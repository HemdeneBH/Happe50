/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 01-31-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
global class HP_BAT028_CheckBlacklistKeywordEmailMsg implements Database.Batchable<sObject>, Schedulable {

    public HP_WRP048_KeywordsBlackList blacklist;

    public HP_BAT028_CheckBlacklistKeywordEmailMsg() {
        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'HP_keywords_blacklist' LIMIT 1];
        String body = sr.Body.toString();
        blacklist = HP_WRP048_KeywordsBlackList.parse(body);
    }

    global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT028_CheckBlacklistKeywordEmailMsg());
    }

    global static void execute(SchedulableContext sc){
		execute();
	}

    public static void execute(){
		HP_BAT028_CheckBlacklistKeywordEmailMsg checkBlacklistKeywordsOnEmailMessagesBatch = new HP_BAT028_CheckBlacklistKeywordEmailMsg();
		Database.executeBatch(checkBlacklistKeywordsOnEmailMessagesBatch);
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            [   SELECT ID, HP_Presence_mot_interdit__c, Subject, TextBody, HP_isHappe__c FROM EmailMessage
                WHERE HP_Presence_mot_interdit__c != 'Pas de mot interdit'
            ]
        );
    }

    public void execute(Database.BatchableContext bc, List<EmailMessage> emailMessages){
        for (EmailMessage e : emailMessages) {
            for(HP_WRP048_KeywordsBlackList.KeywordBlackList k: blacklist.keywordBlackList) {   
                if(
                    (e.Subject != null && (e.Subject.contains(' '+k.keyword+' ') || e.Subject.contains(' '+k.keyword+';') || e.Subject.contains(' '+k.keyword+'.') || e.Subject.contains(' '+k.keyword+',') || e.Subject.equalsIgnoreCase(k.keyword)))
                     || 
                    (e.TextBody != null && (e.TextBody.contains(' '+k.keyword+' ') || e.TextBody.contains(' '+k.keyword+';') || e.TextBody.contains(' '+k.keyword+'.') || e.TextBody.contains(' '+k.keyword+',') || e.TextBody.equalsIgnoreCase(k.keyword)))
                ){
                    e.HP_Presence_mot_interdit__c = 'Mot interdit trouvé';break;
                } else {
                    e.HP_Presence_mot_interdit__c = 'Pas de mot interdit';
                }               
            }
        }
        update emailMessages;
    }

    public void finish(Database.BatchableContext bc){
        System.debug('EmailMessages checked!');
    }
}