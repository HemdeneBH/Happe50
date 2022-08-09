/**
 * @File Name          : HP_EM024_PorteFeuilleContrat.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Badr Eddine Belkarchi
 * @Last Modified On   : 02-14-2022
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/02/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class HP_EM024_PorteFeuilleContrat {
    public static String createPorteFeuilleContratXdata(HP_ContractPortfolio contractPortfolio) {
        HttpResponse response = HP_UTIL_HTTPUtils.calloutPost(HP_Constantes.XDATA_PORTEFEUILLES_CONTRATS, System.JSON.serialize(new HP_APIHourContractPortfolio(contractPortfolio)));
        String location;
        if(response.getHeaderKeys().contains(HP_HttpUtils.HTTP_LOCATION)){
            location = response.getHeader(HP_HttpUtils.HTTP_LOCATION); 
        }else if(response.getHeaderKeys().contains(HP_HttpUtils.HTTP_LOCATION_APIGEE)){
            location = response.getHeader(HP_HttpUtils.HTTP_LOCATION_APIGEE);
        }
        final String portfolioContractId = location.substringAfterLast(HP_HttpUtils.URI_SEP);
		return portfolioContractId;
    }

    public static void updatePorteFeuilleContratXdata(String contractPortfolioXdataId, HP_ContractPortfolio contractPortfolio) {
        Set<String> filterString = new Set<String>{'idPersonne'};
		String fstring = HP_ParseUtils.serializeStringSet(contractPortfolio,filterString);
        HttpResponse response = HP_UTIL_HTTPUtils.calloutPut(HP_Constantes.XDATA_PORTEFEUILLES_CONTRATS, fstring,'/' + contractPortfolioXdataId);

    }

    public static HP_Porte_Feuille_Contrat__c loadPorteFeuilleContrat(String selfcareId) {
        return [select Id, HP_Contact__c, HP_Souscription_Digital_Id__c, Xdata_Id__c from HP_Porte_Feuille_Contrat__c where HP_Souscription_Digital_Id__c = :selfcareId];
    }

    public static HP_Porte_Feuille_Contrat__c getPortefeuilleContratByXdataId(String porteFeuilleContratXdataId) {
        return [select Id, HP_Contact__c, HP_Souscription_Digital_Id__c, Xdata_Id__c from HP_Porte_Feuille_Contrat__c where Xdata_Id__c = :porteFeuilleContratXdataId];
    }
}