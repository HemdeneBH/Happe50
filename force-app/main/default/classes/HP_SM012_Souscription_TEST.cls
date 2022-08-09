/** 
* @author Slimen Belhaj Ali 
* @date 14/01/2020  
* @description Classe de test pour HP_SM012_Souscription
*/

@IsTest
public with sharing class HP_SM012_Souscription_TEST {

    @testSetup static void dataSetup(){
        System.runAs(HP_UTIL_SmartFactory.insertUserHP()){     
        }
    }

    @IsTest
	static void creationSouscriptionAgilab_TEST() {
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'propositions/souscription' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                null,
                new Map<String, String> {'Content-Type' => 'application/json'}),
                
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_APIHourAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'})
                };

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
        Map<Integer, String> result = HP_SM012_Souscription.creationSouscriptionAgilab('123', 'promo', '123','');

        Test.stopTest();
        System.System.assertNotEquals(null, result.get(200), 'Le statut de le reponse different de 200');
        }   
    }
}