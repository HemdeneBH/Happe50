/*
*@Author: Amal Chreiteh
*@Description: Classe de test de la classe VI_CookieConsentService
*@CreatedDate: 16/03/2021
*@LastModified: 16/03/2021
*/

@isTest
public with sharing class VI_CookieConsentService_Test {
    @testSetup
    static void createTestData() {
        cookiecon__CookieConsentCategory__c cookieConsentCategory = new cookiecon__CookieConsentCategory__c(Name = 'Test', cookiecon__Description__c = 'Description', cookiecon__DefaultValue__c = true, cookiecon__Manditory__c = true, cookiecon__AdditionalInformation__c = 'Test');
        insert cookieConsentCategory;
        cookiecon__Cookie__c cookie = new cookiecon__Cookie__c(Name = 'Test', cookiecon__Description__c = 'Test', cookiecon__CookieConsentCategory__c = cookieConsentCategory.Id);
        insert cookie;
    }
    
    
    @isTest
    static void testGetCookieData() {
        Test.startTest();
        List<Map<String, Object>> result = new List<Map<String, Object>>();
        result = VI_CookieConsentService.getCookieData();
        Test.stopTest();
        System.assert(result.size() == 1);
    }
    
}