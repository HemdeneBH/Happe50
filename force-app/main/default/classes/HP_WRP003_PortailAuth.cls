/**
 * @File Name          : HP_WRP003_PortailAuth.cls
 * @Description        : Wrapper pour HP_WS001_PortailAuth
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Badr Eddine Belkarchi
 * @Last Modified On   : 01-24-2022
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/12/2019   Vincent Albiser     Initial Version
**/
global with sharing class HP_WRP003_PortailAuth {

    global class Request {
        public final String login;        
    }

    public class Canal {
        public String label;
        public List<String> droits;
    }

    global class Response {
        public final String login;
        public final String prestataire;
        public final String role;
        public final Canal canal;

        global Response(HP_PortailUtilisateur__c utilisateur){
            this.login          = utilisateur.Login__c;
            this.prestataire    = utilisateur.Prestataire__r.Name;
            this.role           = utilisateur.Role__c;
            
            List<String> dList = new List<String>();
            if(utilisateur.Prestataire__r.Canal__r.Droit_PaiementCB__c)
                dList.add('droit_paiement_cb');
            if(utilisateur.Prestataire__r.Canal__r.Droit_ParcoursEmDm__c)
                dList.add('droit_emdm_resil');
            if(utilisateur.Prestataire__r.Canal__r.Droit_VenteChf1Ex__c)
                dList.add('droit_chf_1ex');
            if(utilisateur.Prestataire__r.Canal__r.Droit_VenteChf2Ex__c)
                dList.add('droit_chf_2ex');
            if(utilisateur.Prestataire__r.Canal__r.Droit_VenteEm__c)
                dList.add('droit_em_2ex');
            if(utilisateur.Prestataire__r.Canal__r.Droit_VenteEm1Ex__c)
                dList.add('droit_em_1ex');
            if(utilisateur.Prestataire__r.Canal__r.Droit_RepriseChf1Ex__c)
                dList.add('droit_reprise_chf_1ex');
            if(utilisateur.Prestataire__r.Canal__r.Droit_Action_Save_3_CRC__c)
                dList.add('droit_Action_Save_3_CRC__c');
            if(utilisateur.Prestataire__r.Canal__r.Droit_ImportFichier__c)
                dList.add('Droit_ImportFichier__c');

            if(utilisateur.Prestataire__r.Canal__r.HP_Paiement_prlvt__c)
                dList.add('HP_Paiement_prlvt');
            if(utilisateur.Prestataire__r.Canal__r.HP_Visu_docs__c)
                dList.add('HP_Visu_docs');
            if(utilisateur.Prestataire__r.Canal__r.HP_Modif_ventes__c)
                dList.add('HP_Modif_ventes');
            if(utilisateur.Prestataire__r.Canal__r.Visu_docs_s2__c == true)
                dList.add('Visu_docs_s2');
            if(utilisateur.Prestataire__r.Canal__r.HP_Liens_SF__c == true)
                dList.add('Liens_SF');
			if(utilisateur.Prestataire__r.Canal__r.HP_Vente_Stay__c)
                dList.add('Vente_Stay');
            if(utilisateur.Prestataire__r.Canal__r.HP_Unshort_Lien__c)
                dList.add('Unshort_Lien');

            Canal c             = new Canal();
            c.label             = utilisateur.Prestataire__r.Canal__r.Name;
            c.droits            = dList;
            this.canal          = c;
        }
    }

    global class Error {
        private String message {get; set;}
        private Integer errorCode {get; set;}

        public Error(String err, Integer code) {
            this.message = err;
            this.errorCode = code;
        }
    }
}