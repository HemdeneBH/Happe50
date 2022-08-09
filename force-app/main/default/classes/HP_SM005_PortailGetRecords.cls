/**
 * @File Name          : HP_SM005_PortailGetRecords.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 20/01/2020 à 01:39:45
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    02/01/2020   Vincent Albiser     Initial Version
**/
public with sharing class HP_SM005_PortailGetRecords {
    
    public static HP_WRP006_PortailRecords.Response getRecords(HP_WRP006_PortailRecords.Request req, String contexte){

        HP_PortailUtilisateur__c utilisateur            = HP_EM002_PortailUtilisateur.getUtilisateurByLogin(req.login);
        List<HP_Souscription__c> souscriptionList   = HP_EM005_Souscription.getSouscriptionsForPortailAdmin(utilisateur, contexte, req.startDate, req.endDate);
        HP_WRP006_PortailRecords.Response response      = new HP_WRP006_PortailRecords.Response(souscriptionList);
        
        return response;
    }
}