public with sharing class HP_EM044_CaseViewHistory {
    public static Boolean caseHistoryInLastHour(String caseId) {
        DateTime dt = System.now().addHours(-1);
        String userId = UserInfo.getUserId();
        List<HP_CaseViewHistory__c> caseList = [select id from HP_CaseViewHistory__c 
        where HP_Case__c = :caseId and CreatedById = :userId and createdDate > :dt];

        return caseList.size() < 1;
    }

    public static void insertCaseViewHistory(String caseId) {
        HP_CaseViewHistory__c ch = new HP_CaseViewHistory__c(HP_Case__c = caseId);
        
        insert ch;
    }
}