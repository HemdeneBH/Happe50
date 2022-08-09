public with sharing class HP_SM051_IBANViewHistory {
    @AuraEnabled
    public static void insertCaseHistoryView(String iban, String souscriptionId, String contactId){
        String userId = UserInfo.getUserId();
        if(HP_EM045_IBANViewHistory.ibanHistoryInLastHour(iban, souscriptionId, contactId)) {
            HP_EM045_IBANViewHistory.insertibanViewHistory(iban, souscriptionId, contactId);
        }
    }
}