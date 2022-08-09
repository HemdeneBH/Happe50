/*@Author: MHA
*@Description : classe de test de l'appel de l'API consentement
*@CreatedDate : 28/09/2018
*LastModified: MHA 17/01/2019
*/
@isTest
global class SM_AP27_ConsentementAPI_TEST {
	/*@Author: MHA
	*@Description : test de la lecture
	*@CreatedDate : 28/09/2018
	*LastModified: MHA 17/01/2019
	*/
	@isTest
	global static void testRead() {
		// Implement test code

		Map<String , object>inputMap = new Map<String, object>() ;
		Map<String , object>outputMap = new Map<String, object>() ;

		Map<String, Object> personnes = new Map<String, object>();
		Map<String, Object> personne = new Map<String, object>();
		personne.put('idPersonneUnifie', 15003);
		personnes.put('personne1', personne);
		inputMap.put('personnes', personnes);

		SM_AP27_ConsentementAPI service = new SM_AP27_ConsentementAPI() ;

		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SM_MockTestConsentements');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);

		service.invokeMethod('methodenotCovered', inputMap,  outputMap, null) ;
		service.invokeMethod('callConsentement', inputMap,  outputMap, null) ;

		System.debug('@MHA outputMap '+outputMap);
		SM_AP27_ConsentementAPI.ConsentementModel answer1;
		Map<String,Object>results;
		if(outputMap.get('answers') != null){
			results = (Map<String,Object>)outputMap.get('answers');
			if(results.get('answer1') != null){
				answer1 = (SM_AP27_ConsentementAPI.ConsentementModel)results.get('answer1');
			}
		}

		System.assertEquals('0202010068',answer1.idBusinessPartner);
		System.assertEquals('SMILE',answer1.application);
		System.assertEquals('1',answer1.idQuestion);
		System.assertEquals('1',answer1.idQuestionnaire);
		System.assertEquals('15003',answer1.idPersonne);
		System.assertEquals('true',answer1.consent);
	}

	/*@Author: MHA
	*@Description : test de l'écriture
	*@CreatedDate : 28/09/2018
	*LastModified: MHA 17/01/2019
	*/
	@isTest static void testWrite() {
		// Implement test code
		MP_Generics_Endpoints__c endpoint = new MP_Generics_Endpoints__c();
		endpoint.EndPoint__c = 'https://auth.ext.rec.api.engie.fr';
		endpoint.Name = 'api_endpoint';
		insert endpoint;

		MP_Xdata_credentials__c sm_api_version = new MP_Xdata_credentials__c();
		sm_api_version.Value__c = '0.1';
		sm_api_version.Name = 'sm_api_version';
		insert sm_api_version;

		MP_Xdata_credentials__c sm_api_key = new MP_Xdata_credentials__c();
		sm_api_key.Value__c = 'l7xx914e96a9169640b2ab5afd09c6163829';
		sm_api_key.Name = 'sm_api_key_INT';
		insert sm_api_key;

		Map<String , object>inputMap = new Map<String, object>() ;
		Map<String , object>outputMap = new Map<String, object>() ;
		Map<String , object>choixElements = new Map<String, object>();
		Map<String, Object> personnes = new Map<String, object>();
		Map<String, Object> personne = new Map<String, object>();
		Map<String, Object> question1 = new Map<String, object>();
		Map<String, Object> question2 = new Map<String, object>();
		Map<String, Object> questions = new Map<String, object>();
		Map<String, Object> ChoixCanal = new Map<String, object>();

		inputMap.put('answers', null);

		choixElements.put('answer1display', 'true');
		choixElements.put('answer2display', 'true');

		inputMap.put('refClientIdBP', 0123456789);
		inputMap.put('refIdpersonne', 15001);

		question1.put('id', '1');
		question1.put('idQuestion', '3');

		question2.put('id', '2');
		question2.put('idQuestion', '3');

		questions.put('question1', question1);
		questions.put('question2', question2);

		inputMap.put('questions', questions);

		inputMap.put('refClientIdBP', 'test');

		choixCanal.put('CanalPreference', 'WEB');
		choixElements.put('ChoixCanal', choixCanal);
		inputMap.put('ChoixElements', choixElements);

		SM_AP27_ConsentementAPI service = new SM_AP27_ConsentementAPI();

		service.invokeMethod('methodenotCovered', inputMap,  outputMap, null) ;
		service.invokeMethod('callUpsertConsentement', inputMap,  outputMap, null);


		Map<String, Object> bodyRequest = new Map<String, Object>();
		bodyRequest.put('idPersonne', Integer.valueOf('15001'));
		bodyRequest.put('idQuestionnaire', Integer.valueOf('3'));
		bodyRequest.put('idBusinessPartner', '0202010066');
		bodyRequest.put('idQuestion', Integer.valueOf('1'));
		bodyRequest.put('consent', Boolean.valueOf('true'));
		bodyRequest.put('canal', 'WEB');
		bodyRequest.put('application', 'SMILE');

		Map<String, Object> bodyRequest2 = new Map<String, Object>();
		bodyRequest2.put('idPersonne', Integer.valueOf('15001'));
		bodyRequest2.put('idQuestionnaire', Integer.valueOf('3'));
		bodyRequest2.put('idBusinessPartner', '0202010066');
		bodyRequest2.put('idQuestion', Integer.valueOf('2'));
		bodyRequest2.put('consent', Boolean.valueOf('true'));
		bodyRequest2.put('canal', 'WEB');
		bodyRequest2.put('application', 'SMILE');

		HttpRequest request =  SM_AP27_ConsentementAPI.buildHttpRequestHeadersPost('tokentest',bodyRequest );

		SM_AP27_ConsentementAPI.sendData(request ) ;

		SM_AP27_ConsentementAPI.getResponseWrite('tokentest', bodyRequest);
		SM_AP27_ConsentementAPI.getResponseWrite('tokentest', bodyRequest2);
	}

	/*@Author: MHA
	*@Description : test de la mise à jour
	*@CreatedDate : 28/09/2018
	*LastModified: MHA 17/01/2019
	*/
	@isTest static void testUpdate() {
		// Implement test code
				MP_Generics_Endpoints__c endpoint = new MP_Generics_Endpoints__c();
		endpoint.EndPoint__c = 'https://auth.ext.rec.api.engie.fr';
		endpoint.Name = 'api_endpoint';
		insert endpoint;

		MP_Xdata_credentials__c sm_api_version = new MP_Xdata_credentials__c();
		sm_api_version.Value__c = '0.1';
		sm_api_version.Name = 'sm_api_version';
		insert sm_api_version;

		MP_Xdata_credentials__c sm_api_key = new MP_Xdata_credentials__c();
		sm_api_key.Value__c = 'l7xx914e96a9169640b2ab5afd09c6163829';
		sm_api_key.Name = 'sm_api_key_INT';
		insert sm_api_key;

		Map<String , object>inputMap = new Map<String, object>() ;
		Map<String , object>outputMap = new Map<String, object>() ;
		Map<String , object>choixElements = new Map<String, object>();
		Map<String, Object> personnes = new Map<String, object>();
		Map<String, Object> personne = new Map<String, object>();
		Map<String, Object> question1 = new Map<String, object>();
		Map<String, Object> question2 = new Map<String, object>();
		Map<String, Object> questions = new Map<String, object>();
		Map<String, Object> choixCanal = new Map<String, object>();
		Map<String, Object> answer2 = new Map<String, object>();
		Map<String, Object> answer1 = new Map<String, object>();
		Map<String, Object> answers = new Map<String, object>();

		answer1.put('id', 'test');
		answer1.put('idQuestionnaire', '3');
		answer1.put('idQuestion','1');
		answer2.put('id', 'test');
		answer2.put('idQuestionnaire', '3');
		answer2.put('idQuestion', '2');
		answers.put('answer1',answer1);
		answers.put('answer2',answer2);
		inputMap.put('answers', answers);

		choixElements.put('answer1display', 'true');
		choixElements.put('answer2display', 'true');

		/*answer1display
		answer2display*/

		personne.put('idPersonneUnifie', '15001');
		personnes.put('personne1', personne);
		inputMap.put('personnes', personnes);
		/*personnes
			personne1
				idPersonneUnifie
				id*/
		question1.put('id', '1');
		question1.put('idQuestion', '3');

		question2.put('id', '2');
		question2.put('idQuestion', '3');

		questions.put('question1', question1);
		questions.put('question2', question2);

		inputMap.put('questions', questions);

		inputMap.put('refClientIdBP', 'test');

		choixCanal.put('CanalPreference', 'WEB');
		choixElements.put('ChoixCanal', choixCanal);
		inputMap.put('ChoixElements', choixElements);

		SM_AP27_ConsentementAPI service = new SM_AP27_ConsentementAPI();

		service.invokeMethod('methodenotCovered', inputMap,  outputMap, null) ;
		service.invokeMethod('callUpsertConsentement', inputMap,  outputMap, null);
		Map<String, Object> bodyRequest = new Map<String, Object>();
		bodyRequest.put('idPersonne', Integer.valueOf('15001'));
		bodyRequest.put('idQuestionnaire', Integer.valueOf('3'));
		bodyRequest.put('idBusinessPartner', '0202010066');
		bodyRequest.put('idQuestion', Integer.valueOf('1'));
		bodyRequest.put('consent', Boolean.valueOf('true'));
		bodyRequest.put('canal', 'WEB');
		bodyRequest.put('application', 'SMILE');

		Map<String, Object> bodyRequest2 = new Map<String, Object>();
		bodyRequest2.put('idPersonne', Integer.valueOf('15001'));
		bodyRequest2.put('idQuestionnaire', Integer.valueOf('3'));
		bodyRequest2.put('idBusinessPartner', '0202010066');
		bodyRequest2.put('idQuestion', Integer.valueOf('2'));
		bodyRequest2.put('consent', Boolean.valueOf('true'));
		bodyRequest2.put('canal', 'WEB');
		bodyRequest2.put('application', 'SMILE');


		HttpRequest request =  SM_AP27_ConsentementAPI.buildHttpRequestHeadersPUT('tokentest',bodyRequest, 'test' );

		SM_AP27_ConsentementAPI.sendData(request ) ;

		SM_AP27_ConsentementAPI.getResponseUpdate('tokentest', bodyRequest,'test');
		SM_AP27_ConsentementAPI.getResponseUpdate('tokentest', bodyRequest2,'test');
	}

}