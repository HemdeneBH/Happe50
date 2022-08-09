/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 05-06-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
@isTest
public with sharing class HP_BAT034_ArchiveActivationKey_TEST {
    @TestSetup
    static void makeData(){
        HP_Community_User__c myCommunityUser = new HP_Community_User__c(Activation_Key__c = 'jkaehfkjaepfkjaemf',
                                                                        Activation_Date__c = Date.today().addDays(-5),
                                                                        Username__c = 'myEmail@email.com');
        insert myCommunityUser;
    }

    @isTest
    public static void executeTest(){
        Test.startTest();
        HP_BAT034_ArchiveActivationKey.activationLimit = 4;
        HP_BAT034_ArchiveActivationKey.execute();
        Test.stopTest();
        HP_Community_User__c commUser = [SELECT Id, Activation_Key__c FROM HP_Community_User__c LIMIT 1];
        System.assert(commUser.Activation_Key__c == null, 'Activation effacée');
    }

    @isTest 
    public static void testSchedule(){
        Test.startTest();
        final String jobName = 'HP_BAT034_ArchiveActivationKey'+System.Math.random()*1000;
        final String cronExp = '0 0 13 ? * * *';
        HP_BAT034_ArchiveActivationKey.launchNewScheduler(cronExp,jobName);
        Test.stopTest();
    }
}