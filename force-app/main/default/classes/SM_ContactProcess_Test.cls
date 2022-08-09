@isTest
public class SM_ContactProcess_Test {
    public static testmethod void testContactProcess(){
        
        Contact aC = new Contact(LastName = 'Test', Adresse_Mail_3__c = 'test1@test.com', Tel_Fixe_3__c='0123456789', Mobile_3__c='0623456789');
        insert aC;
        
        aC.Tel_Fixe_3__c ='0123456785';
        aC.Mobile_3__c='0623456785';
        aC.Adresse_Mail_3__c = 'test2@test.com';
        update aC;
        
    }

}