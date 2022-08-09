/*
*@Auhtor: Clément Bouquin
*@Description: Classe de test de VI_SCH003_SuppressionDocuSignTokens_Test
*@CreatedDate: 07/05/2021
*/

@isTest
public class VI_SCH003_SuppressionDocuSignTokens_Test {

    public static String CRON_EXP = '0 0 1 * * ?'; // Everyday at 1AM
    @testSetup
    static void testSetup1(){
        VI_DocuSignTokens__c DocuSignTokens = new VI_DocuSignTokens__c(Name=string.ValueOf(system.now()), VI_Value__c='Test');
		insert DocuSignTokens;
    }
    static testmethod void testScheduledJob() {
        Test.startTest();
        // Schedule the test job
        VI_SCH003_SuppressionDocuSignTokens SuppressionDocuSignTokens = new VI_SCH003_SuppressionDocuSignTokens();
        String jobID = System.schedule('Suppression des DocuSignTokens agés de plus de 30 jours', CRON_EXP, SuppressionDocuSignTokens);
        Test.stopTest();
    }

    
}