global class ScheduledBatchTaskRemoval implements Schedulable {
    
    global static void execute(SchedulableContext sc) {
        
        BatchTaskRemoval batchTaskRemoval = new BatchTaskRemoval();
        Database.executeBatch(batchTaskRemoval);
    }
}