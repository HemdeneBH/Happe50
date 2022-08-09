/**
 * @File Name          : HP_SM004_SGUT.cls
 * @Description        : Service Manager spécifique aux échanges avec SGUT, SGUT est une brique d'authentification du SI ENGIE
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 27/12/2019 à 04:29:21
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    20/12/2019   Vincent Albiser     Initial Version
**/

public without sharing class HP_SM004_SGUT {

    /**
    * @description Appel vers SGUT2 pour la suppression d'un utilisateur
    * @author Sara El-Hannaoui | 22/04/2020 
    * @param Id utilisateurId 
    * @return HP_PortailUtilisateur__c 
    **/
    @AuraEnabled
    public static HP_PortailUtilisateur__c suppressionUtilisateur(Id utilisateurId){
      return HP_EM004_SGUT.call_SGUT2_deleteUtilisateur(utilisateurId);
    }

    /**
    * @description appel vers SGUT2 pour la modification du MDP d'un utilisateur
    * @author Sara El-Hannaoui | 22/04/2020 
    * @param Id utilisateurId 
    * @param String newPassword 
    * @return HP_PortailUtilisateur__c 
    **/
    @AuraEnabled
    public static HP_PortailUtilisateur__c modificationMDP(Id utilisateurId , String newPassword){
      return HP_EM004_SGUT.call_SGUT2_changePassword(utilisateurId, newPassword);
    }

    /**
    * @description appel vers SGUT2 pour la création d'un utilisateur
    * @author Sara El-Hannaoui | 22/04/2020 
    * @param Id utilisateurId 
    * @return HP_PortailUtilisateur__c 
    **/
    @AuraEnabled
    public static HP_PortailUtilisateur__c creationUtilisateur(Id utilisateurId){
      return HP_EM004_SGUT.call_SGUT2_creationUtilisateur(utilisateurId);
    }


}