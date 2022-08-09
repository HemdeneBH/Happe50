/**
* @description       : Test class for SM_CTRL005_RechercherPrixServices (FT1-4381)
* @author            : David Attali
* @group             : 
* @last modified on  : 01-25-2021
* @last modified by  : David ATTALI
* Modifications Log 
* Ver   Date         Author          Modification
* 1.0   01-25-2021   David ATTALI    Initial Version
**/
@isTest
private class SM_CTRL005_RechercherPrixServices_TEST {
    
    /**
     * @description EFOPT_VERT OK
     */
    @isTest static void testInvokeMethod_GetPrixServices_EFOPT_VERT_OK() {
        
        Test.startTest();
        
        Map<String, Object> parameters = new Map<String, Object>();
        parameters.put('code', 'OCTOPUS_RechercherPrixService_01');

        parameters.put('libelle', 'Traitement effectuee sans erreur');

        parameters.put('idOffre', 'EFOPT_VERT');
        parameters.put('donneesPrix_prixMensuelTTC', 3.0);
        Test.setMock(WebServiceMock.class, new SM_SM005_RechercherPrixServices_MOCK(parameters));
        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        inputMap.put('idOffre', 'EFOPT_VERT');
        inputMap.put('puissance', 6);
        inputMap.put('typeDeComptage', 'HPHC');
        
        SM_CTRL005_RechercherPrixServices rechercherPrixServices = new SM_CTRL005_RechercherPrixServices();
        rechercherPrixServices.invokeMethod('getPrixServices', inputMap, outputMap, options);
        
        System.assertEquals('OCTOPUS_RechercherPrixService_01', outputMap.get('code'));

        System.assertEquals('Traitement effectuee sans erreur', outputMap.get('libelle'));
        System.assertEquals('3,00', outputMap.get('prixMensuelTTC_EFOPT_VERT'));

        
        Test.stopTest();
    }
    
    /**
     * @description GOPT_VERT OK
     */
    @isTest static void testInvokeMethod_GetPrixServices_GOPT_VERT_OK() {
        
        Test.startTest();
        
        Map<String, Object> parameters = new Map<String, Object>();
        parameters.put('code', 'OCTOPUS_RechercherPrixService_01');

        parameters.put('libelle', 'Traitement effectuee sans erreur');
        parameters.put('idOffre', 'GOPT_VERT');
        parameters.put('donneesPrix_prixMensuelTTC', 3.0);
        
        parameters.put('donneesPrixAnnexe_prixMensuelTTC', 30.0);
        parameters.put('donneesPrixParametre01', 'ZZCAE');
        parameters.put('donneesPrixValeur01', '006000');
        parameters.put('donneesPrixParametre02', 'ZZTAUX');
        parameters.put('donneesPrixValeur02', '100');

        Test.setMock(WebServiceMock.class, new SM_SM005_RechercherPrixServices_MOCK(parameters));
        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        inputMap.put('idOffre', 'GOPT_VERT');
        inputMap.put('plageDeConsommation', 6000);
        inputMap.put('tauxGazVert', 20);
        
        SM_CTRL005_RechercherPrixServices rechercherPrixServices = new SM_CTRL005_RechercherPrixServices();
        rechercherPrixServices.invokeMethod('getPrixServices', inputMap, outputMap, options);
        
        System.assertEquals('OCTOPUS_RechercherPrixService_01', outputMap.get('code'));

        System.assertEquals('Traitement effectuee sans erreur', outputMap.get('libelle'));
        System.assertEquals('3,00', outputMap.get('prixMensuelTTC_GOPT_VERT'));
        System.assertEquals('30,00', ((Map<String, String>)outputMap.get('additionalPrices')).get('ZZTAUX_100'));

        
        Test.stopTest();
    }
    
    /**
     * @description EFOPT_VERT KO
     */
    @isTest static void testInvokeMethod_GetPrixServices_EFOPT_VERT_KO() {
        
        Test.startTest();
        
        Map<String, Object> parameters = new Map<String, Object>();
        parameters.put('code', 'OCTOPUS_RechercherPrixService_09');

        parameters.put('libelle', 'Aucun prix trouvé pour les paramètres renseignés');

        parameters.put('idOffre', 'EFOPT_VERT');
        parameters.put('donneesPrix_prixMensuelTTC', null);
        Test.setMock(WebServiceMock.class, new SM_SM005_RechercherPrixServices_MOCK(parameters));
        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        inputMap.put('idOffre', 'EFOPT_VERT');
        inputMap.put('puissance', 3);
        inputMap.put('typeDeComptage', 'HPHC');
        
        SM_CTRL005_RechercherPrixServices rechercherPrixServices = new SM_CTRL005_RechercherPrixServices();
        rechercherPrixServices.invokeMethod('getPrixServices', inputMap, outputMap, options);
        
        System.assertEquals('OCTOPUS_RechercherPrixService_09', outputMap.get('code'));

        System.assertEquals('Aucun prix trouvé pour les paramètres renseignés', outputMap.get('libelle'));

        System.assertEquals(null, outputMap.get('prixMensuelTTC_EFOPT_VERT'));
        
        Test.stopTest();
    }
    
    /**
     * @description Exception catching
     */
    @isTest static void testInvokeMethod_GetPrixServices_Exception_Catching() {
        
        Test.startTest();
        


        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        inputMap.put('idOffre', 'EFOPT_VERT');
        inputMap.put('puissance', '6'); // Double parameter (Requires String)
        inputMap.put('typeDeComptage', 'HPHC');
        
        SM_CTRL005_RechercherPrixServices rechercherPrixServices = new SM_CTRL005_RechercherPrixServices();
        rechercherPrixServices.invokeMethod('getPrixServices', inputMap, outputMap, options);

        System.assertEquals('An exception occurred: Invalid conversion from runtime type String to Double', outputMap.get('exception'));
        
        Test.stopTest();
    }

}