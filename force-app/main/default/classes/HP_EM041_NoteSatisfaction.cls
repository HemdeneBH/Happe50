/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 



 * @last modified on  : 10-18-2021



 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   10-28-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class HP_EM041_NoteSatisfaction {
    public static Contact loadContactWithNoteSatisfaction(String idContact) {
        return [select Id,HP_Chat_Score__c,HP_Dernier_score__c,HP_Email_Score__c,
        HP_global_moyenne_score__c,HP_Telephone_Score__c,
        HP_Souscription_CSAT_Score__c,HP_Souscription_NPS_Score__c,
        HP_Resil_CSAT_Note__c, HP_Resil_NPS_Note__c, HP_VDS_CSAT_Note__c, HP_VDS_NPS_Note__c,
        (select id, HP_Case__c,HP_Case__r.CaseNumber,CreatedDate,HP_satisfaction_verbatim__c,
        HP_satisfaction_score__c,HP_satisfaction_canal__c,HP_satisfaction_OeD__c, Name
         from HP_Notes_de_satisfaction__r order by createdDate desc) 
        from Contact where Id = :idContact];
    } 

    public static HP_NoteDeSatisfaction__c noteSatisfactionFromAvis(String rate,String nps, String idReview,String orderRef,Id souscriptionId,Id contactId,String reviewDdate, Datetime dt, String review, String lastname, String firstname, String moderation ){
       
        HP_NoteDeSatisfaction__c noteSatisfaction = new HP_NoteDeSatisfaction__c();


        noteSatisfaction.HP_satisfaction_score__c = (rate != null ? Decimal.valueOf(rate)  : null);
        noteSatisfaction.HP_NPS__c =  (nps != null ? Decimal.valueOf(nps) : null);
        noteSatisfaction.HP_IdAvisVerifie__c =  idReview;
        noteSatisfaction.HP_ID_Souscription_Digital__c =  orderRef	;
        noteSatisfaction.HP_ID_Souscription__c = souscriptionId;
        noteSatisfaction.HP_Contact__c = contactId;
        noteSatisfaction.HP_Date_creation__c = Datetime.valueOf(reviewDdate);
        noteSatisfaction.HP_satisfaction_date__c = dt.date();
        noteSatisfaction.HP_satisfaction_verbatim__c = review;
        noteSatisfaction.HP_Nom__c =  lastname;
        noteSatisfaction.HP_Prenom__c = firstname;
        noteSatisfaction.HP_ReponseApportee__c = moderation;
        noteSatisfaction.HP_satisfaction_canal__c = 'Souscription';

        return noteSatisfaction;
    }





    public static  List<HP_NoteDeSatisfaction__c>  getNoteSatisfaction(set<String> ids, set<String> idsDigital){
        return [ select id, HP_IdAvisVerifie__c, HP_ID_Souscription_Digital__c, HP_ID_Souscription__c from  HP_NoteDeSatisfaction__c where HP_IdAvisVerifie__c  in : ids OR HP_ID_Souscription_Digital__c  in :idsDigital];

    }





}