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
        
        System.assertEquals(3, taskList.size(), '### There should be three Tasks in taskList but there are only ' + taskList.size() + '; there is something wrong with the TestSetup method ###');
        
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
        
    }
}