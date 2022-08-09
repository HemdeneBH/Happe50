/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 01-31-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
@isTest
public with sharing class HP_BAT030_CheckKeywordChat_TEST {
    @testSetup
    static void setup() {

        List < sObject > ls = Test.loadData(LiveChatVisitor.sObjectType, 'HP_TestData_LiveChatVisitor'); 
        LiveChatVisitor chatVisitor = (LiveChatVisitor)ls[0];

        LiveChatTranscript chatTranscript = (LiveChatTranscript) HP_UTIL_SmartFactory.createSObject('LiveChatTranscript', new Map<String, Object> {
            'Body' =>'testing con word',
            'Status' =>'Completed',
            'LiveChatVisitorId' => chatVisitor.ID
		}, null);
        insert chatTranscript;
    }

    @isTest static void execute() {
        Test.startTest();
        HP_BAT030_CheckBlacklistKeywordChat.execute();
        Test.stopTest();
    }

    @isTest static void HP_BAT030_CheckKeywordChat_TEST_Schedule() {
        Test.startTest();
        final String jobName = 'HP_BAT030_CheckBlacklistKeywordChat'+System.Math.random()*1000;
        final String cronExp = '0 0 22 ? * * *';
        HP_BAT030_CheckBlacklistKeywordChat.launchNewScheduler(cronExp,jobName);
        Test.stopTest();
    }
}