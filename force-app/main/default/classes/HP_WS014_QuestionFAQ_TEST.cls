/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 08-13-2021
 * @last modified by  : Badr Eddine Belkarchi
**/
@isTest
public with sharing class HP_WS014_QuestionFAQ_TEST {

    @isTest 
    public static void questionFAQCreation() {

        List<HP_WRP043_QuestionFAQ.QuestionFaqApi> questionFaqApiList = new List<HP_WRP043_QuestionFAQ.QuestionFaqApi>();
        HP_WRP043_QuestionFAQ.QuestionFaqApi questionFaqApi =  new HP_WRP043_QuestionFAQ.QuestionFaqApi(
            1,111,11,'Test Account','Test Account','Test Account','Test Account');
        questionFaqApiList.add(questionFaqApi);

        HP_WRP043_QuestionFAQ.Request req = new HP_WRP043_QuestionFAQ.Request(questionFaqApiList);

        RestRequest reqHttp = new RestRequest();
        RestResponse resHttp = new RestResponse();

        reqHttp.requestBody = Blob.valueof(JSON.serialize(req, false));
        RestContext.request = reqHttp;
        RestContext.response = resHttp;


        Test.startTest();
        HP_WS014_QuestionFAQ.questionFAQCreation();
        Test.stopTest();
    }
}