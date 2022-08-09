/**
@Author <Amar Kaillo>
@name <SM_LC01_UpdateEmailMessage_Controller>
@CreatedDate <27/01/2020>
@Description <Class called from Lightning Component : SM_LC01_UpdateEmailMessage> - FT1-3628
@Version <1.0>
@reference <Referenced program names>
@ModifiedBy <Amar Kaillo>
*/

public without sharing class SM_LC01_UpdateEmailMessage_Controller {
/**
* @Decsription Get the list of cases of the contact linked to the emailMessage
* @name <getListCases>
* @param <emailMessageId> <Id of EmailMessage>
* @return <List<CaseWrapper>> - <List of Case Wrappers containing the caseIds and the case Subjects to be displayed>
* @throws exception-<>
*/        
    @AuraEnabled
    public static List<CaseWrapper> getListCases(String emailMessageId){
        System.debug('### aka');
        String contactId = '';
        List<CaseWrapper> listCaseWrappers = new List<CaseWrapper>();
        // Get contact Id linked to the emailMessage which is filled in SM_CreateDimeloMessage or SM_MailCorrespondence
        EmailMessage emailMessage = [SELECT Id, Tech_Contact__c
                                     FROM EmailMessage
                                     Where Id = :emailMessageId];
        System.debug('### aka emailMessage Tech_Contact__c ' + emailMessage.Tech_Contact__c);
        if(!String.isBlank(emailMessage.Tech_Contact__c)){
            contactId = emailMessage.Tech_Contact__c;
            
            // Get the list of cases having as contactid the contact of the emailMessage to let the conseiller choose only from this list
            for(Case caseRecord : [SELECT Id, Subject, Type, Sous_type__c, Status, CreatedDate
                                   FROM Case 
                                   WHERE ContactId = :contactId
                                   ORDER BY CreatedDate DESC]){
                                       CaseWrapper caseWrapper = new CaseWrapper();
                                       caseWrapper.caseId =  caseRecord.Id;
                                       caseWrapper.caseSubject =  caseRecord.Subject + ' / ' + caseRecord.Type + ' / ' + caseRecord.Status  + ' / ' + caseRecord.CreatedDate;
                                       listCaseWrappers.add(caseWrapper);
                                   }
        }
        
        
        return listCaseWrappers;
    }

/** 
* @Decsription Updates the case on the emailMessage witht the selected emailmessage from the LC: SM_LC01_UpdateEmailMessage
* @name <updateEmailMessage>
* @param <emailMessageId> <EmailMessage to be updated>
* @param <caseId> <Selected case Id>
* @return <> - <>
* @throws exception-<DML Exception if update of EmailMessage fails>
*/         
    @AuraEnabled
    public static String updateEmailMessage(String emailMessageId, String caseId){
       String returnMessage = '';
        EmailMessage emailMessage = new EmailMessage();
        emailMessage.Id = emailMessageId;
         emailMessage.Case__c = caseId;
        try{
            update emailMessage; 
        }
        catch(DMLException exceptionMessage){
            returnMessage = exceptionMessage.getMessage();
        }
        return returnMessage;
    }
    
    public class CaseWrapper{
        @AuraEnabled
        public String caseId;
        @AuraEnabled
        public String caseSubject;
    }
}