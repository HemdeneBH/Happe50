public with sharing class HP_EM045_IBANViewHistory {
    public static Boolean ibanHistoryInLastHour(String iban, String souscriptionId, String contactId) {
        DateTime dt = System.now().addHours(-1);
        String userId = UserInfo.getUserId();

        String query ='select id from HP_ViewHistoryIBAN__c where CreatedById = :userId and createdDate > :dt and Name = :iban';
        
        if(souscriptionId != null) {
            query += ' and HP_Souscription__c = :souscriptionId';
        }

        if(contactId != null) {
            query += ' and HP_Contact__c = :contactId';
        }

        List<HP_ViewHistoryIBAN__c> ibanList = Database.query(query);

        return ibanList.size() < 1;
    }

    public static void insertibanViewHistory(String iban, String souscriptionId, String contactId) {
        HP_ViewHistoryIBAN__c ch = new HP_ViewHistoryIBAN__c(Name = iban);
        
        if(souscriptionId != null) {
            ch.HP_Souscription__c = souscriptionId;
        }

        if(contactId != null) {
            ch.HP_Contact__c = contactId;
        }

        insert ch;
    }
}