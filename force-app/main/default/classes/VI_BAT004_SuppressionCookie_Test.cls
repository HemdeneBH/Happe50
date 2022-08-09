/*
*@Auhtor: Clément Bouquin
*@Description: Classe de test de VI_BAT004_SuppressionCookie_Test
*@CreatedDate: 07/05/2021
*/

@isTest
public class VI_BAT004_SuppressionCookie_Test {

    @testSetup
    static void testSetup1(){
        cookiecon__CookieConsent__c CookieConsent = new cookiecon__CookieConsent__c();
        insert CookieConsent;
    }
    
	 @isTest
    static void testBatch(){
		Test.startTest();
        VI_BAT004_SuppressionCookie.execute('=today');
        Test.stopTest();
	}
}