/*
*@Author: Paul Ghousoub
*@Description: Appel de PdlGaz
*@CreatedDate: 27/10/2020
*@LastModified: 27/10/2020
*/
public class VI_SM010_PdlGaz {
    /////FOR TESTING VI_SM010_PdlGaz.lirePDL('21101817097249','SMILE','2.0','callout:AuthOctopus');
    public static VI_UTIL006_Cache_Management service = new VI_UTIL006_Cache_Management(); 
   /* 
    public static gdfsuezComBefChpPivot.contextDt initContext(String application, String version) {
        // Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
        gdfsuezComBefChpPivot.system_element osource = new gdfsuezComBefChpPivot.system_element();
        osource.systemId=application;
        gdfsuezComBefChpPivot.contextDt octx = new gdfsuezComBefChpPivot.contextDt();
        octx.version=version;
        octx.systemPath = new gdfsuezComBefChpPivot.systemPath_element();
        octx.systemPath.system_x = new gdfsuezComBefChpPivot.system_element[] {osource};
            return octx;
    }
    
    public static gdfsuezBefCalypsoPdlgazV2.Dependency initPort(String NamedCredentialName){
        gdfsuezBefCalypsoPdlgazV2.Dependency port = new gdfsuezBefCalypsoPdlgazV2.Dependency();
        port.endpoint_x =  NamedCredentialName+'/ES-PDLGaz_v2';
        port.inputHttpHeaders_x = new Map<String, String> {'Content-Type' => 'text/xml;charset=utf-8'};
        return port;
    }
    
    public static gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt createInput(gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt_PDLGaz_element PDLGaz,
                                                                          String typeOffre, String loginUtilisateur){
        gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt input = new gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt();
        input.online = true;
        input.typeOffre = VI_UTIL005_OctopusCalloutUtils.initValue(typeOffre);
        input.loginUtilisateur = loginUtilisateur;
        input.PDLGaz = PDLGaz;
        return input;
    }
    
    public static gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt_PDLGaz_element createElement(String pceGaz, Boolean recupererDerniersIndexGaz, Boolean AutorisationSituationContractuelle){
        gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt_PDLGaz_element element = new gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt_PDLGaz_element();
        element.PDLGaz= new gdfsuezComBefCalypsoPdlgaz.PDLGazAbstract();
        element.PDLGaz.idPDLGaz =  pceGaz; //'21101817097249' ;
        element.recupererDerniersIndexGaz= recupererDerniersIndexGaz;// true;
        element.AutorisationSituationContractuelle= AutorisationSituationContractuelle;//true ;
        return element;
    }
    
    public static PdlInfo lirePdl(String pceGaz, String application, String version,String NamedCredentialName) {
        if(String.isBlank(pceGaz)){
            system.debug('no selected pce val ');
            return null;
        }
        gdfsuezComBefChpPivot.contextDt octx = initContext(application,version);
        gdfsuezBefCalypsoPdlgazV2.Dependency port = initPort(NamedCredentialName);
        gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt_PDLGaz_element element = createElement(pceGaz, true,true );
        gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt input = createInput(element, 'INDUSTRIELLE',  'homologation@engie.com');
        gdfsuezBefCalypsoPdlgazV2.lirePDLGazResponse_element response;
        if(!Test.isRunningTest()) {
            //response  = port.LirePDLGaz_Http(input,octx);  
            response = LirePDLGaz_Http(input,octx,'local.VItoken',NamedCredentialName,port);
        }
        else {
            Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPdlgazV2HttpMock());
            gdfsuezBefCalypsoPdlgazV2.Dependency porttest = new gdfsuezBefCalypsoPdlgazV2.Dependency();
            system.debug('@@ start of mock');
            //response = porttest.LirePDLGaz_Http(input, octx);  
            response=LirePDLGaz_Http(input,octx,'local.VItoken',NamedCredentialName,porttest);
            system.debug('@@ end of mock');
        }
        
        if(response != null){
            system.debug('response '+response);
            //system.debug('response body '+response.getbody());
            PdlInfo infoPdl = parseResponse(pceGaz, response);
            system.debug('infoPdl '+infoPdl);
            return infoPdl;
        }
        return null;
    }
    
    public static PdlInfo parseResponse(String pceGaz, gdfsuezBefCalypsoPdlgazV2.lirePDLGazResponse_element response){
        PdlInfo infoPDL = new PdlInfo(pceGaz, 'Gaz');
        List<Object> listOfreleves =  null;
        if(response.lirePDLGazOutput != null && response.lirePDLGazOutput.donneesPDL != null && response.lirePDLGazOutput.donneesPDL[0].donneesContractuelles != null ) {
            parseDonneesContractuelles(infoPDL,response.lirePDLGazOutput.donneesPDL[0].donneesContractuelles);
        }
        if( response.lirePDLGazOutput != null  && response.lirePDLGazOutput.donneesPDL != null && response.lirePDLGazOutput.donneesPDL[0].dernieresReleves != null ) {
            parseDernieresReleves(listOfreleves, infoPDL,response.lirePDLGazOutput.donneesPDL[0].dernieresReleves, response);
        }
        if(response.lirePDLGazOutput != null && response.lirePDLGazOutput.donneesPDL != null && response.lirePDLGazOutput.donneesPDL[0].installation!=null) {
            parseInstallation(infoPDL, response.lirePDLGazOutput.donneesPDL[0].installation);
        }
        if(response.lirePDLGazOutput!= null ){
        	parseAdresse(infoPDL, response);
            infoPDL.typeCompteur = (response.lirePDLGazOutput.donneesPDL[0].Gazpar != null  &&  response.lirePDLGazOutput.donneesPDL[0].Gazpar.etatPDL!= null && response.lirePDLGazOutput.donneesPDL[0].Gazpar.etatPDL.code!= null && response.lirePDLGazOutput.donneesPDL[0].Gazpar.etatPDL.code.equals('3')) ? 'Gazpar' : 'Historique';
            infoPDL.dateRefusTelereleve = (response.lirePDLGazOutput.donneesPDL[0].Gazpar != null  &&    response.lirePDLGazOutput.donneesPDL[0].Gazpar.dateRefusTelereleve!=null) ? response.lirePDLGazOutput.donneesPDL[0].Gazpar.dateRefusTelereleve : null;
            infoPDL.consommationSansFournisseur = (response.lirePDLGazOutput.donneesPDL[0].consommationSansFournisseur!=null) ? response.lirePDLGazOutput.donneesPDL[0].consommationSansFournisseur : null;
            infoPDL.CarActuelle = (response.lirePDLGazOutput.donneesPDL[0] != null &&  response.lirePDLGazOutput.donneesPDL[0].CAR != null && response.lirePDLGazOutput.donneesPDL[0].CAR.CAR_Actuelle != null && response.lirePDLGazOutput.donneesPDL[0].CAR.CAR_Actuelle.valeurCAR  != null ) ?  String.valueOf(response.lirePDLGazOutput.donneesPDL[0].CAR.CAR_Actuelle.valeurCAR) : null;
        }
        
        return infoPDL;
        /*if(listOfreleves!=null && listOfreleves.size()>0){
            return infoPDL;
        }
        else{
            return null;
        }
    }
    
    public static void parseAdresse(PdlInfo infoPDL, gdfsuezBefCalypsoPdlgazV2.lirePDLGazResponse_element response){
        String codepostal;
        String codeinsee;
        String ville;
        if(response.lirePDLGazOutput.donneesPDL != null && response.lirePDLGazOutput.donneesPDL[0].adresse != null && response.lirePDLGazOutput.donneesPDL[0].adresse.cP != null){
            infoPDL.codepostal =  response.lirePDLGazOutput.donneesPDL[0].adresse.cP;
        }
        if(response.lirePDLGazOutput.donneesPDL != null && response.lirePDLGazOutput.donneesPDL[0].adresse != null && response.lirePDLGazOutput.donneesPDL[0].adresse.iNSEE != null){
            infoPDL.codeinsee =  response.lirePDLGazOutput.donneesPDL[0].adresse.iNSEE;
        }
        if(response.lirePDLGazOutput.donneesPDL != null && response.lirePDLGazOutput.donneesPDL[0].adresse != null && response.lirePDLGazOutput.donneesPDL[0].adresse.ville != null){
            infoPDL.ville =  response.lirePDLGazOutput.donneesPDL[0].adresse.ville;
        }
        system.debug('infoPDL.ville '+infoPDL.ville);
        system.debug('infoPDL.codeinsee '+infoPDL.codeinsee);
        system.debug('infoPDL.codepostal'+infoPDL.codepostal);
    }    
  	public static void parseInstallation(PdlInfo infoPDL, gdfsuezComBefCalypsoPdlgaz.installationDt installation){
        infoPDL.etatTechnique = (installation.compteur != null && installation.compteur.etatTechnique != null ) ? installation.compteur.etatTechnique.code : null;
        infoPDL.matricule = (installation!= null && installation.compteur != null) ? installation.compteur.matricule : null;
        infoPDL.DGI = installation.compteur != null ? ((installation.compteur.DGI != null && installation.compteur.DGI) ? 'DGI' : 'Non DGI') : null;
    	infoPdl.situationCompteur = (installation.compteur != null && installation.compteur.situation != null) ? installation.compteur.situation.libelleCourt.toLowerCase('fr') : null;
        system.debug('infoPDL.etatTechnique '+infoPDL.etatTechnique);
        system.debug('infoPDL.matricule '+infoPDL.matricule);
        system.debug('infoPDL.DGI'+infoPDL.DGI);
        system.debug('infoPdl.situationCompteur'+infoPdl.situationCompteur);
    }
    
    public static void parseDernieresReleves(List<Object> listOfreleves, PdlInfo infoPDL, gdfsuezBefCalypsoPdlgazV2.PDLGaz_dernieresReleves_element derniersreleve, gdfsuezBefCalypsoPdlgazV2.lirePDLGazResponse_element response){
        DateTime dateDerniereReleve  = null;
        double dernierIndex ;
        String natureIndex;
        
        if(derniersreleve != null && derniersreleve.releve6M_1M != null && !derniersreleve.releve6M_1M.isEmpty()) {
            listOfreleves = new List<Object>();
            gdfsuezBefCalypsoPdlgazV2.releve6M_1MDt[] listofReleve = derniersreleve.releve6M_1M;
            
            if(listofReleve !=null) {
                for(gdfsuezBefCalypsoPdlgazV2.releve6M_1MDt releve : listofReleve ) {
                    listOfreleves.add(new Mesures(releve.dateFin,releve.indexFin));
                    if(dateDerniereReleve == null) {
                        // pour initaliser la date
                        dateDerniereReleve = releve.dateFin;
                        dernierIndex = releve.indexFin ;
                    }
                    
                    if(releve.dateFin > dateDerniereReleve) {
                        dateDerniereReleve = releve.dateFin;
                        dernierIndex = releve.indexFin ;
                    }
                }
            }
        }else if(response.lirePDLGazOutput != null && response.lirePDLGazOutput.donneesPDL != null  && response.lirePDLGazOutput.donneesPDL[0].derniersIndex != null  && response.lirePDLGazOutput.donneesPDL[0].derniersIndex.index != null){
            for(gdfsuezBefCalypsoPdlgazV2.PDLGaz_derniersIndex_index_element index : response.lirePDLGazOutput.donneesPDL[0].derniersIndex.index) {
                if(dateDerniereReleve == null) {  
                    dateDerniereReleve = index.dateIndex;
                    dernierIndex = index.valeurIndex ;
                    natureIndex =  index.natureIndex != null ?  index.natureIndex.libelleCourt  : null ;
                }else{
                    if( index.dateIndex > dateDerniereReleve) {
                        dateDerniereReleve = index.dateIndex;
                        dernierIndex = index.valeurIndex ;
                        natureIndex =  index.natureIndex != null ?  index.natureIndex.libelleCourt  : null ;
                        
                    }
                }
                
            }
        }
        infoPDL.dateDerniereReleve =dateDerniereReleve;
        infoPDL.dateDerniereTelereleve = derniersreleve.dateDerniereTelereleve!=null ?derniersreleve.dateDerniereTelereleve : null;
    	infoPDL.natureIndex = natureIndex;
        infoPdl.dernierIndex = dernierIndex == null ?  null: String.valueOf(dernierIndex) ;
    }
	public static void parseDonneesContractuelles(PdlInfo infoPDL, gdfsuezBefCalypsoPdlgazV2.PDLGaz_donneesContractuelles_element donneesContractuelles ){
        if(donneesContractuelles.tarifAcheminement !=null){
            infoPDL.ftaLibelle =  donneesContractuelles.tarifAcheminement.libelleCourt ;
        }
        if(donneesContractuelles.donneesReleve != null) {
            Boolean accesReleve;
            accesReleve = donneesContractuelles.donneesReleve[0].accesReleve;
            infoPDL.accessReleve =  (accesReleve== null  ? null : accesReleve ? 'Accessible' : 'Non accessible');
        }
        
        String frequenceReleve = null;
        if(donneesContractuelles.donneesReleve != null && donneesContractuelles.donneesReleve[0].frequenceReleve != null ) {
            infoPDL.frequenceReleve =  donneesContractuelles.donneesReleve[0].frequenceReleve.code;
        }
        String valeurIndexMiseHorsService;
        if((donneesContractuelles !=null && donneesContractuelles.donneesReleve != null  && donneesContractuelles.donneesReleve[0].valeurIndexMiseHorsService != null)) {
                infoPDL.valeurIndexMiseHorsService = String.valueOf(donneesContractuelles.donneesReleve[0].valeurIndexMiseHorsService);
        }
        
        infoPDL.statutContractuel = (donneesContractuelles.statutContractuel !=null ? donneesContractuelles.statutContractuel : null);
    	infoPDL.dateMiseHorsService = (donneesContractuelles.donneesReleve != null  && donneesContractuelles.donneesReleve[0].dateMiseHorsService != null) ? donneesContractuelles.donneesReleve[0].dateMiseHorsService : null;
    	infoPDL.fta = ( donneesContractuelles.tarifAcheminement !=null) ? donneesContractuelles.tarifAcheminement.code : null;
        infoPDL.miseHorsServiceEnCours = donneesContractuelles.miseHorsServiceEnCours!=null ? donneesContractuelles.miseHorsServiceEnCours : null;
        infoPDL.fraude = (donneesContractuelles.donneesCoupure != null && donneesContractuelles.donneesCoupure.fraude!=null) ? donneesContractuelles.donneesCoupure.fraude : null;
    }
    
    public class PdlInfo {
        
        public String accessReleve;           // données pdl > donneesContractuelles > donneesReleve > accesReleve
        public String statutContractuel;          // données pdl > donneesContractuelles >statutContractuel
        public Datetime dateMiseHorsService;           // données pdl > donneesContractuelles > donneesReleve > dateMiseHorsService
        public String etatTechnique;          // données  données pdl > installation > compteur > etat technique > code
        public String matricule;             // données pdl > installation > compteur > matricule
        public String idPdl;
        public string pdlType;          // Gaz Elec
        public Datetime dateDerniereReleve;            //données pdl > donneesContractuelles > donneesReleve > dateDerniereReleve
        public String dgi;
        public String fta;
        public String typeCompteur;
        public DateTime dateRefusTelereleve;
        public Boolean miseHorsServiceEnCours;
        public Boolean consommationSansFournisseur;
        public Datetime dateDerniereTelereleve;
        public Boolean fraude;
        public String frequenceReleve;
        public String valeurIndexMiseHorsService;
        public String CARActuelle;
        public String natureIndex;
        public String ftaLibelle;
        public String dernierIndex;
        public String situationCompteur;                   //donneesPDL . installation . compteur . situation . libelleCourt
        public string codepostal;
        public string codeinsee;
        public string ville;
        public PdlInfo(String pceGaz, String pdlType){
        	this.idPdl = pceGaz;
            this.pdlType = pdlType;
        }
        public PdlInfo(String accessReleve,String statutContractuel,Datetime dateMiseHorsService,String etatTechnique,String matricule,String idPdl,
                       string pdlType,Datetime dateDerniereReleve,String dgi,String fta,String typeCompteur,Datetime dateRefusTelereleve,Boolean miseHorsServiceEnCours,
                       Boolean consommationSansFournisseur,Datetime dateDerniereTelereleve,Boolean fraude, String frequenceReleve, String valeurIndexMiseHorsService,String CARActuelle,String natureIndex,String ftaLibelle){
                           
                           this.accessReleve  = accessReleve;
                           this.statutContractuel  =statutContractuel;
                           this.dateMiseHorsService= dateMiseHorsService;
                           this.etatTechnique  = etatTechnique;
                           this.matricule  = matricule;
                           this.idPdl   =idPdl;
                           this.pdlType  = pdlType;
                           this.dateDerniereReleve = dateDerniereReleve;
                           this.dgi = dgi;
                           this.fta = fta;
                           this.typeCompteur=typeCompteur;
                           this.dateRefusTelereleve=dateRefusTelereleve;
                           this.miseHorsServiceEnCours=miseHorsServiceEnCours;
                           this.consommationSansFournisseur=consommationSansFournisseur;
                           this.dateDerniereTelereleve=dateDerniereTelereleve;
                           this.fraude=fraude;
                           this.frequenceReleve = frequenceReleve;
                           this.valeurIndexMiseHorsService = valeurIndexMiseHorsService;
                           this.CARActuelle =  CARActuelle;
                           this.natureIndex  = natureIndex;
                           this.ftaLibelle = ftaLibelle ;
                       }
    }
    
    public class Mesures {
        
        public datetime dateMesure;
        public double mesures;
        
        
        public Mesures(datetime dateMesure, double mesures ){
            this.dateMesure = dateMesure;
            this.mesures = mesures;
        }
    }
    ////NEW
    //
    public static gdfsuezBefCalypsoPdlgazV2.lirePDLGazResponse_element LirePDLGaz_Http(gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt lirePDLGazInput,gdfsuezComBefChpPivot.contextDt context, 
                                                                               /*ADDEDString partition,String NamedCredentialName,
                                                                               gdfsuezBefCalypsoPdlgazV2.Dependency port) 
    {
        DOM.Document doc = new DOM.Document();
        DOM.XmlNode body = populateDoc(doc);
        DOM.XmlNode methodNode = body.addChildElement('lirePDLGaz', 'http://gdfsuez/bef/calypso/pdlgaz/v2', 'v2');
        gdfsuezBefCalypsoPdlgazV2.lirePDLGaz_element request_x = new gdfsuezBefCalypsoPdlgazV2.lirePDLGaz_element(lirePDLGazInput,context);
        populateXmlNode(methodNode,lirePDLGazInput, context);
        HttpRequest req = new HttpRequest();
        /*if(!HP_Constantes.IS_HAPPE_PROFILE){
req.setClientCertificateName(Label.SM_CL_OctopusCertificate);
}
        //req.setEndpoint(endpoint_x);  old
        req.setEndpoint(NamedCredentialName+'/ES-PDLGaz_v2');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml; charset=UTF-8');
        req.setHeader('SOAPAction', 'tns:LirePDLGaz');
        req.setBodyDocument(doc);
        //req.setBody('===='+doc.toXmlString());
        system.debug('request => '+doc.toXmlString());
        Http http = new Http();
        datetime startCall = datetime.now();
        HTTPResponse res = http.send(req);
        datetime endCall = datetime.now();
        HP_UTIL_HTTPUtils.saveLogResponse(req, res, (endCall.getTime() - startCall.getTime()));
        System.debug('response is => '+res.getBody());
        Dom.Document responseDoc = res.getBodyDocument();
        System.debug('body document body => '+res.getBodyDocument().toXmlString());
        Dom.XmlNode rootNode = responseDoc.getRootElement();
        system.debug('root childs =>'+rootNode.getChildElements());
        Dom.XmlNode bodyNode = rootNode.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/');
        system.debug('body =>'+bodyNode.getText());
        Dom.XmlNode lirePDLGazResponseNode = bodyNode.getChildElement('lirePDLGazResponse', 'http://gdfsuez/bef/calypso/pdlgaz/v2');
        system.debug('lirePdlGAzresponse => '+bodyNode.getText());
        gdfsuezBefCalypsoPdlgazV2.lirePDLGazResponse_element response_x = new gdfsuezBefCalypsoPdlgazV2.lirePDLGazResponse_element(lirePDLGazResponseNode);
        return response_x;
        //return null;
        
    }
    
    public static void populateXmlNode(Dom.XmlNode outerNode,gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt lirePDLGazInputObj,gdfsuezComBefChpPivot.contextDt contextObj){
        
        //System.assertEquals('LirePDLGaz', outerNode.getName());
        
        //gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt lirePDLGazInputObj = this.lirePDLGazInput;
        Dom.XmlNode lirePDLGazInputNode = outerNode.addChildElement('lirePDLGazInput', '', '');
        if(lirePDLGazInputObj != null){
            lirePDLGazInputObj.populateXmlNode(lirePDLGazInputNode);
        }
        
        //gdfsuezComBefChpPivot.contextDt contextObj = this.context;
        Dom.XmlNode contextNode = outerNode.addChildElement('context', '', '');
        if(contextObj != null){
            contextObj.populateXmlNode(contextNode);
        }
    }
    
    private static DOM.XmlNode populateDoc(DOM.Document doc){
			String env = 'http://schemas.xmlsoap.org/soap/envelope/';
			String xsi = 'http://www.w3.org/2001/XMLSchema-instance';
			String xsd = 'http://www.w3.org/2001/XMLSchema';
			String v2 = 'http://gdfsuez/bef/calypso/pdlgaz/v2';
			DOM.XmlNode envelope = doc.createRootElement('Envelope', env, 'env');
			envelope.setNamespace('xsd', xsd);
			envelope.setNamespace('xsi', xsi);
			envelope.setNamespace('v2', v2);
			DOM.XmlNode header = envelope.addChildElement('Header', env, '');
			//System.debug(doc.toXmlString());
			DOM.XmlNode body = envelope.addChildElement('Body', env, 'env');
			return body;
		}
    */
    
    //NEW METHODS WITH VI
    //====================
    public static VI_gdfsuezComBefChpPivot.contextDt initContextV2(String application, String version) {
        // Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
        VI_gdfsuezComBefChpPivot.system_element osource = new VI_gdfsuezComBefChpPivot.system_element();
        osource.systemId=application;
        VI_gdfsuezComBefChpPivot.contextDt octx = new VI_gdfsuezComBefChpPivot.contextDt();
        octx.version=version;
        octx.systemPath = new VI_gdfsuezComBefChpPivot.systemPath_element();
        octx.systemPath.system_x = new VI_gdfsuezComBefChpPivot.system_element[] {osource};
            return octx;
    }
    
    //VERIFIER ENDPOINT
    public static VI_gdfsuezBefCalypsoPdlgazV3.Dependency initPortV2(String NamedCredentialName){
        VI_gdfsuezBefCalypsoPdlgazV3.Dependency port = new VI_gdfsuezBefCalypsoPdlgazV3.Dependency();
        port.endpoint_x =  NamedCredentialName+'/ES-PDLGaz_v3';
        port.inputHttpHeaders_x = new Map<String, String> {'Content-Type' => 'text/xml;charset=utf-8'};
        return port;
    }
    //A VOIR COMMENT REMPLIR listPDLGazElement
    public static VI_gdfsuezBefCalypsoPdlgazV3.lirePDLGazInputDt createInputV2(Boolean online,String pceGaz, Boolean recupererDerniersIndexGaz, Boolean AutorisationSituationContractuelle,
                                                                          String typeOffre, String loginUtilisateur)
    {
        VI_gdfsuezBefCalypsoPdlgazV3.PDLGaz_element element= createElementV2( pceGaz,  recupererDerniersIndexGaz,  AutorisationSituationContractuelle);
        List<VI_gdfsuezBefCalypsoPdlgazV3.PDLGaz_element> listPDLGazElement=new List<VI_gdfsuezBefCalypsoPdlgazV3.PDLGaz_element>();
        listPDLGazElement.add(element);
        VI_gdfsuezBefCalypsoPdlgazV3.lirePDLGazInputDt input = new VI_gdfsuezBefCalypsoPdlgazV3.lirePDLGazInputDt();
        input.online = true;
        input.typeOffre = createTypeOffre(typeOffre);
        input.loginUtilisateur = loginUtilisateur;
        input.PDLGaz = listPDLGazElement;
        return input;
    }
    //VERIFIER S IL FAUT REMPLIR D AUTRES CHAMPS
    public static VI_gdfsuezBefCalypsoPdlgazV3.PDLGaz_element createElementV2(String pceGaz, Boolean recupererDerniersIndexGaz, Boolean AutorisationSituationContractuelle){
        VI_gdfsuezBefCalypsoPdlgazV3.PDLGaz_element element = new VI_gdfsuezBefCalypsoPdlgazV3.PDLGaz_element();
        element.PDLGaz= new VI_gdfsuezComBefCalypsoPdlgaz.PDLGazAbstract();
        element.PDLGaz.idPDLGaz =  pceGaz; //'21101817097249' ;
        element.recupererDerniersIndexGaz= recupererDerniersIndexGaz;// true;
        element.AutorisationSituationContractuelle= AutorisationSituationContractuelle;//true ;
        return element;
    }
    
    public static String lirePdlV2(String pceGaz, String application, String version,String NamedCredentialName) {
        if(String.isBlank(pceGaz)){
            system.debug('no selected pce val ');
            return null;
        }
        VI_gdfsuezComBefChpPivot.contextDt octx = initContextV2(application,version);
        VI_gdfsuezBefCalypsoPdlgazV3.Dependency port = initPortV2(NamedCredentialName);
        VI_gdfsuezBefCalypsoPdlgazV3.PDLGaz_element element = createElementV2(pceGaz, true,true );
        VI_gdfsuezBefCalypsoPdlgazV3.lirePDLGazInputDt input = createInputV2(true, pceGaz,true,true,'INDUSTRIELLE', /*service.getIdentifiantDistribFromApex()*/ 'homologation@engie.com');
        String valeurCAR;
        if(!Test.isRunningTest()) {
            valeurCAR =LirePDLGaz_HttpV2(input,octx,'Local.VIToken',NamedCredentialName,port);
            system.debug('valeurCAR '+valeurCAR);
        }
        else {
            Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPdlgazV2HttpMock());
            VI_gdfsuezBefCalypsoPdlgazV3.Dependency porttest = new VI_gdfsuezBefCalypsoPdlgazV3.Dependency();
            system.debug('@@ start of mock');  
            valeurCAR =LirePDLGaz_HttpV2(input,octx,'Local.VIToken',NamedCredentialName,porttest);
            system.debug('@@ end of mock');
        }
        
        if(valeurCAR != null){
            system.debug('valeurCAR '+valeurCAR);
            return valeurCAR;
        }
        return null;
    }
    
    public static String LirePDLGaz_HttpV2(VI_gdfsuezBefCalypsoPdlgazV3.lirePDLGazInputDt lirePDLGazInput,
                                                                                         VI_gdfsuezComBefChpPivot.contextDt context, 
                                                                               /*ADDED*/String partition,String NamedCredentialName,
                                                                               VI_gdfsuezBefCalypsoPdlgazV3.Dependency port) 
    {
        DOM.Document doc = new DOM.Document();
        DOM.XmlNode body = populateDocV2(doc);
        DOM.XmlNode methodNode = body.addChildElement('lirePDLGaz', 'http://gdfsuez/bef/calypso/pdlgaz/v3', 'v3');
        VI_gdfsuezBefCalypsoPdlgazV3.lirePDLGaz_element request_x = createlirePDLGazElement(lirePDLGazInput,context);
        populateXmlNodeV2(methodNode,lirePDLGazInput, context);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(NamedCredentialName+'/ES-PDLGaz_v3');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml; charset=UTF-8');
        req.setHeader('SOAPAction', 'tns:LirePDLGaz');
        req.setBodyDocument(doc);
        system.debug('reqbody '+req.getBody());
        Http http = new Http();
        HTTPResponse res = http.send(req);
        Dom.Document responseDoc = res.getBodyDocument();
        system.debug('res.getBodyDocument(); '+res.getBodyDocument().getRootElement());
        Dom.XmlNode rootNode = responseDoc?.getRootElement();
        Dom.XmlNode bodyNode = rootNode?.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/');
        Dom.XmlNode lirePDLGazResponseNode = bodyNode?.getChildElement('lirePDLGazResponse', 'http://gdfsuez/bef/calypso/pdlgaz/v3');
        Dom.XmlNode lirePDLGazOutputResponseNode = lirePDLGazResponseNode?.getChildElement('lirePDLGazOutput',null);
        Dom.XmlNode donneesPDLNode = lirePDLGazOutputResponseNode?.getChildElement('donneesPDL',null);
        Dom.XmlNode CARNode = donneesPDLNode?.getChildElement('CAR',null);
        Dom.XmlNode CARActuelleNode = CARNode?.getChildElement('CAR_Actuelle',null);
        Dom.XmlNode valeurCARNode = CARActuelleNode?.getChildElement('valeurCAR',null);
        String valeurCAR = CARActuelleNode?.getChildElement('valeurCAR',null)?.getText();
        
        return valeurCAR;
        
    }
    
    public static VI_gdfsuezBefCalypsoPdlgazV3.lirePDLGaz_element createlirePDLGazElement(VI_gdfsuezBefCalypsoPdlgazV3.lirePDLGazInputDt lirePDLGazInput,
                                                                                          VI_gdfsuezComBefChpPivot.contextDt context)
    {
        VI_gdfsuezBefCalypsoPdlgazV3.lirePDLGaz_element element =new VI_gdfsuezBefCalypsoPdlgazV3.lirePDLGaz_element();
        element.lirePDLGazInput = lirePDLGazInput;
        element.context = context;
        return element;
    }
    
    public static void populateXmlNodeV2(Dom.XmlNode outerNode,VI_gdfsuezBefCalypsoPdlgazV3.lirePDLGazInputDt lirePDLGazInputObj,VI_gdfsuezComBefChpPivot.contextDt contextObj){
        
        //gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt lirePDLGazInputObj = this.lirePDLGazInput;
        Dom.XmlNode lirePDLGazInputNode = outerNode.addChildElement('lirePDLGazInput', '', '');
        if(lirePDLGazInputObj != null){
            //lirePDLGazInputObj.populateXmlNode(lirePDLGazInputNode);
            Dom.XmlNode onlineNode = lirePDLGazInputNode.addChildElement('online', '', '');
            if(lirePDLGazInputObj.online != null){
                onlineNode.addTextNode(String.valueOf(lirePDLGazInputObj.online));
            }
            Dom.XmlNode loginUtilisateurNode = lirePDLGazInputNode.addChildElement('loginUtilisateur', '', '');
            loginUtilisateurNode.addTextNode((lirePDLGazInputObj.loginUtilisateur == null) ? '' : lirePDLGazInputObj.loginUtilisateur);
            
            VI_gdfsuezComBefChpPivot.listeValeursDt typeOffreObj = lirePDLGazInputObj.typeOffre;
            Dom.XmlNode typeOffreNode = lirePDLGazInputNode.addChildElement('typeOffre', '', '');
            if(typeOffreObj != null){
                if(typeOffreObj.idValeur != null){
                    Dom.XmlNode idValeurNode = typeOffreNode.addChildElement('idValeur', '', '');
                    idValeurNode.addTextNode((typeOffreObj.idValeur == null) ? '' : typeOffreObj.idValeur);
                }
                if(typeOffreObj.description != null){
                    Dom.XmlNode descriptionNode = typeOffreNode.addChildElement('description', '', '');
                    descriptionNode.addTextNode((typeOffreObj.description == null) ? '' : typeOffreObj.description);
                }
                if(typeOffreObj.categorie != null){
                    Dom.XmlNode categorieNode = typeOffreNode.addChildElement('categorie', '', '');
                    categorieNode.addTextNode((typeOffreObj.categorie == null) ? '' : typeOffreObj.categorie);
                }
                if(typeOffreObj.order != null){
                    Dom.XmlNode orderNode = typeOffreNode.addChildElement('order', '', '');
                    orderNode.addTextNode((typeOffreObj.order == null) ? '' : typeOffreObj.order);
                }
                if(typeOffreObj.libelleCourt != null){
                    Dom.XmlNode libelleCourtNode = typeOffreNode.addChildElement('libelleCourt', '', '');
                    libelleCourtNode.addTextNode((typeOffreObj.libelleCourt == null) ? '' : typeOffreObj.libelleCourt);
                }
                if(typeOffreObj.libelleLong != null){
                    Dom.XmlNode libelleLongNode = typeOffreNode.addChildElement('libelleLong', '', '');
                    libelleLongNode.addTextNode((typeOffreObj.libelleLong == null) ? '' : typeOffreObj.libelleLong);
                }
                if(typeOffreObj.actif != null){
                    Dom.XmlNode actifNode = typeOffreNode.addChildElement('actif', '', '');
                    actifNode.addTextNode((typeOffreObj.actif == null) ? '' : typeOffreObj.actif);
                }
                if(typeOffreObj.langue != null){
                    Dom.XmlNode langueNode = typeOffreNode.addChildElement('langue', '', '');
                    langueNode.addTextNode((typeOffreObj.langue == null) ? '' : typeOffreObj.langue);
                }
                if(typeOffreObj.code != null){
                    Dom.XmlNode codeNode = typeOffreNode.addChildElement('code', '', '');
                    codeNode.addTextNode((typeOffreObj.code == null) ? '' : typeOffreObj.code);
                }
            }
            VI_gdfsuezBefCalypsoPdlgazV3.PDLGaz_element[] PDLGazObj = lirePDLGazInputObj.PDLGaz;
            if(PDLGazObj != null){
                for(VI_gdfsuezBefCalypsoPdlgazV3.PDLGaz_element element: PDLGazObj){
                    Dom.XmlNode pdlGazNode = lirePDLGazInputNode.addChildElement('PDLGaz', '', '');
                    if(element.codePostal != null){
                        Dom.XmlNode codePostalNode = pdlGazNode.addChildElement('codePostal', '', '');
                        codePostalNode.addTextNode((element.codePostal == null) ? '' : element.codePostal);
                    }
                    if(element.typeOccupant != null){
                        Dom.XmlNode typeOccupantNode = pdlGazNode.addChildElement('typeOccupant', '', '');
                        typeOccupantNode.addTextNode((element.typeOccupant == null) ? '' : element.typeOccupant);
                    }
                    if(element.autorisationSituationContractuelle != null){
                        Dom.XmlNode autorisationSituationContractuelleNode = pdlGazNode.addChildElement('autorisationSituationContractuelle', '', '');
                        autorisationSituationContractuelleNode.addTextNode((element.autorisationSituationContractuelle == null) ? '' : String.valueOf(element.autorisationSituationContractuelle));			
                    }
                    if(element.recupererDerniersIndexGaz != null){
                        Dom.XmlNode recupererDerniersIndexGazNode = pdlGazNode.addChildElement('recupererDerniersIndexGaz', '', '');
                        recupererDerniersIndexGazNode.addTextNode((element.recupererDerniersIndexGaz == null) ? '' : String.valueOf(element.recupererDerniersIndexGaz));			
                    }
                    if(element.PlageDebutConso != null){
                        Dom.XmlNode PlageDebutConsoNode = outerNode.addChildElement('PlageDebutConso', '', '');
                        PlageDebutConsoNode.addTextNode((element.PlageDebutConso == null) ? '' : String.valueOf(element.PlageDebutConso));			
                    }
                    if(element.PlageFinConso != null){
                        Dom.XmlNode PlageFinConsoNode = outerNode.addChildElement('PlageFinConso', '', '');
                        PlageFinConsoNode.addTextNode((element.PlageFinConso == null) ? '' : String.valueOf(element.PlageFinConso));			
                    }
                    if(element.AutorisationConso != null){
                        Dom.XmlNode AutorisationConsoNode = pdlGazNode.addChildElement('AutorisationConso', '', '');
                        AutorisationConsoNode.addTextNode((element.AutorisationConso == null) ? '' : element.AutorisationConso);
                    }
                    if(element.AutorisationConsoEtendue != null){
                        Dom.XmlNode AutorisationConsoEtendueNode = pdlGazNode.addChildElement('AutorisationConsoEtendue', '', '');
                        AutorisationConsoEtendueNode.addTextNode((element.AutorisationConsoEtendue == null) ? '' : String.valueOf(element.AutorisationConsoEtendue));			
                    }
                    if(element.AutorisationConsoEtendue != null){
                        Dom.XmlNode ConsultationConsoPCELibreNode = pdlGazNode.addChildElement('ConsultationConsoPCELibre', '', '');
                        ConsultationConsoPCELibreNode.addTextNode((element.ConsultationConsoPCELibre == null) ? '' : String.valueOf(element.ConsultationConsoPCELibre));			
                    }
                   
                    if(element.PDLGaz!= null){
                        Dom.XmlNode pdlGazInnerNode = pdlGazNode.addChildElement('PDLGaz', '', '');
                        Dom.XmlNode idPDLGazNode = pdlGazInnerNode.addChildElement('idPDLGaz', '', '');
                        if(element.PDLGaz.idPDLGaz != null){
                            idPDLGazNode.addTextNode(String.valueOf(element.PDLGaz.idPDLGaz));
                        }
                    }
                }
            }
        }
        
        //gdfsuezComBefChpPivot.contextDt contextObj = this.context;
        Dom.XmlNode contextNode = outerNode.addChildElement('context', '', '');
        if(contextObj != null){
            Dom.XmlNode versionNode = contextNode.addChildElement('version', '', '');
            if(contextObj.version != null){
                versionNode.addTextNode(contextObj.version);
            }
            
            if(contextObj.allowCache != null){
                Dom.XmlNode allowCacheNode = contextNode.addChildElement('allowCache', '', '');
                allowCacheNode.addTextNode((contextObj.allowCache == null) ? '' : String.valueOf(contextObj.allowCache));
            }
            
            VI_gdfsuezComBefChpPivot.systemPath_element systemPathObj = contextObj.systemPath;
            Dom.XmlNode systemPathNode = contextNode.addChildElement('systemPath', '', '');
            if(systemPathObj != null){
                VI_gdfsuezComBefChpPivot.system_element[] system_xObj = systemPathObj.system_x;
                if(system_xObj != null){
                    for(VI_gdfsuezComBefChpPivot.system_element element: system_xObj){
                        Dom.XmlNode system_xNode = systemPathNode.addChildElement('system', '', '');
                        Dom.XmlNode systemIdNode = system_xNode.addChildElement('systemId', '', '');
                        if(element.systemId != null){
                            systemIdNode.addTextNode(element.systemId);
                        }
                    }
                }    
            }
        }
    }
    
    //Intiate picklistValue
    public static VI_gdfsuezComBefChpPivot.listeValeursDt createTypeOffre( String value){
        VI_gdfsuezComBefChpPivot.listeValeursDt valueToReturn = new VI_gdfsuezComBefChpPivot.listeValeursDt();
        valueToReturn.code = value;
        return valueToReturn;
    }
    
    private static DOM.XmlNode populateDocV2(DOM.Document doc){
			String env = 'http://schemas.xmlsoap.org/soap/envelope/';
			String xsi = 'http://www.w3.org/2001/XMLSchema-instance';
			String xsd = 'http://www.w3.org/2001/XMLSchema';
			String v2 = 'http://gdfsuez/bef/calypso/pdlgaz/v2';
			DOM.XmlNode envelope = doc.createRootElement('Envelope', env, 'env');
			envelope.setNamespace('xsd', xsd);
			envelope.setNamespace('xsi', xsi);
			envelope.setNamespace('v2', v2);
			DOM.XmlNode header = envelope.addChildElement('Header', env, '');
			//System.debug(doc.toXmlString());
			DOM.XmlNode body = envelope.addChildElement('Body', env, 'env');
			return body;
		}
    
    
    
}