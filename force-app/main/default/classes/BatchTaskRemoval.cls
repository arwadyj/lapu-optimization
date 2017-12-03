global class BatchTaskRemoval implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        Integer days = 120;
        //Integer days = [SELECT Id FROM *__mdt ][0].Days__c;
        
        return Database.getQueryLocator('SELECT Id FROM Task WHERE IsCompleted = True AND LastModifiedDate <= :' + System.today().addDays(-days));
    }
    
    global void execute(Database.BatchableContext bc, List<Task> scope) {
        
        System.debug('WHAT IS SCOPE? - ' + scope);
    }
    
    global void finish(Database.BatchableContext bc) {
        
        
    }
}