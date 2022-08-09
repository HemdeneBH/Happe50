/**
 * @File Name          : HP_WRP006_PortailRecords.cls
 * @Description        :
 * @Author             : Vincent Albiser
 * @Group              :
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 10-15-2021
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    01/01/2020   Vincent Albiser     Initial Version
 **/

global with sharing class HP_WRP006_PortailRecords {

	global class Request {
		public final String login;
		public final Datetime startDate;
		public final Datetime endDate;
	}

	global class Response {

		public final List<Record> records;

		global Response(List<HP_Souscription__c> souscriptionList){

			this.records = new List<Record>();
			for(HP_Souscription__c souscription : souscriptionList) {
				this.records.add(new Record(souscription));
			}
		}
	}

	global class Record {

		public final String lastName;
		public final String firstName;
		public final String email;
		public final String gasMeterId;
		public final String electricityMeterId;
		public final String energyType;
		public final String nbExemplaires;
		public final String promotionalCode;
		public final String status;
		public final String selfcareId;
		public final Datetime createdDate;
		public final String login;
		public final String prestataire;
		public final Integer contractPortfolioXdataId;
		public final String electricityDocumentId;
		public final String gasDocumentId;
		public final String revisionDocument;
		public final Boolean updatePropositionStatus;
		public final String typeSouscription;

		public final Boolean creationCPVElec;
		public final Boolean creationCPVGaz;
		public final Boolean creationMandat;
		public final String idDocumentMandate;

		public final String pcElecId;
		public final String pcGazId;
        
        public final String hps;

		public final HP_EnrolmentRestResourceModel.Consentements consentements;

		global Record(HP_Souscription__c souscription){
			this.lastName           = souscription.HP_Contact__r.LastName;
			this.firstName          = souscription.HP_Contact__r.FirstName;
			this.email              = souscription.HP_Contact__r.Email;
			this.gasMeterId         = souscription.HP_NumberPCE__c;
			this.electricityMeterId = souscription.HP_NumPDL__c;
			this.energyType         = souscription.HP_Type_Energie__c;
			this.nbExemplaires      = souscription.HP_DigitalExemplaires__c;
			this.promotionalCode    = souscription.HP_code_promotion__c;
			this.status             = souscription.HP_Statut__c;
			this.selfcareId         = souscription.HP_Souscription_Digital_Id__c;
			this.createdDate        = souscription.HP_DigitalDateSave2__c;
			this.login              = souscription.HP_DigitalLogin__r.Login__c;
			this.prestataire        = souscription.HP_DigitalLogin__r.Prestataire__r.Name;
			this.electricityDocumentId = souscription.HP_DigitalElecDocumentId__c;
			this.gasDocumentId         = souscription.HP_DigitalGazDocumentId__c;
			this.revisionDocument         = souscription.HP_Revision_Document__c;
			this.contractPortfolioXdataId = souscription.HP_Porte_Feuille_Contrat__r.Xdata_Id__c != null ? Integer.valueOf(souscription.HP_Porte_Feuille_Contrat__r.Xdata_Id__c) : null;
			this.updatePropositionStatus = souscription.HP_DigitalUpdatePropositionStatus__c;
			this.idDocumentMandate = souscription.HP_DigitalDocumentMandateId__c;
			this.typeSouscription = souscription.HP_type_Souscription__c;
            this.hps = souscription.Name;


			if(souscription.HP_creation_CPV_elec__c != null && souscription.HP_creation_CPV_elec__c != '') {
				this.creationCPVElec  = (souscription.HP_creation_CPV_elec__c == 'Oui' ? true : false);
			}

			if(souscription.HP_creation_CPV_gaz__c != null && souscription.HP_creation_CPV_gaz__c != '') {
				this.creationCPVGaz = (souscription.HP_creation_CPV_gaz__c == 'Oui' ? true : false);
			}

			if(souscription.HP_creation_mandat__c != null && souscription.HP_creation_mandat__c != '') {
				this.creationMandat = (souscription.HP_creation_mandat__c == 'Oui' ? true : false);
			}

			for(HP_Contrat__c acontrat : souscription.HP_Contrats__r) {
				if(acontrat.HP_Type_de_Compteur__c == 'ELEC') {
					this.pcElecId = acontrat.HP_Proposition_Commerciale_XdataId__c;
				} else if(acontrat.HP_Type_de_Compteur__c == 'GAS') {
					this.pcGazId = acontrat.HP_Proposition_Commerciale_XdataId__c;
				}
			}
		}
	}

}