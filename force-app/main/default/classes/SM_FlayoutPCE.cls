global class SM_FlayoutPCE {
    

    public static SM_UTIL_Cache_Management service = new SM_UTIL_Cache_Management();
    
    @AuraEnabled(cacheable=true)
    public static Map < String, Object > getFlayoutPCEData(String PCEIdentifier,Boolean PerimetrePCE) {
        
        Map < String, Object > PCEInfosReturn = new Map < String, Object >();
     
        
        //
        gdfsuezComBefChpPivot.contextDt octx = initContext('Smile', '2.0');
            gdfsuezBefCalypsoPdlgazV2.Dependency port = new gdfsuezBefCalypsoPdlgazV2.Dependency();
            SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();
            port.clientCertName_x = octopusCS.certName__c;
            SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'PDLGaz' limit 1];
            port.endpoint_x =  octopusCS.endpoint__c+suffixs.suffix__c;
            //  port.endpoint_x = 'https://octopus.ws-ines-rct.engie.com:50001/smile-noprod-gdc/ws/ES-PDLGaz_v2';
            port.inputHttpHeaders_x = new Map<String, String> {'Content-Type' => 'text/xml;charset=utf-8'};

            gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt input = new  gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt();
            input.online = true;
            input.typeOffre = new gdfsuezComBefChpPivot.listeValeursDt();
            input.typeOffre.code = 'INDUSTRIELLE';  // à externaliser
            input.loginUtilisateur = service.getIdentifiantDistribFromApex();


            gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt_PDLGaz_element element = new gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt_PDLGaz_element();
            element.PDLGaz= new gdfsuezComBefCalypsoPdlgaz.PDLGazAbstract();
            element.PDLGaz.idPDLGaz =  PCEIdentifier; 
            element.recupererDerniersIndexGaz= true;
            element.AutorisationSituationContractuelle= true ; 
            input.PDLGaz = element;
            gdfsuezBefCalypsoPdlgazV2.lirePDLGazResponse_element response;

            if(!Test.isRunningTest()) {
                    response  = port.LirePDLGaz_Http(input,octx);
                    system.debug('@@ response data');
                    system.debug(response);
            }
            else {
                    Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPdlgazV2HttpMock());
                    gdfsuezBefCalypsoPdlgazV2.Dependency porttest = new gdfsuezBefCalypsoPdlgazV2.Dependency();
                    system.debug('@@ start of mock');
                    response = porttest.LirePDLGaz_Http(input, octx);
                    system.debug('@@ end of mock');
                    

            }
        
        	gdfsuezBefCalypsoPdlgazV2.PDLGaz_donneesContractuelles_element donneesContractuelles;
            if(response != null && response.lirePDLGazOutput != null && response.lirePDLGazOutput.donneesPDL != null && response.lirePDLGazOutput.donneesPDL[0].donneesContractuelles != null ) {
                    donneesContractuelles =  response.lirePDLGazOutput.donneesPDL[0].donneesContractuelles;
            }

            gdfsuezBefCalypsoPdlgazV2.PDLGaz_dernieresReleves_element derniersreleve;

            if( response != null && response.lirePDLGazOutput != null  && response.lirePDLGazOutput.donneesPDL != null && response.lirePDLGazOutput.donneesPDL[0].dernieresReleves != null ) {
                    derniersreleve= response.lirePDLGazOutput.donneesPDL[0].dernieresReleves;
            }
        
        
        List<Object> listOfreleves =  null;
            DateTime dateDerniereReleve  = null;
            double dernierIndex ;
           String natureIndex;
            if(derniersreleve != null) {
                    listOfreleves = new List<Object>();
                    gdfsuezBefCalypsoPdlgazV2.releve6M_1MDt[] listofReleve = derniersreleve.releve6M_1M;

                    if(listofReleve !=null) {
                            for(gdfsuezBefCalypsoPdlgazV2.releve6M_1MDt releve : listofReleve ) {
                                    listOfreleves.add(new Mesures(releve.dateFin,releve.indexFin));
                                    if(dateDerniereReleve == null) {
                                            // pour initaliser la date
                                            dateDerniereReleve = releve.dateFin;
                                           dernierIndex = releve.indexFin ;
                                            //   break ;
                                    }

                                    if(releve.dateFin > dateDerniereReleve) {
                                            dateDerniereReleve = releve.dateFin;
                                            dernierIndex = releve.indexFin ;
                                    }
                            }
                    }
            }else if(response != null && response.lirePDLGazOutput != null && response.lirePDLGazOutput.donneesPDL != null  && response.lirePDLGazOutput.donneesPDL[0].derniersIndex != null  && response.lirePDLGazOutput.donneesPDL[0].derniersIndex.index != null){
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
                                     // ==> dans le contexte de l'us SMIL-1400 recupérer le nature de dernier index pour l'aficher dans la partie recap OPS gaz

                        }
                    }
                    
                }
            }
            Boolean accesReleve;

            if(donneesContractuelles !=null && donneesContractuelles.donneesReleve != null) {
                    accesReleve = donneesContractuelles.donneesReleve[0].accesReleve;
            }

            String frequenceReleve = null;
            if(donneesContractuelles !=null && donneesContractuelles.donneesReleve != null && donneesContractuelles.donneesReleve[0].frequenceReleve != null ) {
                    frequenceReleve =  donneesContractuelles.donneesReleve[0].frequenceReleve.code;
            }

            Datetime dateMiseHorsService = (donneesContractuelles !=null && donneesContractuelles.donneesReleve != null  && donneesContractuelles.donneesReleve[0].dateMiseHorsService != null) ? donneesContractuelles.donneesReleve[0].dateMiseHorsService : null;

            String valeurIndexMiseHorsService;
            if((donneesContractuelles !=null && donneesContractuelles.donneesReleve != null  && donneesContractuelles.donneesReleve[0].valeurIndexMiseHorsService != null)) {
                    try{
                            valeurIndexMiseHorsService = String.valueOf(donneesContractuelles.donneesReleve[0].valeurIndexMiseHorsService);
                    }
                    catch(Exception e) {
                    }
            }


            gdfsuezComBefCalypsoPdlgaz.installationDt installation;
            if(response != null && response.lirePDLGazOutput != null && response.lirePDLGazOutput.donneesPDL != null) {
                    installation =  response.lirePDLGazOutput.donneesPDL[0].installation;
            }
            //system.debug('typeCompteur'+response.lirePDLGazOutput.donneesPDL[0].Gazpar.etatPDL.code);

   
            // <== dans le contexte de l'us SMIL-1400 recupérer le nature de dernier index pour l'aficher dans la partie recap OPS gaz

           String ftaLibelle ; 
           if(donneesContractuelles !=null && donneesContractuelles.tarifAcheminement !=null){
                ftaLibelle = donneesContractuelles.tarifAcheminement.code + ' - ' + donneesContractuelles.tarifAcheminement.libelleCourt;
           }
        
        
        String Accessibilite = '';
        String  typeCompteur = '';
        String  ConsommationAnnuelle = '';
        String etatAlimentation = '';
        String Perimetre = '';
        
        //Accessibilite
        if(accesReleve != null){
            Accessibilite = 'Accessible';
        }
        else {
            Accessibilite = 'Non accessible';
        }
        
        //TypeCompteur
        if(response != null && response.lirePDLGazOutput.donneesPDL[0].Gazpar != null
           &&  response.lirePDLGazOutput.donneesPDL[0].Gazpar.etatPDL!= null
           && response.lirePDLGazOutput.donneesPDL[0].Gazpar.etatPDL.code!= null
           && response.lirePDLGazOutput.donneesPDL[0].Gazpar.etatPDL.code.equals('3')){
               typeCompteur = 'Compteur Gazpar';
           }
        else{
            typeCompteur = 'Compteur Gaz';
        }
            
		//ConsommationAnnuelle
        if(response != null && response.lirePDLGazOutput.donneesPDL[0] != null 
           &&  response.lirePDLGazOutput.donneesPDL[0].CAR != null
           && response.lirePDLGazOutput.donneesPDL[0].CAR.CAR_Actuelle != null
           && response.lirePDLGazOutput.donneesPDL[0].CAR.CAR_Actuelle.valeurCAR  != null ){
            ConsommationAnnuelle = String.valueOf(response.lirePDLGazOutput.donneesPDL[0].CAR.CAR_Actuelle.valeurCAR);
           }
        
        // etatAlimentation
        if(installation!= null && installation.compteur != null && installation.compteur.etatTechnique != null ){
            etatAlimentation = installation.compteur.etatTechnique.code;
        }
        
        //PerimetrePCE
        
        if(PerimetrePCE == true){
            Perimetre = 'PCE hors périmètre';
        }
        else{
            Perimetre = 'PCE dans le périmètre';            
        }

        // PCEInfosReturn
        PCEInfosReturn.put('PerimetrePCE',Perimetre);
        PCEInfosReturn.put('TypeCompteur',typeCompteur);
        PCEInfosReturn.put('ConsommationAnnuelle',ConsommationAnnuelle);
        PCEInfosReturn.put('Accessibilite',Accessibilite);
        PCEInfosReturn.put('etatAlimentation',etatAlimentation);
        PCEInfosReturn.put('TA',ftaLibelle);
                                        
        
        //
        system.debug('PCEInfosReturn :'+PCEInfosReturn);
        return PCEInfosReturn;
    }
    
    public static gdfsuezComBefChpPivot.contextDt initContext(String application, String version) {
            // Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
            gdfsuezComBefChpPivot.system_element osource = new gdfsuezComBefChpPivot.system_element();
            osource.systemId=application;
            gdfsuezComBefChpPivot.contextDt octx = new gdfsuezComBefChpPivot.contextDt();
            octx.version=version;
            //  octx.allowCache = false ;
            octx.systemPath = new gdfsuezComBefChpPivot.systemPath_element();
            octx.systemPath.system_x = new gdfsuezComBefChpPivot.system_element[] {osource};
            return octx;
    }
    
    
     public class Mesures {

        public datetime dateMesure;
        public double mesures;


        public Mesures(datetime dateMesure, double mesures ){
                this.dateMesure = dateMesure;
                this.mesures = mesures;
        }
    }

}