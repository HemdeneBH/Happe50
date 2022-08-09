/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 05-09-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
@isTest 
public with sharing class HP_BAT035_ArchiveResetPasswordKey_TEST {
    @TestSetup
    static void makeData(){
        HP_Community_User__c myCommunityUser = new HP_Community_User__c(Reset_Password_Key__c = 'jkaehfkjaepfkjaemf',
                                                                        Reset_Password_Time__c = System.now().addHours(-6),
                                                                        Username__c = 'myEmail@email.com');
        insert myCommunityUser;
    }

    @isTest
    public static void executeTest(){
        Test.startTest();
        HP_BAT035_ArchiveResetPasswordKey.passwordLimit = 4;
        HP_BAT035_ArchiveResetPasswordKey.execute();
        Test.stopTest();
        HP_Community_User__c commUser = [SELECT Id, Reset_Password_Key__c FROM HP_Community_User__c LIMIT 1];
        System.assert(commUser.Reset_Password_Key__c == null, 'Reset Password effacée');
    }

    @isTest 
    public static void testSchedule(){
        Test.startTest();
        final String jobName = 'HP_BAT035_ArchiveResetPasswordKey'+System.Math.random()*1000;
        final String cronExp = '0 30 9 ? * * *';
        HP_BAT035_ArchiveResetPasswordKey.launchNewScheduler(cronExp,jobName);
        Test.stopTest();
    }
}