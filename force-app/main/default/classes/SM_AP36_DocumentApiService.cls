global class SM_AP36_DocumentApiService {

	@AuraEnabled(cacheable=false)
	public static Map < String, Object > callFactureLWC(Map < String, Object > inputMap) {
		System.debug('*** inputMap : ' + inputMap);
		Map < String, Object > outMap  = new Map<String, Object>();
		if (inputMap.get('idFacture') == null || String.valueOf(inputMap.get('idFacture')).length() == 0) {
			system.debug('idFacture not found ...');
			return outMap;
		}
		String idFacture = String.valueOf(inputMap.get('idFacture'));
		/*String idMandat;*/
		String param;
		if(idFacture != null){
			param = idFacture;
		}
		

		String token;
		if(!Test.isRunningTest()){
			token = SM_MP_AP04_GetTokenService.getTokenFromSmile();
		}
		else{
			token = 'test';
		}

		if (token == null) {
			system.debug('Token not found ...');
			return outMap;
		}

		HttpResponse httpResponse = getResponse(token, (String)param);
		if(httpResponse != null){
			Map < String, Object > resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
			List < Object > documentList = (List < Object > ) resultAsMap.get('_data');

			if (documentList.Size() == 0) {
				system.debug('No data to get the idFacture');
			}
			else{
				outMap.put('data', documentList);
				System.debug('*** output : ' + outMap);
			}
		}

		return outMap;
	}

	public static void callFacture(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
		System.debug('*** inputMap : ' + inputMap);
		
		if (inputMap.get('idFacture') == null || String.valueOf(inputMap.get('idFacture')).length() == 0) {
			system.debug('idFacture not found ...');
			return;
		}
		String idFacture = String.valueOf(inputMap.get('idFacture'));
		/*String idMandat;*/
		String param;
		if(idFacture != null){
			param = idFacture;
		}
		

		String token;
		if(!Test.isRunningTest()){
			token = SM_MP_AP04_GetTokenService.getTokenFromSmile();
		}
		else{
			token = 'test';
		}

		if (token == null) {
			system.debug('Token not found ...');
			return;
		}

		HttpResponse httpResponse = getResponse(token, (String)param);
		if(httpResponse != null){
			Map < String, Object > resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
			List < Object > documentList = (List < Object > ) resultAsMap.get('_data');

			if (documentList.Size() == 0) {
				system.debug('No data to get the idFacture');
			}
			else{
				outMap.put('data', documentList);
				System.debug('*** output : ' + outMap);
			}
		}
	}

	public static void callMandats(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
		System.debug('*** inputMap : ' + inputMap);

		if (inputMap.get('idMandat') == null || String.valueOf(inputMap.get('idMandat')).length() == 0) {
			system.debug('idMandats not found ...');
			return;
		}
		String idMandat = String.valueOf(inputMap.get('idMandat'));
		/*String idMandat;*/
		String param;
		if(idMandat != null){
			param = idMandat;
		}

		String token;
		if(!Test.isRunningTest()){
			token = SM_MP_AP04_GetTokenService.getTokenFromSmile();
		}else{
			token = 'test';
		}

		if (token == null) {
			system.debug('Token not found ...');
			return;
		}

		HttpResponse httpResponse = getResponse1(token, (String)param);
		if(httpResponse != null){
			Map < String, Object > resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
			List < Object > documentList = (List < Object > ) resultAsMap.get('_data');

			if (documentList.Size() == 0) {
				system.debug('No data to get the idMandat');
			}
			else{
				outMap.put('data1', documentList);
				System.debug('*** output : ' + outMap);
			}
		}
	}

	public class FactureModel {
		public String idDoc;
		public String url;

		public FactureModel(String idDoc, String url) {
			this.idDoc = idDoc;
			this.url = url;
		}
	}

	public static HttpRequest buildHttpRequestHeaders(String token, String param) {
		HttpRequest req = new HttpRequest();
		req.setMethod('GET');
		String endpointURL = '';
		
		SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'Documents' limit 1];
		endpointURL = 'callout:AuthAPIHour' +suffixs.suffix__c;
		
		req.setEndpoint(endpointURL + '?size=1&idFacture=' + param);
		req.setHeader('X-Correlation-Id', MP_AP13_GuidUtil.NewGuid());
		req.setHeader('api_key', MP_Xdata_credentials__c.getInstance('sm_api_key_INT').Value__c);
		req.setHeader('Authorization', 'Bearer ' + token);
		req.setHeader('Content-Type', 'application/json');
		return req;
	}

	public static HttpRequest buildHttpRequestHeaders1(String token, String param) {
		HttpRequest req = new HttpRequest();
		req.setMethod('GET');
		String endpointURL = '';

		SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'Documents' limit 1];
		endpointURL = 'callout:AuthAPIHour' +suffixs.suffix__c;

		req.setEndpoint(endpointURL + '?size=1&idMandat=' + param);
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
			system.debug('## [Factures] failed to send data ##');
			return null;
		}
		return res;

	}

	private static Boolean httpResponseFailureDetected(HttpResponse response) {
		return (response == null || (response.getStatusCode() != 201 && response.getStatusCode() != 200 && response.getStatusCode() != 206));

	}

	public static HttpResponse getResponse(String token, String param) {
		HttpRequest httpReq = buildHttpRequestHeaders(token, param);
		HttpResponse httpResp = sendData(httpReq);
		if (httpResponseFailureDetected(httpResp)) {
			// should abort next step's
			system.debug('## [ factures] error occured when sending data ##');
			system.debug(httpResp != null ? httpResp.getBody() : 'http response is null');
			return null;
		}

		return httpResp;

	}

	public static HttpResponse getResponse1(String token, String param) {
		HttpRequest httpReq = buildHttpRequestHeaders1(token, param);
		HttpResponse httpResp = sendData(httpReq);
		if (httpResponseFailureDetected(httpResp)) {
			// should abort next step's
			system.debug('## [ factures] error occured when sending data ##');
			system.debug(httpResp != null ? httpResp.getBody() : 'http response is null');
			return null;
		}

		return httpResp;

	}
}