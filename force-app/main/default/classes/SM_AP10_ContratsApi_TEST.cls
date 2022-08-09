@isTest
global class SM_AP10_ContratsApi_TEST {
    
    private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            System.debug('*** req : ' + req.getEndpoint());
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String endpoint = req.getEndpoint();
            res.setBody('{"_data":[{"id":98194,"idPortefeuilleContrat":169158,"idPersonne":140975,"numeroContrat":"6009277011","typeContrat":"Electricité","statutComposante":"Actif","dureeContratEnMois":null,"dateEmmenagement":"2017-10-14","dateDemenagement":"9999-12-31","dateDebutContrat":"2017-10-14","dateFinContrat":"9999-12-31","facture":false,"numeroContratCRM":"6011997021","numeroInstallation":"0919248984","idOffre":304,"offre":"ÉlecAjust2ans","codeOffre":"EBUA2","idInstallation":133693,"idPointDeLivraison":233343,"dateDebutValidite":"2017-10-14","dateFinValidite":"9999-12-31","numeroContratExterne":"","idPropositionCommerciale":320657,"idAgence":0,"codeEquipement":null,"libelleEquipement":null,"_links":{"self":"https://qa-rec-dmzext-gtw.api.engie.fr:8550/api/apiset/0.1/contrats/98194"}},{"id":98201,"idPortefeuilleContrat":169158,"idPersonne":140975,"numeroContrat":"6009277012","typeContrat":"GazNaturel","statutComposante":"Actif","dureeContratEnMois":null,"dateEmmenagement":"2017-10-19","dateDemenagement":"9999-12-31","dateDebutContrat":"2017-10-19","dateFinContrat":"9999-12-31","facture":false,"numeroContratCRM":"6011997021","numeroInstallation":"0901078010","idOffre":335,"offre":"GazAjust2ans","codeOffre":"GBUA2","idInstallation":4442,"idPointDeLivraison":126214,"dateDebutValidite":"2017-10-19","dateFinValidite":"9999-12-31","numeroContratExterne":"","idPropositionCommerciale":320665,"idAgence":0,"codeEquipement":null,"libelleEquipement":null,"_links":{"self":"https://qa-rec-dmzext-gtw.api.engie.fr:8550/api/apiset/0.1/contrats/98201"}}]}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    @TestSetup
    public static void initData(){
        MP_Generics_Endpoints__c endpoint = new MP_Generics_Endpoints__c();
        endpoint.EndPoint__c = 'https://auth.ext.rec.api.engie.fr';
        endpoint.Name = 'api_endpoint';
        insert endpoint;

        MP_Xdata_credentials__c client_id = new MP_Xdata_credentials__c();
        client_id.Value__c = '516a8780-afd6-45d0-903e-e3caaeab4bc5';
        client_id.Name = 'client_id';
        insert client_id;

        MP_Xdata_credentials__c client_secret = new MP_Xdata_credentials__c();
        client_secret.Value__c = 'fa1a7c0c-8420-447e-bfd8-b54303b84794';
        client_secret.Name = 'client_secret';

        insert client_secret;

        MP_Xdata_credentials__c api_version = new MP_Xdata_credentials__c();
        api_version.Value__c = '0.1';
        api_version.Name = 'sm_api_version';
        insert api_version;


        MP_Xdata_credentials__c api_key = new MP_Xdata_credentials__c();
        api_key.Value__c = 'l7xx914e96a9169640b2ab5afd09c6163829';
        api_key.Name = 'sm_api_key_INT';
        insert api_key;


        MP_Xdata_credentials__c sm_client_id = new MP_Xdata_credentials__c();
        sm_client_id.Value__c = '4bf81dd4-b8ec-4c4b-9c84-8e009d8a2b35';
        sm_client_id.Name = 'sm_client_id';
        insert sm_client_id;

        MP_Xdata_credentials__c sm_client_secret = new MP_Xdata_credentials__c();
        sm_client_secret.Value__c = '868e3fed-b555-4e42-9430-5bc93755ca51';
        sm_client_secret.Name = 'sm_client_secret';
        insert sm_client_secret;


        MP_Xdata_credentials__c sm_scope = new MP_Xdata_credentials__c();
        sm_scope.Value__c = 'apiset.read';
        sm_scope.Name = 'sm_scope';
        insert sm_scope;    
    }
    
    @IsTest(SeeAllData = false)
    public static void callContrats(){
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map <String,Object> options = new Map<String,Object>();
        
        inputMap.put('IdPortefeuilleContrat', '123456789');
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new Mock());
        SM_AP10_ContratsApiService ctrl = new SM_AP10_ContratsApiService();
        ctrl.invokeMethod('callContrats', inputMap, outMap, options);
        
        Test.stopTest();
        
        System.debug(outMap);
        
        List<Object> outContrat = (List<Object>) outMap.get('resultdata');
        
        System.assertEquals(2, outContrat.size());
    }
    
    @IsTest(SeeAllData = false)
    public static void callContratsActif(){
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map <String,Object> options = new Map<String,Object>();
        
        inputMap.put('IdPortefeuilleContrat', '919202');
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new Mock());
        SM_AP10_ContratsApiService ctrl = new SM_AP10_ContratsApiService();
        ctrl.invokeMethod('callContratsActif', inputMap, outMap, options);
        
        Test.stopTest();
        
        System.debug(outMap);
        
        List<Object> outContratElec = (List<Object>) outMap.get('resultdataElec');
        List<Object> outContratGaz = (List<Object>) outMap.get('resultdataGaz');
        
        // System.assertEquals(1, outContratElec.size());
        // System.assertEquals(1, outContratGaz .size());
    }
    
    @IsTest(SeeAllData = false)
    public static void callContratsActifwithIdTest(){
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map <String,Object> options = new Map<String,Object>();
        
        inputMap.put('IdPortefeuilleContrat', '143921');
        inputMap.put('idContrat', '6011928655');
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new Mock());
        SM_AP10_ContratsApiService ctrl = new SM_AP10_ContratsApiService();
        ctrl.invokeMethod('callContratswithId', inputMap, outMap, options);
        
        Test.stopTest();
        
        System.debug(outMap);
        
        // List<Object> outContratElec = (List<Object>) outMap.get('resultdataElec');
        Map<String,Object> outContratGaz = (Map<String,Object>) outMap.get('resultdataGaz');
        
        // System.assertEquals(1, outContratElec.size());
        //System.assertEquals(1, outContratGaz .size());
    }
        
    @IsTest(SeeAllData = false)
    public static void callContratsSelfcare(){
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map <String,Object> options = new Map<String,Object>();
        
        inputMap.put('idPersonne', '123456789');
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new Mock());
        SM_AP10_ContratsApiService ctrl = new SM_AP10_ContratsApiService();
        ctrl.invokeMethod('callContratsSelfcare', inputMap, outMap, options);
        
        Test.stopTest();
        
        System.debug(outMap);
        
        Set<String> outElec = (Set<String>) outMap.get('elec');
        Set<String> outGaz = (Set<String>) outMap.get('gaz');
        
        System.assertEquals(1, outElec.size());
        System.assertEquals(1, outGaz.size());
    }
    
}