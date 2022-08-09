/**
 * @File Name          : HP_WRP005_SgutUtilisateur.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 30/01/2020 à 15:59:36
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    27/12/2019   Vincent Albiser     Initial Version
**/

global with sharing class HP_WRP005_SgutUtilisateur {

    global class Request {
        @AuraEnabled
        public final String login;
        @AuraEnabled   
        public final String motDePasse;
        @AuraEnabled
        public final String nom;
        @AuraEnabled   
        public final String prenom;
        @AuraEnabled
        public final String civilite;
        @AuraEnabled
        public final String composante;
        @AuraEnabled
        public final String idApplicatif;

        global Request(HP_PortailUtilisateur__c utilisateur, String composante, String idApplicatif){
            this.login          = utilisateur.Login__c;
            this.motDePasse     = utilisateur.Password__c;
            this.nom            = utilisateur.Nom__c;
            this.prenom         = utilisateur.Prenom__c;
            this.civilite       = utilisateur.Civilite__c;
            this.composante     = composante;
            this.idApplicatif   = idApplicatif;
        }   
    }

    global class Response {
        @AuraEnabled
        public final String statut; 
        @AuraEnabled  
        public final List<Erreur> erreurs;
        @AuraEnabled
        public final Reponse reponse ;
    }
    global class Reponse {
        @AuraEnabled
        public String demandeur;
        @AuraEnabled
        public String civilite;
        @AuraEnabled
        public String nom;
        @AuraEnabled
        public String login;
        @AuraEnabled
        public String prenom;
        @AuraEnabled
        public String uid;
        @AuraEnabled
        public Boolean classique;
        @AuraEnabled
        public Integer id;
        @AuraEnabled
        public Integer sphereId;
        @AuraEnabled
        public Decimal dateCreation;
        @AuraEnabled
		public Decimal dateModification;
    }
    global class Erreur {
        @AuraEnabled  
        public final String code; 
        @AuraEnabled    
        public final String message;
    }
}