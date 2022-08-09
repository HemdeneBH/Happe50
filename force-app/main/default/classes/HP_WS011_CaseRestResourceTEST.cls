/**
 * @File Name          : HP_WS011_CaseRestResourceTEST.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 26/04/2020 à 10:41:36
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    26/04/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
@IsTest
public class HP_WS011_CaseRestResourceTEST {


    @testSetup static void dataSetup(){
        System.runAs(HP_UTIL_SmartFactory.insertUserHP()){
        }
    }


    @istest()
    static void apiSubscriptionTest(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){

        final String data = '{"selfcareCase": {"enrolmentCase_v0_1": {"surname": "string","lastName": "string","email": "user@example.com","phoneNumber": "string",'
        +'"caseName": "string", "backOfficeProcessing": "NEW_CASE"}}}';
		RestRequest restR = new RestRequest(); 	 
		restR.requestURI = '/case/recontact/subscription';
		restR.httpMethod = 'POST';
		restR.requestBody = Blob.valueof(data);
        RestContext.request = restR;
        RestContext.response= new RestResponse();
        Test.startTest();
        HP_WS011_CaseRestResource.save();
        Test.stopTest();
    }

    }
    
    @istest()
    static void apiServiceTest(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){

        final String data = '{"selfcareCase": {"enrolmentCase_v0_1": {"surname": "string","lastName": "string","email": "user@example.com","phoneNumber": "string",'
        +'"caseName": "string", "backOfficeProcessing": "NEW_CASE"}}}';
		RestRequest restR = new RestRequest(); 	 
		restR.requestURI = '/case/recontact/service';
		restR.httpMethod = 'POST';
		restR.requestBody = Blob.valueof(data);
        RestContext.request = restR;
        RestContext.response= new RestResponse();
        Test.startTest();
        HP_WS011_CaseRestResource.save();
        Test.stopTest();
    }

    }
    
    @istest()
    static void apiFailTest(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){

        final String data = 'test';
		RestRequest restR = new RestRequest(); 	 
		restR.requestURI = '/case/recontact/';
		restR.httpMethod = 'POST';
		restR.requestBody = Blob.valueof(data);
        RestContext.request = restR; 
        RestContext.response= new RestResponse();
        Test.startTest();
        HP_WS011_CaseRestResource.firstUpdate();
        Test.stopTest();
    }
}
}