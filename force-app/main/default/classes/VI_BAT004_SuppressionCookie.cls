/*
*@Author: Clément Bouquin
*@Description: Batch qui relance chaque jour la suppression des Cookies agés de plus de 6 mois
*@CreatedDate: 07/05/2021
*@LastModified: 07/05/2021
*/

global class VI_BAT004_SuppressionCookie implements Database.Batchable<sObject>{

    // Query select all cookiecon__CookieConsent__c older than 6 Month
    global final String query = 'SELECT ID, Name, CreatedDate FROM cookiecon__CookieConsent__c WHERE CreatedDate ';
    global String numberOfDay = '< LAST_N_MONTHS:6';
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('VI_BAT004_SuppressionCookie starting...');
        return Database.getQueryLocator(query + numberOfDay);
    }
    
    public static void execute(String numberOfDay){
        VI_BAT004_SuppressionCookie relanceBatch = new VI_BAT004_SuppressionCookie();
        relanceBatch.numberOfDay = numberOfDay;
        Database.executeBatch(relanceBatch,200); 
    }
    
	global void execute(Database.BatchableContext bc, List<cookiecon__CookieConsent__c> oldCookies){
		// Delete all cookiecon__CookieConsent__c older than 6 month
        delete oldCookies;
    }
        
    global void finish(Database.BatchableContext bc){
        System.debug('VI_BAT004_SuppressionCookie ending...');
    }
    
}