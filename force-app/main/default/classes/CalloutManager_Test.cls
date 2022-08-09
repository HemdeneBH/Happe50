@isTest 
public class CalloutManager_Test {

    //expected header for resource callout
	public static Map<String, String> headersService = new Map<String, String>{ 
        'scope' => 'apihour:read',
        'Content-Length' => '0',
        'X-Correlation-Id' => MP_AP13_GuidUtil.NewGuid()};
    
    //expected header for token service
    public static Map<String, String> headersToken = new Map<String, String>{
        'Content-Type' => 'application/x-www-form-urlencoded', 
        'scope' => 'apihour:read',
        'X-Correlation-Id' => MP_AP13_GuidUtil.NewGuid()};
    
    //expected body parameters to encode        
    public static Map<String, String> config = new Map<String, String>{
        'grant_type' => 'client_credentials'};
    public static final String ENDPOINT_WITH_URL = 'test';
    public static final String TOKEN_SUFFIX = '/oauth2/v1/token';
    public static final String RESOURCE_SUFFIX = '/api/apiset/0.1/locaux?idLocaux=0';
    public static final String CLIENTID = 'test_CLIENTID';
    public static final String CLIENTSECRET = 'test_CLIENTSECRET';
    public static final String CLIENTCERT = null;

    @isTest 
    public static void sendRequest_Test() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SM_MockResponseApiLocal');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        system.debug('sendData mock : '+mock);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        HttpResponse response = CalloutManager.sendRequest('locaux',null, 'GET', CalloutManager.Scope.READ, null, null);
        if (CalloutManager.httpResponseFailureDetected(response)) {
			system.debug(response != null ? response.getBody() : 'http response is null');
		}
        Test.stopTest();
        system.assertEquals(200, response.getStatusCode());
    }

    @isTest
    public static void getToken_Test(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SM_MockResponseGetTokenApigee');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        system.debug('sendData mock : '+mock);
        Test.setMock(HttpCalloutMock.class, mock);
        HttpResponse response = CalloutManager.callout(ENDPOINT_WITH_URL,TOKEN_SUFFIX,headersToken,config,'POST',CLIENTID,CLIENTSECRET,CLIENTCERT,null,null);
        System.debug('Response: '+response.getBody());
        CalloutManager.TokenResponse token = new CalloutManager.TokenResponse();
        token = CalloutManager.deserializeToken(response.getbody());
        system.assertEquals(200, response.getStatusCode());
        system.assertEquals('Bearer',token.token_type);
    }
    @isTest
    public static void tokenResponse_Test(){
        CalloutManager.Fault fault = new CalloutManager.Fault();
        fault.detail = new CalloutManager.Detail();
        fault.faultstring = 'test';
        CalloutManager.TokenResponse token = new CalloutManager.TokenResponse();
        token.token_type ='Test_type';
        token.issued_at = String.valueOf(Date.today());
        token.client_id = 'test_client_id';
        token.access_token = 'test';
        token.application_name = 'SMILE';
        token.scope = 'Apihour:read';
        token.expires_in = String.valueOf(Date.today());
        token.refresh_count = '10';
        token.status = 'Unauthorized';
        token.ErrorCode ='400';
        token.Error = 'Error';
        token.fault = fault;
        
        system.assertEquals(true, token.isError());
        system.assertEquals('Code: 400/ Message: Error', token.getErrorMessage());
        
        
    }
}