/**
 * @author Sutharsan Pushparajah
 * @date 21/09/2021
 * @description Generic callout manager
 */
public class CalloutManager {

    // Global and default attributs
    public enum Scope {READ, WRITE, READWRITE}
    public static final String DEFAULT_ENDPOINT = 'callout:AuthAPIHour';
    public static Map<String, String> apigeeHeaders = new Map<String, String>{
        'Content-Length' => '0',
        'X-Correlation-Id' => MP_AP13_GuidUtil.NewGuid()
    };
    public static Map<String, String> apihourHeaders = new Map<String, String>{
        'X-Correlation-Id' => MP_AP13_GuidUtil.NewGuid(),
        'api_key' => (!Test.isRunningTest())?MP_Xdata_credentials__c.getInstance('sm_api_key_INT').Value__c:'',
        'Content-Type' => 'application/json'
    };
    
	/**
     * @description make an http callout depending on every argument
     */
    public static HttpResponse callout(String endpoint, String resource, Map<String, String> headers, Map<String, String> config, String method, String clientid, String clientsecret, String clientcert, String accessToken, String body){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint+resource);
        req.setMethod(method);
        
        if (String.isNotEmpty(clientcert)){
        	req.setClientCertificateName(clientcert);
        }
        if (headers !=null){
            for (String key : headers.keyset()){
                req.setHeader(key, headers.get(key));
            }
        }
        if (config != null){
            String result = '';
            
            for (String thisKey : config.keySet()) {
                result += EncodingUtil.urlEncode(thisKey, 'UTF-8') + '=' + EncodingUtil.urlEncode(config.get(thisKey), 'UTF-8') + '&';
            }
            
            if (String.isNotEmpty(result)){
                req.setBody(result);
            }
        }
        if (String.isNotEmpty(body)){
        	req.setBody(body);
        }
        if (String.isNotEmpty(clientid) && String.isNotEmpty(clientsecret)){
            Blob headerValue = Blob.valueOf(clientid + ':' + clientsecret);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
        }
        if (String.isNotEmpty(accessToken)){
            req.setHeader('Authorization', 'Bearer '+accessToken);
        }
        System.debug('Callout Request =>( Endpoint='+req.getEndpoint()+' , Method='+req.getMethod()+' , Content-Type='+req.getHeader('Content-Type')+' , Authorization='+req.getHeader('Authorization')+' , api_key='+req.getHeader('api_key')+' , X-Correlation-Id='+req.getHeader('X-Correlation-Id')+' , x-apigw-api-id='+req.getHeader('x-apigw-api-id')+' , Body='+req.getBody()+' )');
		Http http = new Http();
		HttpResponse res;
		try {
            res = http.send(req);
            System.debug('Callout Response =>( StatusCode='+res.getStatusCode()+' , Status='+res.getStatus()+' , Body='+res.getBody()+' )');
        } catch (Exception e) {
            System.debug('*** failed to send the request : ' + e);
            return null;
        }
        return res;
    }
    
    /**
     * @description deserialize response and return token
     */
    public static TokenResponse deserializeToken(String responseBody){
        // use default parsing for everything we can.
        TokenResponse parsedResponse = new TokenResponse();
        try{
            parsedResponse = (TokenResponse) System.JSON.deserialize(responseBody, TokenResponse.class);
            // explicitly parse out the developer.email property because it's an illegal identifier
            Map<String,Object> props = (Map<String,Object>) System.JSON.deserializeUntyped(responseBody);
        } catch(Exception exp){
            parsedResponse.error = exp.getMessage() + ' response: '+responseBody;
        }
       
        return parsedResponse;
    }

    /**
     * @description Method allows you to build the generic part of the header of an Xdata call
     */
    public static HttpResponse sendRequest(String resource, String params, String method, Scope scopeParam, String body, Map<String, String> additionalHeaders){
        String endpointURL = '';
        Boolean isApihour = false;
        Map<String, String> headers = new Map<String, String>();

        SM_WS_Suffix__mdt suffixs = [select id, suffix__c,endpoint__c,activate_Apihour__c from SM_WS_Suffix__mdt where developername =: resource limit 1];
        endpointURL = (suffixs.activate_Apihour__c || String.isBlank(suffixs.endpoint__c))? DEFAULT_ENDPOINT + suffixs.suffix__c :suffixs.endpoint__c + suffixs.suffix__c;
        isApihour = suffixs.activate_Apihour__c || String.isBlank(suffixs.endpoint__c);

        endpointURL = (String.isBlank(params)) ? endpointURL : endpointURL + params;
        System.debug(endpointURL);
        if (isApihour) {
            headers.putAll(apihourHeaders);
            String token = (!Test.isRunningTest()) ? SM_MP_AP04_GetTokenService.getTokenFromSmile() : 'test';
            if (token == null) {
                system.debug('Token not found ...');
            }
            headers.put('Authorization', 'Bearer ' + token);
        } else {
            headers.putAll(apigeeHeaders);
            headers.put('scope', getCalloutScope(scopeParam));
        }
        if(additionalHeaders != null)
            headers.putAll(additionalHeaders); 
        return callout(endpointURL, '', headers, null, method, null, null, null, null, body);
    }

    /**
     * @description To determine the corresponding scope of the request
     */
    public static String getCalloutScope(Scope scopeParam){
        String requestScope = '';
        if(scopeParam == Scope.READ){
            requestScope = 'apihour:read';
        }else if(scopeParam == Scope.WRITE){
            requestScope = 'apihour:write';
        }else if(scopeParam == Scope.READWRITE){
            requestScope = 'apihour:read apihour:write';
        }
        return requestScope;
    }

    /**
     * @description Method allows you to check if the response parameter has a failure code
     */
    public static Boolean httpResponseFailureDetected(HttpResponse response) {
        return (response == null || (response.getStatusCode() != 201 && response.getStatusCode() != 200 && response.getStatusCode() != 206));
    }

    /**
     * @description wrapper class to deserialize the response from APIGEE
     */
    public class TokenResponse {
        public String token_type {get;set;}
        public String issued_at {get;set;}
        public String client_id {get;set;}
        public String access_token {get;set;}
        public String application_name {get;set;}
        public String scope {get;set;}
        public String expires_in {get;set;}
        public String refresh_count {get;set;}
        public String status {get;set;}

        // Apigee Edge -- hosted version uses these fields for error handling
        public String ErrorCode {get; set;}
        public String Error {get; set;}

        // Apigee on premise version uses this Field for error handling
        public Fault fault {get; set;}

        public Boolean isError() {
            return Error != null || fault != null;
        }

        public String getErrorMessage() {
            if (Error != null) {
                return 'Code: '+ErrorCode+ '/ Message: '+Error;
            }

            if (fault != null) {
                // Substitute the error code to compose
                return fault.faultString.replace('{0}',fault.detail.errorcode);
            }
            return null;
        }
    }

    /**
     * @description wrapper class to deserialize the response from APIGEE
     */
    public class Fault {
        public String faultstring {get;set;}
        public Detail detail {get;set;}
    }

    /**
     * @description wrapper class to deserialize the response from APIGEE
     */
    public class Detail {
        public String errorcode {get;set;}
    }

    /**
     * @description Custom exception type so we can wrap and rethrow
     **/
    public class TokenException extends Exception {}

}