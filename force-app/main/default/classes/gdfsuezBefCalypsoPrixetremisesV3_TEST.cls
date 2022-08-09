/**
* @description       : Test class for gdfsuezBefCalypsoPrixetremisesV3 (FT1-4381)
* @author            : David Attali
* @group             : 
* @last modified on  : 01-25-2021
* @last modified by  : David ATTALI
* Modifications Log 
* Ver   Date         Author          Modification
* 1.0   01-25-2021   David ATTALI    Initial Version
**/
@isTest
private class gdfsuezBefCalypsoPrixetremisesV3_TEST {

    @IsTest static void coverGeneratedCodeTypes() {    	
        
        Test.startTest();
        
        new gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemisesServices_element();
        new gdfsuezBefCalypsoPrixetremisesV3.caracteristiquesOffreElecDt();
        new gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemisesServicesOutputDt();
        new gdfsuezBefCalypsoPrixetremisesV3.donneesPackDt();
        new gdfsuezBefCalypsoPrixetremisesV3.caracteristiquesOffreServiceOutDt();
        new gdfsuezBefCalypsoPrixetremisesV3.remiseDt();
        new gdfsuezBefCalypsoPrixetremisesV3.identifiantsLieuDt();
        new gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemisesServicesResponse_element();
        new gdfsuezBefCalypsoPrixetremisesV3.caracteristiquesOffreGazDt();
        new gdfsuezBefCalypsoPrixetremisesV3.donneesOffreDt();
        new gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixServices_element();
        new gdfsuezBefCalypsoPrixetremisesV3.caracteristiquesOffreServiceInDt();
        new gdfsuezBefCalypsoPrixetremisesV3.donneesPrixDetailsDt();
        new gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemises_element();
        new gdfsuezBefCalypsoPrixetremisesV3.listeCaracteristiquesDiagDt();
        new gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemisesServicesInputDt();
        new gdfsuezBefCalypsoPrixetremisesV3.donneesPrixCriteresDt();
        new gdfsuezBefCalypsoPrixetremisesV3.caracteristiquesDiagnosticGazDt();
        new gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixServicesInputDt();
        new gdfsuezBefCalypsoPrixetremisesV3.listeRemisesDt();
        new gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemisesResponse_element();
        new gdfsuezBefCalypsoPrixetremisesV3.donneesPrixDt();
        new gdfsuezBefCalypsoPrixetremisesV3.prixServiceDt();
        new gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemisesOutputDt();
        new gdfsuezBefCalypsoPrixetremisesV3.prixDt();
        new gdfsuezBefCalypsoPrixetremisesV3.donneesPrixOutDt();
        new gdfsuezBefCalypsoPrixetremisesV3.listePrixDt();
        new gdfsuezBefCalypsoPrixetremisesV3.donneesOffreServiceDt();
        new gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixServicesResponse_element();
        new gdfsuezBefCalypsoPrixetremisesV3.listePrixServiceDt();
        new gdfsuezBefCalypsoPrixetremisesV3.caracteristiquesDiagnosticElecDt();
        new gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixEtRemisesInputDt();
        new gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixServicesOutputDt();
        new gdfsuezBefCalypsoPrixetremisesV3.criteres_element();
        
        Test.stopTest();
    }
    
    @IsTest static void testRechercherPrixEtRemises(){
        
        Test.startTest();
        
        Test.setMock(WebServiceMock.class, new gdfsuezBefCalypsoPrixetremisesV3_MOCK());
        
        gdfsuezBefCalypsoPrixetremisesV3.PrixEtRemisesPort prixEtRemisesPort = new gdfsuezBefCalypsoPrixetremisesV3.PrixEtRemisesPort();
        prixEtRemisesPort.RechercherPrixEtRemises(null, null);
        
        Test.stopTest();
    }
    
    @IsTest static void testRechercherPrixServices(){
        
        Test.startTest();
        
        Test.setMock(WebServiceMock.class, new gdfsuezBefCalypsoPrixetremisesV3_MOCK());
        
        gdfsuezBefCalypsoPrixetremisesV3.PrixEtRemisesPort prixEtRemisesPort = new gdfsuezBefCalypsoPrixetremisesV3.PrixEtRemisesPort();
        prixEtRemisesPort.RechercherPrixServices(null, null);
        
        Test.stopTest();
    }
    
    @IsTest static void testRechercherPrixEtRemisesServices(){
        
        Test.startTest();
        
        Test.setMock(WebServiceMock.class, new gdfsuezBefCalypsoPrixetremisesV3_MOCK());
        
        gdfsuezBefCalypsoPrixetremisesV3.PrixEtRemisesPort prixEtRemisesPort = new gdfsuezBefCalypsoPrixetremisesV3.PrixEtRemisesPort();
        prixEtRemisesPort.RechercherPrixEtRemisesServices(null, null);
        
        Test.stopTest();
    }
}