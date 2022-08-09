@isTest
public with sharing  class HP_EM040_UserHistory_TEST {

    @isTest
    public static void createUserHistory() {
    
        Test.startTest();
        HP_UserHistory__c result = HP_EM040_UserHistory.createUserHistory(UserInfo.getUserId(), 1, 1.0, 1.0, Date.newInstance(2020, 12, 12));
        Test.stopTest();

        System.assert(result != null, 'Result is null');
        System.assert(result.User__c == UserInfo.getUserId(), 'UserId is wrong');
    }

    @isTest
    public static void saveUserHistoryList() {
        List<HP_UserHistory__c> userHistoryList = new List<HP_UserHistory__c>();
        Test.startTest();
        HP_UserHistory__c result = HP_EM040_UserHistory.createUserHistory(UserInfo.getUserId(), 1, 1.0, 1.0, Date.newInstance(2020, 12, 12));
        userHistoryList.add(result);
        HP_EM040_UserHistory.saveUserHistoryList(userHistoryList);
        Test.stopTest();

        List<HP_UserHistory__c> resultList = [Select Id From HP_UserHistory__c]; 
        System.assert(resultList.size() == 1, 'Erreur insertion liste');

    }
}