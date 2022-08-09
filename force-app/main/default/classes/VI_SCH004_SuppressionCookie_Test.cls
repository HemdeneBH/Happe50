/*
*@Auhtor: Clément Bouquin
*@Description: Classe de test de VI_SCH004_SuppressionCookie_Test
*@CreatedDate: 07/05/2021
*/

@isTest
public class VI_SCH004_SuppressionCookie_Test {
    
    public static String CRON_EXP = '0 0 1 * * ?'; // Everyday at 1AM
	@testSetup
	static void testSetup1(){
		cookiecon__CookieConsent__c CookieConsent = new cookiecon__CookieConsent__c();
		insert CookieConsent;
	}
    
	static testmethod void testScheduledJob() {
        Test.startTest();
        // Schedule the test job
        VI_SCH004_SuppressionCookie SuppressionCookieConsent = new VI_SCH004_SuppressionCookie();
        String jobID = System.schedule('Suppression des cookiecon__CookieConsent__c agés de plus de 30 jours', CRON_EXP, SuppressionCookieConsent);
        Test.stopTest();
	}
    
}