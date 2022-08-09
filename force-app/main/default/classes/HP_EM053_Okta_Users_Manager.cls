/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 02-22-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
public with sharing class HP_EM053_Okta_Users_Manager {
    
    @AuraEnabled
    public static HP_PortailUtilisateur__c createUser(Id utilisateurId){
        System.debug('HP_EM053_Okta_Users_Manager.createUser() | Method Start');
        HP_PortailUtilisateur__c user = HP_EM002_PortailUtilisateur.getUtilisateurById(utilisateurId);
        try {
            HP_WRP048_OktaUser.Request req = new HP_WRP048_OktaUser.Request(user);
            String body = JSON.serialize(req);
            HttpResponse response = HP_UTIL_HTTPUtils.calloutPost(HP_Constantes.HP_OKTA_CREATE_USER, body);
            
            Integer statusCode = response.getStatusCode();
            if(statusCode == 200 || statusCode == 201){
                HP_WRP048_OktaUser.ResponseSuccess responseSucess = (HP_WRP048_OktaUser.ResponseSuccess) JSON.deserialize(response.getBody(), HP_WRP048_OktaUser.ResponseSuccess.class);
                user.HP_Okta_Status__c = 'OK';
                user.HP_Okta_Erreur__c = '';
                user.HP_Okta_Id__c = responseSucess.id;
            }else{
                HP_WRP048_OktaUser.ResponseFailure responseFailure = (HP_WRP048_OktaUser.ResponseFailure) JSON.deserialize(response.getBody(), HP_WRP048_OktaUser.ResponseFailure.class);
                user.HP_Okta_Status__c = 'KO';
                user.HP_Okta_Erreur__c = responseFailure.errorSummary;
            }
        } catch (Exception ex) {
            System.debug('HP_EM053_Okta_Users_Manager.createUser() | Exception : '+ ex.getMessage());
            user.HP_Okta_Status__c = 'KO';
            user.HP_Okta_Erreur__c = 'Erreur Technique';
            
        }
        update user;
        System.debug('HP_EM053_Okta_Users_Manager.createUser() | Method Exit');
        return user;
    }

    @AuraEnabled
    public static HP_PortailUtilisateur__c deleteUser(Id utilisateurId){
        System.debug('HP_EM053_Okta_Users_Manager.deleteUser() | Method Start');
        HP_PortailUtilisateur__c user = HP_EM002_PortailUtilisateur.getUtilisateurById(utilisateurId);
        String userId = getUserId(user);
        if(userId != null){
            try {
                HttpResponse response = HP_UTIL_HTTPUtils.calloutDelete(HP_Constantes.HP_OKTA_USER, userId);
                if(response.getStatusCode() == 204){
                    HttpResponse finalResponse = HP_UTIL_HTTPUtils.calloutDelete(HP_Constantes.HP_OKTA_USER, userId);
                    if(finalResponse.getStatusCode() == 204){
                        user.HP_Okta_Id__c = '';
                        user.HP_Okta_Status__c = 'OK';
                    }else{
                        user.HP_Okta_Status__c = 'KO';
                        user.HP_Okta_Erreur__c = 'Erreur Technique';
                    }
                }else{
                    user.HP_Okta_Status__c = 'KO';
                    user.HP_Okta_Erreur__c = 'Erreur Technique';
                }
            } catch (Exception ex) {
                System.debug('HP_EM053_Okta_Users_Manager.deleteUser() | Exception : '+ ex.getMessage());
                System.debug('HP_EM053_Okta_Users_Manager.deleteUser() | Exception : '+ ex.getStackTraceString());
                System.debug('HP_EM053_Okta_Users_Manager.deleteUser() | Exception : '+ ex.getLineNumber());
            }
        }else {
            System.debug('HP_EM053_Okta_Users_Manager.deleteUser() | User does not exists in Okta');
            throw new AuraException('User does not exists in Okta');
        }
        update user;
        System.debug('HP_EM053_Okta_Users_Manager.deleteUser() | Method Exit');
        return user;
    }

    @AuraEnabled
    public static HP_PortailUtilisateur__c updatePassword(Id utilisateurId, String newPassword){
        System.debug('HP_EM053_Okta_Users_Manager.updatePassword() | Method Start');
        HP_PortailUtilisateur__c user = HP_EM002_PortailUtilisateur.getUtilisateurById(utilisateurId);
        String param = user.Login__c;
        if(param != null){
            try {
                String body = '{"credentials": { "password": {"value":"'+newPassword+'"}}}';
                HttpResponse response = HP_UTIL_HTTPUtils.callout(HP_Constantes.HP_OKTA_USER, HP_UTIL_HTTPUtils.PUT, body, param ,  null);
                Integer statusCode = response.getStatusCode();
            if(statusCode == 200){
                user.HP_Okta_Status__c = 'OK';
                user.HP_Okta_Erreur__c = '';
                user.Password__c = newPassword;
            }else{
                HP_WRP048_OktaUser.ResponseFailure responseFailure = (HP_WRP048_OktaUser.ResponseFailure) JSON.deserialize(response.getBody(), HP_WRP048_OktaUser.ResponseFailure.class);
                user.HP_Okta_Status__c = 'KO';
                user.HP_Okta_Erreur__c = responseFailure.errorSummary;
            }
            } catch (Exception ex) {
                System.debug('HP_EM053_Okta_Users_Manager.updatePassword() | Exception : '+ ex.getMessage());
            }
        }
        update user;        
        System.debug('HP_EM053_Okta_Users_Manager.updatePassword() | Method Exit');
        return user;
    }

    public static String getUserId(HP_PortailUtilisateur__c user){
        System.debug('HP_EM053_Okta_Users_Manager.getUserId() | Method Start');
        String result;
        try {
            HttpResponse response = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.HP_OKTA_USER, user.Login__c);
            Integer statusCode = response.getStatusCode();
            if(statusCode == 200 || statusCode == 201){
                HP_WRP048_OktaUser.ResponseSuccess responseSucess = (HP_WRP048_OktaUser.ResponseSuccess) JSON.deserialize(response.getBody(), HP_WRP048_OktaUser.ResponseSuccess.class);
                result = responseSucess.id;
            }else{
                result = null;
            }
        } catch (Exception ex) {
            System.debug('HP_EM053_Okta_Users_Manager.getUserId() | Exception : '+ ex.getMessage());
        }
        System.debug('HP_EM053_Okta_Users_Manager.getUserId() | Method Exit');
        return result;
    }
}