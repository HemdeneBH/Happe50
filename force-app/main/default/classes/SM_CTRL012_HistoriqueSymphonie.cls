/**
 * @description       : Classe controlleur HistoriqueSymphonie
 * @author            : Mohamed Aamer
 * @last modified on  : 07-29-2022
 * @last modified by  : Mohamed Aamer
**/
public with sharing class SM_CTRL012_HistoriqueSymphonie {
    
    private static gdfsuezBefCalypsoDemandeV4.Dependency port = new gdfsuezBefCalypsoDemandeV4.Dependency();
    private static gdfsuezBefCalypsoDemandeV4.rechercherDemandeOutputDt rechercherDemandeOutput;
    private static gdfsuezBefCalypsoDemandeV4.lireDemandeOutputDt_listeDemande_element[] listeDemandeResp;
    private static final String SUCCESS = 'Success';
    private static final String NO_DEMANDES = 'No_Demandes';
    private static final String ERROR = 'Error';
    private static final String CODE_RETOUR_02 = 'OCTOPUS_RechercherDemande_02';
    
    /* La fonction principale de récupération des demandes */
    @AuraEnabled(cacheable=true)
    public static List<SM_WRP006_HistoriqueSymphonie> getDemandes(String dateDebut, String dateFin, String idPersonne){

        /* ----------------------- Appel Rechercher Demandes ------------------ */
        String searchResult = searchDemande(dateDebut, dateFin, idPersonne);
        if (searchResult == SUCCESS) {
            /* ----------------------- Appel Lire Demandes (Dépend du premier appel RechercherDemande)------------------ */
            gdfsuezBefCalypsoDemandeV4.rechercherDemandeOutputDt_listeDemande_element[] listeDemande = rechercherDemandeOutput.listeDemande;
            String readResult = readDemande(listeDemande);
            return (readResult == SUCCESS) ? handleResponse(listeDemandeResp) : handleErrorResponse(readResult);  
        } else {
            return handleErrorResponse(searchResult);
        }
    }

    /* Méthode responsable de récupérer les IDs demandes en fonction des dates et id personne */
    private static String searchDemande(String dateDebut, String dateFin, String idPersonne){

        Date debutDateFormat = Date.parse(dateDebut);
        Date finDateFormat = Date.parse(dateFin);
        Integer debutDay = debutDateFormat.day();
        Integer debutMonth = debutDateFormat.month();
        Integer debutYear = debutDateFormat.year();

        Integer finDay = finDateFormat.day();
        Integer finMonth = finDateFormat.month();
        Integer finYear = finDateFormat.year();

        gdfsuezBefCalypsoDemandeV4.rechercherDemandeInputDt rechercheDemandeInput = new gdfsuezBefCalypsoDemandeV4.rechercherDemandeInputDt();
        rechercheDemandeInput.idPersonne = idPersonne;
        rechercheDemandeInput.dateCreationDemandeDu = DateTime.newInstance(debutYear, debutMonth, debutDay, 0, 0, 0);
        rechercheDemandeInput.dateCreationDemandeAu = DateTime.newInstance(finYear, finMonth, finDay, 0, 0, 0);
        
        gdfsuezBefCalypsoDemandeV4.rechercherDemandeResponse_element response = new gdfsuezBefCalypsoDemandeV4.rechercherDemandeResponse_element();
        
        response = port.RechercherDemande_Http(rechercheDemandeInput);
        rechercherDemandeOutput = response.rechercherDemandeResponseOutput;
        if (rechercherDemandeOutput != null) {
            return SUCCESS;
        } else {
            if (response.messageRetours != null && response.messageRetours.retourTraitementMessage != null) {
                String code =  response.messageRetours.retourTraitementMessage[0].code;
                return (code == CODE_RETOUR_02) ? NO_DEMANDES : ERROR;
            }
            return ERROR;
        }
    }

    /* Méthode responsable de récupérer les détails des demandes en fonctions des ID demandes */
    private static String readDemande(gdfsuezBefCalypsoDemandeV4.rechercherDemandeOutputDt_listeDemande_element[] listeDemande){

        /* Préparation inputs lireDemandes */
        List<String> listDemandeIds = new List<String>();
        for (gdfsuezBefCalypsoDemandeV4.rechercherDemandeOutputDt_listeDemande_element demande : listeDemande) {
            listDemandeIds.add(demande.idDemande);
        }

        gdfsuezBefCalypsoDemandeV4.lireDemandeInputDt lireDemandeInput = new gdfsuezBefCalypsoDemandeV4.lireDemandeInputDt();
        gdfsuezBefCalypsoDemandeV4.lireDemandeInputDt_listeIdDemande_element listeIdDemande = new gdfsuezBefCalypsoDemandeV4.lireDemandeInputDt_listeIdDemande_element();
        listeIdDemande.idDemande = listDemandeIds;

        lireDemandeInput.listeIdDemande = listeIdDemande;

        gdfsuezBefCalypsoDemandeV4.lireDemandeResponse_element responseLireDemande = new gdfsuezBefCalypsoDemandeV4.lireDemandeResponse_element();
        gdfsuezBefCalypsoDemandeV4.lireDemandeOutputDt lireDemandeResponseOutput;
        
        responseLireDemande = port.LireDemande_Http(lireDemandeInput);
        lireDemandeResponseOutput = responseLireDemande.lireDemandeResponseOutput;

        if (lireDemandeResponseOutput != null) {
            listeDemandeResp = lireDemandeResponseOutput.listeDemande;
            return SUCCESS;
        } else {
            listeDemandeResp = null;
            if (responseLireDemande.messageRetours != null && responseLireDemande.messageRetours.retourTraitementMessage != null) {
                String code =  responseLireDemande.messageRetours.retourTraitementMessage[0].code;
                return (code == 'OCTOPUS_RechercherDemande_02') ? NO_DEMANDES : ERROR;
            }
            return ERROR;
        }
    }

    /* Construire la réponse à renvoyer au composant LWC */
    private static List<SM_WRP006_HistoriqueSymphonie> handleResponse(gdfsuezBefCalypsoDemandeV4.lireDemandeOutputDt_listeDemande_element[] listeDemandeResp){
        List<SM_WRP006_HistoriqueSymphonie> result = new List<SM_WRP006_HistoriqueSymphonie>();
        Integer countActivite = 100; // Compteur pour construire la clé idActivité
        
        for (gdfsuezBefCalypsoDemandeV4.lireDemandeOutputDt_listeDemande_element demande : listeDemandeResp) {
            DateTime dt = DateTime.newInstance(demande.dateCreation.date().year(), demande.dateCreation.date().month(),demande.dateCreation.date().day());
            String dateCreation = dt.format('dd/MM/yyyy');

            Integer secondsInt = demande.dateCreation.second();
            String secondsStr = (secondsInt<10) ? '0'+String.valueOf(demande.dateCreation.second()) : String.valueOf(demande.dateCreation.second());
            String heureCreation = String.valueOf(demande.dateCreation.hour()) +':'+secondsStr;

            String subStringMarketing =  demande.texteLibreDemande.substringAfter(':').substringBefore('#');
            String marketing = (subStringMarketing.length() <= 25) ? subStringMarketing : '--';

            String pj = '#';
            Boolean isURLExist = false;
            gdfsuezComBefChpPivotDemande.objetLieDt[] objetLies = demande.objetLie;
            if (objetLies != null) {
                pj = objetLies[0].URL;
                isURLExist = true;
            }

            /* Récupération des champs 'Par'/'Responsable' à partir des balises refPersonne */
            String zOrigin = '--';
            String responsable = '--';
            gdfsuezComBefChpPivotDemande.refPersonneDt[] refPersonnes = demande.refPersonne;
            if (refPersonnes != null) {
                for (gdfsuezComBefChpPivotDemande.refPersonneDt personne : refPersonnes) {
                    gdfsuezComBefChpPivotDemande.listeValeursDt role = personne.rolePersonne;
                    String code = role.code;
                    if (code == 'ZORIGINE') {
                        String nomZ = (personne.nom != null) ? personne.nom.toUpperCase() : '-';
                        String prenomZ = (personne.prenom != null)? personne.prenom : '-';
                        zOrigin = nomZ+' '+prenomZ;
                    }
                    else if (code == 'RESP' || code == '00000022') {
                        String nomR = (personne.nom != null) ? personne.nom.toUpperCase() : '-';
                        String prenomR = (personne.prenom != null) ? personne.prenom : '-';
                        responsable = nomR+' '+prenomR;
                    }
                }
            }

            String activiteDemande = '';
            if (demande.typeDemande != null) {
                activiteDemande = demande.typeDemande.libelleCourt;
                if (demande.motifDemande != null) {
                    activiteDemande = activiteDemande + ' / '+ demande.motifDemande.libelleCourt;
                }   
            }

            String canalDemande = '';
            if (demande.canalDemande != null) {
                canalDemande = demande.canalDemande.libelleCourt;
            }

            String statutDemande = '';
            if (demande.statutDemande != null) {
                statutDemande = demande.statutDemande.libelleCourt;
            }
            
            //ID utilisé pour le filtre d'activité dynamique
            String idActivite = 'Activite'+countActivite;

            SM_WRP006_HistoriqueSymphonie demandeObj = new SM_WRP006_HistoriqueSymphonie(
                false,
                false,
                demande.idDemande,
                dateCreation,
                heureCreation,
                canalDemande,
                statutDemande,
                activiteDemande,
                idActivite,
                pj,
                isURLExist,
                demande.texteLibreDemande,
                marketing,
                zOrigin,
                responsable
            );
            result.add(demandeObj);
            countActivite++;
        }

        return result;
    }

    /* Contruire un wrapper spécifique des erreurs en fonction du code retour */
    private static List<SM_WRP006_HistoriqueSymphonie> handleErrorResponse(String resultCode){
        List<SM_WRP006_HistoriqueSymphonie> result = new List<SM_WRP006_HistoriqueSymphonie>();
        SM_WRP006_HistoriqueSymphonie wrapp;
            if (resultCode == NO_DEMANDES) {
                wrapp = new SM_WRP006_HistoriqueSymphonie(false,true,null,null,null,null,null,null,null,null,null,null,null,null,null);
            } else if(resultCode == ERROR){
                wrapp = new SM_WRP006_HistoriqueSymphonie(true,false,null,null,null,null,null,null,null,null,null,null,null,null,null);
            }
            result.add(wrapp);
            return result;
    }

}