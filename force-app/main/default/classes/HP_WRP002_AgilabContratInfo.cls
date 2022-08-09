/**
* @author Vincent Albiser
* @date Creation 29/11/2019
* @description Structure de réponse des infos de contrat Agilab
*/
public with sharing class HP_WRP002_AgilabContratInfo {

    @AuraEnabled
    public String status;
    @AuraEnabled
    public String message;

    public Output output;
    public class Output {
		public String pdl;	                        //77793724213666
		public String date_prochaine_facturation;	//2019-10-26
		public String mode_envoi_facture;	        //électronique
		public String date_reconduction;	        //2021-01-01
		public String jour_drp;	                    //8
		public Electricite electricite;
		public Gaz gaz;
	}

    public class Electricite {
        public String conso_annuelle_estimee;
		public String puissance;
    }

    public class Gaz {
        public String conso_annuelle_reference;
		public String plage_conso;
		public String niveau;
    }

    public static HP_WRP002_AgilabContratInfo parse(String json){
		return (HP_WRP002_AgilabContratInfo) System.JSON.deserialize(json, HP_WRP002_AgilabContratInfo.class);
	}
}