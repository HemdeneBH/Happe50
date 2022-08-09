/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 01-31-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
global class HP_BAT027_CheckBlacklistKeywordOnTasks implements Database.Batchable<sObject>, Schedulable {

    public HP_WRP048_KeywordsBlackList blacklist;

    public HP_BAT027_CheckBlacklistKeywordOnTasks() {
        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'HP_keywords_blacklist' LIMIT 1];
        String body = sr.Body.toString();
        blacklist = HP_WRP048_KeywordsBlackList.parse(body);
    }

    global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT027_CheckBlacklistKeywordOnTasks());
    }

    global static void execute(SchedulableContext sc){
		execute();
	}

    public static void execute(){
		HP_BAT027_CheckBlacklistKeywordOnTasks checkBlacklistKeywordsOnTasksBatch = new HP_BAT027_CheckBlacklistKeywordOnTasks();
		Database.executeBatch(checkBlacklistKeywordsOnTasksBatch);
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        Set<Id> recordTypes = new Set<Id>{ 
            HP_UTIL_RecordType.getRecordTypeId('Task', 'HP_ChatTask'),
            HP_UTIL_RecordType.getRecordTypeId('Task', 'HP_Task')};

        return Database.getQueryLocator(
            [  
                SELECT ID, HP_Presence_mot_interdit__c, Subject, Description FROM Task
                WHERE HP_Presence_mot_interdit__c != 'Pas de mot interdit'
                AND RecordTypeId IN :recordTypes
            ]
        );
    }

    public void execute(Database.BatchableContext bc, List<Task> tasks){
        for (Task t : tasks) {
            for(HP_WRP048_KeywordsBlackList.KeywordBlackList k: blacklist.keywordBlackList) {   
                if(
                    (t.Subject != null && (t.Subject.contains(' '+k.keyword+' ') || t.Subject.contains(' '+k.keyword+';') || t.Subject.contains(' '+k.keyword+'.') || t.Subject.contains(' '+k.keyword+',') || t.Subject.equalsIgnoreCase(k.keyword)))
                     || 
                    (t.Description != null && (t.Description.contains(' '+k.keyword+' ') || t.Description.contains(' '+k.keyword+';') || t.Description.contains(' '+k.keyword+'.') || t.Description.contains(' '+k.keyword+',') || t.Description.equalsIgnoreCase(k.keyword)))
                ){
                    t.HP_Presence_mot_interdit__c = 'Mot interdit trouvé';break;
                } else {
                    t.HP_Presence_mot_interdit__c = 'Pas de mot interdit';
                }               
            }
        }
        update tasks;
    }

    public void finish(Database.BatchableContext bc){
        System.debug('Tasks checked!');
    }

}