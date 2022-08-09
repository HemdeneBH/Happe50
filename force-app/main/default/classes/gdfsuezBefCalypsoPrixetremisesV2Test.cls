@isTest  
private class gdfsuezBefCalypsoPrixetremisesV2Test {   
    
    private class gdfsuezBefCalypsoPrixetremisesV2MockImplt implements WebServiceMock {
    
        public void doInvoke(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType) {
        
            if(request instanceOf gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesServices_element) {
                response.put( 'response_x', new gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesServicesResponse_element());
            } else if(request instanceOf gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemises_element) {
                response.put( 'response_x', new gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesResponse_element());
            } else if(request instanceOf gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemises_element) {
                response.put( 'response_x', new gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesResponse_element());
            }
            return;
        } 
    }

    @IsTest
    private static void coverGeneratedCodeCRUDOperations()
    {	
        // Null Web Service mock implementation
        System.Test.setMock(WebServiceMock.class, new gdfsuezBefCalypsoPrixetremisesV2MockImplt());
        // Only required to workaround a current code coverage bug in the platform
        gdfsuezBefCalypsoPrixetremisesV2 service = new gdfsuezBefCalypsoPrixetremisesV2();
        // Invoke operations     
        Test.startTest();    
        gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort port = new gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort();
        Test.stopTest();
    }

    @IsTest
    private static void coverGeneratedCodeFileBasedOperations1()
    {    	
    	// Null Web Service mock implementation
        System.Test.setMock(WebServiceMock.class, new gdfsuezBefCalypsoPrixetremisesV2MockImplt());
        // Only required to workaround a current code coverage bug in the platform
        gdfsuezBefCalypsoPrixetremisesV2 service = new gdfsuezBefCalypsoPrixetremisesV2();
        // Invoke operations    
        Test.startTest();

        gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort metaDataPort = new gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort();
        metaDataPort.RechercherPrixEtRemises(null, null);
        metaDataPort.RechercherPrixEtRemisesServices(null, null);
        
        Test.stopTest();
    }

    @IsTest
    private static void coverGeneratedCodeTypes()
    {    	       
        // Reference types
        Test.startTest();
        new gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesServices_element();
        new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
        new gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesServicesOutputDt();
        new gdfsuezBefCalypsoPrixetremisesV2.donneesPackDt();
        new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreServiceOutDt();
        new gdfsuezBefCalypsoPrixetremisesV2.remiseDt ();
        new gdfsuezBefCalypsoPrixetremisesV2.identifiantsLieuDt();
        new gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesServicesResponse_element();
        new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt();
        new gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt();
        new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreServiceInDt();
        new gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemises_element();
        new gdfsuezBefCalypsoPrixetremisesV2.listeCaracteristiquesDiagDt ();
        new gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesServicesInputDt();
        new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesDiagnosticGazDt();
        new gdfsuezBefCalypsoPrixetremisesV2.listeRemisesDt();
        new gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesResponse_element();
        new gdfsuezBefCalypsoPrixetremisesV2.prixServiceDt();
        new gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesOutputDt();
        new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
        new gdfsuezBefCalypsoPrixetremisesV2.listePrixDt();
        new gdfsuezBefCalypsoPrixetremisesV2.donneesOffreServiceDt();
        new gdfsuezBefCalypsoPrixetremisesV2.listePrixServiceDt();
        new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesDiagnosticElecDt();
        new gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt();
        Test.stopTest();
    }

}