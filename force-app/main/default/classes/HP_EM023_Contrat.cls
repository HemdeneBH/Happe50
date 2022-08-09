/**
 * @File Name          : HP_EM023_Contrat.cls
 * @Description        : Data Manager spécifique à l'object SF Happe Contrat
 * @Author             : Sara El-Hannaoui
 * @Group              :
 * @Last Modified By   : Badr Eddine Belkarchi

 * @Last Modified On   : 01-20-2022

 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    07/02/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
 **/
public with sharing class HP_EM023_Contrat {


	public static void upsertContratIndexByXdataId(Decimal xDataContractId,  Decimal indexGaz, Decimal indexElec, Decimal indexElecHC, Decimal indexElecHP){
		 HP_Contrat__c contrat = new HP_Contrat__c(
			HP_Contrat_XdataId__c = xDataContractId,
			HP_Index_de_Compteur__c = indexGaz,
			HP_Compteur_Base_Plan_Index__c= indexElec,
			HP_Compteur_Variable_Plan_prix_Index__c=  indexElecHP,
			HP_Compteur_Plan_Bottom_Price_Index__c = indexElecHC
			);
			Database.upsert(contrat,HP_Contrat__c.Fields.HP_Contrat_XdataId__c);
		}

	public static List<String> saveContrat(final HP_EnrolmentRestResourceModel.FirstSave_v0_1 selfcare, String souscriptionId) {
		List<HP_Contrat__c> contratList = new List<HP_Contrat__c>();
		if(selfcare.energyType == 'ELECTRICITY' || selfcare.energyType == 'COMBINED_GAS_AND_ELECTRICITY') {
			contratList.add(buildElecContract(selfcare, souscriptionId));
		}

		if(selfcare.energyType == 'GAS' || selfcare.energyType == 'COMBINED_GAS_AND_ELECTRICITY') {
			contratList.add(buildGazContract(selfcare, souscriptionId));
		}
		Database.upsert(contratList,HP_Contrat__c.Fields.HP_Souscription_Digital_Id__c);
		List<String> idList = new List<String>();
		for(HP_Contrat__c item : contratList) {
			idList.add(item.id);
		}
		return idList;
	}

	public static HP_Contrat__c buildContract(Integer energyContractXdataId, HP_EnrolmentRestResourceModel.EnergyType energyType) {
		HP_Contrat__c cont = new HP_Contrat__c();
		cont.HP_Contrat_XdataId__c       = energyContractXdataId;
		cont.HP_Type_de_Compteur__c =   energyType.name() == 'ELECTRICITY' ? 'ELEC' : 'GAS';
		cont.HP_Souscription_Digital_Id__c = energyContractXdataId + energyType.name();
		return cont;
	}

	public static HP_Contrat__c buildElecContract(HP_EnrolmentRestResourceModel.FirstSave_v0_1 selfcare, String souscriptionId) {
		HP_Contrat__c cont = new HP_Contrat__c();
		cont.HP_Numero_reference_du_Compteur__c = selfcare.electricityMeterReferenceNumber;
		cont.HP_Id_Compteur__c = selfcare.electricityMeterId;
		cont.HP_Type_de_Compteur__c = 'ELEC';
		cont.HP_Souscription_Digital_Id__c = selfcare.selfcareId + '-ELEC';
		cont.HP_Souscription__c = souscriptionId;

		if(selfcare.electricityMeterBasePlanIndex != null)
			cont.HP_Compteur_Base_Plan_Index__c = selfcare.electricityMeterBasePlanIndex;// optional in save1
		if(selfcare.electricityMeterVariablePlanPeakPriceIndex != null)
			cont.HP_Compteur_Variable_Plan_prix_Index__c = selfcare.electricityMeterVariablePlanPeakPriceIndex;// optional in save1
		if(selfcare.electricityMeterVariablePlanBottomPriceIndex != null)
			cont.HP_Compteur_Plan_Bottom_Price_Index__c = selfcare.electricityMeterVariablePlanBottomPriceIndex;// optional in save1

		return cont;
	}
	public static HP_Contrat__c buildGazContract(HP_EnrolmentRestResourceModel.FirstSave_v0_1 selfcare, String souscriptionId) {
		HP_Contrat__c cont = new HP_Contrat__c();
		cont.HP_Numero_reference_du_Compteur__c = selfcare.gasMeterReferenceNumber;
		cont.HP_Id_Compteur__c = selfcare.gasMeterId;
		cont.HP_Type_de_Compteur__c = 'GAS';
		cont.HP_Souscription_Digital_Id__c = selfcare.selfcareId + '-GAS';
		cont.HP_Souscription__c = souscriptionId;

		if(selfcare.gasMeterIndex != null)
			cont.HP_Index_de_Compteur__c = selfcare.gasMeterIndex; // optional in save1

		return cont;
	}

	public static List<HP_Contrat__c> loadContrat(String selfcareId) {
		return [select Id, 		 
		HP_Contrat_XdataId__c,
		HP_Porte_Feuille_Contrat__r.HP_Contact__c, 
		HP_Porte_Feuille_Contrat__c,		
		HP_Type_de_Compteur__c, 
		HP_Id_Compteur__c, 
		HP_Proposition_Commerciale_XdataId__c,
		HP_Numero_reference_du_Compteur__c,
		HP_Souscription__r.HP_Souscription_Digital_Id__c,
		HP_Souscription__r.HP_Contact__r.Email,
		HP_Souscription__r.HP_Contact__r.Id_Tiers__c,
		HP_Souscription__r.HP_Contact__r.Lastname, 
		HP_Souscription__r.HP_Contact__r.Salutation,
		HP_Souscription__r.HP_Contact__r.Firstname,
		HP_Souscription__r.HP_Plan_de_Prix_electrique__c,
		HP_Souscription__r.HP_type_Souscription__c,
		HP_Souscription__r.HP_Contact__r.No_Voie__c,
		HP_Souscription__r.HP_Contact__r.MailingStreet,
		HP_Souscription__r.HP_Contact__r.Complement_adresse__c,
		HP_Souscription__r.HP_Contact__r.MailingPostalCode,
		HP_Souscription__r.HP_Contact__r.MailingCity,
		HP_Compteur_Base_Plan_Index__c, 
		HP_Compteur_Variable_Plan_prix_Index__c, 
		HP_Compteur_Plan_Bottom_Price_Index__c, 
		HP_Index_de_Compteur__c,
	    HP_Souscription__r.HP_Numero_de_voie__c,
		HP_Souscription__r.HP_Nom_de_rue__c,
		HP_Souscription__r.HP_Complement_d_adresse__c,
		HP_Souscription__r.HP_Code_postal__c,
		HP_Souscription__r.HP_Nom_de_ville__c
		from HP_Contrat__c
			where HP_Souscription__r.HP_Souscription_Digital_Id__c = : selfcareId];
	}

	public static List<HP_Contrat__c> loadContratByEnergy(String selfcareId, String energy) {
		return [select Id, 		 
		HP_Contrat_XdataId__c,
		HP_Porte_Feuille_Contrat__r.HP_Contact__c, 
		HP_Porte_Feuille_Contrat__c,		
		HP_Type_de_Compteur__c, 
		HP_Id_Compteur__c, 
		HP_Proposition_Commerciale_XdataId__c,
		HP_Numero_reference_du_Compteur__c,
		HP_Souscription__r.HP_Souscription_Digital_Id__c,
		HP_Souscription__r.HP_Contact__r.Email,
		HP_Souscription__r.HP_Contact__r.Id_Tiers__c,
		HP_Souscription__r.HP_Contact__r.Lastname, 
		HP_Souscription__r.HP_Contact__r.Salutation,
		HP_Souscription__r.HP_Contact__r.Firstname,
		HP_Souscription__r.HP_Plan_de_Prix_electrique__c,
		HP_Souscription__r.HP_type_Souscription__c,
		HP_Souscription__r.HP_Contact__r.No_Voie__c,
		HP_Souscription__r.HP_Contact__r.MailingStreet,
		HP_Souscription__r.HP_Contact__r.Complement_adresse__c,
		HP_Souscription__r.HP_Contact__r.MailingPostalCode,
		HP_Souscription__r.HP_Contact__r.MailingCity,
		HP_Compteur_Base_Plan_Index__c, 
		HP_Compteur_Variable_Plan_prix_Index__c, 
		HP_Compteur_Plan_Bottom_Price_Index__c, 
		HP_Index_de_Compteur__c,
		HP_Souscription__r.HP_Numero_de_voie__c,
		HP_Souscription__r.HP_Nom_de_rue__c,
		HP_Souscription__r.HP_Complement_d_adresse__c,
		HP_Souscription__r.HP_Code_postal__c,
		HP_Souscription__r.HP_Nom_de_ville__c 
		from HP_Contrat__c
			where HP_Souscription__r.HP_Souscription_Digital_Id__c = : selfcareId and HP_Type_de_Compteur__c = : energy];
	}

	public static HP_Contrat__c loadContratByXdataId(Integer contratXdataId) {
		return [select Id, 
		HP_Contrat_XdataId__c,
		HP_Porte_Feuille_Contrat__r.HP_Contact__c, 
		HP_Porte_Feuille_Contrat__c,
		HP_Type_de_Compteur__c,
		HP_Id_Compteur__c,
		HP_Compteur_Base_Plan_Index__c, 
		HP_Compteur_Variable_Plan_prix_Index__c, 
		HP_Compteur_Plan_Bottom_Price_Index__c, 
		HP_Index_de_Compteur__c,
		HP_Numero_reference_du_Compteur__c,
		HP_Proposition_Commerciale_XdataId__c,
		HP_Souscription__r.HP_Type_Energie__c,
		HP_Souscription__r.HP_Souscription_Digital_Id__c,
		HP_Souscription__r.HP_Contact__r.Email,
		HP_Souscription__r.HP_Contact__r.Id_Tiers__c,
		HP_Souscription__r.HP_Contact__r.Lastname, 
		HP_Souscription__r.HP_Contact__r.Salutation,
		HP_Souscription__r.HP_Contact__r.Firstname,
		HP_Souscription__r.HP_Plan_de_Prix_electrique__c,
		HP_Souscription__r.HP_type_Souscription__c,
		HP_Souscription__r.HP_Contact__r.No_Voie__c,
		HP_Souscription__r.HP_Contact__r.MailingStreet,
		HP_Souscription__r.HP_Contact__r.Complement_adresse__c,
		HP_Souscription__r.HP_Contact__r.MailingPostalCode,
		HP_Souscription__r.HP_Contact__r.MailingCity
		from HP_Contrat__c where HP_Contrat_XdataId__c =: contratXdataId limit 1];
	}

	public static List<HP_Contrat__c> loadContratListByXdataId(Integer contratXdataId) {
		return [select Id, HP_Contrat_XdataId__c,
					HP_Porte_Feuille_Contrat__r.HP_Contact__c,
					HP_Porte_Feuille_Contrat__c,
					HP_Type_de_Compteur__c,
					HP_Id_Compteur__c,
					HP_Compteur_Base_Plan_Index__c, 
					HP_Compteur_Variable_Plan_prix_Index__c, 
					HP_Compteur_Plan_Bottom_Price_Index__c, 
					HP_Index_de_Compteur__c,
					HP_Numero_reference_du_Compteur__c,
					HP_Proposition_Commerciale_XdataId__c,
					HP_Souscription__r.HP_Type_Energie__c,
					HP_Souscription__r.HP_Souscription_Digital_Id__c,
					HP_Souscription__r.HP_Contact__r.Email,
					HP_Souscription__r.HP_Contact__r.Id_Tiers__c,
					HP_Souscription__r.HP_Contact__r.Lastname, 
					HP_Souscription__r.HP_Contact__r.Salutation,
					HP_Souscription__r.HP_Contact__r.Firstname,
					HP_Souscription__r.HP_Plan_de_Prix_electrique__c,
					HP_Souscription__r.HP_type_Souscription__c,
					HP_Souscription__r.HP_Contact__r.No_Voie__c,
					HP_Souscription__r.HP_Contact__r.MailingStreet,
					HP_Souscription__r.HP_Contact__r.Complement_adresse__c,
					HP_Souscription__r.HP_Contact__r.MailingPostalCode,
					HP_Souscription__r.HP_Contact__r.MailingCity 
					from HP_Contrat__c where HP_Contrat_XdataId__c =: contratXdataId];
	}


	public static HP_AgilabContractualization agilabContractualisationBuilder(HP_Souscription__c souscription,
										  Contact cont, HP_Contrat__c acontrat, HP_Porte_Feuille_Contrat__c ptf) {
		HP_AgilabContractualization c = new HP_AgilabContractualization();
		c.code_offre = ((acontrat.HP_Type_de_Compteur__c == 'ELEC' ) ? (souscription.HP_Code_Electrique_Produit__c): (souscription.HP_Code_Gaz_Produit__c));
		c.date_proposition = HP_ConversionUtils.toString(souscription.HP_Date_Origine__c);
		c.id_client_xdata = HP_ConversionUtils.toString(integer.valueof(cont.Id_Tiers__c));
		c.code_civilite = cont.salutation == 'MR' ? '1' : '3';
		c.nom = cont.lastName;
		c.prenom = cont.firstName;
		c.email = cont.email;
		c.telephone = cont.mobilephone != null ? cont.mobilephone : cont.Phone;
		c.id_portefeuille_contrat_xdata = ptf.Xdata_Id__c;
		c.id_proposition_commerciale = acontrat.HP_Proposition_Commerciale_XdataId__c;
		c.montant_mensualite = HP_ConversionUtils.toString(acontrat.HP_Type_de_Compteur__c == 'GAS' ? souscription.HP_Montant_de_la_facturation_gaz__c : souscription.HP_Montant_de_la_facturation_electrique__c);
		c.mode_envoi_facture = '1';
		c.id_contrat_xdata = HP_ConversionUtils.toString(integer.valueof(acontrat.HP_Contrat_XdataId__c));
		c.periodicite = souscription.HP_Periode_de_facturation__c == 'MONTHLY' ? '1' : '2';
		c.modalite_de_paiement = souscription.HP_Methode_de_paiement__c == 'TRANSFER' ? '5' : '6';
		c.date_debut_souhaitee = HP_ConversionUtils.toString(souscription.HP_Date_de_Contractualisation__c);
		c.date_signature = HP_ConversionUtils.toString(System.date.today());
		c.type_demande = souscription.HP_type_Souscription__c == 'SWITCH_SUPLIER' ? '1' : '2';
		c.jour_drp =  HP_ConversionUtils.toString(integer.valueof(souscription.HP_Jour_de_facturation__c));
		c.puissance = acontrat.HP_Type_de_Compteur__c == 'ELEC' ? HP_ConversionUtils.toString(integer.valueof(souscription.HP_Puissance_Compteur_electrique__c)) : null;
		c.voucher_code =  souscription.HP_VoucherCode__c;
		c.type_energie =  souscription.HP_Type_Energie__c == 'ELECTRICITY' ? '1' : (souscription.HP_Type_Energie__c == 'GAS' ? '2' : '3');
		// index base,hp et hc
		c.index_base = (acontrat.HP_Type_de_Compteur__c == 'ELEC' && souscription.HP_Plan_de_Prix_electrique__c == 'BASE' && acontrat.HP_Compteur_Base_Plan_Index__c != null) ?  HP_ConversionUtils.toString(Integer.valueOf(acontrat.HP_Compteur_Base_Plan_Index__c)) : null;
		c.index_hp = (acontrat.HP_Type_de_Compteur__c == 'ELEC' && souscription.HP_Plan_de_Prix_electrique__c != 'BASE' && acontrat.HP_Compteur_Variable_Plan_prix_Index__c != null) ?  HP_ConversionUtils.toString(Integer.valueOf(acontrat.HP_Compteur_Variable_Plan_prix_Index__c)) : null;
		c.index_hc = (acontrat.HP_Type_de_Compteur__c == 'ELEC' && souscription.HP_Plan_de_Prix_electrique__c != 'BASE' && acontrat.HP_Compteur_Plan_Bottom_Price_Index__c != null) ?  HP_ConversionUtils.toString(Integer.valueOf(acontrat.HP_Compteur_Plan_Bottom_Price_Index__c)) : null;
		
		c.conso_annuelle_estimee = acontrat.HP_Type_de_Compteur__c == 'ELEC' ? HP_ConversionUtils.toString(integer.valueof(souscription.HP_Estimation_Consommation_electrique__c)) : null;
		c.type_comptage =souscription.HP_Plan_de_Prix_electrique__c == 'BASE' ? '1' : '2';
		c.car = acontrat.HP_Type_de_Compteur__c == 'GAS' ? HP_ConversionUtils.toString(souscription.HP_Estimation_Consommation_gaz__c) : null;
		c.point_de_livraison = acontrat.HP_Id_Compteur__c;
		c.rum = souscription.HP_RUM__c;
		c.iban =  souscription.HP_IBAN__c;
		c.titulaire_compte = cont.firstName + ' ' + cont.lastName;
		c.gaz_serial = acontrat.HP_Type_de_Compteur__c == 'GAS' ? acontrat.HP_Numero_reference_du_Compteur__c : null;
		c.gaz_index = acontrat.HP_Type_de_Compteur__c == 'GAS' ? HP_ConversionUtils.toString(acontrat.HP_Index_de_Compteur__c) : null;
		c.civilite_cotitulaire = souscription.HP_CoContractant__r.Salutation == 'MR' ? '1' : (souscription.HP_CoContractant__r.Salutation == 'MME' ? '3' : null);
		c.nom_cotitulaire = souscription.HP_CoContractant__r.lastName;
		c.prenom_cotitulaire = souscription.HP_CoContractant__r.firstName;
		c.adresse_facturation.ville = souscription.HP_Nom_de_ville_facturation__c;
		c.adresse_facturation.code_postal = souscription.HP_Code_postal_facturation__c;
		c.adresse_facturation.nom_voie = souscription.HP_Nom_de_rue_facturation__c;
		c.adresse_facturation.numero_voie = souscription.HP_Numero_de_voie_facturation__c;
		c.adresse_facturation.complement = souscription.HP_Complement_d_adresse_facturation__c;
		c.adresse_facturation.code_insee = souscription.HP_code_Postal_Insee_facturation__c;

		c.adresse_consommation.ville = souscription.HP_Nom_de_ville__c;
		c.adresse_consommation.code_postal = souscription.HP_Code_postal__c;
		c.adresse_consommation.nom_voie = souscription.HP_Nom_de_rue__c;
		c.adresse_consommation.numero_voie = souscription.HP_Numero_de_voie__c;
		c.adresse_consommation.complement = souscription.HP_Complement_d_adresse__c;
		c.adresse_consommation.code_insee = souscription.HP_code_Postal_Insee__c;
		c.id_digital_souscription = souscription.HP_Souscription_Digital_Id__c;
		c.parrainage = souscription.HP_Parrainage__c ? 'true' : 'false';
		//c.parrainage = souscription.HP_Parrainage__c; // boolean true si voucher code renseigné
		c.option_vert = souscription.HP_OptionVert__c == true ? '1' : '0';
		return c;
	}

	public static HP_EnergyContractRequest energyContractRequestBuilder(Contact cont, HP_Souscription__c souscription, HP_Contrat__c acontrat) {
		HP_EnergyContractRequest c = new HP_EnergyContractRequest();
		c.personId = String.valueOf(cont.Id_Tiers__c);
		c.salutation = cont.salutation;
		c.customerLastName = cont.lastName;
		c.customerFirstName = cont.firstName;
		c.contractStartDate = souscription.HP_Date_de_Contractualisation__c;
		c.customerMainPhone =  cont.mobilePhone != null ? cont.mobilePhone : cont.Phone;
		c.electricityPowerRatingKiloVoltAmpere = Integer.valueOf(souscription.HP_Puissance_Compteur_electrique__c);
		c.electricityPricingPlan = souscription.HP_Plan_de_Prix_electrique__c;
		c.energyMeterId = acontrat.HP_Id_Compteur__c;
		c.deliveryPointStreetName = souscription.HP_Nom_de_rue__c;
		c.deliveryPointStreetNumber= souscription.HP_Numero_de_voie__c;
		c.deliveryPointCity = souscription.HP_Nom_de_ville__c;
		c.deliveryPointPostalCode = souscription.HP_Code_postal__c;
		c.deliveryPointCountryISO2Code = 'FR';
		c.electricityMeterBasePlanIndex = acontrat.HP_Compteur_Base_Plan_Index__c != null ?  Integer.valueOf(acontrat.HP_Compteur_Base_Plan_Index__c) : null;
		c.electricityMeterVariablePlanPeakPriceIndex =acontrat.HP_Compteur_Variable_Plan_prix_Index__c != null ?
							       Integer.valueOf(acontrat.HP_Compteur_Variable_Plan_prix_Index__c) : null;
		c.electricityMeterVariablePlanBottomPriceIndex = acontrat.HP_Compteur_Plan_Bottom_Price_Index__c != null ?
								 Integer.valueOf(acontrat.HP_Compteur_Plan_Bottom_Price_Index__c) : null;
		c.estimatedConsumption = souscription.HP_Estimation_Consommation_gaz__c != null ?  Integer.valueOf(souscription.HP_Estimation_Consommation_gaz__c) : null;
		c.gasMeterIndex = acontrat.HP_Index_de_Compteur__c != null ?  Integer.valueOf(acontrat.HP_Index_de_Compteur__c) : null;

		return c;
	}
}