/**
 * @File Name          : HP_UTIL_Vue360LoadPrestationDist.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Hemdene Ben Hammouda
 * @Last Modified On   : 11-04-2021
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    09/04/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class HP_UTIL_Vue360LoadPrestationDist implements HP_UTIL_ApexVue360Interface {

    public  static Object processing(Object param, Object rootParam) {
        final String contactId = (String) rootParam;
        Map<String,Object> paramMap = (Map<String,Object>) param;
        paramMap = (Map<String,Object>)((Map<String,Object>) param).get('data');
        List<Object> paramList = (List<Object>) paramMap.get('_data');
        Map<String, Object> result = new Map<String, Object>();
        system.debug('## paramList : '+paramList);
        if((paramList != null) && (paramList.size() > 0)) {
        for(Object item : paramList) {
            Map<String, Object> itemMap = (Map<String, Object>)item;
            List<Object> paramTempList = (List<Object>)itemMap.get('locaux');
            System.debug('## paramTempList : '+paramTempList);
                if(paramTempList != null && paramTempList.size() > 0) {
            itemMap = (Map<String, Object>) paramTempList[0];
            paramTempList = (List<Object>)itemMap.get('pointsDeLivraison');
            for(Object pointLiv : paramTempList) {
                itemMap = (Map<String, Object>) pointLiv;
                result.put(String.valueOf(itemMap.get('numeroPointDeLivraison')), 
                loadPrestationDistrubuteurToCardService(String.valueOf(itemMap.get('numeroPointDeLivraison')),contactId));
            }  
        }
            }
        }
        
        return result;
    }


    public static Object loadPrestationDistrubuteurToCardService(String numeroCompteur, String contactId) {


        List<Prestation_distributeur__c> presDisList = [SELECT Id, Numero_affaire_distributeur__c, Date_de_prestation__c, Statut__c, 
        Civilite_interlocuteur_intervention__c, Nom_contact_d_intervention__c, Prenom_contact_d_intervention__c,
        Situation_de_vente__c, Secteur_activite__c , Numero_PDL_PCE__c, Telephone_intervention__c
        from Prestation_distributeur__c WHERE Numero_PDL_PCE__c = :numeroCompteur AND Statut__c = 'En cours' AND Contact__c = :contactId order by CreatedDate desc limit 1];

        if(presDisList.size() > 0) {
            return presDisList.get(0);
        }
        presDisList = [SELECT Id,Numero_affaire_distributeur__c, Date_de_prestation__c, Statut__c, Situation_de_vente__c, Secteur_activite__c , Numero_PDL_PCE__c
        from Prestation_distributeur__c WHERE Numero_PDL_PCE__c = :numeroCompteur AND Statut__c = 'Terminé' AND Contact__c = :contactId order by CreatedDate desc limit 1];
        if(presDisList.size() > 0) {
            return presDisList.get(0);
        }

        presDisList = [SELECT Id,Numero_affaire_distributeur__c, Date_de_prestation__c, Statut__c, Situation_de_vente__c , Secteur_activite__c, Numero_PDL_PCE__c
        from Prestation_distributeur__c WHERE Numero_PDL_PCE__c = :numeroCompteur AND Statut__c = 'Annulé' AND Contact__c = :contactId order by CreatedDate desc limit 1];
        if(presDisList.size() > 0) {
            return presDisList.get(0);
        }

        return null;
	}
}