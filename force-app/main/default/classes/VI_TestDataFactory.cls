/*
*@Author: Paul Ghousoub
*@Description: Classe data factory pour faciliter la création d'enregistrement dans les test classes
*@CreatedDate: 06/11/2020
*@LastModified: 20/05/2021
*/
public without sharing class VI_TestDataFactory {
    public static void createDummyXData(){
        MP_Generics_Endpoints__c endpoint = new MP_Generics_Endpoints__c();
        endpoint.EndPoint__c = 'https://auth.ext.rec.api.engie.fr';
        endpoint.Name = 'VI_api_endpoint';
        insert endpoint;
        
        MP_Xdata_credentials__c VI_client_id = new MP_Xdata_credentials__c();
        VI_client_id.Value__c = '516a8780-afd6-45d0-903e-e3caaeab4bc5';
        VI_client_id.Name = 'VI_client_id';
        insert VI_client_id;
        
        MP_Xdata_credentials__c VI_api_key_digital_INT = new MP_Xdata_credentials__c();
        VI_api_key_digital_INT.Value__c = '516a8780-afd6-45d0-903e-e3caaeab4bc5';
        VI_api_key_digital_INT.Name = 'VI_api_key_digital_INT';
        insert VI_api_key_digital_INT;
        
        MP_Xdata_credentials__c VI_digital_id_client = new MP_Xdata_credentials__c();
        VI_digital_id_client.Value__c = '516a8780-afd6-45d0-903e-e3caaeab4bc5';
        VI_digital_id_client.Name = 'VI_digital_id_client';
        insert VI_digital_id_client;
        
        MP_Xdata_credentials__c VI_digital_secret_client = new MP_Xdata_credentials__c();
        VI_digital_secret_client.Value__c = '516a8780-afd6-45d0-903e-e3caaeab4bc5';
        VI_digital_secret_client.Name = 'VI_digital_secret_client';
        insert VI_digital_secret_client;
        
        MP_Xdata_credentials__c client_secret = new MP_Xdata_credentials__c();
        client_secret.Value__c = 'fa1a7c0c-8420-447e-bfd8-b54303b84794';
        client_secret.Name = 'VI_client_secret';
        
        insert client_secret;
        
        MP_Xdata_credentials__c api_version = new MP_Xdata_credentials__c();
        api_version.Value__c = '0.1';
        api_version.Name = 'VI_api_version';
        insert api_version;
        
        
        MP_Xdata_credentials__c api_key = new MP_Xdata_credentials__c();
        api_key.Value__c = 'l7xx914e96a9169640b2ab5afd09c6163829';
        api_key.Name = 'VI_api_key';
        insert api_key;
        
        
        MP_Xdata_credentials__c sm_client_id = new MP_Xdata_credentials__c();
        sm_client_id.Value__c = '4bf81dd4-b8ec-4c4b-9c84-8e009d8a2b35';
        sm_client_id.Name = 'VI_client_id';
        insert sm_client_id;
        
        MP_Xdata_credentials__c sm_client_secret = new MP_Xdata_credentials__c();
        sm_client_secret.Value__c = '868e3fed-b555-4e42-9430-5bc93755ca51';
        sm_client_secret.Name = 'VI_client_secret';
        insert sm_client_secret;
        
        
        MP_Xdata_credentials__c sm_scope = new MP_Xdata_credentials__c();
        sm_scope.Value__c = 'apiset.read';
        sm_scope.Name = 'VI_scope';
        insert sm_scope;
        
        MP_Xdata_credentials__c scope = new MP_Xdata_credentials__c();
        scope.Value__c = '516a8780-afd6-45d0-903e-e3caaeab4bc5';
        scope.Name = 'VI_scopeAPIGEE';
        insert scope;
        
        MP_Xdata_credentials__c consumerKey = new MP_Xdata_credentials__c();
        consumerKey.Value__c = '516a8780-afd6-45d0-903e-e3caaeab4bc5';
        consumerKey.Name = 'VI_consumerKeyAPIGEE';
        insert consumerKey;
        
        MP_Xdata_credentials__c consumerSecret = new MP_Xdata_credentials__c();
        consumerSecret.Value__c = '516a8780-afd6-45d0-903e-e3caaeab4bc5';
        consumerSecret.Name = 'VI_consumerSecretAPIGEE';
        insert consumerSecret;
    }
    
    public static cookiecon__CookieConsentCategory__c createCookieConsentCategory(){
        
        cookiecon__CookieConsentCategory__c cookieConsentCategory = new cookiecon__CookieConsentCategory__c(Name = 'Test', cookiecon__Description__c = 'Description', cookiecon__DefaultValue__c = true, cookiecon__Manditory__c = true, cookiecon__AdditionalInformation__c = 'Test');
        
        insert cookieConsentCategory;
        
        return cookieConsentCategory;
        
    }
    
    public static cookiecon__Cookie__c createCookie(Id categoryId){
        
        cookiecon__Cookie__c cookie = new cookiecon__Cookie__c(Name = 'Test', cookiecon__Description__c = 'Test', cookiecon__CookieConsentCategory__c = categoryId);
        
        insert cookie;
        
        return cookie;
        
    }
    
    public static VI_parcours__c createParcours(String choixParcours, String idCase, String canal){
        VI_parcours__c parcousaCreer = new VI_parcours__c(VI_Case__c=idCase,VI_ChoixParcours__c=choixParcours, VI_TypeParcours__c = canal);
        return parcousaCreer;
    }
    
    public static Case createCase(){
        Case caseaCreer = new Case();
        return caseaCreer;
    }
    
}