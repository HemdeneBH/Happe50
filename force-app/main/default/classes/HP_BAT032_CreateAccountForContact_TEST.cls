/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 01-25-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
@isTest
public with sharing class HP_BAT032_CreateAccountForContact_TEST {
    
    @testSetup static void dataSetup() {

        insert new ByPassSettings__c(
            SetupOwnerId = UserInfo.getUserId(),
            ValidationRule__c 	= true,
            ProcessBuilder__c 	= true,
            AccountTrigger__c 	= true,
            ContactTrigger__c 	= true
        );
    
        Contact contact1 = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', null, new Map<String, Object> {
            'RecordTypeId' => HP_UTIL_RecordType.getRecordTypeId('Contact','HP_Contact'),
            'LastName' => 'ContactTest',
            'FirstName' => 'TestContact',
            'Email' => 'ContactTest.TestContact@gmail.com',
            'HP_Numero_etranger__c' => '1111111111111111',
            'Id_Tiers__c' => 131313
        }, null, null,null);
        insert contact1;

        Contact contact2 = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', null, new Map<String, Object> {
            'RecordTypeId' => HP_UTIL_RecordType.getRecordTypeId('Contact','HP_Contact'),
            'LastName' => 'TestContact',
            'FirstName' => 'ContactTest',
            'Email' => 'TestContact.ContactTest@gmail.com',
            'HP_Numero_etranger__c' => '1111111111111111',
            'Id_Tiers__c' => null
        }, null, null,null);
        insert contact2;
    }

    @isTest static void execute() {
        Test.startTest();
        HP_BAT032_CreateAccountForContact.execute();
        Test.stopTest();

        System.assertEquals(1, [SELECT count() FROM Contact WHERE HP_Numero_etranger__c = '1111111111111111' AND AccountId != null]);

    }

    @isTest static void HP_BAT032_CreateAccountForContact_TEST_Schedule() {
        Test.startTest();
        final String jobName = 'HP_BAT032_CreateAccountForContact'+System.Math.random()*1000;
        final String cronExp = '0 0 4 ? * * *';
        HP_BAT032_CreateAccountForContact.launchNewScheduler(cronExp,jobName);
        Test.stopTest();
    }
}