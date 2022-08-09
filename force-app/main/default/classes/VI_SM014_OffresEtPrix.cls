/*@Author: Eloi Dereeper
*@Description: Récupération des valeurs du WS prix et remise et calcul des mensualités
*@CreatedDate: 06/11/2020
*@LastModified: 24/11/2020
*/
public class VI_SM014_OffresEtPrix { 
    
    public static gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesResponse_element callPrixETRemise(String codeCommune, String codePostal, String enseigneSouscription,
                                                                                             String contSouscriptionCode, DateTime dateEffet, Map<String, List<String>> mapPackOffres,
                                                                                             String plageconso, String vpuissance, String typeDeComptage, String lastModifFTA, 
                                                                                             String codeFTA, String pourcentageOffreVerte, Integer CAE, String niveauOuvertureService,
                                                                                             Map<String, Boolean > mapIsOffreVerte, Map<String,String> mapStrucmesfour, 
                                                                                             String application, String version, String NamedCredential) {
    	List<gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt> listInput = new List<gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt>();
        gdfsuezComBefChpCommunV3.contextDt octx = initContext(application, version);
        for (String pack : mapPackOffres.keyset()) {
            gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt prixService =createInput(codeCommune, codePostal,enseigneSouscription,contSouscriptionCode,dateEffet, pack,  
                                                                                                     mapPackOffres.get(pack), plageconso, vpuissance, typeDeComptage, lastModifFTA, 
                                                                                                     codeFTA,  pourcentageOffreVerte, CAE, niveauOuvertureService,
                                                                                                     mapIsOffreVerte.get(pack), mapStrucmesfour.get(pack));
            listInput.add(prixService);
        }
        gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort prixRemiseService = initPort(NamedCredential);
        gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesResponse_element response = new gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesResponse_element();
        if (!Test.isRunningTest()) {
            response = prixRemiseService.RechercherPrixEtRemises(listInput, octx);
        } else {
            Test.setMock(WebServiceMock.class, new VI_SM014_OffresEtPrix_Mock());
            gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort testObject = new gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort();
            response = testObject.RechercherPrixEtRemises(listInput, octx);
        }
        return response;
    }
    
    public static gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt createInput( String codeCommune, String codePostal, String enseigneSouscription,
                                                                                             String contSouscriptionCode, DateTime dateEffet, String pack, List<String> idOffre,
                                                                                             String plageconso, String vpuissance, String typeDeComptage, String lastModifFTA, 
                                                                                             String codeFTA, String pourcentageOffreVerte, Integer CAE, String niveauOuvertureService,
                                                                                             Boolean isOffreVerte, String Strucmesfour){
        gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt input = new gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt();
        input.identifiantsLieu = initIdentifiantLieu(codeCommune, codePostal);
        input.dateEffetContrat = dateEffet;
        input.datePropositionCommerciale = System.now();
        input.dateValiditePrix = dateEffet;
        input.idPack = pack;
        input.idOffre = idOffre;
        input.enseigneSouscription = initValue(enseigneSouscription);
        input.contexteSouscription = initValue(contSouscriptionCode);
        if (!String.isBlank(plageconso)) {
            input.caracteristiquesOffreGaz = initcaracteristiquesOffreGaz(plageconso);
        }
        if (!String.isBlank(vpuissance) || !String.isBlank(typeDeComptage)) {
        	if(contSouscriptionCode == 'CHGT_FOURN'){
                input.dateDerniereModificationFormuleTarifaireAcheminement = lastModifFTA;                
            	input.formuleTarifaireAcheminement = initValue(codeFTA); 
            }
                     gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt carElec = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                     if (!String.isBlank(vpuissance) ) {
                         carElec.puissance = initValue(vpuissance);
                     }
                     if (isOffreVerte == true) { // Peut-être null, et provoque une erreur
                         carElec.pourcentageOffreVerte = initValue(pourcentageOffreVerte);
                     }
                     if(Strucmesfour != null){
                         carElec.structureMesureFournisseur =initValue(pack);
                     }
                     if(CAE != null && CAE != 0){
                         carElec.CAEElec = CAE;
                     }
                     if(niveauOuvertureService != null && niveauOuvertureService != ''){
                         carElec.niveauOuvertureService = niveauOuvertureService;
                     }
                     input.caracteristiquesOffreElec = carElec;
                 }
        return input;
    }
    
    public static gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt initcaracteristiquesOffreGaz(String plageconso){
        gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt carGaz = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt();
        carGaz.plageConsommation = initValue(plageconso);
        return carGaz;
    }
    
    public static gdfsuezBefCalypsoPrixetremisesV2.identifiantsLieuDt initIdentifiantLieu(String codeCommune, String codePostal){
        gdfsuezBefCalypsoPrixetremisesV2.identifiantsLieuDt identifiantsLieu = new gdfsuezBefCalypsoPrixetremisesV2.identifiantsLieuDt();
        identifiantsLieu.codeCommune = codeCommune;
        identifiantsLieu.codePostal = codePostal;
        return identifiantsLieu;
    }
    
    //Intiate picklistValue
    public static gdfsuezComBefChpCommunV3.listeValeursDt initValue( String value){
        gdfsuezComBefChpCommunV3.listeValeursDt valueToReturn = new gdfsuezComBefChpCommunV3.listeValeursDt();
        valueToReturn.code = value;
        return valueToReturn;
    }
    public static gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort initPort(String NamedCredential) {
        
          
        gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort port = new gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort();
        port.endpoint_x = NamedCredential + '/ES-PrixEtRemises_v2';
        port.inputHttpHeaders_x = new Map<String, String> {'Content-Type' => 'text/xml;charset=utf-8'};
        port.timeout_x = 120000;
        System.debug(port);
        return port;
        /*
        SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();
        gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort prixRemiseService = new gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort();
        prixRemiseService.clientCertName_x = octopusCS.certName__c;
        prixRemiseService.timeout_x = 30000;
        prixRemiseService.endpoint_x = octopusCS.endpoint__c + 'ES-PrixEtRemises_v2';
        prixRemiseService.inputHttpHeaders_x = new Map<String, String> {'Content-Type' => 'text/xml;charset=utf-8'};
            return prixRemiseService;*/
    }
    
    
    
    public static gdfsuezComBefChpCommunV3.contextDt initContext(String application, String version) {
        
        gdfsuezComBefChpCommunV3.system_element osource = new gdfsuezComBefChpCommunV3.system_element();
        osource.systemId = application;
        gdfsuezComBefChpCommunV3.contextDt octx = new gdfsuezComBefChpCommunV3.contextDt();
        octx.version = version;
        octx.systemPath = new gdfsuezComBefChpCommunV3.systemPath_element();
        octx.systemPath.system_x = new gdfsuezComBefChpCommunV3.system_element[] {osource};
            return octx;
    }
    
}