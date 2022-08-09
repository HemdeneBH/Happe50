/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 08-23-2021
 * @last modified by  : Badr Eddine Belkarchi
**/
public without sharing class HP_EM052_QuestionFAQ {

    public static void upsertQuestionsFAQ(List<HP_QuestionFAQ__C> questionsFAQList){
		upsert questionsFAQList HP_IdDigital__c;
	}
    
}