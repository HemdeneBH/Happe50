public with sharing class HP_SM049_CaseViewHistory {
    
    @AuraEnabled
    public static void insertCaseHistoryView(String caseId){
        String userId = UserInfo.getUserId();
        if(HP_EM044_CaseViewHistory.caseHistoryInLastHour(caseId)) {
            HP_EM044_CaseViewHistory.insertCaseViewHistory(caseId);
        }
    }
}