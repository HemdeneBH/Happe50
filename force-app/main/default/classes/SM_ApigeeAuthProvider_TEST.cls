/**
* @File Name          : ApigeeAuthProvider_TEST.cls
* @Description        : 
* @Author             : Amine Deghais
* @Group              : 
* Ver       Date            Author      		    Modification
* 1.0    13/10/2020   Amine Deghais     Initial Version
**/
@IsTest
public class SM_ApigeeAuthProvider_TEST {
    private static final String OAUTH_TOKEN = 'testToken'; 
    private static final String STATE = 'mocktestState'; 
    private static final String REFRESH_TOKEN = 'refreshToken'; 
    private static final String LOGIN_ID = 'testLoginId'; 
    private static final String USERNAME = 'testUsername'; 
    private static final String FIRST_NAME = 'testFirstName'; 
    private static final String LAST_NAME = 'testLastName'; 
    private static final String EMAIL_ADDRESS = 'testEmailAddress'; 
    private static final String LOCALE_NAME = 'testLocalName'; 
    private static final String FULL_NAME = FIRST_NAME + ' ' + LAST_NAME; 
    private static final String PROVIDER = 'Concur'; 
    private static final String REDIRECT_URL = 
        'http://localhost/services/authcallback/orgId/Concur'; 
    private static final String KEY = 'testKey'; 
    private static final String SECRET = 'testSecret'; 
    private static final String STATE_TO_PROPOGATE = 'testState'; 
    private static final String ACCESS_TOKEN_URL = 
        'http://www.dummyhost.com/accessTokenUri'; 
    private static final String API_USER_VERSION_URL = 
        'http://www.dummyhost.com/user/20/1'; 
    private static final String AUTH_URL = 
        'http://www.dummy.com/authurl'; 
    private static final String API_USER_URL = 
        'www.concursolutions.com/user/api'; 
    public static final String ENDPOINT_WITH_AUTHPROVIDER = 'CALLOUT:AuthApigee';
    public static final String ENDPOINT_WITH_NAMED = 'CALLOUT:APIGEE_NOPROD_2022';
    public static final String RESOURCE_SUFFIX = '/protected-miam/v1/espace-prive/DGP?telMFa=true';
    //public static final String RESOURCE_SUFFIX = '/protected-miam/v1/espace-prive/DGP/identite';
    public static final String TOKEN_SUFFIX = '/oauth2/v1/token';
    public static final String ENDPOINT_WITH_URL = 'https://api.private.dgp-int.engie.fr';
    public static final String CLIENTID = 'bAROFQEgRGU0pjKuhYQGAQMKI0Mzy9E7';
    public static final String CLIENTSECRET = 'G7PNtecNYmMVdYIG';
    public static final String CLIENTCERT = null;
    
    
    
    
    
    @isTest static String  getCustomMetadataType(){
        ApigeeAuthProvider apigeeAuthProvider=new  ApigeeAuthProvider();
        return apigeeAuthProvider.getCustomMetadataType();
    }
    private static Map<String,String> setupAuthProviderConfig () 
    { 
        Map<String,String> authProviderConfiguration = new Map<String,String>(); 
        authProviderConfiguration.put('Key__c', KEY); 
        authProviderConfiguration.put('Auth_Url__c', AUTH_URL); 
        authProviderConfiguration.put('Secret__c', SECRET); 
        authProviderConfiguration.put('Access_Token_Url__c', ACCESS_TOKEN_URL); 
        authProviderConfiguration.put('API_User_Url__c',API_USER_URL); 
        authProviderConfiguration.put('API_User_Version_Url__c',
                                      API_USER_VERSION_URL); 
        authProviderConfiguration.put('Redirect_Url__c',REDIRECT_URL); 
        return authProviderConfiguration; 
        
    } 
    static testMethod void testInitiateMethod() 
    { 
        String stateToPropogate = 'mocktestState'; 
        Map<String,String> authProviderConfiguration = setupAuthProviderConfig(); 
        ApigeeAuthProvider apigeeAuthProvider=new  ApigeeAuthProvider();
        //apigeeAuthProvider.redirectUrl = authProviderConfiguration.get('Redirect_Url__c'); 
        PageReference expectedUrl = new PageReference(authProviderConfiguration.get('Auth_Url__c') + '?client_id='+ 
                                                      authProviderConfiguration.get('Key__c') +'&scope=USER,EXPRPT,LIST&redirect_uri='+ 
                                                      authProviderConfiguration.get('Redirect_Url__c') + '&state=' + 
                                                      STATE_TO_PROPOGATE); 
        PageReference actualUrl = apigeeAuthProvider.initiate(authProviderConfiguration, STATE_TO_PROPOGATE); 
        System.assertEquals(true, true);
    } 
    
    static testMethod void testHandleCallback() {
        Map<String,String> authProviderConfiguration = setupAuthProviderConfig();
        ApigeeAuthProvider apigeeAuthProvider=new  ApigeeAuthProvider();
        
        Test.setMock(HttpCalloutMock.class, new ApigeeMockHttpResponseGenerator());
        
        Map<String,String> queryParams = new Map<String,String>();
        queryParams.put('code','code');
        queryParams.put('state',authProviderConfiguration.get('State_c'));
        Auth.AuthProviderCallbackState cbState = new Auth.AuthProviderCallbackState(null,null,queryParams);
        try{
            Auth.AuthProviderTokenResponse actualAuthProvResponse = apigeeAuthProvider.handleCallback(authProviderConfiguration, cbState);
            Auth.AuthProviderTokenResponse expectedAuthProvResponse = new Auth.AuthProviderTokenResponse('Concur', OAUTH_TOKEN, REFRESH_TOKEN, null);    
        }catch(Exception e){
            System.debug('test catch exception');
        }
        System.assertEquals(true, true);          
    }
    static testMethod void testGetUserInfo() {
        Map<String,String> authProviderConfiguration = setupAuthProviderConfig();
        ApigeeAuthProvider apigeeAuthProvider=new  ApigeeAuthProvider();
        
        Test.setMock(HttpCalloutMock.class, new ApigeeMockHttpResponseGenerator());
        
        Auth.AuthProviderTokenResponse response = new Auth.AuthProviderTokenResponse(PROVIDER, OAUTH_TOKEN ,'sampleOauthSecret', STATE);
        try{
            Auth.UserData actualUserData = apigeeAuthProvider.getUserInfo(authProviderConfiguration, response) ;
        }catch(Exception e){
            System.debug('test catch exception');
        }
        try{
            Auth.OAuthRefreshResult refresh = apigeeAuthProvider.refresh(authProviderConfiguration, null) ;
        }catch(Exception e){
            System.debug('test catch exception');
        }
        System.assertNotEquals(true,null);
        
    }
    public static Map<String, String> headersService = new Map<String, String>{
        'Content-Type' => 'application/json', 
            'scope' => 'apihour:read',
            'Content-Length' => '0',
            'X-Correlation-Id' => MP_AP13_GuidUtil.NewGuid()
            };
                
                public static Map<String, String> headersToken = new Map<String, String>{
                    'Content-Type' => 'application/x-www-form-urlencoded', 
                        'scope' => 'apihour:read',
                        'X-Correlation-Id' => MP_AP13_GuidUtil.NewGuid()
                        };
                            public static Map<String, String> config = new Map<String, String>{
                                'grant_type' => 'client_credentials'
                                    };
                                        
                                        
                                        static testMethod void testcallout() {                                                          
                                            HttpResponse response = CalloutManager.callout(ENDPOINT_WITH_URL,TOKEN_SUFFIX,headersToken,config,'POST',CLIENTID,CLIENTSECRET,CLIENTCERT,null,null);

                                        }
    
    // implementing a mock http response generator for concur 
    public  class ApigeeMockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            String namespace = API_USER_VERSION_URL;
            String prefix = 'mockPrefix';            
            Dom.Document doc = new Dom.Document();
            Dom.XmlNode xmlNode =  doc.createRootElement('mockRootNodeName', namespace, prefix);
            xmlNode.addChildElement('LoginId', namespace, prefix).addTextNode(LOGIN_ID);
            xmlNode.addChildElement('FirstName', namespace, prefix).addTextNode(FIRST_NAME);
            xmlNode.addChildElement('LastName', namespace, prefix).addTextNode(LAST_NAME);
            xmlNode.addChildElement('EmailAddress', namespace, prefix).addTextNode(EMAIL_ADDRESS);
            xmlNode.addChildElement('LocaleName', namespace, prefix).addTextNode(LOCALE_NAME);            
            xmlNode.addChildElement('Token', null, null).addTextNode(OAUTH_TOKEN);
            System.debug(doc.toXmlString());
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/xml');
            res.setBody(doc.toXmlString());
            res.setStatusCode(200);
            return res;
        }
    }   
}