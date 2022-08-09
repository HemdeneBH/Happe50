/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 11-19-2020
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   11-19-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest 
global  class HP_BAT012_UserProductivity_TEST {
    
    @isTest static void launchNewScheduler_TEST(){
        
        Case c1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_PrestationDistributeur', new Map<String, Object> {
            'Status' => 'NEW_CASE',
                'Priority' => 'High',
                'Origin' => 'Télévente Happe COMDATA'
                }, null,null,null);
        insert c1;
        
        Case cas = [select Id from Case limit 1 ];
        
        HP_CaseHistory__c caseHistory = (HP_CaseHistory__c) HP_UTIL_SmartFactory.createSObject('HP_CaseHistory__c', new Map<String, Object> {
            'Case__c'  => cas.Id,
                'HP_dateAttribution__c'=>  Datetime.now() ,
                'HP_type__c' =>'DMT',
                'HP_DureeTraitement__c' => 10,
                'user__c' => UserInfo.getUserId()}, null);
        insert caseHistory;
        
        final String jobName = 'HP_BAT012_UserProductivityTest1';
        final String cronExp = '0 0 23 ? * * *';
        Test.startTest();
        HP_BAT012_UserProductivity.launchNewScheduler(cronExp,jobName);
        Test.stopTest();   
        
    }
    
    @isTest static void launch2_TEST(){
        
        Case c1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_PrestationDistributeur', new Map<String, Object> {
            'Status' => 'NEW_CASE',
                'Priority' => 'High',
                'Origin' => 'Télévente Happe COMDATA'
                }, null,null,null);
        insert c1;
        
        HP_CaseHistory__c caseHistory = (HP_CaseHistory__c) HP_UTIL_SmartFactory.createSObject('HP_CaseHistory__c', new Map<String, Object> {
            'Case__c'  => c1.Id,
                'HP_dateAttribution__c'=>  Datetime.newInstance(2020, 10, 04, 0, 0, 0),
                'HP_DateChangementStatut__c'  =>  Datetime.now(),
                'HP_DureeTraitement__c' => 10,
                'HP_type__c' =>'DMT',
                'user__c' => UserInfo.getUserId()}, null);
        insert caseHistory;
        
        final String jobName = 'HP_BAT012_UserProductivityTest2';
        final String cronExp = '0 0 23 ? * * *';
        Test.startTest();
        HP_BAT012_UserProductivity.launchNewScheduler(cronExp,jobName);
        Test.stopTest();   
        
    }
    
    
    @isTest static void getMinutes_TEST(){
        
        
        Time start = DateTime.newInstance(2019, 10, 9, 13, 0, 0).time();
        Time endTime = DateTime.newInstance(2019, 10, 9, 14, 0, 0).time();
        Test.startTest();
        HP_SM043_UserProductivity.getMinutes(start, endTime);
        Test.stopTest(); 
        
    }
    
    @isTest static void getDayStartEndTime_TEST(){
        
        BusinessHours bh = [SELECT Id,  SundayStartTime, SundayEndTime, MondayStartTime,MondayEndTime , TuesdayStartTime, TuesdayEndTime, WednesdayStartTime, WednesdayEndTime, ThursdayStartTime, ThursdayEndTime, FridayStartTime, FridayEndTime, SaturdayStartTime, SaturdayEndTime FROM BusinessHours WHERE name ='HP' limit 1];
        List<String> days= new List<String>{'Sun', 'Mon','Tue','Wed','Thu','Fri','Sat'};
            Test.startTest();
        for(Integer i=0;i<days.size();i++){
            HP_SM043_UserProductivity.getDayStartEndTime(days[i], true, bh);
        }
        for(Integer i=0;i<days.size();i++){
            HP_SM043_UserProductivity.getDayStartEndTime(days[i], false, bh);
        }
        Test.stopTest(); 
        
        
    }
    
}