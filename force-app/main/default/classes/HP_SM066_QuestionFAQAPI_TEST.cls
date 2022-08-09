/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 08-23-2021
 * @last modified by  : Badr Eddine Belkarchi
**/
@isTest 
public with sharing class HP_SM066_QuestionFAQAPI_TEST {

    @isTest 
    public static void questionsFAQCreation() {

        List<HP_WRP043_QuestionFAQ.QuestionFaqApi> questionFaqApiList = new List<HP_WRP043_QuestionFAQ.QuestionFaqApi>();
        HP_WRP043_QuestionFAQ.QuestionFaqApi questionFaqApi =  new HP_WRP043_QuestionFAQ.QuestionFaqApi(
            1,111,11,'Test Account','Test Account','Test Account','Test Account');
        questionFaqApiList.add(questionFaqApi);

        HP_WRP043_QuestionFAQ.Request req = new HP_WRP043_QuestionFAQ.Request(questionFaqApiList);
        HP_WRP022_SFResponse response = new HP_WRP022_SFResponse (HP_HttpStatus.OK);


        Test.startTest();
        HP_SM066_QuestionFAQAPI.questionsFAQCreation(req, response);
        Test.stopTest();
    }

    @isTest 
    public static void convertQuestionFaqFromApi() {

        List<HP_WRP043_QuestionFAQ.QuestionFaqApi> questionFaqApiList = new List<HP_WRP043_QuestionFAQ.QuestionFaqApi>();
        HP_WRP043_QuestionFAQ.QuestionFaqApi questionFaqApi =  new HP_WRP043_QuestionFAQ.QuestionFaqApi(
            1,111,11,
            'Test Account','Test Account','Test Account','Test Account');
        questionFaqApiList.add(questionFaqApi);

        Test.startTest();
        List<HP_QuestionFAQ__C> questionFaqList = HP_SM066_QuestionFAQAPI.convertQuestionFaqFromApi(questionFaqApiList);
        Test.stopTest();

        System.assert(questionFaqList.size() > 0);
    }
}