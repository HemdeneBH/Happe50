/*
*@Auhtor: Clément	 Bouquin
*@Description: Classe de test de VI_SCH005_ExpirationParcours
*@CreatedDate: 06/07/2021
*/

@isTest
public class VI_SCH005_ExpirationParcours_Test {
    
    public static String CRON_EXP = '0 0 1 * * ? *';
    @testSetup
    static void testSetup1(){
        Case casex=new Case(VI_StatutEnveloppe__c='Sent' );
        insert casex;
        VI_Parcours__c parcours= VI_TestDataFactory.createParcours('CHF', casex.id, 'PURE PLAYERS');
        parcours.VI_Date_envoi_email__c=system.today().adddays(-11);
        insert parcours;
    }
    static testmethod void testScheduledJob() {
        Test.startTest();
        // Schedule the test job
        VI_SCH005_ExpirationParcours schExpirationBatch = new VI_SCH005_ExpirationParcours();
        String jobID = System.schedule('Mise à jour du statut du Parcours à \'Expiré\' ainsi que le status du Case à \'Pré-clôturé\' et son sous-statut à \'Abandon\' Si le status de l enveloppe n est pas \'Signed\' 10 jours après son envoie', CRON_EXP, schExpirationBatch);
        Test.stopTest();
    }
}