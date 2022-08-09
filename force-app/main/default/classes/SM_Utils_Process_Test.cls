@isTest
public class SM_Utils_Process_Test {
    @isTest
    public static void test() {
        Map<String , object>inputMap = new Map<String, object>() ;
        Map<String , object>outputMap = new Map<String, object>() ;
        
        inputMap.put('ServiceName','Contrat');
        
      	SM_Utils_Process service = new SM_Utils_Process ();        
        service.invokeMethod('getParams', inputMap,  outputMap, null) ;
    }

}