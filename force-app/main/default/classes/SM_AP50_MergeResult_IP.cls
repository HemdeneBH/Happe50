global class SM_AP50_MergeResult_IP implements vlocity_cmt.VlocityOpenInterface {

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {

        if (methodName.equals('mergeList')) {
            try {
                mergeList(inputMap, outMap, options);
            } catch (Exception e) {
                system.debug('Exception: ' + e);
                System.debug(e.getStackTraceString());
                return false;
            }
        }
        
        if (methodName.equals('getStories')) {
            try {
                getStories(inputMap, outMap, options);
            } catch (Exception e) {
                system.debug('Exception: ' + e);
                return false;
            }
        }
       
        return true;

}
     public static void mergeList(Map<String,Object> inputMap, Map<String,Object> outMap, Map <String,Object> options) {

        system.debug('@@ SM_AP50 inputMap ' +inputMap);
         
         Map < String, Object > callContrats = (Map < String, Object > ) inputMap.get('ContratsWS');
         System.debug('*** ' + callContrats);
         Object resultdata =  callContrats.get('resultdata');
         String JSONString = JSON.serialize(resultdata);
        outMap.put('JSONString',JSON.deserializeUntyped(JSONString));

}
    
     public static void getStories(Map<String,Object> inputMap, Map<String,Object> outMap, Map <String,Object> options) {

        system.debug('@@ SM_AP50 inputMap ' +inputMap);
        Map < String, Object > StoryListHandler = (Map < String, Object > ) inputMap.get('StoryListHandler');
        system.debug('@@ SM_AP50 StoryListHandler ' +StoryListHandler);

        Map < String, Object > newList =  new Map < String, Object >();
        newList.putAll(StoryListHandler);

        Object Stories =  StoryListHandler.get('Stories');
        system.debug('@@ SM_AP50 newList ' +Stories);
        String JSONString = JSON.serialize(Stories);
        system.debug('*****'+JSON.deserializeUntyped(JSONString));
        outMap.put('JSONString',JSON.deserializeUntyped(JSONString));
        //outMap.putAll(newList);

}
    
    
}