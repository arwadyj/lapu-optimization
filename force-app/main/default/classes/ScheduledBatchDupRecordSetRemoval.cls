global class ScheduledBatchDupRecordSetRemoval implements Schedulable {
    
    global static void execute(SchedulableContext sc) {
        
        BatchDuplicateRecordSetRemoval batchDuplicateRecordSetRemoval = new BatchDuplicateRecordSetRemoval();
        Database.executeBatch(batchDuplicateRecordSetRemoval);
    }
}