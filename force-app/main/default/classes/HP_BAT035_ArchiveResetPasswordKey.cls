/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 05-06-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
global class HP_BAT035_ArchiveResetPasswordKey implements Database.Batchable<SObject>, Database.AllowsCallouts, Schedulable{
    public static final Integer BATCH_CHUNK_SIZE = 50;
    public static final String PASSWORD_LIMIT = 'HP_Password_Limit';

    @TestVisible
    public static Integer passwordLimit {
        get{
            if(passwordLimit == null){
                passwordLimit = Integer.valueOf(HP_UTIL_MetadataManager.getConfigByKey(PASSWORD_LIMIT));
            }
            return passwordLimit;
        }
        private set;
    }

	global Database.QueryLocator start(Database.BatchableContext batchableContext){
        return Database.getQueryLocator(
            [   
                SELECT  Id, Reset_Password_Key__c
                FROM    HP_Community_User__c
                WHERE   Reset_Password_Key__c != NULL
                AND Reset_Password_Count__c > :passwordLimit 
            ]
        );
        
	}

	global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT035_ArchiveResetPasswordKey());
	}

	global static void execute(SchedulableContext sc){
		execute();
	}

	global static void execute(){
		HP_BAT035_ArchiveResetPasswordKey passwordKeyBatch = new HP_BAT035_ArchiveResetPasswordKey();
		Database.executeBatch(passwordKeyBatch, BATCH_CHUNK_SIZE);
	}

    global void execute(Database.BatchableContext batchableContext, List<HP_Community_User__c> communityUserLoginList){
        System.debug('HP_BAT035_ArchiveResetPasswordKey.execute | Method Start');
        if(communityUserLoginList.isEmpty()){
            return;
        }
        for(HP_Community_User__c communityUserLogin : communityUserLoginList){
            communityUserLogin.Reset_Password_Key__c = null;
        }
        update communityUserLoginList;
        System.debug('HP_BAT035_ArchiveResetPasswordKey.execute | Method Exit');
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('HP_BAT035_ArchiveResetPasswordKey.finish');
	}
}