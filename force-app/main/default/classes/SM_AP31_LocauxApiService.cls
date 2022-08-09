global class SM_AP31_LocauxApiService implements vlocity_cmt.VlocityOpenInterface {

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        if (methodName.equals('callLocaux')) {
            try {
                callLocaux(inputMap, outMap, options);
            } catch (Exception e) {
                system.debug('Exception: ' + e);
                return false;
            }
        }
        else if(methodName.equals('getIdNewLocal')){
            try {
                getIdNewLocal(inputMap, outMap, options);
            } catch (Exception e) {
                system.debug('Exception: ' + e);
                return false;
            }
        }
        return true;
    }

    public static void callLocaux(Map<String,Object> inputMap, Map<String,Object> outMap, Map <String,Object> options) {
        if (inputMap.get('numeroLocal') == null || String.valueOf(inputMap.get('numeroLocal')).length() == 0) {
            system.debug('numeroLocal is not found ...');
            return;
        }
        String token = '';
        if(!Test.isRunningTest()){
          	token = SM_MP_AP04_GetTokenService.getTokenFromSmile();
        }
        else{
            token ='12345';
        } 
        if (token == null) {	
            system.debug('Token not found ...');
            return;
        }

        HttpResponse httpResponse = getResponse(token, String.valueOf(inputMap.get('numeroLocal')),false);
        system.debug('@@ httpResponse '+httpResponse);
        if(httpResponse!=null){
             Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(httpResponse.getBody());
            system.debug('@@ resultAsMap '+resultAsMap);       
            if (resultAsMap.Size() == 0) {              
                system.debug('No data to get the idPersonne' + inputMap.get('idPersonne'));
                outMap.put('resultdata', new  List<Object>());
            }
           else {
                system.debug('@@ locaux OK');             
                outMap.put('resultdata', resultAsMap);            
            } 
        }
        else{
            outMap.put('numeroLocal', null);     
        }
       
        system.debug('### MGH :: ' + outMap);
    }

    public static void getIdNewLocal(Map<String,Object> inputMap, Map<String,Object> outMap, Map <String,Object> options) {
        if (inputMap.get('numeroLocal') == null || String.valueOf(inputMap.get('numeroLocal')).length() == 0) {
            system.debug('[SM_AP31_LocauxApiService:getIdNewLocal] - numeroLocal is not found ...');
            throw new IOException('Numero du local non trouvé');
        }
        String token = '';
        if(!Test.isRunningTest()){
          	token = SM_MP_AP04_GetTokenService.getTokenFromSmile();
        }
        else{
            token ='12345';
        } 
        if (token == null) {	
            system.debug('Token not found ...');
            return;
        }

        HttpResponse httpResponse = getResponse(token, String.valueOf(inputMap.get('numeroLocal')),true);
        system.debug('@@ httpResponse '+httpResponse);
        if(httpResponse!=null){
			Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(httpResponse.getBody());
            system.debug('@@ resultAsMap '+resultAsMap);       
            if (resultAsMap.Size() == 0) {              
                system.debug('[SM_AP31_LocauxApiService:getIdNewLocal] - idLocal is not found ...');
                throw new IOException('Local non trouvé');
            }
           else {
               List < Object > listeRetourAPI = (List < Object > ) resultAsMap.get('_data');
               if(listeRetourAPI.size()==0){
                   system.debug('[SM_AP31_LocauxApiService:getIdNewLocal] - idLocal is not found ...');
                   throw new IOException('Local non trouvé');
               }
               Map<String, Object> localAPI = (Map<String,Object>) listeRetourAPI.get(0);
               outMap.put('idLocal',  String.valueOf(localAPI.get('id')));
            }
        }
        else{
            throw new IOException('Problème lors de la récupération des données du local');
        }
       
        system.debug('### MGH :: ' + outMap);
    }
    
    public class IOException extends Exception {
    }

    public static HttpRequest buildHttpRequestHeaders(String token, String numeroLocal) {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        String endpointURL = '';
        if (!Test.isRunningTest()) {
            SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'Locaux' limit 1];
            endpointURL = 'callout:AuthAPIHour' +suffixs.suffix__c;
        }
       req.setEndpoint(endpointURL + '/' + numeroLocal);
        //req.setEndpoint(endpointURL + '/' + '11111111111111111');       
        req.setHeader('X-Correlation-Id', MP_AP13_GuidUtil.NewGuid());
        req.setHeader('api_key', MP_Xdata_credentials__c.getInstance('sm_api_key_INT').Value__c);
        req.setHeader('Authorization', 'Bearer ' + token);
        req.setHeader('Content-Type', 'application/json');
        return req;
    }
    
    public static HttpRequest buildHttpRequestHeadersWithParams(String token, String numeroLocal) {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        String endpointURL = '';
        if (!Test.isRunningTest()) {
            SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'Locaux' limit 1];
            endpointURL = 'callout:AuthAPIHour' +suffixs.suffix__c;
        }
        req.setEndpoint(endpointURL + '?numeroLocal=' + numeroLocal);
        req.setHeader('X-Correlation-Id', MP_AP13_GuidUtil.NewGuid());
        if (!Test.isRunningTest()) {
        	req.setHeader('api_key', MP_Xdata_credentials__c.getInstance('sm_api_key_INT').Value__c);
        }
        req.setHeader('Authorization', 'Bearer ' + token);
        req.setHeader('Content-Type', 'application/json');
        return req;
    }

    public static HttpResponse sendData(HttpRequest request) {
        Http http = new Http();
        HttpResponse res;
        try {
            if(!Test.isRunningTest()){
                res = http.send(request);
            }
            else{
                StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
                mock.setStaticResource('SM_MockResponseApiLocal');
                mock.setStatusCode(200);
                mock.setHeader('Content-Type', 'application/json');
                // Set the mock callout mode
                system.debug('sendData mock : '+mock);
                Test.setMock(HttpCalloutMock.class, mock);
                res = http.send(request);
            }
        } catch (Exception e) {
            system.debug('## [Locaux] failed to send data ##');
            return null;
        }
        return res;

    }

    private static Boolean httpResponseFailureDetected(HttpResponse response) {
        return (response == null || (response.getStatusCode() != 201 && response.getStatusCode() != 200 && response.getStatusCode() != 206));

    }

    public static HttpResponse getResponse(String token, String numeroLocal,Boolean isNewLocal) {
        HttpRequest httpReq = isNewLocal ? buildHttpRequestHeadersWithParams(token, numeroLocal) : buildHttpRequestHeaders(token, numeroLocal) ;
        HttpResponse httpResp = sendData(httpReq);
        if (httpResponseFailureDetected(httpResp)) {
            system.debug('## [Locaux] error occured when sending data ##');
            return null;
        }
        return httpResp;
    }

}