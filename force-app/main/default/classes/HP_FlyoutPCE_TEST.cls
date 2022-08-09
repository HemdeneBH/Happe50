/**
 * @File Name          : HP_FlyoutPCE_TEST.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 24/04/2020 à 14:57:26
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    24/04/2020   Mouhamadoune Coulibaly     Initial Version
**/
@isTest
public with sharing class HP_FlyoutPCE_TEST {

    @testSetup static void dataSetup(){
        HP_UTIL_SmartFactory.insertUserHP();
    }

    @isTest
    static void getFlyoutPCE(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_APIHourAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}),
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_APIHourAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}),
    
                'ES-PDLGaz_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
                'HP_ES_PDLGaz_v2_Mock',
                new Map<String, String> {'Content-Type' => 'application/xml'})
                };
                Test.setMock(WebServiceMock.class, new HP_UTIL_ResponseSoapMock());
                Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
                Test.startTest();
                Map<String,Object> maptest = HP_FlyoutPCE.getFlyoutPCE('31431211214068',true);
                System.debug(maptest);
                System.assertEquals(maptest.get('TypeCompteur'), 'Compteur Gaz', ' le compteur n est pas de type Gaz');
                Test.stopTest();
        }
       
    }
}