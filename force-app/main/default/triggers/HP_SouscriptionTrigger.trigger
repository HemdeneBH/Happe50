/**
 * @File Name          : HP_SouscriptionTrigger.trigger
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 11-13-2020
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    02/03/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/

trigger HP_SouscriptionTrigger on HP_Souscription__c (after update, before insert, before update) {
    if(!HP_UTIL_ByPassTrigger.isByPassTrigger('HP_SouscriptionTrigger__c')) {
        if (Trigger.isAfter){
            HP_HDL003_Souscription.handleAfterUpdate();
        }else if (Trigger.isBefore){
            HP_HDL003_Souscription.handleBeforeUpdateInsert();
        }
    }
}