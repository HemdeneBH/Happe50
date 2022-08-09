/*
* @Author: Ibrahim Merabti
* @Date: 20/04/2020
* @Description: Test Class for HarmonicaMail class 
*/

@isTest
public without sharing class SM_HarmonicaEmailTemplates_TEST {

    @testSetup 
    static void setup() {
        
        // create Account
        Account Acc = SM_TestDataFactory.createAccount('Harmonica_Account');
        Insert acc;
        // Create Case
        Case harmonicaCase = SM_TestDataFactory.createCase('TEST', Acc.Id);
        insert harmonicaCase;
        
        // Create donneé vente
        Donnees_Vente__c dv = SM_TestDataFactory.createDonneeVente(harmonicaCase.Id,'Cergy','ABCD','52','Avenue des loups', '95800');
        dv.Code_pack__c ='DGBUEBUVR2_P';
        dv.Commune__c = 'Cergy';
        dv.Date_resiliation__c =date.valueOf('2021-04-29');
        insert dv;
        
        // Create a product
        Product2 offre = SM_TestDataFactory.createProduct('harmonica_product', 'ABCD', 'ABCD');
        offre.familyLabel__c = 'Offre energie 2 ans';
        offre.Family ='DGBUEBUVR2_P';
        insert offre;
    }
    
    @isTest 
    public static void testDonneesVente(){
        // retrieve the case 
        Case harmonicaCase = [select Id from Case limit 1];
        
        // Prefill SM_HarmonicaEmailTemplates attributes with the CaseId
        SM_HarmonicaEmailTemplates smh = new SM_HarmonicaEmailTemplates();
        smh.CaseId = harmonicaCase.Id;
        smh.dvFieldName = 'Commune__c';
        
        Test.startTest();
        String commune = smh.dvValue;
        Test.stopTest();
        
        // assert equal 
        system.assertEquals('Cergy', commune);
    }
    
       @isTest 
    public static void testProductCode(){
        // retrieve the case 
        Case harmonicaCase = [select Id from Case limit 1];
        
        // Prefill SM_HarmonicaEmailTemplates attributes with the CaseId
        SM_HarmonicaEmailTemplates smh = new SM_HarmonicaEmailTemplates();
        smh.CaseId = harmonicaCase.Id;
        smh.dvFieldName = 'Code_pack__c';
        
        Test.startTest();
        String familyLabel = smh.dvValue;
        Test.stopTest();
        
        // assert equal 
        system.assertEquals('Offre energie 2 ans', familyLabel);
    }
    
}