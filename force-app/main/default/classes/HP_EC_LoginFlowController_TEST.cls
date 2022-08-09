/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 04-12-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
@isTest
public with sharing class HP_EC_LoginFlowController_TEST {
    @TestSetup
    static void dataSetup(){
        Account myAccount = new Account(name = 'HP Portal Account');
        insert myAccount;

        Contact myContact = new Contact(LastName = 'Portal Account', AccountId = myAccount.Id, ID_Tiers__c = 100166);
        insert myContact;

        HP_Community_User__c myUser = (HP_Community_User__c) HP_UTIL_SmartFactory.createSObject('HP_Community_User__c', new Map<String, Object> {
            'Salt__c' => '123SLT',
            'Crypted_Password__c' => 'ea8c75d4cac9d69404a47a4b05333bbe09e42796',
            'Username__c' => 'myEmail@email.com'
            }, null);
        insert myUser;

        HP_Community_Settings__c settings = HP_Community_Settings__c.getOrgDefaults();
        settings.Issuer__c = '3MVG904d7VkkD2aN_5BfyZl0Kz9sV1ViUEg3QqeC1ASJz783.oct1fHm2VexJIXRvqgixkwgWnFY6nBhhehxR';
        settings.Crypto_Type__c = 'SHA1';
        settings.Certificate__c = 'HappeJWTSignEC';
        settings.Community_Name__c = 'happeportal';
        settings.Community_URL__c = 'https://devhpbh2-engie-dgpfr.cs189.force.com';
        upsert settings HP_Community_Settings__c.Id;
    }

    @isTest
    public static void testAuthantificationOk(){
        Map<String,Object> myResultParams = new Map<String,Object>();
        Test.startTest();
        myResultParams = HP_EC_LoginFlowController.handleConnection('myEmail@email.com', 'P@ssw0rd');
        Test.stopTest();
        System.assert(myResultParams.get('myPageUrl') != null, 'connexion OK');    
    }

    @isTest
    public static void testAuthantificationKo(){
        Map<String,Object> myResultParams = new Map<String,Object>();
        Test.startTest();
        myResultParams = HP_EC_LoginFlowController.handleConnection('myEmail', 'Pssw0rd');
        Test.stopTest();
        System.assert(myResultParams.get('myPageUrl') == null, 'problème de connexion');
    }
}