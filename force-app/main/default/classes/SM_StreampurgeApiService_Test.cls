@isTest
global class SM_StreampurgeApiService_Test {
    @isTest
    global static void callStreampurgeApiServiceTest() {

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

        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        //changer le fichier mock par un exemple de réponse de cette API
        mock.setStaticResource('SM_MockResponseApiLocal');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        system.debug('sendData mock : '+mock);
        Test.setMock(HttpCalloutMock.class, mock);
        SM_StreampurgeApiService.callStreampurgeApi('test');
        Test.stopTest();

        List<SyncEventLog__c> listSyncEventLog = [Select id From SyncEventLog__c limit 1];
        System.assertEquals(0, listSyncEventLog.size());
    }
    @isTest
    global static void callStreampurgeApiServiceTest2() {
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
        
        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        //changer le fichier mock par un exemple de réponse de cette API
        mock.setStaticResource('SM_MockResponseApiLocal');
        mock.setStatusCode(400);
        mock.setHeader('Content-Type', 'application/json');
        system.debug('sendData mock : '+mock);
        Test.setMock(HttpCalloutMock.class, mock);
        SM_StreampurgeApiService.callStreampurgeApi('test');
        Test.stopTest();

        List<SyncEventLog__c> listSyncEventLog = [Select id From SyncEventLog__c limit 1];
        System.assertEquals(0, listSyncEventLog.size());
    }
}