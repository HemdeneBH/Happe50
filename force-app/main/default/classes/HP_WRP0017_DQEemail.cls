/**
 * @File Name          : HP_WRP001_DQEemail.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 25/03/2020 à 14:59:28
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    20/01/2020   Mouhamadoune Coulibaly     Initial Version
**/  
public with sharing class HP_WRP0017_DQEemail {

  public String CodeActivite;
		public String IdError;
		public Integer Redressement;
		public String eMail;
		public String eMailOrigine;

  
  public class Keys {

		public String CodeActivite;
		public String IdError;
		public Integer Redressement;
		public String eMail;
		public String eMailOrigine;
	}
  
 
    public static HP_WRP0017_DQEemail parse(String json){
		return (HP_WRP0017_DQEemail) System.JSON.deserialize(json, HP_WRP0017_DQEemail.class);
	}
}