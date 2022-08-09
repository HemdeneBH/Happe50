@isTest
public class SM_LC01_UpdateEmailMessage_TEST {
    
    @isTest
    public static void getListCases_TEST(){
        Account account = SM_TestDataFactory.createAccount('Test Account');
        insert account;
        
        Contact contact = SM_TestDataFactory.createContact('Last Name', account.Id);
        insert contact;
        
        Case caseRecord = SM_TestDataFactory.createCase('Test Case', account.Id);
        caseRecord.Subject = 'Case Subject';
        caseRecord.Type = 'Acquisition';
        caseRecord.Sous_type__c = 'Changement de fournisseur';
        caseRecord.Status = 'En attente';
        caseRecord.ContactId = contact.Id;
        insert caseRecord;
        
        List<Id> listContactIds = new List<Id>();
        listContactIds.add(contact.id);
        
        EmailMessage emailMessage =  SM_TestDataFactory.createEmailMessage(account.Id, caseRecord.Id, listContactIds, 'toAddres@test.com', '0', 'fromAddress@test.com', 'textBody', 'emailSubject', 'htmlBody');
        emailMessage.Tech_Contact__c = contact.Id;
        insert emailMessage;
        
        List<SM_LC01_UpdateEmailMessage_Controller.CaseWrapper> listCaseWrappers = SM_LC01_UpdateEmailMessage_Controller.getListCases(emailMessage.Id);
        System.assertEquals(caseRecord.Id, listCaseWrappers[0].caseId);
        caseRecord = [SELECT Id, Subject, Type, Status, CreatedDate
                      FROM Case
                      WHERE Id = :caseRecord.id];
        System.assertEquals(caseRecord.Subject + ' / ' + caseRecord.Type + ' / ' + caseRecord.Status + ' / ' + caseRecord.CreatedDate, listCaseWrappers[0].caseSubject);
        
        String errorMessage = SM_LC01_UpdateEmailMessage_Controller.updateEmailMessage(emailMessage.Id, listCaseWrappers[0].caseId);
        System.assertEquals('', errorMessage);
        
        emailMessage = [SELECT Case__c
                       FROM EmailMessage 
                       WHERE Id = :emailMessage.id];
        System.assertEquals(caseRecord.Id, emailMessage.Case__c);
        
       errorMessage = SM_LC01_UpdateEmailMessage_Controller.updateEmailMessage(emailMessage.Id, account.Id);

        
    }
}