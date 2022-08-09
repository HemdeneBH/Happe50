/**
 * @File Name          : HP_EM004_FactureManager.cls
 * @Description        : class permet de tester HP_PersonneController_TEST
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Created On         : 20/01/2020
**/

@isTest
public with sharing class HP_PersonneController_TEST {
    
    private enum StaticResource {
		HP_APIHourAccessTokenResponse_MOCK,
        HP_APIHourGetPersonne,
        HP_AGILAB_PERSONNE_XDATA_ID_MOCK
    }
    
    @testSetup static void dataSetup(){
        HP_UTIL_SmartFactory.insertUserHP();
    }

    @isTest
    static void ecrirePersonne_TEST(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            //Configurer le Mock
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                    StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                                                    new Map<String, String> {'Content-Type' => 'application/json'}),
                                                    
                'personnes' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                    Null,
                                                    new Map<String, String> { 'Content-Type' => 'application/json',
                                                    'Location' => ' https://qa-rec-dmzint-gtw.api.engie.fr:8500/api/happe/0.1/personnes/220647'
                                                    })
            };

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
            String infosPersonneJson = '{\"civilite\":\"MR\",\"nom\":\"test\",\"prenom\":\"test\",\"numeroFixe\":\"0112345678\",\"numeroMobile\":\"0742908414\",\"email\":\"test@external.engie.com\",\"prospect\":false,\"client\":true,\"numVoie\":\"12\",\"voie\":\"Rue de Bercy\",\"complementAdresse\":\"\",\"codePostal\":\"34000\",\"ville\":\"Montpellier\",\"pays\":\"FR\"}';
            String reponse = HP_PersonneController.ecrirePersonne(infosPersonneJson);
            Test.stopTest();
            System.assert(reponse != null , 'succès');
        } 
    }

    @isTest
    static void loadPersonne_TEST(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            //Configurer le Mock
		Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
												   new Map<String, String> {'Content-Type' => 'application/json'}),

			'personnes' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                StaticResource.HP_APIHourGetPersonne.name(),
												  new Map<String, String> { 'Content-Type' => 'application/json'})
        };
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        Map<String, Object> reponseMap = HP_PersonneController.loadPersonne('220647');
        Test.stopTest();
        System.System.assertEquals(reponseMap.get('id'), 220647, 'Le client existant');
        } 
    }

    /**
    * @description tester oadContactDoublonsList
    * @author Slimene Belhaj Ali | 20/01/2020
    * @return void 
    **/
    @isTest
    public static void loadContactDoublonsList_TEST() {
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Test.startTest();
            List<Contact> result = HP_PersonneController.loadContactDoublonsList(new Map<String, Object>{'mail' => 'test@test.com'});
            Test.stopTest();
            System.assertEquals(result.size(), 0, 'Doublons invalide');
        }
    }


    @isTest
    static void mergeClientWithConsentement_TEST(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            //Configurer le Mock
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                    StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                                                    new Map<String, String> {'Content-Type' => 'application/json'}),
                                                    
                'personnes' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                    Null,
                                                    new Map<String, String> { 'Content-Type' => 'application/json',
                                                    'Location' => ' https://qa-rec-dmzint-gtw.api.engie.fr:8500/api/happe/0.1/personnes/220647'
                                                    }),
                'consentement' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                    Null,
                                                    new Map<String, String>())
                                                    
            };
            Map<String, Object> client = new Map<String, Object>{'civilite'=>'MR', 'nom'=>'MR', 'prenom'=>'MR', 'numeroFixe'=>'06555', 'numeroMobile'=>'01111', 'email'=>'dsfdfd@dfd.fr'
            , 'prospect'=>false, 'client'=>true, 'numVoie'=>'14', 'voie'=>'MR', 'complementAdresse'=>'MR', 'codePostal'=>'92000', 'ville'=>'MR', 'pays'=>'FR','stopEmail'=>false, 'stopSms'=>false,'optinMarketing'=>false};
            List<Map<String, Object>> concentementList = new  List<Map<String, Object>>();
            concentementList.add(new Map<String, Object>());
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
            String infosPersonneJson = '{\"civilite\":\"MR\",\"nom\":\"test\",\"prenom\":\"test\",\"numeroFixe\":\"0112345678\",\"numeroMobile\":\"0742908414\",\"email\":\"test@external.engie.com\",\"prospect\":false,\"client\":true,\"numVoie\":\"12\",\"voie\":\"Rue de Bercy\",\"complementAdresse\":\"\",\"codePostal\":\"34000\",\"ville\":\"Montpellier\",\"pays\":\"FR\",\"stopEmail\":false,\"stopSms\":false,\"optinMarketing\":false}';
            String reponse = HP_PersonneController.mergeClientWithConsentement(client, '+33', concentementList);
            Test.stopTest();
            System.assert(reponse != null , 'succès');
        } 
    }


    @isTest
    static void getXdataId_TEST(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            //Configurer le Mock
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
												   new Map<String, String> {'Content-Type' => 'application/json'}),
                 'personnes/get_personne_xdata_id' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                                                    'HP_AGILAB_PERSONNE_XDATA_ID_MOCK',
                                                    new Map<String, String> {'Content-Type' => 'application/json'})
            };
        
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
            String email = 'ali.ajellal@external.engie.com';
            List<Map<String, Object>>  reponse = HP_PersonneController.getPersonneXdataId(email);
            Test.stopTest();
        } 
    }
}