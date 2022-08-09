/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 05-06-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
global class HP_BAT034_ArchiveActivationKey implements Database.Batchable<SObject>, Database.AllowsCallouts, Schedulable{
    public static final Integer BATCH_CHUNK_SIZE = 50;
    public static final String ACTIVATION_LIMIT = 'HP_Activation_Limit';

    @TestVisible
    public static Integer activationLimit {
        get{
            if(activationLimit == null){
                activationLimit = Integer.valueOf(HP_UTIL_MetadataManager.getConfigByKey(ACTIVATION_LIMIT));
            }
            return activationLimit;
        }
        private set;
    }

	global Database.QueryLocator start(Database.BatchableContext batchableContext){
        return Database.getQueryLocator(
            [   
                SELECT  Id, Activation_Key__c
                FROM    HP_Community_User__c
                WHERE   Activation_Key__c != NULL
                AND Activation_Count__c > :activationLimit 
            ]
        );
        
	}

	global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT034_ArchiveActivationKey());
	}

	global static void execute(SchedulableContext sc){
		execute();
	}

	global static void execute(){
		HP_BAT034_ArchiveActivationKey activationKeyBatch = new HP_BAT034_ArchiveActivationKey();
		Database.executeBatch(activationKeyBatch, BATCH_CHUNK_SIZE);
	}

    global void execute(Database.BatchableContext batchableContext, List<HP_Community_User__c> communityUserLoginList){
        System.debug('HP_BAT034_ArchiveActivationKey.execute | Method Start');
        if(communityUserLoginList.isEmpty()){
            return;
        }
        for(HP_Community_User__c communityUserLogin : communityUserLoginList){
            communityUserLogin.Activation_Key__c = null;
        }
        update communityUserLoginList;
        System.debug('HP_BAT034_ArchiveActivationKey.execute | Method Exit');
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('HP_BAT034_ArchiveActivationKey.finish');
	}

}