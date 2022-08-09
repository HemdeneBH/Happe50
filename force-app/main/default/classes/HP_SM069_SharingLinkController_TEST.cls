/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 09-21-2021
 * @last modified by  : Hemdene Ben Hammouda
**/
@isTest
public with sharing class HP_SM069_SharingLinkController_TEST {
    @TestSetUp 
	private static void insertTestData() {
        Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{ 
            'Id_Tiers__c' => 195464,
            'Salutation'=>'MR',
            'lastName' => 'testnicot',
            'firstName' => 'lenfant',
            'email' => 'user@example.com',
            'mobilePhone' => '0756543434',
            'Phone' => '0145454545',
            'No_Voie__c' => '22',
            'MailingStreet' => 'rue des bois',
            'MailingPostalCode' => '92160',
            'Complement_adresse__c' => 'REZID',
            'MailingCity' =>'ANTONY',
            'HP_Shared_URL__c' => null
        }, null, null, null);
        insert contact;
    }

    @isTest
    static void getSharingLinkTest(){
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'id.buyapowa.com/oauth/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                   'HP_ByuapowaAPI_Token_MOCK',
                                                   new Map<String, String> {'Content-Type' => 'application/json'}),

            '/api.co-buying.com/api/signups' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(202,
                                                  'HP_ByuapowaAPI_MOCK_OK',
                                                  new Map<String, String> { 'Content-Type' => 'application/json'}
                                                  )
        };
        Contact cont = [SELECT Id,HP_Shared_URL__c, Email, firstName, lastName, Id_tiers__c from Contact limit 1];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_SM069_SharingLinkController.setSharingLink(cont);
        Test.stopTest();
        System.assert(cont.HP_Shared_URL__c != null);
    }
}