/*
*@Author: Clément Bouquin
*@Description: Batch qui met à jours le status du Case à 'Pré-clôturé' et son sous-statut à 'Abandon'
Si le status de l'enveloppe n'est pas 'Signed' 30 jours après son envoie.
*@CreatedDate: 06/07/2021
*@LastModified: 13/09/2021
*/

global class VI_BAT005_ExpirationParcours implements Database.Batchable<sObject>{

    // Query select every Parcours and their linked Cases ids with an enveloppe not Signed after 30 days
    global final String query = 'SELECT Id, VI_StatutParcours__c, VI_Case__c FROM VI_Parcours__c WHERE VI_ChoixParcours__c=\'CHF\' AND VI_Case__r.VI_DateEnvoiEnveloppe__c < LAST_N_DAYS:30 AND VI_Case__r.VI_StatutEnveloppe__c!=\'Signed\'';
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('VI_BAT005_ExpirationParcours starting...');
        return Database.getQueryLocator(query);
    }
    
    public static void execute(){
        VI_BAT005_ExpirationParcours expirationBatch = new VI_BAT005_ExpirationParcours();
        Database.executeBatch(expirationBatch,200);
    }
    
	global void execute(Database.BatchableContext bc, List<VI_Parcours__c> scope){
        // Update VI_StatutParcours__c, Case's Status and Sous_statut__c of every VI_StatutEnveloppe__c != 'Signed' if VI_DateEnvoiEnveloppe__c higher than 30 days

        Set<Id> setCaseIds=new Set<Id>();
        for(VI_Parcours__c parcours:scope) {
            // Add the id case of the current parcours, from the scope, in setCaseIds
            setCaseIds.add(parcours.VI_Case__c);
        }
        // Query select every Case's in the parcours previously selected
        List<Case> listcase=new List<Case>();
        listcase=[SELECT Id, VI_DateEnvoiEnveloppe__c, VI_StatutEnveloppe__c, Status, Sous_statut__c FROM Case WHERE Id IN :setCaseIds];

        for(Case currentCase :listcase){
            // Update Status from Case
            currentCase.Status= 'Pré-clôturé';
            // Update Sous_statut__c from Case
            currentCase.Sous_statut__c = 'Abandon';  
        }
        update listcase;

    }
        
    global void finish(Database.BatchableContext bc){
        System.debug('VI_BAT005_ExpirationParcours ending...');
    }
    
}