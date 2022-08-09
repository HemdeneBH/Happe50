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

        HttpResponse httpResponse = new HttpResponse();
        httpResponse = getResponse(listParameters);
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
    *@Description: construction de l'adresse d'appel
    *@CreatedDate: 02/01/2019
    *@LastModified: MHA 02/01/2019
	*/
	public static String buildRequestParams(Map<String, String> listParameters) {
        String endPoint = '';
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
    *@Description: appel de l'api
    *@CreatedDate: 02/01/2019
    *@LastModified: MHA 02/01/2019
	*/
	public static HttpResponse getResponse(Map<String, String> listParameters) {

		String endpointParams = buildRequestParams(listParameters);
		HttpResponse httpResp = CalloutManager.sendRequest('Banques', endpointParams, 'GET', CalloutManager.Scope.READ, null,null);
		if (CalloutManager.httpResponseFailureDetected(httpResp)) {
			// should abort next step's
			system.debug('## [ banque] error occured when sending data ##');
			system.debug(httpResp != null ? httpResp.getBody() : 'http response is null');
			return null;
		}

		return httpResp;

	}
}