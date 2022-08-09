/**
 * @author Sutharsan Pushparajah
 * @date 15/04/2022
 * @description SM_DM203_TranquilityRest - Every Tranquility REST Webservice class must cal this class to handle Tranquiliy API Specificities
 */
public inherited sharing class SM_DM203_TranquilityRest {

    /* Name of the http request service setting for users login */
    public static final String USERS_LOGIN_SERVICE_NAME = 'TRANQUILITY_USERS_LOGIN';
    /* Root node of the response payload */
    private static final String ROOT_NODE = 'data';
    /* Token node of the response payload */
    private static final String TOKEN_NODE = 'token';
    /* This body param will contain the username */
    private static final String USERNAME_PARAM = 'gaia';
    /* This body param will contain the password */
    private static final String PASSWORD_PARAM = 'mdp';
    /* The authorization bearer header */
    private static final String AUTHORIZATION_HEADER = 'x-Authorization';

    /* Users login remote service instance */
    private static final ITF004_HttpRequestManager usersLoginServiceHttp = new SM_DM202_ApigeeRest(USERS_LOGIN_SERVICE_NAME);
    /* any Tranquility API remote service instance */
    private ITF004_HttpRequestManager tranquilityServiceHttp;

    /* The username is stored in this custommetadata, it's not a good practise but keeping it for backward compatibility */
    private static final String USERNAME;
    /* The password is stored in this custommetadata, it's not a good practise but keeping it for backward compatibility */
    private static final String PASSWORD; 

    /* Identity token retrieved once per transaction to minimize calls */
    private static String tranquilityToken;

    static {
        //Compatibility with test classes
        try{
            USERNAME = MP_Xdata_credentials__c.getInstance('sm_user_tranquility').Value__c;
        } catch (Exception exp){
            USERNAME = 'FAKE';
        }

        try{
            PASSWORD = MP_Xdata_credentials__c.getInstance('sm_password_tranquility').Value__c;
        } catch (Exception exp){
            PASSWORD = 'FAKE';
        }

        tranquilityToken = SM_DM203_TranquilityRest.getToken(new WRP003_HttpRequest());
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 15/04/2022
     * @description Constructor to instanciate the service settings
     * @param serviceName DeveloperName of the HttpRequestService__mdt setting 
     * @return void
     */
    public SM_DM203_TranquilityRest(String serviceName) {
        tranquilityServiceHttp = new SM_DM202_ApigeeRest(serviceName);
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 15/04/2022
     * @description Call Tranquility Users Login API to get a valid identity token
     * @param httpRequestInfos wrapper containing request/response infos
     * @return String Identity Token from WS call
     */
    @TestVisible
    private static String getToken(WRP003_HttpRequest httpRequestInfos){
        httpRequestInfos.requestType = 'POST';
        httpRequestInfos.bodyParams.put(USERNAME_PARAM, USERNAME);
        httpRequestInfos.bodyParams.put(PASSWORD_PARAM, PASSWORD);
        
        usersLoginServiceHttp.sendRequest(httpRequestInfos);

        Map<String, Object> resultAsMap = (Map<String, Object>) JSON.deserializeUntyped(httpRequestInfos.httpResponse.getBody());
        Map<String, Object> bearer = (Map<String,Object>) resultAsMap.get(ROOT_NODE);
        String tokenTranquility = (String) bearer.get(TOKEN_NODE);

        return tokenTranquility;
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 15/04/2022
     * @description method to callout external service
     * @param httpRequestInfos wrapper containing request/response infos 
     * @return void
     */
    public void sendRequest(WRP003_HttpRequest httpRequestInfos){
        Map<String, String> tranquilityHeaders = new Map<String, String>{AUTHORIZATION_HEADER => tranquilityToken};
        httpRequestInfos.header.putAll(tranquilityHeaders);
        tranquilityServiceHttp.sendRequest(httpRequestInfos);
    }
}