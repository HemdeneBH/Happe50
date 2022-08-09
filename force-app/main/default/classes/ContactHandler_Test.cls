/*
* @Author: khalil OUKIL
* @Date: 11/03/2022
* @Description:classe de test de ContactHandler
*/
@isTest
public class ContactHandler_Test {
    
    private enum StaticResource {
        HP_SM020_SouscriptionSave1_TEST
            }
    
    @testSetup static void dataSetup() {  
        Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', null, new Map<String, Object> {
            'FirstName' => 'Contact FirstName',
                'LastName' => 'Contact Test',
                'Phone' => '+33664345465',
                'Email' => 'test@gmail.com',
                'Id_Tiers__c' => 1313}, null, null,null);
        insert contact;
        
    }
     @istest static void doesContactExist_TEST() {
        Contact cc = [select Id,Email from Contact where Id_Tiers__c = 1313];
       Test.startTest();
       Id idContact = ContactHandler.doesContactExist('Email',(String)cc.Email);
       Test.stopTest();
       system.assert(String.isNotBlank(idContact));
    }
    @istest static void doesContactExistByEmail_TEST() {
        Contact cc = [select Id,Email from Contact where Id_Tiers__c = 1313];
        Test.startTest();
        Id idContact = ContactHandler.doesContactExistByEmail(cc.Email);
        Test.stopTest();
        system.assert(String.isNotBlank(idContact));

    }
    @istest static void doesContactExistByPhone_TEST() {
        Contact cc = [select Id,Phone from Contact where Id_Tiers__c = 1313];
        Test.startTest();
        Id idContact = ContactHandler.doesContactExistByPhone(cc.Phone);
        Test.stopTest();
        system.assert(String.isNotBlank(idContact));
    }
    
}