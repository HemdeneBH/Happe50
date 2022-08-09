/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-18-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   08-31-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing  class HP_EM036_CaseHistory {
    
 
    public static List<HP_CaseHistory__c> getCaseHistory(String caseOwner, String caseId) {
        return [select Id, Case__c, HP_dateAttribution__c, HP_type__c, user__c from HP_caseHistory__c where case__c =:caseId and User__c =:caseOwner];   
    }

    public static HP_CaseHistory__c creatCaseHistory(Case cas, AgentWork agentWork,Boolean isCase){
        HP_CaseHistory__c caseHistory = new HP_CaseHistory__c();
        caseHistory.Case__c = isCase ? cas.Id : agentWork.WorkItemId;
        caseHistory.HP_DateAttribution__c = DateTime.now();

        caseHistory.User__c = isCase ?  cas.OwnerId : agentWork.UserId;
        return caseHistory;
    }





    public static List<HP_CaseHistory__c> getCaseHistoryByListCase(String caseOwner, List<String> casesId) {
        return [select Id, Case__c, HP_dateAttribution__c, HP_DateChangementStatut__c, HP_type__c, user__c from HP_caseHistory__c where case__c  IN :casesId and User__c =:caseOwner];   
    }

    public static List<HP_CaseHistory__c> getCaseHistoryByListCaseAndUser(String caseOwner, Set<String> casesId) {
        return [select Id, Case__c, HP_dateAttribution__c, HP_DateChangementStatut__c, HP_type__c, user__c from HP_caseHistory__c where (case__c  IN :casesId and User__c =:caseOwner) order by HP_DateAttribution__c desc limit 1];   
    }


    public static List<HP_CaseHistory__c> getCaseHistoryByUsers(List<Id> users, Date batchDate){
        return [ select Id ,Case__c, HP_DateAttribution__c, HP_DateChangementStatut__c, HP_ChangementStatutAncien__c, HP_ChangementStatutNouveau__c,HP_DureeTraitement__c, User__c, User__r.name from HP_CaseHistory__c where( (  DAY_ONLY(HP_DateAttribution__c) =:batchDate  or DAY_ONLY(HP_DateChangementStatut__c) =: batchDate)  and  User__c IN :users) ];
    }


    public static List<CaseHistory> getCaseHistoryByCasesIds(Set<Id> casesIds) {
        return [SELECT Id, CaseId, CreatedDate, Field, NewValue, OldValue FROM CaseHistory WHERE CaseId in : casesIds ORDER BY CreatedDate ASC];
    }



}