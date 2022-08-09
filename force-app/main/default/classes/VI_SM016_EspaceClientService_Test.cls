/* 
@Project : Pure Player
@Description : Classe de test de VI_SM016_EspaceClientService

*/
@isTest
public class VI_SM016_EspaceClientService_Test {
    @testSetup 
    static void testSetup(){ 
        MP_Xdata_credentials__c client_id = new MP_Xdata_credentials__c();
        client_id.Value__c = '516a8780-afd6-45d0-903e-e3caaeab4bc5';
        client_id.Name = 'VI_client_id';
        insert client_id;
        
        MP_Xdata_credentials__c client_secret = new MP_Xdata_credentials__c();
        client_secret.Value__c = 'fa1a7c0c-8420-447e-bfd8-b54303b84794';
        client_secret.Name = 'VI_client_secret';
        insert client_secret;
        
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
        
        MP_Xdata_credentials__c VI_scope = new MP_Xdata_credentials__c();
        VI_scope.Value__c = 'apiset.read';
        VI_scope.Name = 'VI_scope';
        insert VI_scope;
        
        MP_Xdata_credentials__c VI_user_tranquility = new MP_Xdata_credentials__c();
        VI_user_tranquility.Value__c = '4bf81dd4-b8ec-4c4b-9c84-8e009d8a2b35';
        VI_user_tranquility.Name = 'VI_user_tranquility';
        insert VI_user_tranquility;
        
        MP_Xdata_credentials__c VI_password_tranquility = new MP_Xdata_credentials__c();
        VI_password_tranquility.Value__c = '868e3fed-b555-4e42-9430-5bc93755ca51';
        VI_password_tranquility.Name = 'VI_password_tranquility';
        insert VI_password_tranquility;
    }
    
    @isTest
    public static void testcreerEspaceClient() {
        Account acc = new Account(ID_Local__c =4543,ID_Porte_feuille_contrat__c=432432, No_Compte_contrat__c='5435',Name='test user');
        insert acc ;
        Contact contactNew = new Contact(AccountId=acc.Id,Identifiant_Buisness_Partener__c='1234567890',LastName='user',Email = 'test1@email.com',Adresse_Mail_2__c = 'test2@email.com',Adresse_Mail_3__c = 'test3@email.com',Adresse_Mail_Principale__c = 'Adresse Mail 1') ;
        insert contactNew ;
        SM_OCTOPUS__c orgSettings = new SM_OCTOPUS__c();
        orgSettings.certName__c = 'smilecert';
        insert orgSettings;
        Map<String,Object> outMap = new Map<String,Object>();
        Test.startTest();
        VI_SM016_EspaceClientService.EspaceClientACreer eac=new VI_SM016_EspaceClientService.EspaceClientACreer('test','test','test','test','test');
        
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_TestEspaceClientService');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        
        Test.setMock(HttpCalloutMock.class, multimock);
        Map < String, Object > espaceClientACreerMap =new Map<String,Object>();
        espaceClientACreerMap.put('prenom','prenom');
        espaceClientACreerMap.put('nom','user');
        espaceClientACreerMap.put('civilite','Mr');
        espaceClientACreerMap.put('email','test1@email.com');
        espaceClientACreerMap.put('numeroBP','1234567890');
        VI_SM016_EspaceClientService.creerEspaceClient('prenom','nom','Mr','test1@email.com','1234567890','VI', 'local.VIToken');
        Test.stopTest();
    }
    
    @isTest
    static void testrenvoyerMailActivation(){
        Test.startTest();
        
        
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_TestEspaceClientService');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        
        Test.setMock(HttpCalloutMock.class, multimock);
        Map < String, Object > MailActivationrMap =new Map<String,Object>();
        MailActivationrMap.put('login','test1@email.com');
        MailActivationrMap.put('numeroBP','1234567890');
        VI_SM016_EspaceClientService.renvoyerMailActivation('login','VI', 'local.VIToken');
        Test.stopTest();
        
    }
}