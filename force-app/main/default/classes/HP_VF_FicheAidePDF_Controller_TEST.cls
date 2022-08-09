/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 12-06-2021
 * @last modified by  : Hemdene Ben Hammouda
**/
@isTest
public with sharing class HP_VF_FicheAidePDF_Controller_TEST {
    @TestSetup
    static void dataSetup(){
        HP_UTIL_SmartFactory.insertUserHP();
    }

    @isTest
    static void pdfControllerTest(){
        Test.StartTest(); 
        PageReference pdfPage = Page.HP_VF_FicheAidePDF; 
        pdfPage.getParameters().put('nameText', 'Client Name');
        pdfPage.getParameters().put('idClientText', '254578');
        pdfPage.getParameters().put('situationCompteText', '06/12/2021');
        pdfPage.getParameters().put('montantDuText', '500.00 €');
        pdfPage.getParameters().put('dateNextInvoiceText', '05/01/2022');
        pdfPage.getParameters().put('prelevementEnCoursText', 'Oui');
        pdfPage.getParameters().put('dateMontantsText', '');
        pdfPage.getParameters().put('clientMensualiseText', 'Non');
        pdfPage.getParameters().put('planApurementText', 'Oui');
        pdfPage.getParameters().put('montantTotalPlanApurementText', '750.00 €');
        pdfPage.getParameters().put('soldePlanApurementText', '150.00 €');
        Test.setCurrentPage(pdfPage);
        HP_VF_FicheAidePDF_Controller pdfPageDossierAide = new HP_VF_FicheAidePDF_Controller();
        Test.StopTest();    
    }
}