/*
* @Author: Paul Ghoussoub
* @Date: 14/09/2021
* @Description:classe de test de VI_ContactHandler
*/
@isTest
public class VI_ContactHandler_Test {
    public static testmethod void testContactHandler(){
        
        Contact aC = new Contact(LastName = 'Test', Email = 'test1@test.com',Adresse_Mail_Principale__c='Adresse Mail 1',Id_Tiers__c=1);
        insert aC;
        
        aC.Email = 'test2@test.com';
        aC.Adresse_Mail_Principale__c='Adresse Mail 1';
        update aC;
        
        List<Contact> contactCheck=[select EmailPrincipalValueRW__c,Adresse_Mail_3__c,MobilePrincipalValueRW__c,Mobile_2__c,TelFixePrincipalValueRW__c,Phone from Contact where LastName='Test' Limit 1];        
        
        System.assertEquals(contactCheck[0].EmailPrincipalValueRW__c, 'test2@test.com');
    }
}