/*
*@Auhtor: Paul Ghoussoub
*@Description: Classe de test de VI_SCH002_RelanceCPV
*@CreatedDate: 30/03/2021
*/
@isTest
public class VI_SCH002_RelanceCPV_Test {
    public static String CRON_EXP = '0 0 19 * * ? *';
    @testSetup
    static void testSetup1(){
        Case casex=new Case(VI_StatutEnveloppe__c='Sent' );
        insert casex;
        VI_Parcours__c parcours= VI_TestDataFactory.createParcours('CHF', casex.id, 'PURE PLAYERS');
        parcours.VI_Date_envoi_email__c=system.today().adddays(-1);
        parcours.VI_Tech_relance__c=false;
        insert parcours;
    }
    static testmethod void testScheduledJob() {
        Test.startTest();
        // Schedule the test job
        VI_SCH002_RelanceCPV schRelanceCPV = new VI_SCH002_RelanceCPV();
        String jobID = System.schedule('Demarrer Relance CPV', CRON_EXP, schRelanceCPV);
        Test.stopTest();
    }
}