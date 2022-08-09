/**
 * @File Name          : KnowledgeTrigger.trigger
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 19/05/2020 à 03:08:44
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    19/05/2020   Vincent Albiser     Initial Version
**/
trigger KnowledgeTrigger on Knowledge__kav (before insert, before update) {
    
    if(!HP_UTIL_ByPassTrigger.isByPassTrigger('HP_KnowledgeTrigger__c')) {
		HP_KnowledgeTriggerHandler.execute();
	}

}