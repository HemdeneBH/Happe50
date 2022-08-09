@isTest
public class EmailMessageHandler_TEST {

    @isTest
    static void updateCaseOnTaskTest(){
        List<String> listContactIds = new List<String>();
        
        Account account = new Account();
        account.Name = 'Test Account';
        insert account;
        
        Contact contact = new Contact();
        contact.LastName = 'Last Name';
        contact.AccountId = account.id;
        insert contact;
        listContactIds.add(contact.Id);
        
        Case caseRecord = new Case();
        caseRecord.Subject = 'Test Case';
        caseRecord.AccountId = account.id;
        insert caseRecord;
        
         Case caseRecord1 = new Case();
        caseRecord1.Subject = 'Test Case';
        caseRecord1.AccountId = account.id;
        insert caseRecord1;
        
        EmailMessage emailMessage = new EmailMessage();
		emailMessage.toIds = listContactIds;
		emailMessage.toAddress = 'toaddresssubject@test.com';
        emailMessage.status = '3';
        emailMessage.FromAddress = 'Test@test.com';
        emailMessage.TextBody = 'Test Body ';
        emailMessage.Subject = 'Subject test';
        emailMessage.RelatedToId = account.Id;
        emailMessage.htmlBody = '<p>test<p>';
        emailMessage.Case__c = caseRecord.Id;
        
        Test.startTest();
            insert emailMessage;
            emailMessage.Case__c = caseRecord1.Id;
            update emailMessage;
            emailMessage.Case__c = null;
            update emailMessage;
        Test.stopTest();
    }
    
}