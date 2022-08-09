/*
*@Author: Paul Ghousoub, Eloi Dereeper
*@Description: Classe utilitaire pour la gestion des appels HTTP.
*@CreatedDate: 27/10/2020
*@LastModified: 27/10/2020
*/
public class VI_UTIL001_HttpUtilities {  
    
    private static String transactionId = null;   
    
    public static HttpResponse getTokenResponse (String Contexte){
        Map <String, String> values = getHttpRequestDefaultValues(Contexte);
        HttpRequest req = new HttpRequest();
        String endpoint = buildEndPoint(Contexte+'_token', null, contexte);
        system.debug('edndps '+endpoint);
        if(endpoint != null){
            req.setEndpoint(endpoint);
        }
        else{
            return null;
        }
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody(VI_UTIL002_Utilities.encodeFormData(values));
        system.debug('req'+ req.getBody());
        HttpResponse httpResp = getResponse(req);
        return httpResp;
    } 
    
    public static HttpResponse getTokenResponseApigee (String Contexte){
        Map <String, String> values = new Map < String, String > ();
        values.put('grant_type', 'client_credentials');
        String result = '';
        for (String thisKey : values.keySet()) {
            result += EncodingUtil.urlEncode(thisKey, 'UTF-8') + '=' + EncodingUtil.urlEncode(values.get(thisKey), 'UTF-8') ;
        }
        
        String Scope = MP_Xdata_credentials__c.getInstance(Contexte+'_scopeAPIGEE').Value__c;
        String consumerKey = MP_Xdata_credentials__c.getInstance(Contexte+'_consumerKeyAPIGEE').Value__c;
        String consumerSecret = MP_Xdata_credentials__c.getInstance(Contexte+'_consumerSecretAPIGEE').Value__c;
        
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        //req.setHeader('scope', 'apihour:read smile.read apiset-consentements.write smile-protected-digital apiset-protected-tranquility');
        req.setHeader('scope', Scope);
        req.setMethod('POST');
        req.setHeader('X-Correlation-Id', VI_UTIL003_GuidUtil.NewGuid());

        Blob headerValue=Blob.valueOf(consumerKey+':'+consumerSecret);
        string authHeader='Basic '+EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authHeader);
        
        String endPoint = buildEndPoint(Contexte+'_TokenAPIGEE', null, contexte);
        req.setEndpoint(endpoint);
        
        
        
        req.setBody(result);
        system.debug('req'+ req.getBody());
        HttpResponse httpResp = getResponse(req);
        system.debug('httpResp '+httpResp);
        return httpResp;
    } 

	public static HttpResponse getTokenResponseApigeeB2C (String Contexte){
        Map <String, String> values = new Map < String, String > ();
        values.put('grant_type', 'client_credentials');
        String result = '';
        for (String thisKey : values.keySet()) {
            result += EncodingUtil.urlEncode(thisKey, 'UTF-8') + '=' + EncodingUtil.urlEncode(values.get(thisKey), 'UTF-8') ;
        }

        String consumerKey = MP_Xdata_credentials__c.getInstance(Contexte+'_consumerKeyAPIGEE_B2C').Value__c;
        String consumerSecret = MP_Xdata_credentials__c.getInstance(Contexte+'_consumerSecretAPIGEE_B2C').Value__c;
        
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setMethod('POST');
        req.setHeader('X-Correlation-Id', VI_UTIL003_GuidUtil.NewGuid());

        Blob headerValue=Blob.valueOf(consumerKey+':'+consumerSecret);
        string authHeader='Basic '+EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authHeader);
        
        String endPoint = buildEndPoint(Contexte+'_TokenAPIGEEB2C', null, contexte);
        req.setEndpoint(endpoint);
        
        req.setBody(result);
        system.debug('req'+ req.getBody());
        HttpResponse httpResp = getResponse(req);
        system.debug('httpResp '+httpResp);
        return httpResp;
    }     
    
    public static Map < String, String > getHttpRequestDefaultValues(String Contexte){
        Map <String, String> values = new Map < String, String > ();
        String ClientId = MP_Xdata_credentials__c.getInstance( Contexte+'_client_id').Value__c; 
        String ClientSecret = MP_Xdata_credentials__c.getInstance(Contexte +'_client_secret').Value__c;
        String Scope;
        if(Label.VI_useAPIGEE=='true'){
            Scope = MP_Xdata_credentials__c.getInstance(Contexte+'_scopeAPIGEE').Value__c;           
        }
        else{
            Scope = MP_Xdata_credentials__c.getInstance(Contexte+'_scope').Value__c;            
        }
        system.debug('SCope '+Scope);
        values.put('client_id', ClientId);
        values.put('client_secret', ClientSecret);
        values.put('grant_type', 'client_credentials');
        
        values.put('scope', Scope);
        return values;
    }
    
    public static HttpResponse getResponseConsentement(String token,String Method,String apiName,String developerName,
                                                       Map<String, Object> bodyRequest, String idPersonneFinal, String contexte) {
                                                           Map<String, String> parameters= new Map<String, String>();
                                                           If(idPersonneFinal != null){ 
                                                               parameters.put('idPersonne', idPersonneFinal);
                                                           }
                                                           HttpResponse httpResp = makeHttpCall(token,Method,developerName,parameters,bodyRequest, contexte);
                                                           return httpResp;
                                                       }
    // Makes Callout = build Request + Get Response
    public static HttpResponse makeHttpCall(String token,String Method,String apiName,Map<String, String> parameters,
                                            Map<String, Object> bodyRequest, String contexte){
                                                HttpRequest httpReq = buildHttpRequest(token,Method,apiName,parameters,bodyRequest, null, contexte);
                                                HttpResponse httpResp = getResponse(httpReq);
                                                return httpResp;
                                            }
    
    // Makes Callout = build Request + Get Response
    
    public static HttpResponse makeHttpCall(String token,String Method,String apiName,Map<String, String> parameters,
                                            Map<String, Object> bodyRequest, String Id, String contexte){
                                                HttpRequest httpReq = buildHttpRequest(token,Method,apiName,parameters,bodyRequest, id, contexte);
                                                HttpResponse httpResp = getResponse(httpReq);
                                                return httpResp;
                                            }
    
    public static HttpResponse makeHttpCall(String token,String Method,String apiName,Map<String, String> parameters,
                                            Map<String, Object> bodyRequest, String Id , String contentType, String accept,
                                            String xAuthorization, String contexte){
                                                HttpRequest httpReq = buildHttpRequest(token,Method,apiName,parameters,bodyRequest, id,contentType,accept,xAuthorization, contexte);
                                                HttpResponse httpResp = getResponse(httpReq);
                                                return httpResp;
                                            }
    
    //Gets  http Response
    public static HttpResponse getResponse(HttpRequest req){
        system.debug('req '+req);
        HttpResponse httpResp = sendData(req);
        system.debug('httpResp '+httpResp);
        if (httpResponseFailureDetected(httpResp)) {
            return httpResp;
        }
        return httpResp; 
    }
    
    //Builds Http Request
    public static HttpRequest buildHttpRequest(String token, String method ,String apiName, Map<String, String> listParameters, 
                                               Map<String, Object> bodyRequest, String id, String contexte) {
                                                   return buildHttpRequest(token, method ,apiName, listParameters, bodyRequest,id, 'application/json', null,null, contexte);
                                               }
    
    
    public static HttpRequest buildHttpRequest(String token, String method ,String apiName, Map<String, String> listParameters, 
                                               Map<String, Object> bodyRequest, String id, String contentType, String accept,
                                               String xAuthorization, String contexte)
    {
        HttpRequest req = new HttpRequest();
        req.setMethod(method);
        system.debug('userInfo.getUserId() '+userInfo.getUserId());
        req.setEndpoint(buildEndPoint(apiName, listParameters, id, contexte));
        system.debug('apiname '+apiname);
        if(apiName.contains('VerifyEmail') || apiName.contains('VerifyPhoneNumber') || apiName.contains('EspacesPrives') || apiName.contains('MailActivation')
          || apiName.contains('CodeConfirmation') || apiName.contains('VI_VerificationCode')){
            setHeadersForVerifyPhoneMail(req,token,'application/json', contexte);
        }
        else{
            setHeaders(req,token,contentType, accept,xAuthorization, contexte);
        }
        if(bodyRequest != null ){
            if(apiname.contains('userLoginTranquility')){
                String result = '';
                for (String thisKey : bodyRequest.keySet()) {
                    // EncodingUtil.URLENCODE(addrComplete,'UTF-8'); 
                    result += EncodingUtil.URLENCODE(thisKey, 'UTF-8') + '=' +EncodingUtil.URLENCODE((String)bodyRequest.get(thisKey), 'UTF-8') + '&';
                }
                System.debug('*** url 1 : ' + result);
                req.setBody(result);
            }
            else
            {
                system.debug('JSON.serialize(bodyRequest) '+JSON.serialize(bodyRequest));
                req.setBody(JSON.serialize(bodyRequest));
            }
        }
        system.debug(req.getBody());
        return req;
    }
    
    //Detects http response failure
    private static Boolean httpResponseFailureDetected(HttpResponse response) {
        return (response == null || (response.getStatusCode() != 201 && response.getStatusCode() != 200 && response.getStatusCode() != 206));
    }
    
    //Send HttpRequest
    public static HttpResponse sendData(HttpRequest request) {
        String bodyResponse;
        String bodyRequest;
        String keyrow;
        String endPoint;
        String method;
        Integer status;
        Http http = new Http();
        HttpResponse res;
        system.debug(request);
        try {
            res = http.send(request);
            
        } catch (Exception e) {
            system.debug('exception '+e.getMessage());
            return null;
        }
        system.debug(res);
        system.debug(res.getBody());
        
        try{
            if(res != null) {
                bodyResponse=res.getBody().length() > 5000 ? res.getBody().substring(0,5000)  : res.getBody();
                status=res.getStatusCode();
                
            } else {
                status=400;
                bodyResponse='NO RESPONSE';
            }
            
            bodyRequest = request.getBodyDocument() != null ? request.getBodyDocument().toXmlString() : request.getBody();
            endpoint =  request.getEndpoint();
            method = request.getMethod();
            keyrow = 'K'+ DateTime.Now().getTime() +Integer.valueof(Math.random() * 9999);
            
            VI_LOG_CALLOUT__b log=buildLog(bodyResponse,bodyRequest,keyrow,status,endpoint,method);
            
            if(Test.isRunningTest()) {
                return res;
            }
            
            Database.SaveResult resultList = database.insertImmediate(log);
            system.debug('resultList '+resultList);
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }     
        
        
        return res;
    }
    
    public static String getTransactionId() {
        if(transactionId == null) {
            transactionId = 'ID-T-' + DateTime.Now().getTime() +Integer.valueof(Math.random() * 9999);
        }
        return transactionId;
    }
    
    public static VI_LOG_CALLOUT__b buildLog(String bodyResponse,String bodyRequest,String keyrow,Integer status,String endpoint,String method){
        VI_LOG_CALLOUT__b log = new VI_LOG_CALLOUT__b();
        log.Body_Response__c=bodyResponse;
        log.Status__c=status;
        log.Body_Request__c = bodyRequest;
        log.Endpoint__c = endpoint;
        log.User_Id__c = UserInfo.getUserId();
        log.Method__c = method;
        log.Date__c = DateTime.Now();
        log.Key_Row__c = keyrow;
        log.Transaction_Id__c = getTransactionId();
        return log;
    }
    
    public static String buildEndPoint(String apiName, Map<String, String> listParameters, string id, String contexte) {
        String endPoint = '';
        system.debug('apiname '+apiname);
        if (!Test.isRunningTest()) {
            List<SM_WS_Suffix__mdt> suffixes = [SELECT id, suffix__c from SM_WS_Suffix__mdt 
                                                WHERE developername = :apiName  and isActive__c=true 
                                                LIMIT 1];
            if(suffixes.size()>0){
                endPoint = 'callout:'+contexte+'_AuthAPIHour' + suffixes[0].suffix__c;  
                if(Label.VI_useAPIGEE=='true'){
                    endPoint = 'callout:'+contexte+'_AuthAPIGEE' + suffixes[0].suffix__c;  
                }
                if(apiname=='VI_EspacePriveB2C' || apiname=='VI_TokenAPIGEEB2C'){
                    endPoint = 'callout:'+contexte+'_AuthAPIGEEB2C' + suffixes[0].suffix__c;  
                }
            }
            else{
                return null;
            }
            
        }
        else{
            endpoint='testEndpoint';
        }
        if(id != null){
            endPoint = endPoint +'/'+id;
        }
        if (listParameters!= null && listParameters.size() > 0) {
            endPoint = endPoint + '?';
            Set<String> queryParamsKeys = listParameters.keySet();
            for (String key : queryParamsKeys) {
                endPoint = endPoint + key + '=' + listParameters.get(key) + '&';
            }
            endPoint = endPoint.substring(0, endPoint.length() - 1);
        }
        system.debug('endpoint '+endpoint);
        return endPoint;
    }
    //Builds the endPoint based on a list of parameters
    public static String buildEndPoint(String apiName, Map<String, String> listParameters, String contexte) {
        String endPoint = buildEndPoint(apiName,listParameters, null, contexte );
        return endPoint;
    }    
    
    //Builds the header based on the parameters
    
    public static void setHeaders(httpRequest request, String token, string contentType, string accept, String xAuthorization, String contexte){
        request.setHeader('X-Correlation-Id', VI_UTIL003_GuidUtil.NewGuid());
        system.debug('req.getHeader(\'X-Correlation-Id\') '+request.getHeader('X-Correlation-Id'));
        system.debug('token '+token);
        if(token != null && token != ''){
            request.setHeader('Authorization', 'Bearer ' + token);
            system.debug('req.getHeader(\'Authorization\') '+request.getHeader('Authorization'));
        }
        system.debug('paul content type '+contenttype);
        if(contentType != null && contentType != ''){
            request.setHeader('Content-Type', contentType);
            system.debug('req.getHeader(\'Content-Type\') '+request.getHeader('Content-Type'));
        }
        if(accept != null && accept != ''){
            request.setHeader('Accept', accept);
            system.debug('req.getHeader(\'Accept\') '+request.getHeader('Accept'));
        }
        system.debug('xAuthorization '+xAuthorization);
        if(xAuthorization != null && xAuthorization != ''){
            request.setHeader('x-Authorization', xAuthorization);
            system.debug('req.getHeader(\'x-Authorization\') '+request.getHeader('x-Authorization'));
        }
        if (!Test.isRunningTest()) {
            request.setHeader('api_key', MP_Xdata_credentials__c.getInstance(contexte+'_api_key_INT').Value__c);
            system.debug('req.getHeader(\'api_key\') '+request.getHeader('api_key'));
        }
        system.debug('userInfo.getUserId() '+userInfo.getUserId());
        if(Label.VI_useAPIGEE=='true'){
            request.setHeader('Content-length', '0');
            system.debug('req.getHeader(\'Content-length\') '+request.getHeader('Content-length'));
        }
    }
    //Builds the header based on the parameters
    
    public static void setHeadersForVerifyPhoneMail(httpRequest request, String token, string contentType, string contexte){
        setHeaders(request, token, contentType,null,null, contexte);
        request.setHeader('X-Api-Key', MP_Xdata_credentials__c.getInstance(contexte +'_api_key_digital_INT').Value__c);
        system.debug('req.getHeader(\'X-Api-Key\') '+request.getHeader('X-Api-Key'));
        request.setHeader('DIG_ID_CLIENT', MP_Xdata_credentials__c.getInstance(contexte + '_digital_id_client').Value__c);
                system.debug('req.getHeader(\'DIG_ID_CLIENT\') '+request.getHeader('DIG_ID_CLIENT'));

        request.setHeader('DIG_SECRET_CLIENT', MP_Xdata_credentials__c.getInstance(contexte+ '_digital_secret_client').Value__c);
                system.debug('req.getHeader(\'DIG_SECRET_CLIENT\') '+request.getHeader('DIG_SECRET_CLIENT'));
        

    }
    
    public static HttpResponse makeGetCalloutAdresse(String addrComplete){
        
        addrComplete = EncodingUtil.URLENCODE(addrComplete,'UTF-8');
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api-adresse.data.gouv.fr/search/?q=' + addrComplete);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json; charset=utf-8');
        Http http = new Http();
        HttpResponse res = http.send(req);
        return res;
    }
    
    
    public static String handleResponse(String json){
        json = json.replaceAll('__', '_');
        json = json.replace('_pagination', 'pagination');
        json = json.replace('_data', 'data');
        json = json.replace('_links', 'links');
        json = json.replace('"1"', '"data"');
        return json;
    }
}