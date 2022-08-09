/**
 * @File Name          : HP_BAT002_Contractualisation.cls
 * @Description        :
 * @Author             : Sara El-Hannaoui
 * @Group              : 
 * @Last Modified By   : Hemdene Ben Hammouda




 * @Last Modified On   : 02-04-2022




 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    27/02/2020   Vincent Albiser     Initial Version
 **/

global class HP_BAT002_Contractualisation implements Database.Batchable<SObject>, Database.AllowsCallouts, Schedulable, Database.RaisesPlatformEvents, HP_UTIL_BatchInterface{


	public static final Integer BATCH_CHUNK_SIZE = 1;


	global Database.QueryLocator start(Database.BatchableContext batchableContext){
		return HP_SLCT_Case.retrievePendingPrestationDistributeurQueryLocator();	
	}

	global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT002_Contractualisation());
	}

	global static void execute(SchedulableContext sc){
		execute();
	}

	global static void execute(){
		HP_BAT002_Contractualisation contractualizationBatch = new HP_BAT002_Contractualisation();
		Database.executeBatch(contractualizationBatch, BATCH_CHUNK_SIZE);
	}



	global void execute(Database.BatchableContext batchableContext, List<Case> caseList){

		List<Id> oppIdList = new List<Id>();
		HP_WRP022_SFResponse response = new HP_WRP022_SFResponse(200);
		List<HP_Souscription__c> enrolmentDetailsTocancelledList = new List<HP_Souscription__c>();
		List<Case> caseTocancelledList = new List<Case>();
		List<EmailMessage> emList = new List<EmailMessage>();
		System.debug('caseList'+caseList);
		System.debug('@@@@@@bat002 : caseList size'+caseList.size());

		Map<String,List<SObject> > result;
		for (Case aCase : caseList) {
			HP_Souscription__c enrol = aCase.HP_Contrat__r.HP_Souscription__r;
			HP_Contrat__c aContrat = aCase.HP_Contrat__r;
			HP_EnergyRequest energyRequest = new HP_EnergyRequest(enrol.HP_type_Souscription__c, aContrat.HP_Id_Compteur__c,
								     (Integer)(aContrat.HP_Type_de_Compteur__c == 'GAS' ? aContrat.HP_Index_de_Compteur__c :
									 aContrat.HP_Compteur_Base_Plan_Index__c != null ?  aContrat.HP_Compteur_Base_Plan_Index__c :
									 aContrat.HP_Compteur_Variable_Plan_prix_Index__c ));
			HP_EnergyResponse energyResponse = HP_SM024_Case.precontratOCTOPUS(enrol, aContrat, energyRequest);							   
			Boolean firstCondition = aCase.HP_Contrat__r.HP_Souscription__r.HP_Date_de_Contractualisation__c == System.today().addDays(1);
			Boolean secondCondition = energyResponse.isOnsiteIntervention == false;
			Boolean thirdCondition = enrol.HP_type_Souscription__c == 'MOVING_IN';
			Boolean fourthCondition = aContrat.HP_Type_de_Compteur__c == 'GAS' ? aContrat.HP_Index_de_Compteur__c == null :
									enrol.HP_Plan_de_Prix_electrique__c =='BASE' ?  aContrat.HP_Compteur_Base_Plan_Index__c == null :
									(aContrat.HP_Compteur_Variable_Plan_prix_Index__c  == null && aContrat.HP_Compteur_Plan_Bottom_Price_Index__c == null); 
									
			System.debug('First Condition : '+firstCondition);
			System.debug('Second Condition : '+secondCondition);
			System.debug('Third Condition : '+thirdCondition);
			System.debug('Fourth Condition : '+fourthCondition);
			System.debug('Smart Meter : '+energyResponse.isSmartMeter);
			if(firstCondition && secondCondition && thirdCondition && fourthCondition && !energyResponse.isSmartMeter) {
				enrol.HP_Statut__c = 'CANCEL';
				enrol.HP_RaisonAnnulation__c = 'INDEX_NON_COMMUNIQES';
				String commentaire =  'CPV Annulées par batch le ' + DateTime.now();
				enrol.commentaire__c = commentaire;
				enrol.HP_Tech_Is_Apex_Processing__c = true;
				//enrolmentDetailsTocancelledList.add(enrol);

				aCase.status= HP_Constantes.CASE_STATUS_CANCELED;

				caseTocancelledList.add(aCase);
				if(!Test.isRunningTest()) {
					HP_Contrat__c contrat = HP_EM023_Contrat.loadContratByXdataId(Integer.valueOf(aCase.HP_Contrat__r.HP_Contrat_XdataId__c));
					EmailMessage email = HP_SendMailContratualizationService.sendMailViaCabestanSync('SF12',  contrat, response);
					if(email != null) {
						emList.Add(email);
					}
				}

				if (aCase.HP_Contrat__c != null && aCase.HP_Contrat__r.HP_Contrat_XdataId__c != null ) {
					String todayFomat = System.now().format('yyyy-MM-dd');
					HP_APIHourContractService.cancelContractSync(String.valueOf(aCase.HP_Contrat__r.HP_Contrat_XdataId__c),
										     HP_Constantes.CONTRACT_XADATA_STATUS_CANCELED, 'INACT', todayFomat);
					HP_AgilabCommercialPropositionService.updateContractSync(Integer.valueOf(aCase.HP_Contrat__r.HP_Contrat_XdataId__c), HP_Constantes.CONTRACT_AGILAB_STATUS_CANCELED, null,response);
				}
			}
			result = HP_SM024_Case.callAPIProcessing(enrol, aCase.Contact, new List<HP_Contrat__c> {aCase.HP_Contrat__r},

								 aCase.HP_Contrat__r.HP_Porte_Feuille_Contrat__r, false, response);
			
			// linky  & Gaspar: la valeur est MAJ au niveau de HP_SM024_Case.callAPIProcessing
			enrol.HP_isCommunicantElec__c = enrol.HP_isCommunicantElec__c;
			enrol.HP_isLinky__c = enrol.HP_isLinky__c;
			enrol.HP_isGaspar__c = enrol.HP_isGaspar__c;
			enrol.HP_isCommunicantGaz__c = enrol.HP_isCommunicantGaz__c ;
			System.debug('@@@@@@bat002 : HP_isCommunicantElec__c'+enrol.HP_isCommunicantElec__c);
			System.debug('@@@@@@bat002 : HP_isLinky__c'+enrol.HP_isLinky__c);
			System.debug('@@@@@@bat002 : HP_isGaspar__c'+enrol.HP_isGaspar__c);
			System.debug('@@@@@@bat002 : HP_isCommunicantGaz__c'+enrol.HP_isCommunicantGaz__c);

			enrolmentDetailsTocancelledList.add(enrol);
			System.debug('@@@@@@bat002 : enrolmentDetailsTocancelledList size '+enrolmentDetailsTocancelledList.size() );

			if(emList.size() > 0){
				insert emList;
				HP_EM019_EmailMessage.createEmailMessageRelation(emList[0],aCase.Contact);
			}
		}

		List<Case> caseListResult = (List<Case>)result.get('case');
		System.debug('@@@@@@bat002 : caseListResult '+caseListResult);

		if(caseListResult != null && caseListResult.size() > 0) {
			Database.upsert(caseListResult ,case.Fields.HP_TECH_ExternalId__c);
			System.debug('@@ upsert Case' + caseListResult);
		}

		List<Prestation_distributeur__c> prestationList = (List<Prestation_distributeur__c>)result.get('prestation');
		if(prestationList != null && prestationList.size() > 0) {
			insert prestationList;
		}


		if(enrolmentDetailsTocancelledList.size() > 0) {
			update enrolmentDetailsTocancelledList;
		}
		/*if(caseTocancelledList.size() > 0) {
			update caseTocancelledList;
			return;
		}*/

	}




	global void finish(Database.BatchableContext bc) {
	}
}