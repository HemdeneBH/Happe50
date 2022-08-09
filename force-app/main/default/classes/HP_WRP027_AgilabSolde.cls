/**
 * @File Name          : HP_WRP027_AgilabSolde.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 18/02/2020 à 17:22:26
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    18/02/2020   Mouhamadoune Coulibaly     Initial Version
**/
public with sharing class HP_WRP027_AgilabSolde {
    @AuraEnabled
    public String status;
    @AuraEnabled
    public String message;
    @AuraEnabled
    public Output output;


public class Output {
    @AuraEnabled
    public List<Map<String, Double>> soldes;
    public Output(List<Map<String, Double>> soldes) {
        this.soldes = soldes;
        }
    }
    public static HP_WRP027_AgilabSolde parse(String json){
		return (HP_WRP027_AgilabSolde) System.JSON.deserialize(json, HP_WRP027_AgilabSolde.class);
	}
}