/**
 * @File Name          : HP_WRP026_AgilabEcheance.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 18/02/2020 à 17:05:37
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    18/02/2020   Mouhamadoune Coulibaly     Initial Version
**/
public with sharing class HP_WRP026_AgilabEcheance {
    @AuraEnabled
    public String status;
    @AuraEnabled
    public String message;
    @AuraEnabled
	public Map<String,Echeance> output;

	public class Echeance {
		public String reference;
		public String date_decheance;
		public Integer modalite_de_paiement_initiale;
		public String type_decheance;
		public String montant_ttc;
		public String montant_restant_du;
		public Object soldee_le;
		public Object annulee_le;
		public Object traitee_a;
		public Object ouverture_cb;
		public Object date_de_rejet;
	}

    public static HP_WRP026_AgilabEcheance parse(String json){
		return (HP_WRP026_AgilabEcheance) System.JSON.deserialize(json, HP_WRP026_AgilabEcheance.class);
	}
}