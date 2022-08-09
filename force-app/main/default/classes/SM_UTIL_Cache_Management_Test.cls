@isTest
public class SM_UTIL_Cache_Management_Test {
    
    static testMethod void testCacheInfos(){
        Map < String, Object > input = new Map < String, Object >();
        Map < String, Object > output = new Map < String, Object >();
        Map < String, Object > options = new Map < String, Object >();
        input.put('identifiantDistrib','identifiantDistrib');
        input.put('token','token');
        input.put('GetIdDistrib','true');
        options.put('identifiantDistrib',true);
        options.put('token_SAP',true);         
        
        SM_UTIL_Cache_Management service = new SM_UTIL_Cache_Management();
        service.invokeMethod('getCacheInfos', input, output, options);
        service.invokeMethod('setCacheInfos', input, output, options);
        service.invokeMethod('getOctopusToken_SAP', input, output, options);
        service.invokeMethod('setOctopusToken_SAP', input, output, options);
        service.invokeMethod('setIdentifiantDistrib', input, output, options);
        service.invokeMethod('getIdentifiantSAPToOS', input, output, options);
        service.getIdentifiantDistribFromApex();  
        service.getIdentifiantSAPFromApex();
        
        //Test with orgPartition
        SM_UTIL_Cache_Management.cacheOrg = true;
        service.invokeMethod('getOctopusToken_SAP', input, output, options);
        service.invokeMethod('setOctopusToken_SAP', input, output, options);
    }
    
}