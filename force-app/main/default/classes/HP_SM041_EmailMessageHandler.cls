/**
 * @File Name          : HP_SM041_EmailMessageHandler.cls
 * @Description        : 
 * @Author             : Antoine Latour
 * @Group              : 
 * @Last Modified By   : Hemdene Ben Hammouda
 * @Last Modified On   : 01-03-2022
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    29/09/2020   Antoine Latour     Initial Version
**/
public without sharing class HP_SM041_EmailMessageHandler {
    
    public static void populateTechAccount(List<EmailMessage> emailMessageList) {
        if(emailMessageList == null)
            return;
        System.debug('populateTechAccount emailMessageList.size() = '+ emailMessageList.size());
        for(EmailMessage item : emailMessageList) {
            String rtId = item.RelatedToId;
            if(rtId != null && rtId.startsWith('001')) {
                item.HP_TECH_Account_Id__c = item.RelatedToId;
                item.RelatedToId = null;
                System.debug('HP_TECH_Account_Id__c : '+item.HP_TECH_Account_Id__c);
            } 
        }
    }

    public static void updateEmailMessageRelation(List<EmailMessage> emailMessageList) {
        if(emailMessageList == null)
            return;

        List<String> accountIdList = new List<String>();
        List<String> activityIdList = new List<String>();
        Map<String, String> activityMap = new Map<String, String>();

        for(EmailMessage item : emailMessageList) {
            if(item.HP_TECH_Account_Id__c == null) {
                continue;
            }
            activityMap.put(item.HP_TECH_Account_Id__c, item.ActivityId);
            accountIdList.add(item.HP_TECH_Account_Id__c);
        }
        if(accountIdList.size() == 0) {
            return;
        }
        List<Contact> contList = [select Id, AccountId from Contact where AccountId in :accountIdList];
        if(contList.size() == 0) {
            return;
        }
        Map<String, String> contactAccountMap = new  Map<String, String>();
        for(Contact cont : contList) {
            contactAccountMap.put(cont.AccountId, cont.Id);
        }
        List<EmailMessageRelation> emailMessageRelationList = new List<EmailMessageRelation>();
        List<Task> tsk = new List<Task>();
        for(EmailMessage item : emailMessageList) {
            if(contactAccountMap.get(item.HP_TECH_Account_Id__c) == null) {
                continue;
            }
            EmailMessageRelation emr = new EmailMessageRelation();
            emr.emailMessageId = item.id;
            emr.relationId = contactAccountMap.get(item.HP_TECH_Account_Id__c); 
           emr.relationType = 'OtherAddress';
           emailMessageRelationList.add(emr);
           if(item.ActivityId != null) {
                tsk.add(new Task(Id = item.ActivityId, WhoId = contactAccountMap.get(item.HP_TECH_Account_Id__c)));
           }
        }

        System.debug('@@@ emailMessageRelationList ' + emailMessageRelationList);
        if(emailMessageRelationList.size() > 0) {
            insert emailMessageRelationList;
        }

        if(tsk.size() > 0) {
            update tsk;
        }
    }
    
    
    public static void createCaseClosedEmailSent (List<EmailMessage> emailMessageList) {
        if(emailMessageList == null){
            System.debug('### HP_SM041_EmailMessageHandler.createCaseClosedEmailSent : emailMessage List is null.');
            return;
        } 
        try{
            Map<Id,Id> accConMap = new Map<Id,Id>();
            List<wrapEmailCase> wrapECList = new List<wrapEmailCase>();

            List<Case> casesToInsert = new List<Case>();
            for(EmailMessage item : emailMessageList) {
                if(item.HP_TECH_Account_Id__c!=null && !item.HP_TECH_Incoming__c && item.ReplyToEmailMessageId==null){
                    Case newCase = new Case();
                    List<String> listToAddress = item.ToAddress.split(';');
                    newCase.RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case','HP_Mail');
                    newCase.Origin = 'HP_CRM';
                    newCase.Description = item.TextBody;
                    newCase.Subject = item.Subject;
                    newCase.AccountId = item.HP_TECH_Account_Id__c;
                    newCase.SuppliedEmail = listToAddress[0];
                    newCase.Status = 'CLOSED';
                    newCase.Priority = 'Low';
                    newCase.HP_Type__c = 'HP_EmailSortantSpontane';
                    newCase.ContactId = [Select Id from Contact where AccountId = :item.HP_TECH_Account_Id__c and Email = :listToAddress[0] limit 1].Id;
                    casesToInsert.add(newCase);
                    wrapECList.add(new wrapEmailCase(item,newCase));
                    System.debug('### HP_SM041_EmailMessageHandler.createCaseClosedEmailSent : CaseAdded to list');
                }else{
                    System.debug('### HP_SM041_EmailMessageHandler.createCaseClosedEmailSent : TECH_Account_Id is null et Item.Incoming is true ');
                    continue;
                }
            }

            if (casesToInsert.size() != 0){
                insert casesToInsert;
                System.debug('LIST of Cases to insert size '+casesToInsert.size());
                for(wrapEmailCase item : wrapECList){
                    item.email.Case__c = item.cas.Id;
                    System.debug('### HP_SM041_EmailMessageHandler.createCaseClosedEmailSent : item.email.Case__c : ' + item.email.Case__c);  
                }
            }

            

        }catch(Exception e){
            System.debug('### HP_SM041_EmailMessageHandler.createCaseClosedEmailSent ERROR'+ e.getCause() + ' ' + e.getTypeName() + ' '+ e.getLineNumber() + ' '+ e.getMessage() + ' ' + e.getStackTraceString());
        }
	}

    public class wrapEmailCase{
        public EmailMessage email {get; set;}
        public Case cas {get; set;}

        public wrapEmailCase(EmailMessage e , Case c){
            email = e;
            cas = c;
        }
    }

}