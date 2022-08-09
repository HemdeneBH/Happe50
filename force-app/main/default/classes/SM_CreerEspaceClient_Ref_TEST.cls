@isTest
public class SM_CreerEspaceClient_Ref_TEST {
    @isTest
    public static void  testInvokeMethod(){
        String methodName = 'creerEpaceClient';
        Map < String, Object > inputMap = new Map < String, Object >(); 
        Map < String, Object > inputMap2 = new Map < String, Object >(); 
        Map < String, Object > outMap = new Map < String, Object >();
        Map < String, Object > options = new Map < String, Object >();
        inputMap.put('refClientIdBP','123435');
        map<String,Object> contactInfo = new map<String,Object>();
        map<String,Object> contacserviceGestiontInfo = new map<String,Object>();
        inputMap.put('emailConnexion','toto@gmail.com');
        inputMap.put('ContextId',SM_TestDataFactory.createContact('toto', SM_TestDataFactory.createAccount('toto').id).id);
        inputMap.put('email','');
        inputMap.put('nom','JEANVALJEAN');
        inputMap.put('prenom','jEAN');
        inputMap.put('civilite','Mr');
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SM_MockResponseApiEspacesPrives');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        SM_CreerEspaceClient_Ref espaceClient = new SM_CreerEspaceClient_Ref();
         espaceClient.invokeMethod(methodName,inputMap,outMap,options);
    //    system.assertEquals(false, espaceClient.invokeMethod(methodName,inputMap,outMap,options));

        
        inputMap.put('emailConnexion','');
        inputMap.put('email','toto@gmail.com');
        SM_CreerEspaceClient_Ref espaceClient2 = new SM_CreerEspaceClient_Ref();
       // system.assertEquals(false, espaceClient2.invokeMethod(methodName,inputMap,outMap,options));        
        espaceClient2.invokeMethod(methodName,inputMap,outMap,options);
    }
}