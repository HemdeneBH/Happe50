/*
*@Author: Paul Ghousoub
*@Description: Appel de VI_Consentement
*@CreatedDate: 27/10/2020
*@LastModified: 27/10/2020
*/
public class VI_SM011_ConsentementAnswers_API {
    /**
* @author Paul Ghousoub
* @date 26/10/2020
* @description retourne les reponses du questionnaire par rapport à l'id de la personne envoyé
* @param id de la personne, contexte (HP,SM,VI), partitionName (local.VIToken,local.smileToken)
*/
    @AuraEnabled(cacheable=false)
    public static List<consentementAnswer> getConsentementAnswersData(String idPersonne,String contexte, String partitionName) {
        Map<String, String> listParameters = new Map<String, String>();
        HttpResponse httpResponse = new HttpResponse();    
        String idPersonnee;
        if (idPersonne == null) { 
            system.debug('idPersonne not found ...');
            return null;
        }
        else
        {
            listParameters.put('idPersonne', idPersonne);
        }
        String token;
        if(!Test.isRunningTest()){
            token = VI_SM013_GetTokenService.getToken(contexte, partitionName);
        }else{
            token = 'test';
        }
        
        if (token == null) {
            system.debug('Token not found ...');
            return null;
        }
        List < Object > data = new List<Object>();
        httpResponse = VI_UTIL001_HttpUtilities.makeHttpCall(token,'GET',contexte+'_Consentements',listParameters,null, contexte);
        List<consentementAnswer> consentementAnswers = new List<consentementAnswer>();
        if(httpResponse!= null){
            system.debug(httpResponse.getBody());
            ConsentementAnswersResponse consentementResponse = parse(httpResponse.getBody());
            system.debug(consentementResponse);
            if(consentementResponse.data != null){
            	consentementAnswers = getConsentementAnswersData(consentementResponse.data);
            }
            else{
                return null;
            }
            if (consentementAnswers.Size() == 0) {
                system.debug('No data to get the idPersonne ' + idPersonne);
                return null;
            }
        }
        system.debug('consentementAnswers'+ consentementAnswers);
        return consentementAnswers;
        
    }
    
    /**
* @author Paul Ghousoub
* @date 26/10/2020
* @description met à jour les reponses du questionnaire
*/
    @AuraEnabled(cacheable=false)
    public static Map <String, Integer> updateConsentements (String idpersonne,string idBusinessPartner,
                                                            List<consentementAnswer> consentementResult, String application, 
                                                            String canal,String contexte, String partitionName){
                                                                system.debug('consentementResult '+consentementResult);
                                                                Map <String, Integer> listRetourAPIPostconsentement=new Map <String, Integer> ();
                                                                /* recuperation de la liste des consentement à mettre a jour*/
                                                                if(consentementResult!=null && consentementResult.size()>0){
                                                                    String token;
                                                                    if (Test.isRunningTest()) {
                                                                        token = 'wadfkoa1234';
                                                                    } else {
                                                                        token =  VI_SM013_GetTokenService.getToken(contexte, partitionName);
                                                                    } 
                                                                    
                                                                    for (Integer i = 0; i < consentementResult.size(); i++) {
                                                                        consentementAnswer ConsentementOS =consentementResult[i];  
                                                                        if( ConsentementOS!=null ){
                                                                            String idConsentToUpdate = ConsentementOS.id;
                                                                            String key = ConsentementOS.idQuestionnaire+'_'+ConsentementOS.idQuestion;
                                                                            if(!String.isBlank(idConsentToUpdate)){ 
                                                                                Map<String, String> parameters = new Map<String, String>();
                                                                                parameters.put('id',idConsentToUpdate);
                                                                                Map<String,Object> mapInput=prepareConsentementUpdateMap(ConsentementOS,application, canal); 
                                                                                system.debug('mapInputBlank'+ mapInput);
                                                                                HttpResponse retour= VI_UTIL001_HttpUtilities.makeHttpCall(token,'PUT',contexte+'_Consentements',
                                                                                                                                          null,mapInput, idConsentToUpdate,contexte);
                                                                                listRetourAPIPostconsentement.put(key, retour.getStatusCode());
                                                                            } else if (String.isBlank(idConsentToUpdate)){
                                                                                // on crée un nouvelle réponse
                                                                                Map<String,Object> mapInput=prepareConsentementUpdateMap(ConsentementOS,application, canal); 
                                                                                system.debug('mapInput'+ mapInput);
                                                                                HttpResponse retour= VI_UTIL001_HttpUtilities.makeHttpCall(token,'POST',contexte+'_Consentements',
                                                                                                                                         null,mapInput,contexte);
                                                                                
                                                                                
                                                                                listRetourAPIPostconsentement.put(key, retour.getStatusCode());
                                                                                
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                                return listRetourAPIPostconsentement;
                                                            }
    
    public static Map <String,Object> prepareConsentementUpdateMap(consentementAnswer answer,String application,String canal){
        Map<String,Object> mapInput=new Map<String,Object>();
        
        mapInput.put('application',application); 
        mapInput.put('canal',canal); 
        mapInput.put('consent',answer.consent);
        mapInput.put('idQuestion', answer.idQuestion);
        if(answer.idBusinessPartner!= null && answer.idBusinessPartner!= ''){
            mapInput.put('idBusinessPartner',answer.idBusinessPartner); 
        }
        else{
            mapInput.put('idBusinessPartner',''); 
        }
        mapInput.put('idQuestionnaire', answer.idQuestionnaire);                                                                 
        mapInput.put('idPersonne', answer.idPersonne);
        
        return  mapInput;                                                               
    }
    
    public static List<consentementAnswer> getConsentementAnswersData(List<cls_data> ConsentementAnswers){
        Integer i = 1;
        List<consentementAnswer> QuestionConsentementList = new List<consentementAnswer>();
        for (cls_data answer : ConsentementAnswers) {
            consentementAnswer consent;
            consent= new consentementAnswer (answer);
            QuestionConsentementList.add(consent);
        }
        return QuestionConsentementList;
    }
    
    public class consentementAnswer {
        
        public String id {get;set;}
        public Integer idPersonne {get;set;}
        public Integer idQuestionnaire {get;set;}
        public String idBusinessPartner {get;set;}
        public Integer idQuestion {get;set;}
        public Boolean consent {get;set;}
        public String canal {get;set;}
        public String application {get;set;}
        public String dateModification {get;set;}
        
        public consentementAnswer(String id, Integer idPersonne, Integer idQuestionnaire, String idBusinessPartner,
                                  Integer idQuestion, Boolean consent, String canal, String application, String dateModification){
        	this.id = id;
            this.idPersonne = idPersonne;                          
            this.idQuestionnaire = idQuestionnaire;
            this.idBusinessPartner = idBusinessPartner;      
            this.idQuestion = idQuestion;
            this.consent = consent;
            this.canal = canal;   
            this.application = application;
            this.dateModification = dateModification;
        }
        
        public consentementAnswer(cls_data ConsentementAnswer) {
            this.id = ConsentementAnswer.id;
            this.idPersonne = ConsentementAnswer.idPersonne;
            this.idQuestionnaire = ConsentementAnswer.idQuestionnaire;
            this.idBusinessPartner  = ConsentementAnswer.idBusinessPartner;
            this.idQuestion  = ConsentementAnswer.idQuestion;
            this.consent  =ConsentementAnswer.consent;
            this.canal  = ConsentementAnswer.canal;
            this.application  = ConsentementAnswer.application;
            this.dateModification  = ConsentementAnswer.dateModification; 
        }
        
    }
    
    
    public class ConsentementAnswersResponse{
        public cls_data[] data;
        public String code; //null si 200, 201 ou 206
        public String name;
        public String message;
    }
    class cls_data {
        public String id;	//7ec755f1-25f2-419f-8355-7d0b4e49c9c3
        public Integer idPersonne;	//1200
        public Integer idQuestionnaire;	//1
        public Integer idQuestion;	//2
        public boolean consent;
        public String idBusinessPartner;	//
        public String canal;	//Telephone
        public String application;	//HAPPE
        public String dateModification;	//2020-11-10 23:31:08
        public cls_links links;
    }
    class cls_links {
        public String self;	//https://qa-rec-dmzint-gtw.api.engie.fr:8500/api/apiset/0.1/consentements/7ec755f1-25f2-419f-8355-7d0b4e49c9c3
    }
    public static ConsentementAnswersResponse parse(String json){
        json = VI_UTIL001_HttpUtilities.handleResponse(json);
        return (ConsentementAnswersResponse) System.JSON.deserialize(json, ConsentementAnswersResponse.class);
    }
}