/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 12-16-2021
 * @last modified by  : Hemdene Ben Hammouda
**/
@isTest
public with sharing class HP_GeneratePDFHelper_TEST {
    
    @TestSetup
    static void dataSetup(){
        HP_UTIL_SmartFactory.insertUserHP();
    }

    @isTest
    static void generatePDFTest(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Case aCase = (Case)HP_UTIL_SmartFactory.createSObject('Case','HP_Mail', new Map<String, Object>{
                'Status' => 'NEW_CASE',
                'HP_Type__c' => 'Service',   
                'Subject' => 'Mail'
                }, null, null, null);
            insert aCase;
            String pdfData = '{"clientName":"MR. Nico test flag LENFANT","clientRef":204833,"situationCompte":"2021-12-03","montantDu":704.87,"dateNextInvoice":"2021-04-02","prelevement":"Oui","montantReglements":"50 € le 10/10/2021","isMensualisee":"Oui","planApurement":"Oui","montantApurement":"350","soldeApurement":"50","caseId":"'+aCase.Id+'"}';
            Test.startTest();
            PageReference pageRef = Page.HP_VF_FicheAidePDF; 
            Test.setCurrentPage(pageRef);
            String result = HP_GeneratePDFHelper.generatePDF(pdfData);
            Test.stopTest();
            ContentDocumentLink objDocumentLink = [SELECT Id FROM ContentDocumentLink where LinkedEntityId = :aCase.Id];
            System.assertEquals(true, objDocumentLink!=null);
        }
    }
}