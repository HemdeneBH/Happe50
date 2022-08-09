/**
 * @File Name          : HP_BAT012_OmnichannelStopRoutage.cls
 * @Description        : 
 * @Author             : Antoine Latour
 * @Group              : 
 * @Last Modified By   : Antoine Latour
 * @Last Modified On   : 09/11/2020 à 15:45:51
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    09/11/2020   Antoine Latour     Initial Version
**/
global class HP_BAT013_OmnichannelStopRoutage implements Database.Batchable<sObject>, System.Schedulable, Database.RaisesPlatformEvents, HP_UTIL_BatchInterface{

    global static void launchNewScheduler(String schedule,String jobName){
		  System.schedule(jobName, schedule, new HP_BAT013_OmnichannelStopRoutage());
    }

    global void execute(SchedulableContext sc){
		  execute();
    }
    
    public static void execute(){
        HP_BAT013_OmnichannelStopRoutage batch = new HP_BAT013_OmnichannelStopRoutage();
		Database.executeBatch(batch, 20); 
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {

        List<String> queueDeveloperNames = new List<String>{'HP_Niveau_1', 'HP_Niveau_2', 'HP_Niveau_3'};
        Set<Id> queueIds = (new Map<Id, Group>([SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME IN : queueDeveloperNames])).keySet();
        List<String> caseStatus = new List<String>{'CLOSED','CANCELED'};
        
        return Database.getQueryLocator(
            [SELECT Id FROM PendingServiceRouting 
            WHERE WorkItem.HP_isHappe__c = true 
            AND (WorkItem.OwnerId NOT IN : queueIds OR WorkItem.Status IN : caseStatus)]
        );
    }

    global void execute(Database.BatchableContext bc, List<PendingServiceRouting> scope) {
        if(!scope.isEmpty()){
            HP_SM046_OmnichannelStopRoutage.ejectCaseFromOmnichannel(scope);
        }
    }

    global void finish(Database.BatchableContext bc){
    }
}