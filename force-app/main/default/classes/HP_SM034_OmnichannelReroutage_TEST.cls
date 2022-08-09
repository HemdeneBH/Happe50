/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   20-01-2021   Antoine Latour   Initial Version
**/
@isTest
public class HP_SM034_OmnichannelReroutage_TEST {
    
    @testSetup static void dataSetup(){
        
        List<Case> cases = new List<Case>();
        
        Case c1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_PrestationDistributeur', new Map<String, Object> {
            'Status' => 'NEW_CASE',
            'Priority' => 'High',
            'Origin' => 'Contact distributeur'
            }, null,null,null);
        cases.add(c1);
        
        insert cases;
    }
    
    @isTest static void HP_SM034_OmnichannelReroutage(){
        
        List<Case> cases = [SELECT Id FROM Case];
        List<String> casesId = new List<String>(); 
        for(Case c : cases){
            casesId.add(c.Id);
        }
        Test.startTest();
        HP_SM034_OmnichannelReroutage.rerouteDeclinedCases(casesId);
        Test.stopTest();        
    }
}