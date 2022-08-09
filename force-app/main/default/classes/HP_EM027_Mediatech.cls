/**
 * @File Name          : HP_EM027_Mediatech.cls
 * @Description        : Data Manager spécifique aux échanges avec Mediatech
 * @Author             : Sara El-Hannaoui
 * @Group              : 
 * @Last Modified By   : Sara El-Hannaoui
 * @Last Modified On   : 27/03/2020 à 16:18:34
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    27/03/2020   Sara El-Hannaoui     Initial Version
**/
public with sharing class HP_EM027_Mediatech {
  
  
     @InvocableMethod(label='call WS Mediatech' description = 'Intégration Mediatech Email')
     public static void callMediatechAction(List<ObjectToSend> senderList){
        ObjectToSend sender = senderList[0];
        System.debug('sender***************'+ senderList[0]);
        Integer sousTypeCorrespondanceId;
        List<HP_Mediatech_Parameter__mdt> mediatechParamList = [select Correspondance_ID__c from HP_Mediatech_Parameter__mdt WHERE Case_sous_type__c = : sender.caseSousType];
        if (mediatechParamList.size() > 0){
            sousTypeCorrespondanceId = (Integer) mediatechParamList[0].Correspondance_ID__c;
        }
        System.debug('sender***************'+ sender);
        String encodedEmailSubject = EncodingUtil.URLENCODE(sender.emailSubject,'UTF-8');
        callMediatechAction(sender.caseId , encodedEmailSubject, sousTypeCorrespondanceId, sender.emailContact, sender.origin, sender.caseOwnerId, sender.source);
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
     public static void callMediatechAction(Id caseId, String emailSubject, Integer sousTypeCorrespondanceId, String emailContact, String origin, String caseOwnerId, string source){
        Case acase = HP_EM010_Case.getMailCaseByCaseId(caseId);
       
        //Ajouter le numéro de téléphone contact 
        String mobilePhone = acase.ContactMobile;
        String param = '?client_email='+emailContact +'&origin='+origin + '&agent_id='+caseOwnerId+ '&source='+source+ '&wrapup_id='+sousTypeCorrespondanceId+ '&email_subject='+emailSubject+ '&tel_no='+mobilePhone;
        HTTPResponse response = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.MEDIATECH,  param);
        if(response.getStatusCode() == 200){
            acase.HP_isSentMediatech__c = true;
            update acase;
        } 
     }

     public class ObjectToSend {
		@InvocableVariable(required=true)
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
	}

}