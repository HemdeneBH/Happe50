public class VI_SM022_PrixEtRemises {
    
    public static VI_gdfsuezComBefChpCommunV3.contextDt initContext(String application, String version) {
        // Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
        VI_gdfsuezComBefChpCommunV3.system_element osource = new VI_gdfsuezComBefChpCommunV3.system_element();
        osource.systemId=application;
        VI_gdfsuezComBefChpCommunV3.contextDt octx = new VI_gdfsuezComBefChpCommunV3.contextDt();
        octx.version=version;
        octx.systemPath = new VI_gdfsuezComBefChpCommunV3.systemPath_element();
        octx.systemPath.system_x = new VI_gdfsuezComBefChpCommunV3.system_element[] {osource};
        octx.allowCache = false;
        return octx;
    }
    
    public static VI_gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort initPort(String NamedCredential) {
        VI_gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort port = new VI_gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort();
        //SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();
        //port.clientCertName_x = octopusCS.certName__c;
        port.endpoint_x = NamedCredential + '/ES-PrixEtRemises_v2'; //'callout:VI_AuthOctopus'
        port.inputHttpHeaders_x = new Map < String, String > {
            'Content-Type' => 'text/xml;charset=utf-8'
                };
                    return port;
    }
     
    //Create input prix et remises
    public static VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt createInputV2( String codeCommune,String codePostal, /*identifiantsLieuDt*/
                                                                                                   String idPack, 
                                                                                                   String idGroupeOffres, 
                                                                                                   String[] idOffre, 
         String typePrix,String versionUtilisation,String puissance,String typeComptage,String pourcentageOffreVerte,String structureMesureFournisseur,Integer CAEElec,Double CoefRepartition,String niveauOuvertureService, /*caracteristiquesOffreElecDt*/
                                                                                                   String plageConsommation,Integer CAEGaz,/*caracteristiquesOffreGazDt*/
                                                                                                   String[] caracteristique,/*caracteristiquesDiagnosticGazDt,caracteristiquesDiagnosticElecDt*/
                                                                                                   DateTime dateEffetContrat, 
                                                                                                   DateTime datePropositionCommerciale, 
                                                                                                   DateTime dateValiditePrix, 
                                                                                                   String enseigneSouscription, 
                                                                                                   String motifSouscriptionPropositionCommerciale, 
                                                                                                   String typeDonneesRemontees, 
                                                                                                   DateTime dateDerniereModificationFormuleTarifaireAcheminement,
                                                                                                   String formuleTarifaireAcheminement, 
                                                                                                   String contexteSouscription)
    {
        
        VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt input =new VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt();
        
        VI_gdfsuezBefCalypsoPrixetremisesV2.identifiantsLieuDt identifiantsLieu=genereridentifiantsLieu(codeCommune,codePostal);
        VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt caracteristiquesOffreElec=generercaracteristiquesOffreElecDt(typePrix,versionUtilisation,puissance,typeComptage,pourcentageOffreVerte,
                                                                                                                                                                         structureMesureFournisseur,CAEElec,CoefRepartition,niveauOuvertureService);
        VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt caracteristiquesOffreGaz=generetcaracteristiquesOffreGazDt(typePrix,plageConsommation,CAEGaz);
        VI_gdfsuezBefCalypsoPrixetremisesV2.listeCaracteristiquesDiagDt listeCaracteristiquesDiag=genererlisteCaracteristiquesDiagDt(caracteristique);
        VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesDiagnosticGazDt caracteristiquesDiagnosticGaz=generercaracteristiquesDiagnosticGazDt(listeCaracteristiquesDiag);
        VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesDiagnosticElecDt caracteristiquesDiagnosticElec=generercaracteristiquesDiagnosticElecDt(listeCaracteristiquesDiag);
        input=genererPrixEtRemisesInputDt(identifiantsLieu,idPack,idGroupeOffres,idOffre,caracteristiquesOffreElec,caracteristiquesOffreGaz/*null, null*/,null,null,/*,caracteristiquesDiagnosticGaz,caracteristiquesDiagnosticElec,*/
                                         dateEffetContrat,datePropositionCommerciale,dateValiditePrix,enseigneSouscription,motifSouscriptionPropositionCommerciale,typeDonneesRemontees,dateDerniereModificationFormuleTarifaireAcheminement
                                          ,formuleTarifaireAcheminement,contexteSouscription);
        XMLSerializer serializer1 = new XMLSerializer();
        String serializedXML1 = serializer1.serialize(input,true, null); 
        system.debug('serializedXML Input'+ serializedXML1);
        return input;
    }
    
    
    
    //Create Input Prix et Services
    public static VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesInputDt createInputPrixEtServices(String idOffre,
                                                                                                              DateTime datePropositionCommerciale,
                                                                                                              DateTime dateEffetContrat,
                                                                                                              String contexteSouscription,
                                                                                                              String TypeDeComptage, String puissance)
    {
        VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesInputDt input =new VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesInputDt();
        input.idOffre=idOffre;
        input.datePropositionCommerciale=datePropositionCommerciale;
        input.dateEffetContrat=dateEffetContrat;
        input.contexteSouscription=contexteSouscription;
        List<VI_gdfsuezBefCalypsoPrixetremisesV2.criteres_element> criteresElements = new List<VI_gdfsuezBefCalypsoPrixetremisesV2.criteres_element>();
        VI_gdfsuezBefCalypsoPrixetremisesV2.criteres_element critere1 = new VI_gdfsuezBefCalypsoPrixetremisesV2.criteres_element();
        critere1.parametre = 'ZZTYC';
        critere1.valeur = TypeDeComptage;
        VI_gdfsuezBefCalypsoPrixetremisesV2.criteres_element critere2 = new VI_gdfsuezBefCalypsoPrixetremisesV2.criteres_element();
        critere2.parametre = 'ZZPS';
        critere2.valeur = puissance;
        criteresElements.add(critere1);
        criteresElements.add(critere2);
        input.criteres=criteresElements;
        return input;
    }
    
    
    public static VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesInputDt createInputPrixEtServicesGaz(String idOffre,
                                                                                                              DateTime datePropositionCommerciale,
                                                                                                              DateTime dateEffetContrat,
                                                                                                              String contexteSouscription,
                                                                                                              String plageConso, String pourcentage)
    {
        VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesInputDt input =new VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesInputDt();
        input.idOffre=idOffre;
        input.datePropositionCommerciale=datePropositionCommerciale;
        input.dateEffetContrat=dateEffetContrat;
        input.contexteSouscription=contexteSouscription;
        List<VI_gdfsuezBefCalypsoPrixetremisesV2.criteres_element> criteresElements = new List<VI_gdfsuezBefCalypsoPrixetremisesV2.criteres_element>();
        VI_gdfsuezBefCalypsoPrixetremisesV2.criteres_element critere1 = new VI_gdfsuezBefCalypsoPrixetremisesV2.criteres_element();
        critere1.parametre = 'ZZCAE';
        critere1.valeur = plageConso;
        VI_gdfsuezBefCalypsoPrixetremisesV2.criteres_element critere2 = new VI_gdfsuezBefCalypsoPrixetremisesV2.criteres_element();
        critere2.parametre = 'ZZTAUX';
        critere2.valeur = pourcentage;
        criteresElements.add(critere1);
        criteresElements.add(critere2);
        input.criteres=criteresElements;
        return input;
    }
    //Appel webservice pour recuperer les infos concernant les prix et service
    public static VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesResponse_element recherchePrixetService(VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesInputDt input,
                                                                                                                    String NamedCredential, String application,String version)
    {
        VI_gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort port=initPort(NamedCredential);
        VI_gdfsuezComBefChpCommunV3.contextDt context= initContext(application,version);
        VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesResponse_element response;
        system.debug('input '+input);
        if(!Test.isRunningTest()){ 
            try{
            response=port.RechercherPrixServices(input,context);
            }
            catch(Exception e){
                System.debug('erreur : ' + e.getMessage());
                System.debug('erreur : ' + e.getStackTraceString());
                return null;
            }
        }
        else{
            Test.setMock(WebServiceMock.class, new VI_SM022_PrixEtRemises_Mock());
            VI_gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort porttest = new  VI_gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort();
            response = porttest.RechercherPrixServices(input, context);
        }
        system.debug('response '+response);
        return response;
    }
    
    
   
    
    //Appel webservice pour recuperer les infos concernant les prix et remise et service
   /* public static VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesServicesResponse_element recherchePrixRemiseService(VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesServicesInputDt[] input,
                                                                                                                    String NamedCredential, String application,String version)
    {
        VI_gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort port=initPort(NamedCredential);
        VI_gdfsuezComBefChpCommunV3.contextDt context= initContext(application,version);
        VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesServicesResponse_element response;
        system.debug('input '+input);
        if(!Test.isRunningTest()){ 
            try{
            response=port.RechercherPrixEtRemisesServices(input,context);
            }
            catch(Exception e){
                System.debug('erreur : ' + e.getMessage());
                System.debug('erreur : ' + e.getStackTraceString());
                return null;
            }
        }
        else{
            Test.setMock(HttpCalloutMock.class, new VI_SM020_EstimerElecConsommation_Mock());
            VI_gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort porttest = new  VI_gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort();
            response = porttest.RechercherPrixEtRemisesServices(input, context);
        }
        system.debug('response '+response);
        return response;
    }*/
    
    
    public static VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt generercaracteristiquesOffreElecDt(String typePrix,String versionUtilisation,String puissance,String typeComptage,String pourcentageOffreVerte,String structureMesureFournisseur,
                                                                                Integer CAEElec,Double CoefRepartition,String niveauOuvertureService){
                                                                                    VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt caracteristiquesOffreElec=new VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                                                                                    //caracteristiquesOffreElec.typePrix=prepareValues(typePrix);
                                                                                    //caracteristiquesOffreElec.versionUtilisation=prepareValues(versionUtilisation);
                                                                                    caracteristiquesOffreElec.puissance=prepareValues(puissance);
                                                                                    //caracteristiquesOffreElec.typeComptage=prepareValues(typeComptage);
                                                                                    caracteristiquesOffreElec.pourcentageOffreVerte=prepareValues(pourcentageOffreVerte);
                                                                                    caracteristiquesOffreElec.structureMesureFournisseur=prepareValues(structureMesureFournisseur);
                                                                                    caracteristiquesOffreElec.CAEElec=CAEElec;
                                                                                    //caracteristiquesOffreElec.CoefRepartition=CoefRepartition;
                                                                                    caracteristiquesOffreElec.niveauOuvertureService=niveauOuvertureService;
                                                                                    
                                                                                    return caracteristiquesOffreElec;
                                                                                }
    
    public static VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt generetcaracteristiquesOffreGazDt(String typePrix,String plageConsommation,Integer CAEGaz){
        VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt caracteristiquesOffreGaz=new VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt();
        caracteristiquesOffreGaz.typePrix=prepareValues(typePrix);
        caracteristiquesOffreGaz.plageConsommation=prepareValues(plageConsommation);
        caracteristiquesOffreGaz.CAEGaz=CAEGaz;
        system.debug('caracteristiquesOffreGaz'+ caracteristiquesOffreGaz);
        return caracteristiquesOffreGaz;
    }
    
    public static VI_gdfsuezComBefChpCommunV3.listeValeursDt prepareValues(String code){
		VI_gdfsuezComBefChpCommunV3.listeValeursDt listeValeurs=new VI_gdfsuezComBefChpCommunV3.listeValeursDt();
        listeValeurs.code=code;
        return listeValeurs;
    }
    
    public static VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt genererPrixEtRemisesInputDt( VI_gdfsuezBefCalypsoPrixetremisesV2.identifiantsLieuDt identifiantsLieu, String idPack, String idGroupeOffres, String[] idOffre, 
                                                                             VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt caracteristiquesOffreElec, VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt caracteristiquesOffreGaz, 
                                                                             VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesDiagnosticGazDt caracteristiquesDiagnosticGaz,
                                                                             VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesDiagnosticElecDt caracteristiquesDiagnosticElec, DateTime dateEffetContrat, DateTime datePropositionCommerciale, DateTime dateValiditePrix, 
                                                                             String enseigneSouscription, String motifSouscriptionPropositionCommerciale, 
                                                                             String typeDonneesRemontees, DateTime dateDerniereModificationFormuleTarifaireAcheminement, 
                                                                             String formuleTarifaireAcheminement, String contexteSouscription)
    {
        VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt rechercherPrixEtRemisesInput=new VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt();
        rechercherPrixEtRemisesInput.identifiantsLieu=identifiantsLieu;
        rechercherPrixEtRemisesInput.idPack=idPack;
        rechercherPrixEtRemisesInput.idGroupeOffres=prepareValues(idGroupeOffres);
        rechercherPrixEtRemisesInput.idOffre=idOffre;
        rechercherPrixEtRemisesInput.caracteristiquesOffreElec=caracteristiquesOffreElec;
        rechercherPrixEtRemisesInput.caracteristiquesOffreGaz=caracteristiquesOffreGaz;
        rechercherPrixEtRemisesInput.caracteristiquesDiagnosticGaz=caracteristiquesDiagnosticGaz;
        rechercherPrixEtRemisesInput.caracteristiquesDiagnosticElec=caracteristiquesDiagnosticElec;
        rechercherPrixEtRemisesInput.dateEffetContrat=dateEffetContrat;
        rechercherPrixEtRemisesInput.datePropositionCommerciale=datePropositionCommerciale;
        rechercherPrixEtRemisesInput.dateValiditePrix= dateValiditePrix;
        rechercherPrixEtRemisesInput.enseigneSouscription=prepareValues(enseigneSouscription);
        rechercherPrixEtRemisesInput.motifSouscriptionPropositionCommerciale=prepareValues(motifSouscriptionPropositionCommerciale); 
        rechercherPrixEtRemisesInput.typeDonneesRemontees=prepareValues(typeDonneesRemontees);
        rechercherPrixEtRemisesInput.dateDerniereModificationFormuleTarifaireAcheminement=dateDerniereModificationFormuleTarifaireAcheminement;
        rechercherPrixEtRemisesInput.formuleTarifaireAcheminement=prepareValues(formuleTarifaireAcheminement);
        rechercherPrixEtRemisesInput.contexteSouscription=prepareValues(contexteSouscription);
        
        return rechercherPrixEtRemisesInput;
    }
    
    
    
    
    public static VI_gdfsuezBefCalypsoPrixetremisesV2.identifiantsLieuDt genereridentifiantsLieu(String codeCommune,String codePostal){
        VI_gdfsuezBefCalypsoPrixetremisesV2.identifiantsLieuDt identifiantsLieu=new VI_gdfsuezBefCalypsoPrixetremisesV2.identifiantsLieuDt();
        identifiantsLieu.codeCommune=codeCommune;
        identifiantsLieu.codePostal=codePostal;
        return identifiantsLieu;
    }
    
    public static VI_gdfsuezBefCalypsoPrixetremisesV2.listeCaracteristiquesDiagDt genererlisteCaracteristiquesDiagDt(String[] caracteristique){
        VI_gdfsuezBefCalypsoPrixetremisesV2.listeCaracteristiquesDiagDt listeCaracteristiquesDiag=new VI_gdfsuezBefCalypsoPrixetremisesV2.listeCaracteristiquesDiagDt();
        listeCaracteristiquesDiag.caracteristique=prepareValuesList(caracteristique);
        return listeCaracteristiquesDiag;
    }
    
     public static VI_gdfsuezComBefChpCommunV3.listeValeursDt[] prepareValuesList(String[] listcode){
         List<VI_gdfsuezComBefChpCommunV3.listeValeursDt> listRetour=new List<VI_gdfsuezComBefChpCommunV3.listeValeursDt>();
         if(listcode!=null){
             for(String code:listCode){
                 VI_gdfsuezComBefChpCommunV3.listeValeursDt listeValeurs=new VI_gdfsuezComBefChpCommunV3.listeValeursDt();
                 listeValeurs.code=code;
                 system.debug(listRetour);
                 system.debug(listeValeurs);
                 listRetour.add(listeValeurs);
             }
         }
        return listRetour;
    }
    
    public static VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesDiagnosticGazDt generercaracteristiquesDiagnosticGazDt(VI_gdfsuezBefCalypsoPrixetremisesV2.listeCaracteristiquesDiagDt listeCaracteristiquesGaz){
        VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesDiagnosticGazDt caracteristiquesDiagnosticGaz=new VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesDiagnosticGazDt();
        caracteristiquesDiagnosticGaz.listeCaracteristiquesGaz=listeCaracteristiquesGaz;
        return caracteristiquesDiagnosticGaz;
    }
    
    public static VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesDiagnosticElecDt generercaracteristiquesDiagnosticElecDt(VI_gdfsuezBefCalypsoPrixetremisesV2.listeCaracteristiquesDiagDt listeCaracteristiquesElec){
        VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesDiagnosticElecDt caracteristiquesDiagnosticElec=new VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesDiagnosticElecDt();
        caracteristiquesDiagnosticElec.listeCaracteristiquesElec=listeCaracteristiquesElec;
        return caracteristiquesDiagnosticElec;
    }
    
   
//Appel webservice pour recuperer les infos concernant les prix et remise
    public static VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesResponse_element recherchePrixetRemise(List<VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt> input,
                                                                                                                    String NamedCredential, String application,String version)
    {
        VI_gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort port=initPort(NamedCredential);
        VI_gdfsuezComBefChpCommunV3.contextDt context= initContext(application,version);
        VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesResponse_element response;
        system.debug('input '+input);
        if(!Test.isRunningTest()){ 
            try{
            response=port.RechercherPrixEtRemises(input,context);
            }
            catch(Exception e){
                System.debug('erreur : ' + e.getMessage());
                System.debug('erreur : ' + e.getStackTraceString());
                return null;
            }
        }
        else{
            Test.setMock(WebServiceMock.class, new VI_SM022_PrixEtRemises_Mock());
            VI_gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort porttest = new  VI_gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort();
            response = porttest.RechercherPrixEtRemises(input, context);
        }
        system.debug('response '+response);
        return response;
    }     
/* 
//Create Input Prix Remises et Services
    public static VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesServicesInputDt createInputPrixEtServices(String codeCommune,String codePostal,String idPack,
                                                                                                                      String idGroupeOffres, 
                                                                                                                       String[] idOffre,
                                                                                                                      String typePrix,DateTime dateEffetContrat,
                                                                                                                       DateTime datePropositionCommerciale,
                                                                                                                       DateTime dateValiditePrix,
                                                                                                                      String enseigneSouscription,
                                                                                                                      String typeDonneesRemontees)
    {
        VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesServicesInputDt input =new VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesServicesInputDt();
        VI_gdfsuezBefCalypsoPrixetremisesV2.identifiantsLieuDt identifiantsLieu=genereridentifiantsLieu(codeCommune,codePostal);
        VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreServiceInDt caracteristiquesOffreService =generercaracteristiquesOffreServiceInDt(typePrix);
        input=genererPrixEtRemisesServicesInputDt(identifiantsLieu,
                                                  idPack,
                                                  idGroupeOffres,
                                                  idOffre,
                                                  caracteristiquesOffreService, 
                                                  dateEffetContrat,
                                                  datePropositionCommerciale,
                                                  dateValiditePrix,
                                                  enseigneSouscription,
                                                  typeDonneesRemontees);
        return input;
    }
    public static VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesServicesInputDt genererPrixEtRemisesServicesInputDt( VI_gdfsuezBefCalypsoPrixetremisesV2.identifiantsLieuDt identifiantsLieu,
                                                                                                                                 String idPack,
                                                                                                                                 String idGroupeOffres,
                                                                                                                                 String[] idOffre,
                                                                                                                                 VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreServiceInDt caracteristiquesOffreService,
                                                                                                                                 DateTime dateEffetContrat,
                                                                                                                                 DateTime datePropositionCommerciale,
                                                                                                                                 DateTime dateValiditePrix,
                                                                                                                                 String enseigneSouscription,
                                                                                                                                 String typeDonneesRemontees)
    {
        VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesServicesInputDt rechercherPrixEtRemisesServicesInput=new VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesServicesInputDt();
    	rechercherPrixEtRemisesServicesInput.identifiantsLieu=identifiantsLieu;
        rechercherPrixEtRemisesServicesInput.idPack=idPack;
        rechercherPrixEtRemisesServicesInput.idGroupeOffres=prepareValues(idGroupeOffres);
        rechercherPrixEtRemisesServicesInput.idOffre=idOffre;
        rechercherPrixEtRemisesServicesInput.caracteristiquesOffreService=caracteristiquesOffreService;
        rechercherPrixEtRemisesServicesInput.dateEffetContrat=dateEffetContrat;
        rechercherPrixEtRemisesServicesInput.datePropositionCommerciale=datePropositionCommerciale;
        rechercherPrixEtRemisesServicesInput.dateValiditePrix=dateValiditePrix;
        rechercherPrixEtRemisesServicesInput.enseigneSouscription=prepareValues(enseigneSouscription);
        rechercherPrixEtRemisesServicesInput.typeDonneesRemontees=prepareValues(typeDonneesRemontees); 
        return rechercherPrixEtRemisesServicesInput;
    }


public static VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreServiceInDt generercaracteristiquesOffreServiceInDt(String typePrix)
    {
        VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreServiceInDt caracteristiquesOffreService=new VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreServiceInDt();
        caracteristiquesOffreService.typePrix=prepareValues(typePrix);
        return caracteristiquesOffreService;
    }
    
    public static VI_gdfsuezBefCalypsoPrixetremisesV2.criteres_element generercritereselement(String parametre, String valeur){
        VI_gdfsuezBefCalypsoPrixetremisesV2.criteres_element critere= new VI_gdfsuezBefCalypsoPrixetremisesV2.criteres_element();
        critere.parametre=parametre;
        critere.valeur=valeur;
        return critere;
    }*/
    
}