/**
 * @File Name          : HP_EM004_FactureManager.cls
 * @Description        : class permet de gerer les Souscriptions
 * @Author             : Slimene Belhaj Ali
 * @Group              : 
 * @Created On         : 16/01/2020
**/
public with sharing class HP_SM012_Souscription {
    
    /**
    * @description permet de créer une souscription dans Agilab
    * @author Slimene Belhaj Ali | 16/01/2020
    * @param String codeOffre
    * @param String agilabStatus codePromo
    * @param String agilabStatus idPropCommecrial
    * @return Map<Integer, String> 
    **/
    public static Map<Integer, String> creationSouscriptionAgilab(String codeOffre, String codePromo, String idPropCommercial, String idPrestataire){
		
		return HP_EM005_Souscription.creationSouscriptionAgilab(codeOffre, codePromo, idPropCommercial, idPrestataire);
  }
  
  @AuraEnabled(cacheable=true)
  public static List<Map<String, Object>> loadDataCocontractant(String contactId) {
        return HP_EM005_Souscription.loadDataCocontractant(contactId);
  }
}