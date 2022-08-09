/**
 * @description       : 
 * @author            : Slimene Belhaj Ali
 * @group             : 
 * @last modified on  : 04-08-2021
 * @last modified by  : Slimene Belhaj Ali
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   03-30-2021   Slimene Belhaj Ali   Initial Version
**/
@isTest
public with sharing class HP_SM058_EditNameClient_TEST {

    @testSetup static void dataSetup(){
        System.runAs(HP_UTIL_SmartFactory.insertUserHP()){
            Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{

                'Id_Tiers__c' => 100166,

                'HP_IsHappe__c' => true,
                'Salutation'=>'MR',
                'lastName' => 'testnicot',
                'firstName' => 'lenfant',
                'Email'=>'test@email.com',
                'mobilePhone' => '0756543434',
                'Phone' => '0145454545',
                'No_Voie__c' => '22',
                'MailingStreet' => 'rue des bois',
                'MailingPostalCode' => '92160',
                'Complement_adresse__c' => 'REZID',
                'MailingCity' =>'ANTONY'
            },null, null, null);
            insert contact;
        }
    }
    @isTest
    public static void editName_TEST() {
        String expectedValue = HP_StaticResourceTestUtils_TEST.extractStaticResourceBody('HP_SM008_Personne_MOCK');
		Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
												'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   'HP_APIHourAccessTokenResponse_MOCK',
												   new Map<String, String> {'Content-Type' => 'application/json'}),
                                                
                                                'personnes' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(204, 
												null,
												new Map<String, String> {'Content-Type' => 'application/json'})
												};

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
        String contactId = [select id from contact limit 1].Id;
         HP_SM058_EditNameClient.editName(contactId, '100166', 'MR', 'xxx', 'XX', null, null, null, null
        ,'C', 'E', true);
        Test.stopTest();
       
    }

    @isTest
    public static void sendNotificationTest() {
         Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'ES-Correspondance_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_NotificationOPS',
                new Map<String, String> ()
            )
                };
                Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object> {
				'LastName' => 'Contact Test',
				'Email' => 'test@gmail.com',
                    'mobilePhone' => '0121212',
				'Id_Tiers__c' => 1313
			}, null, null,null);
			insert contact;    
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        String contactId = [select id from contact limit 1].Id;
        HP_SM058_EditNameClient.notificationClient(contactId, true, true, false, false, null);
        HP_SM058_EditNameClient.sendJustificatif(contactId, 'E', 'C', '');
        Test.stopTest();
    }
}