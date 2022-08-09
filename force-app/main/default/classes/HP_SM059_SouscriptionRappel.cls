/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   06-04-2021   Antoine Latour   Initial Version
**/
public with sharing class HP_SM059_SouscriptionRappel {
    
    public static void createRappelCase(List<HP_Souscription__c> souscriptionList) {
        if(souscriptionList == null || souscriptionList.isEmpty()) return;
        
        List<Case> caseToCreate = new List<Case>();
        Id recordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case','HP_Telephone');
        
        for(HP_Souscription__c souscription : souscriptionList) {
            Case newCase = HP_EM010_Case.createRappelCaseForSouscription(recordTypeId, souscription.Id, souscription.HP_Contact__c);
            caseToCreate.add(newCase);
        }

        if(caseToCreate.size() > 0) Database.insert(caseToCreate);
    }

    public static void closeOdlCases(List<Case> casesList) {
        if(casesList == null || casesList.isEmpty()) return;

        Set<Id> casesIdSet = new Set<Id>();
        for(Case aCase : casesList) {
            casesIdSet.add(aCase.Id);
        }

        Map<Id, List<EmailMessage>> mapEmailMessage = HP_EM019_EmailMessage.loadEmailMessagesFromCase(casesIdSet);
        Map<Id, List<HP_AppelsSortants__c>> mapAppelsSortant = HP_EM049_AppelsSortants.loadAppelsSortantsFromCase(casesIdSet);

        if(mapEmailMessage == null && mapAppelsSortant == null) {
            HP_EM010_Case.cancelCases(casesList);
        }
        else {
            List<Case> casesToCancel = new List<Case>();
            List<Case> casesToClose = new List<Case>();

            for(Case aCase : casesList) {
                final Boolean hasEmailAction = !(mapEmailMessage == null) && mapEmailMessage.containsKey(aCase.Id);
                final Boolean hasAppelAction = !(mapAppelsSortant == null) && mapAppelsSortant.containsKey(aCase.Id);
                final Boolean hasAnyAction = hasEmailAction || hasAppelAction;

                if(hasAnyAction) {
                    casesToClose.add(aCase);
                }
                else {
                    casesToCancel.add(aCase);
                }
            }

            if(casesToCancel.size() > 0) HP_EM010_Case.cancelCases(casesToCancel);
            if(casesToClose.size() > 0) HP_EM010_Case.closeCases(casesToClose);
        }
    }
}