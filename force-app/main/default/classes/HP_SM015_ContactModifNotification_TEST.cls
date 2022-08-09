/**
 * @File Name          : HP_SM015_ContactModifNotification_TEST.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 19/06/2020 à 15:21:51
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    01/04/2020   Mouhamadoune Coulibaly     Initial Version
**/
@IsTest
public with sharing class HP_SM015_ContactModifNotification_TEST {

    private enum StaticResource {
		HP_APIHourAccessTokenResponse_MOCK,
        HP_SendEmail_Mock
    }

    @TestSetUp 
	private static void insertTestData(){
            Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact','HP_Contact', new Map<String, Object>{
                'Email'=>'test@email.com',
                'HP_IsHappe__c' => true,
                'FirstName' => 'LastName Test',
                'LastName' => 'LastName Test',
                'HomePhone'=>'0987678987',
                'MobilePhone'=> '676543647',
                'Id_Tiers__c' => 12121
            }, null, null, new List<String>{'AccountId'});
            insert contact;
    }

    @IsTest
    static void sendSMS(){

            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                    new Map<String, String> {'Content-Type' => 'application/json'}
                ),
                'contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    null,
                    new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'}
                ),
                'ES-Correspondance_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    StaticResource.HP_SendEmail_Mock.name(),
                    new Map<String, String> {'Content-Type' => 'application/json'}
                )
            };
            Test.startTest();
            RestContext.response= new RestResponse();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
            Contact contact = [SELECT id, Id_Tiers__c,LastName ,MobilePhone FROM Contact WHERE LastName='LastName Test' LIMIT 1];
            HP_SM015_ContactModifNotification.sendSMS(contact.LastName,Integer.valueOf(contact.Id_Tiers__c),String.valueOf(contact.MobilePhone));
            Test.stopTest();
            System.assertEquals(1, [SELECT ID, WhoId FROM task WHERE WhoId =: contact.Id].size(),'Passed');
    
            // System.assertEquals(result,resultTest,'ALL_IS_OK');
        
    }

    @IsTest
    static void sendEmail(){

            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                    new Map<String, String> {'Content-Type' => 'application/json'}
                ),
                'contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    null,
                    new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'}
                ),
                'ES-Correspondance_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    StaticResource.HP_SendEmail_Mock.name(),
                    new Map<String, String> {'Content-Type' => 'application/json'}
                )
            };
            Test.startTest();
            RestContext.response= new RestResponse();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
            Contact contact = [SELECT id, Id_Tiers__c,LastName,Email ,MobilePhone,HomePhone FROM Contact WHERE LastName='LastName Test' LIMIT 1];
            String infoString = '{"consentements":true, "numFixe":"0987548345", "numMobile":"0678463748","email":"test@hotmail.com","adresse":"32 RUE PIERRE CURIE"}';
            Object infosMap = JSON.deserializeUntyped(infoString);
            HP_SM015_ContactModifNotification.sendEmail(contact.LastName,contact.Email, Integer.valueOf(contact.Id_Tiers__c),infosMap);
            Test.stopTest();
            System.assertEquals(1, [SELECT ID, relationId FROM EmailMessageRelation WHERE relationId =: contact.Id].size(),'Passed');

    }
}