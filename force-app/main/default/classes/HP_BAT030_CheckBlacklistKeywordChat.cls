/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 01-31-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
global class HP_BAT030_CheckBlacklistKeywordChat implements Database.Batchable<sObject>, Schedulable {

    public HP_WRP048_KeywordsBlackList blacklist;

    public HP_BAT030_CheckBlacklistKeywordChat() {
        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'HP_keywords_blacklist' LIMIT 1];
        String body = sr.Body.toString();
        blacklist = HP_WRP048_KeywordsBlackList.parse(body);
    }

    global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT030_CheckBlacklistKeywordChat());
    }

    global static void execute(SchedulableContext sc){
		execute();
	}

    public static void execute(){
		HP_BAT030_CheckBlacklistKeywordChat checkBlacklistKeywordsOnChatTranscript = new HP_BAT030_CheckBlacklistKeywordChat();
		Database.executeBatch(checkBlacklistKeywordsOnChatTranscript);
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            [   SELECT ID, HP_Presence_mot_interdit__c, Body, Status FROM LiveChatTranscript
                WHERE HP_Presence_mot_interdit__c != 'Pas de mot interdit'
                And Status = 'Completed'
            ]
        );
    }

    public void execute(Database.BatchableContext bc, List<LiveChatTranscript> chatTranscripts){
        for (LiveChatTranscript c : chatTranscripts) {
            for(HP_WRP048_KeywordsBlackList.KeywordBlackList k: blacklist.keywordBlackList) {
                if (c.Body != null && (c.Body.contains(' '+k.keyword+' ') || c.Body.contains(' '+k.keyword+';') || c.Body.contains(' '+k.keyword+'.') || c.Body.contains(' '+k.keyword+',') || c.Body.equalsIgnoreCase(k.keyword))) {
                    c.HP_Presence_mot_interdit__c = 'Mot interdit trouvé';break;
                } else {
                    c.HP_Presence_mot_interdit__c = 'Pas de mot interdit';
                }               
            }
        }
        update chatTranscripts;
    }

    public void finish(Database.BatchableContext bc){
        System.debug('Live Chat Transcripts checked!');
    }
}