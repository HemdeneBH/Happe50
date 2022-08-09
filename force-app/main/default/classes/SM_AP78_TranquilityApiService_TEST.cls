@isTest
public class SM_AP78_TranquilityApiService_TEST {
    /*
*	@description : Appel depuis la vue 360
*/
    @isTest(SeeAllData = true)
    public static void callTranquility(){
        
        
        String methodName='callTranquility';
        Map < String, Object > inputMap = new Map < String, Object >();	
        Map < String, Object > outMap = new Map < String, Object >();
        Map < String, Object > options = new Map < String, Object >();
        SM_AP78_TranquilityApiService trApiSerTest=new SM_AP78_TranquilityApiService();
        
        //bpClient==null
        trApiSerTest.invokeMethod(methodName,inputMap,outMap,options);
        inputMap.put('bpClient',[select Identifiant_Buisness_Partener__c from contact where Identifiant_Buisness_Partener__c!=null limit 1].Identifiant_Buisness_Partener__c);
        //rue==null
        trApiSerTest.invokeMethod(methodName,inputMap,outMap,options);
        inputMap.put('rue','test rue');
        //codePostal==null
        trApiSerTest.invokeMethod(methodName,inputMap,outMap,options);
        inputMap.put('codePostal','92100');
        //commune==null
        trApiSerTest.invokeMethod(methodName,inputMap,outMap,options);
        
        inputMap.put('commune','92');       
        //all param are OK
        trApiSerTest.invokeMethod(methodName,inputMap,outMap,options);
        Cache.OrgPartition part = Cache.Org.getPartition('local.smileToken');
        HttpResponse http=SM_AP78_TranquilityApiService.getResponseTranquility('test','tokenTranquility',inputMap);
        HttpResponse http1=SM_AP78_TranquilityApiService.getResponse('test');


		
        
    }
    
}