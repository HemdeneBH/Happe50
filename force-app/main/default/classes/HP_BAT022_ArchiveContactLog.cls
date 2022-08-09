/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 

 * @last modified on  : 05-20-2021

 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   05-10-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/



global with sharing  class HP_BAT022_ArchiveContactLog implements Database.batchable<sObject>, Schedulable, Database.RaisesPlatformEvents,Database.AllowsCallouts,Database.stateful,  HP_UTIL_BatchInterface{

    public static final Integer BATCH_CHUNK_SIZE = 200;
    global static Id idClient;
    Id myIdContact ;


    global HP_BAT022_ArchiveContactLog(Id idContact) {
        System.debug('idContact.id constructo before**********'+ idContact);
        System.debug('idContact.id constructo before2**********'+ myIdContact);


        myIdContact = idContact;
        System.debug('idContact.id constructo after**********'+ idContact);
        System.debug('idContact.id constructo after2**********'+ myIdContact);

    }


    global HP_BAT022_ArchiveContactLog() {
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        List<Contact> cont = [select id,AccountId, name from contact where name ='Tel Sans Contact Diabolocom'];
        System.debug('cont start :'+cont);
        if(cont.size() >0) idClient = cont[0].Id;
        return Database.getQueryLocator(
            [select Id from case where ( HP_isHappe__c = true  and ContactId =:cont[0].Id)]
        );


    }

    global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT022_ArchiveContactLog());
    }

    global static void execute(SchedulableContext sc){
        execute();
    }

    global static void execute(){




       List<Contact> cont = [select id,AccountId, name from contact where name ='Tel Sans Contact Diabolocom'];
       System.debug('cont :'+cont);
       if(cont.size() == 0 ) return;
       idClient = cont[0].Id;
       System.debug('idClient  apres :'+ idClient);

       Integer numerCountTask =  [SELECT count() FROM Task WHERE WhoId =: idClient ];
       System.debug('numerCountTask :'+numerCountTask);

        Integer numerCount = [select count()   from case where ContactId =:idClient and HP_isHappe__c = true ];
        System.debug('numerCount :'+numerCount);

        Boolean isLimitReached = Test.isRunningTest() ? true : ((numerCountTask + numerCount) >= 9000 );

        isLimitReached = true;
        System.debug('isLimitReached :'+ isLimitReached);
       if(isLimitReached){
           //
           Contact con = new Contact( firstName = 'Tel Sans Contact', LastName = 'Diabolocom'+ Datetime.now(), HP_IsHappe__c = true, AccountId=cont[0].AccountId);
           insert con;
           HP_BAT022_ArchiveContactLog archiveContact = new HP_BAT022_ArchiveContactLog(con.Id);
           System.debug('con.id**********'+ con.Id);


            Database.executeBatch(archiveContact, BATCH_CHUNK_SIZE);
        }
    }

    public void execute(Database.BatchableContext bc, List<case> cases) { 
        System.debug('cases  size'+ cases.size());

        System.debug('myIdContact***'+ myIdContact);

        HP_SM61_ArchiveContactLog.archiveContact(cases, myIdContact);

    }

    global void finish(Database.BatchableContext bc){
        System.debug('myIdContact  :' + myIdContact);
        HP_BAT023_ArchiveTaskLog.execute(myIdContact);


    }   
}