/**
 * @description       : Console Log Utility Component / Shoud be used in all LWC Components to handle console logs display
 * @author            : Mohamed Aamer
 * @last modified on  : 01-18-2022
 * @last modified by  : Mohamed Aamer
 * @version           : 1.0
**/
import hasCustomPermission from '@salesforce/customPermission/SM_VIEW_CONSOLE_LOG';

export function consoleLogHandler(message,elementToShow){
	//Check if the user has permission to show console.log
	if (hasCustomPermission){
		console.log(message+elementToShow);
	}
}