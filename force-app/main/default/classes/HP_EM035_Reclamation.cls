/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 

 * @last modified on  : 08-31-2020

 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   08-31-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class HP_EM035_Reclamation {
    
    @future(callout = true)
    public static void notifyAgilabReclamation(Set<String> caseIdList, Set<String> contactIdList, String status) {
        if(caseIdList.size() == 0) {
            return;
        }
        
        List<aggregateresult> caseAggregate = [select count(id), ContactId from case 
        where (HP_Type__c = 'HP_Reclamation' or HP_Type__c = 'HP_Mediation') and recordtype.developerName = 'HP_Mediation_Reclamation' and id Not in :caseIdList and ContactId in :contactIdList

        and isClosed = false and contact.Id_Tiers__c != null

        group by contactId
        Having count(Id) > 0];

        System.debug('@@ caseAggregate ' + caseAggregate);
        Set<String> contactEnR = new Set<String>();
        for(aggregateresult agr : caseAggregate) {
            contactEnR.add((String) agr.get('ContactId'));
        }

        Map<ID, Contact> contactMap = new Map<ID, Contact>([SELECT Id, Id_Tiers__c FROM Contact where Id in :contactIdList]);
        System.debug('@@ contactMap ' + contactMap);
        for(String idC : contactIdList) {
            if(contactEnR.contains(idC)) {
                continue;
            }
            Map<String, String> parameters = new Map<String, String>();
            parameters.put('id_client_xdata', String.valueOf(contactMap.get(idC).Id_Tiers__c));
            parameters.put('status', status);
            HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.AGILAB_RECLAMATION_NOTIFIER, parameters);
        }
    }


    @AuraEnabled(Cacheable = true)
	public static List<Case> loadReclamationCase(String contactId) {
		return HP_EM010_Case.loadReclamationCase(contactId);
	}

}