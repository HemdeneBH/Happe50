/* 
@Project : Pure Player
@Description : Classe de test de VI_SM015_TranquilityApiService

*/
@isTest
public class VI_SM015_TranquilityApiService_Test {
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
    public static void testCallTranquility() {
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_TestTranquilityApiService');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multimock);
        VI_SM015_TranquilityApiService.callTranquility('asvd','asvd','asvd','asvd','VI', 'local.VIToken');
        VI_SM015_TranquilityApiService.getOffresAvailables('asvd','asvd','asvd','asvd','asvd','asvd','asvd','VI', 'local.VIToken');
        Test.stopTest();
    }
}