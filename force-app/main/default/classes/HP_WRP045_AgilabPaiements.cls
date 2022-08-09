/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 10-04-2021
 * @last modified by  : Badr Eddine Belkarchi
**/
public without sharing class HP_WRP045_AgilabPaiements {

    @AuraEnabled
   	public String status;
	@AuraEnabled
    public String message;
    @AuraEnabled
	public Output output;

    public class Output {

        @AuraEnabled
        public String id_contrat_xdata;
		@AuraEnabled
		public List<Paiements> paiements;
	}

    public class Paiements {
        @AuraEnabled
        public String ref_paiement;
        @AuraEnabled
		public Decimal montant_ttc;
		@AuraEnabled
		public String date_paiement;
		@AuraEnabled
		public String type_paiement;
		@AuraEnabled
		public String statut;
		@AuraEnabled
		public String date_rejet;
		@AuraEnabled
		public String motif_rejet;
		@AuraEnabled
		public String date_envoi_recouvrement;
		@AuraEnabled
		public List<Dettes> dettes;
	}

    public class Dettes {
        @AuraEnabled
        public String facture;
        @AuraEnabled
		public String ref_dette;
		@AuraEnabled
		public Decimal montant_ttc_dette;
		@AuraEnabled
		public Decimal montant_du_ttc_dette;
		@AuraEnabled
		public String date_exigibilite_dette;
        @AuraEnabled
		public String date_solde_dette;
        @AuraEnabled
		public String statut_dette;
    }

    // public static HP_WRP045_AgilabPaiements parse(String json) {
	// 	return (HP_WRP045_AgilabPaiements) System.JSON.deserialize(json, HP_WRP045_AgilabPaiements.class);
	// }
}