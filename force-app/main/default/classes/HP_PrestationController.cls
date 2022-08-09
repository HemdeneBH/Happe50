/**
 * @File Name          : HP_PrestationController.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 30/03/2020 à 10:23:49
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    30/03/2020   Mouhamadoune Coulibaly     Initial Version
**/
public with sharing class HP_PrestationController { 
 
    public static void handleUpdatedOPS (List <Prestation_distributeur__c> hpUpdatedOps) {
 
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HP_PrestationDistributeur').getRecordTypeId();
        Map<Id, Case> caseByPrestaId = new Map<Id, Case>();
        
        for (Prestation_distributeur__c hpOps : hpUpdatedOps) {
            final String opsType = hpOps.Situation_de_vente__c;
            final String energyType = hpOps.Secteur_activite__c;
            final String lastMilestoneStatus;
            final String energy;
 
            if (opsType == 'Changement de fournisseur' || opsType == 'Emménagement') {
                if (energyType == 'Elec') {
                    //Elec
                    lastMilestoneStatus = hpOps.Statut_dernier_jalon__c;
                    energy = HP_SLCT_Case.Energy.Electricity.name();
                    if (hpOps.Statut__c == 'Terminé' && lastMilestoneStatus != 'CPRE') {
                        caseByPrestaId.put(hpOps.Id, handleCaseAndUpdateXDataAgilab(caseRecordTypeId, energy, hpOps));
                    }
                } else {
                    //Gaz
                    lastMilestoneStatus = hpOps.Statut_dernier_jalon__c;
                    energy = HP_SLCT_Case.Energy.Gas.name();
                    if (lastMilestoneStatus == '022' || lastMilestoneStatus == '023' || lastMilestoneStatus == '041') {
                        caseByPrestaId.put(hpOps.Id, handleCaseAndUpdateXDataAgilab(caseRecordTypeId, energy, hpOps));
                    }
                }
            }
 
        }
        if(!caseByPrestaId.isEmpty()){
            insert caseByPrestaId.values();
        }
        for (Prestation_distributeur__c hpOps : hpUpdatedOps){
            if(caseByPrestaId.containsKey(hpOps.Id)){
                hpOps.Case__c = caseByPrestaId.get(hpOps.Id).Id;
            }
        }
 
        List<Database.UpsertResult> updateOPSResultList = Database.upsert(hpUpdatedOps, true);
        if (updateOPSResultList.size()>0) {
            system.debug('OPS isSuccess');
        }
        return;
    }
 
    public static Case handleCaseAndUpdateXDataAgilab (Id caseRecordTypeId, String energy, Prestation_distributeur__c hpOps) {
 
            System.debug('Create Case hpOps Id: '+hpOps);
            Case hpCase = new Case();
 
            hpCase.RecordTypeId = caseRecordTypeId;
            hpCase.Status = HP_SLCT_Case.Status.TO_DO.name();
            hpCase.Origin = HP_SLCT_Case.Origin.HP_CRM.name();
            hpCase.HP_Energy__c = energy;
            hpCase.Reason = HP_SLCT_Case.Reason.HP_PRESTATION_GRD.name();
            hpCase.Description = 'Demande non réalisée';
            
            hpOps.HP_TECH_toNotify__c = true;     
            
            return hpCase;
    }
}