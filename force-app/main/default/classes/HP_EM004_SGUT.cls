/**
 * @File Name          : HP_EM004_SGUT.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 30/01/2020 à 16:04:04
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    20/12/2019   Vincent Albiser     Initial Version
**/
public without sharing class HP_EM004_SGUT {

    private static final String SGUT2_HAPPE_COMPOSANTE = 'HAPCONS';
    
    /**
    * @description  Modifier le MDP d'un utilisateur dans le LDAP Engie
    * @author Sara El-Hannaoui | 22/04/2020 
    * @param Id utilisateurId 
    * @param String newPassword 
    * @return HP_PortailUtilisateur__c 
    **/
    public static HP_PortailUtilisateur__c call_SGUT2_changePassword(Id utilisateurId , String newPassword){
        HP_PortailUtilisateur__c utilisateur = HP_EM002_PortailUtilisateur.getUtilisateurById(utilisateurId);
        HP_WRP005_SgutUtilisateur.Response infos = HP_EM004_SGUT.call_SGUT2_getUtilisateur(utilisateur);
        if (infos != null && infos.statut == 'OK'){
            Map<String, String> headers = new   Map<String, String>{'uid' => infos.reponse.uid};
            Map<String, Object> paramsBody = new Map<String,Object>{
                'motDePasseActuel'=> utilisateur.Password__c,
                'nouveauMotDePasse'=> newPassword,
                'composante'=> SGUT2_HAPPE_COMPOSANTE
            };
            HTTPResponse resp = HP_UTIL_HTTPUtils.calloutPut(HP_constantes.SGUT_PUT_PASSWORD, JSON.serialize(paramsBody), null, headers);
            HP_WRP005_SgutUtilisateur.Response r = (HP_WRP005_SgutUtilisateur.Response) JSON.deserialize(resp.getBody(), HP_WRP005_SgutUtilisateur.Response.class);
            if (resp.getStatusCode() == 200){
                utilisateur.Password__c = newPassword;
                utilisateur.Sgut2Statut__c = 'OK';
                utilisateur.Sgut2Erreur__c = '';
            }else{
                utilisateur.Sgut2Statut__c = 'KO';
                String error = 'Erreur inconnue';
                if(r.erreurs != null && !r.erreurs.IsEmpty() && r.erreurs.size()>=1){
                    error = r.erreurs[0].message;
                }
                utilisateur.Sgut2Erreur__c = error;
            }     
        }
        update utilisateur;
        return utilisateur;
    } 

    /**
    * @description  Supprimer un utilisateur dans le LDAP Engie
    * @author Sara El-Hannaoui | 20/04/2020 
    * @param HP_PortailUtilisateur__c utilisateur 
    * @return HP_WRP005_SgutUtilisateur.Response 
    **/
    public static HP_PortailUtilisateur__c call_SGUT2_deleteUtilisateur(Id utilisateurId){
        HP_PortailUtilisateur__c utilisateur = HP_EM002_PortailUtilisateur.getUtilisateurById(utilisateurId);
        HP_WRP005_SgutUtilisateur.Response infos = HP_EM004_SGUT.call_SGUT2_getUtilisateur(utilisateur);
        if (infos != null && infos.statut == 'OK'){
            HTTPResponse httpResp = HP_UTIL_HTTPUtils.calloutDelete(HP_constantes.SGUT_USER_DELETION, infos.reponse.id +'?composante='+SGUT2_HAPPE_COMPOSANTE);
            HP_WRP005_SgutUtilisateur.Response r = (HP_WRP005_SgutUtilisateur.Response) JSON.deserialize(httpResp.getBody(), HP_WRP005_SgutUtilisateur.Response.class);
            if (httpResp.getStatusCode() == 200){
                utilisateur.Sgut2Statut__c = 'OK';
                utilisateur.Sgut2Erreur__c = '';
            }else{
                utilisateur.Sgut2Statut__c = 'KO';
                String error = 'Erreur inconnue';
                if(r.erreurs != null && !r.erreurs.IsEmpty() && r.erreurs.size()>=1){
                    error = r.erreurs[0].message;
                }
                utilisateur.Sgut2Erreur__c = error;
            }   
        }
       update utilisateur;
       return utilisateur;
    }

    /**
    * @description  Récuperer les informations d'un utilisateur dans le LDAP Engie
    * @author Sara El-Hannaoui | 20/04/2020 
    * @param HP_PortailUtilisateur__c utilisateur 
    * @return HP_WRP005_SgutUtilisateur.Response 
    **/
     public static HP_WRP005_SgutUtilisateur.Response call_SGUT2_getUtilisateur(HP_PortailUtilisateur__c utilisateur){
        HP_WRP005_SgutUtilisateur.Response r ;
        try{
            Map<String, String> parameters = new  Map<String, String>{
                'login' => utilisateur.Login__c,
                'composante' => SGUT2_HAPPE_COMPOSANTE
            };
            HTTPResponse resp = HP_UTIL_HTTPUtils.calloutGet(HP_constantes.SGUT_GET_UTILISATEUR, parameters);
            r = (HP_WRP005_SgutUtilisateur.Response) JSON.deserialize(resp.getBody(), HP_WRP005_SgutUtilisateur.Response.class);
            Integer statusCode = resp.getStatusCode();
            if(statusCode == 200){
                utilisateur.Sgut2Statut__c = 'OK';
                utilisateur.Sgut2Erreur__c = '';
            }
            else{
                utilisateur.Sgut2Statut__c = 'KO';
                String error = 'Erreur inconnue';
                if(r.erreurs != null && !r.erreurs.IsEmpty() && r.erreurs.size()>=1){
                    error = r.erreurs[0].message;
                }
                utilisateur.Sgut2Erreur__c = error;
            }   
            
        }catch(Exception e){
            System.debug(e);
			utilisateur.Sgut2Statut__c = 'KO';
            utilisateur.Sgut2Erreur__c = 'Erreur technique';
        }
        return r;  
    }


 
    
    /**6934958
    * @description Création d'un utilisateur dans le LDAP Engie
    * @author Vincent Albiser | 27/12/2019 
    **/
    @AuraEnabled
    public static HP_PortailUtilisateur__c call_SGUT2_creationUtilisateur(Id utilisateurId){
        HP_PortailUtilisateur__c utilisateur = HP_EM002_PortailUtilisateur.getUtilisateurById(utilisateurId);
        try {
            //construction du body
            String idApplicatif = utilisateur.Prestataire__r.Canal__r.Name + '_' + utilisateur.Prestataire__r.Name + '_';
            if((utilisateur.Prestataire__r.Canal__r.Name.equals('CRC-HAPPE') || utilisateur.Prestataire__r.Canal__r.Name.equals('CRC-ENGIE')) && !String.isBlank(utilisateur.GaiaId__c)){
                idApplicatif += utilisateur.GaiaId__c;
            }
            else{
                idApplicatif += (!String.isBlank(utilisateur.Prenom__c) ? utilisateur.Prenom__c : '') + utilisateur.Nom__c;
            }
            HP_WRP005_SgutUtilisateur.Request req = new HP_WRP005_SgutUtilisateur.Request(utilisateur, SGUT2_HAPPE_COMPOSANTE, idApplicatif);
            String body = JSON.serialize(req);            
            //body = '{"login":"Hap006@yopmail.com","motDePasse":"Gdfgdf1!","civilite":"Mr","nom":"YOUNESS","prenom":"Robert", "composante":"HAPCONS","idApplicatif":"200002227"}';
            System.debug(body);

            //requete          
            HTTPResponse resp = HP_UTIL_HTTPUtils.calloutPost(HP_Constantes.SGUT_USER_CREATION, body);
            Integer statusCode = resp.getStatusCode();
            
            if((statusCode == 200 || statusCode == 201)){
                utilisateur.Sgut2Statut__c = 'OK';
                utilisateur.Sgut2Erreur__c = '';
            }
            else{
                //{"statut":"KO","erreurs":[{"code":"MGUT-001","message":"KO PARAMETRES INCORRECT(LE LOGIN NE RESPECTE PAS LE FORMAT D'UN EMAIL)"}]}
                HP_WRP005_SgutUtilisateur.Response r = (HP_WRP005_SgutUtilisateur.Response) JSON.deserialize(resp.getBody(), HP_WRP005_SgutUtilisateur.Response.class);
                utilisateur.Sgut2Statut__c = 'KO';
                String error = 'Erreur inconnue';
                if(r.erreurs != null && !r.erreurs.IsEmpty() && r.erreurs.size()>=1){
                    error = r.erreurs[0].message;
                }
                utilisateur.Sgut2Erreur__c = error;
            }
		} 
        catch(Exception e) {
            System.debug(e);
			utilisateur.Sgut2Statut__c = 'KO';
            utilisateur.Sgut2Erreur__c = 'Erreur technique';
		}
        update utilisateur;
        return utilisateur;
    }

}