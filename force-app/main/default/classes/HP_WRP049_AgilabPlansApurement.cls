/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 02-22-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
public with sharing class HP_WRP049_AgilabPlansApurement {

    public String status;
    public String message;
	public Output output;
    
    public class Output{
        public List<PlansApurement> plans_apurement;
    }

    public class PlansApurement{
        public Integer id_plan_apurement;
        public String date_creation;
        public Integer statut;
        public Integer modalite_de_paiement_ref;
        public Integer type_plan_apurement;
        public List<Facture> factures;
        public Integer nombre_echeance;
        public List<Echeance> echeances;
    }

    public class Echeance {
		public String ref_echeances;
		public String date_decheance;
		public Decimal montant_ttc;
		public Decimal montant_restant_du;
		public Integer statut;
		public String date_annulee;
		public String date_ok_cb;
		public String date_retour_ok;
		public String date_ko_cb;
		public String date_retour_ko;
        public String date_retour_cb_auto;
        public String date_rejet;
        public Boolean ouverture_cb;
	}
    
    public class Facture{
        public String ref_facture;
        public Decimal montant_restant_du;
    }

    public static HP_WRP049_AgilabPlansApurement parse(String json){
		return (HP_WRP049_AgilabPlansApurement) System.JSON.deserialize(json, HP_WRP049_AgilabPlansApurement.class);
	}
}