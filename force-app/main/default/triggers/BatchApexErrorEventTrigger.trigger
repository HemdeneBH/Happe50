/**
 * @File Name          : BatchApexErrorEventTrigger.trigger
 * @Description        : 
 * @Author             : Sara El-Hannaoui
 * @Group              : 
 * @Last Modified By   : Sara El-Hannaoui
 * @Last Modified On   : 07-09-2020
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    30/06/2020   Sara El-Hannaoui     Initial Version
**/
trigger BatchApexErrorEventTrigger on BatchApexErrorEvent (after insert) {

    if(!ByPassSettings__c.getInstance().BatchApexErrorEventTrigger__c){
        if (Trigger.isAfter) {
            if(Trigger.isInsert){
                new BatchApexErrorEventTriggerHandler().run();
            }
        } 
    }
   
}