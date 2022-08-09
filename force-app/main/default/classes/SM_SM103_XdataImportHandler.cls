/**
 * @author Sutharsan Pushparajah
 * @date 24/06/2022
 * @description SM_SM103_XdataImportHandler - Handle creation of Account/contact/role from external XDATA when using composite API
 */
public inherited sharing class SM_SM103_XdataImportHandler {

    private static final String EN_XDATA_IMPORT_PERMISSION = 'EN_XDATA_IMPORT_V3';
    private static final Id ACCOUNT_RT_CONSUMER_ID = SM_EM101_Account.RT_ID_CONSUMER;
    private static final Id CONTACT_RT_CONSUMER_ID = SM_EM100_Contact.RT_ID_CONTACT_SMILE;
    private static final String TECHNICAL_ACCOUNT_NAME = SM_EM101_Account.TECHNICAL_NAME;
    private static final String TECHNICAL_CONTACT_NAME = SM_EM100_Contact.TECHNICAL_NAME;
    private static final Boolean XDATA_SYNC_ENABLED = FeatureManagement.checkPermission(EN_XDATA_IMPORT_PERMISSION);
    
    /**
     * @author Sutharsan Pushparajah
     * @date 24/06/2022
     * @description Check mandatory fields are set
     * @param accountList List of account records to check
     * @return N/A
     */
    public static void validateAccountBeforeInsert(List<Account> accountList){
        if (!XDATA_SYNC_ENABLED) {
            return;
        }
        
        for (Account acc : accountList){
            validateAccount(null, acc);
        }
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 24/06/2022
     * @description Check mandatory fields are set
     * @param accountList List of account records to check
     * @return N/A
     */
    public static void validateAccountBeforeUpdate(Map<Id, Account> oldAccountMap, Map<Id, Account> newAccountMap){
        if (!XDATA_SYNC_ENABLED) {
            return;
        }
        
        for (Id accId : newAccountMap.keySet()){
            Account oldAcc = oldAccountMap.get(accId);
            Account newAcc = newAccountMap.get(accId);
            
            validateAccount(oldAcc, newAcc);
        }
    }
        
    /**
     * @author Sutharsan Pushparajah
     * @date 24/06/2022
     * @description Check mandatory fields are set
     * @param oldAcc account record containing old values
     * @param newAcc account record containing new values
     * @return N/A
     */
    @testVisible
    private static void validateAccount(Account oldAcc, Account newAcc){

        if (String.isEmpty(newAcc.Name)){
            if (oldAcc != null && !String.isEmpty(oldAcc.Name)){
                newAcc.Name = oldAcc.Name;
            } else {
                newAcc.Name = TECHNICAL_ACCOUNT_NAME;
            }
        }
        
        if (String.isEmpty(newAcc.RecordTypeId)){
            if (oldAcc != null && !String.isEmpty(oldAcc.RecordTypeId)){
                newAcc.RecordTypeId = oldAcc.RecordTypeId;
            } else {
                newAcc.RecordTypeId = ACCOUNT_RT_CONSUMER_ID;
            }
        }
        
        if (String.isEmpty(newAcc.No_Compte_contrat__c)){
            newAcc.addError('No_Compte_contrat__c is mandatory');
            return;
        }
        
        if (newAcc.ID_Local__c != null && newAcc.ID_Local__c == 0){
            newAcc.addError('ID_Local__c must be different from 0');
            return;
        } 
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 24/06/2022
     * @description Check mandatory fields are set
     * @param contactList List of contact records to check
     * @return N/A
     */
    public static void validateContactBeforeInsert(List<Contact> contactList){
        if (!XDATA_SYNC_ENABLED) {
            return;
        }
        
        for (Contact ct : contactList){
            validateContact(null, ct);
        }
    }
    
    /**
     * @author Sutharsan Pushparajah
     * @date 24/06/2022
     * @description Check mandatory fields are set
     * @param oldContactMap Map of 1 contact record containing old values
     * @param newContactMap Map of 1 contact record containing new values
     * @return N/A
     */
    public static void validateContactBeforeUpdate(Map<Id, Contact> oldContactMap, Map<Id, Contact> newContactMap){
        if (!XDATA_SYNC_ENABLED) {
            return;
        }
        
        for (Id ctId : newContactMap.keySet()){
            Contact oldCt = oldContactMap.get(ctId);
            Contact newCt = newContactMap.get(ctId);
            
            validateContact(oldCt, newCt);
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 24/06/2022
     * @description Check mandatory fields are set
     * @param oldCt 1 contact record containing old values
     * @param newCt 1 contact record containing new values
     * @return N/A
     */
    @testVisible
    private static void validateContact(Contact oldCt, Contact newCt){

        if (String.isEmpty(newCt.LastName)){
            if (oldCt != null && !String.isEmpty(oldCt.LastName)){
                newCt.lastName = oldCt.LastName;
            } else {
                newCt.LastName = TECHNICAL_CONTACT_NAME;
            }
        }
        
        if (String.isEmpty(newCt.RecordTypeId)){
            if (oldCt != null && !String.isEmpty(oldCt.RecordTypeId)){
                newCt.RecordTypeId = oldCt.RecordTypeId;
            } else {
                newCt.RecordTypeId = CONTACT_RT_CONSUMER_ID;
            }
        }
        
        if (!SM_APU100_StringUtils.emailAddressIsValid(newCt.Email)){
            newCt.addError('Email address is not valid : '+newCt.Email);
            return;
        }
        
        if (!SM_APU100_StringUtils.emailAddressIsValid(newCt.Adresse_Mail_2__c)){
            newCt.addError('Adresse_Mail_2__c address is not valid : '+newCt.Adresse_Mail_2__c);
            return;
        }
        
        if (!SM_APU100_StringUtils.emailAddressIsValid(newCt.Adresse_Mail_3__c)){
            newCt.addError('Adresse_Mail_3__c address is not valid : '+newCt.Adresse_Mail_3__c);
            return;
        }
        
        if (!SM_APU100_StringUtils.emailAddressIsValid(newCt.Adresse_Mail_de_l_espace_client__c)){
            newCt.addError('Adresse_Mail_de_l_espace_client__c address is not valid : '+newCt.Adresse_Mail_de_l_espace_client__c);
            return;
        }
    }
}