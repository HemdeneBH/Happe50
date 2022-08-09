/**
 * @File Name          : HP_UTIL_HTTPUtils.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Hemdene Ben Hammouda




 * @Last Modified On   : 03-10-2022





 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    27/01/2020   Slimene BELHAJ ALI     Initial Version
**/
public without sharing class HP_UTIL_HTTPUtils {
    private static String transactionId = null;
    private static final Integer HTTP_REQUEST_TIMEOUT_DEFAULT = 120000;
    private static String savelogMode = null;
    private static Map<String, TokenWrapper> tokenWrapperMap = null;
    private static Map<String, EndPointWrapper> endPointWrapperMap = null;
    private static final String AUTH_MODE = [SELECT Value__c FROM HP_Auth_Mode__mdt LIMIT 1].Value__c;

    public static final String BEARER = 'Bearer ';
    public static final String HP_API_KEY = 'HP_API_KEY';
    public static final String API_KEY = 'api_key';
    public static final String CONTENT_TYPE_JSON ='application/json';
    public static final String CONTENT_TYPE = 'Content-Type';
    public static final String POST = 'POST';
    public static final String GET = 'GET';
    public static final String PUT = 'PUT';
    public static final String DEL = 'DELETE';
    public final static String CLIENT_ID = 'client_id';
    public final static String ACCOUNT_ID = 'account_id';
    public final static String AUDIENCE_TEXT = 'audience';
    public final static String AUDIENCE_BP_PLATFORM = 'bp-platform-api';
    public final static String HP_BUYAPOWA_TOKEN = 'HpBuyapowaApiToken';
    public final static String CLIENT_SECRET = 'client_secret';
	public final static String GRANT_TYPE = 'grant_type';
    public final static String SCOPE    = 'scope';
    public final static String GAIA_LABEL = 'gaia';
    public final static String MDP_LABEL  ='mdp';
    public final static String TOKEN_PARTION = 'local.HPAccessToken.';
    public static final String CONTENT_TYPE_FORM_ENCODED ='application/x-www-form-urlencoded';
    public static final String X_CORRELATION = 'X-Correlation-Id';
    public static final String HP_X_CORRELATION = 'HP_X_CORRELATION';
    public static final String ACCEPT = 'Accept';
    public static final Integer LIFE_DURATION = 36000;
    public static final String APIGW_API_ID = 'x-apigw-api-id';
    public static final String APIGW_API = 'APIGW_API_ID';
    public static final String API_HOUR = 'API_HOUR';
    public static final String APIGEE = 'APIGEE';
    public static final String APIGEE_PREFIX = 'APIGEE_PREFIX';
    public static final String API_HOUR_PREFIX = 'API_HOUR_PREFIX';
    public static final String APIGEE_TOKEN = 'APIGEE_TOKEN';
    public static final String API_HOUR_TOKEN = 'API_HOUR_TOKEN';
    public static final String AGILAB_TOKEN_APIGEE = 'AGILAB_TOKEN_APIGEE';
    public static final String TRANQUILITY_TOKEN_APIGEE = 'TRANQUILITY_TOKEN_APIGEE';
    public static final String AGILAB_TOKEN = 'AGILAB_TOKEN';
    public static final String TRANQUILITY_TOKEN = 'TRANQUILITY_TOKEN';
    public static final String TRANQUILITY = 'tranquility';
    public static final String AGILAB = 'agilab';

    public static final String HP_CACHE_DURATION = 'HP_CACHE_DURATION';
    public static final String HP_CACHE_ACTIVATION = 'HP_CACHE_ACTIVATION';
    private static Map<String, Map<String, String>> requestApiCache;
    
    public static String getSaveLogMode(){
        
        if(savelogMode == null) {
            savelogMode = HP_UTIL_MetadataManager.getConfigByKey('HP_ACITVE_SAVE_LOG');

        }

        return savelogMode;
    }
    public static String getTransactionId() {
        System.debug('##Transaction Method : '+transactionId);
        if(transactionId == null) {
            transactionId = 'ID-T-' + DateTime.Now().getTime() +Integer.valueof(Math.random() * 9999);
        }
        return transactionId;
    }
    public static Map<Integer, String> calloutGetToMap(final String endpointKey, Map<String, String> parameters) {
        return convertResponseToMap(calloutGet(endpointKey, parameters));
    }

    public static Map<Integer, String> calloutGetToMap(final String endpointKey, String getMethodParam) {
        return convertResponseToMap(calloutGet(endpointKey, getMethodParam));
    }


    /** 
    * @author Slimene Belhaj Ali
    * @date 28/01/2020 
    * @description Methode permet de faire les appel API get
    * @param endpointKey, l'ID de l'endpoint dans le MD HP_Endpoint_Configuration__mdt
    **/
    public static HTTPResponse calloutGet(final String endpointKey, String getMethodParam) {
        return callout(endpointKey, GET, null, getMethodParam, null);
    }

    public static HTTPResponse calloutGet(final String endpointKey, String getMethodParam, Integer timeout) {
        return callout(endpointKey, GET, null, getMethodParam, null, timeout);
    }
    /** 
    * @author Slimene Belhaj Ali
    * @date 28/01/2020 
    * @description Methode permet de faire les appel API get
    * @param endpointKey, l'ID de l'endpoint dans le MD HP_Endpoint_Configuration__mdt
    **/
    public static HTTPResponse calloutGet(final String endpointKey, Map<String, String> parameters) {
        String getMethodParam = '';
        boolean isFirst = true;
        if(parameters == null) {
            return callout(endpointKey, GET, null, null, null);
        }
        for(String key : parameters.keyset()) {
            if(isFirst) {
                getMethodParam += key+ '=' +parameters.get(key);
                isFirst = false;
                continue;
            }
            getMethodParam += '&' + key + '=' +parameters.get(key);
        }
        return callout(endpointKey, GET, null, getMethodParam, null);
    }

     /** 
    * @author Slimene Belhaj Ali
    * @date 28/01/2020 
    * @description Methode permet de faire les appel API POST
    * @param endpointKey, l'ID de l'endpoint dans le MD HP_Endpoint_Configuration__mdt
    * @param body, body de l'appel
    **/
    public static HTTPResponse calloutPost(final String endpointKey, String body) {
        return callout(endpointKey, POST, body, null,  null);
    }

    public static HTTPResponse calloutPostMarketing(final String endpointKey, String body, String contactId) {
        return callout(endpointKey, POST, body, contactId,  null);
    }

    public static Map<Integer, String> calloutPostToMap(final String endpointKey, String body) {
        return convertResponseToMap(calloutPost(endpointKey, body));
    }

     /** 
    * @author Slimene Belhaj Ali
    * @date 28/01/2020 
    * @description Methode permet de faire les appel API POST
    * @param endpointKey, l'ID de l'endpoint dans le MD HP_Endpoint_Configuration__mdt
    * @param body, body de l'appel
    **/
    public static HTTPResponse calloutPut(final String endpointKey, String body, String putMethodParam) {
        return callout(endpointKey, PUT, body, putMethodParam,  null);
    }

    public static HTTPResponse calloutPut(final String endpointKey, String body, String putMethodParam, Map<String, String> headers) {
        return callout(endpointKey, PUT, body, putMethodParam, headers);
    }


     
    public static HTTPResponse calloutDelete(final String endpointKey, String deleteMethodParam) {
        return callout(endpointKey, DEL, null, deleteMethodParam,  null);
    }
    
  /*  public static Map<String, Map<String, String>> getCacheAPI() {
        if(requestApiCache != null) {
            return requestApiCache;
        }
        DateTime nowDateTime = System.now();
        Integer cacheDuration = Integer.valueOf(HP_UTIL_MetadataManager.getConfigByKey(HP_CACHE_DURATION));
        DateTime startLoad = nowDateTime.addSeconds(- cacheDuration);
        List<HP_LOG_CALLOUT__b> logDataList = [select Status__c, Date__c, Method__c,  Endpoint__c, Call_Time_Execution__c, Body_Response__c 
        from HP_LOG_CALLOUT__b where Date__c <= :nowDateTime and Date__c >= :startLoad];
        requestApiCache =  new Map<String, Map<String, String>>();
        for(HP_LOG_CALLOUT__b item : logDataList) {
            if(item.Method__c == GET) {
                System.debug(item.Endpoint__c + '  '+item.Status__c);
                requestApiCache.put(item.Endpoint__c, new Map<String, String>{'body' => item.Body_Response__c, 'code' => String.valueOf(item.Status__c.format())});
            }
        }
        return requestApiCache;
    }*/
     /** 
    * @author Slimene Belhaj Ali
    * @date 28/01/2020 
    * @description Methode permet de faire les appel API
    * @param endpointKey, l'ID de l'endpoint dans le MD HP_Endpoint_Configuration__mdt
    * @param httpMethod, Method de l'appel
    * @param body, body de l'appel
    * @param headers, headers de l'appel
    * @param useCache, activer l'utilisation de cache
    **/
    public static HTTPResponse callout(final String endpointKey, final String httpMethod, final String body, String getMethodParam, Map<String, String> headers, Integer timeout) {

        EndPointWrapper endpointConf = getEndPointWrapperMap().get(endpointKey);
        String endpoint = endpointConf.value;
        Boolean saveLog = endpointConf.saveLog;
        HttpRequest req =   (endpointConf.tokenList == null)
        ?   buildRequest(endpointConf, httpMethod, buildHeaderWithoutToken(headers), body, getMethodParam) 
        :   buildRequest(endpointConf, httpMethod, buildHeaderWithToken(headers, endpointConf.tokenList), body, getMethodParam) ;
		System.Http http = new System.Http();
        datetime startCall = datetime.now();
        req.setTimeout(timeout);
        HTTPResponse response = null;
        try {
            response = http.send(req);
            System.debug(response.getStatusCode());
        } catch(CalloutException e) {
            saveLogResponse(req, response, (datetime.now().getTime() - startCall.getTime()));
            throw new TimeoutException(req);
        }
		datetime endCall = datetime.now();
        if(saveLog){
            saveLogResponse(req, response, (endCall.getTime() - startCall.getTime()));
        }
        if(!tokenIsValid(response)) {
			boolean needToRefresh = removeTokenCache(endpointConf.tokenList);
            if(needToRefresh == true) {
                return callout(endpointKey, httpMethod, body, getMethodParam, headers);
            }
		}
        
		return response;
    }
    public static HTTPResponse callout(final String endpointKey, final String httpMethod, final String body, String getMethodParam, Map<String, String> headers) {
        return callout(endpointKey, httpMethod,   body,  getMethodParam, headers, HTTP_REQUEST_TIMEOUT_DEFAULT);
    }

    /** 
    * @author Slimene Belhaj Ali
    * @date 28/01/2020 
    * @description Methode permet  de construire la requete
    * @param endpoint, le endpoint d l'appel
    * @param httpMethod, Method de l'appel
    * @param body, body de l'appel
    * @param headerMap, headerMap de l'appel
    **/
    public static HttpRequest buildRequest(EndPointWrapper endpointConf, String httpMethod,  Map<String, String> headerMap, String body, String getMethodParam) {
		

		final HttpRequest httpRequest = new HttpRequest();
        String endpoint = endpointConf.value;
        if(getMethodParam != null) {
            endpoint +=  getMethodParam.replaceAll(' ', '%20');
            endpoint = endpoint.replaceAll('@', '%40');
        }
		httpRequest.setEndpoint(endpoint);
		httpRequest.setMethod(httpMethod);
        if(AUTH_MODE == APIGEE ){
            if(httpMethod == 'GET'){
                headerMap.remove(CONTENT_TYPE);
            }
        }
		for (String key : headerMap.keySet()) {
			httpRequest.setHeader(key, headerMap.get(key));
		}
		if (body != null) {
			httpRequest.setBody(body);
		}
        if(endpointConf.headerMandatory != null) {
            for(String headerKey : endpointConf.headerMandatory) {
                String conf = HP_UTIL_MetadataManager.getConfigByKey(headerKey);
                List<String>  confParam = conf.split('=');
                if(confParam.size() >= 2) {
                    httpRequest.setHeader(confParam.get(0), confParam.get(1));
                }
            }
        }
		httpRequest.setTimeout(HTTP_REQUEST_TIMEOUT_DEFAULT);
		return httpRequest;
    }
    
    /**
    * @description A utiliser sur nos WS REST, spécifique aux WS (contrainte technique ordre WS / DML), pas possible d'utiliser les Big Objects   
    * @author Vincent Albiser | 05/02/2020 
    * @param Long duration 
    * @return void 
    **/
    public static void saveLogResponse(RestRequest restRequest, RestResponse restResponse, Long duration){

        if(!HP_Constantes.USE_API_LOG) {
            return;
        } 
        if(getSaveLogMode() == 'NONE') {
            return;
        }

        if(getSaveLogMode() == 'ALL' || getSaveLogMode() == 'LOG') {
            System.debug('##Endpoint ' + restRequest.requestURI);
            System.debug('##Method ' + restRequest.httpMethod);
            System.debug('##status ' + restResponse.statusCode);
            System.debug('##body ' + restRequest.requestBody);
            System.debug('##response ' + restResponse.responseBody);
            System.debug('##duration ' + duration);
        }
        if(getSaveLogMode() != 'DATABASE' && getSaveLogMode() != 'ALL') {
            return;
        }
        
        try{
            HP_LOG_WS__c log = new HP_LOG_WS__c();

            log.Endpoint__c =  restRequest.requestURI;
            log.Body_Request__c = restRequest.requestBody != null ? restRequest.requestBody.toString() : ''; 
            log.Method__c = restRequest.httpMethod;

            log.Status__c = restResponse.statusCode != null ? restResponse.statusCode : 200;
            log.Body_Response__c = restResponse.responseBody != null ? restResponse.responseBody.toString() : '';
            log.User_Id__c = UserInfo.getUserId();            
            log.Date__c = DateTime.Now();
            log.Call_Time_Execution__c = duration;
            log.Transaction_Id__c = getTransactionId();

            if(Test.isRunningTest()) {
                return;
            }
            Database.DMLOptions dml = new Database.DMLOptions();
 		    dml.allowFieldTruncation = true;

            Database.insert(log, dml);        

        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    
    /** 
    * @author Slimene Belhaj Ali
    * @date 28/01/2020 
    * @description Methode permet de historiser la requete et la reponse, spécifique aux CALLOUT (contrainte technique ordre Callout / DML)    
    * @param response, la reponse
    * @param httpRequest, la requete
    **/
    public static void saveLogResponse(HttpRequest httpRequest, HTTPResponse response, Long duration) {
        
        if(!HP_Constantes.USE_API_LOG) {
            return;
        }
        
        if(getSaveLogMode() == 'NONE') {
            return;
        }
        if(getSaveLogMode() == 'ALL' || getSaveLogMode() == 'LOG') {
            System.debug('##Endpoint ' + httpRequest.getEndpoint());
            System.debug('##Method ' + httpRequest.getMethod());
            System.debug('##body ' + httpRequest.getBody());
            System.debug('##bodyDocument ' + httpRequest.getBodyDocument());
            System.debug('##duration ' + duration);
            
            if(response != null) {
                if(httpRequest.getEndpoint() != getEndPointWrapperMap().get(HP_Constantes.PILOTAGE_GET_EMAILS).value) {System.debug('##response ' + response.getBody());}
                System.debug('##status ' + response.getStatusCode());
            }  
        }

        if(getSaveLogMode() != 'DATABASE' && getSaveLogMode() != 'ALL') {
            return;
        }

        try{
            HP_LOG_CALLOUT__b pb = new HP_LOG_CALLOUT__b();
            if(response != null) {
                if(httpRequest.getEndpoint() == getEndPointWrapperMap().get(HP_Constantes.PILOTAGE_GET_EMAILS).value) {
                    HP_WRP025_PilotageEmails    output = (HP_WRP025_PilotageEmails) JSON.deserialize(response.getBody().replace('"date":', '"date_x":'), HP_WRP025_PilotageEmails.class);
                    for ( HP_WRP025_PilotageEmails.ListeEmails email : output.data.listeEmails){
                        email.body = 'Not saved in log';
                    }
                    pb.Body_Response__c = JSON.serializePretty(output);
                }else{
                    pb.Body_Response__c = response.getBody();


                }
                
            try {
                Map<String, endPointWrapper> mapEndpoint = HP_UTIL_HTTPUtils.getEndPointWrapperMapByValue();
                boolean endpointInMapAndHasResponseCode = mapEndpoint.get(httpRequest.getEndpoint()) != null && mapEndpoint.get(httpRequest.getEndpoint()).expectedResponseCode != null;
                    
                boolean responseHasBody = response.getBodyDocument() != null;
                if(endpointInMapAndHasResponseCode && responseHasBody) {
                    String responseAsString = response.getBodyDocument().toXmlString();
                    boolean isValid = false;
                    for(String responseCode : mapEndpoint.get(httpRequest.getEndpoint()).expectedResponseCode) {
                        isValid = responseAsString.containsIgnoreCase(responseCode);
                    }
                

                    pb.Status__c = isValid ? response.getStatusCode() : 400;
                }
                else {
                pb.Status__c = response.getStatusCode();
                }
            }catch(Exception e) {
                pb.Status__c = response.getStatusCode();
            }


            } else {
                pb.Status__c =408;
                pb.Body_Response__c = '{"code" : 408, "message" : "timeout"}';
            }
            
            pb.Body_Request__c = httpRequest.getBodyDocument() != null ? httpRequest.getBodyDocument().toXmlString() : httpRequest.getBody();
            pb.Endpoint__c =  httpRequest.getEndpoint();
            pb.User_Id__c = UserInfo.getUserId();
            pb.Method__c = httpRequest.getMethod();
            pb.Date__c = DateTime.Now();
            pb.Call_Time_Execution__c = duration;
            pb.Key_Row__c = 'K'+ pb.Date__c.getTime() +Integer.valueof(Math.random() * 9999);
            pb.Transaction_Id__c = getTransactionId();
            
            if(Test.isRunningTest()) {
                return;
            }
            Database.DMLOptions dml = new Database.DMLOptions();
 		    dml.allowFieldTruncation = true;

            pb.setOptions(dml);

            Database.SaveResult resultList = database.insertImmediate(pb);
            System.debug('##SaveLog Debug : '+pb);
         }
        catch(Exception e){
            System.debug(e.getMessage());
        }     
    }
    
    /** 
    * @author Slimene Belhaj Ali
    * @date 28/01/2020 
    * @description Methode permet de verifier si le token est valid ou pas
    * @param response, la reponse
    **/
    private static boolean tokenIsValid(HTTPResponse response) {

       
        try{
            Map<String, Object> resultAsMap = (Map <String, Object> ) JSON.deserializeUntyped(response.getbody());

            String error = (String)resultAsMap.get('error');
            if(error == 'invalid_token') {
                return false;
            }
        } catch(Exception e) {}
        
        return(response.getStatusCode() != 401 && response.getStatusCode() != 990);
    }
    
    /** 
    * @author Slimene Belhaj Ali
    * @date 28/01/2020 
    * @description Methode permet de construide le header 
    * @param headers, le headers
    * @param tokenList, le la liste de token
    **/
    private static Map<String, String> buildHeaderWithToken(Map<String, String> headers, List<String> tokenList) {
        Map<String, String> result = new Map<String, String>();
        
        result.put(API_KEY, HP_UTIL_MetadataManager.getConfigByKey(HP_API_KEY));
        result.put(CONTENT_TYPE, CONTENT_TYPE_JSON);
        result.put(ACCEPT, CONTENT_TYPE_JSON);
        result.put(X_CORRELATION, HP_UTIL_MetadataManager.getConfigByKey(HP_X_CORRELATION));

        if(headers != null) {
            for(String key : headers.keySet()) {
                result.put(key, headers.get(key));
            }
        }

        for(String tok : tokenList) {
           TokenWrapper tokenConf =  getTokenWrapperMap().get(tok);
           result.put(tokenConf.headerKey, BEARER + tokenConf.getToken());
        }
        System.debug('@@@ headers : '+result);
        return result;
    }
	@TestVisible
    private static Map<String, String> buildHeaderWithoutToken(Map<String, String> headers) {
        Map<String, String> result = new Map<String, String>();
        
        result.put(CONTENT_TYPE, CONTENT_TYPE_FORM_ENCODED);

        if(headers != null) {
            for(String key : headers.keySet()) {
                result.put(key, headers.get(key));
            }
        }
        
        return result;
    }

    /** 
    * @author Slimene Belhaj Ali
    * @date 28/01/2020 
    * @description Methode permet de charger le token config
    **/
    private static Map<String, TokenWrapper> getTokenWrapperMap() {
        if(tokenWrapperMap != null) {
            return tokenWrapperMap;

        }
        tokenWrapperMap = new Map<String, TokenWrapper>();
        List<HP_Token_Parameter__mdt> tokenConfigList = [select DeveloperName, Cache_Id__c, Client_Id__c, Client_Secret__c,
                                                        End_Point__c, Header_key__c, Method__c, Scope__c, Token_Needed__c, Grant_Type__c,
                                                        Type__c, Gaia__c, Mdp__c, Account_Id__c
                                                        from HP_Token_Parameter__mdt];
        
        for(HP_Token_Parameter__mdt conf : tokenConfigList) {
            tokenWrapperMap.put(conf.DeveloperName, new TokenWrapper(conf));
        }
        return tokenWrapperMap;
    }

    /** 
    * @author Slimene Belhaj Ali
    * @date 28/01/2020 
    * @description Methode permet de charger le endpoint config
    **/
    private static Map<String, EndPointWrapper> getEndPointWrapperMap() {
        if(endPointWrapperMap != null) {
            return endPointWrapperMap;

        }
        endPointWrapperMap = new Map<String, EndPointWrapper>();
        List<HP_Endpoint_Configuration__mdt> endpointConfigList = [select DeveloperName, Token_Needed__c, Value__c, SaveLog__c, Header_Mandatory__c, ExpectedResponseCode__c, Is_API_Hour_Apigee__c
                                                        from HP_Endpoint_Configuration__mdt];
        
        for(HP_Endpoint_Configuration__mdt conf : endpointConfigList) {
            endPointWrapperMap.put(conf.DeveloperName, new EndPointWrapper(conf));
        }
        return endPointWrapperMap;
    }

    /**
    * @description Récupération des config hp endpoint parameters en Map avec pour clé le endpoint
    * @author Antoine Latour | 27-11-2020 
    * @return Map<String, EndPointWrapper> 
    **/
    private static Map<String, EndPointWrapper> getEndPointWrapperMapByValue() {
        if(endPointWrapperMap == null) {
            endPointWrapperMap = getEndPointWrapperMap();
        }
        Map<String, EndPointWrapper> resultMap = new Map<String, EndPointWrapper>();
        
        for(EndPointWrapper endPointConf : endPointWrapperMap.values()){
            resultMap.put(endPointConf.value, endPointConf);
        }

        return resultMap;
    }

    /**
    * @description Récupération du value par HP Endpoint Configuration Name
    * @author Badr Eddine Belkarchi | 13-10-2021 
    * @return String 
    **/
    public static String getEndPointValueByConfigName(String endpointConfigurationName) {
        return getEndPointWrapperMap().get(endpointConfigurationName).value;
    }

    /** 
    * @author Slimene Belhaj Ali
    * @date 28/01/2020 
    * @description Methode permet de vider le cache pour les token
    * @param tokenList, le la liste de token
    **/
    public static boolean removeTokenCache(List<String> tokenList) {
        boolean needToRefresh = false;
        for(String tok : tokenList) {
            TokenWrapper currentTok =  getTokenWrapperMap().get(tok);
            
            if(currentTok == null || currentTok.removeTokenFromCache()) {
                needToRefresh = true;
            }
        }
        return needToRefresh;
    }

    public static Map<Integer, String> convertResponseToMap(HTTPResponse response) {
        return new Map<Integer, String>{
				response.getStatusCode() => response.getBody()
        };
    }

    public static String buildUrlEncodedParameters(final Object agilabQueryObject) {
		final Map<String, Object> deserializedAgilabQueryObject = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(agilabQueryObject));
		return buildUrlEncodedParametersRecursively('', deserializedAgilabQueryObject.keySet().iterator(), deserializedAgilabQueryObject, true, null);
	}	

	private static String buildUrlEncodedParametersRecursively(final String output, final Iterator<String> iterator, final Map<String, Object> deserializedData, final Boolean isFirstParameter, final String containerKey) {
		if (!iterator.hasNext()) {
			return output;
		}
		final String key = iterator.next();
		Object value = deserializedData.get(key);
		String printableKey = ((containerKey == null)? (key) : (containerKey + '[' + key + ']')) + HP_HttpUtils.URI_QUERY_PARAMETER_ASSIGNMENT;
		if (value instanceof Map<String, Object>) {
			printableKey = '';
			value = buildUrlEncodedParametersRecursively('', ((Map<String, Object>)value).keySet().iterator(), (Map<String, Object>)value, true, key);
		} else {
			value = ((value == null)? ('') : (EncodingUtil.urlEncode(String.valueOf(value), HP_HttpUtils.ENCODING_UTF8)));
		}
		return buildUrlEncodedParametersRecursively((output + ((isFirstParameter)? ('') : (HP_HttpUtils.URI_QUERY_DELIMITOR)) + printableKey + value), iterator, deserializedData, false, containerKey);
	}

    

    
    /** 
    * @author Slimene Belhaj Ali
    * @date 28/01/2020 
    * @description token wrapper
    **/
    class TokenWrapper {
        String endPoint;
        String cacheId;
        String clientSecret;
        String clientId;
        String scope;
        String method;
        String headerKey;
        String tokenNeeded;
        String grantType;
        String type;
        String gaia;
        String mdp;
        Decimal accountId;
        String audience;

        boolean isRefreshed;

        /** 
        * @author Slimene Belhaj Ali
        * @date 28/01/2020 
        * @description Constructeur
        * @param conf, le MD associé 
        **/
        public TokenWrapper(HP_Token_Parameter__mdt conf) {
            this.endPoint = conf.End_Point__c;
            this.cacheId = conf.Cache_Id__c;
            this.clientSecret = conf.Client_Secret__c;
            this.clientId = conf.Client_Id__c;
            this.scope = conf.Scope__c;
            this.method = conf.Method__c;
            this.headerKey = conf.Header_key__c;
            this.tokenNeeded = conf.Token_Needed__c;
            this.grantType = conf.Grant_Type__c;
            this.isRefreshed = false;
            this.type = conf.Type__c;
            this.gaia = conf.Gaia__c;
            this.mdp = conf.Mdp__c;
            if(conf.Cache_Id__c =='ApiMarketingCloudToken'){
                this.accountId = 510004624;
                this.audience = null;
            }else if(conf.Cache_Id__c == HP_BUYAPOWA_TOKEN){
                this.audience = AUDIENCE_BP_PLATFORM;
                this.accountId = null;
            }else {
                this.accountId = null;
                this.audience = null;
            }
        }

        /** 
        * @author Slimene Belhaj Ali
        * @date 28/01/2020 
        * @description methode recuperer le token
        **/
        public String getToken() {
            String token = retrieveTokenFromCache();
            Integer duration;
            if(token != null) {
                return token;
            }
            Map<String,String> tokenMap = refreshToken();
            token = tokenMap.get('token');
            duration = !String.isEmpty(tokenMap.get('duration')) ? Integer.valueOf(tokenMap.get('duration')) : 3600;
            if(duration < 300){
                duration = 300;
            }
            putTokenToCache(token,duration);
            return token;
        }
        
        /** 
        * @author Slimene Belhaj Ali
        * @date 28/01/2020 
        * @description methode recuperer le token de la cache
        **/
        private String retrieveTokenFromCache() {
            return (String)Cache.Org.get(HP_UTIL_HTTPUtils.TOKEN_PARTION + this.cacheId);
        }

        /** 
        * @author Slimene Belhaj Ali
        * @date 28/01/2020 
        * @description methode permer d'ecrire dans le cache
        * @param token, le token
        **/
        private void putTokenToCache(String token, Integer duration) {
            if(token == null) {
                return;
            }
            Cache.Org.put(HP_UTIL_HTTPUtils.TOKEN_PARTION + this.cacheId, token, duration);
        }

        /** 
        * @author Slimene Belhaj Ali
        * @date 28/01/2020 
        * @description methode permer ds supprimer le token de cache
        **/
        public boolean removeTokenFromCache() {
            if(!this.isRefreshed) {
                Cache.Org.remove(HP_UTIL_HTTPUtils.TOKEN_PARTION + this.cacheId);
                return true;
            }
            return false;
        }

        /** 
        * @author Slimene Belhaj Ali
        * @date 28/01/2020 
        * @description methode permer de faire le refresh
        **/
        private Map<String,String> refreshToken() {
            
            isRefreshed = true;
            Map<String,String> resultMap = new Map<String,String>();
            final HttpRequest httpRequest = new HttpRequest();
            httpRequest.setEndpoint(this.buildUrl());
            httpRequest.setMethod(this.method);
            String body = this.buildBody();
           
            if(body != null) {
                httpRequest.setBody(this.buildBody());
            }
            
            httpRequest.setTimeout(HTTP_REQUEST_TIMEOUT_DEFAULT);

            //httpRequest.setHeader(API_KEY, HP_UTIL_MetadataManager.getConfigByKey(HP_API_KEY_AGILAB));
            if(this.method == GET) {
                httpRequest.setHeader(CONTENT_TYPE, CONTENT_TYPE_JSON);
                httpRequest.setHeader(X_CORRELATION, HP_UTIL_MetadataManager.getConfigByKey(HP_X_CORRELATION));
                httpRequest.setHeader(API_KEY, HP_UTIL_MetadataManager.getConfigByKey(HP_API_KEY));
            } else {
                  if (this.type == GAIA_LABEL){
                    httpRequest.setHeader(ACCEPT, CONTENT_TYPE_JSON);
                    httpRequest.setHeader(CONTENT_TYPE, CONTENT_TYPE_JSON);
                    httpRequest.setHeader(X_CORRELATION, HP_UTIL_MetadataManager.getConfigByKey(HP_X_CORRELATION));
                    httpRequest.setHeader(API_KEY, HP_UTIL_MetadataManager.getConfigByKey(HP_API_KEY));
                }else if(httpRequest.getEndpoint().contains('marketingcloudapis') || httpRequest.getEndpoint().contains('buyapowa')){
                    httpRequest.setHeader(CONTENT_TYPE, CONTENT_TYPE_JSON);
                }else{
                    httpRequest.setHeader(CONTENT_TYPE, CONTENT_TYPE_FORM_ENCODED);
                }  
            }
            
            
            if(this.tokenNeeded != null) {
                TokenWrapper tok = HP_UTIL_HTTPUtils.getTokenWrapperMap().get(this.tokenNeeded);
                tok.removeTokenFromCache();
                String ttok = tok.getToken();
				 System.debug('**************************************** ttok '+ttok);
                httpRequest.setHeader(tok.headerKey, BEARER + ttok);
            }
            Http http = new Http();
            datetime startCall = datetime.now();
            httpRequest.setTimeout(HTTP_REQUEST_TIMEOUT_DEFAULT);
            HTTPResponse response = null;
            try {
                response = http.send(httpRequest);
            } catch(CalloutException e) {
                System.debug('Exception : ' + e.getMessage());
                saveLogResponse(httpRequest, response, (datetime.now().getTime() - startCall.getTime()));
                throw new TimeoutException(httpRequest);
            }
            datetime endCall = datetime.now();
            HP_UTIL_HTTPUtils.saveLogResponse(httpRequest, response, (endCall.getTime() - startCall.getTime()));
            if(response.getStatusCode() == 200){
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                if (this.type == GAIA_LABEL){
                    resultMap.put('token',(String)((Map<String, Object>)results.get('data')).get('token'));
                    resultMap.put('duration', '3600');
                }else {
                    resultMap.put('token',(String)results.get('access_token'));
                    resultMap.put('duration', String.valueOf((Integer)results.get('expires_in')));
                }  
            }
            return resultMap;
        }

        /** 
        * @author Slimene Belhaj Ali
        * @date 28/01/2020 
        * @description methode permer de construire l'url
        **/
        private String buildUrl() {
            if(this.method == POST) {
                return this.endPoint;
            }
            return this.endPoint + '?' + CLIENT_ID + '=' + this.clientId + '&' + CLIENT_SECRET + '=' +
            this.clientSecret + '&' + GRANT_TYPE + '=' + this.grantType;
        }

        /** 
        * @author Slimene Belhaj Ali
        * @date 28/01/2020 
        * @description methode permer de construire le body
        **/
        private String buildBody() {

            List<Schema.PicklistEntry>  ple = Schema.getGlobalDescribe().get('HP_Token_Parameter__mdt').getDescribe().fields.getMap().get('Type__c').getDescribe().getPicklistValues();

            if(this.method == GET) {
                return null;
            }

           for( Schema.PicklistEntry pickListVal : ple){
                if(pickListVal.getValue() == this.type){
                    return  HP_ParseUtils.serialize( new Map<String, Object> {
                        MDP_LABEL => this.mdp, GAIA_LABEL => this.gaia
                    }) ;
                }
            } 
            if(this.accountId != null){
                return HP_ParseUtils.serialize( new Map<String, Object> {
                    CLIENT_ID => this.clientId, CLIENT_SECRET => this.clientSecret, GRANT_TYPE => this.grantType, ACCOUNT_ID => this.accountId
                }) ;
            }else if(this.audience != null){
                return HP_ParseUtils.serialize( new Map<String, Object> {
                    CLIENT_ID => this.clientId, CLIENT_SECRET => this.clientSecret, GRANT_TYPE => this.grantType, AUDIENCE_TEXT => this.audience
                }) ;
            }else {
            return CLIENT_ID+'='+this.clientId+'&'+CLIENT_SECRET+'='+this.clientSecret+'&'+GRANT_TYPE+'='+this.grantType+'&scope='+this.scope.replaceAll(' ', '+');
        }
    }
    }
    
    /** 
    * @author Slimene Belhaj Ali
    * @date 28/01/2020 
    * @description endpoint wrapper
    **/
    class EndPointWrapper {
        String value;
        Boolean saveLog;
        Boolean isApigee;
        List<String> tokenList;
        List<String> headerMandatory;
        List<String> expectedResponseCode;
        /** 
        * @author Slimene Belhaj Ali
        * @date 28/01/2020 
        * @description Constructeur
        **/
        public EndPointWrapper(HP_Endpoint_Configuration__mdt endPointConf) {
            this.saveLog = endPointConf.SaveLog__c;
            this.isApigee = endPointConf.Is_API_Hour_Apigee__c;
            this.tokenList = new List<String>();
            if(endPointConf.Token_Needed__c != null) {
                tokenList = endPointConf.Token_Needed__c.split(';');
            }

            if(AUTH_MODE == API_HOUR && endPointConf.Is_API_Hour_Apigee__c){
                this.value = HP_UTIL_MetadataManager.getConfigByKey(API_HOUR_PREFIX) +endPointConf.Value__c;
                tokenList.add(API_HOUR_TOKEN);
                if(endPointConf.Value__c.contains(TRANQUILITY)){
                    tokenList.add(0,TRANQUILITY_TOKEN);
                }else if(endPointConf.Value__c.contains(AGILAB)){
                    tokenList.add(0,AGILAB_TOKEN);
                }
            }else if(AUTH_MODE == APIGEE && endPointConf.Is_API_Hour_Apigee__c){
                this.value = HP_UTIL_MetadataManager.getConfigByKey(APIGEE_PREFIX) +endPointConf.Value__c;
                tokenList.add(APIGEE_TOKEN);
                if(endPointConf.Value__c.contains(TRANQUILITY)){
                    tokenList.add(0,TRANQUILITY_TOKEN_APIGEE);
                }else if(endPointConf.Value__c.contains(AGILAB)){
                    tokenList.add(0,AGILAB_TOKEN_APIGEE);
                }
            }else {
                this.value = endPointConf.Value__c;
            }

            if(endPointConf.Header_Mandatory__c != null) {
                headerMandatory = endPointConf.Header_Mandatory__c.split(';');
            }

            if(endPointConf.ExpectedResponseCode__c != null) {
                expectedResponseCode = endPointConf.ExpectedResponseCode__c.split(';');
            }
        }
    }

    public class TimeoutException extends Exception {
        public HttpRequest req;
        public TimeoutException(HttpRequest req) { this.req = req; }
    }

}