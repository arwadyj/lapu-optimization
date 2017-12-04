global class BatchTaskRemoval implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        Integer days = 120;
        //Integer days = [SELECT Id FROM *__mdt ][0].Days__c;
        
        Date cutoffDateUnformatted = System.today().addDays(-days);
        
        String cutOffDate = String.valueOf(cutoffDateUnformatted);
        
        return Database.getQueryLocator('SELECT Id FROM Task WHERE Status = \'Completed\' AND Completed_Date__c <= ' + cutoffDate);
    }
    
    global void execute(Database.BatchableContext bc, List<Task> scope) {
        
        delete scope;
    }
    
    global void finish(Database.BatchableContext bc) {
        
        
    }
}