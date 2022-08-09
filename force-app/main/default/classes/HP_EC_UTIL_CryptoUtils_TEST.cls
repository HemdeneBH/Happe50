/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-13-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
@isTest
public with sharing class HP_EC_UTIL_CryptoUtils_TEST {

    @TestSetup
    static void dataSetup(){
        Account myAccount = new Account(Name='Portal Account');
        insert myAccount;
        Contact myContact = new Contact(FirstName='Test ', LastName = 'Portal Account', Email = 'email@test.com', Id_Tiers__c = 123456, AccountId = myAccount.Id);
        insert myContact;
    }

    @isTest
    public static void getSha256_TEST() {
        HP_EC_UTIL_CryptoUtils.getSha256('test text');
    }

    @isTest
    public static void generateSogenactifParamsTest(){
        Id p = [SELECT id FROM profile where name = 'HP_Community_User'].id;
        Contact con = [SELECT id FROM Contact WHERE lastname = 'Portal Account' LIMIT 1];
        User portalUser = new User(alias = 'hpPortal', email = 'portaluser@noemail.com', EmailEncodingKey = 'UTF-8', lastname = 'Portal', 
        LanguageLocaleKey = 'en_US', LocaleSidKey ='en_US', ProfileId = p, country = 'United States', IsActive = true, contactId = con.Id, TimeZoneSidKey = 'Europe/Paris', UserName = 'portaluser@noemail.com');
        insert portalUser;
        Id pset = [SELECT id FROM PermissionSet where name = 'HP_EC_permissions' LIMIT 1].id;
        PermissionSetAssignment psa =  new PermissionSetAssignment(PermissionSetId = pset, AssigneeId = portalUser.id);
        insert psa;
        system.runAs(portalUser) {
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'sogenactif.com' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_SOGENACTIF_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'})};
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
            Map<String,Object> resultMap = HP_EC_UTIL_CryptoUtils.generateSogenactifParams('2500', con.Id, '123456', 'CB');
            Test.stopTest();
            System.assert(resultMap!=null, 'redirection OK');
        }
    }
}