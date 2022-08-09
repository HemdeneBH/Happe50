/*
*@Author: Clément Bouquin
*@Description: Scheduler qui relance chaque jour la suppression des DocuSignTokens agés de plus de 30 jours 
*@CreatedDate: 06/05/2021
*@LastModified: 07/05/2021
*/

global class VI_SCH003_SuppressionDocuSignTokens implements schedulable{

    // VI_SCH003_SuppressionDocuSignTokens schSuppressionDocuSignTokens = new VI_SCH003_SuppressionDocuSignTokens();
	// String sch = '0 0 1 * * ?';	// Class runs every day at 1 AM.
	// String jobID = system.schedule('Suppression des DocuSignTokens agés de plus de 30 jours', sch, schSuppressionDocuSignTokens);
    
    global void execute(SchedulableContext sc){
        VI_BAT003_SuppressionDocuSignTokens.execute('< LAST_N_DAYS:30');
    }
    
}