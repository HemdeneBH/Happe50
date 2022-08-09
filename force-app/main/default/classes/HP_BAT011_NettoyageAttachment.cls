global with sharing class HP_BAT011_NettoyageAttachment implements  Database.Batchable<SObject>, Schedulable, Database.RaisesPlatformEvents, HP_UTIL_BatchInterface {
    
    public static final Integer BATCH_CHUNK_SIZE = 100;
    private static Integer HP_LIMITE_JOUR_ATTACHMENT = Integer.valueOf(HP_UTIL_MetadataManager.getConfigByKey('HP_LIMITE_JOUR_ATTACHMENT'));

    global final  String query = 'Select Id ,Name, ParentId,CreatedDate from Attachment where (Name like \'compteur_%\' AND Parent.Type = \'HP_Souscription__c\' AND  CreatedDate < LAST_N_DAYS:' + HP_LIMITE_JOUR_ATTACHMENT +')';  
           
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global static void launchNewScheduler(String schedule, String jobName){
        
		System.schedule(jobName, schedule, new HP_BAT011_NettoyageAttachment());
    }

    global static void execute(SchedulableContext sc){
        execute();
    }
    
    global static void execute(){
        HP_BAT011_NettoyageAttachment batchNettoyage = new HP_BAT011_NettoyageAttachment();
        Database.executeBatch(batchNettoyage, BATCH_CHUNK_SIZE);
    }
    global void execute(Database.BatchableContext bc, List<Attachment> hpAttachments) { 
        System.debug('*******list attachment:***'+hpAttachments);
        delete hpAttachments;
       
    }
    global void finish(Database.BatchableContext bc){
        
    }


}