/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 06-02-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
@isTest
public with sharing class HP_SM076_ShareGroopController_TEST {

    @isTest 
    public static void createOrderPaiementAPlusieurs_TEST() {
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_ApigeeAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'protected-agilab/oauth2s/access_token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_Agilab_Token_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            '/v1/orders' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,'HP_Sharegroop_CreateOrder_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            )
        };
        
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
    String responseBody = HP_SM076_ShareGroopController.createOrderPaiementAPlusieurs('FACT379527', '838.91', 'jdd.espace.test@yopmail.com', 'JDD', 'Espace CLient');
    Map <String, Object> resultMap = (Map<String,Object>)JSON.deserializeUntyped(responseBody);
    Test.stopTest();
    System.assert(resultMap.get('success') == true, 'Order creation succeeded');
    }
}