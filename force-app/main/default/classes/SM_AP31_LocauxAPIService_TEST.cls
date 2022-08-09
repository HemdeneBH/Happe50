@isTest
global class SM_AP31_LocauxAPIService_TEST {
    @isTest
    global static void test() {
        
        MP_Generics_Endpoints__c endpoint = new MP_Generics_Endpoints__c();
        endpoint.EndPoint__c = 'https://auth.ext.rec.api.engie.fr';
        endpoint.Name = 'api_endpoint';
        insert endpoint;
        
        MP_Xdata_credentials__c sm_api_version = new MP_Xdata_credentials__c();
        sm_api_version.Value__c = '0.1';
        sm_api_version.Name = 'sm_api_version';
        insert sm_api_version;
        
        MP_Xdata_credentials__c sm_api_key = new MP_Xdata_credentials__c();
        sm_api_key.Value__c = 'l7xx914e96a9169640b2ab5afd09c6163829';
        sm_api_key.Name = 'sm_api_key_INT';
        insert sm_api_key;
        
        Map<String , object>inputMap = new Map<String, object>() ;
        inputMap.put('numeroLocal',25972);
        
        Map<String,Object> outputMap = new Map<String,Object>();
        
        SM_AP31_LocauxApiService service = new SM_AP31_LocauxApiService() ;
        
        service.invokeMethod('callLocaux', inputMap,  outputMap, null) ;
        
        
        HttpRequest request =  SM_AP31_LocauxAPIService.buildHttpRequestHeaders('tokentest',String.valueOf(inputMap.get('numeroLocal'))) ;
        SM_AP31_LocauxAPIService.sendData(request ) ;
        
        SM_AP31_LocauxAPIService.getResponse('tokentest',String.valueOf(inputMap.get('numeroLocal')),false) ;
        
        
    }
    
    
    @isTest
    global static void testGetIdLocal() {

        Map<String , object>inputMap = new Map<String, object>() ;
        inputMap.put('numeroLocal','0713911170');
        
        Map<String,Object> outputMap = new Map<String,Object>();
        
        SM_AP31_LocauxApiService service = new SM_AP31_LocauxApiService() ;
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SM_MockResponseApiLocal');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        
        // WHEN
        service.invokeMethod('getIdNewLocal', inputMap,  outputMap, null) ;
        
        //THEN 
        System.assertEquals('230195',outputMap.get('idLocal'));
        
    }
}