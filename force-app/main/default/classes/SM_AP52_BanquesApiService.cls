/*@Auhtor: MHA
*@Description: Appel de l'API SMILE banques
*@CreatedDate: 02/01/2019
*@LastModified: MHA 02/01/2019
*/
global class SM_AP52_BanquesApiService implements vlocity_cmt.VlocityOpenInterface{
	global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outputMap, Map < String, Object > options) {
		if (methodName.equals('getInstitutBanqueByIBAN')) {
            try {
                getInstitutBanqueByIBAN(inputMap, outputMap, options);
            } catch (Exception e) {
                system.debug(e);
                return false;
            }
        }
        return true;
	}

	/*@Auhtor: MHA
    *@Description récupération du nom de la banque grâce à l'IBAN
    *@CreatedDate: 02/01/2019
    *@LastModified: MHA 02/01/2019
	*/
    public static void getInstitutBanqueByIBAN(Map < String, Object > inputMap, Map < String, Object > outputMap, Map < String, Object > options) {
    	Map<String, String> listParameters = new Map<String, String>();
    	/*Map<String, Object> serviceGestion = new Map<String, Object>();
    	if(inputMap.get('ServicesGestion') == null){
    		System.debug('pas de valeur pour le service de gestion');
    		return;
    	}else{
    		serviceGestion = (Map<String, Object>)inputMap.get('ServicesGestion');
    	}

    	Map<String, Object> editBlock1 = new Map<String, Object>();
    	if(serviceGestion.get('EditBlock1') == null){
    		System.debug('pas de valeur pour l\'EditBlock1');
    		return;
    	}else{
    		editBlock1 = (Map<String, Object>)serviceGestion.get('EditBlock1');
    	}
*/
    	String iBan;
    	if(inputMap.get('IbanNumber') == null){
    		System.debug('pas de valeur pour l\'IBAN');
    		return;
    	}else{
    		iBan = String.valueOf(inputMap.get('IbanNumber'));
            String codeGuichet = iBan.substring(4, 14);
            listParameters.put('codeBanqueGuichet', codeGuichet);
            System.debug('MHA codeGuichet:'+codeGuichet);
    		/*listParameters.put('iBAN', iBan);*/
    	}

    	String token;
        if (!Test.isRunningTest()) {
            token = SM_MP_AP04_GetTokenService.getTokenFromSmile();
        } else {
            token = 'test';
        }

        if (token == null) {
            system.debug('Token not found ...');
            return;
        }

        HttpResponse httpResponse = new HttpResponse();
        httpResponse = getResponse(token, listParameters);
        if (httpResponse != null) {
            Map < String, Object > resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
            List < Object > listResult = (List < Object > ) resultAsMap.get('_data');

            if (listResult.Size() == 0) {
                system.debug('No data to get the nomInstituBancaire ' + listResult);
                return;
            }
            // methode qui transform les données retournées par l'api , qui extrait les champ qu'on a besoin au niveau de l'omniscript
            /*transformToOutPut(listResult, outMap);*/
            Map < String, Object > result = (Map < String, Object >)listResult.get(0);
            System.debug('*** nomInstitutBancaire : ' + result.get('nomInstitutBancaire'));
            outputMap.put('nomInstitutBancaire',result.get('nomInstitutBancaire'));
            System.debug('*** output : ' + outputMap);
        }

    }

	/*@Auhtor: MHA
    *@Description: construction du header de la requête
    *@CreatedDate: 02/01/2019
    *@LastModified: MHA 02/01/2019
	*/
	public static HttpRequest buildHttpRequestHeaders(String token, Map<String, String> listParameters) {
		HttpRequest req = new HttpRequest();
		req.setMethod('GET');
		req.setEndpoint(buildEndPoint(listParameters));
		req.setHeader('X-Correlation-Id', MP_AP13_GuidUtil.NewGuid());
        if(!Test.isRunningTest()){
            req.setHeader('api_key', MP_Xdata_credentials__c.getInstance('sm_api_key_INT').Value__c);
        }
		req.setHeader('Authorization', 'Bearer ' + token);
		req.setHeader('Content-Type', 'application/json');
        System.debug('Request =>'+req);
		return req;
	}

	/*@Auhtor: MHA
    *@Description: construction de l'adresse d'appel
    *@CreatedDate: 02/01/2019
    *@LastModified: MHA 02/01/2019
	*/
	public static String buildEndPoint(Map<String, String> listParameters) {
        String endPoint = '';
        if (!Test.isRunningTest()) {
            SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'Banques' limit 1];
            endPoint = 'callout:AuthAPIHour' +suffixs.suffix__c;
        }

        if (listParameters.size() > 0) {
            endPoint = endPoint + '?';
            Set<String> queryParamsKeys = listParameters.keySet();
            for (String key : queryParamsKeys) {
                endPoint = endPoint + key + '=' + listParameters.get(key) + '&';
            }
            endPoint = endPoint.substring(0, endPoint.length() - 1);

        }
        system.debug('[buildEndPoint]' + endPoint);
        return endPoint;
    }

	/*@Auhtor: MHA
    *@Description: appel de l'api en HTTP
    *@CreatedDate: 02/01/2019
    *@LastModified: MHA 02/01/2019
	*/
	public static HttpResponse sendData(HttpRequest request) {
		Http http = new Http();
		HttpResponse res;
		try {
			res = http.send(request);

		} catch (Exception e) {
			system.debug('## [banque] failed to send data ##');
			return null;
		}
		return res;

	}

	private static Boolean httpResponseFailureDetected(HttpResponse response) {
		return (response == null || (response.getStatusCode() != 201 && response.getStatusCode() != 200 && response.getStatusCode() != 206));
	}

	/*@Auhtor: MHA
    *@Description: appel de l'api
    *@CreatedDate: 02/01/2019
    *@LastModified: MHA 02/01/2019
	*/
	public static HttpResponse getResponse(String token, Map<String, String> listParameters) {


		HttpRequest httpReq = buildHttpRequestHeaders(token, listParameters);
		HttpResponse httpResp = sendData(httpReq);
		if (httpResponseFailureDetected(httpResp)) {
			// should abort next step's
			system.debug('## [ banque] error occured when sending data ##');
			system.debug(httpResp != null ? httpResp.getBody() : 'http response is null');
			return null;
		}

		return httpResp;

	}
}