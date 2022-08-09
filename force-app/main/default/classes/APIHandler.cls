public with sharing class APIHandler {
    public static String getToken(){
        String token = '';
        if(!Test.isRunningTest()){
			token = SM_MP_AP04_GetTokenService.getTokenFromSmile();
		}else{
			token = 'test';
		}

        return token;
    }

    public static List<Object> callAPI(String api, String params, String method){
        String endpointURL = '';
        List<Object> listObject = null;

        if (!Test.isRunningTest()) {
            SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername =: api limit 1];
        	endpointURL = 'callout:AuthAPIHour' +suffixs.suffix__c;
        }

        endpointURL = (String.isBlank(params)) ? endpointURL : endpointURL + '?' + params;

        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointURL);
		req.setHeader('X-Correlation-Id', MP_AP13_GuidUtil.NewGuid());
		req.setHeader('api_key', MP_Xdata_credentials__c.getInstance('sm_api_key_INT').Value__c);
		req.setHeader('Authorization', 'Bearer ' + getToken());
		req.setHeader('Content-Type', 'application/json');
        req.setMethod(method);

        System.debug('*** Full endpointURL : ' + endpointURL);

        Http http = new Http();
		HttpResponse res;

		try {
			res = http.send(req);
		} catch (Exception e) {
            System.debug('*** Erreur de récupération des données lors du call API : ' + e);
			return null;
		}

        if(res != null){
			Map < String, Object > resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(res.getBody());
			listObject = (List < Object > ) resultAsMap.get('_data');
        }

        return listObject;
    }
}