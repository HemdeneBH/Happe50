/**
 * @File Name          : HP_WRP034_Case.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 03-14-2022
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    17/03/2020   Vincent Albiser     Initial Version
**/
global class HP_WRP034_Case {

    global class Request {  
        public String context;
        public String description;
        public String selfcareId;
        public Integer porteFeuilleContratXdataId;
        public Integer contratXdataId;
        public String energie;
        public String pdl;
        public Double montant_paiement;

        public String numeroAffaire;
        public Integer etat;
        public String objectCode;
        public String motifNonRealisationCode;
        public String motifCode;
        public Boolean attestationPaiement;
        public Boolean remiseChq;

        public ContactInfo contactInfo; 
    }

    global class ContactInfo {
        public  String firstname;   
        public  String lastname;
        public  String email;
        public  Integer xdataId;
        public  Boolean clientAide;
    }
}