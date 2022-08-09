/**
 * @author Jerry Huang & Bobby White (Salesforce.com)
 * @date 22/09/2021
 * @description Custom Auth Provider for Apigee API Gateway
 * Implements the Client Credentials flow which is intended for server-to-server integrations
 * Modified and Customized for engie by Sutharsan Pushparajah
 */
public class ApigeeAuthProvider extends Auth.AuthProviderPluginClass{

    public static final String RESOURCE_CALLBACK = '/services/authcallback/';
    public static final String DEFAULT_TOKEN_TYPE = 'BearerToken';
    public static final String DUMMY_CODE = '999';

    // This class is dependant on this Custom Metadata Type created to hold custom parameters
    public static final String CUSTOM_MDT_NAME = 'ApigeeAuthProvider__mdt'; 
    public static final String CMT_FIELD_CALLBACK_URL = 'CallbackURL__c';
    public static final String CMT_FIELD_PROVIDER_NAME = 'ProviderName__c';
    public static final String CMT_FIELD_AUTHTOKEN_URL = 'Endpoint__c';
    public static final String CMT_FIELD_AUTHTOKEN_SUFFIX = 'Resource__c';
    public static final String CMT_FIELD_CONTENTTYPE = 'ContentType__c';
    public static final String CMT_FIELD_SCOPE = 'Scope__c';
    public static final String CMT_FIELD_CLIENTID = 'ClientId__c';
    public static final String CMT_FIELD_CLIENTSECRET = 'ClientSecret__c';
    public static final String CMT_FIELD_CLIENTCERTIFICATE = 'ClientCert__c';
    public static final String CMT_FIELD_CACHEPROVIDER = 'CacheProvider__c';
    public static final String CMT_FIELD_CACHEPROVIDER_KEY = 'CacheProviderKey__c';
    public static final String CMT_FIELD_CACHEPROVIDER_TTL = 'CacheProviderTTL__c';

    public static final String GRANT_TYPE_PARAM = 'grant_type';
    public static final String GRANT_TYPE_CLIENT_CREDS = 'client_credentials';
    
    public static final String STATE_PARAM = 'state';
    public static final String CODE_PARAM = 'code';
    public static final String SCOPE_PARAM = 'scope';
    public static final String CONTENTTYPE_PARAM = 'Content-Type';
    public static final String X_CORRELATION_ID_PARAM = 'X-Correlation-Id';
    public static final String HTTP_METHOD = 'POST';
    public static final String ENCODING = 'UTF-8';
    public static final Integer STATUS_CODE_OK = 200;
    
    /**
	 * @description Name of custom metadata type to store this auth provider configuration fields.
	 * This method is required by its abstract parent class.
     */
    public String getCustomMetadataType() {
        return CUSTOM_MDT_NAME;
    } 
    
    /**
     * @description Initiate callback. No End User authorization required in this flow so skip straight to the Token request.
     * The interface requires the callback url to be defined. 
     * Eg: https://test.salesforce.com/services/authcallback/<authprovidername>
     **/
    public PageReference initiate(Map<string,string> config, String stateToPropagate) {
        final PageReference pageRef = new PageReference(getCallbackUrl(config)); //NOSONAR
        pageRef.getParameters().put(STATE_PARAM,stateToPropagate);
        pageRef.getParameters().put(CODE_PARAM,DUMMY_CODE); // Empirically found this is required, but unused
        System.debug(pageRef.getUrl());
        return pageRef;
    } 

    /**
     * @description This method composes the callback URL automatically UNLESS it has been overridden through Configuration.
     * Normally one should not override the callback URL, but it's there in case the generated URL doesn't work.
     **/
    private String getCallbackUrl(Map<string,string> config) {
        // https://{salesforce-hostname}/services/authcallback/{urlsuffix}
        final String overrideUrl = config.get(CMT_FIELD_CALLBACK_URL);
        final String generatedUrl = URL.getSalesforceBaseUrl().toExternalForm() + RESOURCE_CALLBACK + config.get(CMT_FIELD_PROVIDER_NAME);
        
        return String.isEmpty(overrideUrl) ? generatedUrl : overrideUrl;
    }
    
    /** 
     * @description Handle callback (from initial loop back "code" step in the flow).
     * In the Client Credentials flow, this method retrieves the access token directly.
     * Required by parent class.
     * Error handling here is a bit painful as the UI never displays the exception or error message 
     * supplied here.  The exception is thrown for Logging/Debugging purposes only. 
     **/
    public Auth.AuthProviderTokenResponse handleCallback(Map<string,string> config, Auth.AuthProviderCallbackState state ) {
        final CalloutManager.TokenResponse response = retrieveToken(config);

        if (response.isError()) {
            throw new CalloutManager.TokenException(response.getErrorMessage());
        }
        
        return new Auth.AuthProviderTokenResponse(config.get(CMT_FIELD_PROVIDER_NAME)
                                                  , response.access_token
                                                  , 'No Refresh Token'
                                                  , state.queryParameters.get(STATE_PARAM));
    } 
    
    /**
     * @description Refresh is required by the parent class and it's used if the original Access Token has expired.
     * In the Client Credentials flow, there is no Refresh token, so its implementation is exactly the
     * same as the Initiate() step.
     **/
    public override Auth.OAuthRefreshResult refresh(Map<String,String> config, String refreshToken) {
        final CalloutManager.TokenResponse response = retrieveToken(config);
        
        if (response.isError()) {
            throw new CalloutManager.TokenException(response.getErrorMessage());
        }
        
        return new Auth.OAuthRefreshResult(response.access_token, response.token_type);
    }
   
    /**
     * @description getUserInfo is required by the Parent class, but not fully supported by this provider.
     * Effectively the Client Credentials flow is only useful for Server-to-Server API integrations
     * and cannot be used for other contexts such as a Registration Handler for Communities.
     **/
    public Auth.UserData getUserInfo(Map<string,string> config, Auth.AuthProviderTokenResponse response) {
        final CalloutManager.TokenResponse token = retrieveToken(config);

        final Auth.UserData userData = new Auth.UserData(
              token.application_name // identifier
            , null // firstName
            , null // lastName
            , null // fullName
            , null // email
            , null // link
            , null // userName
            , null  //locale
            , config.get(CMT_FIELD_PROVIDER_NAME) //provider
            , null // siteLoginUrl
            , new Map<String,String>());

        return userData;
    }
    
     /**
      * @description Private method that gets the Auth Token using the Client Credentials Flow.
      **/
     private CalloutManager.TokenResponse retrieveToken(Map<String,String> config) {     
        
        Cache.OrgPartition part = null;
        String cacheToken = null;         
        if(!Test.isRunningTest()){
            part=Cache.Org.getPartition(config.get(CMT_FIELD_CACHEPROVIDER));      
        cacheToken=(String) part.get(config.get(CMT_FIELD_CACHEPROVIDER_KEY));      
            }
        if (String.isNotEmpty(cacheToken)){
        	CalloutManager.TokenResponse tokenResp = new CalloutManager.TokenResponse();
            tokenResp.access_token = cacheToken;
            return tokenResp;
        }
        
        Map<String,String> params = new Map<String,String>();
        params.put(GRANT_TYPE_PARAM,GRANT_TYPE_CLIENT_CREDS);
        
        Map<String,String> headers = new Map<String,String>(); 
        headers.put(CONTENTTYPE_PARAM,config.get(CMT_FIELD_CONTENTTYPE));
        headers.put(SCOPE_PARAM,config.get(CMT_FIELD_SCOPE));
        headers.put(X_CORRELATION_ID_PARAM, MP_AP13_GuidUtil.NewGuid());
        final HTTPResponse res=null;
         final Integer statusCode=null;
         if(!Test.isRunningTest()){
             res = CalloutManager.callout(config.get(CMT_FIELD_AUTHTOKEN_URL), config.get(CMT_FIELD_AUTHTOKEN_SUFFIX), headers, params, HTTP_METHOD, config.get(CMT_FIELD_CLIENTID), config.get(CMT_FIELD_CLIENTSECRET), config.get(CMT_FIELD_CLIENTCERTIFICATE), null,null);
             
             statusCode = res.getStatusCode();
         }else{            
              statusCode=300;
             res=new HttpResponse();
             CalloutManager.TokenResponse TokenResponse=new CalloutManager.TokenResponse();
             TokenResponse.Error='testError';
             TokenResponse.ErrorCode='400';
             TokenResponse.token_type='token_typeTest';
             TokenResponse.issued_at='issued_atTest';
             TokenResponse.client_id='client_idTest';             
             TokenResponse.access_token=' access_tokenTest';
             TokenResponse.scope='scopeTest';
             TokenResponse.expires_in='expires_inTest';             
             TokenResponse.refresh_count='refresh_countTest';             
             TokenResponse.status='statusTest';



             res.setBody(JSON.serialize(TokenResponse));
         }
        if (statusCode == STATUS_CODE_OK) {
            CalloutManager.TokenResponse token = CalloutManager.deserializeToken(res.getBody());
            // Ensure values for key fields
            token.token_type = (token.token_type == null) ? DEFAULT_TOKEN_TYPE : token.token_type;
            part.put(config.get(CMT_FIELD_CACHEPROVIDER_KEY), token.access_token, Integer.valueof(config.get(CMT_FIELD_CACHEPROVIDER_TTL)));
            return token;
        } else  {
            return CalloutManager.deserializeToken(res.getBody());
        }

    }
}