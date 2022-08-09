/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 02-07-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
global class HP_BAT031_CreateAccountForContact implements Database.Batchable<sObject>, Schedulable {

    global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT031_CreateAccountForContact());
    }

    global static void execute(SchedulableContext sc){
		execute();
	}

    public static void execute(){
		HP_BAT031_CreateAccountForContact createAccountForContactBatch = new HP_BAT031_CreateAccountForContact();
		Database.executeBatch(createAccountForContactBatch);
    }

    private static final Id HP_ACCOUNT_TYPE_ID = HP_UTIL_RecordType.getRecordTypeId('Account','HP_Account');
    private static final Id HP_CONTACT_TYPE_ID = HP_UTIL_RecordType.getRecordTypeId('Contact','HP_Contact');
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        Set<Id> recordTypes = new Set<Id>{ HP_CONTACT_TYPE_ID };

        return Database.getQueryLocator(
            [   
                SELECT  ID, ID_Tiers__c, FirstName, LastName, AccountId
                FROM    Contact
                WHERE   RecordTypeId IN :recordTypes
                AND     AccountId = ''
                AND     ID_Tiers__c != null
            ]
        );
    }

    public void execute(Database.BatchableContext bc, List<Contact> contacts){
        System.debug('***List of contacts***, size:'+contacts.size()+', list:'+contacts);
        List<Account> accounts = new List<Account>();
        for (Contact c : contacts) {
            Account newAccount = new Account();
            newAccount.Name =  c.FirstName + ' ' + c.LastName;
            newAccount.HP_XDataExternalId__c = c.ID_Tiers__c;
            newAccount.RecordTypeId = HP_ACCOUNT_TYPE_ID;
            accounts.add(newAccount);
        }
        insert accounts;

        System.debug('***List of new accounts created***,\n size:'+accounts.size()+',\n list:'+accounts);
        for (Contact c : contacts) {
            c.AccountId = getAccountIdByXDataExternalId(c.ID_Tiers__c, accounts);
        }
        update contacts;
        System.debug('***List of contacts attached with an account***,\n size:'+contacts.size()+',\n list:'+contacts);
    }

    public void finish(Database.BatchableContext bc){
        System.debug('HP_BAT031_CreateAccountForContact Finished !');
    }

    private Id getAccountIdByXDataExternalId(Decimal xDataExternalId, List<Account> accounts) {
        for (Account a : accounts) {
            if (a.HP_XDataExternalId__c == XDataExternalId) {
                return a.Id;
            }
        }
        return null;
    }
}