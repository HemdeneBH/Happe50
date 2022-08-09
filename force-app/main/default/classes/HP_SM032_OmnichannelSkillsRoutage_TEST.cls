/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   18-11-2020   Antoine Latour   Initial Version
**/
@isTest
public class HP_SM032_OmnichannelSkillsRoutage_TEST {
    
    @testSetup static void dataSetup(){
        List<String> queueDeveloperName = new List<String> {'HP_Niveau_1','HP_Niveau_2', 'HP_Niveau_3'};
        Map<String, Group> queuesMap = HP_Util_QueueManager.getQueueMapByName();

        List<Case> caseList = new List<Case>();

        Case c1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_PrestationDistributeur', new Map<String, Object> {
            'Status' => 'NEW_CASE',

            'Priority' => 'Low',
            'Origin' => 'Contact distributeur',

            'HP_Type__c' => 'HP_MANUAL_PROCESS',

            'OwnerId' => queuesMap.get(queueDeveloperName.get(0)).Id
            }, null,null,null);
        caseList.add(c1);

        Case c2 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_PrestationDistributeur', new Map<String, Object> {
            'Status' => 'NEW_CASE',

            'Priority' => 'Low',
            'Origin' => 'Contact distributeur',

            'HP_Type__c' => 'HP_MANUAL_PROCESS',

            'OwnerId' => queuesMap.get(queueDeveloperName.get(1)).Id
            }, null,null,null);
        caseList.add(c2);

        Case c3 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_PrestationDistributeur', new Map<String, Object> {
            'Status' => 'NEW_CASE',

            'Priority' => 'Low',
            'Origin' => 'Contact distributeur',

            'HP_Type__c' => 'HP_MANUAL_PROCESS',

            'OwnerId' => queuesMap.get(queueDeveloperName.get(2)).Id
            }, null,null,null);
        caseList.add(c3);
       
        insert caseList;
    }
    
    @isTest static void HP_SM032_OmnichannelSkillsRoutage(){
        
        List<Case> cases = [SELECT Id, Priority FROM Case];
        List<String> casesId = new List<String>(); 
        for(Case c : cases){
            casesId.add(c.Id);
        }
        Test.startTest();
        HP_SM032_OmnichannelSkillsRoutage.routeUsingSkills(casesId);
        Test.stopTest();        
        
       	cases = [SELECT Id, Priority FROM Case];
        for(Case c : cases) {
            System.assert(c.Priority == 'Medium');
        }
    }
}