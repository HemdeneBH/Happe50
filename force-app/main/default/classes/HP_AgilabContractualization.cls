/**
 * @File Name          : HP_AgilabContractualization.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Hemdene Ben Hammouda
 * @Last Modified On   : 12-16-2021
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    13/02/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public  class HP_AgilabContractualization  {
	// @see https://engie-dmpa-dsi-digital.atlassian.net/browse/HAPP-259
	public class AgilabAddress {
		public  String ville;//	String	Oui	Ville
		public  String code_postal;//	String	Oui	Code postal
		public  String nom_voie;//	String	Oui	Nom voie
		public  String numero_voie;//	String	Oui	Numéro
		public  String complement;//	String	Non	Complément
		public  String code_insee;//	String	Oui	Code INSEE


		public AgilabAddress() {
			
		}
	}

 	public  String code_offre;//	String	Oui	Code de l'offre
	 //public   String code_promo;//	String	Non	Code promo pour la remise
	//public Boolean parrainage; // boolean true si voucher code renseigné
	public  String date_proposition;//	String	Oui	Date de la proposition / souscription
 	public  String id_client_xdata;//	String	Oui	ID client xdata
 	public  String code_civilite;//	String	Oui	code correspondant à la civilite, valeurs possibles :{ "1" => "Monsieur", "3" => "Madame", "4" => "Mademoiselle", "8" => "Monsieur et Mademoiselle", "9" => "Madame et Mademoiselle", "5" => "Messieurs", "2" => "Monsieur et Madame", "6" => "Mesdames", "7" => "Mesdemoiselles" }
 	public  String nom;//	String	Oui	Nom du client
 	public  String prenom;//	String	Oui	Prénom du client
 	public  String email;//	String	Oui	Email du client
 	public  String telephone;//	String	Oui	Téléphone du client
 	public  String id_portefeuille_contrat_xdata;//	String	Oui	ID portefeuille contrat xdata
 	public  String id_proposition_commerciale;//	String	Oui	ID de la proposition commerciale
 	public  String montant_mensualite;//	Float	Non	Montant de la mensualité si le client est mensualisé
 	public  String mode_envoi_facture;//	Integer	Oui	Mode d'envoi des factures, valeurs possibles: { 1 => Electronique, 2 => Papier }
 	public   String id_contrat_xdata;//	String	Oui	ID du contrat dans xdata
 	public   String periodicite;//	Integer	Oui	Périodicité de facturation, valeurs possibles: { 1 => Annuelle, 2 => Bimestrielle }
 	public   String modalite_de_paiement;//	integer	Oui	Modalité de paiement du client, valeurs possibles: { 2 => Paiement récurrent CB, 3 => Chèque, 4 => Espece, 5 => Prélèvement, 6 => Paiement CB }
 	public   String date_debut_souhaitee;//	String	Oui	Date de début du contrat souhaitée
 	public   String date_signature;//	String	Oui	Date de signature des cpvs
 	public   String type_demande;//	String	Oui	Type de la demande, emmenagement ou changement fournisseur, valeurs possibles: { 1 => CHF, 2 => EM }
 	public   String jour_drp;//	integer	Oui si contrat prélèvement annuel	Jour de prélèvement souhaité (de 1 à 28)
	public   AgilabAddress adresse_facturation;//	Object Oui	adresse de facturation
 	public   AgilabAddress adresse_consommation;//	Object	Oui	adresse de consommation
	public   String puissance;//	Integer	Oui	Puissance du client
 	public   String conso_annuelle_estimee;//	Integer	Oui si offre électricité	Consommation annuelle estimée d'électricité
 	public   String type_comptage;//	Integer	Oui si offre électricité	Type de comptage élec, valeurs possibles: { 1 => Comptage simple, 2 => Comptage HPHC }
 	public   String car;//	Integer	Oui si offre GAZ	Consommation annuelle de référence gaz
 	public   String point_de_livraison;//	String	Oui	PDL ou PCE du client
 	public   String rum;//	String	Non	Numéro de mandat
 	public   String iban;//	String	Oui si modalite de paiement est prélèvement	IBAN du client
 	public   String titulaire_compte;//	String	Non	Titulaire du contrat
 	public   String gaz_serial;//	String	Non	Numéro de série du compteur
 	public   String gaz_index;//	integer	Non	Auto-relève du compteur pour la mise en service
	public   String civilite_cotitulaire;
	public   String nom_cotitulaire;
	public   string prenom_cotitulaire;
	public   String index_base;//	integer	Auto-relève comptage simple du compteur pour la mise en service
	public   String index_hp; // Integer Auto-relève comptage heure pleine du compteur pour la mise en service
	public   String index_hc; // Integer Auto-relève comptage heure creuse du compteur pour la mise en service
	public 	 String voucher_code;
	public 	 String type_energie;
	public   String id_digital_souscription; 
	public   String parrainage;
	
	public   String option_vert;

	private static   Map<HP_EnrolmentRestResourceModel.Salutation, String> AGILAB_SALUTATION_BY_SALUTATION = new Map<HP_EnrolmentRestResourceModel.Salutation,String>{
		HP_EnrolmentRestResourceModel.Salutation.MR => '1',
		HP_EnrolmentRestResourceModel.Salutation.MME => '2'
	};

	private static   Map<HP_EnrolmentRestResourceModel.BillingPeriodicity, String> AGILAB_BILLING_PERIODICITY_BY_BILLING_PERIODICITY = new Map<HP_EnrolmentRestResourceModel.BillingPeriodicity,String>{
		HP_EnrolmentRestResourceModel.BillingPeriodicity.MONTHLY => '1',//FIXME
		HP_EnrolmentRestResourceModel.BillingPeriodicity.BIMONTHLY => '2' 
	};

	private static   Map<HP_EnrolmentRestResourceModel.BillingMethod, String> AGILAB_BILLING_METHOD_BY_BILLING_METHOD = new Map<HP_EnrolmentRestResourceModel.BillingMethod,String>{
		HP_EnrolmentRestResourceModel.BillingMethod.TRANSFER => '5',
		HP_EnrolmentRestResourceModel.BillingMethod.BANK_CARD => '6'//CHECK
	};

	private static   Map<HP_EnrolmentRestResourceModel.EnrolmentType, String> AGILAB_ENROLMENT_TYPE_BY_ENROLMENT_TYPE = new Map<HP_EnrolmentRestResourceModel.EnrolmentType,String>{
		HP_EnrolmentRestResourceModel.EnrolmentType.SWITCH_SUPLIER => '1',
		HP_EnrolmentRestResourceModel.EnrolmentType.MOVING_IN => '2'
	};

	public HP_AgilabContractualization() {
		this.adresse_facturation = new AgilabAddress();
		this.adresse_consommation = new AgilabAddress();
	}
	
}