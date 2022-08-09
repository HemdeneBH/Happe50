/*
*@Author: André NGUEMA
*@Description: Controller classe pour le lightning web componenet parcoursPPRecapSouscription
*@CreatedDate: 01/02/2021
*@LastModified: 23/03/2021
*/

public without sharing class VI_ParcoursPPRecap_Controller { 
    
    
    /**
* @author André NGUEMA
* @date 01/02/2021
* @description Récupération du contact et du case reliés au parcours
* @param parcours provenant du lwc qui contient idBP utilisé pour l'appel
* @return IbanClientWrapper wrapper qui contient les coordonnées bancaires ou le message d'erreur en cas d'erreur
*/
    
    @AuraEnabled(cacheable=false)
    public static RecapWrapper getSelectedContact(VI_parcours__c parcours) {
        system.debug('parcours.VI_Case__c'+ parcours);
        List<Contact> contacts = [SELECT FirstName, LastName, Email, Adresse_Mail_2__c,MobilePhone, Mobile_2__c, Mobile_3__c, reference_client_f__c, 
                                  MailingPostalCode, VI_Contact_Emails__c, MailingCity, Phone, Tel_Fixe_2__c, Tel_Fixe_3__c, No_Voie__c, MailingStreet,
                                  Salutation, Adresse_Mail_Principale__c, Mobile_Principal__c, Tel_Fixe_Principal__c 
                                  FROM Contact 
                                  WHERE Id  =: parcours.VI_Contact__c];
        
        //VI_parcours__c parcoursX = [Select Id, VI_Case__r.CaseNumber from VI_parcours__c where Id=:parcours.Id];
        //system.debug('parcoursX'+ parcoursX);
        system.debug('parcours.VI_Case__c'+ parcours.VI_Case__c);
         system.debug('parcours.VI_Contact__c'+ parcours.VI_Contact__c);
        List<Case> cases = [SELECT Id, CaseNumber, VI_StatutEnveloppe__c
                            FROM Case
                            WHERE Id = : parcours.VI_Case__c];
        contactX cont = new ContactX(contacts[0]);
        caseX recapCase = new caseX(cases[0]);
        system.debug('contacts'+ contacts);
        system.debug('cases'+ cases);
        return new RecapWrapper(cont, recapCase);//, cases[0]
    } 
    
     @AuraEnabled(cacheable=false)
    public static validerParcoursWrapper envoiCPV(VI_parcours__c parcours, String numeroCase, List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> coupleCodeValeurs) {
        String responseStatus;
        String message;
      
        VI_SM024_GetDocusignToken.retourEnvoiDocument  retourEnvoiDocument=  VI_SM024_GetDocusignToken.envoyerDocumentsfromLWC(parcours, numeroCase, coupleCodeValeurs, 'local.VIDocusignToken');
      
        if(retourEnvoiDocument!= null){
            if(retourEnvoiDocument.retourMessage != null){
                message = retourEnvoiDocument.retourMessage;
                parcours = retourEnvoiDocument.parcours;
                update parcours;
                return new validerParcoursWrapper(parcours, message);
            }
            else if(retourEnvoiDocument.parcours != null ){
                parcours = retourEnvoiDocument.parcours;
                parcours.OwnerId=UserInfo.getUserId();
                if(parcours.VI_LocalNonIdentifieGenerationCase__c == false){
                    parcours.VI_StatutParcours__c = 'CPV Envoyées: PDL/PCE connu';
                }
                else{
                    parcours.VI_StatutParcours__c = 'CPV Envoyées: PDL/PCE non connu';
                } 
                update parcours;
                System.debug('Fin envoiCPV:'+ system.now());
                return new validerParcoursWrapper(parcours, message);
            }
        }
        else{
            message = 'Une erreur s\'est produite lors de l\' envoi du CPV au client' ;
            update parcours;
             System.debug('Fin envoiCPV:'+ system.now());
            return new validerParcoursWrapper(parcours, message);
        } 
        update parcours;
        

        //DDPCM-1324 22/06/2022
        List<VI_SM011_ConsentementAnswers_API.consentementAnswer> listAnswers = VI_SM011_ConsentementAnswers_API.getConsentementAnswersData(parcours.VI_IDReferenceClient__c,'VI', 'local.VIToken');
        if(listAnswers!=null && listAnswers.size()>0){
            responseStatus=updateAnswers(parcours.VI_IDReferenceClient__c,parcours.VI_ConsentProspectionEngieNonAnalogue__c ,parcours.VI_ConsentProspectionPartenaire__c,listAnswers);
            if(responseStatus=='Error'){ return new validerParcoursWrapper(parcours, 'Une erreur s\'est produite lors de la mise à jour des consentements');
            }
        }
        else{
            responseStatus=submitAnswers(parcours.VI_IDReferenceClient__c,parcours.VI_ConsentProspectionEngieNonAnalogue__c ,parcours.VI_ConsentProspectionPartenaire__c);
            if(responseStatus=='Error'){ return new validerParcoursWrapper(parcours, 'Une erreur s\'est produite lors de la mise à jour des consentements');
            }
        }

        System.debug('Fin envoiCPV:'+ system.now());
        return new validerParcoursWrapper(parcours, message);
    }

            /**
    * @author Amal Chreiteh
    * @date 15/12/2020
    * @description Remonter les consentements de la personne de Xdata
    * @param idPersonne 
    * @return List<Question> 
    */ 
    @AuraEnabled(cacheable=true)
    public static List<Question> getQuestions(String idpersonne) {
        VI_SM004_QuestionConsentementAPI.QuestionConsentementResponse response = VI_SM004_QuestionConsentementAPI.callQuestionConsentement('VI', 'local.VIToken');
        List <Question> answers =new List <Question>();
        for(VI_SM004_QuestionConsentementAPI.cls_data question :response.data){
            system.debug('question.codeQuestionnaireQuestion '+question.codeQuestionnaireQuestion);
            if(question.codeQuestionnaireQuestion == 'Q'+Label.VI_NumeroQuestionnaire+'.'+Label.VI_NumeroQuestionNonAnalogue || question.codeQuestionnaireQuestion == 'Q'+Label.VI_NumeroQuestionnaire+'.'+Label.VI_NumeroQuestionPartenaire){
                answers.add(new Question(new VI_SM011_ConsentementAnswers_API.consentementAnswer(null,null, question.idQuestionnaire,idpersonne, question.idQuestion,false,'Pure Player','PC', null ),question.libelleQuestion));
            }
        }
        return answers; 
    }

        /**
* @author Amal Chreiteh
* @date 15/12/2020
* @description Envoyer à Xdata les consentements de la personne
* @param idPersonne, consentement Engie, consentement Partenaire 
* @return String ( Success ou Error)
*/ 
    
@AuraEnabled(cacheable=true)
public static String submitAnswers(String idpersonne, String consentementEngie, String consentementPartenaire ) {
    system.debug('in submit answers');
    List<VI_SM011_ConsentementAnswers_API.consentementAnswer> answers = new List<VI_SM011_ConsentementAnswers_API.consentementAnswer>();
    
    List<Question> questions = getQuestions(idpersonne);
    for (Question q: questions){
        system.debug('q question '+q);
        q.answer.idPersonne = Integer.valueof(idpersonne);
        system.debug('q.answer.idPersonne '+q.answer.idPersonne);
        system.debug('q.answer.idQuestion '+q.answer.idQuestion);
        system.debug(' Integer.ValueOf(Label.VI_NumeroQuestionNonAnalogue) '+ Integer.ValueOf(Label.VI_NumeroQuestionNonAnalogue));
        system.debug(' Integer.ValueOf(Label.VI_NumeroQuestionPartenaire) '+ Integer.ValueOf(Label.VI_NumeroQuestionPartenaire));
        system.debug('consentementEngie '+consentementEngie);
        system.debug('consentementPartenaire '+consentementPartenaire);
        if(q.answer.idQuestion == Integer.ValueOf(Label.VI_NumeroQuestionNonAnalogue)){
            system.debug('in first if');
            
            if(consentementEngie=='Oui') { q.answer.consent=true;
            }
            else if(consentementEngie=='Non') { q.answer.consent=false;
            }
            if(consentementEngie=='Oui' || consentementEngie=='Non')  {
                answers.add(q.answer);
            }
        }
        if(q.answer.idQuestion == Integer.ValueOf(Label.VI_NumeroQuestionPartenaire)){
            if(consentementPartenaire=='Oui') q.answer.consent=true;
            else if(consentementPartenaire=='Non') q.answer.consent=false;
            if(consentementPartenaire=='Oui' || consentementPartenaire=='Non') answers.add(q.answer);
        }
    }
    Map <String, Integer> result =  VI_SM011_ConsentementAnswers_API.updateConsentements( idpersonne,null, answers, 
                                                                                         'PC','Pure Player','VI', 
                                                                                         'local.VIToken');
    for(Integer status:result.values()){ if(status!=200 && status!=201){ return 'Error';}
    }
    return 'Success'; 
}

/**
* @author Amal Chreiteh
* @date 15/12/2020
* @description Mettre à jour les consentements de la personne dans Xdata
* @param idPersonne, consentement Engie, consentement Partenaire 
* @return String ( Success ou Error)
*/ 

@AuraEnabled(cacheable=true)
public static String updateAnswers(String idpersonne, String consentementEngie, String consentementPartenaire, List<VI_SM011_ConsentementAnswers_API.consentementAnswer> listAnswers ) {
    Boolean questionNonAnalogueExists=false;
    Boolean questionPartenaireExists=false;
    if(listAnswers!=null && listAnswers.size()>0){
        for (VI_SM011_ConsentementAnswers_API.consentementAnswer answer: listAnswers){
            if(answer.idQuestion == Integer.ValueOf(Label.VI_NumeroQuestionNonAnalogue)){
                questionNonAnalogueExists=true;
                if(consentementEngie=='Oui') answer.consent=true;
                else if(consentementEngie=='Non') answer.consent=false;
            }
            if(answer.idQuestion == Integer.ValueOf(Label.VI_NumeroQuestionPartenaire)){
                questionPartenaireExists=true;
                if(consentementPartenaire=='Oui') answer.consent=true;
                else if(consentementPartenaire=='Non') answer.consent=false;
            }
        }
    }
    if(!questionNonAnalogueExists || !questionPartenaireExists){
        List<Question> questions = getQuestions(idpersonne); 
        for (Question q: questions){
            q.answer.idPersonne = Integer.valueof(idpersonne);
            if(!questionNonAnalogueExists && q.answer.idQuestion == Integer.ValueOf(Label.VI_NumeroQuestionNonAnalogue)){
                if(consentementEngie=='Oui') q.answer.consent=true;
                else if(consentementEngie=='Non') q.answer.consent=false;
                if(consentementEngie=='Oui' || consentementEngie=='Non') listAnswers.add(q.answer);
            }
            if(!questionPartenaireExists && q.answer.idQuestion == Integer.ValueOf(Label.VI_NumeroQuestionPartenaire)){
                if(consentementPartenaire=='Oui') q.answer.consent=true;
                else if(consentementPartenaire=='Non') q.answer.consent=false;
                if(consentementPartenaire=='Oui' || consentementPartenaire=='Non') listAnswers.add(q.answer);
            }
        }
    }
    Map <String, Integer> result =  VI_SM011_ConsentementAnswers_API.updateConsentements( idpersonne,null, listAnswers, 
                                                                                         'PC','Pure Player','VI', 
                                                                                         'local.VIToken');
    for(Integer status:result.values()){ if(status!=200 && status!=201){ return 'Error';}
    }
    return 'Success'; 
}

    public class Question{
        @AuraEnabled
        public VI_SM011_ConsentementAnswers_API.consentementAnswer answer;
        @AuraEnabled
        public String libelleQuestion;
        public Question(VI_SM011_ConsentementAnswers_API.consentementAnswer answer, String libelleQuestion ){
            this.answer = answer;
            this.libelleQuestion =libelleQuestion;
        }
    }
    
    public class validerParcoursWrapper{
        @AuraEnabled
        public VI_parcours__c parcours{get;set;}
        @AuraEnabled
        public String message{get; set;}
        public validerParcoursWrapper(VI_parcours__c parcours, String message){
            this.parcours = parcours;
            this.message = message;
        }
    }  
    
    public class RecapWrapper{
        @AuraEnabled
        public ContactX recapContact{get;set;}
        @AuraEnabled
        public CaseX recapCase{get; set;}
        @AuraEnabled
        public String message{get; set;}
        public RecapWrapper(ContactX recapContact, CaseX recapCase){//, Case recapCase
            this.recapCase = recapCase;
            this.recapContact = recapContact;
        }
    }  
    
    public class CaseX{
        @AuraEnabled
        public String CaseNumber{get;set;}
        @AuraEnabled
        public String statutEnveloppe{get;set;}
        public CaseX(Case recapCase){
            this.CaseNumber = recapCase.CaseNumber;
            this.statutEnveloppe = recapCase.VI_StatutEnveloppe__c;
        }
    }
    
    public class ContactX{
        @AuraEnabled
        public String FirstName{get;set;}
        @AuraEnabled
        public String LastName{get;set;}
        @AuraEnabled
        public String Email{get;set;}
        @AuraEnabled
        public String Adresse_Mail_2{get;set;}
        @AuraEnabled
        public String MobilePhone{get;set;}
        @AuraEnabled
        public String Mobile_2{get;set;}
        @AuraEnabled
        public String Mobile_3{get;set;}
        @AuraEnabled
        public String reference_client_f{get;set;}
        @AuraEnabled
        public String MailingPostalCode{get;set;}
        @AuraEnabled
        public String VI_Contact_Emails{get;set;}
        @AuraEnabled
        public String MailingCity{get;set;}
        @AuraEnabled
        public String Phone{get;set;}
        @AuraEnabled
        public String Tel_Fixe_2{get;set;}
        @AuraEnabled
        public String Tel_Fixe_3{get;set;}
        @AuraEnabled
        public String No_Voie{get;set;}
        @AuraEnabled
        public String MailingStreet{get;set;}
        @AuraEnabled
        public String Salutation{get;set;}
        @AuraEnabled
        public String Adresse_Mail_Principale{get;set;}
        @AuraEnabled
        public String Tel_Fixe_Principal {get;set;}
        @AuraEnabled
        public String Mobile_Principal {get;set;}
        
        public ContactX(Contact contact){
            this.FirstName = contact.FirstName;
            this.LastName = contact.LastName;
            this.Email = contact.Email;
            this.Adresse_Mail_2 = contact.Adresse_Mail_2__c;
            this.MobilePhone = contact.MobilePhone;
            this.Mobile_2 = contact.Mobile_2__c;
            this.Mobile_3 = contact.Mobile_3__c;
            this.reference_client_f = contact.reference_client_f__c;
            this.MailingPostalCode = contact.MailingPostalCode;
            this.VI_Contact_Emails = contact.VI_Contact_Emails__c;
            this.MailingCity = contact.MailingCity;
            this.Phone = contact.Phone;
            this.Tel_Fixe_2 = contact.Tel_Fixe_2__c;
            this.Tel_Fixe_3 = contact.Tel_Fixe_3__c;
            this.No_Voie = contact.No_Voie__c;
            this.MailingStreet = contact.MailingStreet;
            this.Salutation = contact.Salutation;
            this.Adresse_Mail_Principale = contact.Adresse_Mail_Principale__c;
            this.Mobile_Principal = contact.Mobile_Principal__c;
            this.Tel_Fixe_Principal = contact.Tel_Fixe_Principal__c;
        }
    } 
}