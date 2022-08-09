/*
*@Author: Clément Bouquin
*@Description: 
*@CreatedDate: 28/01/2022
*@LastModified: 01/02/2022
*/

public class VI_SM049_LocauxContrats {
    
    public static String callLocauxContrats (String idPorteFeuilleContrat, String contexte, String partitionName) {
        String res;
        if (idPorteFeuilleContrat == null || idPorteFeuilleContrat.length() == 0) {
            system.debug('idPorteFeuilleContrat is not found ...');
            return null;
        }
        
        Map<String, String> paramIdPorteFeuilleContrat = new Map<String, String>();
        paramIdPorteFeuilleContrat.put('idsPortefeuilleContrat', idPorteFeuilleContrat);
        paramIdPorteFeuilleContrat.put('size', '50');
        
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
        HttpResponse httpResponse =  VI_UTIL001_HttpUtilities.makeHttpCall(token,'GET', contexte+ '_LocauxContrats', paramIdPorteFeuilleContrat, null, contexte);
        system.debug(VI_UTIL001_HttpUtilities.handleResponse(httpResponse.getBody()));
        res = VI_UTIL001_HttpUtilities.handleResponse(httpResponse.getBody());
        system.debug('res :'+ res);
        
        LocauxContratsResponseWrapper responseWrapper = LocauxContratsResponseWrapper.parse(httpResponse.getBody());
        system.debug('¤ responseWrapper : '+responseWrapper);
        if(responseWrapper != null){
            return NULL;
        }
        
        return res;
    }
    
    /* @author Clément Bouquin
	* @date 01/02/2022	
	* @description Wrapper du retour de l'appel 
	*/
    
    public class LocauxContratsResponseWrapper{
        public cls_data[] data;
    }
    
	class cls_data {
		public Integer idPortefeuilleContrat;	//1234
		public Integer idPersonne;	//286290
		public String numeroPortefeuilleContrat;	//000400000572
		public String numeroBusinessPartner;	//0200000412
		public boolean clientMaReleve;
		public boolean clientZenbox;
		public boolean clientCapEcoConso;
		public String codeFactureEnLigne;	//0003
		public String libelleFactureEnLigne;	//F@cture dispo
		public String dateProchaineFacture;	//0001-01-01
		public String modeEncaissement;	//
		public boolean blocageRelance;
		public String codeMotifBlocageRelance;
		public String libelleMotifBlocageRelance;
		public String dateCreationBlocageRelance;
		public String dateDebutBlocageRelance;
		public String dateFinBlocageRelance;
		public boolean blocageFacturation;
		public String codeMotifBlocageFacturation;
		public String libelleMotifBlocageFacturation;
		public String dateCreationBlocageFacturation;
		public String dateDebutBlocageFacturation;
		public String dateFinBlocageFacturation;
		public boolean blocageDecaissement;
		public String codeMotifBlocageDecaissement;
		public String libelleMotifBlocageDecaissement;
		public String dateCreationBlocageDecaissement;
		public String dateDebutBlocageDecaissement;
		public String dateFinBlocageDecaissement;
		public boolean blocagePrelevement;
		public String codeMotifBlocagePrelevement;
		public String libelleMotifBlocagePrelevement;
		public String dateCreationBlocagePrelevement;
		public String dateDebutBlocagePrelevement;
		public String dateFinBlocagePrelevement;
		public String numeroVoie;	//2
		public String libelleVoie;	//ROUTE DE SAINTE SOLANGE
		public String ville;	//MOULINS SUR YEVRE
		public String codeINSEE;	//18158
		public String codePostal;	//18390
		public Integer idAdresse;	//2293
		public String idBAN;	//18158_0092_00002
		public String complementAdresse;	//  
		public String typeOccupation;
		public String typeResidence;
		public cls_contrats[] contrats;
	}
    
	class cls_contrats {
		public Integer idContrat;	//284290396
		public String numeroContrat;	//5000000406
		public String typeContrat;	//GN
		public String statutContrat;	//Actif
		public String dateDebutContrat;	//2006-06-17
		public String dateFinContrat;	//9999-12-31
		public String uniteReleve;	//G20218DB
		public String numeroContratCRM;	//5500000291
		public String codeStatutContratCRM;	//
		public String libelleStatutContratCRM;	//-
		public Integer idOffre;	//583
		public String codeOffre;	//B1
		public String libelleOffre;	//Tarif Gaz Historique - B1
		public Integer idPointDeLivraison;	//41120955
		public String numeroPointDeLivraison;	//17710709086993
		public String typeEnergie;	//gaz
		public String dateTheoriqueReleve;
		public String typeCompteur;	//GAZPAR
		public String consommationAnnuelleDeReference;
		public String tarifAcheminement;	//
		public String nombreRoue;
		public String systemeInfoContractuel;
		public String codeNiveauService;
		public String numeroVoie;	//2
		public String libelleVoie;	//ROUTE DE SAINTE SOLANGE
		public String ville;	//MOULINS SUR YEVRE
		public Integer idInstallation;	//1657
		public String numeroInstallation;	//0900000406
		public Integer idLocal;	//4156897
		public String numeroLocal;	//0700000406
		public Integer idBatiment;	//1180
		public String etage;	//
		public String numeroAppartement;	//
		public String typeLogement;	//Individuel
		public String codeINSEE;	//18158
		public String codePostal;	//18390
		public Integer idFoyer;	//0
	}
    
	public static LocauxContratsResponseWrapper parse(String json){
        json = json.replace('_data', 'data');
		return (LocauxContratsResponseWrapper) System.JSON.deserialize(json, LocauxContratsResponseWrapper.class);
	}
}