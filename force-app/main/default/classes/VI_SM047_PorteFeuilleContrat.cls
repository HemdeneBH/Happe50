/*
*@Author: Clément Bouquin
*@Description: 
*@CreatedDate: 15/12/2021
*@LastModified: 27/01/2022
*/

public class VI_SM047_PorteFeuilleContrat {

    public static String callPortefeuilleContrat (String idPorteFeuilleContrat, String contexte, String partitionName) {
        String res;
        if (idPorteFeuilleContrat == null || idPorteFeuilleContrat.length() == 0) {
            system.debug('idsPortefeuilleContrat is not found ...');
            return null;
        }
        String token;
        if (!Test.isRunningTest()){
            token = VI_SM013_GetTokenService.getToken(contexte, partitionName);
            system.debug('token '+token);
            if (token == null) {
                system.debug('Token not found ...');
                return null;
            }
        }
        else {
            token = 'ABCDEFU';
        }

        HttpResponse httpResponse =  VI_UTIL001_HttpUtilities.makeHttpCall(token,'GET', contexte+ '_Portefeuilles_Contrats', null, null, idPorteFeuilleContrat, contexte);
        system.debug(VI_UTIL001_HttpUtilities.handleResponse(httpResponse.getBody()));
        res = VI_UTIL001_HttpUtilities.handleResponse(httpResponse.getBody());
        
        PorteFeuilleContratResponseWrapper responseWrapper = PorteFeuilleContratResponseWrapper.parse(httpResponse.getBody());
        system.debug('responseWrapper : ');
        system.debug(responseWrapper);
        if(responseWrapper != null){
            return NULL;
        }
        
        return res;
    }

    /**
* @author Clément Bouquin
* @date 26/01/2022
* @description Wrapper du retour de l'appel 
*/ 
    
    public class PorteFeuilleContratResponseWrapper{
        public Integer id;	//1234
        public Integer idPersonne;	//286290
        public Integer idCoordonneeBancaireEncaissement;	//104105338
        public Integer idCoordonneeBancaireDecaissement;	//0
        public String idBusinessPartner;	//0200000412
        public String idCompteClient;	//000400000572
        public String libelle;	// 
        public String dateCreation;	//2006-08-11
        public String dateModification;	//2018-10-14
        public Integer idPersonneDivergentPayeur;	//0
        public Integer idPersonneDivergentRelance;	//0
        public Integer idPersonneDivergentFacture;	//0
        public Integer idPersonneDivergentCorrespondance;	//0
        public String modeEncaissement;	//
        public String etatProcedureRelance;	//P1
        public String modePaiement;	//0
        public String conditionPaiement;	//+14B
        public String caracteristiquePrelevement;	//T4
        public boolean clientMaReleve;
        public boolean clientZenbox;
        public boolean clientCapEcoConso;
        public String factureEnLigne;	//F@cture dispo
        public String codeFactureEnLigne;	//0003
        public String dateProchaineFacture;	//0001-01-01
        public Double solde;	//41.77
        public String dateDernierMouvement;	//2021-08-20
        public String dateRelance;
        public String dateMiseAJour;	//2021-08-20 20:30:13
        public boolean blocageRelance;
        public String dateCreationBlocageRelance;
        public String dateDebutBlocageRelance;
        public String dateFinBlocageRelance;
        public boolean blocagePrevelement;
        public String dateCreationBlocagePrevelement;
        public String dateDebutBlocagePrevelement;
        public String dateFinBlocagePrevelement;
        public String dateFinValiditeSolde;	//9999-12-31
        public String codeMarque;	//ENG
        public String libelleMarque;	//ENGIE

        public String code; //null si 200, 201 ou 206
        public String name;
        public String message;

	}
    
    public static PorteFeuilleContratResponseWrapper parse(String json){
        return (PorteFeuilleContratResponseWrapper) System.JSON.deserialize(json, PorteFeuilleContratResponseWrapper.class);
    }
    
}