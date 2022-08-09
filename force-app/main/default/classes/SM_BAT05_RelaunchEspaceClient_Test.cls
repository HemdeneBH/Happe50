/** 
* @author            : Ahlam BENABBOU
* @group             : SMILE FT4
* @description       : SM_BAT05_RelaunchEspaceClient batch Test class 
**/
@IsTest
public class SM_BAT05_RelaunchEspaceClient_Test {
	//Create User
	public static User testUserBAT05 = SM_TestDataFactory.createUser('BAT05', 'userBAT05@email.com', 'userBAT05lastName', 'userBAT05@username.com', 'SM_Utilisateur admin métier');

    @testSetup 
    static void dataSetup() {
		//create Account
        Account testAcc=SM_TestDataFactory.createAccount('SmileAccount');
        insert testAcc;
        //create Contact
        Contact testContact = SM_TestDataFactory.createContact('SmileContact',testAcc.Id);
        Id recordTypeId =Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Smile').getRecordTypeId(); 
        testContact.RecordTypeId =recordTypeId; 
        testContact.FirstName='SmileEC';
        testContact.LastName='SmileEC';
        testContact.ChoixEmailEspaceClient__c='smile@ec.fr';
        testContact.Tech_StatusCreationEspaceClient__c='Scheduled';
        testContact.ID_Tiers__c=23418;
        testContact.Phone='+33606758463';
        testContact.Identifiant_Buisness_Partener__c='206359257';
        Contact testContact2 = SM_TestDataFactory.createContact('SmileContact',testAcc.Id);
        testContact2.RecordTypeId =recordTypeId;
        testContact2.FirstName='SmilewithoutEC';
        testContact2.LastName='SmilewithoutEC';
        testContact2.Phone='+33678754638';
        testContact2.ChoixEmailEspaceClient__c='smile1@ec.fr';
        testContact2.Tech_StatusCreationEspaceClient__c='KO';
        testContact2.ID_Tiers__c=23410;
        testContact2.Identifiant_Buisness_Partener__c='202017191';
        Contact testContact3 = SM_TestDataFactory.createContact('SmileContact',testAcc.Id);
        testContact3.RecordTypeId =recordTypeId;
        testContact3.FirstName='SmileEC1';
        testContact3.LastName='SmileEC1';
        testContact3.ChoixEmailEspaceClient__c='smile@ec1.fr';
        testContact3.Tech_StatusCreationEspaceClient__c='Scheduled';
        testContact3.ID_Tiers__c=23413;
        testContact3.Phone='+33606758463';
        testContact3.Identifiant_Buisness_Partener__c='202017180';
        List<Contact> ListContactsToInsert =new List<Contact>(); 
        ListContactsToInsert.add(testContact);
        ListContactsToInsert.add(testContact2);
        ListContactsToInsert.add(testContact3);
        insert ListContactsToInsert;
    }
    @isTest 
    static void testBatchMethod() {
        map<string, object> inputContact = new map<string, object>();
        System.runAs(testUserBAT05){ 
		Test.startTest();
        Id batchJobId = database.executebatch(new SM_BAT05_RelaunchEspaceClient(),5);
        Test.stopTest();
        system.debug('#### batchJobId '+batchJobId);
        List<Contact> contactList=new List<Contact>();
        contactList =[SELECT ID_Tiers__c , LastName, FirstName , Phone, Identifiant_Buisness_Partener__c,ChoixEmailEspaceClient__c,Tech_StatusCreationEspaceClient__c FROM Contact where Identifiant_Buisness_Partener__c IN ('206359257','202017191')];
        system.debug('### contactList: '+contactList);
        for(Contact con : contactList){
            // Test the 1st Case : EC created with success + Update method
            if(con.Identifiant_Buisness_Partener__c=='206359257'){
                System.assertEquals(con.ChoixEmailEspaceClient__c,null);
                System.assertEquals(con.Tech_StatusCreationEspaceClient__c,null);
                // Test the 2nd Case : EC not created
            }else if(con.Identifiant_Buisness_Partener__c=='202017191'){
                System.assertEquals(con.ChoixEmailEspaceClient__c,'smile1@ec.fr');
                System.assertEquals(con.Tech_StatusCreationEspaceClient__c,'KO');
            }
        }
        }
    }
}