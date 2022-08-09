@isTest
public class SM_BAT08_GenesysDeleteReqScheduleTest {
    static testmethod  void testScheduledJob() {
        Test.startTest();
        SM_BAT08_GenesysDeleteReqSchedule deleteScheduled = new SM_BAT08_GenesysDeleteReqSchedule();
        String CRON = '0 18 * * * ?';
        String jobID = System.schedule('testSM_BAT08_GenesysDeleteReqSchedule', CRON, deleteScheduled);
        Test.stopTest();
    }
}