/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-10-2022
 * @last modified by  : Hemdene Ben Hammouda
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   11-03-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class HP_CALL008_Mediatech {
   
  
    @InvocableMethod(label='call Mediatech' description = 'Intégration Mediatech')
    public static void callMediatechAction(List<ObjectToSend> senderList){
       ObjectToSend sender = senderList[0];
       Integer sousTypeCorrespondanceId = null;
       Boolean isTelOrigin = 'tel'.equals(sender.origin);
       Boolean isEmailOrigin = 'email'.equals(sender.origin);
       if(isTelOrigin) {
       	   List<Task> lastTasks = [Select Id, CallType, CallDisposition From Task where WhatId =: sender.caseId order by createdDate desc limit 1];
           if(lastTasks.size() == 0 || lastTasks[0].CallType != 'Inbound') {
               return;
           }
           else {
               String callResult = lastTasks[0].CallDisposition;
               Integer index = callResult.lastIndexOf('(');
               sousTypeCorrespondanceId = Integer.valueOf(callResult.substring(index + 1, callResult.length() - 1));
           }
       }
        
       if(sousTypeCorrespondanceId == null) {
           List<HP_Mediatech_Parameter__mdt> mediatechParamList = [select Correspondance_ID__c,Correspondance_ID_Tel__c from HP_Mediatech_Parameter__mdt WHERE Case_sous_type__c = : sender.caseSousType];
		   if(!mediatechParamList.isEmpty()) {
    		   sousTypeCorrespondanceId = (Integer) mediatechParamList[0].Correspondance_ID__c;
           }
       }
       String encodedEmailSubject = null;
       if(sender.emailSubject != null) {
           encodedEmailSubject = EncodingUtil.URLENCODE(sender.emailSubject,'UTF-8');  
       }
       callMediatechAction(sender.caseId , encodedEmailSubject, sousTypeCorrespondanceId, sender.emailContact, sender.origin, sender.caseOwnerId, sender.source, sender.xdataContact);
    }
  
    /**
    * @description 
    * @author Sara El-Hannaoui | 15/05/2020 
    * @param Id caseId 
    * @param String emailSubject 
    * @param Integer sousTypeCorrespondanceId 101
    * @param String emailContact 'XX@external.engie.com'
    * @param String origin 'email'
    * @param String caseOwnerId 
    * @param string source 'post_contact_email'
    * @return void 
    **/
   @future(Callout=true)
    public static void callMediatechAction(Id caseId, String emailSubject, Integer sousTypeCorrespondanceId, String emailContact, String origin, String caseOwnerId, string source, Decimal xdataContact){
       Case acase = null;
        if('tel'.equals(origin)) {
             acase = HP_EM010_Case.getTelephoneCaseByCaseId(caseId);
        }
        if('email'.equals(origin)) {
             acase = HP_EM010_Case.getMailCaseByCaseId(caseId);
        }
       //Ajouter le numéro de téléphone contact 
       String mobilePhone = acase.ContactMobile;
       String param = '?origin='+origin + '&agent_id='+caseOwnerId+ '&source='+source+ '&wrapup_id='+sousTypeCorrespondanceId+ ((emailSubject != null) ? ('&email_subject='+emailSubject) : '') + ((mobilePhone != null) ? ('&tel_no='+mobilePhone) : '')+ '&case_id='+caseId
       + (xdataContact != null ? ('&client_id=' + Integer.valueOf(xdataContact)) : '') +(emailContact != null ? ('&client_email='+emailContact) : '');
       HTTPResponse response = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.MEDIATECH,  param);
       if(response.getStatusCode() == 200){
           acase.HP_isSentMediatech__c = true;
           update acase;
       } 
    }
    
     public class ObjectToSend {
       @InvocableVariable
       public String emailContact;
       @InvocableVariable(required=true)
       public String caseOwnerId;
       @InvocableVariable(required=true)
       public String source;
       @InvocableVariable(required=true)
       public String origin;
       @InvocableVariable(required=true)
       public Id caseId;
       @InvocableVariable
       public String emailSubject;
       @InvocableVariable
       public String caseSousType;
       @InvocableVariable
       public Decimal xdataContact;       
   }

}