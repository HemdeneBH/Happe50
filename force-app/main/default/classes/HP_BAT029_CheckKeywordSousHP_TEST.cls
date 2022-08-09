/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 01-31-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
@isTest
public with sharing class HP_BAT029_CheckKeywordSousHP_TEST {

    @testSetup
    static void setup() {
    
        HP_Souscription__c enrolment = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
            'HP_NumberPCE__c' =>'33333333333333',
            'HP_Statut__c' =>'SAVE_1',
            'HP_Revision_Document__c' => 'testing con word',
            'commentaire__c' => 'testing con word'
		}, null);
        insert enrolment;
    }

    @isTest static void execute() {
        Test.startTest();
        HP_BAT029_CheckBlacklistKeywordSousHP.execute();
        Test.stopTest();

        System.assertEquals(1, [select count() from HP_Souscription__c where HP_NumberPCE__c = '33333333333333' AND HP_Presence_mot_interdit__c = 'Mot interdit trouvé']);

    }

    @isTest static void HP_BAT029_CheckKeywordSousHP_TEST_Schedule() {
        Test.startTest();
        final String jobName = 'HP_BAT029_CheckBlacklistKeywordSousHP'+System.Math.random()*1000;
        final String cronExp = '0 0 22 ? * * *';
        HP_BAT029_CheckBlacklistKeywordSousHP.launchNewScheduler(cronExp,jobName);
        Test.stopTest();
    }
}