/**
 * @File Name          : HP_SCH006_NettoyageLog.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 30/03/2020 à 11:16:05
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    24/03/2020   Mouhamadoune Coulibaly     Initial Version
**/
global class HP_SCH006_NettoyageLog implements Schedulable{
    
    global void execute(SchedulableContext sc){
        HP_BAT006_NettoyageLog.execute();
    }
    public static void launchNewScheduler(){
		final String jobName = 'HP_SCH006_NettoyageLog';
        final String cronExp = '0 0 22 * * ? *';
        System.schedule(jobName, cronExp, new HP_SCH006_NettoyageLog());
	}
}