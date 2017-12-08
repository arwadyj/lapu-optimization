global class BatchDuplicateRecordSetRemoval implements Database.Batchable<sObject> {

    global static Database.QueryLocator start(Database.BatchableContext bc) {
        
        return Database.getQueryLocator('SELECT Id, (select id from DuplicateRecordItems limit 2) FROM DuplicateRecordSet');
    }
    
    global static void execute(Database.BatchableContext bc, List<DuplicateRecordSet> scope) {
        
        List<DuplicateRecordSet> duplicateRecordSetsToDelete = new List<DuplicateRecordSet>();
        
        for(DuplicateRecordSet each :scope) {
            
            if(each.DuplicateRecordItems.size() == 1)
                duplicateRecordSetsToDelete.add(each);
        }
        
        if(duplicateRecordSetsToDelete.size() > 0)
        	delete duplicateRecordSetsToDelete;
    }
    
    global static void finish(Database.BatchableContext bc) {
        
    }
}
