public class SM_AP77_CallIPApiService {
    @AuraEnabled(cacheable=false)
    public static Map < String, Object > callIP(Map<String,Object> inputMap, String NameIntergation) {
        System.debug('### aka inputMap ' + inputMap);
        Map < String, Object > options  = new Map<String, Object>();
        Map<String, Object> ipOutput;
        if(!Test.isRunningTest()){
            if(NameIntergation.equals('IP_SM_CreerPA_MAJPersonne')){
                inputMap = transformComplexInput(inputMap);
            }
            System.Debug('### aka inputMap 222 ' + inputMap);
            ipOutput = (Map<String,Object>)vlocity_cmt.IntegrationProcedureService.runIntegrationService(NameIntergation,  inputMap , options);
        }

        return ipOutput;
    }
    
    public static Map<String, Object> transformComplexInput(Map<String, Object> inputMap){
        System.debug('### inputMap ' + inputMap);
        Map<String, Object> transformedInput = new Map<String, Object>();
        for(String key : inputMap.keySet()){
            System.Debug('### inputMap.get(key)' + inputMap.get(key));
            transformedInput.put(key, transformInput(inputMap.get(key)));
        }
        return transformedInput;
        
    }
    public static Object transformInput(Object obj){
        Map<String, Object> tempMap = new Map<String, Object>();
        List<Object> listO;
        List<Object> newListO;
        
        if(obj instanceOf Map<Object, Object>){
            tempMap.putAll(transformMap((Map<Object, Object>) obj));
            return tempMap;  
        }
        else if(obj instanceOf List<Object>){
            listO = (List<Object>) obj;
            newListO = new List<Object>();
            for(Object oT : listO){
                newListO.add(transformInput(oT));
                
            }
            return newListO;
            
        }
        else{
            return obj;
        }
        
    }
    
    
    private static Map<String, Object> transformMap(Map<Object, Object> inputMap){
    
        Map<String, Object> tempMap = new Map<String, Object>();
        for(Object o : inputMap.keySet()){
            tempMap.put(String.valueOf(o), transformInput(inputMap.get(o)));
        }    
        
        return tempMap;
        
    }
}