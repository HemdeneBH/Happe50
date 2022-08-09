/* 
* @description: Trigger related to Prestation_distributeur__c object
* @projet: Smile
*
*
* @Modified by : Omar Mohamad
* @Date : 27/03/2020
* @Description:Optimisation trigger avec le pattern 0'hara.
*/
public with sharing class Prestation_distributeur_Process {
    
    public static String SM_PrestaDistribRecordType = System.Label.SM_PrestaDistribRecordType;
    
    public static void modifyCaseStatus(List<Prestation_distributeur__c> newList){
        // FT3-218 : on modifie le statut et sous-statut de Case si toutes les OPS sont terminées
        
        // on exclut les OPS Happe
        Id hpRecordTypeId = Schema.SObjectType.Prestation_distributeur__c.getRecordTypeInfosByDeveloperName().get('HP_PrestationDistributeur').getRecordTypeId();
        
        
        //Prestation_distributeur__c[] listOPS = Trigger.new;
        Map<Id,Case> listIdCase = new Map<Id,Case>();
        for(Prestation_distributeur__c ops : newList){
            if(ops.RecordTypeId != hpRecordTypeId){
                listIdCase.put(ops.case__c, null);
                
            }
        }
        
        Prestation_distributeur__c[] listAllOPS = [select id, statut__c, case__c, case__r.status from Prestation_distributeur__c where Case__c IN :listIdCase.keyset() ];
        for(Prestation_distributeur__c myOPS : listAllOPS){
            if(myOPS.statut__c != 'Terminé' || myOPS.case__r.status == 'Pré-clôturé' || myOPS.case__r.status == 'Fermé' || myOPS.case__r.status == 'Annulé'){
                //on exclut les cases ayant des OPS non terminées
                //FT3-693 : on exclut les case qui sont au statut Pré-clôturé, Fermé ou Annulé
                
                listIdCase.remove(myOPS.Case__c);
            }
        }
        
        // On met les Case à préclôturé conforme
        List<Case> listCaseToUpdate = new List<Case>();
        for(Id caseId : listIdCase.keySet()){
            
            
            
            Case myCase = new Case();
            myCase.Id = caseId;
            myCase.Status = System.Label.SM_CL21_Case_status_PreCloturee;
            myCase.Sous_statut__c = 'Conforme';
            listCaseToUpdate.add(myCase);
        }    
        update listCaseToUpdate;
    }
    
}