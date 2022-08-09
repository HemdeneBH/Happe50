@isTest
public class SM_AP50_MergeResult_IP_Test {
    
    static testMethod void mergeTest() {
        Map < String, Object > inputMap = new Map < String, Object >();		
		Map < String, Object > outMap = new Map < String, Object >();
        Map < String, Object > callContrats = new Map < String, Object >();
        
        
        callContrats.put('resultdata','(ContratModel:[dateDebutContrat=31/03/2007, dateFinContrat=24/05/2013]');
        
        inputMap.put('ContratsWS',callContrats);
        
        SM_AP50_MergeResult_IP service = new SM_AP50_MergeResult_IP();
        service.invokeMethod('mergeList',inputMap,outMap,null);

	}

	static testMethod void getStories_TEST() {
        Map < String, Object > inputMap = new Map < String, Object >();	
        Map < String, Object > stories = new Map < String, Object >();	
		Map < String, Object > outMap = new Map < String, Object >();
        
        inputMap.put('StoryListHandler',stories);
        stories.put('Stories', 'StoryListHandler Text');
        
        SM_AP50_MergeResult_IP service = new SM_AP50_MergeResult_IP();
        service.invokeMethod('getStories',inputMap,outMap,null);

        System.assert(!String.isBlank((String) outMap.get('JSONString')));

	}
}