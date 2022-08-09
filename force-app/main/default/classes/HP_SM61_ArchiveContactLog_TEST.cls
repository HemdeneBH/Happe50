/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 

 * @last modified on  : 05-18-2021

 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   05-10-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/

@IsTest
public with sharing class HP_SM61_ArchiveContactLog_TEST {

   

    @isTest
    public static void archiveContact() {
       
      
			Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', null, new Map<String, Object> {

            'LastName' => 'Diabolocom',
            'firstName' => 'Tel Sans Contact',

				'Email' => 'test@gmail.com',
				'Id_Tiers__c' => 1313
			}, null, null,null);
            insert contact;
            
            System.debug('contact test :'+ contact);

            Case aCase = (Case) HP_UTIL_SmartFactory.createSObject('Case', new Map<String, Object> {'Status' => HP_SLCT_Case.Status.HP_PENDING.name(),
            'OwnerId' => UserInfo.getUserId(),
            'ContactId' => contact.Id}, null);
            insert aCase;

            System.debug('aCase  test:'+ aCase);
        


            List<case>  cases = [select id, ContactId from case ];
            Test.startTest();
            HP_SM61_ArchiveContactLog.archiveContact(cases, contact.Id);

            Test.stopTest();

    }

}