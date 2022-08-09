/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   17-11-2020   Antoine Latour   Initial Version
**/
@isTest 
global  class HP_BAT014_QSReport_TEST {
  
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
            'ToAddress' => 'emailnotinsalesforce@clients.happ-e.fr, anotherone@toexample.com',
            'ParentId' => mailCase.Id,
            'ReplyToEmailMessageId' => originMessage.Id}, null);
        insert responseMessage;
    }

     @isTest static void launch_TEST(){
        Test.startTest();
        HP_BAT014_QSReport.execute(Date.newInstance(2021, 1, 19));
        Test.stopTest();   
    }
    
    @isTest static void launch2_TEST(){
        
        final String jobName = 'HP_BAT014_QSReport';
        final String cronExp = '0 0 23 ? * * *';
        Test.startTest();
        HP_BAT014_QSReport.launchNewScheduler(cronExp,jobName);
        Test.stopTest();   
    }

}