/* 
 * @description: Trigger related to Prestation_distributeur__c object
 * @projet: Smile
 *
 * @Modified by : Omar Mohamad
 * @Date : 27/03/2020
 * @Description:Optimisation trigger avec le pattern 0'hara.
 */
public with sharing class Prestation_distributeur_Handler extends TriggerHandler {

    private Map<Id, Prestation_distributeur__c> oldMap;
    private Map<Id, Prestation_distributeur__c> newMap;
    private List<Prestation_distributeur__c> oldList;
    private List<Prestation_distributeur__c> newList;
    Set<Id> emailsChanged = new Set<Id>();
    
    
    public Prestation_distributeur_Handler() {
        this.oldMap = (Map<Id, Prestation_distributeur__c>) Trigger.oldMap;
        this.newMap = (Map<Id, Prestation_distributeur__c>) Trigger.newMap;
        this.oldList = (List<Prestation_distributeur__c>) Trigger.Old;
        this.newList = (List<Prestation_distributeur__c>) Trigger.New;
    }
    
    public override void afterUpdate(){

        //if (SM_Utilities.getUserProfileName().startsWith('SM_') || SM_Utilities.getUserProfileName().startsWith('HP_') || Test.isRunningTest()) {

            Prestation_distributeur_Process.modifyCaseStatus(newList);
        //}
    }
    
}