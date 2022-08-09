/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 01-31-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
@isTest
public with sharing class HP_BAT027_CheckKeywordOnTasks_TEST {

    @testSetup
    static void setup() {
        
        Task tsk = (Task)HP_UTIL_SmartFactory.createSObject('Task', null, new Map<String, Object> {
            'Description' => 'testing con word',
            'RecordTypeId' => HP_UTIL_RecordType.getRecordTypeId('Task', 'HP_Task')		
        }, null, null,null);
        insert tsk;
    }

    @isTest static void execute() {
        Test.startTest();
        HP_BAT027_CheckBlacklistKeywordOnTasks.execute();
        Test.stopTest();
    }

    @isTest static void HP_BAT027_CheckKeywordOnTasks_TEST_Schedule() {
        Test.startTest();
        final String jobName = 'HP_BAT027_CheckBlacklistKeywordOnTasks'+System.Math.random()*1000;
        final String cronExp = '0 0 22 ? * * *';
        HP_BAT027_CheckBlacklistKeywordOnTasks.launchNewScheduler(cronExp,jobName);
        Test.stopTest();
    }
}