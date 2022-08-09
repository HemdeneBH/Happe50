/**
 * @File Name          : HP_SCH005_SynchroXdataAgilab.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 19/03/2020 à 12:39:16
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    19/03/2020   Mouhamadoune Coulibaly     Initial Version
**/
global class  HP_SCH005_SynchroXdataAgilab implements Schedulable {
    
	global void execute(SchedulableContext sc){
        HP_BAT005_SynchroXdataAgilab.execute();
	}

	 public static void launchNewScheduler(){
	 	final String jobName = 'HP_SCH005_SynchroXdataAgilab';
		 // La date du schedule peut changer
		 final String schedule = '0 0 6 ? * MON,TUE,WED,FRI,SAT *'; 
	 	// Use extreme care if you’re planning to schedule a class from a trigger. You must be able to guarantee that the trigger won’t add more scheduled classes than the limit
	 	// The System.Schedule method takes three arguments: a name for the job, an expression used to represent the time and date the job is scheduled to run, and the name of the class.
	 	System.schedule(jobName, schedule, new HP_SCH005_SynchroXdataAgilab());
	 }
}