/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 01-31-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
global class HP_BAT026_CheckBlacklistKeywordOnCases implements Database.Batchable<sObject>, Schedulable {

    public HP_WRP048_KeywordsBlackList blacklist;

    public HP_BAT026_CheckBlacklistKeywordOnCases() {
        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'HP_keywords_blacklist' LIMIT 1];
        String body = sr.Body.toString();
        blacklist = HP_WRP048_KeywordsBlackList.parse(body);
    }

    global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT026_CheckBlacklistKeywordOnCases());
    }

    global static void execute(SchedulableContext sc){
		execute();
	}

    public static void execute(){
		HP_BAT026_CheckBlacklistKeywordOnCases checkBlacklistKeywordsOnCasesBatch = new HP_BAT026_CheckBlacklistKeywordOnCases();
		Database.executeBatch(checkBlacklistKeywordsOnCasesBatch);
    }
    

    public Database.QueryLocator start(Database.BatchableContext bc) {
        Set<Id> recordTypes = new Set<Id>{ 
            HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_ContractCancelationCase'),
            HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Mail'),
            HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone'),
            HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Chat'),
            HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_CaseRecontact'),
            HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_EnrolmentCase'),
            HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_PrestationDistributeur'),
            HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Mediation_Reclamation'),
            HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_ContractErrorSave3')};

        DateTime before15days = datetime.now().addDays(-15);

        return Database.getQueryLocator(
            [   SELECT ID, HP_Presence_mot_interdit__c, Subject, Description, HP_Comment__c, HP_RaisonDetailleeEscalade__c, HP_ContDemApprobation__c, HP_reponseApprobation__c, Motif__c
                FROM Case
                WHERE HP_Presence_mot_interdit__c != 'Pas de mot interdit'
                AND closedDate  <= :before15days
                AND RecordTypeId IN :recordTypes
            ]
        );
    }

    public void execute(Database.BatchableContext bc, List<Case> cases){
        for (Case c : cases) {
                for(HP_WRP048_KeywordsBlackList.KeywordBlackList k: blacklist.keywordBlackList) {   
                    if(
                        (c.Subject != null && (c.Subject.contains(' '+k.keyword+' ') || c.Subject.contains(' '+k.keyword+';') || c.Subject.contains(' '+k.keyword+'.') || c.Subject.contains(' '+k.keyword+',') || c.Subject.equalsIgnoreCase(k.keyword)))
                         || 
                        (c.Description != null && (c.Description.contains(' '+k.keyword+' ') || c.Description.contains(' '+k.keyword+';') || c.Description.contains(' '+k.keyword+'.') || c.Description.contains(' '+k.keyword+',') || c.Description.equalsIgnoreCase(k.keyword)))
                         || 
                        (c.HP_Comment__c != null && (c.HP_Comment__c.contains(' '+k.keyword+' ') || c.HP_Comment__c.contains(' '+k.keyword+';') || c.HP_Comment__c.contains(' '+k.keyword+'.') || c.HP_Comment__c.contains(' '+k.keyword+',') || c.HP_Comment__c.equalsIgnoreCase(k.keyword)))
                         || 
                        (c.HP_RaisonDetailleeEscalade__c != null && (c.HP_RaisonDetailleeEscalade__c.contains(' '+k.keyword+' ') || c.HP_RaisonDetailleeEscalade__c.contains(' '+k.keyword+';') || c.HP_RaisonDetailleeEscalade__c.contains(' '+k.keyword+'.') || c.HP_RaisonDetailleeEscalade__c.contains(' '+k.keyword+',') || c.HP_RaisonDetailleeEscalade__c.equalsIgnoreCase(k.keyword)))
                         || 
                        (c.HP_ContDemApprobation__c != null && (c.HP_ContDemApprobation__c.contains(' '+k.keyword+' ') || c.HP_ContDemApprobation__c.contains(' '+k.keyword+';') || c.HP_ContDemApprobation__c.contains(' '+k.keyword+'.') || c.HP_ContDemApprobation__c.contains(' '+k.keyword+',') || c.HP_ContDemApprobation__c.equalsIgnoreCase(k.keyword)))
                         || 
                        (c.HP_reponseApprobation__c != null && (c.HP_reponseApprobation__c.contains(' '+k.keyword+' ') || c.HP_reponseApprobation__c.contains(' '+k.keyword+';') || c.HP_reponseApprobation__c.contains(' '+k.keyword+'.') || c.HP_reponseApprobation__c.contains(' '+k.keyword+',') || c.HP_reponseApprobation__c.equalsIgnoreCase(k.keyword)))
                         || 
                        (c.Motif__c != null && (c.Motif__c.contains(' '+k.keyword+' ') || c.Motif__c.contains(' '+k.keyword+';') || c.Motif__c.contains(' '+k.keyword+'.') || c.Motif__c.contains(' '+k.keyword+',') || c.Motif__c.equalsIgnoreCase(k.keyword)))
                    ){
                        c.HP_Presence_mot_interdit__c = 'Mot interdit trouvé';break;
                    } else {
                        c.HP_Presence_mot_interdit__c = 'Pas de mot interdit';
                    }               
                }
        }
        update cases;
    }

    public void finish(Database.BatchableContext bc){
        System.debug('Cases checked!');
    }
    
}