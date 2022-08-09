@isTest
public class SM_AP95_SkillBasedRouting_Test {
    
	@testSetup 
    static void dataSetup() {
        // create Omnichannel Rule
		Omnichannel_Rule__c omniRule = SM_TestDataFactory.createOmniChannelRule('Case','Origin','Tunnel en ligne','WEB PARTICULIER',null,null);
        Insert omniRule;
        
        omniRule = SM_TestDataFactory.createOmniChannelRule('Donnees_Vente__c','Parcours_Client__c','RES','RESILIATION',null,null);
        Insert omniRule;
        
        // create Account
        Account acc = SM_TestDataFactory.createAccount('Smile_Account');
        Insert acc;

        // create Contact
        Contact testContact = SM_TestDataFactory.createContact('testContact', acc.Id);
        Insert testContact;
        
        // Create Cases
        Case testCase = SM_TestDataFactory.createCase('TEST', acc.Id);
        Insert testCase;
        
        // Create donnée vente
        Donnees_Vente__c dv = SM_TestDataFactory.createDonneeVente(testCase.Id,'Cergy','ABCD','52','Avenue des loups', '95800');
        insert dv;
    }
    
    @isTest
    static void testRoutingCasesToAgents() {
        List<Case> caseList = [SELECT id FROM Case Limit 1];
        List<String> caseIds = new List<String>();
        caseIds.add(caseList[0].Id);

		Test.startTest();
        SM_AP95_SkillBasedRouting.routingCasesToAgents(caseIds);
        Test.stopTest();
    }
}