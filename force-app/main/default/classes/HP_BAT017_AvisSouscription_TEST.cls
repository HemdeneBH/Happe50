/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-15-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   02-10-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest 
public with sharing class HP_BAT017_AvisSouscription_TEST {
    
    @IsTest
    static void getAvis(){
     
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
		
                'AWS/WEBSITE_AP' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                      'HP_AVIS_MOCK',
                                                      new Map<String, String> { 'Content-Type' => 'application/json'})
            };
    
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
            final String jobName = 'HP_BAT017_AvisSouscription';
            final String cronExp = '0 0 4 ? * * *';
            HP_BAT017_AvisSouscription.launchNewScheduler(cronExp,jobName);
            Test.stopTest();
        
    }
    
}