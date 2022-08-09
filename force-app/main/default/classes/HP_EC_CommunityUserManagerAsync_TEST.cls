/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 04-25-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
@isTest
public with sharing class HP_EC_CommunityUserManagerAsync_TEST {
    @TestSetup
    static void dataSetup(){
        Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{
            'Id_Tiers__c' => 100166,
            'Salutation'=>'MR',
            'lastName' => 'testnicot',
            'firstName' => 'lenfant',
            'email' => 'email@email.com',
            'mobilePhone' => '0756543434',
            'Phone' => '0145454545',
            'No_Voie__c' => '22',
            'MailingStreet' => 'rue des bois',
            'MailingPostalCode' => '92160',
            'Complement_adresse__c' => 'REZID',
            'MailingCity' =>'ANTONY'
        }, null, null, null);
        insert contact;

        HP_Community_Settings__c settings = HP_Community_Settings__c.getOrgDefaults();
        settings.Issuer__c = '3MVG904d7VkkD2aN_5BfyZl0Kz9sV1ViUEg3QqeC1ASJz783.oct1fHm2VexJIXRvqgixkwgWnFY6nBhhehxR';
        settings.Crypto_Type__c = 'SHA1';
        settings.Certificate__c = 'HappeJWTSignEC';
        settings.Community_Name__c = 'happeportal';
        settings.Community_URL__c = 'https://devhpbh2-engie-dgpfr.cs189.force.com';
        upsert settings HP_Community_Settings__c.Id;
    }

    @isTest
    public static void executeTestOk(){
        Contact myContact = [SELECT Id, Id_Tiers__c FROM Contact LIMIT 1];
        Test.startTest();        
        System.enqueueJob(new HP_EC_CommunityUserManagerAsync(myContact.Id_Tiers__c));
        System.enqueueJob(new HP_EC_CommunityUserLoginManagerAsync(myContact.Id));
        Test.stopTest();

        List<HP_Community_User__c> myCommunityUserList = [SELECT Id FROM HP_Community_User__c];
        system.assert(myCommunityUserList.size()>0, 'Test Ok');
    }
}