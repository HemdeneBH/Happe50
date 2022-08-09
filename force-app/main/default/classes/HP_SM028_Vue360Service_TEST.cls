/**
 * @description  : 
 * @author       : Vincent Albiser
 * Modifications Log 
 * Ver   Date         Author            Modification
 * 1.0   09-12-2020   Vincent Albiser   Initial Version
**/
@IsTest
public with sharing class HP_SM028_Vue360Service_TEST {

    private enum StaticResource {		
        HP_APIHourCommercialProposition_POST_MOCK
    }
   
    @isTest static void execute(){
        Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{'Id_Tiers__c' => 100166,'lastName' => 'testnicot'}, null, null, null);
        insert contact;

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_APIHourAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            '' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                null,
                new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'}
            )
        };
       
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_SM028_Vue360Service.loadData('V1_SOQL_LOAD_CONTACT_FROM_SF_BY_ID', contact.Id, 447, String.valueOf(contact.Id));
        Test.stopTest();
}

}