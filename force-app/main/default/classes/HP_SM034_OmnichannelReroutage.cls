/**
 * @File Name          : HP_SM034_OmnichannelReroutage.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 14/06/2020 à 01:30:13
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    14/06/2020   Vincent Albiser     Initial Version
**/
global without sharing class HP_SM034_OmnichannelReroutage {
    
    @InvocableMethod
    public static void rerouteDeclinedCases(List<String> casesId){

        delete [SELECT Id FROM PendingServiceRouting WHERE WorkItemId = :casesId];
        delete [SELECT Id FROM AgentWork WHERE WorkItemId = :casesId];

        Id queueNiv1Id = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'HP_Niveau_1'].Id;
        List<Case> cases = [SELECT Id FROM Case WHERE Id = :casesId];
        for(Case c : cases){
            c.ownerId = queueNiv1Id;
        }
        update cases;    
    }

}