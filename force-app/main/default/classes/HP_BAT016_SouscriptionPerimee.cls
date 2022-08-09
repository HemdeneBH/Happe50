/**
 * @description  : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author            Modification
 * 1.0   02-10-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
global with sharing class HP_BAT016_SouscriptionPerimee implements  Database.AllowsCallouts, Database.Batchable<SObject>, Schedulable, Database.RaisesPlatformEvents, HP_UTIL_BatchInterface {
       
    private static Integer HP_NBR_JOUR_AVANT_SOUSCRIPTION_PERIMEE = Integer.valueOf(HP_UTIL_MetadataManager.getConfigByKey('HP_NBR_JOUR_AVANT_SOUSCRIPTION_PERIMEE'));

    global Database.QueryLocator start(Database.BatchableContext bc) {
        DateTime dateLimit = System.now().addDays(- HP_NBR_JOUR_AVANT_SOUSCRIPTION_PERIMEE);
        return Database.getQueryLocator('select Id, (select id, HP_Proposition_Commerciale_XdataId__c from HP_Contrats__r) from HP_Souscription__c where HP_DigitalDateSave2__c < :dateLimit and (HP_Statut__c = \'SAVE_2\' or HP_Statut__c = \'SAVE_2_CONFIRMED\')');
    }

    global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT016_SouscriptionPerimee());
    }

    global static void execute(SchedulableContext sc){
		execute();
	}
    
    global static void execute(){
		HP_BAT016_SouscriptionPerimee bt = new HP_BAT016_SouscriptionPerimee();
		Database.executeBatch(bt, 1); 
    }
    
    global void execute(Database.BatchableContext bc, List<hp_souscription__c> souscriptions) { 
        for(HP_Souscription__c sous : souscriptions) {
            if(sous.HP_Contrats__r != null && sous.HP_Contrats__r.size() > 0) {
                List<Integer> pcIdList = new List<Integer>();
                for(HP_Contrat__c cont : sous.HP_Contrats__r) {
                    if(cont.HP_Proposition_Commerciale_XdataId__c != null)
                        pcIdList.add(Integer.valueOf(cont.HP_Proposition_Commerciale_XdataId__c));
                }
                if(pcIdList.size() > 0)
                    HP_APIHourCommercialPropositionService.updateCommmercialPropositionSync(pcIdList, 'E0010', 'H0104');
            }
            sous.HP_Statut__c = 'PERIMEE';
        }
        update souscriptions;
    }

    global void finish(Database.BatchableContext bc){
        
    }
}