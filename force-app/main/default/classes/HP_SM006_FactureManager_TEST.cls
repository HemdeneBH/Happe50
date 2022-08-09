/** 
* @author Slimen Belhaj Ali 
* @date 14/01/2020  
* @description Classe de test pour HP_SM006_FactureManager
*/
@IsTest
public with sharing class HP_SM006_FactureManager_TEST {

    @testSetup static void dataSetup(){
        HP_UTIL_SmartFactory.insertUserHP();
    }

    /** 
    * @author Slimene Belhaj Ali
    * @date 14/01/2020 
    * @description Methode permet tester la methode updateFactureModeEnvoi
    */
    @IsTest
	static void updateFactureModeEnvoi_TEST(){

        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'propositions/modifier_mode_denvoi_factures' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_ResponseHPSM006FactureManagermodifiermodedenvoiFactures',
                new Map<String, String> {'Content-Type' => 'application/json'}),
                
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_APIHourAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'})
                };

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
        Map<Integer, String> result = HP_SM006_FactureManager.updateFactureModeEnvoi('123', 2);
        Test.stopTest();
        System.System.assertNotEquals(null, result.get(200), 'Le statut de le reponse different de 200');
        }
    }

    @IsTest
	static void updateEnergieVert_TEST(){

        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'propositions/modifier' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_ResponseHPSM006FactureManagermodifiermodedenvoiFactures',
                new Map<String, String> {'Content-Type' => 'application/json'}),
                
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                null, '{"status": "SUCCESS","message": "L","output": {}}',
                new Map<String, String> {'Content-Type' => 'application/json'})
                };

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
        HP_SM006_FactureManager.updateEnergieVert('123', '1', '1');
        Test.stopTest();
        }
    }

    @IsTest
	static void loadEnergieVerOption_TEST(){

        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'propositions/get_options' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_ResponseHPSM006FactureManagermodifiermodedenvoiFactures',
                new Map<String, String> {'Content-Type' => 'application/json'}),
                
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                null, '{"status": "SUCCESS","message": "L","output": {}}',
                new Map<String, String> {'Content-Type' => 'application/json'})
                };

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
        HP_SM006_FactureManager.loadEnergieVerOption('123');
        Test.stopTest();
        }
    }
}