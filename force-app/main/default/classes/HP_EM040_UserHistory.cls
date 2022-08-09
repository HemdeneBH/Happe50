public with sharing  class HP_EM040_UserHistory {

    public static HP_UserHistory__c createUserHistory(String userId, Integer numberOfTreatments, Decimal somme, Decimal dureeTraitement, Date selectedDate) {
        HP_UserHistory__c userHistory = new HP_UserHistory__c();
               
        userHistory.User__c =userId;
        userHistory.HP_Date__c = selectedDate;
        userHistory.HP_NombreTraitements__c	 = numberOfTreatments;
        userHistory.HP_TempsPresence__c = somme;
        userHistory.HP_DureeTraitement__c = dureeTraitement;
        
        return userHistory; 
    }

    public static void saveUserHistoryList(List<HP_UserHistory__c> userHistoryList) {
        if(userHistoryList != null && userHistoryList.size() > 0) {
            insert userHistoryList;
        }
    }
}