@isTest
private class ScheduledBatchTaskRemovalTest {

    @isTest
    static void scheduledTest() {
        
        ScheduledBatchTaskRemoval scheduled = new ScheduledBatchTaskRemoval();
        String cron = '0 0 0 * * ?';
        System.schedule('Remove Old Completed Tasks', cron, scheduled);
    }
}