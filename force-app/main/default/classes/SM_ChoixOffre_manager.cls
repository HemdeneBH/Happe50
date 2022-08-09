/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* this class is to handle the deactivation of choix offre when a new one is created
*
*
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Joel NENKAM   <guy-joel.nenkamtamdem@external.engie.com>
* @modifiedBy     Zouhair BOUKHRISS   
* @maintainedBy   Zouhair BOUKHRISS   
* @version        2.0
* @created        2020-04-17
* @modified       2022-03-03
* @systemLayer    Service
* @see            ????
* @see            ????
*/
public with sharing class SM_ChoixOffre_manager {
    // to disable choix offre of the specify 'energy' and 'contexte de souscription'
    //listCo contains the new choix d'offre inserted
    public static void disableOldChoixOffreByEnergie(List<Choix_Offre__c> listCo){
        
        List<Choix_Offre__c> listChoixOffre = [SELECT Id, Energie__c, Contexte_de_souscription__c, Actif__c FROM Choix_Offre__c where Actif__c=true];
        
        if(listChoixOffre != null && !listChoixOffre.isEmpty()){
            for(Choix_Offre__c choixOffre :listChoixOffre ){
                for(Choix_Offre__c nvChoixOffre :listCo ){
                    if(choixOffre.Energie__c == nvChoixOffre.Energie__c && choixOffre.Contexte_de_souscription__c == nvChoixOffre.Contexte_de_souscription__c && choixOffre.Actif__c  && nvChoixOffre.Actif__c){
                        choixOffre.Actif__c = false;
                    }
                } 
            }
            update listChoixOffre; 
        }        
    }
    
}