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

@isTest
public class HP_BAT023_ArchiveTaskLog_TEST {
    
    @isTest static void HP_BAT023_ArchiveTaskLog_TEST_Schedule() {
        Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', null, new Map<String, Object> {
            'LastName' => 'Diabolocom',
            'firstName' => 'Tel Sans Contact',
            'Email' => 'test@gmail.com',
            'Id_Tiers__c' => 1313
                }, null, null,null);
        insert contact;

        Case aCase = (Case) HP_UTIL_SmartFactory.createSObject('Case', new Map<String, Object> {'Status' => HP_SLCT_Case.Status.HP_PENDING.name(),
        'OwnerId' => UserInfo.getUserId(),
        'ContactId' => contact.Id}, null);
        insert aCase;
        
        Task tsk = (Task)HP_UTIL_SmartFactory.createSObject('Task', null, new Map<String, Object> {
				'WhoId' => contact.Id,
                'whatId' => aCase.Id			
            }, null, null,null);
            insert tsk;
            List<Contact>  contacts = [select id from Contact ];
        Test.startTest();
        final String jobName = 'HP_BAT021_ArchiveContactLog';
        final String cronExp = '0 0 4 ? * * *';
        HP_BAT023_ArchiveTaskLog.execute(contacts[0].id);
        Test.stopTest();
    }
    
}