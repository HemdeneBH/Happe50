/**
 * @File Name          : HP_BAT000_BatchMaster.cls
 * @Description        : Master class , executes all happe batchs 
 * @Author             : Sara El-Hannaoui
 * @Group              : 
 * @Last Modified By   : Sara El-Hannaoui
 * @Last Modified On   : 01/07/2020 à 12:14:39
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    01/07/2020   Sara El-Hannaoui     Initial Version
**/

global class HP_BAT000_BatchMaster {

    global static void main() {
        abort();
        execute();
    }

    global static void abort(){
        for (CronTrigger job :  [select Id from CronTrigger where CronJobDetail.JobType = '7' and CronJobDetail.Name like 'HP_%']){
             System.abortJob(job.Id);
        }
    }


  

    global static void execute(){
        for (HP_BatchCron_Config__mdt cronMDT : [SELECT BatchClassName__c, CronExpression__c, DeveloperName FROM HP_BatchCron_Config__mdt]){
            if(!Test.isRunningTest()) {
                HP_UTIL_BatchInterface apexClass = (HP_UTIL_BatchInterface) Type.forName(cronMDT.BatchClassName__c).newInstance();
                apexClass.launchNewScheduler(cronMDT.CronExpression__c , cronMDT.DeveloperName);
            }     
        }
    }

}