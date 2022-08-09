/*
*@Author: Paul Ghousoub
*@Description: Classe test de VI_SM004_QuestionConsentementAPI.
*@CreatedDate: 04/11/2020
*@LastModified: 05/11/2020
*/
@isTest
public class VI_SM004_QuestionConsentementAPI_Test {  
    @testSetup
    static void testSetup(){
        VI_TestDataFactory.createDummyXData();
    }
    @isTest
    public static void test() {
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_TestQuestionsConsentement');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multimock);
        VI_SM004_QuestionConsentementAPI.QuestionConsentementResponse rep=VI_SM004_QuestionConsentementAPI.callQuestionConsentement('VI', 'local.VIToken');
        system.debug(rep.data[0].libelleQuestion);
        system.assertEquals(rep.data[0].libelleQuestion, 'q11');
        Test.stopTest();
    }
}