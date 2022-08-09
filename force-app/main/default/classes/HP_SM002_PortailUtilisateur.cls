/**
 * @File Name          : HP_SM002_PortailUtilisateur.cls
 * @Description        : SM de HP_PortailUtilisateur__c
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 19/12/2019 à 13:25:36
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/12/2019   Vincent Albiser     Initial Version
**/

public with sharing class HP_SM002_PortailUtilisateur {

    public class PortailException extends Exception {}

    /**
    * @description Authentification des HP_PortailUtilisateur__c
    * @author Vincent Albiser | 10/12/2019 
    * @param HP_WRP003_PortailAuth.Request req 
    * @return HP_WRP003_PortailAuth.Response 
    **/
    public static HP_WRP003_PortailAuth.Response verifierLogin(HP_WRP003_PortailAuth.Request req){

        HP_WRP003_PortailAuth.Response response;
        HP_PortailUtilisateur__c utilisateur = HP_EM002_PortailUtilisateur.getUtilisateurByLogin(req.login);
        if(utilisateur != null){
            response = new HP_WRP003_PortailAuth.Response(utilisateur);
        }
        else{
            throw new PortailException('Login invalide');
        }

        return response;
    }
}