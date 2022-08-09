public with sharing class ContactHandler {
    /*
    *   @description Vérifie l'existence d'un contact dans Salesforce selon un filtre
    *   @params field : le champ sur lequel on souhaite filtrer
    *   @params value : la valeur du champ qu'on recherche
    *   @return L'ID de l'enregistrement retrouvé
    */
    public static Id doesContactExist(String field, String value){
        System.debug('*** IN doesContactExist with field = ' + field + ' / value = ' + value);

        String cleanField = String.escapeSingleQuotes(field);
        String cleanValue = String.escapeSingleQuotes(value);
        String query = 'SELECT Id FROM Contact WHERE ' + cleanField + '=:cleanValue WITH SECURITY_ENFORCED ORDER BY LastModifiedDate DESC';


        System.debug('*** Query : ' + query);
        
        List<Contact> contacts = Database.query(query);
        
        String contactId;

        if(contacts.size() == 1){
            contactId = contacts[0].Id;
        }

        System.debug('*** OUT doesContactExist with contactId = ' + contactId);
        return contactId;
    }

    public static Id doesContactExistByEmail(String email){
        System.debug('*** IN doesContactExist with email = ' + email);
        List<Contact> contacts = [SELECT Id FROM Contact WHERE Email =: email OR Adresse_Mail_2__c =: email OR Adresse_Mail_3__c =: email WITH SECURITY_ENFORCED];
        
        String contactId;

        if(contacts.size() == 1){
            contactId = contacts[0].Id;
        }
        
        System.debug('*** OUT doesContactExistByEmail with contactId = ' + contactId);
        return contactId;
    }

    public static Id doesContactExistByPhone(String phone){
        System.debug('*** IN doesContactExistByPhone with phone = ' + phone);
        List<Contact> contacts = [SELECT Id FROM Contact WHERE Phone =: phone OR Tel_Fixe_2__c =: phone OR Tel_Fixe_3__c =: phone OR MobilePhone =: phone OR Mobile_2__c =: phone OR Mobile_3__c =: phone WITH SECURITY_ENFORCED];
        
        String contactId;

        if(contacts.size() == 1){
            contactId = contacts[0].Id;
        }
        
        System.debug('*** OUT doesContactExistByPhone with contactId = ' + contactId);
        return contactId;
    }
}