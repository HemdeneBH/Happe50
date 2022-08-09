/**
 * @File Name          : HP_CancelationCaseUtils.cls
 * @Description        :
 * @Author             : Mohamed Aamer
 * @Group              :
 * @Last Modified By   : Hemdene Ben Hammouda
 * @Last Modified On   : 11-04-2021
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    17/12/2019   Mohamed Aamer     Initial Version
 **/
public with sharing class HP_CancelationCaseUtils {
	public static final String RELANCE_CLIENT = 'Relance client';
	public static final String CLOSED_STATUS = 'CLOSED';
	public static final String CANCELED_STATUS = 'CANCELED';
	public static final String TO_DO_STATUS = 'TO_DO';

	/* public static void handleCancelationCase(final List<HP_CancelationCaseRestResourceModel.CancelationCase_v0_1> cancelationCaseList_v0_1, final Contact primaryContact, final Date effectiveDate, HP_WRP022_SFResponse response) {
	        handleCancelationCase(cancelationCaseList_v0_1, primaryContact, effectiveDate, null, HP_SLCT_Case.Status.NEW_CASE.name(), HP_SLCT_Case.Source.HP_CLIENT.name(),HP_SLCT_Case.Origin.HP_SELFCARE.name(),response);
	   } */

	public static void handleCancelationCase(final List<HP_CancelationCaseRestResourceModel.CancelationCase_v0_1> cancelationCaseList_v0_1, final Contact primaryContact, final Date effectiveDate, HP_WRP022_SFResponse response) {
		handleCancelationCase(cancelationCaseList_v0_1, primaryContact, effectiveDate, null, 'NEW_CASE','HP_CLIENT','HP_SELFCARE',response);
	}

	public static void handleCancelationCase(final List<HP_CancelationCaseRestResourceModel.CancelationCase_v0_1> cancelationCaseList_v0_1, final Contact primaryContact, final Date effectiveDate, final Date processingDate, HP_WRP022_SFResponse response) {
		handleCancelationCase(cancelationCaseList_v0_1, primaryContact, effectiveDate, processingDate, HP_SLCT_Case.Status.NEW_CASE.name(), HP_SLCT_Case.Source.HP_CLIENT.name(),HP_SLCT_Case.Origin.HP_SELFCARE.name(),response);
	}

	public static String buildCaseExternalId(Integer contractXdataId){
		return HP_ExternalIdUtils.itemExternalIdBuilder(HP_SLCT_Case.Type.CONTRACT_CANCELATION.name(), String.valueOf(contractXdataId));
	}

	public static void handleCancelationCase(final List<HP_CancelationCaseRestResourceModel.CancelationCase_v0_1> cancelationCaseList_v0_1, final Contact primaryContact, final Date effectiveDate, final Date processingDate, final String caseStatus, final String sourceCase, final String Origin, HP_WRP022_SFResponse response) {
		System.debug('HP_CancelationCaseUtils.handleCancelationCase() | Method Start');
		System.debug('cancelationCaseList_v0_1: '+cancelationCaseList_v0_1);
		Boolean upsertCase = true;
		final List<Case> caseList = new List<Case>();
		final List<Task> taskList = new List<Task>();
		List<HP_Contrat__c> contratList =  new List<HP_Contrat__c>();
		final Id taskRecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Task','HP_Task');
		final Id caseRecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case','HP_ContractCancelationCase');

		List<Decimal> xdataIdContratList = new List<Decimal>();
		for (HP_CancelationCaseRestResourceModel.CancelationCase_v0_1 cancelationCase : cancelationCaseList_v0_1) {
			xdataIdContratList.add(cancelationCase.energyContractXDataId);
		}
		List<HP_Contrat__c> contractList = [select Id, HP_Contrat_XdataId__c from HP_Contrat__c where HP_Contrat_XdataId__c in :xdataIdContratList];

		Set<Decimal> xdataIdContratSet = new Set<Decimal>();
		for(HP_Contrat__c cont : contractList) {
			xdataIdContratSet.add(cont.HP_Contrat_XdataId__c);
		}
		for (HP_CancelationCaseRestResourceModel.CancelationCase_v0_1 cancelationCase : cancelationCaseList_v0_1) {
			contratList = HP_EM023_Contrat.loadContratListByXdataId(cancelationCase.energyContractXDataId);
			if (contratList.size() == 0) {
				contratList.add(HP_EM023_Contrat.buildContract(cancelationCase.energyContractXDataId,cancelationCase.energyType));
			}
		System.debug('@@ primaryContact ' +primaryContact);
			final String caseExternalId = buildCaseExternalId(cancelationCase.energyContractXDataId);
			Case newCase = new Case(
				ContactId =  primaryContact.id,
				Origin = Origin,
				HP_Source__c = sourceCase,
				HP_Type__c = HP_SLCT_Case.Type.CONTRACT_CANCELATION.name(),
				Status = caseStatus,
				RecordTypeId = caseRecordTypeId,
				HP_TECH_ExternalId__c = caseExternalId,
				HP_Energy__c = cancelationCase.energyType.name(),
				HP_CompteurCommunicant__c = cancelationCase.isSmartEnergyMeter,
				HP_index_elec_base__c = (cancelationCase.energyType.name() == 'ELECTRICITY' && cancelationCase.electricityMeterVariablePlanBottomPriceIndex == null) ? cancelationCase.energyMeterIndex : null,
				HP_index_elec_hp__c =( cancelationCase.energyType.name() == 'ELECTRICITY' && cancelationCase.electricityMeterVariablePlanBottomPriceIndex != null) ? cancelationCase.energyMeterIndex : null,
				HP_index_elec_hc__c =  (cancelationCase.energyType.name() == 'ELECTRICITY' && cancelationCase.electricityMeterVariablePlanBottomPriceIndex != null) ? cancelationCase.electricityMeterVariablePlanBottomPriceIndex : null,
				HP_index_gaz__c = cancelationCase.energyType.name() == 'GAS' ? cancelationCase.energyMeterIndex : null,
				HP_ResiliationAgilabTraitement__c = false,
				HP_ResiliationModifierStatutAgilab__c=false,
				HP_ResiliationModifierStatutXdata__c=false
				);
				if(contratList.get(0).Id != null) {
					newCase.HP_Contrat__c = contratList.get(0).Id;
				} else if(xdataIdContratSet.contains(cancelationCase.energyContractXDataId)) {
					newCase.HP_Contrat__r = new HP_Contrat__c( HP_Contrat_XdataId__c = cancelationCase.energyContractXDataId);
				}

			checkEnergyType(newCase,cancelationCase.energyType.name(),cancelationCase.energyMeterIndex,cancelationCase.electricityMeterVariablePlanBottomPriceIndex);
			if (effectiveDate != null) {

				newCase.HP_EffectiveDate__c = effectiveDate;
				System.debug('newCase'+newCase);
			}
			caseList.add(newCase);
		}
		// look for existing cases
		for(Case existingCase : [SELECT Id, Status, HP_Energy__c  FROM Case WHERE HP_TECH_ExternalId__c = :caseList[0].HP_TECH_ExternalId__c limit 1]){
			if(existingCase.Status == CLOSED_STATUS){
				response.addWarning('SF-CaseCancelation-0', existingCase.HP_Energy__c + ' - Case Closed');
				upsertCase = false;
			}else if(existingCase.Status == CANCELED_STATUS){
				response.addWarning('SF-CaseCancelation-0', existingCase.HP_Energy__c +' - Case Cancelled');
				upsertCase = false;
			}else{
				caseList[0].HP_Sous_type__c = RELANCE_CLIENT;
				caseList[0].Status = TO_DO_STATUS;
				upsertCase = true;
			}
		}
		if(upsertCase){
			try{
				Database.upsert(contratList);
				Database.upsert(caseList, Case.Fields.HP_TECH_ExternalId__c);
				System.debug('++++++++>' +caseList[0].HP_TECH_ExternalId__c);
				response.addinfo('SF-CaseCancelation-1', 'Case est créé avec Id tech : ' + caseList[0].HP_TECH_ExternalId__c);
			}catch (Exception e) {
				response.code = HP_HttpStatus.BAD_REQUEST;
				response.message = e.getMessage();
				response.addError('SF-CaseCancelation-2', 'Error au niveau de la création du case');
				throw new HP_WRP022_SFResponse.APIException(); 
			}
		}
		if (processingDate != null) {
			for (Case aCase : caseList) {
				taskList.add(
					new Task(
						RecordTypeId = taskRecordTypeId,
						WhatId = aCase.Id,
						Type = 'HP_CONTRACT_MANAGEMENT',
						Subject = 'HP_CONTRACT_CANCELATION',
						Status = 'HP_TODO',
						ActivityDate = processingDate,
						HP_TECH_ExternalId__c = aCase.HP_TECH_ExternalId__c
						)
					);
			}
			Database.upsert(taskList, Task.Fields.HP_TECH_ExternalId__c);
			response.addinfo('HP_CancelationCaseUtils-3', 'Task est créé avec Id tech : ' + taskList[0].HP_TECH_ExternalId__c);
		}
		System.debug('HP_CancelationCaseUtils.handleCancelationCase() | Method Exit');
	}

	@AuraEnabled
	public static void createTask(String caseId, Date processingDate ){
		final List<Task> taskList = new List<Task>();
		System.debug(caseId +' createTask======='+ processingDate);
		final Id taskRecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Task','HP_Task');
		if(processingDate != null) {
			taskList.add(
				new Task(
					RecordTypeId = taskRecordTypeId,
					WhatId = caseId,
					Type = 'HP_CONTRACT_MANAGEMENT',
					Subject ='HP_CONTRACT_CANCELATION',
					Status ='HP_TODO',
					ActivityDate = processingDate
					)
				);
			Database.upsert(taskList, true);
		}
	}

	public static void checkEnergyType(Case caseR, String energy, Integer indexEnergy, Integer indexHC) {
		if (energy == 'GAS') {
			caseR.HP_index_gaz__c = indexEnergy;
			caseR.HP_index_elec_base__c = null;
		} else if (energy == 'ELECTRICITY') {
			if (indexHC != null) {
				caseR.HP_index_elec_hp__c = indexEnergy;
				caseR.HP_index_elec_hc__c = indexHC;
				caseR.HP_index_elec_base__c = null;
				caseR.HP_index_gaz__c = null;
			} else {
				caseR.HP_index_elec_base__c = indexEnergy;
				caseR.HP_index_elec_hc__c = null;
				caseR.HP_index_elec_hp__c = null;
			}
		}
	}

	public static void handleCancelationCase(
		final HP_CancelationCaseRestResourceModel.CancelationCase_v0_1 cancelationCase_v0_1,
		final Contact primaryContact,
		final Date effectiveDate, final HP_WRP022_SFResponse response) {
		handleCancelationCase(new List<HP_CancelationCaseRestResourceModel.CancelationCase_v0_1> {cancelationCase_v0_1}, primaryContact, effectiveDate, null,response);
	}

	@AuraEnabled
	public static void rescheduleCase(
		final String caseId, final String energy, final Integer energyContractXdataId, final Integer energyMeterIndex, final Integer electricityMeterVariablePlanBottomPriceIndex,
		final Id primaryContactId, final String effectiveDateStr, final String processingDateStr, final String caseStatusStr, final String sourceCaseStr, final String originStr, final HP_WRP022_SFResponse response) {
			final Date effectiveDate = effectiveDateStr != null ? Date.parse(effectiveDateStr) : null;
			final Date processingDate = Date.parse(processingDateStr);
			final Contact primaryContact = new Contact(Id = primaryContactId);
			final Map<String, HP_EnrolmentRestResourceModel.EnergyType> energyTypeValues = new Map<String, HP_EnrolmentRestResourceModel.EnergyType>();
			final Map<String, HP_SLCT_Case.Status> statusValues = new Map<String, HP_SLCT_Case.Status>();
			final Map<String, HP_SLCT_Case.Source> sourceValues = new Map<String, HP_SLCT_Case.Source>();
			final Map<String, HP_SLCT_Case.Origin> originValues = new Map<String, HP_SLCT_Case.Origin>();
			
			originValues.put('HP_CRM',HP_SLCT_Case.Origin.HP_CRM);
			sourceValues.put('HP_CLIENT',HP_SLCT_Case.Source.HP_CLIENT);
			sourceValues.put('HP_PROVIDER',HP_SLCT_Case.Source.HP_PROVIDER);
			statusValues.put('TO_DO',HP_SLCT_Case.Status.TO_DO);
			energyTypeValues.put('GAS',HP_EnrolmentRestResourceModel.EnergyType.GAS);
			energyTypeValues.put('ELECTRICITY',HP_EnrolmentRestResourceModel.EnergyType.ELECTRICITY);
			final String sourceCase = sourceValues.get(sourceCaseStr).name();
			final String caseStatus = statusValues.get(caseStatusStr).name();
			final String origin = originValues.get(originStr).name();
			final HP_EnrolmentRestResourceModel.EnergyType energyType = energyTypeValues.get(energy);
			final HP_CancelationCaseRestResourceModel.CancelationCase_v0_1 cancelationCase_v0_1 = new HP_CancelationCaseRestResourceModel.CancelationCase_v0_1(energyType, energyContractXdataId, energyMeterIndex, electricityMeterVariablePlanBottomPriceIndex);
			handleCancelationCase(new List<HP_CancelationCaseRestResourceModel.CancelationCase_v0_1> {cancelationCase_v0_1}, primaryContact, effectiveDate, processingDate, caseStatus, sourceCase, origin,response); //TODO merge list creation with other methods

	}
}