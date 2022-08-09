/**
 * @File Name          : HP_APIHourCPService_TEST.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 11-22-2021
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    04/02/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
@isTest
public with sharing class HP_APIHourCPService_TEST {
    
    @testSetup static void dataSetup(){
        HP_UTIL_SmartFactory.insertUserHP();
    }

    @isTest
    public static void APICreateUpdate_TEST() {
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_APIHourAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}),
            
                

                'apiset/0.1/propositions-commerciales' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                null,'[123,456]',
                new Map<String, String> { 'Content-Type' => 'application/json'})
                };
        HP_APIHourCommercialPropositionService service = new HP_APIHourCommercialPropositionService();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 

        HP_APIHourCommercialPropositionService.updateCommmercialPropositionAsync(new List<Integer> {121}, 'ACTIF','H0104');
        Test.stopTest();
        }
    }
}