/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   20-01-2021   Antoine Latour   Initial Version
**/
@isTest
public class HP_BAT013_OmnichannelStopRoutage_TEST {
    
    @testSetup static void dataSetup(){
        
        List<Case> cases = new List<Case>();
        Id queueNiveau1Id = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'HP_Niveau_1'].Id;

        Case c1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_PrestationDistributeur', new Map<String, Object> {
            'Status' => 'NEW_CASE',
            'Priority' => 'High',
            'OwnerId' => UserInfo.getUserId(),
            'HP_TreatmentDate__c' => Date.today().addDays(-2),
            'Origin' => 'Contact distributeur'
            }, null,null,null);
        cases.add(c1);

        Case c2 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_PrestationDistributeur', new Map<String, Object> {
            'Status' => 'CLOSED',
            'Priority' => 'High',
            'OwnerId' => queueNiveau1Id,
            'HP_TreatmentDate__c' => Date.today().addDays(-2),
            'Origin' => 'Contact distributeur'
            }, null,null,null);
        cases.add(c2);

        Case c3 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_PrestationDistributeur', new Map<String, Object> {
            'Status' => 'CANCELED',
            'Priority' => 'High',
            'OwnerId' => queueNiveau1Id,
            'HP_TreatmentDate__c' => Date.today().addDays(-2),
            'Origin' => 'Contact distributeur'
            }, null,null,null);
        cases.add(c3);
           
        insert cases;
    }
    
    @isTest static void HP_BAT013_OmnichannelStopRoutage(){
        
        Test.startTest();
        HP_BAT013_OmnichannelStopRoutage.execute();
        Test.stopTest();        
    }
    
    
    @isTest static void HP_BAT013_OmnichannelStopRoutageDiff1(){
        
        Test.startTest();
        HP_BAT013_OmnichannelStopRoutage batchToExec = new HP_BAT013_OmnichannelStopRoutage();
        String chron = '0 0 23 * * ?';        
        String jobid = System.schedule('testBAT013', chron, batchToExec);
        Test.stopTest();        
    }
    
     @isTest static void HP_BAT013_OmnichannelStopRoutageDiff2(){
        String cronExp = '0 0 23 * * ?';        
        String jobName = 'testBAT013';
         
        Test.startTest();
     	HP_BAT013_OmnichannelStopRoutage.launchNewScheduler(cronExp, jobName);
		Test.stopTest();
     }
}