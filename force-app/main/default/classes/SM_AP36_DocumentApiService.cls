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

		HttpResponse httpResponse = getResponse(idFacture,null);
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

		HttpResponse httpResponse = getResponse(idFacture,null);
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

		HttpResponse httpResponse = getResponse(null,idMandat);
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

	public static String buildRequestParams(String idFacture,String idMandat) {
		String endpointParams='';
		if(!String.isBlank(idFacture))
			endpointParams += '?size=1&idFacture=' + idFacture;
		else if(!String.isBlank(idMandat))
			endpointParams += '?size=1&idMandat=' + idMandat;
		
		return endpointParams;
	}

	public static HttpResponse getResponse(String idFacture,String idMandat) {
		String endpointParams = buildRequestParams(idFacture,idMandat);
		HttpResponse httpResp = CalloutManager.sendRequest('Documents', endpointParams, 'GET', CalloutManager.Scope.READ, null,null);
		if (CalloutManager.httpResponseFailureDetected(httpResp)) {
			// should abort next step's
			system.debug('## [ factures] error occured when sending data ##');
			system.debug(httpResp != null ? httpResp.getBody() : 'http response is null');
			return null;
		}

		return httpResp;

	}
}