/*@Author: MHA
*@Description : Lecture et enregistrement du consentement RGPD
*@CreatedDate : 28/09/2018
*LastModified: MHA 17/01/2019
*/
global class SM_AP27_ConsentementAPI implements vlocity_cmt.VlocityOpenInterface {
	/*@Author: MHA
	*@Description : gestion des appels
	*@CreatedDate : 28/09/2018
	*LastModified: MHA 17/01/2019
	*/
	global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

		if (methodName.equals('callConsentement')) {
			try {
				callConsentement(inputMap, outMap, options);
				// your implementation, use outMap to send response back to OmniScript
			} catch (Exception e) {
				system.debug(e);
				return false;
			}
		} else if (methodName.equals('callUpsertConsentement')) {
			try {
				Map<String, Object>answers = new Map<String, Object>();
				Map<String, Object>answer1 = new Map<String, Object>();
				if (inputMap.get('answers') != null) {
					answers = (Map<String, Object>)inputMap.get('answers');
				} else {
					System.debug('pas de réponses');
				}
				System.debug('@answers existe : '+answers+', '+inputMap.get('answers'));
				if (inputMap.get('answers') != null) {
					callModifiedConsentement(inputMap, outMap, options);
				} else {
					callCreateConsentement(inputMap, outMap, options);
				}
				// your implementation, use outMap to send response back to OmniScript
			} catch (Exception e) {
				system.debug(e);
				return false;
			}
		}

		return true;
	}

	/*@Author: MHA
	*@Description : Read Consentement
	*@CreatedDate : 28/09/2018
	*LastModified: MHA 17/01/2019
	*/
	public static void callConsentement(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
		Map < String, Object > personnes = new Map < String, Object >();
		Map < String, Object >personne = new Map < String, Object >();
		String idPersonneFinal = String.valueOf(31);
		if (inputMap.get('personnes') != null) {
			personnes = (Map < String, Object >)inputMap.get('personnes');
		} else {
			System.debug('pas de personnes');
			return;
		}

		if (personnes.get('personne1') != null) {
			System.debug('@test:' + personnes.get('personne1'));
			personne = (Map < String, Object >)personnes.get('personne1');
		} else {
			System.debug('pas de personne');
			return;
		}
		/*System.debug('@personne value'+personne.get(0));
		ConsentementModel value = (ConsentementModel)personne.get(0);
		System.debug(value.idPersonneUnifie);*/
		if (personne.get('idPersonneUnifie') != '0' && personne.get('idPersonneUnifie') != null && personne.get('idPersonneUnifie') != '') {
			idPersonneFinal = String.valueOf(personne.get('idPersonneUnifie'));
		} else {
			if (personne.get('id') != null && personne.get('id') == '0') {
				idPersonneFinal = (String)personne.get('id');
			} else {
				System.debug('pas de personne...');
				return;
			}
		}

		String token;
        if (Test.isRunningTest()) {
            token = 'wadfkoa1234';
        } else {
            token = SM_MP_AP04_GetTokenService.getTokenFromSmile();
        }

		if (token == null) {
			system.debug('Token not found ...');
			return;
		}
		HttpResponse httpResponse = getResponse(token, idPersonneFinal);

		Map < String, Object > resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
		List < Object > clientAccounts = (List < Object > ) resultAsMap.get('_data');

		if (clientAccounts.Size() == 0) {
			system.debug('No data to get the idBusinessPartner ' + inputMap.get('IdBuisnessPartner'));
			/*callCreateConsentement(inputMap, outMap, options);*/
			return;
		}/*else{
			Map<String, Object> transformedData =  transformDatatoOmniscript(clientAccounts) ;
			Map<String, String> answersId = new Map<String, String>();
			for(Integer index = 1 ; index <=transformedData.size();index++){
				ConsentementModel consentement = (ConsentementModel)transformedData.get('answer'+index);
				answersId.put('answerId'+index, consentement.Id);
			}
			callModifiedConsentement(inputMap, outMap, options,answersId);
			outMap.put('answers', transformedData);

		}*/
		// methode qui transform les données retournées par l'api , qui extrait les champ qu'on a besoin au niveau de l'omniscript
		System.debug('test1');
		Map<String, Object> transformedData =  (Map<String, Object>)transformDatatoOmniscript(clientAccounts) ;

		outMap.put('answers', transformedData);

	}

	/*@Author: MHA
	*@Description : Save a new consentemnt
	*@CreatedDate : 28/09/2018
	*LastModified: MHA 17/01/2019
	*/
	public static void callCreateConsentement(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
		Map < String, Object > questions = new Map < String, Object >();
		Map < String, Object > question1 = new Map < String, Object >();
		Map < String, Object > personnes = new Map < String, Object >();
		Map < String, Object > personne = new Map < String, Object >();
		Map < String, Object >answers = new Map< String, Object >();
		Map < String, Object >answer1 = new Map< String, Object >();
		Map < String, Object >answer2 = new Map< String, Object >();
		Map < String, Object >choixElements = new Map < String, Object >();


		String answerChoice;
		String answerChoice2;
		String idQuestion1;
		String idQuestionnaire1;
		String codeQuestionnaireQuestion;
		String idAnswer2;
		String idQuestionnaire2;
		String idQuestionValue2;
		String idQuestion2;
		String idPersonneFinal;
		String canalPreference;
		String idAnswer;

		String idBP = (String)inputMap.get('refClientIdBP');
		if(inputMap.get('refIdpersonne') != null){
			idPersonneFinal = String.valueOf(inputMap.get('refIdpersonne'));
		}

		if (inputMap.get('ChoixElements') != null) {
			choixElements = (Map < String, Object >)inputMap.get('ChoixElements');
		} else {
			System.debug('ChoixElements n\'existe pas');
			return;
		}

		if (choixElements.get('answer1display') != null) {
			answerChoice = (String)choixElements.get('answer1display');
		} else {
			System.debug('pas de choix de réponse');
			return;
		}

		if (choixElements.get('answer2display') != null) {
			answerChoice2 = (String)choixElements.get('answer2display');
		} else {
			System.debug('pas de choix de réponse');
			return;
		}

		/*if (inputMap.get('personnes') != null) {
			personnes = (Map < String, Object >)inputMap.get('personnes');
		} else {
			System.debug('pas de personnes');
			return;
		}

		if (personnes.get('personne1') != null) {
			personne = (Map < String, Object >)personnes.get('personne1');
		} else {
			System.debug('pas de personne');
			return;
		}

		if (personne.get('idPersonneUnifie') != '0' && personne.get('idPersonneUnifie') != null && personne.get('idPersonneUnifie') != '') {
			idPersonneFinal = String.valueOf(personne.get('idPersonneUnifie'));
		} else {
			if (personne.get('id') != null) {
				idPersonneFinal = (String)personne.get('id');
			} else {
				System.debug('pas de personne...');
				return;
			}
		}*/

		if (inputMap.get('questions') != null) {
			questions = (Map < String, Object >)inputMap.get('questions');
		} else {
			System.debug('pas de questions');
			return;
		}
		if (questions.get('question1') != null) {
			question1 = (Map < String, Object >)questions.get('question1');
		} else {
			system.debug('pas de question1');
			return;
		}

		if (question1.get('id') != null) {
			idQuestion1 = (String)question1.get('id');
		} else {
			system.debug('valeur inexistant');
			return;
		}

		if(question1.get('idQuestion') != null){
			idQuestionnaire1 = (String)question1.get('idQuestion');
		}else{
			system.debug('valeur inexistant');
			return;
		}

		Map < String, Object > question2 = new Map < String, Object >();
		if (questions.get('question2') != null) {
			question2 = (Map < String, Object >)questions.get('question2');
		} else {
			system.debug('pas de question2');
			return;
		}

		if (question2.get('id') != null) {
			idQuestion2 = (String)question2.get('id');
		} else {
			system.debug('valeur2  inexistante');
			return;
		}

		if(question2.get('idQuestion') != null){
			idQuestionnaire2 = (String)question2.get('idQuestion');
		}else{
			system.debug('valeur inexistant');
			return;
		}

		if (inputMap.get('refClientIdBP') == null || idQuestion1 == null || idQuestion2 == null) {
			System.debug('les valeurs d\'entrée ne sont pas toutes ou pas présentes');
			return;
		}

		canalPreference = 'Telephone';

		Map<String, Object> bodyRequest = new Map<String, Object>();
		if(idPersonneFinal != null){
			bodyRequest.put('idPersonne', Integer.valueOf(idPersonneFinal));
		}
		bodyRequest.put('idQuestionnaire', Integer.valueOf(idQuestionnaire1));
		bodyRequest.put('idBusinessPartner', idBP);
		bodyRequest.put('idQuestion', Integer.valueOf(idQuestion1));
		bodyRequest.put('consent', Boolean.valueOf(answerChoice));
		bodyRequest.put('canal', canalPreference);
		bodyRequest.put('application', 'SMILE');

		Map<String, Object> bodyRequest2 = new Map<String, Object>();
		bodyRequest2.put('idPersonne', Integer.valueOf(idPersonneFinal));
		bodyRequest2.put('idQuestionnaire', Integer.valueOf(idQuestionnaire2));
		bodyRequest2.put('idBusinessPartner', idBP);
		bodyRequest2.put('idQuestion', Integer.valueOf(idQuestion2));
		bodyRequest2.put('consent', Boolean.valueOf(answerChoice2));
		bodyRequest2.put('canal', canalPreference);
		bodyRequest2.put('application', 'SMILE');

		String token = SM_MP_AP04_GetTokenService.getTokenFromSmile();
		if (token == null) {
			system.debug('Token not found ...');
			return;
		}

		System.debug('@MHA body' +JSON.serialize(bodyRequest));
		System.debug('@MHA body2' +JSON.serialize(bodyRequest2));

		HttpResponse httpResponse = getResponseWrite(token, bodyRequest);
		HttpResponse httpResponse2 = getResponseWrite(token, bodyRequest2);

		/*Map < String, Object > resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
		List < Object > clientAccounts = (List < Object > ) resultAsMap.get('_data');

		if (clientAccounts.Size() == 0) {
			system.debug('No data to get the idBusinessPartner ' + inputMap.get('IdBuisnessPartner'));
			return;
		}*/
		// methode qui transform les données retournées par l'api , qui extrait les champ qu'on a besoin au niveau de l'omniscript
		/*Map<String, Object> transformedData =  transformDatatoOmniscript(clientAccounts) ;

		outMap.put('answer', transformedData);*/
	}

	/*@Author: MHA
	*@Description : Update a consentement
	*@CreatedDate : 28/09/2018
	*LastModified: MHA 17/01/2019
	*/
	public static void callModifiedConsentement(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
		Map < String, Object > questions = new Map < String, Object >();
		Map < String, Object > question1 = new Map < String, Object >();
		Map < String, Object > personnes = new Map < String, Object >();
		Map < String, Object > personne = new Map < String, Object >();
		Map < String, Object >answers = new Map< String, Object >();
		Map < String, Object >answer1 = new Map< String, Object >();
		Map < String, Object >answer2 = new Map< String, Object >();
		Map < String, Object >choixElements = new Map < String, Object >();
		/*Map < String, Object >choixCanal = new Map < String, Object >();*/

		String answerChoice;
		String answerChoice2;
		String idQuestion1;
		String idQuestionValue1;
		String idQuestionnaire1;
		String codeQuestionnaireQuestion;
		String idAnswer2;
		String idQuestionnaire2;
		String idQuestionValue2;
		String idQuestion2;
		String idPersonneFinal;
		String canalPreference;
		String idAnswer;

		String idBP = (String)inputMap.get('refClientIdBP');


		if (inputMap.get('ChoixElements') != null) {
			choixElements = (Map < String, Object >)inputMap.get('ChoixElements');
		} else {
			System.debug('ChoixElements n\'existe pas');
			return;
		}

		if (choixElements.get('answer1display') != null) {
			answerChoice = (String)choixElements.get('answer1display');
		} else {
			System.debug('pas de choix de réponse');
			return;
		}

		if (choixElements.get('answer2display') != null) {
			answerChoice2 = (String)choixElements.get('answer2display');
		} else {
			System.debug('pas de choix de réponse');
			return;
		}

		if (inputMap.get('personnes') != null) {
			personnes = (Map < String, Object >)inputMap.get('personnes');
		} else {
			System.debug('pas de personnes');
			return;
		}

		if (personnes.get('personne1') != null) {
			personne = (Map < String, Object >)personnes.get('personne1');
		} else {
			System.debug('pas de personne');
			return;
		}

		if (personne.get('idPersonneUnifie') != '0' && personne.get('idPersonneUnifie') != null && personne.get('idPersonneUnifie') != '') {
			idPersonneFinal = String.valueOf(personne.get('idPersonneUnifie'));
		} else {
			if (personne.get('id') != null) {
				idPersonneFinal = (String)personne.get('id');
			} else {
				System.debug('pas de personne...');
				return;
			}
		}

		if (inputMap.get('questions') != null) {
			questions = (Map < String, Object >)inputMap.get('questions');
		} else {
			System.debug('pas de questions');
			return;
		}
		if (questions.get('question1') != null) {
			question1 = (Map < String, Object >)questions.get('question1');
		} else {
			system.debug('pas de question1');
			return;
		}

		if (question1.get('id') != null) {
			idQuestion1 = (String)question1.get('id');
		} else {
			system.debug('valeur inexistant');
			return;
		}

		Map < String, Object > question2 = new Map < String, Object >();
		if (questions.get('question2') != null) {
			question2 = (Map < String, Object >)questions.get('question2');
		} else {
			system.debug('pas de question2');
			return;
		}

		if (question2.get('id') != null) {
			idQuestion2 = (String)question2.get('id');
		} else {
			system.debug('valeur2  inexistante');
			return;
		}

		if (inputMap.get('refClientIdBP') == null || idQuestion1 == null || idQuestion2 == null) {
			System.debug('les valeurs d\'entrée ne sont pas toutes ou pas présentes');
			return;
		}

		/*if (choixElements.get('ChoixCanal') != null) {
			choixCanal = (Map < String, Object >)choixElements.get('ChoixCanal');
		} else {
			system.debug('pas de choixCanal');
			return;
		}

		if (choixCanal.get('CanalPreference') != null) {*/
			canalPreference = 'Telephone';
		/*} else {
			system.debug('pas de canal selectionné');
			return;
		}*/


		if (inputMap.get('answers') != null) {
			answers = (Map<String, Object>)inputMap.get('answers');
		} else {
			System.debug('pas de réponses');
			return;
		}

		if (answers.get('answer1') != null) {
			answer1 = (Map<String, Object>)answers.get('answer1');
		} else {
			System.debug('pas de réponses');
			return;
		}

		if(answer1.get('id') != null){
			idAnswer = (String)answer1.get('id');
		}else{
			System.debug('pas d\'id à la question');
		}

		if(answer1.get('idQuestionnaire')!=null){
			idQuestionnaire1 = (String)answer1.get('idQuestionnaire');
		}else{
			System.debug('pas d\'id questionnaire');
		}

		if(answer1.get('idQuestion')!=null){
			idQuestionValue1 = (String)answer1.get('idQuestion');
		}else{
			System.debug('pas d\'id questionnaire');
		}

		if (answers.get('answer2') != null) {
			answer2 = (Map<String, Object>)answers.get('answer2');
		} else {
			System.debug('pas de réponses');
			return;
		}

		if(answer1.get('id') != null){
			idAnswer2 = (String)answer2.get('id');
		}else{
			System.debug('pas d\'id à la question');
		}

		if(answer2.get('idQuestionnaire')!=null){
			idQuestionnaire2 = (String)answer2.get('idQuestionnaire');
		}else{
			System.debug('pas d\'id questionnaire');
		}

		if(answer2.get('idQuestion')!=null){
			idQuestionValue2 = (String)answer2.get('idQuestion');
		}else{
			System.debug('pas d\'id questionnaire');
		}

		Map<String, Object> bodyRequest = new Map<String, Object>();
		bodyRequest.put('idPersonne', Integer.valueOf(idPersonneFinal));
		bodyRequest.put('idQuestionnaire', Integer.valueOf(idQuestionnaire1));
		bodyRequest.put('idBusinessPartner', idBP);
		bodyRequest.put('idQuestion', Integer.valueOf(idQuestionValue1));
		bodyRequest.put('consent', Boolean.valueOf(answerChoice));
		bodyRequest.put('canal', canalPreference);
		bodyRequest.put('application', 'SMILE');

		Map<String, Object> bodyRequest2 = new Map<String, Object>();
		bodyRequest2.put('idPersonne', Integer.valueOf(idPersonneFinal));
		bodyRequest2.put('idQuestionnaire', Integer.valueOf(idQuestionnaire2));
		bodyRequest2.put('idBusinessPartner', idBP);
		bodyRequest2.put('idQuestion', Integer.valueOf(idQuestionValue2));
		bodyRequest2.put('consent', Boolean.valueOf(answerChoice2));
		bodyRequest2.put('canal', canalPreference);
		bodyRequest2.put('application', 'SMILE');

		String token = SM_MP_AP04_GetTokenService.getTokenFromSmile();
		if (token == null) {
			system.debug('Token not found ...');
			return;
		}

		System.debug('@MHA body' +JSON.serialize(bodyRequest));
		System.debug('@MHA body2' +JSON.serialize(bodyRequest2));


		HttpResponse httpResponse = getResponseUpdate(token, bodyRequest, idAnswer);
		HttpResponse httpResponse2 = getResponseUpdate(token, bodyRequest2, idAnswer2);

		/*Map < String, Object > resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
		List < Object > clientAccounts = (List < Object > ) resultAsMap.get('_data');

		if (clientAccounts.Size() == 0) {
			system.debug('No data to get the idBusinessPartner ' + inputMap.get('IdBuisnessPartner'));
			return;
		}*/
		// methode qui transform les données retournées par l'api , qui extrait les champ qu'on a besoin au niveau de l'omniscript
		/*Map<String, Object> transformedData =  transformDatatoOmniscript(clientAccounts) ;

		outMap.put('answer', transformedData);*/
	}

	/*@Author: MHA
	*@Description : Creation du model
	*@CreatedDate : 28/09/2018
	*LastModified: MHA 17/01/2019
	*/
	public class ConsentementModel {
		public String id;
		public String idQuestionnaire;
		public String idQuestion;
		public String consent;
		public String canal;
		public String idBusinessPartner;
		public String idPersonne;
		public String application;
		/*public String url;*/

		/*@Author: MHA
		*@Description : Constructeur du model
		*@CreatedDate : 28/09/2018
		*LastModified: MHA 17/01/2019
		*/
		public ConsentementModel(String id, String idQuestionnaire, String idQuestion, String consent, String canal, String idBusinessPartner, String idPersonne, String application) {
			this.id = id;
			this.idQuestionnaire = idQuestionnaire;
			this.idQuestion = idQuestion;
			this.consent = consent;
			this.canal = canal;
			this.idBusinessPartner = idBusinessPartner;
			this.idPersonne = idPersonne;
			this.application = application;
		}


	}

	/*@Author: MHA
	*@Description : gestion du retour vers l'omniscript
	*@CreatedDate : 28/09/2018
	*LastModified: MHA 17/01/2019
	*/
	public static  Map<String, Object> transformDatatoOmniscript(List < Object > apiData) {
		System.debug('test2');
		Map < String, Object > transformeDataStructure = new Map < String, Object > ();
		/*List < Object > listTemp = new List < Object > ();*/
		ConsentementModel answer;
		Integer i = 1;
		for (Object obj : apiData) {
			Map < String, Object > objectX = (Map < String, Object > ) obj;
			answer = new ConsentementModel(String.valueOf(objectX.get('id')), String.valueOf(objectX.get('idQuestionnaire')), String.valueOf( objectX.get('idQuestion')), String.valueOf(objectX.get('consent')), String.valueOf(objectX.get('canal')), String.valueOf( objectX.get('idBusinessPartner')), String.valueOf( objectX.get('idPersonne')), String.valueOf( objectX.get('application')) );
			transformeDataStructure.put('answer' + i, answer);
			i++;
		}
		return transformeDataStructure ;
	}

	/*@Author: MHA
	*@Description : Construction du header en lecture
	*@CreatedDate : 28/09/2018
	*LastModified: MHA 17/01/2019
	*/
	public static HttpRequest buildHttpRequestHeaders(String token, String idPersonneFinal) {
		System.debug('test3');
		HttpRequest req = new HttpRequest();
		req.setMethod('GET');
		String endpointURL = '';
		if (!Test.isRunningTest()) {
			SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'Consentements' limit 1];
			endpointURL = 'callout:AuthAPIHour' +suffixs.suffix__c;
		}
		endpointURL = endpointURL+'?idPersonne=' + idPersonneFinal;
		req.setEndpoint(endpointURL);
		req.setHeader('X-Correlation-Id', MP_AP13_GuidUtil.NewGuid());
		if(!Test.isRunningTest()){
			req.setHeader('api_key', MP_Xdata_credentials__c.getInstance('sm_api_key_INT').Value__c);
		}
		req.setHeader('Authorization', 'Bearer ' + token);
		req.setHeader('Content-Type', 'application/json');
		return req;
	}

	/*@Author: MHA
	*@Description : Construction du header en cas de création
	*@CreatedDate : 28/09/2018
	*LastModified: MHA 17/01/2019
	*/
	public static HttpRequest buildHttpRequestHeadersPost(String token, Map<String, Object> bodyRequest) {
		HttpRequest req = new HttpRequest();
		req.setMethod('POST');
		String endpointURL = '';
		if (!Test.isRunningTest()) {
			SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'Consentements' limit 1];
			endpointURL = 'callout:AuthAPIHour' +suffixs.suffix__c;
		}
		req.setEndpoint(endpointURL);
		req.setHeader('X-Correlation-Id', MP_AP13_GuidUtil.NewGuid());
		if(!Test.isRunningTest()){
			req.setHeader('api_key', MP_Xdata_credentials__c.getInstance('sm_api_key_INT').Value__c);
		}
		req.setHeader('Authorization', 'Bearer ' + token);
		req.setHeader('Content-Type', 'application/json');
		req.setBody(JSON.serialize(bodyRequest));
		return req;
	}

	/*@Author: MHA
	*@Description : Construction du header en cas de modification
	*@CreatedDate : 28/09/2018
	*LastModified: MHA 17/01/2019
	*/
	public static HttpRequest buildHttpRequestHeadersPUT(String token, Map<String, Object> bodyRequest, String idAnswer) {
		HttpRequest req = new HttpRequest();
		req.setMethod('PUT');
		String endpointURL = '';
		if (!Test.isRunningTest()) {
			SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'Consentements' limit 1];
			endpointURL = 'callout:AuthAPIHour' +suffixs.suffix__c;
		}
		req.setEndpoint(endpointURL + '/' + idAnswer);
		req.setHeader('X-Correlation-Id', MP_AP13_GuidUtil.NewGuid());
		if(!Test.isRunningTest()){
			req.setHeader('api_key', MP_Xdata_credentials__c.getInstance('sm_api_key_INT').Value__c);
		}
		req.setHeader('Authorization', 'Bearer ' + token);
		req.setHeader('Content-Type', 'application/json');
		req.setBody(JSON.serialize(bodyRequest));
		return req;
	}

	/*@Author: MHA
	*@Description : appel HTTP
	*@CreatedDate : 28/09/2018
	*LastModified: MHA 17/01/2019
	*/
	public static HttpResponse sendData(HttpRequest request) {
		Http http = new Http();
		HttpResponse res;
		try {
			res = http.send(request);

		} catch (Exception e) {
			system.debug('## [consenstement] failed to send data ##');
			return null;
		}
		return res;

	}

	/*@Author: MHA
	*@Description : gestiond de l'erreur
	*@CreatedDate : 28/09/2018
	*LastModified: MHA 17/01/2019
	*/
	private static Boolean httpResponseFailureDetected(HttpResponse response) {
		return (response == null || (response.getStatusCode() != 201 && response.getStatusCode() != 200 && response.getStatusCode() != 206));

	}

	/*@Author: MHA
	*@Description : appel dans le cas de la lecture
	*@CreatedDate : 28/09/2018
	*LastModified: MHA 17/01/2019
	*/
	public static HttpResponse getResponse(String token, String idPersonneFinal) {

		System.debug('test4');
		HttpRequest httpReq = buildHttpRequestHeaders(token, idPersonneFinal);
		HttpResponse httpResp = sendData(httpReq);
		if (httpResponseFailureDetected(httpResp)) {
			// should abort next step's
			system.debug('## [ consentement] error occured when sending data ##');
			system.debug(httpResp != null ? httpResp.getBody() : 'http response is null');
			return null;
		}

		return httpResp;

	}

	/*@Author: MHA
	*@Description : appel dans le cas de la création
	*@CreatedDate : 28/09/2018
	*LastModified: MHA 17/01/2019
	*/
	public static HttpResponse getResponseWrite(String token, Map<String, Object> bodyRequest) {
		HttpRequest httpReq = buildHttpRequestHeadersPost(token, bodyRequest);
		HttpResponse httpResp = sendData(httpReq);
		if (httpResponseFailureDetected(httpResp)) {
			// should abort next step's
			system.debug('## [ consentement] error occured when sending data ##');
			system.debug(httpResp != null ? httpResp.getBody() : 'http response is null');
			return null;
		}

		return httpResp;

	}

	/*@Author: MHA
	*@Description : appel dans le cas de la modification
	*@CreatedDate : 28/09/2018
	*LastModified: MHA 17/01/2019
	*/
	public static HttpResponse getResponseUpdate(String token, Map<String, Object> bodyRequest, String idAnswer) {


		HttpRequest httpReq = buildHttpRequestHeadersPUT(token, bodyRequest, idAnswer);
		HttpResponse httpResp = sendData(httpReq);
		if (httpResponseFailureDetected(httpResp)) {
			// should abort next step's
			system.debug('## [ PortefeuillesContrats] error occured when sending data ##');
			system.debug(httpResp != null ? httpResp.getBody() : 'http response is null');
			return null;
		}

		return httpResp;

	}
}