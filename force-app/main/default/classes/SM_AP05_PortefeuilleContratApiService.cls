global class SM_AP05_PortefeuilleContratApiService implements vlocity_cmt.VlocityOpenInterface{

    global Boolean invokeMethod (String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        if (methodName.equals('callPortefeuilleContrat')) {
            try {
                callPortefeuilleContrat(inputMap, outMap, options);
            } catch (Exception e) {
                system.debug(e);
                return false;
            }
        }
        return true;
    }

    public static void callPortefeuilleContrat (Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        if (inputMap.get('idPortefeuilleContrat') == null || String.valueOf(inputMap.get('idPortefeuilleContrat')).length() == 0) {
            system.debug('idPortefeuilleContrat is not found ...');
            return;
        }
        String token = SM_MP_AP04_GetTokenService.getTokenFromSmile();
        if (token == null) {
            system.debug('Token not found ...');
            return;
        }
        HttpResponse httpResponse = getResponse(token, (String) inputMap.get('idPortefeuilleContrat'));
        Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(httpResponse.getBody());
        if (resultAsMap.Size() == 0) {
            system.debug('No data to get the idPortefeuilleContrat ' + inputMap.get('idPortefeuilleContrat'));
            return;
        }
        outMap.put('data', new PortefeuilleContratModel((String) resultAsMap.get('conditionPaiement')));
        system.debug('## [idPortefeuilleContrat] Result te be returned ' + outMap);
    }

    public class PortefeuilleContratModel {
        public String conditionPaiement;

        public PortefeuilleContratModel(String conditionPaiement) {
            this.conditionPaiement = conditionPaiement;
        }
    }

    public static HttpRequest buildHttpRequestHeaders(String token, String idPortefeuilleContrat) {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        String endpointURL = '';
        if (!Test.isRunningTest()) {
            SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'Portefeuilles_Contrats' limit 1];
        	endpointURL = 'callout:AuthAPIHour' +suffixs.suffix__c;
        }
        req.setEndpoint(endpointURL + '/' + idPortefeuilleContrat);
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
            system.debug('## [PortefeuilleContrat] failed to send data ##');
            return null;
        }
        return res;
    }

    private static Boolean httpResponseFailureDetected(HttpResponse response) {
        return (response == null || (response.getStatusCode() != 201 && response.getStatusCode() != 200 && response.getStatusCode() != 206));
    }

    public static HttpResponse getResponse(String token, String idPortefeuilleContrat) {
        HttpRequest httpReq = buildHttpRequestHeaders(token, idPortefeuilleContrat);
        HttpResponse httpResp = sendData(httpReq);
        if (httpResponseFailureDetected(httpResp)) {
            // should abort next step's
            system.debug('## [PortefeuilleContrat] error occured when sending data ##');
            system.debug(httpResp != null ? httpResp.getBody() : 'http response is null');
            return null;
        }
        return httpResp;
    }
}