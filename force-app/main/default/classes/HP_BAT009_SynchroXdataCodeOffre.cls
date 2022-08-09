/**
 * @File Name          : HP_BAT009_SynchroXdataCodeOffre.cls
 * @Description        : Batch synchronisation codeOffre xdata API Offre 
 * @Author             : Sara El-Hannaoui
 * @Group              : 
 * @Last Modified By   : Sara El-Hannaoui
 * @Last Modified On   : 05/05/2020 à 15:13:52
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    05/05/2020   Sara El-Hannaoui     Initial Version
**/
global with sharing class HP_BAT009_SynchroXdataCodeOffre implements Database.Batchable<HP_WRP036_APIHourCodeOffre>, Database.AllowsCallouts, Schedulable, Database.RaisesPlatformEvents, HP_UTIL_BatchInterface {
   
    
    public List<HP_WRP036_APIHourCodeOffre> start(Database.BatchableContext bc) {
        return HP_SM008_APIHour.getCodeOffre();
    }

    global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT009_SynchroXdataCodeOffre());
    }

    global static void execute(SchedulableContext sc){
		execute();
	}
    
    global static void execute(){
		HP_BAT009_SynchroXdataCodeOffre batchSynchro = new HP_BAT009_SynchroXdataCodeOffre();
		Database.executeBatch(batchSynchro); 
	}
    
    public void execute(Database.BatchableContext bc, List<HP_WRP036_APIHourCodeOffre> scope) {
        List<HP_Offre__c> offres = new List<HP_Offre__c>();
        for (HP_WRP036_APIHourCodeOffre code : scope){
            offres.add(new HP_Offre__c(
                Name = code.code, 
                marqueCode__c =  code.codeMarque,
                offreCode__c = code.code,
                offreId__c = code.id,
                packId__c = code.idPack,
                offreLibelle__c = code.libelle 
            ));
        }
        Database.upsert(offres, HP_Offre__c.Fields.offreCode__c);  
    }

    global void finish(Database.BatchableContext bc){
    }
}