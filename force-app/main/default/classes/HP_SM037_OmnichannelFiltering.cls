/**
 * @description       : 
 * @author            : Sara El-Hannaoui
 * @group             : 
 * @last modified on  : 07-20-2020
 * @last modified by  : Sara El-Hannaoui
 * Modifications Log 
 * Ver   Date         Author             Modification
 * 1.0   07-17-2020   Sara El-Hannaoui   Initial Version
**/
public without sharing class HP_SM037_OmnichannelFiltering {

    @InvocableMethod
    public static void deletePSR(List<String> casesId){

        System.debug('HP_SM037_OmnichannelFiltering');
        System.debug('casesId = ' + casesId);

        Map<Id, Case> closedCaseList = new Map<Id, Case>( [SELECT Id,
        RecordType.DeveloperName
        FROM Case WHERE Id IN :casesId]);

        System.Debug('************** case fermés '+ closedCaseList.keyset());
         // Extraction PSR de case fermés  
        delete [SELECT Id, WorkItemId FROM PendingServiceRouting WHERE WorkItemId IN : closedCaseList.keyset()];
        delete [SELECT id FROM AgentWork WHERE WorkItemId IN :closedCaseList.keyset()];
    
    }
}