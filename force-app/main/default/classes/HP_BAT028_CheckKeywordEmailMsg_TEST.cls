/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 01-31-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
@isTest
public with sharing class HP_BAT028_CheckKeywordEmailMsg_TEST {
    @testSetup
    static void setup() {
        
        EmailMessage originMessage = (EmailMessage) HP_UTIL_SmartFactory.createSObject('EmailMessage', new Map<String, Object> {
            'Status' => '3',
            'FromAddress' => 'sender@clients.happ-e.fr', 
            'FromName' => 'Dan Perkins', 
            'Subject' =>'This is the Subject con !', 
            'TextBody' => 'Hello',
            'HtmlBody' => '<html><body><b>Hello</b></body></html>',
            'ToAddress' => 'emailnotinsalesforce@toexample.com, anotherone@toexample.com'}, null);
        insert originMessage;
    }

    
    @isTest static void execute() {
        Test.startTest();
        HP_BAT028_CheckBlacklistKeywordEmailMsg.execute();
        Test.stopTest();
    }

    @isTest static void HP_BAT028_CheckKeywordEmailMsg_TEST_Schedule() {
        Test.startTest();
        final String jobName = 'HP_BAT028_CheckBlacklistKeywordEmailMsg'+System.Math.random()*1000;
        final String cronExp = '0 0 22 ? * * *';
        HP_BAT028_CheckBlacklistKeywordEmailMsg.launchNewScheduler(cronExp,jobName);
        Test.stopTest();
    }
}