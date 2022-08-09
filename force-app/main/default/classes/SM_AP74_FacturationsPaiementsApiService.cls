public class SM_AP74_FacturationsPaiementsApiService {
    @AuraEnabled(cacheable=false)
    public static Map < String, Object > callFacturationsPaiements(Map<String,Object> inputMap) {
        Map < String, Object > outMap  = new Map<String, Object>();
        system.debug('@@ SM_AP74 inputMap ' +inputMap);
        
        if (inputMap.get('idsPortefeuilleContrat') == null || String.valueOf(inputMap.get('idsPortefeuilleContrat')).length() == 0) {
            system.debug('idsPortefeuilleContrat is not found ...');
            return outMap;
        }
        String token;
        if(!Test.isRunningTest()){
            token = SM_MP_AP04_GetTokenService.getTokenFromSmile();
        }else{
            token = 'test';
        }
        if (token == null) {
            system.debug('Token not found ...');
            return outMap;
        }
        // HttpResponse httpResponse = getResponse(token, String.valueOf(inputMap.get('idsPortefeuilleContrat')), null);
        HttpResponse httpResponse = new HttpResponse();
        if(Test.isRunningTest()){
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('SM_MockTestFacturationPaiement');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json');
            // system.debug('@@ mock '+mock);
            // Set the mock callout mode
            Test.setMock(HttpCalloutMock.class, mock);
            httpResponse = getResponse(token, String.valueOf(inputMap.get('idsPortefeuilleContrat')), null);
        }else{
            httpResponse = getResponse(token, String.valueOf(inputMap.get('idsPortefeuilleContrat')), null);
        }
        
        
        
        // system.debug('@@ httpResponse '+httpResponse);
        if(httpResponse != null){
            Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(httpResponse.getBody());
            // system.debug('@@ resultAsMap '+resultAsMap);
            List<Object> FacturationsPaiements = (List <Object> ) resultAsMap.get('_data');
            // system.debug('@@ FacturationsPaiements '+FacturationsPaiements);
            if (FacturationsPaiements.Size() == 0) {
                system.debug('No data to get the idsPortefeuilleContrat ' + inputMap.get('idsPortefeuilleContrat'));
                //return;
                outMap.put('resultdata', new  List<Object>());
            }
        else{
                // List<Object> transformedData = transformDataToCard(contracts) ;
                outMap.put('resultdata', FacturationsPaiements);
                // outMap.put('nombreRythmeFacturation',transformedData.size() == 1 ? 'OK' :'NOK' ) ;
        
                
            }
            // system.debug('### MGH :: ' + outMap);
        }
        return outMap;
    }

    public static HttpResponse getResponse(String token, String idBusinessPartner, String idPersonne) {
        HttpRequest httpReq = buildHttpRequestHeaders(token, idBusinessPartner, idPersonne);
        HttpResponse httpResp = sendData(httpReq);
        if (httpResponseFailureDetected(httpResp)) {
            // should abort next step's
            system.debug('## [FacturationsPaiements] error occured when sending data ##');
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
            system.debug(e.getMessage());
            system.debug(e.getStackTraceString());
            system.debug('## [FacturationsPaiements] failed to send data ##');
            return null;
        }
        return res;

    }

    public static HttpRequest buildHttpRequestHeaders(String token, String idsPortefeuilleContrat, String idPersonne) {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        
        
        String endPoint = 'FacturationsPaiements';
        if (!Test.isRunningTest()) {
            SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'FacturationsPaiements' limit 1];
            endPoint = 'callout:AuthAPIHour' +suffixs.suffix__c;           
        }
        if(!String.isBlank(idsPortefeuilleContrat)){
            // System.debug('*** Call with idsPortefeuilleContrat = ' + idsPortefeuilleContrat);
            req.setEndpoint(endPoint + '?idsPortefeuilleContrat=' + idsPortefeuilleContrat);
        } else if (!String.isBlank(idPersonne)){
            // System.debug('*** Call with idPersonne = ' + idPersonne);
            // System.debug('*** : ' + MP_Generics_Endpoints__c.getInstance('api_endpoint'));
            // System.debug('*** : ' + MP_Xdata_credentials__c.getInstance('sm_api_version'));
            req.setEndpoint(endPoint + '?idPersonne=' + idPersonne);
        }
        // System.debug('*** Endpoint : ' + req.getEndpoint());
        req.setHeader('X-Correlation-Id', MP_AP13_GuidUtil.NewGuid());
        req.setHeader('api_key', MP_Xdata_credentials__c.getInstance('sm_api_key_INT').Value__c);
        req.setHeader('Authorization', 'Bearer ' + token);
        req.setHeader('Content-Type', 'application/json');
        return req;
    }

    private static Boolean httpResponseFailureDetected(HttpResponse response) {
        return (response == null || (response.getStatusCode() != 201 && response.getStatusCode() != 200 && response.getStatusCode() != 206));
    }

}