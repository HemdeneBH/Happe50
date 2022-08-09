/**
 * @File Name          : HP_SLCT_Case.cls
 * @Description        :
 * @Author             : Sara El-Hannaoui
 * @Group              :
 * @Last Modified By   : Hemdene Ben Hammouda
 * @Last Modified On   : 03-15-2022
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    13/01/2020   Mohamed Aamer     Initial Version
 **/
global  class HP_SLCT_Case {
	global enum Origin {
		HP_SELFCARE,
		HP_CRM,
		Email,
		Phone,
		Web,
		HP_BILLING

	}

	global enum Type {
		HP_MANUAL_PROCESS,
		HP_AUTOMATED_PROCESS,
		INVALID_DATA,
		CONTRACT_CANCELATION,
		HP_CaseRecontact,
		HP_Contractualization,
		HP_CONTRACT_DATA,// pour la vie de contrat
		HP_Form_Site
	}

	global enum Reason {
		GAS_METER,
		ELECTRICITY_BASE_METER,
		ELECTRICITY_VARIABLE_METER,
		ENERGY_METER,
		ELECTRICITY_KVA,
		ELECTRICITY_PRICING_PLAN,
		MISSING_ELECTRICTY_KVA, //TODO
		HP_PRESTATION_GRD,
		HP_EnrolmentError,
		HP_CUT,
		HP_Recontact_Customer
	}

	global enum Source {
		HP_CLIENT,
		HP_PROVIDER
	}

	global enum Status {
		NEW_CASE,
		CANCELED,
		TO_DO,
		CLOSED,
		DISCARDED,
		HP_PENDING,
		HP_EXCEPTION
	}

	global enum Energy {
		Gas,
		Electricity
	}

	public static final Set<Status> ACTIVE_STATUS_SET = new Set<Status> {
		Status.NEW_CASE,
		Status.TO_DO,
		STATUS.HP_PENDING
	};

	private static final Set<String> ACTIVE_STRING_STATUS_SET = new Set<String>();
	static {
		for (Status status : ACTIVE_STATUS_SET) {
			ACTIVE_STRING_STATUS_SET.add(status.name());
		}
	}



	public static Database.QueryLocator retrievePendingPrestationDistributeurQueryLocator() {
		return Database.getQueryLocator([
							SELECT
							Id,
							HP_Contrat__r.HP_Souscription__r.Id ,
							HP_Contrat__r.HP_Souscription__r.HP_Methode_de_paiement__c ,
							HP_Contrat__r.HP_Souscription__r.HP_Periode_de_facturation__c ,
							HP_Contrat__r.HP_Souscription__r.HP_Puissance_Compteur_electrique__c ,
							HP_Contrat__r.HP_Souscription__r.HP_Estimation_Consommation_gaz__c ,
							HP_Contrat__r.HP_Souscription__r.HP_Montant_de_la_facturation_gaz__c ,
							HP_Contrat__r.HP_Souscription__r.HP_Type_Energie__c ,
							HP_Contrat__r.HP_Souscription__r.HP_code_promotion__c ,
							HP_Contrat__r.HP_Souscription__r.HP_Date_Origine__c ,
							HP_Contrat__r.HP_Souscription__r.HP_Souscription_Digital_Id__c ,
							HP_Contrat__r.HP_Souscription__r.HP_Montant_de_la_facturation_electrique__c ,
							HP_Contrat__r.HP_Souscription__r.HP_Date_de_Contractualisation__c ,
							HP_Contrat__r.HP_Souscription__r.HP_type_Souscription__c ,
							HP_Contrat__r.HP_Souscription__r.HP_Estimation_Consommation_electrique__c ,
							HP_Contrat__r.HP_Souscription__r.HP_Plan_de_Prix_electrique__c ,
							HP_Contrat__r.HP_Souscription__r.HP_Code_Electrique_Produit__c ,
							HP_Contrat__r.HP_Souscription__r.HP_Code_Gaz_Produit__c ,
							HP_Contrat__r.HP_Souscription__r.HP_Code_postal__c ,
							HP_Contrat__r.HP_Souscription__r.HP_code_Postal_Insee__c ,
							HP_Contrat__r.HP_Souscription__r.HP_Complement_d_adresse__c ,
							HP_Contrat__r.HP_Souscription__r.HP_Nom_de_rue__c ,
							HP_Contrat__r.HP_Souscription__r.HP_Numero_de_voie__c ,
							HP_Contrat__r.HP_Souscription__r.HP_Nom_de_ville__c ,
							HP_Contrat__r.HP_Souscription__r.HP_Code_postal_facturation__c ,
							HP_Contrat__r.HP_Souscription__r.HP_code_Postal_Insee_facturation__c ,
							HP_Contrat__r.HP_Souscription__r.HP_Complement_d_adresse_facturation__c ,
							HP_Contrat__r.HP_Souscription__r.HP_Nom_de_rue_facturation__c ,
							HP_Contrat__r.HP_Souscription__r.HP_Numero_de_voie_facturation__c ,
							HP_Contrat__r.HP_Souscription__r.HP_Nom_de_ville_facturation__c ,
							

							HP_Contrat__r.HP_Souscription__r.HP_Contact__r.Email,
							HP_Contrat__r.HP_Souscription__r.HP_Contact__r.Id_Tiers__c,
						    HP_Contrat__r.HP_Souscription__r.HP_Contact__r.Lastname,
							HP_Contrat__r.HP_Souscription__r.HP_Contact__r.Salutation,
							HP_Contrat__r.HP_Souscription__r.HP_Contact__r.Firstname,


							HP_Contrat__r.HP_Souscription__r.HP_CoContractant__r.Id ,
							HP_Contrat__r.HP_Souscription__r.HP_CoContractant__r.Salutation ,
							HP_Contrat__r.HP_Souscription__r.HP_CoContractant__r.lastName ,
							HP_Contrat__r.HP_Souscription__r.HP_CoContractant__r.firstName ,
							HP_Contrat__r.HP_Souscription__r.HP_Parrainage__c ,

							HP_Contrat__r.HP_Souscription__r.HP_isLinky__c,
							HP_Contrat__r.HP_Souscription__r.HP_isCommunicantElec__c,
							HP_Contrat__r.HP_Souscription__r.HP_isGaspar__c,
							HP_Contrat__r.HP_Souscription__r.HP_isCommunicantGaz__c,

							HP_Contrat__r.HP_Souscription__r.HP_ActivationPrioritaire__c,

							HP_Contrat__r.HP_Porte_Feuille_Contrat__r.HP_Souscription_Digital_Id__c,
							HP_Contrat__r.HP_Porte_Feuille_Contrat__r.Xdata_Id__c,
							HP_Contrat__r.Id ,
							HP_Contrat__r.HP_Porte_Feuille_Contrat__c,
							HP_Contrat__r.HP_Id_Compteur__c ,
							HP_Contrat__r.HP_Contrat_XdataId__c,
							HP_Contrat__r.HP_Numero_reference_du_Compteur__c ,
							HP_Contrat__r.HP_Proposition_Commerciale_XdataId__c ,
							HP_Contrat__r.HP_Souscription_Digital_Id__c ,
							HP_Contrat__r.HP_Type_de_Compteur__c ,
							HP_Contrat__r.HP_Index_de_Compteur__c,
							Contact.Id_Tiers__c,
							Contact.Adresse_Mail_Principale__c,
							Contact.Email,
							Contact.Id,
							Contact.Salutation,
							Contact.MailingStreet,
							Contact.lastName,
							Contact.No_Voie__c,
							Contact.firstName,
							Contact.MobilePhone,
							Contact.Phone,
							Contact.Complement_adresse__c,
							Contact.MailingPostalCode,
							Contact.MailingCity,
							Contact.HP_Shared_URL__c,
							HP_Contrat__r.HP_Compteur_Base_Plan_Index__c,
							HP_Contrat__r.HP_Compteur_Variable_Plan_prix_Index__c,
							HP_Contrat__r.HP_Compteur_Plan_Bottom_Price_Index__c,
							Status,
							Reason,
							OwnerId,
							HP_Type__c
							FROM
							Case
							WHERE
								(Case.Status ='HP_PENDING')
							AND (HP_Type__c = 'HP_AUTOMATED_PROCESS')
							AND (HP_Contrat__r.HP_Souscription__r.HP_Date_de_Contractualisation__c  != null)
						]);
	}

	public static Database.QueryLocator retrievePendingCoupureQueryLocator() {
		return Database.getQueryLocator([
							SELECT
							Id,
							HP_Contrat__r.HP_Porte_Feuille_Contrat__r.HP_Souscription_Digital_Id__c,
							HP_Contrat__r.HP_Porte_Feuille_Contrat__r.Xdata_Id__c,
							HP_Contrat__r.Id ,
							HP_Contrat__r.HP_Porte_Feuille_Contrat__c,
							HP_Contrat__r.HP_Id_Compteur__c ,
							HP_Contrat__r.HP_Contrat_XdataId__c,
							HP_Contrat__r.HP_Numero_reference_du_Compteur__c ,
							HP_Contrat__r.HP_Proposition_Commerciale_XdataId__c ,
							HP_Contrat__r.HP_Souscription_Digital_Id__c ,
							HP_Contrat__r.HP_Type_de_Compteur__c ,
							HP_Contrat__r.HP_Index_de_Compteur__c,
							Contact.Id_Tiers__c,
							Contact.Adresse_Mail_Principale__c,
							Contact.Email,
							Contact.Id,
							Contact.Salutation,
							Contact.MailingStreet,
							Contact.lastName,
							Contact.No_Voie__c,
							Contact.firstName,
							Contact.MobilePhone,
							Contact.Phone,
							Contact.Complement_adresse__c,
							Contact.MailingPostalCode,
							Contact.MailingCity,
							Contact.HP_Shared_URL__c,
							HP_Contrat__r.HP_Compteur_Base_Plan_Index__c,
							HP_Contrat__r.HP_Compteur_Variable_Plan_prix_Index__c,
							HP_Contrat__r.HP_Compteur_Plan_Bottom_Price_Index__c,
							Status,
							OwnerId,
							HP_Type__c, 
                            HP_Client_Aide__c, 
                            HP_TreatmentDate__c, 
                            HP_Energy__c, 
                            HP_Sous_type__c, 
                            HP_Xdata_Contrat__c,
                            HP_PDL_PCE__c,
                            ContactId,
							HP_Type_compteur_electricite__c
							FROM
							Case
							WHERE
								Status ='HP_PENDING'
							AND HP_Type__c = 'HP_Coupure_ReductionPuissance'
							AND RecordType.DeveloperName = 'HP_Facturation'
						]);
	}

	public static List<Case> getCancelationCase(Decimal idContract){ //FIXME remove and use core method
		return retrieveActiveCancelationCase((Integer)idContract);
	}

	public static List<Case> retrieveActiveCancelationCase(final Integer contractXdataId){
		return [
			SELECT
			HP_EffectiveDate__c,
			HP_index_gaz__c,
			HP_index_elec_base__c,
			HP_index_elec_hp__c,
			HP_index_elec_hc__c,
			HP_Source__c,
			Status,
			HP_TreatmentDate__c,
			ContactId
			FROM
			Case
			WHERE
				(HP_TECH_ExternalId__c =: HP_CancelationCaseUtils.buildCaseExternalId(contractXdataId))
			AND (RecordType.DeveloperName = 'HP_ContractCancelationCase')
			AND (Status IN: ACTIVE_STRING_STATUS_SET)
		];
	}

}