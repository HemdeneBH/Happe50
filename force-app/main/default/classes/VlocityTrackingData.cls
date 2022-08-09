/*
* @Author: Amine Deghais ~ amine.deghais@external.engie.com
* @Date: 11/03/2020
* @Description: FT1-3666 Analytics - Configuration granulaire des traces Vlocity
*/
global class VlocityTrackingData implements vlocity_cmt.VlocityOpenInterface {
    //les evenments a tracker si le tracking 'reporting' est activé  
    private static final Map<String, Set<String>> trackingSettingMap = 
            new Map<String, Set<String>> {'Reporting' => new Set<String> {'Remote Action', 'Integration Procedure Action', 'Step'}};
    
    private static final String TRACKING_EVENT = 'TrackingEvent';
    private static final String STEP_ACTION_TIME = 'StepActionTime';
    private static final String ELEMENT_TYPE = 'ElementType';
    
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options)
    {               
        try
        {
            if (methodName == 'processTracking')
            {
                processTrackingEvent((List<Map<String, Object>>)inputMap.get('trackingDataList'), outMap);
            }
       }
        catch (Exception e)
        {
            System.debug( '##### errors dans apex class VlocityTrackingData: ' + e.getMessage());
        }
        return true;
    }
    
    /**
    * Called from above to process the tracking events...
    */
    void processTrackingEvent( List<Map<String, Object>> trackingDataList, Map<String, Object> outMap)
    {       
        String trackingEvent;
        VlocityTrackingSetting__mdt trackingSetting = [Select id, Tracked_Element__c, Label from VlocityTrackingSetting__mdt limit 1];
       	List<Map<String, Object>> trackingFinalData = manageTracking(trackingDataList, trackingSetting);
        outMap.put('trackingSetting', trackingSetting.Tracked_Element__c);
        outMap.put('trackingDataList', trackingFinalData);
        System.debug('-------------------------------- Here is out put '+JSON.serialize(outMap));
    } 
     List<Map<String, Object>> manageTracking(List<Map<String, Object>> trackingDataList, VlocityTrackingSetting__mdt trackingSetting){
        List<Map<String, Object>> trackingFinalData = new List<Map<String, Object>>();
        if(trackingSetting.Tracked_Element__c == 'Reporting'){
            for(Map<String, Object> trackingDataMapInst : trackingDataList){
                if(String.valueOf(trackingDataMapInst.get(TRACKING_EVENT)) == STEP_ACTION_TIME && trackingSettingMap.get(trackingSetting.Tracked_Element__c).contains(string.valueOf(trackingDataMapInst.get(ELEMENT_TYPE)))){
                    trackingFinalData.add(trackingDataMapInst);
                }
            }
            return trackingFinalData;
        }
        else if(trackingSetting.Tracked_Element__c == 'All'){
            return trackingDataList;
        }
        else{
            return null;
        }
    }	
}