global class BatchTaskRemoval implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        Decimal decimalDays = [SELECT Cutoff_Days__c FROM Task_Removal_Setting__mdt][0].Cutoff_Days__c;
        
        Integer days = Integer.valueOf(decimalDays);
        
        Date cutoffDateUnformatted = System.today().addDays(-days);
        
        String cutOffDate = String.valueOf(cutoffDateUnformatted);
        
        return Database.getQueryLocator('SELECT Id FROM Task WHERE IsClosed = true AND Completed_Date__c <= ' + cutoffDate);
    }
    
    global void execute(Database.BatchableContext bc, List<Task> scope) {
        
        delete scope;
    }
    
    global void finish(Database.BatchableContext bc) {
        
        
    }
}