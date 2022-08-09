/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 08-23-2021
 * @last modified by  : Badr Eddine Belkarchi
**/
public without sharing class HP_SM066_QuestionFAQAPI {

    public static void questionsFAQCreation(HP_WRP043_QuestionFAQ.Request req, HP_WRP022_SFResponse response){
        try{
            dataValidation(req, response);
            if(response.errors.isEmpty()){
                // convert 'QuestionFaqApi' List to an 'QuestionsFAQ__C' List
                List<HP_QuestionFAQ__C> questionsFAQList = convertQuestionFaqFromApi(req.questionFaqApiList);
                // questions FAQ creation
                HP_EM052_QuestionFAQ.upsertQuestionsFAQ(questionsFAQList);
            }
            else{
                response.code = 400;
            }            	
        }
        catch(Exception e){
            response.addError('SM066-SF', e.getMessage());
            response.code = 400;
		}  
    }

    public static void dataValidation(HP_WRP043_QuestionFAQ.Request req, HP_WRP022_SFResponse response){
        // add check if list empty => code 400
        if (req.questionFaqApiList.isEmpty()) {
            response.addError('SM066-SF', 'List is empty, there are no questions to create.');
            response.code = 400;
        }
	}


    @TestVisible private static List<HP_QuestionFAQ__C> convertQuestionFaqFromApi(List<HP_WRP043_QuestionFAQ.QuestionFaqApi> questionFaqApiList) {
        List<HP_QuestionFAQ__C> listQuestionsFAQ = new List<HP_QuestionFAQ__C>();
        for (HP_WRP043_QuestionFAQ.QuestionFaqApi q: questionFaqApiList) {
            HP_QuestionFAQ__C questionFAQ =  new HP_QuestionFAQ__C();
            questionFAQ.HP_IdDigital__c       = q.digitalId;
            questionFAQ.HP_VotePositifs__c    = q.votesPositifs;
            questionFAQ.HP_VoteNegatifs__c    = q.votesNegatifs;
            questionFAQ.HP_Titre__c           = q.titre;
            questionFAQ.HP_Categorie__c       = q.categorie;
            questionFAQ.HP_SousCategorie__c   = q.sousCategorie;
            questionFAQ.HP_Path__c            = q.path;

            listQuestionsFAQ.add(questionFAQ);
        }
        return listQuestionsFAQ;
    }
}