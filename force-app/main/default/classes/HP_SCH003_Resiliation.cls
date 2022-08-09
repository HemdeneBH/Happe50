/**
 * @File Name          : HP_SCH003_Resiliation.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 27/02/2020 à 13:06:37
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    27/02/2020   Vincent Albiser     Initial Version
**/
global class HP_SCH003_Resiliation implements schedulable {

	global void execute(SchedulableContext sc){
		HP_BAT003_Resiliation batchResiliation = new HP_BAT003_Resiliation();
		database.executebatch(batchResiliation);
	}
}