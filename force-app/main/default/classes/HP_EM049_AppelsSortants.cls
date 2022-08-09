/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   09-04-2021   Antoine Latour   Initial Version
**/

public inherited sharing class HP_EM049_AppelsSortants {
    
    /**
    * @description 
    * @author Antoine Latour | 09-04-2021 
    * @param Set<Id> casesIdSet 
    * @return Map<Id, List<HP_AppelsSortants__c>> 
    **/
    public static Map<Id, List<HP_AppelsSortants__c>> loadAppelsSortantsFromCase(Set<Id> casesIdSet) {
        List<HP_AppelsSortants__c> appelsSortantsList = [select Id, HP_CaseRappel__c From HP_AppelsSortants__c Where HP_CaseRappel__c in: casesIdSet];
        if(appelsSortantsList == null || appelsSortantsList.isEmpty()) return null;

        Map<Id, List<HP_AppelsSortants__c>> mapAppelsSortants = new Map<Id, List<HP_AppelsSortants__c>>();
        for(HP_AppelsSortants__c appelsSortant : appelsSortantsList) {
            List<HP_AppelsSortants__c> tempList = null;
            if(mapAppelsSortants.containsKey(appelsSortant.HP_CaseRappel__c)) {
                tempList = mapAppelsSortants.get(appelsSortant.HP_CaseRappel__c);
            }
            else {
                tempList = new List<HP_AppelsSortants__c>();
            }
            tempList.add(appelsSortant);
            mapAppelsSortants.put(appelsSortant.HP_CaseRappel__c, tempList);
        }

        return mapAppelsSortants;
    }
}