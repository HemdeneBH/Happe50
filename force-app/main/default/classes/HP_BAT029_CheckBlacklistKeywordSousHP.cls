/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 01-31-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
global class HP_BAT029_CheckBlacklistKeywordSousHP implements Database.Batchable<sObject>, Schedulable {

    public HP_WRP048_KeywordsBlackList blacklist;

    public HP_BAT029_CheckBlacklistKeywordSousHP() {
        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'HP_keywords_blacklist' LIMIT 1];
        String body = sr.Body.toString();
        blacklist = HP_WRP048_KeywordsBlackList.parse(body);
    }

    global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT029_CheckBlacklistKeywordSousHP());
    }

    global static void execute(SchedulableContext sc){
		execute();
	}

    public static void execute(){
		HP_BAT029_CheckBlacklistKeywordSousHP checkBlacklistKeywordsOnSouscriptionsHappe = new HP_BAT029_CheckBlacklistKeywordSousHP();
		Database.executeBatch(checkBlacklistKeywordsOnSouscriptionsHappe);
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            [   SELECT ID, HP_Presence_mot_interdit__c, commentaire__c, HP_Revision_Document__c FROM HP_Souscription__c
                WHERE HP_Presence_mot_interdit__c != 'Pas de mot interdit'
            ]
        );
    }

    public void execute(Database.BatchableContext bc, List<HP_Souscription__c> souscriptions){
        for (HP_Souscription__c s : souscriptions) {
            for(HP_WRP048_KeywordsBlackList.KeywordBlackList k: blacklist.keywordBlackList) {   
                if(
                    (s.commentaire__c != null && (s.commentaire__c.contains(' '+k.keyword+' ') || s.commentaire__c.contains(' '+k.keyword+';') || s.commentaire__c.contains(' '+k.keyword+'.') || s.commentaire__c.contains(' '+k.keyword+',') || s.commentaire__c.equalsIgnoreCase(k.keyword)))
                     || 
                    (s.HP_Revision_Document__c != null && (s.HP_Revision_Document__c.contains(' '+k.keyword+' ') || s.HP_Revision_Document__c.contains(' '+k.keyword+';') || s.HP_Revision_Document__c.contains(' '+k.keyword+'.') || s.HP_Revision_Document__c.contains(' '+k.keyword+',') || s.HP_Revision_Document__c.equalsIgnoreCase(k.keyword)))
                ){
                    s.HP_Presence_mot_interdit__c = 'Mot interdit trouvé';break;
                } else {
                    s.HP_Presence_mot_interdit__c = 'Pas de mot interdit';
                }               
            }
        }
        update souscriptions;
    }

    public void finish(Database.BatchableContext bc){
        System.debug('Souscriptions Happe checked!');
    }
}