/*
*@Auhtor: Paul Ghoussoub
*@Description: Batch qui relance les mandats chaque jour
*@CreatedDate: 16/03/2021
*/
global class VI_BAT001_RelanceMandat implements Database.Batchable<sObject>, Database.AllowsCallouts{
    global final String Query = 'SELECT Id,VI_URL_Mandat__c,VI_IDReferenceClient__c,VI_ID_Mandat__c,VI_idCompteClient__c,VI_Tech_relance__c FROM VI_Parcours__c where VI_ID_Mandat__c!=null AND VI_EmailEnvoye__c=true AND VI_Tech_relance__c=false';
    //global final String Query = 'SELECT Id,VI_URL_Mandat__c,VI_IDReferenceClient__c,VI_ID_Mandat__c,VI_idCompteClient__c,VI_Tech_relance__c FROM VI_Parcours__c where id=\'a4I1q000005OOLeEAO\'';

    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('VI_BAT001_RelanceMandat starting...');
        return Database.getQueryLocator(Query);
    }
    
    public static void execute(){
        VI_BAT001_RelanceMandat relanceBacth = new VI_BAT001_RelanceMandat();
        Database.executeBatch(relanceBacth,1); 
    }
    
    global void execute(Database.BatchableContext bc, List<VI_Parcours__c> scope){
        for(VI_Parcours__c parcours:scope){
             VI_SM034_ProcessusRelanceMandat.relancerMandat(parcours.VI_IDReferenceClient__c,parcours.VI_ID_Mandat__c,parcours.VI_idCompteClient__c,null,'VI','local.VIToken','callout:VI_AuthOctopus');
            parcours.VI_Tech_relance__c=true;
        }
        update scope;
    }
    
    global void finish(Database.BatchableContext bc){
        System.debug('VI_BAT001_RelanceMandat ending...');
    }
}