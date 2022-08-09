@isTest
global class SM_AP10_ContratsApi_TEST {
    
    private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            System.debug('*** req : ' + req.getEndpoint());
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            
            String endpoint = req.getEndpoint();
            
            if(endpoint.contains('token')){
                res.setBody('{"access_token":"6085ce33-f4e4-420f-83ba-4c3b97ccd643","token_type":"Bearer","expires_in":86400,"scope":"apiset.read smile.read apiset-consentements.write"}');
            } else if(endpoint.contains('contrat')){
                res.setBody('{"_data":[{"id":486149,"idPortefeuilleContrat":216045,"idPersonne":192607,"numeroContrat":"6009189019","typeContrat":"GN","secteurActivite":"Gaz Naturel","idOffre":244,"codeOffre":"GBUF2C","libelleOffre":"GAZ COMPENSÉ CARBONE 2 ANS","uniteReleve":"A10131DB","numeroPointDeLivraison":"21101817660531","statutContrat":"Actif","statutComposante":"Actif","dateDebutContrat":"2018-11-05","dateFinContrat":"9999-12-31","dateEmmenagement":"2018-11-05","dateDemenagement":"9999-12-31","numeroContratCRM":"6011928655","_links":{"self":"https://qa-rec-dmzext-gtw.api.engie.fr:8550/api/smile/0.1/contrats/486149"}},{"id":486150,"idPortefeuilleContrat":216045,"idPersonne":192607,"numeroContrat":"6009189018","typeContrat":"E","secteurActivite":"Electricité","idOffre":148,"codeOffre":"EBUF2V100","libelleOffre":"ELEC FIXE 2 ANS","uniteReleve":"A10131EB","numeroPointDeLivraison":"09701143164444","statutContrat":"Actif","statutComposante":"Actif","dateDebutContrat":"2018-11-05","dateFinContrat":"9999-12-31","dateEmmenagement":"2018-11-05","dateDemenagement":"9999-12-31","numeroContratCRM":"6011928655","_links":{"self":"https://qa-rec-dmzext-gtw.api.engie.fr:8550/api/smile/0.1/contrats/486150"}},{"id":486151,"idPortefeuilleContrat":216045,"idPersonne":192607,"numeroContrat":"6009189018","typeContrat":"E","secteurActivite":"Electricité","idOffre":148,"codeOffre":"EBUF2V100","libelleOffre":"ELEC FIXE 2 ANS","uniteReleve":"A10131EB","numeroPointDeLivraison":"09701143164444","statutContrat":"Inactif","statutComposante":"Inactif","dateDebutContrat":"2018-11-05","dateFinContrat":"9999-12-31","dateEmmenagement":"2018-11-05","dateDemenagement":"9999-12-31","numeroContratCRM":"6011928655","_links":{"self":"https://qa-rec-dmzext-gtw.api.engie.fr:8550/api/smile/0.1/contrats/486150"}}]}');
            } else{
                res.setBody('');
            }
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
        
        System.assertEquals(3, outContrat .size());
    }
    
    @IsTest(SeeAllData = false)
    public static void callContratsActif(){
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map <String,Object> options = new Map<String,Object>();
        
        inputMap.put('IdPortefeuilleContrat', '123456789');
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new Mock());
        SM_AP10_ContratsApiService ctrl = new SM_AP10_ContratsApiService();
        ctrl.invokeMethod('callContratsActif', inputMap, outMap, options);
        
        Test.stopTest();
        
        System.debug(outMap);
        
        List<Object> outContratElec = (List<Object>) outMap.get('resultdataElec');
        List<Object> outContratGaz = (List<Object>) outMap.get('resultdataGaz');
        
        System.assertEquals(1, outContratElec.size());
        System.assertEquals(1, outContratGaz .size());
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