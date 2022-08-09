/**
 * @File Name          : HP_EnrolmentRestResourceModel.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              :






 * @Last Modified By   : Hemdene Ben Hammouda
 * @Last Modified On   : 05-30-2022






 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    31/12/2019   Vincent Albiser     Initial Version
 **/
global with sharing class HP_EnrolmentRestResourceModel {

	global SelfcareLead selfcareLead;

	global class SelfcareLead {
		public FirstSave_v0_1 firstSave_v0_1;
		public SecondSave_v0_1 secondSave_v0_1;
		public ThirdSave_v0_1 thirdSave_v0_1;
	}

	global enum EnrolmentType {//TODO move to Opportunity / lead
		MOVING_IN, //EM 1
		SWITCH_SUPLIER //CHF 2
	}

	global enum EnergyType {
		ELECTRICITY, // Electricity 1
		GAS, // gas 2
		COMBINED_GAS_AND_ELECTRICITY // dual 3 // should be list of EnergyType instead
	}

	global enum BillingPeriodicity {//TODO move to EnrolmentDetails / (contract / Asset / Order / nowhere)?
		MONTHLY, // Mensuel » si valeur =1
		BIMONTHLY // « Bimestriel » si valeur = 2>
	}

	global enum BillingMethod {//TODO move to EnrolmentDetails / (contract / Asset / Order / nowhere)?
		TRANSFER, // « prélèvement » si valeur = 1
		BANK_CARD // « carte bancaire » si valeur = 2
	}

	global enum Salutation {//TODO move to lead / Contact?
		MR,
		MME
	}

	public static final Map<String, BillingPeriodicity> BILLING_PERIODICITY_BY_NAME = new Map<String, BillingPeriodicity> {
		BillingPeriodicity.MONTHLY.name( )=> BillingPeriodicity.MONTHLY,
		BillingPeriodicity.BIMONTHLY.name( )=> BillingPeriodicity.BIMONTHLY
	};

	public static final Map<String, BillingMethod> BILLING_METHOD_BY_NAME = new Map<String, BillingMethod> {
		BillingMethod.TRANSFER.name( )=> BillingMethod.TRANSFER,
						       BillingMethod.BANK_CARD.name( )=> BillingMethod.BANK_CARD
	};

	public static final Map<String, Salutation> SALUTATION_BY_NAME = new Map<String, Salutation> {
		Salutation.MR.name( )=> Salutation.MR,
						    Salutation.MME.name( )=> Salutation.MME
	};

	public static final Map<String, EnrolmentType> ENROLMENT_TYPE_BY_NAME = new Map<String, EnrolmentType> {
		EnrolmentType.MOVING_IN.name() => EnrolmentType.MOVING_IN,
						       EnrolmentType.SWITCH_SUPLIER.name() => EnrolmentType.SWITCH_SUPLIER
	};

	global class ThirdSave_v0_1 {
		// EnrolmentDetails
		public final String selfcareId {get; set;}
		public final String internationalBankAccountNumber; 
		public final String singleEuroPaymentAreaUniqueMandateReference;
		public final Boolean isSignedByContractHolder;
		public final Integer contractPortfolioXdataId;
		public final Integer gasContractXdataId;
		public final Integer electricityContractXdataId;
		// HAPP-1002
		public final Boolean updatePropositionStatus;
		// HAPP-921
		public final String electricityDocumentId;
		public final String gasDocumentId;
		// CASEs
		public final Boolean cancelContract;
		public final List<HP_CancelationCaseRestResourceModel.CancelationCase_v0_1> cancelationCaseList_v0_1;
		public final Date cancelationCaseEffectiveDate;

		public final Boolean creationCPVElec;
		public final Boolean creationCPVGaz;
		public final boolean creationMandat;
		public final String revisionDocument;
		public final String idDocumentMandate;
		public final Consentements consentements;
	}

	global class SecondSave_v0_1 {
		/* HP_Souscription__c */
		public final String selfcareId;
		//public final String internationalBankAccountNumber;
		//public final String recordLink;
		public final Integer xDataId;
		public final Boolean distinctBillingAddress;
		public final String billingStreetNumber;
		public final String billingStreetName;
		public final String billingCity;
		public final String billingZipCode;
		public final String billingInseeCityCode;
		public final String billingAdditionalAddressInformation;
		// HAPP-674
	 	public final String voucherCode;  
		public final Boolean parrainage; 
		// HAPP-921 /*  Portail Utilisateur */
		public final String login;             
		public final String nbExemplaires; 
		public final Datetime dateCreation; 
		/* Contact */
		public final Salutation salutation;
		public final String lastName;
		public final String firstName;
		public final String email;
		public final String mobilePhone;
		public final String homePhone;

		public final Boolean secondContractHolder;
		public final Integer secondContractHolderXDataId;
		public final Salutation secondContractHolderSalutation;
		public final String secondContractHolderLastName;
		public final String secondContractHolderFirstName;
		public final String secondContractHolderEmail;
	
		public final boolean isElecENGIE;
		public final boolean isGazENGIE;
	
		/* update pourcentage de remise elec & gaz */
		public final String currentPercentReductionEleca1;
		public final String currentPercentReductionEleca2;
		public final String currentPercentReductionAboElec;

		public final String currentPercentReductionAboGaz;
        public final String currentPercentReductionGaza1;
		public final String currentPercentReductionGaza2;

        public final Boolean estColoc;


		public final Date contractStartDate;
		public final Integer gasMeterIndex;
		public final Integer electricityMeterBasePlanIndex;
		public final Integer electricityMeterVariablePlanPeakPriceIndex;
		public final Integer electricityMeterVariablePlanBottomPriceIndex;
	
	}

	global class FirstSave_v0_1 {

		/* HP_Souscription__c */
		public final String selfcareId;
		public final String recordLink;
		public final String salesChannel;
		public final String source;
		public final String streetNumber;
		public final String streetName;
		public final String city;
		public final String zipCode;
		public final String inseeCityCode;
		public final String additionalAddressInformation;
		public final String enrolmentType;
		public final DateTime originDateTime;
		public final Date contractStartDate;
		public final String ownerGaiaId;
		public final String energyType;
		public final String billingPeriodicity;
		public final String billingMethod;
		public final Integer billingDay;
		public final Double electricityBillingAmount;
		public final Double gasBillingAmount;
		public final String promotionalCode;
		public final String formerContractHolderLastName;
		public final Boolean greenElectricity;
		public final String electricityPricingPlan;
		public final Integer electricityPowerRatingKiloVoltAmpere;
		public final String gasConsumptionClass;
		public final Integer gasEstimatedConsumptionKiloWatt;
		public final Integer electricityEstimatedConsumptionKiloWatt;
		public final String gasProductCode;
		public final String electricityProductCode;
		public final Boolean optionVert;
		public final Boolean consentement_grd;
		/* HP_Contrat__c[] */
		public final String electricityMeterReferenceNumber;
		public final String gasMeterReferenceNumber;
		public final String electricityMeterId;
		public final String gasMeterId;
		public final Integer gasMeterIndex;
		public final Integer electricityMeterBasePlanIndex;
		public final Integer electricityMeterVariablePlanPeakPriceIndex;
		public final Integer electricityMeterVariablePlanBottomPriceIndex;
	
		/* Attachment*/
		public PhotoCompteur electricityPhoto;
		public PhotoCompteur gasPhoto;
	
		/* Campagne marketing*/
		public Campagne campagneInfos;

		/* pourcentage de remise elec & gaz */
		public final String currentPercentReductionEleca1;
		public final String currentPercentReductionEleca2;
		public final String currentPercentReductionAboElec;

		public final String currentPercentReductionAboGaz;
        public final String currentPercentReductionGaza1;
		public final String currentPercentReductionGaza2;


		/**email devis */
		public final String email_devis;


	}

	global  class PhotoCompteur {
		public  String body;
		public  String contentType;
	}

	global class Campagne{
		public String campaignLabel ;
		public String campaignSource ;
		public String campaignMedium ;
	}

	global class Consentements{
		//questions
		public Boolean q11;
		public Boolean q12;
		public Boolean q13;
	}
}