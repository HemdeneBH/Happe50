@isTest
public class SM_CreerEspaceClient_TEST {
    @isTest
    public static void  testInvokeMethod(){
        String methodName = '';
        Map < String, Object > inputMap = new Map < String, Object >(); 
        Map < String, Object > outMap = new Map < String, Object >();
        Map < String, Object > options = new Map < String, Object >();
        inputMap.put('refClientIdBP','123435');
        map<String,Object> contactInfo = new map<String,Object>();
        map<String,Object> contacserviceGestiontInfo = new map<String,Object>();
        contacserviceGestiontInfo.put('emailConnexion','toto@gmail.com');
        contacserviceGestiontInfo.put('ContextId',SM_TestDataFactory.createContact('toto', SM_TestDataFactory.createAccount('toto').id).id);
        //contacserviceGestiontInfo.put('','');
        //contactInfo.put('email','toto@gmail.com');
        contactInfo.put('email','');
        //contactInfo.put('mobile','09374763746');
        contactInfo.put('nom','JEANVALJEAN');
        contactInfo.put('prenom','jEAN');
        contactInfo.put('civilite','Mr');
        inputMap.put('ContactInfo',contactInfo);
        inputMap.put('ServicesGestion',contacserviceGestiontInfo);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource('SM_MockResponseApiEspacesPrives');
		mock.setStatusCode(200);
		mock.setHeader('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, mock);
        SM_CreerEspaceClient espaceClient = new SM_CreerEspaceClient();
        system.assertEquals(false, espaceClient.invokeMethod(methodName,inputMap,outMap,options));
        //espaceClient.invokeMethod(methodName,inputMap,outMap,options);
    }
}