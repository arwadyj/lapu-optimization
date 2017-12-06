@isTest
private class ScheduledBatchDupRecordSetRemovalTest {

    @isTest
    static void scheduledTest() {
        
        ScheduledBatchDupRecordSetRemoval scheduled = new ScheduledBatchDupRecordSetRemoval();
        String cron = '0 0 0 * * ?';
        System.schedule('Remove Duplicate Record Sets with One Duplicate Record Item', cron, scheduled);
    }
}