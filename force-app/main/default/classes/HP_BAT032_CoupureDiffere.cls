/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 03-15-2022
 * @last modified by  : Hemdene Ben Hammouda
**/

global class HP_BAT032_CoupureDiffere implements Database.Batchable<SObject>, Database.AllowsCallouts, Schedulable{
    public static final Integer BATCH_CHUNK_SIZE = 1;
    private static final String STATUT_DIFFERE = 'DELAYED_PROCESS';
    private static final String TYPE_HAPPE_COUPURE = 'HP_Coupure_ReductionPuissance';
    private static final String FACTURATION_RT = 'HP_Facturation';


	global Database.QueryLocator start(Database.BatchableContext batchableContext){
		return Database.getQueryLocator([SELECT Id FROM Case 
                                            WHERE  Status = :STATUT_DIFFERE 
                                            AND HP_TreatmentDate__c = :Date.today() 
                                            AND HP_isHappe__c = true 
                                            AND HP_Type__c = :TYPE_HAPPE_COUPURE 
                                            AND RecordType.DeveloperName = :FACTURATION_RT]);   
	}

	global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT032_CoupureDiffere());
	}

	global static void execute(SchedulableContext sc){
		execute();
	}

	global static void execute(){
		HP_BAT032_CoupureDiffere contractualizationBatch = new HP_BAT032_CoupureDiffere();
		Database.executeBatch(contractualizationBatch, BATCH_CHUNK_SIZE);
	}



	global void execute(Database.BatchableContext batchableContext, List<Case> caseList){
        System.debug('HP_BAT032_CoupureDiffere.execute | Method Start');
        List<Id> caseIdsList = new List<Id>();
        for(Case aCase : caseList){
            caseIdsList.add(aCase.Id);
        }
        if(!caseIdsList.isEmpty()){
            HP_EM054_CoupureReduction.processCoupureReduction(caseIdsList);
        }
        System.debug('HP_BAT032_CoupureDiffere.execute | Method Exit');
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('HP_BAT032_CoupureDiffere.finish');
	}
}