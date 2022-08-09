/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 


 * @last modified on  : 09-16-2020


 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   08-31-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class HP_CaseHandler extends TriggerHandler {
    private List<Case> newList;
    private String rtReclamationId;
    private String rtResiliationId;
    private String rtPrestationId;

    private Map<Id,Case> newMap;
    private Map<Id,Case> oldMap;
    public HP_CaseHandler() {
        this.newList = (List<Case>) Trigger.New;
        this.newMap = (Map<Id,Case>) Trigger.newMap;
        this.oldMap = (Map<Id,Case>) Trigger.oldMap;
        rtReclamationId = HP_UTIL_RecordType.getRecordTypeId('Case','HP_Mediation_Reclamation');
        rtResiliationId = HP_UTIL_RecordType.getRecordTypeId('Case','HP_ContractCancelationCase');
        rtPrestationId = HP_UTIL_RecordType.getRecordTypeId('Case','HP_PrestationDistributeur');

    }

    public override void afterUpdate(){
        List<Case> caseList = new List<Case>();
        for(Case cas : newList){
            if(cas.RecordtypeId == rtReclamationId && cas.IsClosed == true && oldMap.get(cas.Id).isClosed == false) {
                 caseList.add(cas);
            }
        }
        Set<String> caseIdList = new Set<String>();
        Set<String> contactIdList = new Set<String>();
        for(Case cas : caseList) {
            caseIdList.add(cas.id);
            contactIdList.add(cas.contactId);
        }


        if(caseIdList.size() > 0 && !System.isBatch())


            HP_EM035_Reclamation.notifyAgilabReclamation(caseIdList, contactIdList, '0');
    }

    public override void afterInsert() {
       List<Case> caseList = new List<Case>();
       for(Case cas : newList){
           if(cas.RecordtypeId == rtReclamationId && cas.IsClosed == false) {
                caseList.add(cas);
           }
       }
       Set<String> caseIdList = new Set<String>();
       Set<String> contactIdList = new Set<String>();
       for(Case cas : caseList) {
           caseIdList.add(cas.id);
           contactIdList.add(cas.contactId);
       }


       if(caseIdList.size() > 0 && !System.isBatch())


             HP_EM035_Reclamation.notifyAgilabReclamation(caseIdList, contactIdList, '1');
    }

    public override void beforeInsert() {
        Map<String, Case> souscriptionCaseMap = new Map<String, Case>();
        for(Case acase : newList) {
            if(acase.HP_Souscription__c != null && 
            (acase.RecordtypeId == rtPrestationId || acase.RecordtypeId == rtResiliationId)) {
                souscriptionCaseMap.put(acase.HP_Souscription__c, acase);
            }
        }
        if(souscriptionCaseMap.size() > 0) {
            List<HP_Souscription__c> sousList = [select Id,
            (select Id, HP_Contrat_XdataId__c,HP_Type_de_Compteur__c, HP_Proposition_Commerciale_XdataId__c from HP_Contrats__r)
            from HP_Souscription__c where Id in :souscriptionCaseMap.keySet()];

            for(HP_Souscription__c sous : sousList) {
                Case acase = souscriptionCaseMap.get(sous.Id);
                if(acase == null) {
                    continue;
                }
                    for(HP_Contrat__c cont : sous.HP_Contrats__r) {
                        if((cont.HP_Type_de_Compteur__c == 'GAS' && acase.HP_Energy__c == 'Gas')
                        || (cont.HP_Type_de_Compteur__c == 'ELEC' && acase.HP_Energy__c == 'Electricity')) {
                            if(acase.HP_Contrat__c == null) {
                            acase.HP_Contrat__c = cont.Id;
                            }
                            if(acase.HP_TECH_ExternalId__c == null && acase.RecordtypeId == rtResiliationId) {
                                acase.HP_TECH_ExternalId__c = 'CONTRACT_CANCELATION/' + cont.HP_Contrat_XdataId__c;
                            }
                            if(acase.HP_TECH_ExternalId__c == null && acase.RecordtypeId == rtPrestationId) {
                                acase.HP_TECH_ExternalId__c = cont.HP_Proposition_Commerciale_XdataId__c+'PrestationDistributeur' + cont.HP_Type_de_Compteur__c;
                            }
                        
                    }
                }
            }
            
        }
        
    }
}