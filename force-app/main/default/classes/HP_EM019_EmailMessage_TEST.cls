/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-04-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   09-04-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/

@isTest 
public class HP_EM019_EmailMessage_TEST {
    
    @testSetup static void dataSetup(){
        Account acc = (Account)HP_UTIL_SmartFactory.createSObject('Account','HP_Account' ,new Map<String, Object>{
            'HP_XDataExternalId__c' => 100166,
            'Name' => 'UnitTest',
            'OwnerId' => UserInfo.getUserId()
        },null,null, null);
        insert acc;
        
            Contact acontact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{
                'AccountId' => acc.Id,
                'Id_Tiers__c' => 100166,
                'Salutation'=>'MR',
                'lastName' => 'testnicot',
                'firstName' => 'lenfant',
                'email' => 'user@example.com',
                'mobilePhone' => '0756543434',
                'Phone' => '0145454545',
                'No_Voie__c' => '22',
                'MailingStreet' => 'rue des bois',
                'MailingPostalCode' => '92160',
                'Complement_adresse__c' => 'REZID',
                'MailingCity' =>'ANTONY',
                'OwnerId' => UserInfo.getUserId(),
                'HP_IsHappe__c' => true
            }, null, null, null);
            insert acontact;

            Case mailCase = (Case) HP_UTIL_SmartFactory.createSObject('Case', new Map<String, Object> {
                'Description' => 'Description Test',
                'Subject' => 'TEST',
                'HP_Type__c' => 'HP_RappelLeadNonSigne',
                'RecordTypeId' => HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone'),
                'OwnerId' => UserInfo.getUserId(),
                'Status' => 'TO_DO'}, null);
            insert mailCase;

            EmailMessage originMessage = (EmailMessage) HP_UTIL_SmartFactory.createSObject('EmailMessage', new Map<String, Object> {
                'Status' => '3',
                'RelatedToId' => acc.Id,
                'FromAddress' => 'sender@clients.happ-e.fr', 
                'FromName' => 'Dan Perkins', 
                'Subject' =>'This is the Subject!', 
                'HtmlBody' => '<html><body><b>Hello</b></body></html>',
                'ToAddress' => 'emailnotinsalesforce@toexample.com, anotherone@toexample.com',
                'ParentId' => mailCase.Id}, null);
            insert originMessage;
    }
    
    @isTest
	public static void createEmailMessageSF22() {
        Contact contact =[SELECT ID,Id_Tiers__c FROM Contact LIMIT 1];
                
        Integer idClient = Integer.valueOf(contact.Id_Tiers__c);
        Test.startTest();
		HP_EM019_EmailMessage.createEmailMessage('test@test.test', idClient, 'SF22', 'BodySF12');        
        Test.stopTest();
        List<EmailMessage> listEmailMessage = [SELECT Id FROM EmailMessage];
        System.assert(listEmailMessage.size() == 2, 'Echec');
    } 
    
    @isTest
	public static void createEmailMessageSF21() {
        Contact contact =[SELECT ID,Id_Tiers__c FROM Contact LIMIT 1];
                
        Integer idClient = Integer.valueOf(contact.Id_Tiers__c);
        Test.startTest();
		HP_EM019_EmailMessage.createEmailMessage('test@test.test', idClient, 'SF21', 'BodySF12');        
        Test.stopTest();
        List<EmailMessage> listEmailMessage = [SELECT Id FROM EmailMessage];
        System.assert(listEmailMessage.size() == 2, 'Echec');
    } 
    
    @isTest
	public static void createEmailMessageSF20() {
        Contact contact =[SELECT ID,Id_Tiers__c FROM Contact LIMIT 1];
                
        Integer idClient = Integer.valueOf(contact.Id_Tiers__c);
        Test.startTest();
		HP_EM019_EmailMessage.createEmailMessage('test@test.test', idClient, 'SF20', 'BodySF12');        
        Test.stopTest();
        List<EmailMessage> listEmailMessage = [SELECT Id FROM EmailMessage];
        System.assert(listEmailMessage.size() == 2, 'Echec');
    } 
    
    @isTest
	public static void createEmailMessageSF13() {
        Contact contact =[SELECT ID,Id_Tiers__c FROM Contact LIMIT 1];
                
        Integer idClient = Integer.valueOf(contact.Id_Tiers__c);
        Test.startTest();
		HP_EM019_EmailMessage.createEmailMessage('test@test.test', idClient, 'SF13', 'BodySF12');        
        Test.stopTest();
        List<EmailMessage> listEmailMessage = [SELECT Id FROM EmailMessage];
        System.assert(listEmailMessage.size() == 2, 'Echec');
    } 
    
    @isTest
	public static void createEmailMessageSF12() {
        Contact contact =[SELECT ID,Id_Tiers__c FROM Contact LIMIT 1];
                
        Integer idClient = Integer.valueOf(contact.Id_Tiers__c);
        Test.startTest();
		HP_EM019_EmailMessage.createEmailMessage('test@test.test', idClient, 'SF12', 'BodySF12');        
        Test.stopTest();
        List<EmailMessage> listEmailMessage = [SELECT Id FROM EmailMessage];
        System.assert(listEmailMessage.size() == 2, 'Echec');
    } 
    
    @isTest
	public static void createEmailMessageSF52() {
        Contact contact =[SELECT ID,Id_Tiers__c FROM Contact LIMIT 1];
                
        Integer idClient = Integer.valueOf(contact.Id_Tiers__c);
        Test.startTest();

        HP_EM019_EmailMessage.createEmailMessage('test@clients.happ-e.fr', idClient, 'SF52', 'BodySF52');
        
        Test.stopTest();
        List<EmailMessage> listEmailMessage = [SELECT Id FROM EmailMessage];
        System.assert(listEmailMessage.size() == 2, 'Echec');
    } 

    @IsTest
    public static void loadEmailMessagesFromCase() {
        List<Case> casesList = [SELECT Id, Status FROM Case WHERE HP_Type__c = 'HP_RappelLeadNonSigne'];
        Set<Id> casesIdSet = new Set<Id>();
        for(Case acase : casesList) {
            casesIdSet.add(acase.Id);
        }
        Test.startTest();
        Map<Id, List<EmailMessage>> result = HP_EM019_EmailMessage.loadEmailMessagesFromCase(casesIdSet);
        Test.stopTest();

        System.assert(result != null);
        System.assert(result.get(casesList.get(0).Id) != null);
    }

}