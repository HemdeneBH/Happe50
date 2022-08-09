global class SM_AP29_PersonnesAPI implements vlocity_cmt.VlocityOpenInterface {
	global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

		if (methodName.equals('callPersonne')) {
			try {
				callPersonne(inputMap, outMap, options);
				// your implementation, use outMap to send response back to OmniScriC:\Users\HN5803\Documents\Smile\src\SM_AP32_PersonnesLocauxAPI.apxcpt
			} catch (Exception e) {
				system.debug(e);
				return false;
			}
		}

		return true;
	}

	public static void callPersonne(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
		String idBusinessPartner = String.valueOf(inputMap.get('refClientIdBP'));
		Integer size = idBusinessPartner.length();
        String idBP = idBusinessPartner;
        if(size <10){
            Integer difference = 10 -size;
            for(Integer i = 0; i<difference; i++ ){
                idBP = '0'+idBP;
            }
        }
		if (idBusinessPartner == null || idBP.length() == 0) {
			system.debug('idBusinessPartner is not found ...');
			return;
		}

		String token = SM_MP_AP04_GetTokenService.getTokenFromSmile();
		if (token == null) {
			system.debug('Token not found ...');
			return;
		}
		HttpResponse httpResponse = getResponse(token, idBP);

		Map < String, Object > resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
		List < Object > clientAccounts = (List < Object > ) resultAsMap.get('_data');

		if (clientAccounts.Size() == 0) {
			system.debug('No data to get the idBusinessPartner ' + idBP);
			return;
		}
		// methode qui transform les données retournées par l'api , qui extrait les champ qu'on a besoin au niveau de l'omniscript
		Map<String, Object> transformedData =  transformDatatoOmniscript(clientAccounts) ;

		outMap.put('personnes', transformedData);
	}

	public class PersonneModel {
		public String id;
		public String idPersonneUnifie;
		public String idBusinessPartner;

		public PersonneModel(String id, String idPersonneUnifie, String idBusinessPartner ) {
			this.id = id;
			this.idPersonneUnifie = idPersonneUnifie;
			this.idBusinessPartner = idBusinessPartner;
		}


	}

	public static  Map<String, Object> transformDatatoOmniscript(List < Object > apiData) {

		Map < String, Object > transformeDataStructure = new Map < String, Object > ();
		List < Object > listTemp = new List < Object > ();
		Integer i = 1;
		for (Object obj : apiData) {
			Map < String, Object > objectX = (Map < String, Object > ) obj;
			PersonneModel personneValue = new PersonneModel(String.valueOf(objectX.get('id')), String.valueOf(objectX.get('idPersonneUnifiee')), String.valueOf(objectX.get('idBusinessPartner')));
			transformeDataStructure.put('personne'+i, personneValue);
			i++;
		}
		/*transformeDataStructure.put('personne', listTemp);*/
		return transformeDataStructure ;
	}

	public static HttpRequest buildHttpRequestHeaders(String token, String idBusinessPartner) {
		HttpRequest req = new HttpRequest();
		req.setMethod('GET');
		String endpointURL = '';
		if (!Test.isRunningTest()) {
			SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'Personnes' limit 1];
			endpointURL = 'callout:AuthAPIHour' +suffixs.suffix__c;
		}
		req.setEndpoint(endpointURL+'?idBusinessPartner=' + idBusinessPartner);
		req.setHeader('X-Correlation-Id', MP_AP13_GuidUtil.NewGuid());
		req.setHeader('api_key', MP_Xdata_credentials__c.getInstance('sm_api_key_INT').Value__c);
		req.setHeader('Authorization', 'Bearer ' + token);
		req.setHeader('Content-Type', 'application/json');
		return req;
	}


	public static HttpResponse sendData(HttpRequest request) {
		Http http = new Http();
		HttpResponse res;
		try {
			res = http.send(request);

		} catch (Exception e) {
			system.debug('## [PortefeuillesContrats] failed to send data ##');
			return null;
		}
		return res;

	}

	private static Boolean httpResponseFailureDetected(HttpResponse response) {
		return (response == null || (response.getStatusCode() != 201 && response.getStatusCode() != 200 && response.getStatusCode() != 206));
	}

	public static HttpResponse getResponse(String token, String idBusinessPartner) {


		HttpRequest httpReq = buildHttpRequestHeaders(token, idBusinessPartner);
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