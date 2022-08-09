/*
* @Author: Lahoucine Ikerchalene
* @Date: 18/06/2020
* @Description: Test Class for SM_AP89_SendMail
*/
@isTest
public class SM_AP89_SendMail_Test {
  
    @TestSetup
    static void setup() {
        Contact con = new Contact();
        // A REVOIR
        con.RecordTypeId = [SELECT Id FROM RecordType WHERE isActive = true AND SobjectType = 'Contact' AND DeveloperName = 'Contact_Smile'].Id; 
        con.FirstName = 'Test';
        con.LastName = 'Test';
        con.Mobile_Principal__c = 'Mobile 1';
        con.MobilePhone = '+33600000000';
        insert con;
    }

    @isTest
    static void sendingMail_1() {
        SM_OCTOPUS__c orgSettings = new SM_OCTOPUS__c();
        orgSettings.certName__c = 'smilecert';
        insert orgSettings;
        
        List<Contact> listCon = [Select id From Contact limit 1];
        List<Id> listIds = new List<Id>();
        listIds.add(listCon[0].id);
        
        Test.setMock(HttpCalloutMock.class, new SM_AP86_SendSMS_Mock());
        Test.startTest();
            SM_AP89_SendMail.sendingMail_1(listIds);
        Test.stopTest();
    }

}