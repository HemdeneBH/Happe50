@isTest
public class SM_EspaceClientResendActivatonEmail_TEST {

    @isTest
    public static void  testInvokeMethod(){
        String methodName = '';
        Map < String, Object > inputMap = new Map < String, Object >(); 
        Map < String, Object > outMap = new Map < String, Object >();
        Map < String, Object > options = new Map < String, Object >();
        inputMap.put('refClientIdBP','123435');
        map<String,Object> contactInfo = new map<String,Object>();
        contactInfo.put('email','toto@gmail.com');
        inputMap.put('ContactInfo',contactInfo);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource('SM_MockResponseApiEmailActivation');
		mock.setStatusCode(200);
		mock.setHeader('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, mock);
        SM_EspaceClientResendActivatonEmail espaceClient = new SM_EspaceClientResendActivatonEmail();
        system.assertEquals(true, espaceClient.invokeMethod(methodName,inputMap,outMap,options));
        //espaceClient.invokeMethod(methodName,inputMap,outMap,options);
    }
}