/**
 * @description       : 
 * @author            : Mohamed Aamer
 * @last modified on  : 04-07-2022
 * @last modified by  : Mohamed Aamer
**/
public with sharing class SM_WRP005_AdministrationEquipes {
    @AuraEnabled
	public List<NewUser> newUsers;

    @AuraEnabled
	public List<OldUser> oldUsers;

	@AuraEnabled
	public String role;
    
	public class NewUser {
		@AuraEnabled
		public String label;
        @AuraEnabled
		public String value;
	}

    public class OldUser {
        @AuraEnabled
		public String label;
		@AuraEnabled
		public String value;
	}

	
	public static SM_WRP005_AdministrationEquipes parse(String json) {
		return (SM_WRP005_AdministrationEquipes) System.JSON.deserialize(json, SM_WRP005_AdministrationEquipes.class);
	}
}