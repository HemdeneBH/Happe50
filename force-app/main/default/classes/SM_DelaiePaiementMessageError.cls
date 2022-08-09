/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This class is to get error message label for delai paiement screen
*
*
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Joel NENKAM   <guy-joel.nenkamtamdem@external.engie.com>
* @modifiedBy     Joel NENKAM   <guy-joel.nenkamtamdem@external.engie.com>
* @maintainedBy   Joel NENKAM   <guy-joel.nenkamtamdem@external.engie.com>
* @version        1.0
* @created        2020-04-02
* @modified       2020-04-02
* @systemLayer    Service
* @see            ????
* @see            ????
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* vX.X            Vivek_Chawla@Intuit.com
* YYYY-MM-DD      Explanation of the change.  Multiple lines can be used to explain the change, but
*                 each line should be indented till left aligned with the previous description text.
*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public class SM_DelaiePaiementMessageError {
    
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * to assign get the label of the error message
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    errorCode  
    * @return   String 
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    
    @AuraEnabled(cacheable=true)
    public static String getErrorMessage(String errorCode){
        list<SM_DelaiPaiement_ErrorMessage__mdt> listErrorDP = [select libelleErreur__c from SM_DelaiPaiement_ErrorMessage__mdt where CodeErreur__c =:errorCode];
        String libelleErreur = listErrorDP[0].libelleErreur__c;
        return libelleErreur;
    }

}