public with sharing class ConsentementsHandler {

    @AuraEnabled(cacheable=true)
    public static List<Object> getConsentementsQuestions() {
        List<Object> listObject = null;
        HttpResponse httpResp = CalloutManager.sendRequest('Questions_Consentement', null, 'GET', CalloutManager.Scope.READ,null,null);
        if(httpResp != null){
			Map < String, Object > resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(httpResp.getBody());
			listObject = (List < Object > ) resultAsMap.get('_data');
        }
        System.debug('1 - listObject'+ listObject);
        return listObject;
    }
     
    @AuraEnabled( cacheable=true )  
    public static List < SM_QuestionConsentement__mdt > fetchSmileQuestions() {
        
        String codeQuestion = null;

        List <SM_WS_Suffix__mdt> questions_suffix = [SELECT suffix__c FROM SM_WS_Suffix__mdt WHERE DeveloperName = 'Questions_Consentement'];

        for(SM_WS_Suffix__mdt qst : questions_suffix) {
            if (qst.suffix__c.contains('idQuestionnaire=7')){
                codeQuestion = '%Q7%';
            }
            else{
                codeQuestion = '%Q1%';
            }
        }
        
        List <SM_QuestionConsentement__mdt> questionnaire = [ SELECT Id, codeQuestionnaireQuestion__c, LibelleQuestion__c FROM SM_QuestionConsentement__mdt WHERE codeQuestionnaireQuestion__c LIKE :codeQuestion];

        return questionnaire;
 
    }
}