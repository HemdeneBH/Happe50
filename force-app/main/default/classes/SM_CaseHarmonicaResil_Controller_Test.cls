@isTest
public class SM_CaseHarmonicaResil_Controller_Test {
    
     @testSetup static void setup() {
        Contact testContact = new Contact();
        testContact.LastName = 'Test Contact';
        testContact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Smile').getRecordTypeId();
		insert testContact; 
         
        Case harmonicaCase = new Case();
        harmonicaCase.Subject = 'harmonica Résiliation';
        harmonicaCase.Status = 'Nouveau';
        insert harmonicaCase; 
        harmonicaCase.ContactId = testContact.id;
        update harmonicaCase;
              
    }
    
    static testMethod void getContactIdTest(){
       
       Case acase = [select id from Case Limit 1];
       Contact acontact = [select id from contact limit 1];
       String contactId = SM_CaseHarmonicaResil_Controller.getContactId(acase.Id);
       System.assertNotEquals(null, contactId);
    }

}