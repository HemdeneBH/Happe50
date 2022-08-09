/*
* @Author: Amine Deghais ~ amine.deghais@external.engie.com
* @Date: 03/09/2019
* @Description: test Class:Insère un contact pour vérifier le remplissage  email,Mobile,telephone par les email,Mobile,telephone Principals
*/
@isTest
public class ContactTrigger_TEST {
    @isTest static void testContactTrigger(){
        Test.startTest();     
        Contact contact=new Contact(
            LastName='LastNameCT12',
            Email='amine.deghais@external.engie.com',
            Adresse_Mail_2__c='mohamed.kchaou@external.engie.com',
            Adresse_Mail_3__c='goolaup.jasondavid@external.engie.com',
            Adresse_Mail_Principale__c='Adresse Mail 3',
            MobilePhone='+33742342341',
            Mobile_2__c='+33742342342',
            Mobile_3__c='+33742342343',
            Mobile_Principal__c='Mobile 2',
            Phone='+33574543241',
            Tel_Fixe_2__c='+33574543242',
            Tel_Fixe_3__c='+33574543243',
            Tel_Fixe_Principal__c='Tel Fixe 1',
            Id_Tiers__c = 12345);     
        insert contact;
        update contact;
        Test.stopTest();
        List<Contact> contactCheck=[select EmailPrincipalValueRW__c,Adresse_Mail_3__c,MobilePrincipalValueRW__c,Mobile_2__c,TelFixePrincipalValueRW__c,Phone from Contact where LastName='LastNameCT12' Limit 1];        
        
        System.assertEquals(contactCheck[0].EmailPrincipalValueRW__c, contactCheck[0].Adresse_Mail_3__c);
        System.assertEquals(contactCheck[0].MobilePrincipalValueRW__c, contactCheck[0].Mobile_2__c);
        System.assertEquals(contactCheck[0].TelFixePrincipalValueRW__c, contactCheck[0].Phone);
    }
    
    public static testmethod void testContactHandler(){
        
        Contact aC = new Contact(LastName = 'Test', Email = 'test1@test.com',Adresse_Mail_Principale__c='Adresse Mail 1', Id_Tiers__c = 12345);
        insert aC;
        
        aC.Email = 'test2@test.com';
        aC.Adresse_Mail_Principale__c='Adresse Mail 1';
        update aC;
		
        List<Contact> contactCheck=[select EmailPrincipalValueRW__c,Adresse_Mail_3__c,MobilePrincipalValueRW__c,Mobile_2__c,TelFixePrincipalValueRW__c,Phone from Contact where LastName='Test' Limit 1];        

        System.assertEquals(contactCheck[0].EmailPrincipalValueRW__c, 'test2@test.com');
    }
    
    public static testmethod void testContactEmailChange(){
        
        Contact aC = new Contact(LastName = 'Test', Email = 'test1@test.com',Adresse_Mail_Principale__c='Adresse Mail 1', Id_Tiers__c = 12345);
        insert aC;
        
        aC.Adresse_Mail_2__c = 'test2@test.com';
        aC.Adresse_Mail_Principale__c='Adresse Mail 2';
        update aC;
		
        List<Contact> contactCheck=[select EmailPrincipalValueRW__c,Adresse_Mail_3__c,MobilePrincipalValueRW__c,Mobile_2__c,TelFixePrincipalValueRW__c,Phone from Contact where LastName='Test' Limit 1];        

        System.assertEquals(contactCheck[0].EmailPrincipalValueRW__c, 'test2@test.com');
    }
    
    public static testmethod void testContactMobileChange(){
        
        Contact aC = new Contact(LastName = 'Test',MobilePhone='+33742342341',Mobile_Principal__c='Mobile 1', Id_Tiers__c = 12345);
        insert aC;
        
        aC.Mobile_2__c = '+33742342342';
        aC.Mobile_Principal__c='Mobile 2';
        update aC;
        
        List<Contact> contactCheck=[select EmailPrincipalValueRW__c,Adresse_Mail_3__c,MobilePrincipalValueRW__c,Mobile_2__c,TelFixePrincipalValueRW__c,Phone from Contact where LastName='Test' Limit 1];        

        System.assertEquals(contactCheck[0].MobilePrincipalValueRW__c, '+33742342342');
    }
    
    public static testmethod void testContactPhoneChange(){
        
        //SM_Utilities.runOnce = false;
        Contact aC = new Contact(LastName = 'Test', Phone='+33574543241',Tel_Fixe_Principal__c='Tel Fixe 1', Id_Tiers__c = 12345);
        insert aC;
        
        aC.Tel_Fixe_2__c='+33574543245';
        aC.Tel_Fixe_Principal__c='Tel Fixe 2';
        update aC;
        List<Contact> contactCheck=[select EmailPrincipalValueRW__c,Adresse_Mail_3__c,MobilePrincipalValueRW__c,Mobile_2__c,TelFixePrincipalValueRW__c,Phone from Contact where LastName='Test' Limit 1];        

        System.assertEquals(contactCheck[0].TelFixePrincipalValueRW__c, '+33574543245');
        
        //test Run Once
        aC.Tel_Fixe_3__c='+33574543247';
        aC.Tel_Fixe_Principal__c='Tel Fixe 3';
        update aC;
        
        List<Contact> contactCheck2=[select EmailPrincipalValueRW__c,Adresse_Mail_3__c,MobilePrincipalValueRW__c,Mobile_2__c,TelFixePrincipalValueRW__c,Phone from Contact where LastName='Test' Limit 1];        

        System.assertEquals(contactCheck2[0].TelFixePrincipalValueRW__c, '+33574543247');
    }
}