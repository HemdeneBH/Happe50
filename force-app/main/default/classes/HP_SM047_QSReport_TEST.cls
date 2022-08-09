/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   17-11-2020   Antoine Latour   Initial Version
**/
@isTest
public class HP_SM047_QSReport_TEST {
    
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
            'ToAddress' => 'emailnotinsalesforce@toexample.com, anotherone@toexample.com',
            'ParentId' => mailCase.Id}, null);
        insert originMessage;

        EmailMessage responseMessage = (EmailMessage) HP_UTIL_SmartFactory.createSObject('EmailMessage', new Map<String, Object> {
            'Status' => '3',
            'RelatedToId' => acc.Id,
            'FromAddress' => 'sender@example.com', 
            'FromName' => 'Dan Perkins', 
            'Subject' =>'This is the Subject!', 
            'HtmlBody' => '<html><body><b>Hello</b></body></html>',
            'ToAddress' => 'anotherone@toexample.com',
            'ParentId' => mailCase.Id,
            'ReplyToEmailMessageId' => originMessage.Id}, null);
        insert responseMessage;
                
    }
    
    @isTest 
    public static void  updateQSResponseTime() {

        List<EmailMessage> emailList = [Select Id,HP_TECH_Incoming__c, ReplyToEmailMessageId, CreatedDate, CreatedById, ParentId From EmailMessage];
        Case mailCase = [select Id from Case limit 1];
        Account acc = [select Id from Account limit 1]; 
        
        Test.startTest();
        HP_SM047_QSReport.updateQSResponseTime(emailList); 
        Test.stopTest();

        EmailMessage emailPrecedent = [Select Id, HP_QS24__c, HP_QS48__c From EmailMessage Where ReplyToEmailMessageId=null Limit 1];
        System.assert(emailPrecedent.HP_QS24__c != null && emailPrecedent.HP_QS48__c != null);
    }

}