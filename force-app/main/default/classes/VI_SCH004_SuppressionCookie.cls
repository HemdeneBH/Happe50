/*
*@Author: Clément Bouquin
*@Description: Scheduler qui relance chaque jour la suppression des Cookies agés de plus de 6 mois 
*@CreatedDate: 07/05/2021
*@LastModified: 07/05/2021
*/
global class VI_SCH004_SuppressionCookie implements schedulable{

    // VI_SCH004_SuppressionCookie schSuppressionCookie = new VI_SCH004_SuppressionCookie();
	// String sch = '0 0 1 * * ?';	// Class runs every day at 1 AM.
	// String jobID = system.schedule('Suppression des cookiecon__CookieConsent__c agés de plus de 6 mois', sch, schSuppressionCookie);
    
    global void execute(SchedulableContext sc){
        VI_BAT004_SuppressionCookie.execute('< LAST_N_MONTHS:6');
    }
    
}