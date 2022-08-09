/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 04-11-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
public with sharing class HP_WRP052_AgilabEnvoiIndexes {

    @AuraEnabled
   	public String status;
	@AuraEnabled
    public String message;
    @AuraEnabled
	public Output output;
	@AuraEnabled
	public String prochaine_releve_debut;
	@AuraEnabled
	public String prochaine_releve_fin;


    public class Output {
        @AuraEnabled
		public String status;
        @AuraEnabled
		public String message;
		@AuraEnabled
		public String prochaine_releve_debut;
        @AuraEnabled
		public String prochaine_releve_fin;

	}

    public static HP_WRP052_AgilabEnvoiIndexes parse(String json) {
		return (HP_WRP052_AgilabEnvoiIndexes) System.JSON.deserialize(json, HP_WRP052_AgilabEnvoiIndexes.class);
	}
}