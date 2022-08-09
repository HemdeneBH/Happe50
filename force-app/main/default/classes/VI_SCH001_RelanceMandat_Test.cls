/*
*@Auhtor: Paul Ghoussoub
*@Description: Classe de test de VI_SCH001_RelanceMandat
*@CreatedDate: 16/03/2021
*/
@isTest
public class VI_SCH001_RelanceMandat_Test {
    public static String CRON_EXP = '0 0 19 * * ? *';
    @testSetup
    static void testSetup1(){
        VI_Parcours__c parcours= VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
        parcours.VI_URL_Mandat__c='www.urlmandat.com';
        parcours.VI_IDReferenceClient__c='1';
        parcours.VI_ID_Mandat__c='1';
        parcours.VI_EmailEnvoye__c=true;
        parcours.VI_idCompteClient__c='1';
        parcours.VI_Tech_relance__c=false;
        insert parcours;
    }
    static testmethod void testScheduledJob() {
        Test.startTest();
        // Schedule the test job
        VI_SCH001_RelanceMandat schRelanceMandat = new VI_SCH001_RelanceMandat();
        String jobID = System.schedule('Demarrer Relance Mandat', CRON_EXP, schRelanceMandat);
        Test.stopTest();
    }
}