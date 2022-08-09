@isTest
public class SM_AP34_GetAPIService_Test {
    @isTest
    public static void test() {        
        MP_Generics_Endpoints__c endpoint = new MP_Generics_Endpoints__c();
        endpoint.EndPoint__c = 'https://auth.ext.rec.api.engie.fr';
        endpoint.Name = 'api_endpoint';
        insert endpoint;
        
        MP_Xdata_credentials__c sm_api_version = new MP_Xdata_credentials__c();
        sm_api_version.Value__c = '0.1';
        sm_api_version.Name = 'sm_api_version';
        insert sm_api_version;
        
        MP_Xdata_credentials__c sm_api_key_INT = new MP_Xdata_credentials__c();
        sm_api_key_INT.Value__c = 'l7xx914e96a9169640b2ab5afd09c6163829';
        sm_api_key_INT.Name = 'sm_api_key_INT';
        insert sm_api_key_INT;

        MP_Xdata_credentials__c sm_api_key = new MP_Xdata_credentials__c();
        sm_api_key.Value__c = 'l7xx914e96a9169640b2ab5afd09c6163829';
        sm_api_key.Name = 'sm_api_key';
        insert sm_api_key;
        
        Map<String , object>inputMap = new Map<String, object>() ;
        Map<String , object>outputMap = new Map<String, object>() ;
        
        SM_AP34_GetAPIService service = new SM_AP34_GetAPIService ();
        
        service.invokeMethod('getAuth', inputMap,  outputMap, null) ;
    }
}