/**
 * @File Name          : HP_WRP028_AgilabFactures.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 19/02/2020 à 13:11:56
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    18/02/2020   Mouhamadoune Coulibaly     Initial Version
**/
public without sharing class HP_WRP028_AgilabFactures {

	@AuraEnabled
   	public String status;
	@AuraEnabled
    public String message;
    @AuraEnabled
	public Output output;

	public class Output {
		@AuraEnabled
		public List<Factures> factures;
	}

	public class Factures {
        @AuraEnabled
        public String ref_facture;
        @AuraEnabled
		public String date_creation;
		@AuraEnabled
		public String montant_ttc;
		@AuraEnabled
		public String montant_restant_du;
		@AuraEnabled
		public String statut;
		@AuraEnabled
		public String etat;
		@AuraEnabled
		public Boolean eligible_pa;
		@AuraEnabled
		public String recouvrement;
		@AuraEnabled
		public String irrecouvrable;
		@AuraEnabled
		public List<String> modalite_de_paiement;
		@AuraEnabled
		public String date_limite_de_paiement;
		@AuraEnabled
		public String type_facture;
		@AuraEnabled
		public String plan_apurement_en_cours;
		@AuraEnabled
		public String relance_en_cours;
		@AuraEnabled
		public Boolean ouverture_cb;
		@AuraEnabled
		public Object etat_du_paiement;
	}

	
	public static HP_WRP028_AgilabFactures parse(String json) {
		return (HP_WRP028_AgilabFactures) System.JSON.deserialize(json, HP_WRP028_AgilabFactures.class);
	}
}