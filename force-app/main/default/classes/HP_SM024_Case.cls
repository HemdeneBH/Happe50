/**
 * @File Name          : HP_SM024_Case.cls
 * @Description        :
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              :
 * @Last Modified By   : Hemdene Ben Hammouda





 * @Last Modified On   : 03-16-2022





 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    21/02/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
 **/
public with sharing class HP_SM024_Case {


	public static Map<String,List<SObject> > callAPIProcessing( HP_Souscription__c souscription, Contact cont,
								    List<HP_Contrat__c> contractList, HP_Porte_Feuille_Contrat__c ptf,boolean isSave3, HP_WRP022_SFResponse response) {
										
				
		String messageErrorAgilab;
        String sousTypePrestaGRD = null;
        System.debug('souscription : ' + souscription);                               
        if(souscription != null && souscription.HP_ActivationPrioritaire__c) {
        	sousTypePrestaGRD = 'Presta GRD urgente';                    
        }
        System.debug('SousType presta GRD : ' + sousTypePrestaGRD);                               
		Map<String,List<SObject> > result = new Map<String,List<SObject> >();
		result.put('emailMessage', new List<EmailMessage>());
		result.put('case', new List<Case>());
		result.put('prestation', new List<Prestation_distributeur__c>());
		result.put('contrat', new List<HP_Contrat__c>());
		for(HP_Contrat__c acontrat : contractList) {
			if(isSave3) {
				try{
					HttpResponse agilabResponse = contractualisationAgilab(souscription, cont, acontrat, ptf);
					if(agilabResponse.getStatusCode() != 200) {
						Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(agilabResponse.getBody());
						messageErrorAgilab = (String) resultAsMap.get('message');
						throw new HP_WRP022_SFResponse.APIException();
					}
					response.addInfo('SM024-1', 'Contractualisation Agilab ' +acontrat.HP_Type_de_Compteur__c + ' '+ HP_Constantes.AGILAB_CONTRACTUALISATION);
					if(cont.HP_Shared_URL__c == null || cont.HP_Shared_URL__c ==''){
						HP_SM069_SharingLinkController.setSharingLink(cont);
					}
				} catch(Exception e) {
					result.get('case').add(createCaseError(cont, acontrat, 'Error souscription', 'HP_ContractErrorSave3', 'TO_DO', 'HP_Contractualization', messageErrorAgilab, ''));
					response.addWarning('SM024-2', ' Error Contractualisation Agilab ' +acontrat.HP_Type_de_Compteur__c + ' '+ HP_Constantes.AGILAB_CONTRACTUALISATION);
					continue;
				}
			}
			Integer numberDaysDue = System.Today().daysBetween(souscription.HP_Date_de_Contractualisation__c);
			System.debug('@@@@@@souscription.HP_Date_de_Contractualisation__c '+souscription.HP_Date_de_Contractualisation__c);
			System.debug('@@@@@@numberDaysDue '+numberDaysDue);


			if(numberDaysDue == 0) {
				System.debug('@@@@@@numberDaysDue : 0  '+numberDaysDue);

				result.get('case').add(createCaseError(cont, acontrat, 'HP_PRESTATION_GRD', 'HP_PrestationDistributeur', 'TO_DO', 'HP_MANUAL_PROCESS','', sousTypePrestaGRD));
				response.addWarning('SM024-3', 'Date de contractualisation est aujourd hui');
				continue;
			}

			if(numberDaysDue > 42) {
				System.debug('@@@@@@numberDaysDue : 42  '+numberDaysDue);

			     result.get('case').add(createCaseError(cont, acontrat, 'HP_PRESTATION_GRD', 'HP_PrestationDistributeur', 'HP_PENDING', 'HP_AUTOMATED_PROCESS','', sousTypePrestaGRD));
			     response.addWarning('SM024-4', 'Date de contractualisation plus de 42 jours, case créé');
			     continue;
			}

			Integer currentHour = Datetime.now().time().hour();
			if(((currentHour < 8) || (currentHour >= 18)) && !Test.isRunningTest()) {
				result.get('case').add(createCaseError(cont, acontrat, 'HP_PRESTATION_GRD', 'HP_PrestationDistributeur', 'HP_PENDING', 'HP_AUTOMATED_PROCESS','', sousTypePrestaGRD));
				response.addWarning('SM024-5', 'WS fermé');
				continue;
			}
			HP_EnergyContractRequest energyContractRequest;
			HP_EnergyResponse energyResponse;
			HP_EnergyRequest energyRequest;
			Boolean isInterventionOnSite;
			Boolean isSmartMeter;
			Boolean indexExists;
			Boolean isLinky;
			Boolean isGaspar;
			try{
				energyRequest = new HP_EnergyRequest(souscription.HP_type_Souscription__c, acontrat.HP_Id_Compteur__c,
								     (Integer)(acontrat.HP_Type_de_Compteur__c == 'GAS' ? acontrat.HP_Index_de_Compteur__c :
									       acontrat.HP_Compteur_Base_Plan_Index__c != null ?  acontrat.HP_Compteur_Base_Plan_Index__c :
									       acontrat.HP_Compteur_Variable_Plan_prix_Index__c ));
				energyResponse = precontratOCTOPUS(souscription, acontrat, energyRequest);
				response.addInfo('SM024-6', 'Precontractualisation OCTOPUS ' +acontrat.HP_Type_de_Compteur__c);
				energyContractRequest =  HP_EM023_Contrat.energyContractRequestBuilder(cont, souscription, acontrat);

				isInterventionOnSite = energyResponse.isOnsiteIntervention;
				isSmartMeter = energyResponse.isSmartMeter;
				indexExists = (energyRequest.energyMeterIndex != null);
				System.debug('@@ acontrat.HP_Type_de_Compteur__c ' + acontrat.HP_Type_de_Compteur__c);
				if((acontrat.HP_Type_de_Compteur__c != 'GAS')) {
					System.debug('@@ souscription.HP_isLinky__c before ' + souscription.HP_isLinky__c);
				System.debug('@@ souscription.HP_isCommunicantElec__c  before ' + souscription.HP_isCommunicantElec__c );
				System.debug('@@energyResponse.meterType  before ' + energyResponse.meterType );

					isLinky = (energyResponse.meterType == 'LINKY');
					souscription.HP_isLinky__c = isLinky;
					souscription.HP_isCommunicantElec__c = energyResponse.isSmartMeter;
				}
				if((acontrat.HP_Type_de_Compteur__c == 'GAS') ) {
					System.debug('@@ souscription.HP_isGaspar__c  before ' + souscription.HP_isGaspar__c );
				System.debug('@@ souscription.HP_isCommunicantGaz__c   before ' + souscription.HP_isCommunicantGaz__c  );
				System.debug('@@energyResponse.meterType   before ' +energyResponse.meterType );
					isGaspar = energyResponse.meterType == 'Compteur Gazpar';
					souscription.HP_isGaspar__c = isGaspar;
					souscription.HP_isCommunicantGaz__c = energyResponse.isSmartMeter;
				}
				System.debug('***************************************************************************'  );
				System.debug('@@ souscription.HP_isLinky__c after ' + souscription.HP_isLinky__c);
				System.debug('@@ souscription.HP_isCommunicantElec__c  after ' + souscription.HP_isCommunicantElec__c );
				System.debug('@@ souscription.HP_isGaspar__c  after ' + souscription.HP_isGaspar__c );
				System.debug('@@ souscription.HP_isCommunicantGaz__c   after ' + souscription.HP_isCommunicantGaz__c  );
				System.debug('***************************************************************************'  );
				System.debug('@@ isLinky ' + isLinky);
				System.debug('@@ isGaspar ' + isGaspar);
				System.debug('@@ isInterventionOnSite ' + isInterventionOnSite);
				System.debug('@@ isSmartMeter ' + isSmartMeter);
				System.debug('@@ indexExists ' + indexExists);
				System.debug('@@ souscription.HP_Date_de_Contractualisation__c ' + souscription.HP_Date_de_Contractualisation__c);
				System.debug('@@ numberDaysDue ' + numberDaysDue);
				if(isInterventionOnSite) {
					System.debug('@@ intervention on site ' + isInterventionOnSite);

					result.get('case').add(createCaseError(cont, acontrat, 'HP_PRESTATION_GRD', 'HP_PrestationDistributeur', 'TO_DO', 'HP_MANUAL_PROCESS','', sousTypePrestaGRD));
					continue;
				}
			} catch(Exception ex) {
				System.debug('@@ error creation prestation octopus ' + isInterventionOnSite);

                System.debug(ex.getMessage());

				response.addWarning('SM024-7', 'Error au niveau de la création prestation OCTOPUS ' + acontrat.HP_Type_de_Compteur__c +
						    ' : ' + ex.getMessage());
				result.get('case').add(createCaseError(cont, acontrat, 'HP_PRESTATION_GRD', 'HP_PrestationDistributeur', 'TO_DO', 'HP_MANUAL_PROCESS','', sousTypePrestaGRD));
				continue;
			}
			System.debug('@@ v ');
			boolean isValid = areContractualizationRequirementsValid(isSmartMeter, numberDaysDue, energyRequest, indexExists, acontrat.HP_Type_de_Compteur__c);
			System.debug('@@ isValid ' + isValid + ' ' +  energyRequest.enrolmentType);

			if (isValid) {
				System.debug('@@ isValid '+isValid);

				try{

					HP_EnergyContractResponse energyContractResponse;

					if(acontrat.HP_Type_de_Compteur__c == 'GAS') {
						energyContractResponse = HP_SM026_DistCreatePrestationGaz.sendRequest(energyContractRequest, souscription.HP_type_Souscription__c, energyResponse, energyRequest.energyMeterIndex != null);
					} else {
						energyContractResponse = HP_SM027_DistCreatePrestationElec.sendRequest(energyContractRequest, souscription.HP_type_Souscription__c, energyResponse, energyRequest.energyMeterIndex != null);
					}
					if(energyContractResponse != null && energyContractResponse.isSuccess == false) {
						System.debug('@@ energyContractResponse != null && energyContractResponse.isSuccess == false '+(energyContractResponse != null && energyContractResponse.isSuccess == false));

						response.addWarning('SM024-8', 'Error au niveau de la création prestation OCTOPUS ' + acontrat.HP_Type_de_Compteur__c);
						result.get('case').add(createCaseError(cont, acontrat, 'HP_PRESTATION_GRD', 'HP_PrestationDistributeur', 'TO_DO', 'HP_MANUAL_PROCESS','', sousTypePrestaGRD));
						continue;
					}
					response.addInfo('SM024-9', 'Contractualisation OCTOPUS ' +acontrat.HP_Type_de_Compteur__c);

					result.get('case').add(createCaseError(cont, acontrat, 'HP_PRESTATION_GRD', 'HP_PrestationDistributeur', 'CLOSED', 'HP_AUTOMATED_PROCESS','', sousTypePrestaGRD));
					result.get('prestation').add(createPrestation(souscription, cont, acontrat,energyContractResponse.prestationDistributorId));
					result.get('contrat').add(acontrat);
					try {
						
						
						HP_AgilabCommercialPropositionService.updateContractSync(Integer.valueOf(acontrat.HP_Contrat_XdataId__c),  HP_Constantes.AGILAB_STATUS_BY_STATUS.get('AwaitingEnergyDistributor'), null, response);
						HP_APIHourContractService.updateContractSync(String.valueOf(acontrat.HP_Contrat_XdataId__c),
												 HP_Constantes.CONTRACT_XDATA_STATUS_AWAITING, 'ACTIF', null);
						EmailMessage em = HP_SendMailContratualizationService.sendMailViaCabestanSync('SF13', acontrat, response);
						if(em != null) {result.get('emailMessage').add(em);}
					}catch(Exception e) {
						response.addWarning('SM024-13','Error au niveau de la notification Agilab ou XDATA ou Octopus');
					}

				} catch(Exception ex) {
					response.addWarning('SM024-10', 'Error au niveau de la création prestation OCTOPUS ' + acontrat.HP_Type_de_Compteur__c +
							    ' : ' + ex.getMessage());
					result.get('case').add(createCaseError(cont, acontrat, 'HP_PRESTATION_GRD', 'HP_PrestationDistributeur', 'TO_DO', 'HP_MANUAL_PROCESS','', sousTypePrestaGRD));
				}
			} else if ((!isSmartMeter) && (!indexExists)
				   && (energyRequest.enrolmentType == 'MOVING_IN')
				   && (numberDaysDue <= 1)) {
					System.debug('@@ CANCELED  case' );

				response.addInfo('SM024-12', 'Creer case Cancel manuel');
				result.get('case').add(createCaseError(cont, acontrat, 'HP_PRESTATION_GRD', 'HP_PrestationDistributeur', 'CANCELED', 'HP_AUTOMATED_PROCESS','', sousTypePrestaGRD));
			}
			else {
				response.addInfo('SM024-11', 'Creer case auto');
				result.get('case').add(createCaseError(cont, acontrat, 'HP_PRESTATION_GRD', 'HP_PrestationDistributeur', 'HP_PENDING', 'HP_AUTOMATED_PROCESS','', sousTypePrestaGRD));

			}
		}

		return result;
	}


	public static case createCaseError(Contact cont, HP_Contrat__c acontrat, String raison, String rt, String status, String type, String description, String sousType) {
		return new Case(
			HP_TECH_ExternalId__c = acontrat.HP_Proposition_Commerciale_XdataId__c + rt + acontrat.HP_Type_de_Compteur__c,
			ContactId = cont.Id,
			HP_Contrat__c = acontrat.Id,
			Status = status,
			HP_Energy__c = (acontrat.HP_Type_de_Compteur__c == 'GAS' ? 'Gas' : 'Electricity'),
			Description = description,
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(rt).getRecordTypeId(),
			Reason = raison,

			//OwnerId = HP_Util_QueueManager.getQueueIdByName('HP_Niveau_1'),

			HP_Souscription__r = acontrat.HP_Souscription__r.HP_Souscription_Digital_Id__c != null ? new HP_Souscription__c(HP_Souscription_Digital_Id__c = acontrat.HP_Souscription__r.HP_Souscription_Digital_Id__c) : null,
			HP_Type__c = type,
			HP_Sous_type__c = sousType
			);
}

	public static Prestation_distributeur__c createPrestation(HP_Souscription__c souscription, Contact cont, HP_Contrat__c acontrat, String businessNumber) {
		Prestation_distributeur__c p = new Prestation_distributeur__c(
			RecordTypeId =  Schema.SObjectType.Prestation_distributeur__c.getRecordTypeInfosByDeveloperName().get('HP_PrestationDistributeur').getRecordTypeId(),
			Date_de_prestation__c = souscription.HP_Date_de_Contractualisation__c,
			Statut__c = 'En cours',
			Type_OPS__c= 'Online',
			Secteur_activite__c = acontrat.HP_Type_de_Compteur__c == 'ELEC' ? 'Elec' : 'Gaz',
			Situation_de_vente__c = souscription.HP_type_Souscription__c == 'MOVING_IN' ? 'Emménagement' : 'Changement de fournisseur',
			Numero_PDL_PCE__c = acontrat.HP_Id_Compteur__c,
			Contact__c = cont.Id,
			HP_Contrat__c = acontrat.Id,
			Numero_affaire_distributeur__c = businessNumber,
			Name = businessNumber,
			Case__r = new case (HP_TECH_ExternalId__c = acontrat.HP_Proposition_Commerciale_XdataId__c + 'HP_PrestationDistributeur'+ acontrat.HP_Type_de_Compteur__c)
			);
		return p;
	}

	/*  public static boolean contractualisationAgilab(HP_Souscription__c souscription, Contact cont, HP_Contrat__c acontrat, HP_Porte_Feuille_Contrat__c ptf, String message){
	     HP_AgilabContractualization contrat = HP_EM023_Contrat.agilabContractualisationBuilder(souscription, cont, acontrat, ptf);
	     HTTPResponse httpResponse = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.AGILAB_CONTRACTUALISATION, HP_UTIL_HTTPUtils.buildUrlEncodedParameters(contrat));
	     return (httpResponse.getStatusCode() == 200);
	   } */

	public static HTTPResponse contractualisationAgilab(HP_Souscription__c souscription, Contact cont, HP_Contrat__c acontrat, HP_Porte_Feuille_Contrat__c ptf){
		HP_AgilabContractualization contrat = HP_EM023_Contrat.agilabContractualisationBuilder(souscription, cont, acontrat, ptf);
		HTTPResponse httpResponse = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.AGILAB_CONTRACTUALISATION, HP_UTIL_HTTPUtils.buildUrlEncodedParameters(contrat));
		return httpResponse;
	}

	public static HP_EnergyResponse precontratOCTOPUS(HP_Souscription__c souscription, HP_Contrat__c acontrat, HP_EnergyRequest energyRequest) {
		HP_PreContractService preContractService = ((acontrat.HP_Type_de_Compteur__c == 'GAS') ? ((HP_PreContractService) new HP_SM029_DistGetPdlGaz()) : ((HP_PreContractService) new HP_SM028_DistGetPdlElec()));

		return preContractService.retrieveEnergyMeterInformations(energyRequest);
	}

	private static Boolean areContractualizationRequirementsValid(final Boolean isSmartMeter, final Integer numberOfDaysToContractStartDate,
								      final HP_EnergyRequest energyRequest, final Boolean indexExists, String productFamily) {
		return (((isSmartMeter) && (numberOfDaysToContractStartDate < 42))
		|| ((!isSmartMeter)
			&& (
				((indexExists)
				 && ( ((productFamily == 'ELEC') && (numberOfDaysToContractStartDate < 42)) || ((productFamily == 'GAS') && (numberOfDaysToContractStartDate < 15))))
				|| ((!indexExists)
				&& (energyRequest.enrolmentType == 'SWITCH_SUPLIER')
				&& (numberOfDaysToContractStartDate < 4))
				)
			)
		);
	}
	@AuraEnabled(Cacheable = true)
	public static List<Case> loadReclamationCase(String contactId) {
		return HP_EM010_Case.loadReclamationCase(contactId);
	}

	/**
	* @description 
	* @author Antoine Latour | 06-04-2021 
	* @param List<Case> caseList 
	**/
	public static void reaffectCase(List<Case> caseList) {
		Map<Id, User> mapUser = new Map<Id, User>();
		Set<Id> ownerIds = new Set<Id>();

		for(Case c : caseList) {
			if(c.OwnerId != null && string.valueOf(c.OwnerId).startsWith('005')) {
				ownerIds.add(c.OwnerId);
			}
		}
		mapUser = HP_UTIL_ProfileManager.getUsersProfiles(ownerIds);
		List<Case> casesN1 = new List<Case>();
		List<Case> casesN2 = new List<Case>();
		Id queueNiveau1Id = HP_Util_QueueManager.getQueueIdByName('HP_Niveau_1');
		Id queueNiveau2Id = HP_Util_QueueManager.getQueueIdByName('HP_Niveau_2');

		for(Case c : caseList) {
			if(c.OwnerId != null && mapUser.containsKey(c.OwnerId)) {
				if(mapUser.get(c.OwnerId).Profile != null){
					if(mapUser.get(c.OwnerId).Profile.Name.contains('HP_Conseiller Niveau 1')) {
						casesN1.add(c);
					}
					if(mapUser.get(c.OwnerId).Profile.Name.contains('HP_Conseiller Niveau 2')) {
						casesN2.add(c);
					}
				}
			}		     
		}

		Map<Id, List<Case>> mapReaffectation = new Map<Id, List<Case>>();
		mapReaffectation.put(queueNiveau1Id, casesN1);
		mapReaffectation.put(queueNiveau2Id, casesN2);
		HP_EM010_Case.reaffectCaseToOwner(mapReaffectation);
	}
}