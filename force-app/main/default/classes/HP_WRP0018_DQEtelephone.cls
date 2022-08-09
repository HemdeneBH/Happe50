/**
 * @File Name          : HP_WRP0018_DQEtelephone.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 27/01/2020 à 18:01:00
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    22/01/2020   Mouhamadoune Coulibaly     Initial Version
**/ 
public with sharing class HP_WRP0018_DQEtelephone {
   
    public String Type;
	public String OldOperator;
	public Integer IdError ;
	public String Operator;
	public String Ported ;
	public String Tel ;
	public String Geolocation ;
	public String TelOrigine ;
public class Keys {

    public String Typez ;// in json: Type
	public String OldOperator;
	public Integer IdError ;
	public String Operator;
	public String Ported ;
	public String Tel ;
	public String Geolocation ;
	public String TelOrigine ;
	}


    public static HP_WRP0018_DQEtelephone parse(String json) {
		return (HP_WRP0018_DQEtelephone) System.JSON.deserialize(json, HP_WRP0018_DQEtelephone.class);
	}

    
}