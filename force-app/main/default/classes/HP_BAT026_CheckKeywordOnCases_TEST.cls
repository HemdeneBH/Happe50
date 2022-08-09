/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 02-01-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
@isTest
public with sharing class HP_BAT026_CheckKeywordOnCases_TEST {
    
    @testSetup
    static void setup() {

        insert new ByPassSettings__c(
            SetupOwnerId = UserInfo.getUserId(),
            ValidationRule__c 	= true,
            ProcessBuilder__c 	= true,
            AccountTrigger__c 	= true,
            ContactTrigger__c 	= true,
            CaseTrigger__c      = true
        );
    
        List < sObject > ls = Test.loadData(Case.sObjectType, 'HP_TestData_Cases'); 
    }

    @isTest static void execute() {
        Test.startTest();
        HP_BAT026_CheckBlacklistKeywordOnCases.execute();
        Test.stopTest();
    }

    @isTest static void HP_BAT026_CheckKeywordOnCases_TEST_Schedule() {
        Test.startTest();
        final String jobName = 'HP_BAT026_CheckBlacklistKeywordOnCases'+System.Math.random()*1000;
        final String cronExp = '0 0 22 ? * * *';
        HP_BAT026_CheckBlacklistKeywordOnCases.launchNewScheduler(cronExp,jobName);
        Test.stopTest();
    }
}