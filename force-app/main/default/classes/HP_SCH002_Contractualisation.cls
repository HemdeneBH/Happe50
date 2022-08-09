/**
 * @File Name          : HP_SCH002_Contractualisation.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 27/02/2020 à 12:51:47
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    27/02/2020   Vincent Albiser     Initial Version
**/
global class HP_SCH002_Contractualisation implements Schedulable {
    
	global void execute(SchedulableContext sc){
		HP_BAT002_Contractualisation.execute();
	}

	public static void launchNewScheduler(){
		final String jobName = 'HP_SCH002_Contractualisation';
		final String delayedSecondMinute = '00 15 ';
		final String jobRecurenceDayYear = ' ? * MON-FRI *';
		final String schedule = delayedSecondMinute + '8' + jobRecurenceDayYear;
		// Use extreme care if you’re planning to schedule a class from a trigger. You must be able to guarantee that the trigger won’t add more scheduled classes than the limit
		// The System.Schedule method takes three arguments: a name for the job, an expression used to represent the time and date the job is scheduled to run, and the name of the class.
		System.schedule(jobName, schedule, new HP_SCH002_Contractualisation());
	}
}