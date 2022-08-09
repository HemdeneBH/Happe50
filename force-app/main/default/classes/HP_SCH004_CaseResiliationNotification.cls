/**
 * @File Name          : HP_SCH004_CaseResiliationNotification.cls
 * @Description        : 
 * @Author             : Sara El-Hannaoui
 * @Group              : 
 * @Last Modified By   : Sara El-Hannaoui
 * @Last Modified On   : 25/06/2020 à 14:03:06
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    25/06/2020   Sara El-Hannaoui     Initial Version
**/
global with sharing class HP_SCH004_CaseResiliationNotification implements Schedulable{
    
    global void execute(SchedulableContext sc){
		HP_BAT005_SynchroXdataAgilab.execute();
		HP_SCH004_CaseResiliationNotification.launchNewScheduler();
	}

	global static void launchNewScheduler(){
	 	final String jobName = 'HP_SCH004_CaseResiliationNotification';
		// runs every one hour 
		final  String schedule = '0 0 * * * ?'; 
	 	// Use extreme care if you’re planning to schedule a class from a trigger. You must be able to guarantee that the trigger won’t add more scheduled classes than the limit
	 	// The System.Schedule method takes three arguments: a name for the job, an expression used to represent the time and date the job is scheduled to run, and the name of the class.
	 	System.schedule(jobName, schedule, new HP_SCH004_CaseResiliationNotification());
	 }
}