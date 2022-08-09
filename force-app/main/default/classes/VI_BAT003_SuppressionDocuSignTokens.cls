/*
*@Author: Clément Bouquin
*@Description: Batch qui relance chaque jour la suppression des DocuSignTokens agés de plus de 30 jours
*@CreatedDate: 06/05/2021
*@LastModified: 07/05/2021
*/

global class VI_BAT003_SuppressionDocuSignTokens implements Database.Batchable<sObject>{
    
    // Query select all VI_DocuSignTokens__c older than 30 days
    global final String query = 'SELECT ID, Name, VI_Value__c, CreatedDate FROM VI_DocuSignTokens__c WHERE CreatedDate ';
    global String numberOfDay = '< LAST_N_DAYS:30';
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('VI_BAT003_SuppressionDocuSignTokens starting...');
        return Database.getQueryLocator(query + numberOfDay);
    }
    
    public static void execute(String numberOfDay){
        VI_BAT003_SuppressionDocuSignTokens relanceBatch = new VI_BAT003_SuppressionDocuSignTokens();
        relanceBatch.numberOfDay = numberOfDay;
        Database.executeBatch(relanceBatch,200); 
    }
    
	global void execute(Database.BatchableContext bc, List<VI_DocuSignTokens__c> oldDocuSignTokens){
		// Delete all VI_DocuSignTokens__c older than 30 days
        delete oldDocuSignTokens;
    }
        
    global void finish(Database.BatchableContext bc){
        System.debug('VI_BAT003_SuppressionDocuSignTokens ending...');
    }
}