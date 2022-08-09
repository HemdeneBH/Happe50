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
public with sharing class HP_HDL004_EmailMessage_TEST {
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
            Case c1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_PrestationDistributeur', new Map<String, Object> {
                'Status' => 'NEW_CASE',
                'Priority' => 'High',
                'OwnerId' => UserInfo.getUserId(),
                'HP_DateReponseEmailConseiller__c' => DateTime.now(),
                'ContactId' => acontact.Id,
                'HP_TreatmentDate__c' => Date.today().addDays(-2),
                'Origin' => 'Contact distributeur'
                }, null,null,null);
            insert c1;

        Case mailCase = (Case) HP_UTIL_SmartFactory.createSObject('Case', new Map<String, Object> {
		'Description' => 'Description Test',
		'Origin' => 'TEST',
		'Reason' => 'TEST',
		'Subject' => 'TEST',
		'HP_Type__c' => 'HP_Chat',
		'RecordTypeId' => HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Mail'),
        'BusinessHoursId' => [select Id from BusinessHours where Name='HP'].Id,
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
    public static void inserEmailMessageTest() {
        Account acc = [select Id from Account limit 1]; 
        Contact cont = [select Id from Contact limit 1]; 
         Case cas = [select Id from Case limit 1 ];
        EmailMessage emailMessage = new EmailMessage();
        emailMessage.status = '3';
        emailMessage.relatedToId = acc.Id; 

        emailMessage.fromAddress = 'sender@clients.happ-e.fr'; 

        emailMessage.fromName = 'Dan Perkins'; 
        emailMessage.subject = 'This is the Subject!'; 
        emailMessage.htmlBody = '<html><body><b>Hello</b></body></html>';
        emailMessage.ParentId = cas.Id;
        String[] toIds = new String[]{UserInfo.getUserId()}; 
        emailMessage.toIds = toIds;
        
        emailMessage.toAddress = 'emailnotinsalesforce@toexample.com, anotherone@toexample.com';

        Test.startTest();
        insert emailMessage; 
        Test.stopTest();
    }

    @isTest
    public static void testReporting() {
        Case mailCase = [select Id from Case limit 1];
        Account acc = [select Id from Account limit 1]; 
        Contact cont = [select Id from Contact limit 1]; 
        EmailMessage message = [select Id from EmailMessage limit 1];
        
        EmailMessage emailMessage = new EmailMessage();
        emailMessage.status = '3';
        emailMessage.relatedToId = acc.Id; 

        emailMessage.fromAddress = 'response@exemple.com'; 

        emailMessage.fromName = 'Conseiller'; 
        emailMessage.subject = 'Re: This is the Subject!'; 
        emailMessage.htmlBody = '<html><body><b>Hello</b></body></html>';
        String[] toIds = new String[]{UserInfo.getUserId()}; 
        emailMessage.toIds = toIds;
        emailMessage.ParentId = mailCase.Id;

        emailMessage.toAddress = 'emailnotinsalesforce@clients.happ-e.fr, anotherone@toexample.com';

		emailMessage.ReplyToEmailMessageId = message.Id;
        Test.startTest();
        insert emailMessage; 
        Test.stopTest();
    }
}