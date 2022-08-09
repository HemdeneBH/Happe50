/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   06-05-2021   Antoine Latour   Initial Version
**/

public inherited sharing class HP_EM050_HPCaseOwner {
    
    
    /**
    * @description 
    * @author Antoine Latour | 06-05-2021 
    * @param Set<Id> casesId 
    * @return Map<Id, List<HP_CaseOwner__c>> 
    **/
    public static Map<Id, List<HP_CaseOwner__c>> getCaseOwnerMap(Set<Id> casesId) {
        Map<Id, List<HP_CaseOwner__c>> result = new Map<Id, List<HP_CaseOwner__c>>();
        List<HP_CaseOwner__c> caseOwnerList = [SELECT ProfileName__c, Case__c, HP_ElapsedTime__c, HP_LastAssignment__c, HP_ActualOwner__c FROM HP_CaseOwner__c WHERE Case__c in : casesId];
        for(HP_CaseOwner__c co : caseOwnerList) {
            List<HP_CaseOwner__c> tempList;
            if(result.containsKey(co.Case__c)) {
                tempList = result.get(co.Case__c);
            }
            else {
                tempList = new List<HP_CaseOwner__c>();
            }
            tempList.add(co);
            result.put(co.Case__c, tempList);
        }

        return result;
    }
}