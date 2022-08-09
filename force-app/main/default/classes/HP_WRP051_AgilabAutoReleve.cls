/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 04-21-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
public with sharing class HP_WRP051_AgilabAutoReleve {
    
    @AuraEnabled
   	public String status;
	@AuraEnabled
    public String message;
    @AuraEnabled
	public Output output;


    public class Output {
        @AuraEnabled
        public Boolean statut_ar;
		@AuraEnabled
		public String date_debut_periode;
        @AuraEnabled
		public String date_fin_periode;
        @AuraEnabled
		public String date_debut_prochaine_releve;
        @AuraEnabled
		public String date_fin_prochaine_releve;
	}

    public static HP_WRP051_AgilabAutoReleve parse(String json) {
		return (HP_WRP051_AgilabAutoReleve) System.JSON.deserialize(json, HP_WRP051_AgilabAutoReleve.class);
	}
}