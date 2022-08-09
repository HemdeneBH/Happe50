global class SM_AP78_TranquilityApiService implements vlocity_cmt.VlocityOpenInterface {
    private static String smUserTranquility;
    private static String smPasswordTranquility;
    static {
        smUserTranquility = MP_Xdata_credentials__c.getInstance('sm_user_tranquility').Value__c;
        smPasswordTranquility = MP_Xdata_credentials__c.getInstance('sm_password_tranquility').Value__c;
	}


	global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
		if (methodName.equals('callTranquility')) {
			try {
				callTranquility(inputMap);
			} catch (Exception e) {
				system.debug(e);
				return false;
			}
		}
		return true;
	}

    @AuraEnabled(cacheable=false)
    public static Map < String, Object > callTranquility(Map<String,Object> inputMap) {
        Map < String, Object > outMap  = new Map<String, Object>();
        // check bp client
        if (inputMap.get('bpClient') == null || String.valueOf(inputMap.get('bpClient')).length() == 0) {
            system.debug('bpClient is not found ...');
            return outMap;
        }

        // check street
        if (inputMap.get('rue') == null || String.valueOf(inputMap.get('rue')).length() == 0) {
            system.debug('rue is not found ...');
            return outMap;
        }

        //check zipCode
        if (inputMap.get('codePostal') == null || String.valueOf(inputMap.get('codePostal')).length() == 0) {
            system.debug('codePostal is not found ...');
            return outMap;
        }

        //check City
        if (inputMap.get('commune') == null || String.valueOf(inputMap.get('commune')).length() == 0) {
            system.debug('commune is not found ...');
            return outMap;
        }

        // system.debug('@@ SM_AP78 inputMap ' +inputMap);
        String token = SM_MP_AP04_GetTokenService.getTokenFromSmile();
        if (token == null) {
            system.debug('Token not found ...');
            return outMap;
        }
        // system.debug('@@ tokenTranquility '+token);
        HttpResponse httpResponse = getResponse(token);
        // system.debug('@@ httpResponse '+httpResponse);
        Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(httpResponse.getBody());
        // system.debug('@@ resultAsMap '+resultAsMap);
        Map<String,Object> beerer = ( Map<String,Object> ) resultAsMap.get('data');
        String tokenTranquility =  (String)  beerer.get('token');
        // system.debug('@@ beerer '+beerer);
        // system.debug('@@ m '+tokenTranquility);
        HttpResponse getResponseTranquility = getResponseTranquility(token, tokenTranquility, inputMap);
        Map<String,Object> resultAsMapTranquility = (Map<String,Object>) JSON.deserializeUntyped(getResponseTranquility.getBody());
        // system.debug('@@ resultAsMapTranquility '+resultAsMapTranquility);        

        return resultAsMapTranquility;
    }

    public static HttpResponse getResponse(String token) {
        HttpRequest httpReq = buildHttpRequestHeaders(token);
        HttpResponse httpResp = sendData(httpReq);
        if (httpResponseFailureDetected(httpResp)) {
            // should abort next step's
            system.debug('## [Contrats] error occured when sending data ##');
            system.debug(httpResp != null ? httpResp.getBody() : 'http response is null');
            return null;
        }
        return httpResp;
    }

    public static HttpResponse getResponseTranquility(String token, String tokenTranquility, Map<String,Object> inputMap) {
        HttpRequest httpReq = buildHttpRequestHeadersTranquility(token, tokenTranquility, inputMap);
        HttpResponse httpResp = sendData(httpReq);
        if (httpResponseFailureDetected(httpResp)) {
            // should abort next step's
            system.debug('## [Contrats] error occured when sending data ##');
            system.debug(httpResp != null ? httpResp.getBody() : 'http response is null');
            return null;
        }
        return httpResp;
    }

    public static HttpResponse sendData(HttpRequest request) {
        Http http = new Http();
        HttpResponse res;
        try {
            res = http.send(request);
        } catch (Exception e) {
            system.debug('## [LocauxContrats] failed to send data ##');
            return null;
        }
        return res;

    }

    public static HttpRequest buildHttpRequestHeaders(String token) {
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        
        
        String endPoint = 'userLoginTranquility';
        if (!Test.isRunningTest()) {
            SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'userLoginTranquility' limit 1];
            endPoint = 'callout:AuthAPIHour' +suffixs.suffix__c;           
        }
        req.setEndpoint(endPoint);
        // System.debug('*** Endpoint : ' + req.getEndpoint());
        req.setHeader('X-Correlation-Id', MP_AP13_GuidUtil.NewGuid());
        req.setHeader('api_key', MP_Xdata_credentials__c.getInstance('sm_api_key_INT').Value__c);
        req.setHeader('Authorization', 'Bearer ' + token);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setHeader('Accept', 'application/json');
        //Body
        Map < String, String > values = new Map < String, String > ();
		values.put('gaia', smUserTranquility);
		values.put('mdp', smPasswordTranquility);	
		req.setBody(encodeFormData(values));
        // System.debug('*** req : ' + req);
        return req;
    }

    public static HttpRequest buildHttpRequestHeadersTranquility(String tokenAPIHour, String tokenTranquility, Map<String,Object> inputMap) {
        HttpRequest req = new HttpRequest();
        String temps = '';
        req.setMethod('POST');
        String endPoint = 'tranquilityGetContratsByAdresse';
        if (!Test.isRunningTest()) {
            SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'tranquilityGetContratsByAdresse' limit 1];
            endPoint = 'callout:AuthAPIHour' +suffixs.suffix__c;           
        }
        req.setEndpoint(endPoint);
        // System.debug('*** Endpoint : ' + req.getEndpoint());
        req.setHeader('X-Correlation-Id', MP_AP13_GuidUtil.NewGuid());
        req.setHeader('api_key', MP_Xdata_credentials__c.getInstance('sm_api_key_INT').Value__c);
        req.setHeader('Authorization', 'Bearer ' + tokenAPIHour);
        req.setHeader('x-Authorization', tokenTranquility);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        //Body
		temps='{"bpClient": "' + inputMap.get('bpClient') +'", "localAssure": { "numRue": "' + inputMap.get('numRue') +'", "rue": "' + inputMap.get('rue') +'", "codePostal": "' + inputMap.get('codePostal') +'", "commune": "' + inputMap.get('commune') +'", "pays": "FR" }, "idConsomateur": "SMILE"}';
        req.setBody(temps);
        // System.debug('*** req reponse 2 : ' + req);
        return req;
    }

    private static String encodeFormData(Map < String, String > values) {
		String result = '';
		for (String thisKey : values.keySet()) {
			result += EncodingUtil.urlEncode(thisKey, 'UTF-8') + '=' + EncodingUtil.urlEncode(values.get(thisKey), 'UTF-8') + '&';
		}
        // System.debug('*** url 1 : ' + result);

		return result.removeEnd('&');
	}


    private static Boolean httpResponseFailureDetected(HttpResponse response) {
        return (response == null || (response.getStatusCode() != 201 && response.getStatusCode() != 200 && response.getStatusCode() != 206));
    }

}