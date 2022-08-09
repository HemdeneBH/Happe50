/*
*@Auhtor: Paul Ghoussoub
*@Description: Classe de test de VI_SCH006_MAJContrat
*@CreatedDate: 05/04/2022
*/

@isTest
public class VI_SCH006_MAJContrat_Test {
    public static String CRON_EXP = '0 0 1 * * ? *';
    static testmethod void testScheduledJob() {
        Test.startTest();
        // Schedule the test job
        VI_SCH006_MAJContrat schExpirationBatch = new VI_SCH006_MAJContrat();
        String jobID = System.schedule('s', CRON_EXP, schExpirationBatch);
        Test.stopTest();
    }
}