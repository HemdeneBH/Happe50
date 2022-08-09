/**
 * @File Name          : HP_BAT004_CaseResiliationNotification.cls
 * @Description        : 
 * @Author             : Sara El-Hannaoui
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 10-27-2020
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    03/03/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
global without sharing class HP_BAT004_CaseResiliationNotification implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable, Database.RaisesPlatformEvents, HP_UTIL_BatchInterface{

    public static final Integer BATCH_CHUNK_SIZE = 1;

    global Database.QueryLocator start(Database.BatchableContext bc) {
        final String queryFields = 'Id,HP_TECH_ExternalId__c, Contact.id_tiers__c , Motif__c, Status, Description, HP_TreatmentDate__c, HP_Energy__c, HP_EffectiveDate__c, ContactEmail, HP_index_elec_base__c, HP_index_elec_hc__c, HP_index_elec_hp__c, HP_index_gaz__c, HP_Contrat__r.HP_Contrat_XdataId__c, HP_ResiliationAgilabTraitement__c, HP_ResiliationModifierStatutAgilab__c, HP_ResiliationModifierStatutXdata__c, HP_PDL_PCE__c';
        final String queryWhere = 'RecordType.DeveloperName = \'HP_ContractCancelationCase\' and (HP_Contrat__r.HP_Contrat_XdataId__c != null or HP_TECH_ExternalId__c != null) and status != \'DISCARDED\' and status != \'CANCELED\' and ((Status != \'Closed\' AND HP_ResiliationAgilabTraitement__c = false) OR (Status = \'Closed\' AND HP_ResiliationModifierStatutAgilab__c = false) OR (Status = \'Closed\' AND HP_ResiliationModifierStatutXdata__c = false)) AND HP_EffectiveDate__c != null AND HP_EffectiveDate__c >= LAST_N_DAYS:15';
        final String query = 'select ' + queryFields + ' from Case where ' + queryWhere; 

        return Database.getQueryLocator(query);
    }


    global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT004_CaseResiliationNotification());
	}

    global static void execute(SchedulableContext sc){
		execute();

    }

    global static void execute(){
		HP_BAT004_CaseResiliationNotification resiliationBatch = new HP_BAT004_CaseResiliationNotification();
		Database.executeBatch(resiliationBatch, BATCH_CHUNK_SIZE); //a class that implements the Database.Batchable interface, parameter scope : number of parameter to pass into the execute method > 0
	}

    global void execute(Database.BatchableContext bc, List<Case> scope){
        List<HP_Contrat__c> contList = new List<HP_Contrat__c>();
        List<HP_Porte_Feuille_Contrat__c> pfcList = new List<HP_Porte_Feuille_Contrat__c>();
        for(Case acase : scope) {
            Decimal xdataId = null;
            if(acase.HP_Contrat__r != null &&  acase.HP_Contrat__r.HP_Contrat_XdataId__c != null) {
                xdataId = acase.HP_Contrat__r.HP_Contrat_XdataId__c;
            } else if(acase.HP_TECH_ExternalId__c != null) {
                try {
                    xdataId = Integer.valueOf(acase.HP_TECH_ExternalId__c.replace('CONTRACT_CANCELATION/', ''));
                    Map<String, Object> datas = HP_EM036_SyncXdataSF.loadContractFromXdata(String.valueOf(xdataId));
                    HP_Contrat__c cont = (HP_Contrat__c)datas.get('cont');
                    contList.add(cont);

                    pfcList.add(HP_EM036_SyncXdataSF.createPFC(cont.HP_Porte_Feuille_Contrat__r.Xdata_Id__c, String.valueOf(datas.get('xdataPersonne'))));
                    acase.HP_Contrat__r = new HP_Contrat__c(HP_Contrat_XdataId__c = Integer.valueOf(xdataId));
                    if(acase.ContactId == null) {
                        acase.Contact = new Contact(Id_Tiers__c = (Decimal)datas.get('xdataPersonne'));
                    }
                    
                    if(String.isBlank(acase.HP_PDL_PCE__c)) {
                        final Boolean isElec = acase.HP_Energy__c == 'Electricity';
                        Map<String, Object> resultPDL = HP_SM008_APIHour.getPDL(String.valueOf(datas.get('xdataPDL')), isElec);
                        acase.HP_PDL_PCE__c = (String)resultPDL.get('numeroPointDeLivraison');
                    }
                } catch(Exception e) {
                    Continue;
                }
                
            } else {
                continue;
            }
            
            Integer indexHp = (Integer) (acase.HP_Energy__c == 'Electricity' && acase.HP_index_elec_hc__c == null ?  acase.HP_index_elec_base__c : (acase.HP_Energy__c == 'Electricity' && acase.HP_index_elec_hc__c != null ? acase.HP_index_elec_hp__c : null ));
            if(!acase.HP_ResiliationAgilabTraitement__c) {
                HP_WRP022_SFResponse response = new HP_WRP022_SFResponse(200);
                HP_AgilabCommercialPropositionService.resiliationAgilab(acase,(Integer)xdataId, indexHp, response);
                
                if(response.infos.size() > 0 && response.infos[0].code == 'AgilabCommercialPropositionService' && response.infos[0].message == 'success'){
                    acase.HP_ResiliationAgilabTraitement__c = true;
                }                
            }
            if(!acase.HP_ResiliationModifierStatutXdata__c && acase.HP_ResiliationAgilabTraitement__c && acase.Status == 'CLOSED') {                
                acase.HP_ResiliationModifierStatutXdata__c = HP_SM008_APIHour.updateContratByResiliationBatch(String.valueOf((Integer)xdataId), 
                HP_APIHourContractService.APIHOUR_STATUS_BY_STATUS.get(HP_Contract.Status.InCancellation),'ACTIF', null);

            }
           
            if(!acase.HP_ResiliationModifierStatutAgilab__c && acase.HP_ResiliationAgilabTraitement__c && acase.Status == 'CLOSED') {
                HP_WRP022_SFResponse response = new HP_WRP022_SFResponse(200);
                HP_AgilabCommercialPropositionService.updateContractSync((Integer) xdataId,
                    HP_Constantes.AGILAB_STATUS_BY_STATUS.get('InCancellation'), String.ValueOf(acase.HP_EffectiveDate__c), response);
                
                if(response.infos.size() > 0 && response.infos[0].code == 'AgilabCommercialPropositionService' && response.infos[0].message == 'success'){
                    acase.HP_ResiliationModifierStatutAgilab__c = true;
                }                

            }
            
        }
        if(pfcList.size() > 0) {
            upsert pfcList Xdata_Id__c;



        }
        if(contList.size() > 0) {
            upsert contList HP_Contrat_XdataId__c;
        }

        upsert scope;


    }

    global void finish(Database.BatchableContext bc){

    }
}