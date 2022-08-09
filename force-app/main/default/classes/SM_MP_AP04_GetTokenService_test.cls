@isTest
    public class SM_MP_AP04_GetTokenService_test {


        @isTest
        public static void test() {

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
            api_version.Name = 'api_version';
            insert api_version;


            MP_Xdata_credentials__c api_key = new MP_Xdata_credentials__c();
            api_key.Value__c = 'l7xx914e96a9169640b2ab5afd09c6163829';
            api_key.Name = 'api_key';
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
            
            SM_MP_AP04_GetTokenService.getTokenFromSmile();
            
            String json = '{"test":"test"}';
            SM_MP_AP04_GetTokenService.getJsonFieldAsString('test',json) ;
        }

    }