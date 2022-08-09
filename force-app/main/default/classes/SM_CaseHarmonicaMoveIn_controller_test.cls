/**
* @description       : Test class for SM_CaseHarmonicaMoveIn_controller
* @author            : ???
* @group             : 
* @last modified on  : 03-12-2021
* @last modified by  : David ATTALI
* Modifications Log 
* Ver   Date         Author          Modification
* 1.0   ??-??-????   ???             Initial Version
* 1.1   03-12-2021   David ATTALI    FT1-4449 + Refactoring
**/
@isTest
public class SM_CaseHarmonicaMoveIn_controller_test {

    @isTest
    static void testGetData_OnlineTunnel_WithoutBanksDetails() {
        
        // Insert contact
        Contact contact = new contact(LastName = 'Test',

                                      Identifiant_Buisness_Partener__c = '306559850',
                                     RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Smile').getRecordTypeId());

        insert contact;

        // Case : Online tunnel without banks details (with IBAN crypted)
        Case onlineTunnelCase = new Case();
        onlineTunnelCase.contactId = contact.Id;
        onlineTunnelCase.Subject = 'Test';
        onlineTunnelCase.Origin = 'Tunnel en ligne';
        onlineTunnelCase.Status = 'Nouveau';
        insert onlineTunnelCase;
        
        Donnees_Vente__c onlineTunnelData = new Donnees_Vente__c();
        onlineTunnelData.CaseId__c = onlineTunnelCase.id;
        onlineTunnelData.IBAN_crypte__c = 'test';
        onlineTunnelData.ID_coordonnees_bancaires__c = '';
        insert onlineTunnelData;
        
        Test.startTest();
        
        // Mock decrypt
        Test.setMock(HttpCalloutMock.class, new SM_decryptage_mock());
        
        SM_CaseHarmonicaMoveIn_controller.HarmonicaData harmonicaData = SM_CaseHarmonicaMoveIn_controller.getData(onlineTunnelCase.id);
        
        Test.stopTest();
        
        
        System.assertNotEquals(null, harmonicaData.data);
    }
    
    @isTest
    static void testGetData_OnlineTunnel_WithBanksDetails() {

        // Case : Online tunnel without banks details (with IBAN crypted)
        Case onlineTunnelCase = new Case();
        onlineTunnelCase.Subject = 'Test';
        onlineTunnelCase.Origin = 'Tunnel en ligne';
        onlineTunnelCase.Status = 'Nouveau';
        insert onlineTunnelCase;
        
        Donnees_Vente__c onlineTunnelData = new Donnees_Vente__c();
        onlineTunnelData.CaseId__c = onlineTunnelCase.id;
        onlineTunnelData.IBAN_crypte__c = 'test';
        onlineTunnelData.ID_coordonnees_bancaires__c = '0306559850-0001';
        insert onlineTunnelData;
        
        Test.startTest();
        
        SM_CaseHarmonicaMoveIn_controller.HarmonicaData harmonicaData = SM_CaseHarmonicaMoveIn_controller.getData(onlineTunnelCase.id);
        
        Test.stopTest();
        
        System.assertNotEquals(null, harmonicaData.data);
        System.assertEquals('0306559850-0001', harmonicaData.harmonicaBankDetailsId);
    }
    
    @isTest
    static void testGetData_PartnerCommunity_WithBanksDetails() {

        // Case : Online tunnel without banks details (with IBAN crypted)
        Case partnerCommunityCase = new Case();
        partnerCommunityCase.Subject = 'Test';
        partnerCommunityCase.Origin = 'Partner Community';
        partnerCommunityCase.Status = 'Nouveau';
        insert partnerCommunityCase;
        
        Donnees_Vente__c partnerCommunityData = new Donnees_Vente__c();
        partnerCommunityData.CaseId__c = partnerCommunityCase.id;
        partnerCommunityData.IBAN_crypte__c = 'test';
        partnerCommunityData.ID_coordonnees_bancaires__c = '0306559850-0001';
        insert partnerCommunityData;
        
        Test.startTest();
        
        SM_CaseHarmonicaMoveIn_controller.HarmonicaData harmonicaData = SM_CaseHarmonicaMoveIn_controller.getData(partnerCommunityCase.id);
        
        Test.stopTest();
        
        System.assertNotEquals(null, harmonicaData.data);
        System.assertEquals('0306559850-0001', harmonicaData.harmonicaBankDetailsId);
    }
    
    @isTest
    static void testUpdateCaseStatus() {

        // Case : Online tunnel without banks details (with IBAN crypted)
        Case onlineTunnelCase = new Case();
        onlineTunnelCase.Subject = 'Test';
        onlineTunnelCase.Status = 'Nouveau';
        insert onlineTunnelCase;
        
        Test.startTest();

        Boolean isUpdated = SM_CaseHarmonicaMoveIn_controller.updateCaseStatus(onlineTunnelCase.id);
        
        Test.stopTest();
        
        System.assertEquals(true, isUpdated);
        System.assertEquals('En Traitement', [SELECT Status FROM Case WHERE Id = :onlineTunnelCase.Id LIMIT 1].Status);
    }
}