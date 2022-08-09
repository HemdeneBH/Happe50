/**
 * @File Name          : HP_WRP004_AgilabRemboursement.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 18/02/2020 à 17:22:08
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    16/12/2019   mouhamadoune.coulybaly@external.engie.com     Initial Version
**/
public with sharing class HP_WRP004_AgilabRemboursement {

    @AuraEnabled
    public String status;
    @AuraEnabled
	public String message;
	@AuraEnabled
	public Output output;

    public class Output {
		public List<Remboursements> remboursements;
	}

    public class Remboursements {
		@AuraEnabled
		public String reference_remboursement;
		@AuraEnabled
		public String date_creation;
		@AuraEnabled
		public String date_validation;
		@AuraEnabled
		public String envoye_en_banque;
		@AuraEnabled
		public String date_annulation;
		@AuraEnabled
		public String motif_rejet;
		@AuraEnabled
		public Integer type_statut_remboursement;
		@AuraEnabled
		public String origine_remboursement;
		@AuraEnabled
		public Double montant_ttc;
		@AuraEnabled
		public Boolean remboursement_recupere;
	}
     public static HP_WRP004_AgilabRemboursement parse(String json){
		return (HP_WRP004_AgilabRemboursement) System.JSON.deserialize(json, HP_WRP004_AgilabRemboursement.class);
	}

}