/*
*@Author: Paul Ghousoub
*@Description: Classe test de VI_SM013_GetTokenService.
*@CreatedDate: 04/11/2020
*@LastModified: 05/11/2020
*/
@isTest
public class VI_SM013_GetTokenService_Test {
    @testSetup
    static void testSetup(){
        VI_TestDataFactory.createDummyXData();
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
        
        MP_Xdata_credentials__c consumerKeyB2C = new MP_Xdata_credentials__c();
        consumerKeyB2C.Value__c = 'PCKEY';
        consumerKeyB2C.Name = 'VI_consumerKeyAPIGEE_B2C';
        insert consumerKeyB2C;
        
        MP_Xdata_credentials__c consumerSecretB2C = new MP_Xdata_credentials__c();
        consumerSecretB2C.Value__c = 'PCVALUE';
        consumerSecretB2C.Name = 'VI_consumerSecretAPIGEE_B2C';
        insert consumerSecretB2C;
    }
    @isTest
    public static void test() {
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_TestToken');
        
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multimock);
        String testToken=VI_SM013_GetTokenService.getToken('VI', 'local.VIToken');
        System.assertEquals(testToken, 'ENED');
        Test.stopTest();
    }
    @isTest
    public static void test2() {
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_TestToken');
        
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multimock);
        String testToken=VI_SM013_GetTokenService.getTokenB2C('VI', 'local.VITokenB2C');
        System.assertEquals(testToken, 'ENED');
        Test.stopTest();
    }
    
}