/**
 * @File Name          : HP_BAT003_Resiliation.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Hemdene Ben Hammouda
 * @Last Modified On   : 08-31-2021
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    27/02/2020   Vincent Albiser     Initial Version
**/
global class HP_BAT003_Resiliation implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable, Database.RaisesPlatformEvents, HP_UTIL_BatchInterface {

	public static final String SF20 = 'SF20';
	public static final String INDEX_ASK = 'Relevé de compteur manquant - demande sur index estimé';
	public static final Integer BATCH_CHUNK_SIZE = 1;

	// the query that will get the list of termination cases to process
	global final String Query = 'SELECT Id, Status, HP_EffectiveDate__c, HP_index_gaz__c, HP_index_elec_base__c, HP_index_elec_hp__c, HP_CompteurCommunicant__c, Subject, ' +
								'Contact.Email, Contact.firstname, Contact.lastname, Contact.salutation, Contact.Id_Tiers__c, HP_Energy__c '+
								'FROM Case ' +
								'WHERE Status IN (\'' + HP_SLCT_Case.Status.NEW_CASE.name() + '\', \'' + HP_SLCT_Case.Status.HP_PENDING.name() + '\') ' +
								'AND RecordType.DeveloperName = \'' + 'HP_ContractCancelationCase' + '\'';

	// the key dates to separate the processing of the cases
	private final Integer processingDeadline = 6;
	private final Integer temperateDeadline = 10;

	// start the batch by requesting the cases and the appropriate sub-objects
	global Database.QueryLocator start(Database.BatchableContext bc) {
	System.debug('@@Qery '+this.Query);
		return Database.getQueryLocator(Query);
	}

	global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT003_Resiliation());
	}

	global static void execute(SchedulableContext sc){
        execute();
	}

	global static void execute(){
        HP_BAT003_Resiliation resiliationBatch = new HP_BAT003_Resiliation();
		Database.executeBatch(resiliationBatch, BATCH_CHUNK_SIZE); 
	}

	// batch execute
	global void execute(Database.BatchableContext bc, List<Case> scope){

		// the list of Tasks to assign to the users
		List<Task> scheduledTaskList = new List<Task>();

		// loop over the list of cases to process
		for (Case ca : scope) {

			System.debug(ca);

			Boolean isIndexKnown = (ca.HP_index_gaz__c!= null || ca.HP_index_elec_base__c != null || ca.HP_index_elec_hp__c!= null); // is the index known
			Boolean isSmartMeter = ca.HP_CompteurCommunicant__c; // is it a SmartMeter (Compteur communicant)
			Date terminationDate = ca.HP_EffectiveDate__c; // The termination date of the contract as asked by the customer
			Date todayDate = date.today(); // Today's date
			String indexResil = isIndexKnown?'true':'false';
			// The index is known
			if (isIndexKnown) {
				// schedule case to cancelation effective date
				scheduleCase(ca, scheduledTaskList);
			}
			// The index is unknown
			else {
				// The termination date of the contract is in less than 6 days
				if (date.today().daysBetween(terminationDate) < this.processingDeadline) {
					// schedule case to cancelation effective date
					scheduleCase(ca, scheduledTaskList);
					// This is not a Smart Meter

					if (!isSmartMeter) {
						// send email to notify the use of estimated index
						//sendEmailEstimatedIndex(ca);
						HP_SM010_SendMailWhenCancellation.sendMailViaCabestanSync(
							ca.Contact.email,
							String.valueOf(ca.Contact.Id_Tiers__c),
							ca.Contact.salutation,
							ca.Contact.lastname,
							ca.Contact.firstname,
							ca.HP_Energy__c == 'Electricity' ? 'electricite' : 'gaz',
							SF20,
							INDEX_ASK,
							null,
							null
							);
					}
				}
				// The termination date of the contract is in at least 6 days
				else {
					if (ca.Status != HP_SLCT_Case.Status.HP_PENDING.name()) {
						// This is a Smart Meter
						if (isSmartMeter) {
							// set the case to pending (until D-5 to effective date)
							ca.Status = HP_SLCT_Case.Status.HP_PENDING.name();
						}
						else if (date.today().daysBetween(terminationDate) <= this.temperateDeadline) {
							// send email to ask for the index
							//sendEmailAskIndex(ca);

							// set the case to pending (until D-5 to effective date)
							ca.Status = HP_SLCT_Case.Status.HP_PENDING.name();
						}
					}
				}
			}
		}
		// insert the list of tasks and the list of cases
		insert scheduledTaskList;
		update scope;

	}

	// method that schedule the case by creating a related Task for the processing date
	private void scheduleCase(Case ca, List<Task> scheduledTaskList) {
		scheduledTaskList.add(new Task(WhatId=ca.Id, ActivityDate=date.today(), Subject='Résiliation'));
		ca.Status = HP_SLCT_Case.Status.TO_DO.name();
	}
/*
	// send an email to advise the use of estimated index
	private void sendEmailEstimatedIndex(Case ca) {

	}

	// send and email to ask for the index
	private void sendEmailAskIndex(Case ca) {

	}
*/
	global void finish(Database.BatchableContext bc){
		
	}

}