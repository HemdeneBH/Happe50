/**
 * @description       : 
 * @author            : Vincent Albiser
 * @group             : 
 * @last modified on  : 10-09-2020
 * @last modified by  : Vincent Albiser
 * Modifications Log 
 * Ver   Date         Author            Modification
 * 1.0   10-09-2020   Vincent Albiser   Initial Version
**/

global with sharing class HP_BAT012_UserProductivity implements  Database.Batchable<SObject>, Schedulable, Database.RaisesPlatformEvents, HP_UTIL_BatchInterface {
    
    public static final Integer BATCH_CHUNK_SIZE = 100;
    private static Integer HP_LIMITE_JOUR_ATTACHMENT = Integer.valueOf(HP_UTIL_MetadataManager.getConfigByKey('HP_LIMITE_JOUR_ATTACHMENT'));
    private static Integer HP_LIMITE_DUREE_ATTRIBUTION = Integer.valueOf(HP_UTIL_MetadataManager.getConfigByKey('HP_LIMITE_DUREE_ATTRIBUTION'));

    private Date batchDate;

    public HP_BAT012_UserProductivity() {

        batchDate = System.now().date();
    }

    public HP_BAT012_UserProductivity(Date selectedDate) {
        batchDate = selectedDate;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {

        String query = Test.isRunningTest() ?   HP_EM042_User.getQueryLocatorCurrentUser()  : HP_EM042_User.getQueryLocatorHPUsers();
        System.debug('*******query:***'+query);
        
        return Database.getQueryLocator(query);

    }

    global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT012_UserProductivity());
    }

    global static void execute(SchedulableContext sc){
        execute();
    }
    

    global static void execute(Date selectedDate) {
        HP_BAT012_UserProductivity batchProductivity = new HP_BAT012_UserProductivity(selectedDate);

        Database.executeBatch(batchProductivity, BATCH_CHUNK_SIZE);
    }

    global static void execute(){
        HP_BAT012_UserProductivity batchProductivity = new HP_BAT012_UserProductivity();
        Database.executeBatch(batchProductivity, BATCH_CHUNK_SIZE);
    }
    global void execute(Database.BatchableContext bc, List<User> users) { 
        System.debug('*******list users:***'+users);
        //get the userHistory using the usersID
        List<Id> ids = new List<Id>();
        for(User u : users){

            ids.add(u.Id);
        }
        list<HP_CaseHistory__c> caseHistories = HP_EM036_CaseHistory.getCaseHistoryByUsers(ids,batchDate );
        System.debug('*******list caseHistories:***'+caseHistories);

        HP_SM043_UserProductivity.addUserHistory(caseHistories, HP_LIMITE_DUREE_ATTRIBUTION, batchDate);
    }


    global void finish(Database.BatchableContext bc){
        
    }

}