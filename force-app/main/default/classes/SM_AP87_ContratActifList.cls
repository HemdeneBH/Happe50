/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This class is to get error message label for delai paiement screen
*
*
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Marouane BEN ATIA   <marouane.benatia@engie.com>
* @modifiedBy     Marouane BEN ATIA   <marouane.benatia@engie.com>
* @maintainedBy   Marouane BEN ATIA   <marouane.benatia@engie.com>
* @version        1.0
* @created        2020-05-11
* @modified       2020-05-11
* @systemLayer    Service
* @see            ????
* @see            ????

*/
public class SM_AP87_ContratActifList {
    
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * to assign get if the contract is actif
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    contractCode  
    * @return   Boolean 
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    
    @AuraEnabled(cacheable=true)
    public static Boolean getContractActif(String contractCode){
        list<contratActif__mdt> findContract = [select contratActifCode__c from contratActif__mdt where contratActifCode__c =:contractCode];
        // String libelleErreur = listErrorDP[0].libelleErreur__c;
        Boolean ContractExist = false;
        if (findContract.size() > 0) {
            ContractExist = true;
        }
        return ContractExist;
    }

}