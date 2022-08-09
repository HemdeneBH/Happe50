/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   18-11-2020   Antoine Latour   Initial Version
**/
@isTest
public class HP_BAT010_OmnichannelAujourdhui_TEST {
    
    @testSetup static void dataSetup(){
        
        Id queueNiveau1Id = HP_Util_QueueManager.getQueueIdByName('HP_Niveau_1');
        List<Case> cases = new List<Case>();
        
        Case c1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_PrestationDistributeur', new Map<String, Object> {
            'Status' => 'NEW_CASE',
            'Priority' => 'High',
            'OwnerId' => queueNiveau1Id,
            'HP_TreatmentDate__c' => Date.today().addDays(-2),
            'Origin' => 'Contact distributeur'
            }, null,null,null);
        cases.add(c1);
           
        insert cases;
    }
    
    @isTest static void HP_BAT010_OmnichannelAujourdhui(){
        
        Test.startTest();
        HP_BAT010_OmnichannelAujourdhui.execute();
        Test.stopTest();        
    }
}