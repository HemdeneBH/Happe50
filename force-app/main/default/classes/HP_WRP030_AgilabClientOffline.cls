/**
 * @File Name          : HP_WRP030_AgilabClientOffline.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 20/02/2020 à 14:30:05
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    20/02/2020   Mouhamadoune Coulibaly     Initial Version
**/
public with sharing class HP_WRP030_AgilabClientOffline {
    @AuraEnabled
    public String status;
    @AuraEnabled
	public String message;
    @AuraEnabled
	public Output output;

	public class Output {
        @AuraEnabled
		public Boolean is_offline;
	}

	
	public static HP_WRP030_AgilabClientOffline parse(String json) {
		return (HP_WRP030_AgilabClientOffline) System.JSON.deserialize(json, HP_WRP030_AgilabClientOffline.class);
	}
}