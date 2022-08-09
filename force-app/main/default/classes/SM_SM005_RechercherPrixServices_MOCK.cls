/**
* @description       : Mock for service class SM_SM005_RechercherPrixServices (FT1-4381)
* @author            : David Attali
* @group             : 
* @last modified on  : 01-25-2021
* @last modified by  : David ATTALI
* Modifications Log 
* Ver   Date         Author          Modification
* 1.0   01-25-2021   David ATTALI    Initial Version
**/
@isTest
global class SM_SM005_RechercherPrixServices_MOCK implements WebServiceMock {
    
    private String code;

    private String libelle;
    private String idOffre;
    private Double donneesPrix_prixMensuelTTC;
    private Double donneesPrixAnnexe_prixMensuelTTC;
    private String donneesPrixParametre01;
    private String donneesPrixValeur01;
    private String donneesPrixParametre02;
    private String donneesPrixValeur02;
    
    public SM_SM005_RechercherPrixServices_MOCK(Map<String, Object> parameters){
        this.code = (String)parameters.get('code');
        this.libelle = (String)parameters.get('libelle');
        this.idOffre = (String)parameters.get('idOffre');
        this.donneesPrix_prixMensuelTTC = (Double)parameters.get('donneesPrix_prixMensuelTTC');
        
        this.donneesPrixAnnexe_prixMensuelTTC = (Double)parameters.get('donneesPrixAnnexe_prixMensuelTTC');
        this.donneesPrixParametre01 = (String)parameters.get('donneesPrixParametre01');
        this.donneesPrixValeur01 = (String)parameters.get('donneesPrixValeur01');
        this.donneesPrixParametre02 = (String)parameters.get('donneesPrixParametre02');
        this.donneesPrixValeur02 = (String)parameters.get('donneesPrixValeur02');

    }
    
    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {
            
            // rechercherPrixServicesResponse_element
            gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixServicesResponse_element response_x = new gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixServicesResponse_element();
            
            // rechercherPrixServicesResponse_element.rechercherPrixServicesOutputDt[]
            List<gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixServicesOutputDt> rechercherPrixServicesOutput = new List<gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixServicesOutputDt>();
            response_x.rechercherPrixServicesOutput = rechercherPrixServicesOutput;
            
            // rechercherPrixServicesResponse_element.rechercherPrixServicesOutputDt[0]
            gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixServicesOutputDt rechercherPrixServicesOutputDt01 = new gdfsuezBefCalypsoPrixetremisesV3.rechercherPrixServicesOutputDt();
            rechercherPrixServicesOutput.add(rechercherPrixServicesOutputDt01);
            
            // Block donneesPrix
            // rechercherPrixServicesResponse_element.rechercherPrixServicesOutputDt[0].donneesPrixOutDt[]
            List<gdfsuezBefCalypsoPrixetremisesV3.donneesPrixOutDt> donneesPrix_donneesPrix = new List<gdfsuezBefCalypsoPrixetremisesV3.donneesPrixOutDt>();
            rechercherPrixServicesOutputDt01.donneesPrix = donneesPrix_donneesPrix;
            
            // rechercherPrixServicesResponse_element.rechercherPrixServicesOutputDt[0].donneesPrixOutDt[0]
            gdfsuezBefCalypsoPrixetremisesV3.donneesPrixOutDt donneesPrix_donneesPrix01 = new gdfsuezBefCalypsoPrixetremisesV3.donneesPrixOutDt();
            donneesPrix_donneesPrix01.idOffre = idOffre;
            donneesPrix_donneesPrix01.datePropositionCommerciale = Date.today();
            donneesPrix_donneesPrix01.dateEffetContrat = Date.today();
            donneesPrix_donneesPrix01.typePrix = 'ABO';
            donneesPrix_donneesPrix.add(donneesPrix_donneesPrix01);
            
            // rechercherPrixServicesResponse_element.rechercherPrixServicesOutputDt[0].donneesPrixOutDt[0].donneesPrixDt[]
            List<gdfsuezBefCalypsoPrixetremisesV3.donneesPrixDt> donneesPrix_donneesPrixDt = new List<gdfsuezBefCalypsoPrixetremisesV3.donneesPrixDt>();
            donneesPrix_donneesPrix01.donneesPrix = donneesPrix_donneesPrixDt;
            
            // rechercherPrixServicesResponse_element.rechercherPrixServicesOutputDt[0].donneesPrixOutDt[0].donneesPrixDt[0]
            gdfsuezBefCalypsoPrixetremisesV3.donneesPrixDt donneesPrix_donneesPrixDt01 = new gdfsuezBefCalypsoPrixetremisesV3.donneesPrixDt();
            donneesPrix_donneesPrixDt.add(donneesPrix_donneesPrixDt01);
            
            // rechercherPrixServicesResponse_element.rechercherPrixServicesOutputDt[0].donneesPrixOutDt[0].donneesPrixDt[0].donneesPrixCriteresDt[]
            List<gdfsuezBefCalypsoPrixetremisesV3.donneesPrixCriteresDt> donneesPrix_donneesPrixCriteresDt = new List<gdfsuezBefCalypsoPrixetremisesV3.donneesPrixCriteresDt>();
            donneesPrix_donneesPrixDt01.donneesPrixCriteres = donneesPrix_donneesPrixCriteresDt;
            
            // rechercherPrixServicesResponse_element.rechercherPrixServicesOutputDt[0].donneesPrixOutDt[0].donneesPrixDt[0].donneesPrixCriteresDt[0]
            gdfsuezBefCalypsoPrixetremisesV3.donneesPrixCriteresDt donneesPrix_donneesPrixCriteresDt01 = new gdfsuezBefCalypsoPrixetremisesV3.donneesPrixCriteresDt();
            donneesPrix_donneesPrixCriteresDt01.donneesPrixParametre = '';
            donneesPrix_donneesPrixCriteresDt01.donneesPrixValeur = '';
            donneesPrix_donneesPrixCriteresDt.add(donneesPrix_donneesPrixCriteresDt01);
            
            // rechercherPrixServicesResponse_element.rechercherPrixServicesOutputDt[0].donneesPrixOutDt[0].donneesPrixDt[0].donneesPrixDetailsDt
            gdfsuezBefCalypsoPrixetremisesV3.donneesPrixDetailsDt donneesPrix_donneesPrixDetailsDt = new gdfsuezBefCalypsoPrixetremisesV3.donneesPrixDetailsDt();
            donneesPrix_donneesPrixDetailsDt.prixMensuelHT = 2.5;
            donneesPrix_donneesPrixDetailsDt.prixMensuelTTC = donneesPrix_prixMensuelTTC;
            donneesPrix_donneesPrixDetailsDt.prixAnnuelHT = 30.0;
            donneesPrix_donneesPrixDetailsDt.prixAnnuelTTC = 36.0;
            donneesPrix_donneesPrixDt01.donneesPrixDetails = donneesPrix_donneesPrixDetailsDt;
            
            // Block donneesPrixAnnexe
            // rechercherPrixServicesResponse_element.rechercherPrixServicesOutputDt[0].donneesPrixOutDt[]
            List<gdfsuezBefCalypsoPrixetremisesV3.donneesPrixOutDt> donneesPrixAnnexe_donneesPrixAnnexe = new List<gdfsuezBefCalypsoPrixetremisesV3.donneesPrixOutDt>();
            rechercherPrixServicesOutputDt01.donneesPrixAnnexe = donneesPrixAnnexe_donneesPrixAnnexe;
            
            // rechercherPrixServicesResponse_element.rechercherPrixServicesOutputDt[0].donneesPrixOutDt[0]
            gdfsuezBefCalypsoPrixetremisesV3.donneesPrixOutDt donneesPrixAnnexe_donneesPrix01 = new gdfsuezBefCalypsoPrixetremisesV3.donneesPrixOutDt();
            donneesPrixAnnexe_donneesPrix01.idOffre = '';
            donneesPrixAnnexe_donneesPrix01.datePropositionCommerciale = Date.today();
            donneesPrixAnnexe_donneesPrix01.dateEffetContrat = Date.today();
            donneesPrixAnnexe_donneesPrix01.typePrix = '';
            donneesPrixAnnexe_donneesPrixAnnexe.add(donneesPrixAnnexe_donneesPrix01);
            
            // rechercherPrixServicesResponse_element.rechercherPrixServicesOutputDt[0].donneesPrixOutDt[0].donneesPrixDt[]
            List<gdfsuezBefCalypsoPrixetremisesV3.donneesPrixDt> donneesPrixAnnexe_donneesPrixDt = new List<gdfsuezBefCalypsoPrixetremisesV3.donneesPrixDt>();
            donneesPrixAnnexe_donneesPrix01.donneesPrix = donneesPrixAnnexe_donneesPrixDt;
            
            // rechercherPrixServicesResponse_element.rechercherPrixServicesOutputDt[0].donneesPrixOutDt[0].donneesPrixDt[0]
            gdfsuezBefCalypsoPrixetremisesV3.donneesPrixDt donneesPrixAnnexe_donneesPrixDt01 = new gdfsuezBefCalypsoPrixetremisesV3.donneesPrixDt();
            donneesPrixAnnexe_donneesPrixDt.add(donneesPrixAnnexe_donneesPrixDt01);
            
            // rechercherPrixServicesResponse_element.rechercherPrixServicesOutputDt[0].donneesPrixOutDt[0].donneesPrixDt[0].donneesPrixCriteresDt[]
            List<gdfsuezBefCalypsoPrixetremisesV3.donneesPrixCriteresDt> donneesPrixAnnexe_donneesPrixCriteresDt = new List<gdfsuezBefCalypsoPrixetremisesV3.donneesPrixCriteresDt>();
            donneesPrixAnnexe_donneesPrixDt01.donneesPrixCriteres = donneesPrixAnnexe_donneesPrixCriteresDt;
            
            // rechercherPrixServicesResponse_element.rechercherPrixServicesOutputDt[0].donneesPrixOutDt[0].donneesPrixDt[0].donneesPrixCriteresDt[0]
            gdfsuezBefCalypsoPrixetremisesV3.donneesPrixCriteresDt donneesPrixAnnexe_donneesPrixCriteresDt01 = new gdfsuezBefCalypsoPrixetremisesV3.donneesPrixCriteresDt();

            donneesPrixAnnexe_donneesPrixCriteresDt01.donneesPrixParametre = donneesPrixParametre01;
            donneesPrixAnnexe_donneesPrixCriteresDt01.donneesPrixValeur = donneesPrixValeur01;
            donneesPrixAnnexe_donneesPrixCriteresDt.add(donneesPrixAnnexe_donneesPrixCriteresDt01);
            
            // rechercherPrixServicesResponse_element.rechercherPrixServicesOutputDt[0].donneesPrixOutDt[0].donneesPrixDt[0].donneesPrixCriteresDt[1]
            gdfsuezBefCalypsoPrixetremisesV3.donneesPrixCriteresDt donneesPrixAnnexe_donneesPrixCriteresDt02 = new gdfsuezBefCalypsoPrixetremisesV3.donneesPrixCriteresDt();
            donneesPrixAnnexe_donneesPrixCriteresDt02.donneesPrixParametre = donneesPrixParametre02;
            donneesPrixAnnexe_donneesPrixCriteresDt02.donneesPrixValeur = donneesPrixValeur02;
            donneesPrixAnnexe_donneesPrixCriteresDt.add(donneesPrixAnnexe_donneesPrixCriteresDt02);
            
            // rechercherPrixServicesResponse_element.rechercherPrixServicesOutputDt[0].donneesPrixOutDt[0].donneesPrixDt[0].donneesPrixDetailsDt
            gdfsuezBefCalypsoPrixetremisesV3.donneesPrixDetailsDt donneesPrixAnnexe_donneesPrixDetailsDt = new gdfsuezBefCalypsoPrixetremisesV3.donneesPrixDetailsDt();
            donneesPrixAnnexe_donneesPrixDetailsDt.prixMensuelHT = 0.0;
            donneesPrixAnnexe_donneesPrixDetailsDt.prixMensuelTTC = donneesPrixAnnexe_prixMensuelTTC;

            donneesPrixAnnexe_donneesPrixDetailsDt.prixAnnuelHT = 0.0;
            donneesPrixAnnexe_donneesPrixDetailsDt.prixAnnuelTTC = 0.0;
            donneesPrixAnnexe_donneesPrixDt01.donneesPrixDetails = donneesPrixAnnexe_donneesPrixDetailsDt;
            
            // rechercherPrixServicesResponse_element.messageRetoursDt
            gdfsuezComBefChpCommunV3.messageRetoursDt messageRetours = new gdfsuezComBefChpCommunV3.messageRetoursDt();
            response_x.messageRetours = messageRetours;
            
            // rechercherPrixServicesResponse_element.messageRetoursDt.messageRetour_element[]
            List<gdfsuezComBefChpCommunV3.messageRetour_element> messageRetour = new List<gdfsuezComBefChpCommunV3.messageRetour_element>();
            messageRetours.messageRetour = messageRetour;
            
            // rechercherPrixServicesResponse_element.messageRetoursDt.messageRetour_element[0]
            gdfsuezComBefChpCommunV3.messageRetour_element messageRetour_element = new gdfsuezComBefChpCommunV3.messageRetour_element();
            messageRetour_element.code = code;
            messageRetour_element.type_x = '';

             messageRetour_element.libelle = libelle;

            messageRetour_element.source = '';
            messageRetour.add(messageRetour_element);
            
            System.debug('response_x...prixMensuelTTC ' + response_x.rechercherPrixServicesOutput.get(0).donneesPrix.get(0).donneesPrix.get(0).donneesPrixDetails.prixMensuelTTC);
            
            response.put('response_x', response_x); 
        }
}