/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 08-23-2021
 * @last modified by  : Badr Eddine Belkarchi
**/
@isTest
public with sharing class HP_EM052_QuestionFAQ_TEST {

    @isTest 
    public static void upsertQuestionsFAQ() {

        List<HP_QuestionFAQ__C> questionsFAQList = new List<HP_QuestionFAQ__C>();
        HP_QuestionFAQ__C q = new HP_QuestionFAQ__C();
        q.HP_IdDigital__c       = 1;
        q.HP_VotePositifs__c    = 100;
        q.HP_VoteNegatifs__c    = 10;
        q.HP_Titre__c            = 'Titre';
        q.HP_Categorie__c        = 'Categorie';
        q.HP_SousCategorie__c   = 'SousCategorie';
        q.HP_Path__c             = 'Path';
        questionsFAQList.add(q);

        Test.startTest();
        HP_EM052_QuestionFAQ.upsertQuestionsFAQ(questionsFAQList);
        Test.stopTest();

    }
}