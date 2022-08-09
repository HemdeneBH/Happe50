/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 01-04-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
public with sharing class HP_SM072_Okta_Users_Manager {
    
    @AuraEnabled
    public static HP_PortailUtilisateur__c creationUtilisateur(Id utilisateurId){
        return HP_EM053_Okta_Users_Manager.createUser(utilisateurId);
    }

    @AuraEnabled
    public static HP_PortailUtilisateur__c suppressionUtilisateur(Id utilisateurId){
      return HP_EM053_Okta_Users_Manager.deleteUser(utilisateurId);
    }

    @AuraEnabled
    public static HP_PortailUtilisateur__c modificationMDP(Id utilisateurId , String newPassword){
      return HP_EM053_Okta_Users_Manager.updatePassword(utilisateurId, newPassword);
    }
}