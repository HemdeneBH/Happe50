/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-12-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class HP_WRP044_AgilabContratCheck {
	public String status;
	public String message;
	public Output output;


	public class Output {
        public String id_contrat_agilab;	                        
        public String id_contrat_xdata;	                          
    }

	

	public static HP_WRP044_AgilabContratCheck parse(String json){
		return (HP_WRP044_AgilabContratCheck) System.JSON.deserialize(json, HP_WRP044_AgilabContratCheck.class);
	}
}