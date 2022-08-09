/**
* @description       : Test class for SM_CaseCHOHarmonica_Controller (FT1-4947)
* @author            : Zouhair BOUKHRISS
* @group             : 
* @last modified on  : 02-07-2021
* @last modified by  : David ATTALI
* Modifications Log 
* Ver   Date         Author               Modification
* 1.0   01-07-2021   Zouhair BOUKHRISS    Initial Version
* 1.1   02-07-2021   David ATTALI         Comments, delete method testGetDataCHO_OnlineTunnel_WithoutBanksDetails and modify method testGetDataCHO_OnlineTunnel_WithBanksDetails
**/
@isTest
public class SM_CaseCHOHarmonica_Controller_test {
    
    @isTest
    static void testGetDataCHO_OnlineTunnel_WithBanksDetails() {
        
        // Create contact
        String contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact_Smile').getRecordTypeId(); 
        Contact contact = new Contact(LastName = 'Test', RecordTypeId = contactRecordTypeId, Identifiant_Buisness_Partener__c = '146559850');
        insert contact;

        // Create case
        String caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Service').getRecordTypeId();   
        Case onlineTunnelCase = new Case();
        onlineTunnelCase.ContactId = contact.Id;
        onlineTunnelCase.Subject = 'Test';
        onlineTunnelCase.Status = 'Nouveau';
        onlineTunnelCase.RecordTypeId = caseRecordTypeId;
        insert onlineTunnelCase;
        
        // Case : with banks details (without IBAN crypted)
        String dataRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Acquisition_Harmonica').getRecordTypeId();   
        Donnees_Vente__c onlineTunnelData = new Donnees_Vente__c();
        onlineTunnelData.CaseId__c = onlineTunnelCase.id;
        onlineTunnelCase.RecordTypeId = dataRecordTypeId;
        onlineTunnelData.ID_coordonnees_bancaires__c = '0306559850-0001';
        insert onlineTunnelData;
        
        Test.startTest();
        
        SM_CaseCHOHarmonica_Controller.HarmonicaCHOData harmonicaDataCHO = SM_CaseCHOHarmonica_Controller.getDataCHO(onlineTunnelCase.id);
        
        Test.stopTest();
        
        System.assertEquals('0306559850-0001', harmonicaDataCHO.harmonicaBankDetailsId);
        System.assertEquals('146559850', harmonicaDataCHO.clientBPId);
        System.assertEquals(contact.Id, harmonicaDataCHO.contactId);
    }
    
}