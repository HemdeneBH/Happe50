/*
*@Author: Clement Bouquin
*@Description: classe de test de VI_SM044_EmailDeConfirmation
*@CreatedDate: 13/09/2021
*@LastModified: 13/09/2021
*/

@isTest
public class VI_SM044_EmailDeConfirmation_Test {

    @isTest
    static void EmailDeConfirmationTest() {
        // create Account
        Account Acc = SM_TestDataFactory.createAccount('Harmonica_Account');
        Insert acc;
        
        // create Contact
        Contact c = new Contact(LastName='Bouquin', FirstName='Clement', Salutation='Mr', Id_Tiers__c=100166,
                                No_Voie__c='127', MailingStreet='Avenue Simon Bolivar', MailingPostalCode='75019', MailingCity='Paris', Complement_adresse__c='');
        Insert c;
        
        // Create Case
        Id CaseRTId = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Acquisition_Harmonica').getRecordTypeId();
        Case caseTest = SM_TestDataFactory.createCase('TEST', Acc.Id);
        caseTest.recordTypeId=CaseRTId;
        caseTest.VI_StatutMandat__c = 'Sent';
        caseTest.VI_StatutEnveloppe__c = 'Sent';
        insert caseTest;   
        
        VI_Parcours__c parcours=VI_testDataFactory.createParcours('CHF', caseTest.id, 'PURE PLAYERS');
        parcours.VI_Contact__c = c.id;
        parcours.VI_Email_CPV__c = 'clement.bouquin@ei-technologies.com';
        insert parcours;
        
        caseTest.VI_StatutMandat__c = 'Signed';
        caseTest.VI_StatutEnveloppe__c = 'Signed';
        update caseTest; 
    }
    
}