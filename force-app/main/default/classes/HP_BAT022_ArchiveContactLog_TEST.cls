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
public class HP_BAT022_ArchiveContactLog_TEST {
    
    @isTest static void HP_BAT021_ArchiveContactLog_TEST_Schedule() {
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
        
        Test.startTest();
        final String jobName = 'HP_BAT021_ArchiveContactLog';
        final String cronExp = '0 0 4 ? * * *';
        HP_BAT022_ArchiveContactLog.launchNewScheduler(cronExp,jobName);
        Test.stopTest();
    }
    
}