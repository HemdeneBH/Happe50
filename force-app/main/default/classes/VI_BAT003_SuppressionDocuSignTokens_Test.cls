/*
*@Auhtor: Clément Bouquin
*@Description: Classe de test de VI_BAT003_SuppressionDocuSignTokens
*@CreatedDate: 07/05/2021
*/

@isTest
public class VI_BAT003_SuppressionDocuSignTokens_Test {

    @testSetup
    static void testSetup1(){
        VI_DocuSignTokens__c DocuSignTokens = new VI_DocuSignTokens__c(Name=string.ValueOf(system.now()), VI_Value__c='Test');
        insert DocuSignTokens;
    }
    
	 @isTest
    static void testBatch(){
		Test.startTest();
        VI_BAT003_SuppressionDocuSignTokens.execute('=today');
        Test.stopTest();
	}
}