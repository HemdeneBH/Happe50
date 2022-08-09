/*
*@Author: Paul Ghousoub
*@Description: Classe test de VI_SM011_ConsentementAnswers_API.
*@CreatedDate: 04/11/2020
*@LastModified: 05/11/2020 
*/
@isTest
public class VI_SM011_ConsentementAnswers_API_Test { 
    @isTest 
    static void testConsentementAnswers(){
        List < VI_SM011_ConsentementAnswers_API.consentementAnswer > consentmentAnswers=new List < VI_SM011_ConsentementAnswers_API.consentementAnswer >(); 
        List<Object> testList=new List<Object>();
        Map<String,Object>testMap=new Map<String,Object>();
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_TestConsentementAnswers');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multimock);
        consentmentAnswers=VI_SM011_ConsentementAnswers_API.getConsentementAnswersData('asfds','VI', 'local.VIToken');
        system.assertEquals(consentmentAnswers[0].idQuestion, 2);
        TESTmap=VI_SM011_ConsentementAnswers_API.updateConsentements('test','test',consentmentAnswers, 'SMILE', 'Telephone','VI', 'local.VIToken');
        Test.stopTest();
    }
}