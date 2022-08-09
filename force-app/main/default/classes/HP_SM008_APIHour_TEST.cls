/**
 * @File Name          : HP_SM008_APIHour_TEST.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 28/04/2020 à 12:41:18
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    03/02/2020   Mouhamadoune Coulibaly     Initial Version
**/
@isTest
public with sharing class HP_SM008_APIHour_TEST {


	private static String expectedValue;
	private static String expectedValueConsent;

	private enum StaticResource {
		HP_APIHourAccessTokenResponse_MOCK,
		HP_SM008_APIHour_ZoneDistribution_TEST,
		HP_SM008_Personne_MOCK,
		HP_CreerConsentement_Mock,
		HP_PutConsentement_Mock
	}


	/**
	* @description 
	* @author Sara El-Hannaoui | 14/01/2020 
	* @return void 
	**/
	@isTest
	 static void checkGetZones() {
		//Configurer le Mock
		Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
												   new Map<String, String> {'Content-Type' => 'application/json'}),

			'zones-distribution' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												  StaticResource.HP_SM008_APIHour_ZoneDistribution_TEST.name(),
												  new Map<String, String> { 'Content-Type' => 'application/json'})
		};

		Test.startTest();
		RestContext.response= new RestResponse();
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
		List<HP_WRP008_APIHourZoneDistribution> response = HP_SM008_APIHour.getZonesDistributions('TESTCODEPOSTAL','TESTINSEE');
		Test.stopTest();
		System.assert (response[0].codeDistributeur == 'ENED',' La ville est une entreprise locale de distribution pour le gaz, cette adresse n est pas compatible avec un contrat happ-e gaz');

	}
	@isTest
	 static void updatePersonne(){
		expectedValue = HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(StaticResource.HP_SM008_Personne_MOCK.name());
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
        Integer result = HP_SM008_APIHour.updatePersonne('209797', expectedValue);
        Test.stopTest();
        System.System.assertEquals(204, result, 'Le statut de le reponse different de 200');
	}
	@isTest
	 static void getPersonne(){
		Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
												'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
												   new Map<String, String> {'Content-Type' => 'application/json'}),
                                                
                                                'personnes' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
												'HP_APIHourGetPersonne',
												new Map<String, String> {'Content-Type' => 'application/json'})
												};

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
		Object result = HP_SM008_APIHour.getPersonne('220647');
		Map<String,Object>  resultMap=(Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(result));
        Test.stopTest();
        System.System.assertEquals(resultMap.get('id'), 220647, 'Le client est la');
	}
	@isTest
	 static void getCommunes(){
		Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
												'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
												   new Map<String, String> {'Content-Type' => 'application/json'}),
                                                
                                                'codespostaux-villes' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
												'HP_APIHourCodesPostauxVilles',
												new Map<String, String> {'Content-Type' => 'application/json'})
												};

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
		List<Object> result = HP_SM008_APIHour.getCommunes('91270');
		System.debug(result);
		Map<String,Object>  resultMap=(Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(result[0]));
		System.debug(resultMap);
        Test.stopTest();
        System.System.assertEquals(resultMap.get('codePostal'), '91270', 'Les données sont validées');
	}
	@isTest
	 static void getCoordonneesBancaires() {
		//Configurer le Mock
		Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
												   new Map<String, String> {'Content-Type' => 'application/json'}),

			'coordonnees-bancaires' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												  'HP_SM008_APIHour_CoordonneesBancaires',
												  new Map<String, String> { 'Content-Type' => 'application/json'})
		};

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
		List<HP_WRP029_APIHourCoordonneesBancaires> result = HP_SM008_APIHour.getCoordonneesBancaires('195464');
		Test.stopTest();
		System.assert (result[0].idPersonne == 195464,'Les données sont validées');

	}
	@isTest
	 static void getReponsesConsentement() {
		//Configurer le Mock
		Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
												   new Map<String, String> {'Content-Type' => 'application/json'}),

			'consentements' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												  'HP_SM008_APIHour_ReponsesConsentement',
												  new Map<String, String> { 'Content-Type' => 'application/json'})
		};

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
		List<HP_WRP031_APIHourConsentements> result = HP_SM008_APIHour.getReponsesConsentement(196489);
		System.debug('++++++++++>'+result);
		Test.stopTest();
		System.assert (result[0].idPersonne == 196489,'Les données sont validées');

	}
	@isTest
	 static void getQuestionsConsentement() {
		//Configurer le Mock
		Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
												   new Map<String, String> {'Content-Type' => 'application/json'}),

			'questions-consentement' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												  'HP_SM008_APIHour_QuestionsConsentement',
												  new Map<String, String> { 'Content-Type' => 'application/json'})
		};

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
		List<HP_WRP032_APIHourConsentementsQuestions> result = HP_SM008_APIHour.getQuestionsConsentement();
		Test.stopTest();
		System.assert (result[0].idQuestionnaire == '1','Les données sont validées');

		

	}
	@isTest
	 static void creerConsentement() {
		expectedValueConsent = HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(StaticResource.HP_CreerConsentement_Mock.name());
		//Configurer le Mock
		Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
												   new Map<String, String> {'Content-Type' => 'application/json'}),

			'consentements' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201,
												  null,
												  new Map<String, String> { 'Content-Type' => 'application/json'})
		};

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
		List<Object> result = HP_SM008_APIHour.creerConsentement(expectedValueConsent);
		Map<String,Object> mapResult=(Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(result[0]));
		Test.stopTest();
		System.assert (mapResult.get('idPersonne') == 196489,'Les données sont validées');


	}
	@isTest
	 static void sendConsentResponses() {
		expectedValueConsent = HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(StaticResource.HP_CreerConsentement_Mock.name());
		//Configurer le Mock
		Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
												   new Map<String, String> {'Content-Type' => 'application/json'}),

			'consentements' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(204,
												  null,
												  new Map<String, String> { 'Content-Type' => 'application/json'})
		};

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
		List<Object> result = HP_SM008_APIHour.sendConsentResponses(expectedValueConsent);
      	Map<String,Object> mapResult=(Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(result[0]));
		Test.stopTest();
		System.assert (mapResult.get('idPersonne') == 196489,'Les données sont validées');

	}

	@isTest
	 static void sendConsentResponsesPut() {
		expectedValueConsent = HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(StaticResource.HP_PutConsentement_Mock.name());
		//Configurer le Mock
		Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
												   new Map<String, String> {'Content-Type' => 'application/json'}),

			'consentements' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201,
												  null,
												  new Map<String, String> { 'Content-Type' => 'application/json'})
		};

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
		List<Object> result = HP_SM008_APIHour.sendConsentResponses(expectedValueConsent);
      	Map<String,Object> mapResult=(Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(result[0]));
		Test.stopTest();
		System.assert (mapResult.get('id') == 'TESIDCONSENT','Les données sont validées');

	}
	
    @isTest
    static void getPDL() {
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
												   new Map<String, String> {'Content-Type' => 'application/json'}),

			'elec-points-de-livraison' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                	null,'{"numeroPointDeLivraison":"1231546"}',
                	new Map<String, String> {'Location' => 'http/123456', 'Content-Type' => 'application/json'})
		};
        
        Test.startTest();
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
		Map<String, Object> result = HP_SM008_APIHour.getPDL('123456', true);
		Test.stopTest();
		System.assert (String.valueOf(result.get('numeroPointDeLivraison')) == '1231546','Les données sont validées');
    }



}