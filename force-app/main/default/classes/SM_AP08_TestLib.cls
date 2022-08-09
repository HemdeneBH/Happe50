@isTest
public class SM_AP08_TestLib {
    
     public static void insertCS_SMOCTOPUS(){
        SM_OCTOPUS__c CS_Setting = new SM_OCTOPUS__c();
        CS_Setting.appName__c = 'Smile';
        CS_Setting.certName__c = 'smilecert';
        CS_Setting.endpoint__c = 'https://octopus.ws-ines-rct.engie.com:50001/smile-noprod-gdc/ws/';        
        insert CS_Setting;      
    }
    
    public static void insertCS_GenericEndpoints(){
        MP_Generics_Endpoints__c endpoint = new MP_Generics_Endpoints__c();
        endpoint.EndPoint__c = 'https://auth.ext.rec.api.engie.fr';
        endpoint.Name = 'api_endpoint';
        insert endpoint;      
    }
    Public static void insertCS_XDATACredentials(){
        List<MP_Xdata_credentials__c> listRecords= new List<MP_Xdata_credentials__c>();
        
        MP_Xdata_credentials__c sm_api_version = new MP_Xdata_credentials__c();
        sm_api_version.Value__c = '0.1';
        sm_api_version.Name = 'sm_api_version';
        listRecords.add(sm_api_version);
       
        MP_Xdata_credentials__c sm_api_key = new MP_Xdata_credentials__c();
        sm_api_key.Value__c = 'l7xx914e96a9169640b2ab5afd09c6163829';
        sm_api_key.Name = 'sm_api_key';
        listRecords.add(sm_api_key);
        
        MP_Xdata_credentials__c sm_api_key_INT = new MP_Xdata_credentials__c();
        sm_api_key_INT.Value__c = 'l752ad743071854f3094e49b1a9bb119e2';
        sm_api_key_INT.Name = 'sm_api_key_INT';
        listRecords.add(sm_api_key_INT);
        
        insert listRecords;
    }
            

}