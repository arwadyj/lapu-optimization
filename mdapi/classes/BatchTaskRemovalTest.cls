@isTest
private class BatchTaskRemovalTest {

    @TestSetup
    static void setup() {
        
        //Insert an Account
        Account account = new Account();
        
        account.Name = 'Test Account';
        
        insert account;
        
        //Insert a completed Task with an old completed date
        Task oldComplete = new Task();
        
        oldComplete.WhatId = account.Id;
        oldComplete.Status = 'Completed';
        
        insert oldComplete;
        
        //---Make the Task have an old Completed Date
        oldComplete.Completed_Date__c = System.today().addDays(-500);
        
        update oldComplete;
        
        //---Verify that the Workflow Rule did not fire
        System.assertNotEquals(System.today(), oldComplete.Completed_Date__c, 
                               '### A Workflow Rule has fired on the previous update dml statement which set the Completed Date field to System.today(); the logic is broken ###');
        
        //Insert a completed Task with a new completed date
        Task newComplete = new Task();
        
        newComplete.WhatId = account.Id;
        newComplete.Status = 'Completed';
        
        insert newComplete;
        
        //---Make the Task have a new Completed Date
        newComplete.Completed_Date__c = System.today().addDays(500);
        
        update newComplete;
        
        //---Verify that the Workflow Rule did not fire
        System.assertNotEquals(System.today(), newComplete.Completed_Date__c, 
                               '### A Workflow Rule has fired on the previous update dml statement which set the Completed Date field to System.today(); the logic is broken ###');
        
        //Insert an incomplete Task
        Task incomplete = new Task();
        
        incomplete.WhatId = account.Id;
        
        insert incomplete;
        
        //---Verify that the Workflow Rule did not fire
        System.assertNotEquals(System.today(), newComplete.Completed_Date__c, 
                               '### A Workflow Rule has fired on the previous update dml statement which set the Completed Date field to System.today(); the logic is broken ###');
    }
    
    @isTest
    static void batchApexTaskLogic() {
        
        List<Task> taskList = 
            [ 
            	SELECT Completed_Date__c, Status 
            	  FROM Task
            ];
        
        System.assertEquals(3, taskList.size(), '### There should be three Tasks in taskList but there are ' + taskList.size() + '; there is something wrong with the TestSetup method ###');
        
        System.debug('### taskList = ' + taskList + ' ###');
        
        BatchTaskRemoval batchTaskRemoval = new BatchTaskRemoval();
        
        Test.startTest();
        
        Database.executeBatch(batchTaskRemoval);
        
        Test.stopTest();
        
        taskList = 
            [ 
            	SELECT Completed_Date__c, Status 
            	  FROM Task
            ];
        
        System.assertEquals(2, taskList.size(), '### There should be two Tasks remaining in taskList but there are ' + taskList.size() + ' instead; ###');
        
        Integer incompleteCounter = 0;
        
        for(Task each : taskList) {
            
            if(each.Status == 'Completed') {
                
                System.assertNotEquals(System.today().addDays(-500), each.Completed_Date__c, 
                                       '### The Batch Apex logic failed to remove the old, completed Task ###');
                
                System.assertEquals(System.today().addDays(500), each.Completed_Date__c, 
                                    '### There should not be a completed Task with a Completed Date of today or a date in the past; Just found one with Completed Date: ' + each.Completed_Date__c + ' ###');
            }
            
            if(each.Status != 'Completed')
                incompleteCounter ++;
        }
        
        System.assertEquals(1, incompleteCounter, '### There should be exactly one incomplete Task; Instead there are: ' + incompleteCounter + ' Tasks ###');
    }
    
    @isTest
    static void batchApexTaskLogicBulk() {
        
        //Create a unique, bulk set of Tasks
        
        //---Grab the existing Account
        Account account = [SELECT Id FROM Account][0];
        
        //---Delete the existing Tasks from setup
        List<Task> tasksToDelete = new List<Task>();
        tasksToDelete = [SELECT Id FROM Task WHERE WhatId = :account.Id];
        delete tasksToDelete;
        
        //--Create 200 Tasks that meet the deletion criteria
        List<Task> tasksToInsert = new List<Task>();
        for(Integer i=0; i<200; i++) {
            
            Task task = new Task();
            
            task.WhatId = account.Id;
            task.Status = 'Completed';
            
            tasksToInsert.add(task);
        }
        insert tasksToInsert;
        
        //---Make the Tasks old; could not do this above because the "Set Completed Date on Task Completed" Task Workflow Rule fired
        for(Task each :tasksToInsert)
            each.Completed_Date__c = System.today().addDays(-500);
        
        update tasksToInsert;
        
        //Initiate the Batch Apex Operation
        Test.startTest();
        
        BatchTaskRemoval batchTaskRemoval = new BatchTaskRemoval();
        
        Database.executeBatch(batchTaskRemoval);
        
        Test.stopTest();
        
        //Query the database for changes
        List<Task> remainingTasks = new List<Task>();
        remainingTasks = [SELECT Id FROM Task];
        
        //Assert that there are no remaining tasks
        System.assertEquals(0, remainingTasks.size(), '### There should be no remaining tasks after the batch operation; instead there are ' + remainingTasks.size());
    }
}