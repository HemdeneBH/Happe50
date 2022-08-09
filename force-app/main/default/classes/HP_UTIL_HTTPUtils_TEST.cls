/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   26-11-2020   Antoine Latour   Initial Version
**/
@IsTest
public without sharing class HP_UTIL_HTTPUtils_TEST {

    private enum StaticResource {
        HP_APIHourAccessTokenResponse_MOCK,
        HP_SM008_Personne_MOCK,
        HP_SendEmail_Mock,
        HP_Invalid_Token_Response_MOCK,
        HP_Agilab_Token_MOCK,
        HP_Tranquility_Response_MOCK,
        HP_Tranquility_Token_MOCK,
        HP_ApigeeAccessTokenResponse_MOCK,
        HP_CONTRAT_XDATA_BY_PERSONNE_MOCK
    }

    @testSetup static void dataSetup(){        
        HP_UTIL_SmartFactory.insertUserHP();
    }

    @istest static void getSaveLogMode(){
        
        Test.startTest();
        String saveLog = HP_UTIL_HTTPUtils.getSaveLogMode();
        Test.stopTest();

        System.assert(saveLog != null);
    }
    
    @istest static void getTransactionId() {
        Test.startTest();
        String transactionId = HP_UTIL_HTTPUtils.getTransactionId();
        Test.stopTest();

        System.assert(transactionId != null);
    }

    
    @istest static void calloutGetApigee() {
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'contrat/byPersonne' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_CONTRAT_XDATA_BY_PERSONNE_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}),
                
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_ApigeeAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'})
                };
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
            HttpResponse response =  HP_UTIL_HTTPUtils.calloutGet('XDATA_CONTRATS', '?idPersonne=1844161');
            Test.stopTest();
            System.System.assertNotEquals(200, response.getStatusCode(), 'Le statut de le reponse égale à 200');
        }
    }

    @istest static void calloutGetToMapByMap() {
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'propositions/modifier_mode_denvoi_factures' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_ResponseHPSM006FactureManagermodifiermodedenvoiFactures',
                new Map<String, String> {'Content-Type' => 'application/json'}),
                
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_APIHourAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'})
                };
            Map<String, String> params = new Map<String, String>();
            params.put('param', 'param');
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
            Map<Integer, String> result = HP_UTIL_HTTPUtils.calloutGetToMap(HP_Constantes.AGILAB_MODIFIER_MODE_ENVOI_FACTURE, params);
            Test.stopTest();
            System.debug(result.get(200));
            System.System.assertNotEquals(null, result.get(200), 'Le statut de le reponse different de 200');
        }
    }
    @istest static void calloutGetToMap() {
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                    'propositions/modifier_mode_denvoi_factures' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    'HP_ResponseHPSM006FactureManagermodifiermodedenvoiFactures',
                    new Map<String, String> {'Content-Type' => 'application/json'}),
                    
                    'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    'HP_APIHourAccessTokenResponse_MOCK',
                    new Map<String, String> {'Content-Type' => 'application/json'})
                    };

            Map<String, String> params = new Map<String, String>();
            params.put('param', 'param');
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
            Map<Integer, String> result = HP_UTIL_HTTPUtils.calloutGetToMap(HP_Constantes.AGILAB_MODIFIER_MODE_ENVOI_FACTURE, HP_UTIL_HTTPUtils.buildUrlEncodedParameters(params));
            Test.stopTest();
            System.System.assertNotEquals(null, result.get(200), 'Le statut de le reponse different de 200');
        }
    }

    @istest static void calloutPostToMap() {
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                    'Contracts/getContrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    'HP_Tranquility_Response_MOCK',
                    new Map<String, String> {'Content-Type' => 'application/json'}),
                    '/rest/users/login' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    'HP_Tranquility_Token_MOCK',
                    new Map<String, String> {'Content-Type' => 'application/json'}),
                    'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    'HP_APIHourAccessTokenResponse_MOCK',
                    new Map<String, String> {'Content-Type' => 'application/json'})
                    };

         String body =  HP_ParseUtils.serialize(new HP_WRP0015_TranquilityContractInfo.TranquilityRequest('123456789','happe'));
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
            Map<Integer, String> result = HP_UTIL_HTTPUtils.calloutPostToMap(HP_Constantes.TRANQUILITY_GET_CONTRAT, body);
            Test.stopTest();
            System.System.assertNotEquals(null, result.get(200), 'Le statut de le reponse different de 200');
        }
    }

    @istest static void calloutGetToMapInvalidToken() {
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                    'propositions/souscription' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(401, 
                    'HP_Invalid_Token_Response_MOCK',
                    new Map<String, String> {'Content-Type' => 'application/json'}),
                    
                    'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    'HP_Agilab_Token_MOCK',
                    new Map<String, String> {'Content-Type' => 'application/json'})
                    };

            Map<String, String> params = new Map<String, String> {
                'code_offre' => 'EITR2_H',
                'id_proposition_commerciale' => '407503445',
                'prestataire' => '4075034'
                };
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
            Map<Integer, String> result = HP_UTIL_HTTPUtils.calloutGetToMap(HP_Constantes.AGILAB_CREATION_SOUSCRIPTION, params);
            Test.stopTest();
            System.assertEquals(true, result.containsKey(401), 'Le statut est bien egal à 401');
        }
    }
    
    @istest static void saveLogResponse(){
        RestRequest restRequest = new RestRequest();
        RestResponse restResponse = new RestResponse();
        Long duration = 100;
        Map<String, String> result = new Map<String, String>();
        result.put('result', 'result');

        restRequest.requestURI = 'URI';
        restRequest.httpMethod = 'GET';
        
        restResponse.statusCode = 200;
        restResponse.responseBody = Blob.valueOf('{"code" : 408, "message" : "timeout"}');
        Test.startTest();
        HP_UTIL_HTTPUtils.saveLogResponse(restRequest, restResponse, duration);
        Test.stopTest();
    }

     @istest static void calloutPut() {
        String expectedValue = HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(StaticResource.HP_SM008_Personne_MOCK.name());
		Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
												'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
												   new Map<String, String> {'Content-Type' => 'application/json'}),
                                                
                                                'personnes' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(204, 
												null,
												new Map<String, String> {'Content-Type' => 'application/json'})
												};

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
        HTTPResponse response= HP_UTIL_HTTPUtils.calloutPut(HP_Constantes.XDATA_PERSONNE, 'infos', 'id');
        Test.stopTest();
        System.System.assertEquals(204, response.getStatusCode(), 'Le statut de le reponse different de 200');
    }
 
    
    @istest static void calloutPutHeaders() {
        String expectedValue = HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(StaticResource.HP_SM008_Personne_MOCK.name());
		Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
												'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
												   new Map<String, String> {'Content-Type' => 'application/json'}),
                                                
                                                'personnes' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(204, 
												null,
												new Map<String, String> {'Content-Type' => 'application/json'})
												};
        Map<String, String> headers = new Map<String, String>();
        headers.put('header', 'header');
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
        HTTPResponse response= HP_UTIL_HTTPUtils.calloutPut(HP_Constantes.XDATA_PERSONNE, 'infos', 'id', headers);
        Test.stopTest();
        System.System.assertEquals(204, response.getStatusCode(), 'Le statut de le reponse different de 200');
    }

    
    @istest static void buildHeaderWithoutTokenTest() {
        Map<String, String> result = new Map<String, String>{'aaa' => 'dd'};
        HP_UTIL_HTTPUtils.buildHeaderWithoutToken(result);
    }
    
    @istest static void removeTokenCacheTest() {
        List<String> result = new List<String>{'aaa'};
        HP_UTIL_HTTPUtils.removeTokenCache(result);
    }

}