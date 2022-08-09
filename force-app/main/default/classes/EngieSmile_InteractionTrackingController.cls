public with sharing class EngieSmile_InteractionTrackingController {
    public String layoutName {get;set;}
    public String nsp { get{return 'vlocity_cmt__';} set;}
     
    public EngieSmile_InteractionTrackingController(){       
    }
     
    @RemoteAction
    public static Map<String, Object> trackChanges(List<Map<String, Object>> trackingData)
    {
        
        if(Test.isRunningTest()){
            System.debug('Test');
            return null;
        }
        else{
        return vlocity_cmt.VlocityTrackingService.track(trackingData);
        }
    }
    
    public void test_Controller(){
        
        System.debug('Test OK'+layoutName+nsp);
        
        List<Map<String, Object>> trackingData = new List<Map<String, Object>>();
        
        trackChanges(trackingData);
    }

}