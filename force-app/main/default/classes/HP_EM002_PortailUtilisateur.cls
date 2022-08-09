/**
 * @File Name          : HP_EM002_PortailUtilisateur.cls
 * @Description        : EM de HP_PortailUtilisateur__c
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Badr Eddine Belkarchi
 * @Last Modified On   : 01-24-2022
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/12/2019   Vincent Albiser     Initial Version
**/

public without sharing class HP_EM002_PortailUtilisateur {

    /**
    * @description , utilisé par EM004
    * @author Vincent Albiser | 27/12/2019 
    * @param Id utilisateurId 
    * @return HP_PortailUtilisateur__c 
    **/
    
    public static HP_PortailUtilisateur__c getUtilisateurById(Id utilisateurId){

        HP_PortailUtilisateur__c utilisateur;

        List<HP_PortailUtilisateur__c> utilisateurList = [SELECT Id, 
                                                                Civilite__c,
                                                                GaiaId__c,
                                                                Login__c,
                                                                Nom__c,
                                                                Password__c,
                                                                Prenom__c,
                                                                Prestataire__c,
                                                                Prestataire__r.Canal__r.Droit_ImportFichier__c,
                                                                Prestataire__r.Canal__r.Droit_PaiementCB__c,
                                                                Prestataire__r.Canal__r.Droit_ParcoursEmDm__c,
                                                                Prestataire__r.Canal__r.Droit_RepriseChf1Ex__c,
                                                                Prestataire__r.Canal__r.Droit_VenteChf1Ex__c,
                                                                Prestataire__r.Canal__r.Droit_VenteChf2Ex__c,
                                                                Prestataire__r.Canal__r.Visu_docs_s2__c,
                                                                Prestataire__r.Canal__r.Droit_VenteEm__c,
                                                                Prestataire__r.Canal__r.Droit_VenteEm1Ex__c,
                                                                Prestataire__r.Canal__r.Droit_Action_Save_3_CRC__c,
                                                                Prestataire__r.Canal__r.HP_Paiement_prlvt__c,
                                                                Prestataire__r.Canal__r.HP_Visu_docs__c,
                                                                Prestataire__r.Canal__r.HP_Modif_ventes__c,
                                                                Prestataire__r.Canal__r.Name,
                                                                Prestataire__r.Canal__r.HP_Liens_SF__c,
                                                          		Prestataire__r.Canal__r.HP_Vente_Stay__c,
                                                                Prestataire__r.Canal__r.HP_Unshort_Lien__c,
                                                                Prestataire__r.Name,
                                                                Role__c,
                                                                Sgut2Statut__c,
                                                                Sgut2Erreur__c,
                                                                HP_Okta_Status__c,
                                                                HP_Okta_Erreur__c,
                                                                HP_Okta_Id__c 
                                                            FROM HP_PortailUtilisateur__c WHERE Id = :utilisateurId];
        System.debug(utilisateurList);
        if(!utilisateurList.isEmpty()){
            utilisateur = utilisateurList[0];
        }
        return utilisateur;
    }


    /**
    * @description habilitations des HP_PortailUtilisateur__c, utilisé par SM002
    * @author Vincent Albiser | 10/12/2019 
    * @param String login 
    * @return HP_PortailUtilisateur__c 
    **/
    public static HP_PortailUtilisateur__c getUtilisateurByLogin(String login){

        HP_PortailUtilisateur__c utilisateur = null;

        List<HP_PortailUtilisateur__c> utilisateurList = [SELECT Id, 
                                                                Civilite__c,
                                                                GaiaId__c,
                                                                Login__c,
                                                                Nom__c,
                                                                Prenom__c,
                                                                Prestataire__c,
                                                                Prestataire__r.Canal__r.Droit_ImportFichier__c,
                                                                Prestataire__r.Canal__r.Droit_PaiementCB__c,
                                                                Prestataire__r.Canal__r.Droit_ParcoursEmDm__c,
                                                                Prestataire__r.Canal__r.Droit_RepriseChf1Ex__c,
                                                                Prestataire__r.Canal__r.Droit_VenteChf1Ex__c,
                                                                Prestataire__r.Canal__r.Droit_VenteChf2Ex__c,
                                                                Prestataire__r.Canal__r.Visu_docs_s2__c,
                                                                Prestataire__r.Canal__r.Droit_VenteEm__c,
                                                                Prestataire__r.Canal__r.Droit_VenteEm1Ex__c,
                                                                Prestataire__r.Canal__r.Droit_Action_Save_3_CRC__c,
                                                                Prestataire__r.Canal__r.HP_Paiement_prlvt__c,
                                                                Prestataire__r.Canal__r.HP_Visu_docs__c,
                                                                Prestataire__r.Canal__r.HP_Modif_ventes__c,
                                                                Prestataire__r.Canal__r.Name,
                                                                Prestataire__r.Name,
                                                                Prestataire__r.Canal__r.HP_Liens_SF__c,
                                                          		Prestataire__r.Canal__r.HP_Vente_Stay__c,
                                                                Prestataire__r.Canal__r.HP_Unshort_Lien__c,
                                                                Prestataire__r.IdPrestataire__c,
                                                                Role__c 
                                                                FROM HP_PortailUtilisateur__c WHERE Login__c = :login];
        if(!utilisateurList.isEmpty()){
            for(HP_PortailUtilisateur__c u : utilisateurList){
                // VAL @19/12/2019 HAPP-925
                if(u.Login__c.equals(login)){
                    utilisateur = u;
                    break;
                }
            }
        }

        return utilisateur;
    }
    
}