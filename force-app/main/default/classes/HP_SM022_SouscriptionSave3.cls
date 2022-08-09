/**
 * @File Name          : HP_SM022_SouscriptionSave3.cls
 * @Description        :
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 

 * @Last Modified By   : Badr Eddine Belkarchi

 * @Last Modified On   : 02-23-2022


 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    13/02/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
 **/
public without sharing class HP_SM022_SouscriptionSave3 {

	
	public static void execute(HP_EnrolmentRestResourceModel.ThirdSave_v0_1 selfcare, HP_WRP022_SFResponse response) {
		
		if (selfcare.selfcareId == null){
			response.addError('SM022-10', 'KO 1 : selfcareId manquant.');
			throw new HP_WRP022_SFResponse.APIException();
		} 
	 	List<HP_Souscription__c> souscriptionlist = HP_EM005_Souscription.loadSouscriptionList(selfcare.selfcareId);
		if(souscriptionlist.size() <= 0){
			response.addError('SM022-11', 'KO 2 : selfcareId inconnu.');
			throw new HP_WRP022_SFResponse.APIException();
		}
		
		HP_Souscription__c  souscription = souscriptionlist[0];
		
		boolean isUpdateSave3 = souscription.HP_Statut__c == 'SAVE_3';
		//String ptfId = String.valueOf(selfcare.contractPortfolioXdataId);
		HP_Porte_Feuille_Contrat__c ptf = HP_EM024_PorteFeuilleContrat.loadPorteFeuilleContrat(selfcare.selfcareId);
		Contact cont = HP_EM020_Contact.loadContact(ptf.HP_Contact__c);
		souscription.HP_IBAN__c = selfcare.internationalBankAccountNumber;
		souscription.HP_RUM__c = selfcare.singleEuroPaymentAreaUniqueMandateReference;

		// Champs pour les consentements liés 
		List<HP_Contrat__c> contractList = HP_EM023_Contrat.loadContrat(selfcare.selfcareId);
		response.addInfo('SM022-1', contractList.size() + ' contrats chargés');
		System.debug('contractList.size() : '+ contractList.size());
		System.debug('contractList : '+ contractList);
		for(HP_Contrat__c acontrat : contractList) {
			
			String typeCompteur = acontrat.HP_Type_de_Compteur__c;
			if(typeCompteur == 'GAS') {
				acontrat.HP_Contrat_XdataId__c = selfcare.gasContractXdataId;
				System.debug('ID_CONTRAT TO AGILAB '+ acontrat.HP_Contrat_XdataId__c);
			} else {
				acontrat.HP_Contrat_XdataId__c = selfcare.electricityContractXdataId;
				System.debug('ID_CONTRAT TO AGILAB '+ acontrat.HP_Contrat_XdataId__c);
			}
		}

        Map<String,List<SObject> > resultApi = null;

		if(!isUpdateSave3) {
			System.debug('@@ souscription avant ' + souscription);
			System.debug('@@ souscription.HP_isLinky__c  avant sous' + souscription.HP_isLinky__c);
			System.debug('souscription.HP_isCommunicantElec__c  avant sous' + souscription.HP_isCommunicantElec__c );
			System.debug('@@ souscription.HP_isGaspar__c  avant sous' + souscription.HP_isGaspar__c );
			resultApi = HP_SM024_Case.callAPIProcessing(souscription, cont, contractList, ptf, true,response);
			System.debug('@@ souscription apres ' + souscription);
			System.debug('@@ souscription.HP_isLinky__c  apres sous' + souscription.HP_isLinky__c);
			System.debug('souscription.HP_isCommunicantElec__c  apres sous' + souscription.HP_isCommunicantElec__c );
			System.debug('@@ souscription.HP_isGaspar__c  apres sous' + souscription.HP_isGaspar__c );
			// check case

			List<Case> resultCases = resultApi.get('case');
			List<Id> erreurAgilabContractIds = new List<Id>{};
			boolean isContractualisationEnErreurAgilab = false;
			for(Case c: resultCases) {
				if (c.HP_Type__c == 'HP_Contractualization') {
					isContractualisationEnErreurAgilab = true;
					erreurAgilabContractIds.add(c.HP_Contrat__c);
				}
			}

			System.debug('isContractualisationEnErreurAgilab is : '+isContractualisationEnErreurAgilab);

			for(HP_Contrat__c acontrat : contractList) {
				if (acontrat.HP_Type_de_Compteur__c == 'ELEC' && !erreurAgilabContractIds.contains(acontrat.id)) {
					souscription.OK_Electricite__c = true;
					System.debug('souscription.OK_Electricite__c = true;');
				}
				if (acontrat.HP_Type_de_Compteur__c == 'GAS' && !erreurAgilabContractIds.contains(acontrat.id)) {
					souscription.OK_Gaz__c = true;
					System.debug('souscription.OK_Gaz__c = true;');
				} 
			}

			if (!isContractualisationEnErreurAgilab) {
				HP_SM063_WelcomeEmailSender.sendWelcomeEmail(souscription.Id,String.valueOf(selfcare.electricityContractXdataId), String.valueOf(selfcare.gasContractXdataId), souscription.OK_Electricite__c, souscription.OK_Gaz__c);
			} else {
				HP_SM063_WelcomeEmailSender.sendSouscriptionEnAttenteDeValidationEmail(souscription.Id,String.valueOf(selfcare.electricityContractXdataId), String.valueOf(selfcare.gasContractXdataId), souscription.OK_Electricite__c, souscription.OK_Gaz__c);
			}
			
			Case acase = insertCaseErrorSouscription(selfcare, cont.Id_Tiers__c, souscription, response);
			if(acase != null) {
				resultApi.get('case').add(acase);
			}
        }

        updateDataProcessing(selfcare, resultApi, souscription, cont, contractList, isUpdateSave3, false, response);
		System.debug('After updateDataProcessing optinMarketing: '+souscription.HP_Contact__r.HP_OptinMarketing__c);
        if (selfcare.cancelContract == true) {
            HP_CancelationCaseUtils.handleCancelationCase(selfcare.cancelationCaseList_v0_1, cont ,selfcare.cancelationCaseEffectiveDate, response);
        }
	}

	public static void updateDataProcessing(HP_EnrolmentRestResourceModel.ThirdSave_v0_1 selfcare, Map<String,List<SObject> > apiResult,
						HP_Souscription__c souscription, Contact cont,  List<HP_Contrat__c> contratList,boolean isUpdateSave3, boolean isRelanceContractSave3, HP_WRP022_SFResponse response){

		if(isRelanceContractSave3 == true) {
			// linky  & Gaspar: la valeur est MAJ au niveau de HP_SM024_Case.callAPIProcessing lors de la relance
			souscription.HP_isCommunicantElec__c = souscription.HP_isCommunicantElec__c;
			souscription.HP_isLinky__c = souscription.HP_isLinky__c;
			souscription.HP_isGaspar__c = souscription.HP_isGaspar__c;
			souscription.HP_isCommunicantGaz__c = souscription.HP_isCommunicantGaz__c ;
			update souscription;
		}
	    if (isRelanceContractSave3 == false){
            souscription.HP_DigitalDateSave3__c = System.now();
			souscription.HP_Statut__c = 'SAVE_3';
			//Champ pour analyser les ventes et les taux de conversions des souscriptions(Signé).
			souscription.HP_TECH_wasSave3__c = 1;	
			souscription.HP_creation_CPV_elec__c = selfcare.creationCPVElec == false ? 'Non' : 'Oui';
			souscription.HP_creation_CPV_gaz__c       = selfcare.creationCPVGaz == false ? 'Non' : 'Oui';
			souscription.HP_creation_mandat__c =  selfcare.creationMandat == false ? 'Non' : 'Oui';
			souscription.HP_DigitalElecDocumentId__c = selfcare.electricityDocumentId;
			souscription.HP_DigitalGazDocumentId__c = selfcare.gasDocumentId;
			souscription.HP_Revision_Document__c = selfcare.revisionDocument;
			souscription.HP_DigitalDocumentMandateId__c = selfcare.idDocumentMandate;
			//Champs Consentements ==>
			System.debug('Before HP_optinMarketing__c = '+ souscription.HP_Contact__r.HP_OptinMarketing__c);
			cont.HP_OptinMarketing__c=true;
			System.debug('After HP_optinMarketing__c = '+ souscription.HP_Contact__r.HP_OptinMarketing__c);
			if(selfcare.consentements != null){
				System.debug('selfcare consentements: '+selfcare.consentements);
				List<HP_MajConsentements__c> consToInsert = new List<HP_MajConsentements__c>();
				souscription.Hp_consentementQ1_1__c = selfcare.consentements.q11;
				System.debug('Hp_consentementQ1_1__c= '+souscription.Hp_consentementQ1_1__c);
				consToInsert.add(HP_SM071_Consentement.createConsentement(cont,souscription.Hp_consentementQ1_1__c,souscription.HP_Contact__r.ID_Tiers__c, 1,1,'Happe','Web'));
				souscription.Hp_consentementQ1_2__c = selfcare.consentements.q12;
				System.debug('Hp_consentementQ1_2__c= '+souscription.Hp_consentementQ1_2__c);
				consToInsert.add(HP_SM071_Consentement.createConsentement(cont,souscription.Hp_consentementQ1_2__c,souscription.HP_Contact__r.ID_Tiers__c, 2,1,'Happe','Web'));
				souscription.Hp_consentementQ1_3__c = selfcare.consentements.q13;
				System.debug('Hp_consentementQ1_3__c= '+souscription.Hp_consentementQ1_3__c);
				consToInsert.add(HP_SM071_Consentement.createConsentement(cont,souscription.Hp_consentementQ1_3__c,souscription.HP_Contact__r.ID_Tiers__c, 3,1,'Happe','Web'));
				if(!consToInsert.isEmpty()){
					insert consToInsert;
				}
			}
				

			// linky  & Gaspar: la valeur est MAJ au niveau de HP_SM024_Case.callAPIProcessing
			souscription.HP_isCommunicantElec__c = souscription.HP_isCommunicantElec__c;
			souscription.HP_isLinky__c = souscription.HP_isLinky__c;
			souscription.HP_isGaspar__c = souscription.HP_isGaspar__c;
			souscription.HP_isCommunicantGaz__c = souscription.HP_isCommunicantGaz__c ;
		
			if(selfcare.updatePropositionStatus != null)
				souscription.HP_DigitalUpdatePropositionStatus__c = selfcare.updatePropositionStatus;
			update souscription;


			List<Case> caseRappelList = [Select Id,Status from Case where HP_Type__c='HP_RappelLeadNonSigne' AND HP_Souscription__c = :souscription.Id];
			Set<Id> caseRappelListIds = new Set<Id>();
			Set<Id> caseRappelTraiteIds = new Set<Id>();
			if(!caseRappelList.isEmpty()){
				for(Case c : caseRappelList){
					caseRappelListIds.add(c.Id);
				}
				List<HP_AppelsSortants__c> appelSortansList = [SELECT Id,HP_CaseRappel__c  from HP_AppelsSortants__c where HP_CaseRappel__c IN :caseRappelListIds];
				List<EmailMessage> emailList = [SELECT Id,ParentId from EmailMessage where ParentId IN :caseRappelListIds];
				if(!appelSortansList.isEmpty()){
					for(HP_AppelsSortants__c aps : appelSortansList){
						caseRappelTraiteIds.add(aps.HP_CaseRappel__c);
					}
				}
				if(!emailList.isEmpty()){
					for(EmailMessage em : emailList){
						caseRappelTraiteIds.add(em.ParentId);
					}
				}
				for(Case c : caseRappelList){
					if(!caseRappelTraiteIds.contains(c.Id)){
						c.Status = 'CANCELED';
					}else if(c.Status != 'CANCELED' || c.Status != 'CLOSED'){
						c.Status = 'CLOSED';
					}else{
						continue;
					}
				}
				update caseRappelList;
			}

		}
		
		if(isUpdateSave3) {
			return;
		}
		List<EmailMessage> emList = (List<EmailMessage>)apiResult.get('emailMessage');
		List<Case> caseList = (List<Case>)apiResult.get('case');
		List<Prestation_distributeur__c> prestationList = (List<Prestation_distributeur__c>)apiResult.get('prestation');
		// if(cont.HP_Shared_URL__c != null){
			Database.update(cont);
		// }
		if(emList.size() > 0){
			insert emList;
			HP_EM019_EmailMessage.createEmailMessageRelation(emList[0],cont);
			response.addInfo('SM022-12', 'Insertion EmailMessage');
		}

		if(caseList.size() > 0) {
			Database.upsert(caseList,case.Fields.HP_TECH_ExternalId__c);
			response.addInfo('SM022-2', 'Creation des Case');
		}

		if(prestationList.size() > 0) {
			List<Case> casePrestationList = new List<Case>();
			insert prestationList;
			response.addInfo('SM022-3', 'Creation de prestation');
			for (Prestation_distributeur__c p : prestationList){
				casePrestationList.add(p.Case__r);
			}
			for (Case c : casePrestationList){
				c.Status = 'CLOSED';
			}
			Database.upsert(casePrestationList,case.Fields.HP_TECH_ExternalId__c);
		}
		
		if(contratList.size() > 0) {
			Database.upsert(contratList,true);
			response.addInfo('SM022-4', 'Mise à jour des Contrats Happe');
		}
	}


	private static case insertCaseErrorSouscription(HP_EnrolmentRestResourceModel.ThirdSave_v0_1 selfcareLead,
							Decimal contactXdataId, HP_Souscription__c souscription, HP_WRP022_SFResponse response) {
		//HAPP-583
		String description = '';
		if(selfcareLead.creationMandat == null && souscription.HP_Methode_de_paiement__c == 'TRANSFER') {
			response.addError('SM022-5', 'BillingMethod TRANSFER => creationMandat Obligatoire');
			throw new HP_WRP022_SFResponse.APIException();
		}
		if(souscription.HP_Type_Energie__c == 'COMBINED_GAS_AND_ELECTRICITY' &&
		   (selfcareLead.creationCPVElec == null || selfcareLead.creationCPVGaz == null)) {
			response.addError('SM022-6', 'Offre combinée => creationCPVElec, creationCPVGaz Obligatoire');
			throw new HP_WRP022_SFResponse.APIException();
		}

		if(souscription.HP_Type_Energie__c == 'GAS' &&
		   (selfcareLead.creationCPVElec != null || selfcareLead.creationCPVGaz == null)) {
			response.addError('SM022-7', 'Offre Gaz => creationCPVGaz Obligatoire et creationCPVElec à ne pas mettre');
			throw new HP_WRP022_SFResponse.APIException();
		}

		if(souscription.HP_Type_Energie__c == 'ELECTRICITY' &&
		   (selfcareLead.creationCPVElec == null || selfcareLead.creationCPVGaz != null)) {
			response.addError('SM022-8', 'Offre Electrique =>  creationCPVElec Obligatoire et creationCPVGaz à ne pas mettre');
			throw new HP_WRP022_SFResponse.APIException();
		}

		if(selfcareLead.creationCPVElec == false) {
			description ='CPV Electricité KO/';
		}
		if(selfcareLead.creationCPVGaz == false) {
			description += 'CPV gaz KO/';
		}
		if(selfcareLead.creationMandat == false) {
			description += 'Mandat KO/';
		}
		if(description != '') {
			Case acase = new Case(
				RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HP_ContractErrorSave3').getRecordTypeId(),
				HP_Type__c = 'HP_DocumentCreationError',
				Origin ='HP_SELFCARE',
				HP_TECH_ExternalId__c = selfcareLead.selfcareId +  'HP_ContractErrorSave3Document',
				Reason = 'erreur de souscription',
				Description = description,
				Contact = new Contact(Id_Tiers__c = contactXdataId),
				HP_Souscription__c = souscription.Id
				);
			response.addWarning('SM022-9', 'Case Erreur création de documents est créé');
			return acase;
		}
		return null;
}
}