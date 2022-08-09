/**
 * @File Name          : HP_FlyoutPDL_TEST.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 24/04/2020 à 14:45:44
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    24/04/2020   Mouhamadoune Coulibaly     Initial Version
**/
@isTest
public with sharing class HP_FlyoutPDL_TEST {

    @testSetup static void dataSetup(){
        HP_UTIL_SmartFactory.insertUserHP();
    }
    

    @isTest
    static void getFlyoutPDL(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_APIHourAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}),
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_APIHourAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}),
    
                'ES-PrestationServiceElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_PrestaElecMock',
                new Map<String, String> {'Content-Type' => 'application/xml'})
                };
                Test.setMock(WebServiceMock.class, new HP_UTIL_ResponseSoapMock());
                Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
                Test.startTest();
                Map<String,Object> maptest = HP_FlyoutPDL.getFlyoutPDL('31431211214170');
                System.assertEquals(maptest.get('puissanceSouscriteValeur'), 12, ' Puissance pas a jour');
                Test.stopTest();
        }  
    }
}