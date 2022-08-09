public with sharing class ConsentementsHandler {

    @AuraEnabled(cacheable=true)
    public static List<Object> getConsentementsQuestions() {
        List<Object> questionsConsentement = APIHandler.callAPI('Questions_Consentement', null, 'GET');
        return questionsConsentement;
    }
}