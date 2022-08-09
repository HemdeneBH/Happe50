/*
*@Author: Eloi Dereeper
*@Description: Classe test de VI_UTIL001_HttpUtilities.
*@CreatedDate: 04/11/2020
*@LastModified: 05/11/2020
*/
@isTest
public class VI_UTIL001_HttpUtilities_Test {
    @testSetup 
    static void testSetup(){ 
        MP_Xdata_credentials__c scope = new MP_Xdata_credentials__c();
        scope.Value__c = '516a8780-afd6-45d0-903e-e3caaeab4bc5';
        scope.Name = 'VI_scopeAPIGEE';
        insert scope;
        
        MP_Xdata_credentials__c consumerKey = new MP_Xdata_credentials__c();
        consumerKey.Value__c = '516a8780-afd6-45d0-903e-e3caaeab4bc5';
        consumerKey.Name = 'VI_consumerKeyAPIGEE';
        insert consumerKey;
        
        MP_Xdata_credentials__c consumerSecret = new MP_Xdata_credentials__c();
        consumerSecret.Value__c = '516a8780-afd6-45d0-903e-e3caaeab4bc5';
        consumerSecret.Name = 'VI_consumerSecretAPIGEE';
        insert consumerSecret;
        
        MP_Xdata_credentials__c client_id = new MP_Xdata_credentials__c();
        client_id.Value__c = '516a8780-afd6-45d0-903e-e3caaeab4bc5';
        client_id.Name = 'VI_client_id';
        insert client_id;
        
        MP_Xdata_credentials__c client_secret = new MP_Xdata_credentials__c();
        client_secret.Value__c = 'fa1a7c0c-8420-447e-bfd8-b54303b84794';
        client_secret.Name = 'VI_client_secret';
        insert client_secret;
        
        MP_Xdata_credentials__c VI_api_key_digital_INT = new MP_Xdata_credentials__c();
        VI_api_key_digital_INT.Value__c = '516a8780-afd6-45d0-903e-e3caaeab4bc5';
        VI_api_key_digital_INT.Name = 'VI_api_key_digital_INT';
        insert VI_api_key_digital_INT;
        
        MP_Xdata_credentials__c VI_api_key_INT = new MP_Xdata_credentials__c();
        VI_api_key_INT.Value__c = '516a8780-afd6-45d0-903e-e3caaeab4bc5';
        VI_api_key_INT.Name = 'VI_api_key_INT';
        insert VI_api_key_INT;
        
        MP_Xdata_credentials__c VI_digital_id_client = new MP_Xdata_credentials__c();
        VI_digital_id_client.Value__c = '516a8780-afd6-45d0-903e-e3caaeab4bc5';
        VI_digital_id_client.Name = 'VI_digital_id_client';
        insert VI_digital_id_client;
        
        MP_Xdata_credentials__c VI_digital_secret_client = new MP_Xdata_credentials__c();
        VI_digital_secret_client.Value__c = '516a8780-afd6-45d0-903e-e3caaeab4bc5';
        VI_digital_secret_client.Name = 'VI_digital_secret_client';
        insert VI_digital_secret_client;
        
        MP_Xdata_credentials__c VI_scope = new MP_Xdata_credentials__c();
        VI_scope.Value__c = 'apiset.read';
        VI_scope.Name = 'VI_scope';
        insert VI_scope;
        
        MP_Xdata_credentials__c VI_user_tranquility = new MP_Xdata_credentials__c();
        VI_user_tranquility.Value__c = '4bf81dd4-b8ec-4c4b-9c84-8e009d8a2b35';
        VI_user_tranquility.Name = 'VI_user_tranquility';
        insert VI_user_tranquility;
        
        MP_Xdata_credentials__c VI_password_tranquility = new MP_Xdata_credentials__c();
        VI_password_tranquility.Value__c = '868e3fed-b555-4e42-9430-5bc93755ca51';
        VI_password_tranquility.Name = 'VI_password_tranquility';
        insert VI_password_tranquility;
    }
    
    @isTest
    static void getTokenResponse_test(){
        HttpResponse getTokenResponse = VI_UTIL001_HttpUtilities.getTokenResponse('VI');
        system.debug('getTokenResponse '+getTokenResponse);
    }
    
    @isTest
    static void getTokenResponseApigee_test(){
        HttpResponse getTokenResponse = VI_UTIL001_HttpUtilities.getTokenResponseApigee('VI');
        system.debug('getTokenResponse '+getTokenResponse);
    }
    
    @isTest
    static void makeHttpCall_test(){
        Map<String, String> params = new Map<String, String> {'Email' => 'test@test.com'};
            HttpResponse httpRespId = VI_UTIL001_HttpUtilities.makeHttpCall('1234','GET','VerifyEmail',params,null, null, 'VI');
        system.debug('httpRespId '+httpRespId);
    }
    
    @isTest
    static void getResponseConsentement_test(){
        HttpResponse httpResp = VI_UTIL001_HttpUtilities.getResponseConsentement('1234','GET','QuestionConsentementAPI',
                                                                                 'VI_Questions_Consentement',null,null, 'VI');
        system.debug('httpResp '+httpResp);
    }
    
    @isTest
    public static void testSearchAdress() {
        List<String> listt=new List<String>();
        listt.add('element');
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_AdressesApiService');        
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multimock);
        HttpResponse respAddr = VI_UTIL001_HttpUtilities.makeGetCalloutAdresse('8 rue Jonquières 31500 Toulouse');
        Test.stopTest();
    }  
    
    @isTest
    public static void test_getTransactionId(){
        VI_UTIL001_HttpUtilities.getTransactionId();
        VI_UTIL001_HttpUtilities.buildLog('bodyResponse', 'bodyRequest', 'keyrow', 200, 'endpoint', 'GET');
    }
    
    @isTest
    public static void test_handleResponse(){
        String json = '_pagination TEST __ TEST _data TEST _links';
        String jsonHandled = VI_UTIL001_HttpUtilities.handleResponse(json);
        system.assertEquals(jsonHandled, 'pagination TEST _ TEST data TEST links');
    }
    
    @isTest
    public static void test_makeHttpCall(){
        Map<String, String> parameters = new Map<String, String>();
        parameters.put('test', 'test');
        Map<String, Object> bodyRequest = new Map<String, Object>();
        bodyRequest.put('test', 'test');
        httpResponse response = VI_UTIL001_HttpUtilities.makeHttpCall('token', 'GET', 'apiName', parameters, bodyRequest, '123456678994', 'contentType', 'accept', 'xAuthorization', 'VI');
    }
    
}