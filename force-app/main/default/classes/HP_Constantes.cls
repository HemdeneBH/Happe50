/**
 * @File Name          : HP_Constantes.cls
 * @Description        :
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              :
 * @Last Modified By   : Badr Eddine Belkarchi






 * @Last Modified On   : 07-20-2022










 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    20/01/2020   Mohamed Aamer     Initial Version
 **/
public with sharing class HP_Constantes {

	/* Variables pour le WS ES-Correspondance (envoi email) */
	public static final String WS_ES_CORRESPONDANCE_NAME = 'ES-Correspondance_v2';
	public static final String WS_ES_CORRESPONDANCE_VERSION = '1.00';
	public static final String WS_ES_CORRESPONDANCE_CONTEXT = '0';
	public static final String WS_ES_CORRESPONDANCE_ID_APPLICATION = 'CABESTANHAPPE';
	public static final String WS_ES_CORRESPONDANCE_SEND_MODE_CODE = 'ASYN';
	public static final String WS_ES_CORRESPONDANCE_SEND_MODE_WORDING = 'mode asynchrone';
	public static final String WS_ES_CORRESPONDANCE_CONTENU = 'CONTENU';
	public static final String WS_ES_CORRESPONDANCE_OBJET = 'Confirmation de la modification de vos informations personnelles';
	/* Fin */

	/* Variables pour le WS Octopus  */
	public static final String WS_ES_OCTOPUS_VERSION = '2.0';
	public static final String WS_ES_OCTOPUS_CONTEXT = '0';
	public static final String WS_ES_OCTOPUS_PDLELEC_NAME = 'ES-PDLElec_v3';
	/* Fin */

	/* Variables pour les parametrages des API */
	public static final String DEFAULT_CACHE_TYPE= 'local';
	/* Fin */

	/* Email de confirmation après modification informations Client */
	public static final String INFO_CLIENT_EMAIL_TEMPLATE = 'SF52';
	public static final String INFO_CLIENT_EMAIL_TEMPLATE_NAME = 'HP_Email_Informations_Client';
	public static final String INFO_CLIENT_EMAIL_IDFORM = 'Mail happe';
	public static final String INFO_CLIENT_EMAIL_KEY = 'EMAIL';
	public static final String INFO_CLIENT_EMAIL_VALUE = 'Email';
	public static final String INFO_CLIENT_EMAIL_OBJET_KEY = 'OBJET';
	public static final String INFO_CLIENT_EMAIL_ID_CLIENT = 'idclient';
	public static final String INFO_CLIENT_EMAIL_SUBJECT = 'Envoi Email: ';

	/* Fin */

	/* SMS de confirmation après modification informations Client */
	public static final String INFO_CLIENT_SMS_TEMPLATE = 'SMS1';
	public static final String INFO_CLIENT_SMS_TEMPLATE_NAME = 'HP_SMS_Informations_Client';
	public static final String INFO_CLIENT_SMS_IDFORM = 'SMS Happ-e';
	public static final String INFO_CLIENT_SMS_KEY = 'SMS';
	public static final String INFO_CLIENT_SMS_MOBILE_KEY = 'numeroTel';
	public static final String INFO_CLIENT_SMS_GSM_KEY = 'GSM';
	public static final String INFO_CLIENT_SMS_SUBJECT = 'Envoi SMS: ';
	/* Fin */

	public static final String CASE_STATUS_CANCELED = 'CANCELED';
	public static final String CONTRACT_XADATA_STATUS_CANCELED  = 'H0104';
	public static final String CONTRACT_AGILAB_STATUS_CANCELED  = '6';
	public static final String CONTRACT_XDATA_STATUS_AWAITING = 'H0101';

	/* Emailing Batch  */
	public static final String AGILAB_ID_BATCH = 'source_Emailing_Batch__c';
	public static final String CONSUMER_BATCH = 'consumer_Emailing_Batch__c';
	public static final String DATE_BATCH = 'date_Emailing_Batch__c';
	/* Fin */

	public static final String BASE = 'BASE';
	public static final String VARIABLE ='VARIABLE';
	public static final String DOSSIER_AIDE ='Dossier_Aide';

	/* Endpoint KEY */
	public static final String AGILAB_CREATION_SOUSCRIPTION =  'AGILAB_PROPOSITION_SOUSCRIPTION';
	public static final String AGILAB_PROPOSITION_MODIFIER =  'AGILAB_PROPOSITION_MODIFIER';
	public static final String AGILAB_CONTRACTUALISATION =  'AGILAB_CONTRACTUALISATION';
	public static final String AGILAB_CREATE_NOTE_CREDIT =  'AGILAB_CREATE_NOTE_CREDIT';
	public static final String AGILAB_CANCEL_NOTE_CREDIT =  'AGILAB_CANCEL_NOTE_CREDIT';
	public static final String AGILAB_SOLDE_EFFECTIF =  'AGILAB_SOLDE_EFFECTIF';
	public static final String AGILAB_MAJ_MENSUALITE =  'AGILAB_MAJ_MENSUALITE';
	public static final String AGILAB_PORTFEUILLE_CONTRACT_FACTURE = 'AGILAB_PORTFEUILLE_CONTRACT_FACTURE';
	public static final String AGILAB_AFFICHIER_INFORMATION_CONTRAT = 'AGILAB_AFFICHIER_INFORMATION_CONTRAT';
	public static final String AGILAB_AFFICHER_ECHENACE_CONTRAT = 'AGILAB_AFFICHER_ECHENACE_CONTRAT';
	public static final String AGILAB_AFFICHER_AUTO_RELEVE = 'AGILAB_AFFICHER_AUTO_RELEVE';
	public static final String AGILAB_AFFICHIER_INFORMATION_AIDE = 'AGILAB_AFFICHIER_INFORMATION_AIDE';
	public static final String AGILAB_MODIFIER_INFORMATION_AIDE = 'AGILAB_MODIFIER_INFORMATION_AIDE';
	public static final String AGILAB_ENVOI_INDEXES = 'AGILAB_ENVOI_INDEXES';
	public static final String AGILAB_AFFICHIER_PERSONNE = 'AGILAB_AFFICHIER_PERSONNE';
	public static final String AGILAB_GRILLE_PRICINGS_GET = 'AGILAB_GRILLE_PRICINGS_GET';
	public static final String AGILAB_MODIFIER_MODE_ENVOI_FACTURE = 'AGILAB_MODIFIER_MODE_ENVOI_FACTURE';
	public static final String AGILAB_PERSONNE_CLIENT_OFFLINE = 'AGILAB_PERSONNE_CLIENT_OFFLINE';
	public static final String AGILAB_VOIR_REMBOURSEMENT = 'AGILAB_VOIR_REMBOURSEMENT';
	public static final String AGILAB_CONTACT_NOTIFIER_MODIFICATION = 'AGILAB_CONTACT_NOTIFIER_MODIFICATION';
	public static final String AGILAB_HAPPE_RESILIATION_CREATE = 'AGILAB_HAPPE_RESILIATION_CREATE';
	public static final String AGILAB_RECLAMATION_NOTIFIER = 'AGILAB_RECLAMATION_NOTIFIER';
	public static final String AGILAB_PERSONNE_XDATA_ID =  'AGILAB_PERSONNE_XDATA_ID';
	public static final String AGILAB_CHERCHER_CONTRAT_ID ='AGILAB_CHERCHER_CONTRAT_ID';
	public static final String HP_BUYAPOWA_API = 'HP_BUYAPOWA_API';
	public static final String AGILAB_CONTRAT_PAIEMENT ='AGILAB_CONTRAT_PAIEMENT';
	public static final String STREAM_PURGE_API_SERVICE ='STREAM_PURGE_API_SERVICE';
	public static final String HP_OKTA_GROUP_ID = 'HP_OKTA_GROUP_IDS';
	public static final String HP_OKTA_CREATE_USER = 'HP_OKTA_CREATE_USER';
	public static final String HP_OKTA_USER = 'HP_OKTA_USER';
	public static final String AGILAB_VOIR_PLANS_APUREMENT = 'AGILAB_VOIR_PLANS_APUREMENT';
	public static final String AGILAB_DOCUMENTS = 'AGILAB_DOCUMENTS';

	
	public static final String API_MARKETING_CLOUD =  'API_MARKETING_CLOUD';
	public static final String SOGENACTIF =  'SOGENACTIF';

	public static final String AGILAB_PERSONNE_CONSOMMATION =  'AGILAB_PERSONNE_CONSOMMATION';
	public static final String AGILAB_CO_TITULAIRES = 'AGILAB_CO_TITULAIRES';


	public static final String AGILAB_HAPPE_ENEGIE_VERT = 'AGILAB_HAPPE_ENEGIE_VERT';

	public static final String XDATA_QUESTION_CONSENTEMENT = 'XDATA_QUESTION_CONSENTEMENT';
	public static final String XDATA_COORDONNEES_BANCAIRES = 'XDATA_COORDONNEES_BANCAIRES';
	public static final String XDATA_MANDATS = 'XDATA_MANDATS';
	public static final String XDATA_LOCAUX_CONTRATS = 'XDATA_LOCAUX_CONTRATS';
	public static final String XDATA_PERSONNE = 'XDATA_PERSONNE';
	public static final String XDATA_CONTRATS = 'XDATA_CONTRATS';
	public static final String XDATA_ELEC_PDL = 'XDATA_ELEC_PDL';
	public static final String XDATA_GAZ_PDL = 'XDATA_GAZ_PDL';
	public static final String XDATA_CONSENTEMENTS = 'XDATA_CONSENTEMENTS';
	public static final String XDATA_PORTEFEUILLES_CONTRATS = 'XDATA_PORTEFEUILLES_CONTRATS';
	public static final String XDATA_PROPOSITIONS_COMMERCIALES = 'XDATA_PROPOSITIONS_COMMERCIALES';
	public static final String XDATA_ZONE_DISTRIBUTION = 'XDATA_ZONE_DISTRIBUTION';
	public static final String XDATA_CODEPOSTAUX_VILLES = 'XDATA_CODEPOSTAUX_VILLES';
	public static final String XDATA_PROTECTED_DQE_MAIL = 'XDATA_PROTECTED_DQE_MAIL';
	public static final String XDATA_PROTECTED_DQE_TEL = 'XDATA_PROTECTED_DQE_TEL';
	public static final String XDATA_CODE_OFFRE = 'XDATA_CODE_OFFRE';

	public static final String TRANQUILITY_GET_CONTRAT = 'TRANQUILITY_GET_CONTRAT';
	public static final String MEDIATECH = 'MEDIATECH';
	public static final String API_GOUV ='API_GOUV';
	public static final String PILOTAGE_GET_EMAILS = 'PILOTAGE_GET_EMAILS';
	public static final String GET_PERSONNE = 'GET_PERSONNE';

	public static final String SGUT_USER_CREATION = 'SGUT_USER_CREATION';
	public static final String SGUT_GET_UTILISATEUR = 'SGUT_GET_UTILISATEUR';
	public static final String SGUT_PUT_PASSWORD = 'SGUT_PUT_PASSWORD';
	public static final String SGUT_USER_DELETION = 'SGUT_USER_DELETION';
	
	public static Boolean IS_HAPPE_PROFILE;
	public static Boolean USE_API_LOG;

	public static final String XDATA_PROTECTED_DQE_ADDRESS ='XDATA_PROTECTED_DQE_ADDRESS';
	public static final String XDATA_PROTECTED_DQE_COMPLEMENT_ADDRESS ='XDATA_PROTECTED_DQE_COMPLEMENT_ADDRESS';

	static {
		IS_HAPPE_PROFILE = FeatureManagement.checkPermission('HP_IS_HAPPE_PROFILE');
		USE_API_LOG = FeatureManagement.checkPermission('HP_USE_API_LOG');
	}
	public static final String AVIS_VERIFIES = 'AVIS_VERIFIES';
	/* Fin */


	/* Maps */
	public static final Map<String, String> ENERGY_TYPE_BY_PRODUCT_FAMILY = new Map<String, String> {
		'HP_GAS' => 'Gaz',
		'HP_GAS' => 'Gaz',
		'HP_GAS_METER' => 'Gaz',
		'HP_ELECTRICITY' => 'Elec',
		' HP_ELECTRICITY_OPTION_PRICING_PLAN'=> 'Elec',
		'HP_ELECTRICITY_OPTION'=> 'Elec',
		'HP_ELECTRICITY'=> 'Elec',
		'HP_ELECTRICITY_METER'=> 'Elec'
	};

	public static final Map<Decimal, Decimal> MAX_YEARLY_CONSUMPTION_BY_ELECTRICITY_POWER = new Map<Decimal, Decimal> {
		3 => 10001,
		6 => 10001,
		9 => 15000,
		12 => 25001,
		15 => 25001,
		18 => 30001,
		24 => 75000,
		30 => 75000,
		36 => 75000
	};

	public static final Map<Decimal, Decimal> MIN_YEARLY_CONSUMPTION_BY_ELECTRICITY_POWER = new Map<Decimal, Decimal> {
		3 => 99,
		6 => 499,
		9 => 499,
		12 => 499,
		15 => 499,
		18 => 499,
		24 => 499,
		30 => 499,
		36 => 499
	};

	public final static Map<String, String> AGILAB_STATUS_BY_STATUS = new Map<String, String> {
		'OpportunitySent' => '1',
		'GeneralTermsAndConditionOfSalesSent' => '2',
		'GeneralTermsAndConditionOfSalesCancelled' => '5',
		'AwaitingEnergyDistributor' => '8',
		'EnergyDistributorError' => '9',
		'InCancellation' => '12',
		'Terminated' => '13'
	};

	public final static Map<String, Integer> CASE_PRIORITY_ROUTING = new Map<String, Integer> {
		'Low' => 3,
		'Medium' => 2,
		'High' => 1
	};
	public final static  Map<String, Object> OPS_CRENEAUX = new Map<String, String> {
        'jou' => 'Journée',
        'dma' => 'Début de matinée',
        'fma' => 'Fin de matinée',
        'ma' => 'Matin',
        'dap' => 'Début d’après midi',
        'fap' => 'Fin d’après midi',
        'apm' => 'Après midi',
        'fjo' => 'Fin de journée',
        'dso' => 'Début de soirée',
        'mjo' => 'Milieu de soirée',
        'soi' => 'Soir',
        'fso' => 'Fin de soirée'
    };             

	/* Fin */
	/*  */

}