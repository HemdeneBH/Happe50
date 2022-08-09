/**
 * @File Name          : HP_SM021_SouscriptionSave2.cls
 * @Description        :
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              :
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 11-02-2021
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    07/02/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
 **/
public without sharing class HP_SM021_SouscriptionSave2 {

	public final static Integer MIN_YEARLY_CONSUMPTION = 499;
	public static void execute(final HP_EnrolmentRestResourceModel.SecondSave_v0_1 selfcare, HP_WRP022_SFResponse response) {

		HP_Souscription__c souscription = HP_EM005_Souscription.loadSouscription(selfcare.selfcareId);

		Case acase = validationData(selfcare, souscription);

		String status = (acase == null ? 'E0005' : 'H0001');


		Map<String, String> resultAPI = callAPIProcessing( selfcare, souscription, status, response);
		updateDataProcessing(selfcare, souscription, acase, resultAPI, response);
		response.output = new OutputSave2(resultAPI);
	}

	public static Map<String, String> callAPIProcessing(final HP_EnrolmentRestResourceModel.SecondSave_v0_1 selfcare, HP_Souscription__c souscription, String status,
							    HP_WRP022_SFResponse response) {

		HP_PortailUtilisateur__c utilisateur = HP_EM002_PortailUtilisateur.getUtilisateurByLogin(selfcare.login);
		String idPrestataire = ((utilisateur == null) ? '' : utilisateur.Prestataire__r.IdPrestataire__c);

		Map<String, String> result = new Map<String, String>();
		String porteFeuilleContratId = null;
		try {
			String label = (selfcare.billingZipCode + selfcare.billingStreetNumber + selfcare.billingStreetName);
			HP_ContractPortfolio contractPortfolio = new HP_ContractPortfolio(selfcare.xDataId, label, souscription.HP_Methode_de_paiement__c, souscription.HP_Periode_de_facturation__c);
			List<HP_Porte_Feuille_Contrat__c> ptf = [select Xdata_Id__c from HP_Porte_Feuille_Contrat__c where HP_Souscription_Digital_Id__c = :selfcare.selfcareId];
			if(ptf == null || ptf.size() == 0 || String.isBlank(ptf.get(0).Xdata_Id__c)) {
				porteFeuilleContratId = HP_EM024_PorteFeuilleContrat.createPorteFeuilleContratXdata(contractPortfolio);
				response.addinfo('SM021-1', 'L appel vers XDATA : ' + HP_Constantes.XDATA_PORTEFEUILLES_CONTRATS + ' voici l ID portfeuille Contrat Créé ' +porteFeuilleContratId);
			} else{
				HP_EM024_PorteFeuilleContrat.updatePorteFeuilleContratXdata(ptf.get(0).Xdata_Id__c, contractPortfolio);
				response.addinfo('SM021-2', 'L appel vers XDATA : ' + HP_Constantes.XDATA_PORTEFEUILLES_CONTRATS + ' voici l ID portfeuille Contrat modifié ' +ptf.get(0).Xdata_Id__c);
				porteFeuilleContratId = ptf.get(0).Xdata_Id__c;
			}

			result.put('ptfcId', porteFeuilleContratId);

		} catch(Exception ex) {
			response.code = HP_HttpStatus.BAD_REQUEST;
			response.message = ex.getMessage();
			response.addError('SM021-3', 'Error au niveau de l appel API XDATA : ' + HP_Constantes.XDATA_PORTEFEUILLES_CONTRATS + ' Merci de voir les log dans lobjet : HP_LOG_CALLOUT__b');
			throw new HP_WRP022_SFResponse.APIException();
		}

		HP_Contrat__c elecCont = getContractType(souscription,'ELEC');
		if(elecCont != null) {
			try{

				HP_WRP023_XdataPropositionCommecriale cp = new HP_WRP023_XdataPropositionCommecriale(Integer.valueOf(porteFeuilleContratId), selfcare.xDataId,
														     souscription.HP_Code_Electrique_Produit__c, status,'H0107');
				String idPC;
				if(elecCont.HP_Proposition_Commerciale_XdataId__c == null) {
					idPC = HP_EM025_PropositionCommecriale.createPropositionCommecrialeXdata(cp);
					response.addinfo('SM021-4', 'L appel vers XDATA : ' + HP_Constantes.XDATA_PROPOSITIONS_COMMERCIALES + ' voici l ID PC ELEC créé ' + idPC);
				} else {
					HP_EM025_PropositionCommecriale.updatePropositionCommecrialeXdata(elecCont.HP_Proposition_Commerciale_XdataId__c, cp);
					idPC = elecCont.HP_Proposition_Commerciale_XdataId__c;
					response.addinfo('SM021-5', 'L appel vers XDATA : ' + HP_Constantes.XDATA_PROPOSITIONS_COMMERCIALES + ' voici l ID PC ELEC modifié ' + idPC);
				}

				result.put('pcElecId', idPC);


			} catch(Exception ex) {
				response.code = HP_HttpStatus.BAD_REQUEST;
				response.message = ex.getMessage();
				response.addError('SM021-6', 'Error au niveau de l appel API XDATA : ' + HP_Constantes.XDATA_PROPOSITIONS_COMMERCIALES + ' Merci de voir les log dans lobjet : HP_LOG_CALLOUT__b');
				throw new HP_WRP022_SFResponse.APIException();
			}

			try{

				Map<Integer, String> res = HP_SM012_Souscription.creationSouscriptionAgilab(souscription.HP_Code_Electrique_Produit__c, souscription.HP_code_promotion__c, result.get('pcElecId'), idPrestataire);
				if(res.get(200) != null) {
					response.addinfo('SM021-7', 'L appel vers Agilab : ELEC ' + HP_Constantes.AGILAB_CREATION_SOUSCRIPTION);
				} else {
					// throw new HP_WRP022_SFResponse.APIException();
				}
			} catch(Exception ex) {
				response.code = HP_HttpStatus.BAD_REQUEST;
				response.message = ex.getMessage();
				response.addError('SM021-8', 'Error au niveau de l appel API XDATA ELEC  ' + HP_Constantes.AGILAB_CREATION_SOUSCRIPTION + ' Merci de voir les log dans lobjet : HP_LOG_CALLOUT__b');
				//throw new HP_WRP022_SFResponse.APIException();
			}
		}
		HP_Contrat__c gazCont = getContractType(souscription,'GAS');


		if(gazCont != null) {
			try {


				HP_WRP023_XdataPropositionCommecriale cp = new HP_WRP023_XdataPropositionCommecriale(Integer.valueOf(porteFeuilleContratId), selfcare.xDataId,
														     souscription.HP_Code_Gaz_Produit__c, status,'H0107');
				String idPC;
				if(gazCont.HP_Proposition_Commerciale_XdataId__c == null) {
					idPC = HP_EM025_PropositionCommecriale.createPropositionCommecrialeXdata(cp);
					response.addinfo('SM021-9', 'L appel vers XDATA : ' + HP_Constantes.XDATA_PROPOSITIONS_COMMERCIALES + ' voici l ID PC GAZ créé ' + idPC);
				} else {
					HP_EM025_PropositionCommecriale.updatePropositionCommecrialeXdata(gazCont.HP_Proposition_Commerciale_XdataId__c, cp);
					idPC = gazCont.HP_Proposition_Commerciale_XdataId__c;
					response.addinfo('SM021-10', 'L appel vers XDATA : ' + HP_Constantes.XDATA_PROPOSITIONS_COMMERCIALES + ' voici l ID PC GAZ créé ' + idPC);
				}

				response.addinfo('SM021-11', 'L appel vers XDATA : ' + HP_Constantes.XDATA_PROPOSITIONS_COMMERCIALES + ' voici l ID PC GAZ créé ' + idPC);
				result.put('pcGazId', idPC);
			} catch(Exception ex) {
				response.code = HP_HttpStatus.BAD_REQUEST;
				response.message = ex.getMessage();
				response.addError('SM021-12', 'Error au niveau de l appel API XDATA : ' + HP_Constantes.XDATA_PROPOSITIONS_COMMERCIALES + ' Merci de voir les log dans lobjet : HP_LOG_CALLOUT__b');
				throw new HP_WRP022_SFResponse.APIException();
			}
			try{
				Map<Integer, String> res = HP_SM012_Souscription.creationSouscriptionAgilab(souscription.HP_Code_Gaz_Produit__c, souscription.HP_code_promotion__c, result.get('pcGazId'),idPrestataire);
				if(res.get(200)!= null) {
					response.addinfo('SM021-13', 'L appel vers Agilab : Gaz ' + HP_Constantes.AGILAB_CREATION_SOUSCRIPTION);
				} else {
					// throw new HP_WRP022_SFResponse.APIException();
				}
			}catch(Exception ex) {
				response.code = HP_HttpStatus.BAD_REQUEST;
				response.message = ex.getMessage();
				response.addError('SM021-14', 'Error au niveau de l appel API XDATA Gaz  ' + HP_Constantes.AGILAB_CREATION_SOUSCRIPTION
						  + ' Merci de voir les log dans lobjet : HP_LOG_CALLOUT__b');
				throw new HP_WRP022_SFResponse.APIException();
			}
		}

		return result;
	}

	public static void updateDataProcessing(final HP_EnrolmentRestResourceModel.SecondSave_v0_1 selfcare, HP_Souscription__c souscription, Case acase, Map<String, String> apiResult, HP_WRP022_SFResponse response) {
		if(selfcare.distinctBillingAddress) {
			souscription.HP_Code_postal_facturation__c = selfcare.billingZipCode;
			souscription.HP_code_Postal_Insee_facturation__c = selfcare.billingInseeCityCode;
			souscription.HP_Complement_d_adresse_facturation__c = selfcare.billingAdditionalAddressInformation;
			souscription.HP_Nom_de_rue_facturation__c = selfcare.billingStreetName;
			souscription.HP_Numero_de_voie_facturation__c = selfcare.billingStreetNumber;
			souscription.HP_Nom_de_ville_facturation__c = selfcare.billingCity;
		} else {
			souscription.HP_Code_postal_facturation__c = souscription.HP_Code_postal__c;
			souscription.HP_code_Postal_Insee_facturation__c = souscription.HP_code_Postal_Insee__c;
			souscription.HP_Complement_d_adresse_facturation__c = souscription.HP_Complement_d_adresse__c;
			souscription.HP_Nom_de_rue_facturation__c = souscription.HP_Nom_de_rue__c;
			souscription.HP_Numero_de_voie_facturation__c = souscription.HP_Numero_de_voie__c;
			souscription.HP_Nom_de_ville_facturation__c = souscription.HP_Nom_de_ville__c;
		}
		if(selfcare.login != null) {
			HP_PortailUtilisateur__c userPortail = HP_EM002_PortailUtilisateur.getUtilisateurByLogin(selfcare.login);
			if(userPortail != null) {
				souscription.HP_DigitalLogin__c = userPortail.Id;
			}
		}
		//Champ migration ENGIE
		if((souscription.HP_Type_Energie__c == 'ELECTRICITY' || souscription.HP_Type_Energie__c == 'COMBINED_GAS_AND_ELECTRICITY') && selfcare.isElecENGIE != null){
			souscription.HP_isElecENGIE__c = selfcare.isElecENGIE;
		}
		if((souscription.HP_Type_Energie__c == 'GAS' || souscription.HP_Type_Energie__c == 'COMBINED_GAS_AND_ELECTRICITY') && selfcare.isGazENGIE != null ){
			souscription.HP_isGazENGIE__c = selfcare.isGazENGIE;
		}
		//Champ pour analyser les ventes et les taux de conversions des souscriptions(save2).
		souscription.HP_TECH_wasSave2__c = 1;	
		souscription.HP_DigitalDateSave2__c = selfcare.dateCreation;
		souscription.HP_DigitalExemplaires__c = selfcare.nbExemplaires;
		if(selfcare.voucherCode != null) {
			souscription.HP_VoucherCode__c = selfcare.voucherCode;
        }
		 /*  pourcentage de remise elec & gaz */

		 if(String.isNotBlank(selfcare.currentPercentReductionEleca1)) souscription.reduction_a1_elec__c =  Decimal.valueOf(selfcare.currentPercentReductionEleca1);

		 if(String.isNotBlank(selfcare.currentPercentReductionEleca2)) souscription.reduction_a2_elec__c =  Decimal.valueOf(selfcare.currentPercentReductionEleca2);
		 if(String.isNotBlank(selfcare.currentPercentReductionAboElec))  souscription.reduction_abo_elec__c =  Decimal.valueOf(selfcare.currentPercentReductionAboElec);
  
		 if(String.isNotBlank(selfcare.currentPercentReductionAboGaz))  souscription.reduction_abo_gaz__c =  Decimal.valueOf(selfcare.currentPercentReductionAboGaz);
		 if(String.isNotBlank(selfcare.currentPercentReductionGaza1))  souscription.reduction_a1_gaz__c =  Decimal.valueOf(selfcare.currentPercentReductionGaza1);
		 if(String.isNotBlank(selfcare.currentPercentReductionGaza2))  souscription.reduction_a2_gaz__c =  Decimal.valueOf(selfcare.currentPercentReductionGaza2);

         souscription.HP_EstColoc__c = '';
         if(selfcare.estColoc != null) {
         	souscription.HP_EstColoc__c = selfcare.estColoc ? 'Oui' : 'Non';   
         }
        
		 /* */
        souscription.HP_Parrainage__c = selfcare.parrainage != null ? selfcare.parrainage : false;
		List<Contact> contactList = HP_EM020_Contact.insertContact(selfcare, souscription);
        response.addInfo('SM021-15', 'Insertion de ' +contactList.size() + ' Contacts.');
        
		if(acase != null) {
			souscription.HP_Statut__c = 'SAVE_2';
			acase.ContactId = contactList.get(0).Id; 
			Database.upsert(acase,Case.Fields.HP_TECH_ExternalId__c);
			response.addinfo('SM021-16', 'insertion de case probleme de données ' + acase.Id);
			response.code = HP_HttpStatus.PRECONDITION_FAILED;

		} else {
			souscription.HP_Statut__c = 'SAVE_2_CONFIRMED';
            List<Case> enrolCaseList = HP_EM010_Case.getEnrolmentCases(souscription);
			for(Case c : enrolCaseList) {
				c.Status =  'CLOSED';
			}
			Database.upsert(enrolCaseList,Case.Fields.HP_TECH_ExternalId__c);
		}

		HP_Porte_Feuille_Contrat__c ptf = new HP_Porte_Feuille_Contrat__c();
		ptf.Xdata_Id__c = apiResult.get('ptfcId');
		ptf.HP_Contact__c = contactList.get(0).Id;
		ptf.HP_Souscription_Digital_Id__c = selfcare.selfcareId;
		Database.upsert(ptf,HP_Porte_Feuille_Contrat__c.Fields.HP_Souscription_Digital_Id__c);
		response.addinfo('SM021-17', 'insertion de porte feuille contrat ' + ptf.Id);

		List<HP_Contrat__c> contractList = new List<HP_Contrat__c>();
		HP_Contrat__c gazCont = getContractType(souscription,'GAS');
		if(gazCont != null && apiResult.get('pcGazId') != null) {
			gazCont.HP_Proposition_Commerciale_XdataId__c = apiResult.get('pcGazId');
			gazCont.HP_Porte_Feuille_Contrat__c = ptf.Id;
			contractList.add(gazCont);
		}
		HP_Contrat__c elecCont = getContractType(souscription,'ELEC');
		if(elecCont != null && apiResult.get('pcElecId') != null) {
			elecCont.HP_Proposition_Commerciale_XdataId__c = apiResult.get('pcElecId');
			elecCont.HP_Porte_Feuille_Contrat__c = ptf.Id;
			contractList.add(elecCont);
		}

        souscription.HP_Porte_Feuille_Contrat__c = ptf.Id;
		Database.upsert(souscription, HP_Souscription__c.Fields.HP_Souscription_Digital_Id__c);
		response.addinfo('SM021-18', 'update de la souscription ');
		Database.upsert(contractList,HP_Contrat__c.Fields.HP_Souscription_Digital_Id__c);
        response.addinfo('SM021-19', 'update des contrats ');
		
		HP_EM010_Case.updateXdataAnomaliesCase(souscription);
		
	}

	public static Case validationData(HP_EnrolmentRestResourceModel.SecondSave_v0_1 selfcare, HP_Souscription__c souscription) {
		String typeSouscription = souscription.HP_Type_Energie__c;
		HP_Contrat__c elecCont = getContractType(souscription,'ELEC');
		HP_Contrat__c gazCont = getContractType(souscription,'GAS');

		String raison = null;
		String description = '';

		if(typeSouscription == 'ELECTRICITY' || typeSouscription == 'COMBINED_GAS_AND_ELECTRICITY') {
			if (elecCont == null || elecCont.HP_Id_Compteur__c == null) {
				description +=  '/ '+ HP_UTIL_RecordType.getPicklistValue('Case', 'Reason', 'ELECTRICITY_BASE_METER');
			}
			if(souscription.HP_Puissance_Compteur_electrique__c == null || souscription.HP_Estimation_Consommation_electrique__c == null ||
			   (souscription.HP_Puissance_Compteur_electrique__c != null &&
			    (HP_Constantes.MAX_YEARLY_CONSUMPTION_BY_ELECTRICITY_POWER.get(souscription.HP_Puissance_Compteur_electrique__c) < souscription.HP_Estimation_Consommation_electrique__c ||
			     HP_Constantes.MIN_YEARLY_CONSUMPTION_BY_ELECTRICITY_POWER.get(souscription.HP_Puissance_Compteur_electrique__c) > souscription.HP_Estimation_Consommation_electrique__c))
			   )
			{
				description +=  '/ '+ HP_UTIL_RecordType.getPicklistValue('Case', 'Reason', 'ELECTRICITY_KVA');
			}
			if(souscription.HP_Plan_de_Prix_electrique__c == null) {
				description +=  '/ '+ HP_UTIL_RecordType.getPicklistValue('Case', 'Reason', 'ELECTRICITY_PRICING_PLAN');
			}
		}

		if((typeSouscription == 'GAS' || typeSouscription == 'COMBINED_GAS_AND_ELECTRICITY') && (gazCont == null || gazCont.HP_Id_Compteur__c == null )) {
			description += '/ '+ HP_UTIL_RecordType.getPicklistValue('Case', 'Reason', 'GAS_METER');
		}

		if(selfcare.dateCreation == null) {
			description += '/ '+ HP_UTIL_RecordType.getPicklistValue('Case', 'Reason', 'HP_EnrolmentError');
		}

		if(!String.isBlank(selfcare.login)) {
			HP_PortailUtilisateur__c utilisateur = HP_EM002_PortailUtilisateur.getUtilisateurByLogin(selfcare.login);
			if(utilisateur == null) {
				description += '/ '+ HP_UTIL_RecordType.getPicklistValue('Case', 'Reason', 'HP_EnrolmentError');
			}
		}

		if(!String.isBlank(description)) {
			return createCase(selfcare.selfcareId, description);
		}

		return null;
	}

	public static HP_Contrat__c getContractType(HP_Souscription__c souscription, String type) {
		for(HP_Contrat__c cont : souscription.HP_Contrats__r) {
			if(cont.HP_Type_de_Compteur__c == type) {
				return cont;
			}
		}
		return null;
	}

	public static Case createCase(final String selfcareId, String description) {
		final Case aCase = new Case();
		Id caseRecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case','HP_EnrolmentCase');
		aCase.RecordTypeId = caseRecordTypeId;
		acase.HP_TECH_ExternalId__c = HP_ExternalIdUtils.createExternalKey(selfcareId, 'HP_EnrolmentCase');
		aCase.HP_Souscription__r = new HP_Souscription__c(HP_Souscription_Digital_Id__c = selfcareId);
		aCase.Origin = 'HP_SELFCARE';
		aCase.HP_Type__c = 'INVALID_DATA';
		aCase.Status = 'TO_DO';
		aCase.Description = description;
		return aCase;
	}
	public class OutputSave2 {
		public Integer gasOpportunityXdataId;
		public Integer electricityOpportunityXdataId;
		public Integer contractPortfolioXdataId;

		public OutputSave2(Map<String, String> resultAPI) {
			this.contractPortfolioXdataId = resultAPI.get('ptfcId') != null ? Integer.valueOf(resultAPI.get('ptfcId')) : null;
			this.electricityOpportunityXdataId = resultAPI.get('pcElecId') != null ? Integer.valueOf(resultAPI.get('pcElecId')) : null;
			this.gasOpportunityXdataId = resultAPI.get('pcGazId') != null ? Integer.valueOf(resultAPI.get('pcGazId')) : null;
		}
	}

}