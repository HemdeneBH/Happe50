/*
*@Author: Paul Ghousoub
*@Description: Classe test de VI_SM001_EmailPhoneVerification.
*@CreatedDate: 04/11/2020
*@LastModified: 05/11/2020
*/
@isTest
public class VI_SM001_EmailPhoneVerification_Test {
    @testSetup
    static void testSetup(){
        VI_TestDataFactory.createDummyXData();
    }
    
    @isTest
    public static void testVerificationEmail(){
        
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_SM001_EmailPhoneVerificationService');
        
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multimock);
        String testdata=VI_SM001_EmailPhoneVerificationService.verifyEmail('abcd@test.com', 'VI', 'local.VIToken');
        system.debug('testdata '+testdata);
        system.assertEquals('OK', testdata);
        Test.stopTest();
    }
    @isTest
    public static void testVerificationPhoneNumber(){
        
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_SM001_PhoneVerificationService');
        
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multimock);
        String testdata=VI_SM001_EmailPhoneVerificationService.verifyPhoneNumber('+33333333333', 'VI', 'local.VIToken');
        system.debug('testdata '+testdata);
        system.assertEquals('OK', testdata);
        Test.stopTest();
    }
}