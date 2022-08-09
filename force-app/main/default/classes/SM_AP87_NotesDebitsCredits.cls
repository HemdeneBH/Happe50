/**
 * @author Unknown
 * @date 11/04/2022 - Refactoring by Sutharsan Pushparajah
 * @description SM_AP87_NotesDebitsCredits - Controller class to access the NotesDebitsCredits API
 */
public with sharing class SM_AP87_NotesDebitsCredits {

    /**
     * @author joel
     * @date 26/05/2020
     * @param idPortefeuilleContrat Id of the client contract
     * @description appel de l'api note-debit-credit
     * @return SM_wrapperNoteDebitCredit response from WS call into a wrapper class
     */
    @AuraEnabled(cacheable=false)
    public static SM_wrapperNoteDebitCredit getNotesDebitsCredits(String idPortefeuilleContrat) {
        return SM_WS103_NotesDebitsCredits.getNotesDebitsCredits(idPortefeuilleContrat);
    }

    /**
     * @author Uknown
     * @date DD/MM/YYYY
     * @param idsfcontact Salesforce Id of the client on Contact record
     * @description appel de l'api note-debit-credit
     * @return SM_wrapperNoteDebitCredit response from WS call into a wrapper class
     */
    @AuraEnabled(cacheable=true)
    public static SM_wrapperNoteDebitCredit getNotesDebitsCreditsByIdsf(String idsfcontact) {
        Contact contact = SM_EM100_Contact.getByIds('Id, ID_Tiers__c', new List<Id>{idsfcontact}).get(0);
        return getNotesDebitsCredits(string.valueof(contact.ID_Tiers__c));
    }
}