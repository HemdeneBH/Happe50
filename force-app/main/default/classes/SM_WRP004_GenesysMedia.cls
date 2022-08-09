/**
 * @description       : Handle the response structure of the Genesys entities
 * @author            : Mohamed Aamer
 * @last modified on  : 01-18-2022
 * @last modified by  : Mohamed Aamer
**/
public class SM_WRP004_GenesysMedia {

	@AuraEnabled
	public List<Entities> entities;
    
	public class Entities {
        @AuraEnabled
		public String id;
        @AuraEnabled
		public String name;
        @AuraEnabled
		public Boolean joined;
	}

	
	public static SM_WRP004_GenesysMedia parse(String json) {
		return (SM_WRP004_GenesysMedia) System.JSON.deserialize(json, SM_WRP004_GenesysMedia.class);
	}

}