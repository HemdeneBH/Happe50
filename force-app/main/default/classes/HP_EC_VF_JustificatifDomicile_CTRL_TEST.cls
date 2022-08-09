/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 07-27-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
@IsTest
public with sharing class HP_EC_VF_JustificatifDomicile_CTRL_TEST {
    @TestSetup
    static void dataSetup(){
        HP_UTIL_SmartFactory.insertUserHP();
    }

    @isTest
    static void pdfControllerTest(){
        Test.StartTest(); 
        PageReference pdfPage = Page.HP_EC_VF_JustificatifDomicilePDF; 
        pdfPage.getParameters().put('date_du_jour', '05/01/2022');
        pdfPage.getParameters().put('ref_client', 'ref_client');
        pdfPage.getParameters().put('adresse_factu1', 'adresse_factu1');
        pdfPage.getParameters().put('adresse_factu2', 'adresse_factu2');
        pdfPage.getParameters().put('adresse_local', 'adresse_local');
        pdfPage.getParameters().put('ref_contrat', 'ref_contrat');
        pdfPage.getParameters().put('civilite_titulaire', 'civilite_titulaire');
        pdfPage.getParameters().put('nom_titulaire', 'nom_titulaire');
        pdfPage.getParameters().put('prenom_titulaire', 'prenom_titulaire');
        pdfPage.getParameters().put('civilite_cotitulaire', 'civilite_cotitulaire');
        pdfPage.getParameters().put('nom_cotitulaire', 'nom_cotitulaire');
        pdfPage.getParameters().put('prenom_cotitulaire', 'prenom_cotitulaire');

        pdfPage.getParameters().put('bodyParagraph', 'bodyParagraph');

        pdfPage.getParameters().put('capital_GDF_SUEZ', 'capital_GDF_SUEZ');
        pdfPage.getParameters().put('adr_gdfsuez_siege', 'adr_gdfsuez_siege');
        pdfPage.getParameters().put('numero_tva_gdf_suez', 'numero_tva_gdf_suez');
        pdfPage.getParameters().put('service_client_agilab', 'service_client_agilab');
        pdfPage.getParameters().put('depannage_elec', 'depannage_elec');
        pdfPage.getParameters().put('depannage_gaz', 'depannage_gaz');
        Test.setCurrentPage(pdfPage);
        HP_EC_VF_JustificatifDomicilePDF_CTRL pdfJustificatifDomicile = new HP_EC_VF_JustificatifDomicilePDF_CTRL();
        Test.StopTest();    
    }
}