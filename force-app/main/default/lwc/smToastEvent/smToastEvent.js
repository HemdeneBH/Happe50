/**
 * @description       : Toast Utility Component to show toasts
 * @author            : Mohamed Aamer
 * @last modified on  : 12-24-2021
 * @last modified by  : Mohamed Aamer
 * @version           : 1.0
**/

import {ShowToastEvent} from 'lightning/platformShowToastEvent';

//Display Notifications
export function toastHandler(eventTarget,title,message,variant){
	const toastEvent = new ShowToastEvent({
		title:title,
		message:message,
		variant:variant
	});
	eventTarget.dispatchEvent(toastEvent);
}