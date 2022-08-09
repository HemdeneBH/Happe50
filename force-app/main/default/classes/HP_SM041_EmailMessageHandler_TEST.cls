/**
 * @File Name          : HP_SM041_EmailMessageHandler_TEST.cls
 * @Description        : 
 * @Author             : Antoine Latour
 * @Group              : 
 * @Last Modified By   : Hemdene Ben Hammouda
 * @Last Modified On   : 01-03-2022
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    29/09/2020   Antoine Latour     Initial Version
**/
@isTest 
public with sharing class HP_SM041_EmailMessageHandler_TEST {
    @testSetup static void dataSetup(){
        Account acc = (Account)HP_UTIL_SmartFactory.createSObject('Account','HP_Account' ,new Map<String, Object>{
            'HP_XDataExternalId__c' => 100166,
            'Name' => 'UnitTest',
            'OwnerId' => UserInfo.getUserId()
        },null,null, null);
        insert acc;

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
            'ToAddress' => 'emailnotinsalesforce@toexample.com',
            'ParentId' => mailCase.Id}, null);
        insert originMessage;

        EmailMessage responseMessage = (EmailMessage) HP_UTIL_SmartFactory.createSObject('EmailMessage', new Map<String, Object> {
            'Status' => '3',
            'RelatedToId' => acc.Id,
            'FromAddress' => 'sender@example.com', 
            'FromName' => 'Dan Perkins', 
            'Subject' =>'This is the Subject!', 
            'HtmlBody' => '<html><body><b>Hello</b></body></html>',
            'ToAddress' => 'emailnotinsalesforce@clients.happ-e.fr;anotherone@toexample.com',
            'ParentId' => mailCase.Id,
            'ReplyToEmailMessageId' => originMessage.Id}, null);
        insert responseMessage;

        // EmailMessage message = (EmailMessage) HP_UTIL_SmartFactory.createSObject('EmailMessage', new Map<String, Object> {
        //     'Status' => '3',
        //     'RelatedToId' => acc.Id,
        //     'FromAddress' => 'sender@clients.happ-e.fr', 
        //     'FromName' => 'Dan Perkins', 
        //     'Subject' =>'This is the Subject!', 
        //     'HtmlBody' => '<html><body><b>Hello</b></body></html>',
        //     'ToAddress' => 'emailnotinsalesforce@toexample.com, anotherone@toexample.com',
        //     'ParentId' => mailCase.Id}, null);
        // insert message;
                
        Contact acontact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{
            'AccountId' => acc.Id,
            'Id_Tiers__c' => 100166,
            'Salutation'=>'MR',
            'lastName' => 'testnicot',
            'firstName' => 'lenfant',
            'email' => 'emailnotinsalesforce@toexample.com',
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
    }
    
    @isTest 
    public static void  populateTechAccount() {
        List<EmailMessage> emailList = [Select Id, HP_TECH_Account_Id__c, RelatedToId, ReplyToEmailMessageId, HP_TECH_Incoming__c, ToAddress From EmailMessage];
        Account accountTest = [Select Id From Account Limit 1];
        
        Test.startTest();
        HP_SM041_EmailMessageHandler.populateTechAccount(emailList);
        Test.stopTest();

        for(EmailMessage item : emailList) {
            System.assert(item.HP_TECH_Account_Id__c == accountTest.Id, 'Echec du remplissage de HP_TECH_Account_Id__c');
        }
    }

    @isTest 
    public static void  updateEmailMessageRelation() {
        EmailMessage emailTest = [Select Id, ActivityId, HP_TECH_Account_Id__c, ReplyToEmailMessageId, HP_TECH_Incoming__c, ToAddress From EmailMessage Limit 1];
        Case mailCase = [select Id from Case limit 1];
        Account acc = [select Id from Account limit 1]; 
        
        emailTest.HP_TECH_Account_Id__c = acc.Id;
        
        List<EmailMessage> emailMessageList = new List<EmailMessage>();
        emailMessageList.add(emailTest);
        List<EmailMessageRelation> emailMessageRelationList = [Select Id From EmailMessageRelation];
        Integer emailRelationListSize = emailMessageRelationList.size();
        Test.startTest();
        HP_SM041_EmailMessageHandler.updateEmailMessageRelation(emailMessageList);
        Test.stopTest();
        emailMessageRelationList = [Select Id From EmailMessageRelation];
        System.assert(emailMessageRelationList.size() == (emailRelationListSize + 1));
    }

    @isTest
    static void createCaseClosedEmailSentTest(){
        List<EmailMessage> emailList = [Select Id, HP_TECH_Account_Id__c, RelatedToId, ReplyToEmailMessageId, HP_TECH_Incoming__c, ToAddress, TextBody, Subject From EmailMessage];
        
        Test.startTest();
        HP_SM041_EmailMessageHandler.populateTechAccount(emailList);
        HP_SM041_EmailMessageHandler.createCaseClosedEmailSent(emailList);
        Test.stopTest();

        List<Case> closedCasesList = [SELECT Id FROM Case WHERE Status = 'CLOSED'];
        System.assertEquals(true,closedCasesList.size()>0,'Tout est OK');
    }
}