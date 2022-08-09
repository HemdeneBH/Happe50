/*
* @Author: Amine Deghais ~ amine.deghais@external.engie.com
* @Date: 11/03/2020
* @Description: test Class: tracking de l'OS
*/
@isTest
private class VlocityTrackingDataTest {
    @isTest static void invokeMethod(){
    Test.startTest(); 
        VlocityTrackingData vlTrData=new VlocityTrackingData();
        String methodName='processTracking';
        List<Map<String, Object>> trackingDataMapInst=new List<Map<String, Object>>();
        Map<String, Object> TrackingEvent=new  Map<String, Object>();
        TrackingEvent.put('TrackingEvent','StepActionTime');
        trackingDataMapInst.add(TrackingEvent);
        Map<String,Object> inputMap=new Map<String,Object>();
        inputMap.put('trackingDataList', trackingDataMapInst);
        Map<String,Object> outMap=new Map<String,Object>();            
        vlTrData.invokeMethod(methodName, inputMap, outMap, null);
    Test.stopTest();        
    }
}