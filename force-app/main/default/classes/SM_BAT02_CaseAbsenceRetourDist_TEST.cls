/**
 * @File Name          : SM_BAT02_CaseAbsenceRetourDist_TEST
 * @Description        : Classe test pour le batch AbsenceRetourDistributeur 
 * @Author             : Geetha SENTHILNATHAN
 * @Group              : 
 * @Last Modified By   : Hayfa GARBOUT
 * @Last Modified On   : 14/01/2022
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    11/09/2020      Equipe Dev SMILE-FT3     Initial Version
**/
@IsTest
public with sharing class SM_BAT02_CaseAbsenceRetourDist_TEST {
    @testSetup 
    static void dataSetup() {
        Id acquisitionRT = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Acquisition').getRecordTypeId();
        Id smilePrestationDistRT = Schema.SObjectType.Prestation_distributeur__c.getRecordTypeInfosByDeveloperName().get('SM_PrestationDistributeur').getRecordTypeId();
        // create Account
        Account acc = SM_TestDataFactory.createAccount('Smile_Account');
        Insert acc;
       
        // create Contact
        Contact testContact = SM_TestDataFactory.createContact('testContact', acc.Id);
        Insert testContact;

        // Create Cases
        List<Case> casesToInsert = new List<Case>();
        Case testCase1 = SM_TestDataFactory.createCase('TEST1', acc.Id);
        testCase1.RecordTypeId = acquisitionRT;
        testCase1.Origin = 'Téléphone';
        testCase1.Status='En attente';
        testCase1.Sous_statut__c='Retour distributeur';
        casesToInsert.add(testCase1);
        Case testCase2 = SM_TestDataFactory.createCase('TEST2', acc.Id);
        testCase2.RecordTypeId = acquisitionRT;
        testCase2.Status='A traiter';
        testCase2.Sous_statut__c='Retour distributeur';
        casesToInsert.add(testCase2);
        insert casesToInsert;
        
        // Create Prestations
        List<Prestation_Distributeur__c> opsToInsert = new List<Prestation_Distributeur__c>();

        // le nbr de jours du timer
        Integer SM_CL45_TimerEnAttenteRetourDistributeur = Integer.valueOf(System.Label.SM_CL45_TimerEnAttenteRetourDistributeur);

        Date datePrestation1 = System.today().addDays(-SM_CL45_TimerEnAttenteRetourDistributeur);


        Prestation_Distributeur__c testOps1 = SM_TestDataFactory.createOPSData(testContact.Id, testCase1.Id, datePrestation1,
                                                                             'A1234560', 'En cours', smilePrestationDistRT);
        opsToInsert.add(testOps1);
        
        Date datePrestation2 = System.today().addDays(-2);
        Prestation_Distributeur__c testOps2 = SM_TestDataFactory.createOPSData(testContact.Id, testCase2.Id, datePrestation2,
                                                                             'A1234563', 'A initier', smilePrestationDistRT);
        opsToInsert.add(testOps2);
        insert opsToInsert;
    }
    
    @isTest 
    static void testBatchCasesAttenteRetourDistributeur() {
        Test.startTest();
        database.executebatch(new SM_BAT02_CaseAbsenceRetourDist(),200);
		Test.stopTest();
        Integer casesUpdated = [SELECT count() FROM Case 
                                WHERE Priority='High'
                                AND Status='A traiter'
                                AND Sous_statut__c='Absence retour distributeur'];
        System.assertEquals(1, casesUpdated);
        

        // Pour couverture de la classe test

        SM_BAT02_CaseAbsenceRetourDistSchedule batchSch=new SM_BAT02_CaseAbsenceRetourDistSchedule();
        batchSch.execute(null);

    }
}