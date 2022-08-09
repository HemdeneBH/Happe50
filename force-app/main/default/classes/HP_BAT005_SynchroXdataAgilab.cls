/**
 * @File Name          : HP_BAT005_SynchroXdataAgilab.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 11-16-2020
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    18/03/2020   Mouhamadoune Coulibaly     Initial Version
**/
global class HP_BAT005_SynchroXdataAgilab implements Database.Batchable<sObject>,Database.AllowsCallouts, Schedulable, Database.RaisesPlatformEvents, HP_UTIL_BatchInterface {
    
    final Id hpRecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Prestation_distributeur__c','HP_PrestationDistributeur');
   
    public static final Integer BATCH_CHUNK_SIZE = 1;
    global final  String query = 'Select Id,case__c, case__r.HP_Contrat__c,HP_Contrat__r.HP_Contrat_XdataId__c, case__r.Contact.Id_Tiers__c, case__r.HP_TECH_ExternalId__c, case__r.HP_Contrat__r.HP_Contrat_XdataId__c, HP_Contrat__c, HP_TECH_toNotify__c,RecordTypeId from Prestation_distributeur__c where RecordTypeId=\'' + hpRecordTypeId+ '\''+'AND HP_TECH_toNotify__c= true';   
    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('@@Query '+this.query);
    return Database.getQueryLocator(query);
    }
    



    global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT005_SynchroXdataAgilab());
    }
    
    global static void execute(SchedulableContext sc){
		execute();
	}
    



    global static void execute(){
		HP_BAT005_SynchroXdataAgilab batchSynchro = new HP_BAT005_SynchroXdataAgilab();
		Database.executeBatch(batchSynchro, BATCH_CHUNK_SIZE); 
	}
    
    global void execute(Database.BatchableContext bc, List<Prestation_distributeur__c> currentPres) { 
        List<HP_Contrat__c> contList = new List<HP_Contrat__c>();
        List<HP_Porte_Feuille_Contrat__c> pfcList = new List<HP_Porte_Feuille_Contrat__c>();
        List<Case> caseList = new List<Case>();
        for(Prestation_distributeur__c apresta : currentPres){
            Decimal xdataId = null;
            if(apresta.HP_Contrat__c != null &&  apresta.HP_Contrat__r.HP_Contrat_XdataId__c != null) {
                xdataId = apresta.HP_Contrat__r.HP_Contrat_XdataId__c ;
            } else if(apresta.case__r != null &&
            apresta.case__r.HP_Contrat__r != null &&
            apresta.case__r.HP_Contrat__r.HP_Contrat_XdataId__c != null) {
                xdataId = apresta.case__r.HP_Contrat__r.HP_Contrat_XdataId__c;
                apresta.HP_Contrat__c = apresta.case__r.HP_Contrat__c;
            } else if(apresta.case__r != null && apresta.case__r.HP_TECH_ExternalId__c != null
            && apresta.case__r.ContactId != null && apresta.case__r.Contact.Id_Tiers__c != null) {
                try {
                    xdataId = Integer.valueOf(apresta.case__r.HP_TECH_ExternalId__c.replace('CONTRACT_CANCELATION/', ''));
                    Map<String, Object> datas = HP_EM036_SyncXdataSF.loadContractFromXdata(String.valueOf(xdataId));
                    HP_Contrat__c cont = (HP_Contrat__c)datas.get('cont');
                    contList.add(cont);
                    pfcList.add(HP_EM036_SyncXdataSF.createPFC(cont.HP_Porte_Feuille_Contrat__r.Xdata_Id__c, String.valueOf(datas.get('xdataPersonne'))));
                    apresta.HP_Contrat__r = new HP_Contrat__c(HP_Contrat_XdataId__c = Integer.valueOf(xdataId));
                    caseList.add(new case(Id = apresta.case__c, HP_Contrat__r = new HP_Contrat__c(HP_Contrat_XdataId__c = Integer.valueOf(xdataId))));
                } catch(Exception e) {
                    Continue;
                }

            } else {
                continue;
            }
          
               HP_AgilabCommercialPropositionService.updateContractSync((Integer)xdataId, '9', null,new HP_WRP022_SFResponse(200));
            
               HP_APIHourContractService.updateContractSync(String.valueOf((Integer)xdataId),
               HP_APIHourContractService.APIHOUR_STATUS_BY_STATUS.get(HP_Contract.Status.CANCELLATION_NOT_DONE),'ACTIF', null);
               apresta.HP_TECH_toNotify__c = false;
           

        }
        if(pfcList.size() > 0) {
            upsert pfcList Xdata_Id__c;
           }
        if(contList.size() > 0) {
            upsert contList HP_Contrat_XdataId__c;
        }
        upsert currentPres;   
        
        

        if(caseList.size() > 0) {
            upsert caseList;
        }
    }
    global void finish(Database.BatchableContext bc){

    }
}