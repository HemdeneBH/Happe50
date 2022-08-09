/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   10-05-2021   Antoine Latour   Initial Version
**/
@isTest
public class HP_BAT021_CaseOwnerHistory_TEST {

    @testSetup static void dataSetup(){
        
        List<Case> cases = new List<Case>();
        
        Case c1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_PrestationDistributeur', new Map<String, Object> {
            'Status' => 'NEW_CASE',
            'Priority' => 'High',
            'OwnerId' => UserInfo.getUserId(),
            'HP_TreatmentDate__c' => Date.today().addDays(-2),
            'Origin' => 'Contact distributeur'
            }, null,null,null);
        cases.add(c1);
           
        insert cases;
    }
    
    @isTest static void HP_BAT021_CaseOwnerHistory(){
        
        Test.startTest();
        HP_BAT021_CaseOwnerHistory.execute();
        Test.stopTest();        
    }

    @isTest static void HP_BAT021_CaseOwnerHistory_Schedule() {
        Test.startTest();
        final String jobName = 'HP_BAT021_CaseOwnerHistory';
        final String cronExp = '0 0 4 ? * * *';
        HP_BAT021_CaseOwnerHistory.launchNewScheduler(cronExp,jobName);
        Test.stopTest();
    }
}