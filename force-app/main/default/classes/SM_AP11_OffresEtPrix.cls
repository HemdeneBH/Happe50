/*@Author: RWA
*@Description: Récupération des valeurs du WS prix et remise et calcul des mens
*@CreatedDate:
*@LastModified: MHA 22/02/2019
*/
global class SM_AP11_OffresEtPrix implements vlocity_cmt.VlocityOpenInterface {
    /*@Author: RWA
*@Description: appel de la méthode
*@CreatedDate:
*@LastModified: RWA
*/
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        if (methodName.equals('getOffresEtPrix')) {
            try {
                System.debug('#### aka 15');
                getOffresEtPrix(inputMap, outMap);
            } catch (Exception e) {
                system.debug('@@ Erreur lors de la recuperation des prix dans lOS ' + e.getMessage());
                return false;
            }
        }
        return true;
    }
    
    /*@Author: RWA
*@Description: Récupération des valeurs du WS prix et remise et calcul des mens
*@CreatedDate:
*@LastModified: MHA 05/03/2019
*/
    public static void getOffresEtPrix(Map < String, Object > inputMap, Map < String, Object > outMap) {
        System.debug('#### aka here');
        /* recuperer le type denergie*/
        //  Map < String, Object > inputMapCE = (Map < String, Object >) inputMap.get('ChoixElements');
        String vEnergyTypeOptions = (String) inputMap.get('EnergyTypeOptions');
        system.debug('@@ input vEnergyTypeOptions ' + vEnergyTypeOptions);
        
        /* recuperer la date d'effet souhaitee */
        String vDateEffet = (String) inputMap.get('EffectiveDate');
        // String vdate= '2018-09-24T22:00:00.000Z';
        Date d = Date.ValueOf(vDateEffet.substring(0, 10));
        /*BUG DANS L'OS MEME SI LA DATE DEFFET AFFICHE j+1 DANS LE JSON LA VALEUR EST TOUJOURS A j
BUG REMONTE A JAMILA*/
        d = d.addDays(1);
        Datetime vDateEffetSouhaitee = Datetime.newInstanceGmt(d.year(), d.month(), d.day());
        system.debug('@@ vDateEffetSouhaitee ' + vDateEffetSouhaitee);
        /*system.debug('@@ now ' +system.now());

Datetime vDateEffetSouhaitee=Datetime.valueOf(vDateEffet);
//Datetime.valueOf('2018-07-03 00:00:00');
*/
        system.debug('@@ vDateEffetSouhaitee ' + vDateEffetSouhaitee);
        //system.debug('@@ vDateEffetSouhaitee now '+system.now());
        
        /* recuperer le  code postal et le code insee*/
        outMap.put('debug', vDateEffetSouhaitee);
        
        //Map < String, Object > inputMapCE1 = (Map < String, Object >) inputMap.get('ChoixElements1');
        System.Debug('inputMap: ' + inputMap);
        String vCodeInsee = String.valueOf(inputMap.get('citycodeValue') );
        String vCodePostal = String.valueOf(inputMap.get('postcodeValue'));
        
        system.debug('@@ input vCodeInsee ' + vCodeInsee);
        system.debug('@@ input vCodePostal ' + vCodePostal);
        
        //Récupération de la CAR et la CAE
        Double CAR = 0;
        Double CAE = 0;
        Double CAE_HC = 0;
        Double CAE_HP = 0;
        Double CAE_WE = 0;
        if (inputMap.get('CAR') != null && inputMap.get('CAR') != '') {
            CAR = Double.valueOf(inputMap.get('CAR'));
        }
        
        if (inputMap.get('CAE') != null && inputMap.get('CAE') != '') {
            CAE = Double.valueOf(inputMap.get('CAE'));
        }
        
        if (inputMap.get('CAE_HC') != null && inputMap.get('CAE_HC') != '') {
            CAE_HC = Double.valueOf(inputMap.get('CAE_HC'));
        }
        
        if (inputMap.get('CAE_HP') != null && inputMap.get('CAE_HP') != '') {
            CAE_HP = Double.valueOf(inputMap.get('CAE_HP'));
        }
        
        if (inputMap.get('CAE_WE') != null && inputMap.get('CAE_WE') != '') {
            CAE_WE = Double.valueOf(inputMap.get('CAE_WE'));
        }
        
        system.debug('CAR CAE ' + CAR + '/' + CAE);
        /*Recuperer les caracteristiques Gaz ou Elec*/
        String vPuissance = '';
        String vTypeComptage = '';
        String vCodePlageConso = '';
        System.debug('#### aka puissance ' + String.valueOf(inputMap.get('puissance')));
        if (vEnergyTypeOptions != 'Elec') {
            vCodePlageConso = String.valueOf(inputMap.get('codePlageConso'));
        }
        
        if (vEnergyTypeOptions != 'Gaz') {
            vPuissance = String.valueOf(inputMap.get('puissance'));
            //vTypeComptage = String.valueOf(inputMap.get('codeTypeComptage'));
        }
        
        system.debug('vCodePlageConso ' + vCodePlageConso);
        system.debug('vPuissance ' + vPuissance);
        system.debug('vTypeComptage ' + vTypeComptage);
        
        String niveauOuvertureService;
        String codeFTA;
        String lastModifFTA;
        String typedecompteur;
        system.debug('## inputMap.keyset '+inputMap.keySet());
        
        // system.debug('## inputMap.get pdlElecInfo '+inputMap.get('pdlElecInfo'));
        //  if(inputMap.get('pdlElecInfo') != null){
        //  map<String,Object> mapPdlInfos = (map<String,Object>)inputMap.get('pdlElecInfo');
        if(!String.isBlank(String.valueOf(inputMap.get('niveauOuvertureServices')))){
            niveauOuvertureService = String.valueOf(inputMap.get('niveauOuvertureServices'));
            
            if(niveauOuvertureService.contains('0')){
                niveauOuvertureService = '0';
            }
            if(niveauOuvertureService.contains('1')){
                niveauOuvertureService = '1';
            }
            if(niveauOuvertureService.contains('2')){
                niveauOuvertureService = '2';
            }
        }
        system.debug('### niveauOuvertureService out '+niveauOuvertureService);
        
        if(inputMap.get('dateDerniereModificationFormuleTarifaireAcheminement') != null){
            system.debug('## mapPdlInfos.get dateDerniereModificationFormuleTarifaireAcheminement'+inputMap.get('dateDerniereModificationFormuleTarifaireAcheminement'));
            lastModifFTA = (String) inputMap.get('dateDerniereModificationFormuleTarifaireAcheminement');
            //    lastModifFTA =  Datetime.ValueofGmt(dateTimeString.replace('T',' '));
        }
        
        system.debug('### lastModifFTA  '+lastModifFTA);
        system.debug('### lastModifFTA inputttt '+(String) inputMap.get('dateDerniereModificationFormuleTarifaireAcheminement'));
        
        if(inputMap.get('ftaCode') != null && inputMap.get('ftaCode') != 0){
            codeFTA = (String) inputMap.get('ftaCode');
        }
        
        if(inputMap.get('typeComptageDifferencie') != null){
            vTypeComptage = (String) inputMap.get('typeComptageDifferencie');
        }
        
        if(inputMap.get('typeCompteur') != null){
            typedecompteur = (String) inputMap.get('typeCompteur');
        }
        
        system.debug('### typeComptageDifferencie '+vTypeComptage);
        system.debug('### typedecompteur '+typedecompteur);
        system.debug('### codeFTA '+codeFTA);
        //  }
        
        String sellingOption;
        // system.debug('## inputMap.get choixelement '+inputMap.get('ChoixElements'));
        //  if(inputMap.get('ChoixElements') != null ){
        // map<String,Object> stepChoixElmts = (map<String,Object>)inputMap.get('ChoixElements');
        if(inputMap.get('chooseSellingOption') != null){
            sellingOption = String.valueOf(inputMap.get('chooseSellingOption'));
            if(sellingOption == 'Changement de fournisseur'){
                sellingOption = 'CHGT_FOURN';
            }else{
                sellingOption = 'MES_EMM';
            }
        }
        system.debug('### sellingOption '+sellingOption);
        // }
        
        list<SM_TranscoTypeComptageStrucMesFour__mdt> listTrascoTypeCompt = [select StructureMesureFournisseur__c from SM_TranscoTypeComptageStrucMesFour__mdt where TypeComptage__c =:vTypeComptage];
        list<String> listStrucMesFour = new list<String>();
        for(SM_TranscoTypeComptageStrucMesFour__mdt transco : listTrascoTypeCompt){
            listStrucMesFour.add(transco.StructureMesureFournisseur__c);
        }
        system.debug('## listStrucMesFour '+listStrucMesFour);
        System.debug('#### aka vEnergyTypeOptions ' + vEnergyTypeOptions);
        List<Product2> offres;
        if(listStrucMesFour.size() > 0){// Dual ou Elec
            
            offres = [SELECT id, FamilyLabel__c,SM_structureMesureFournisseur__c, Family, ProductCode, vlocity_cmt__SpecificationType__c, ArticleURL__c, ArticlePreview__c
                      FROM Product2
                      WHERE  vlocity_cmt__Type__c = : vEnergyTypeOptions AND IsActive = true AND SM_structureMesureFournisseur__c = :listStrucMesFour];
            
            if(vEnergyTypeOptions == 'Duo' && offres.size()>0){
                List<String> listProductFamily = new List<String>();
                for(Product2 offre : offres){
                    listProductFamily.add(offre.Family);
                }
                if(listProductFamily.size()>0){
                    offres = [SELECT id, FamilyLabel__c,SM_structureMesureFournisseur__c, Family, ProductCode, vlocity_cmt__SpecificationType__c, ArticleURL__c, ArticlePreview__c
                              FROM Product2
                              WHERE  vlocity_cmt__Type__c = : vEnergyTypeOptions
                              AND IsActive = true 
                              AND Family IN :listProductFamily
                              AND (SM_structureMesureFournisseur__c = :listStrucMesFour OR SM_structureMesureFournisseur__c = null)];
                }
                
                /* offres = [SELECT id, FamilyLabel__c,SM_structureMesureFournisseur__c, Family, ProductCode, vlocity_cmt__SpecificationType__c
FROM Product2
WHERE  vlocity_cmt__Type__c = : vEnergyTypeOptions AND IsActive = true AND (SM_structureMesureFournisseur__c = :listStrucMesFour OR SM_structureMesureFournisseur__c = null)];*/
            }
            
        }else{// Gaz il n'y a pas de structure mesure fournisseur
            System.debug('### aka 3');
            offres = [SELECT id, FamilyLabel__c,SM_structureMesureFournisseur__c, Family, ProductCode, vlocity_cmt__SpecificationType__c, ArticleURL__c, ArticlePreview__c
                      FROM Product2
                      WHERE  vlocity_cmt__Type__c = : vEnergyTypeOptions AND IsActive = true];
        }
        
        
        system.debug('offres from query ' + offres);
        system.debug('offres from query size ' + offres.size());
        if (offres.size() > 0) {
            Map<String, List<String>> mapPackOffres = new Map<String, List<String>>();
            Map<String, String> mapCodeOffresLibPack = new Map<String, String>();
            Map<String, Boolean> mapIsOffrePoussee = new Map<String, Boolean>();
            Map<String, String> mapProdFamStrucMesFourn = new Map<String,String>();
            Map<String, Article> mapArticle = new Map<String,Article>();
            
            for (Product2 offre : offres) {
                //if (checkEligibility(Offre.ProductCode,offre.Family,niveauOuvertureService,typedecompteur)) {
                    
                    if (mapPackOffres.get(offre.Family) != null) {
                        mapPackOffres.get(offre.Family).add(Offre.ProductCode);
                    } else {
                        mapPackOffres.put(offre.Family, new List<String> {Offre.ProductCode});
                    }
                    
                    mapCodeOffresLibPack.put(offre.ProductCode, offre.FamilyLabel__c);
                    if (offre.vlocity_cmt__SpecificationType__c == 'Offre poussée' ) {
                        mapIsOffrePoussee.put(offre.ProductCode, true);
                    } else {
                        mapIsOffrePoussee.put(offre.ProductCode, false);
                    }
                    if(Offre.SM_structureMesureFournisseur__c != null){
                       mapProdFamStrucMesFourn.put(offre.Family, Offre.SM_structureMesureFournisseur__c); 
                    }
                    Article article = new Article();
                    article.url = offre.ArticleURL__c;
                    article.preview = offre.ArticlePreview__c;
                    System.debug('JASG articleURL' + article.url );
                    mapArticle.put(offre.ProductCode, article);

                    System.debug('JASG mapArticle' + mapArticle);
                    
               // }
            }
            
            system.debug('## mapProdFamStrucMesFourn Key Set '+ mapPackOffres.keySet());
            system.debug('## mapProdFamStrucMesFourn '+ mapPackOffres);
            system.debug('## mapProdFamStrucMesFourn '+mapProdFamStrucMesFourn);
            
            List<String> listCodesOffres = new List<String>();
            listCodesOffres.addAll(mapCodeOffresLibPack.keySet());
            Map<String, Object> mapOffresEtPrix = new Map<String, Object>();
            
            system.debug('input get prix ' + vCodeInsee + '/' + vCodePostal + '/' + mapPackOffres + '/' + mapCodeOffresLibPack + '/' + mapIsOffrePoussee + '/' + vDateEffetSouhaitee + '/' + vCodePlageConso + '/' + vPuissance + '/' + vTypeComptage);
            List<PrixOffreConsolide> OffresEtPrix = getPrix(codeFTA,lastModifFTA,sellingOption, vCodeInsee, vCodePostal, mapPackOffres, mapCodeOffresLibPack, mapIsOffrePoussee,mapProdFamStrucMesFourn, vDateEffetSouhaitee, vCodePlageConso, vPuissance, vTypeComptage,niveauOuvertureService,CAR, CAE, CAE_HP, CAE_HC, CAE_WE,mapArticle);
            //  List<PrixOffreConsolide> OffresEtPrix = new List<PrixOffreConsolide>();
            system.debug('@@ OffresEtPrix retourné apres apple WS ' + OffresEtPrix);
            
            mapOffresEtPrix.put('OffreCatalogue', OffresEtPrix);
            
            system.debug('@@ mapOffresEtPrix retourné a lOS ' + mapOffresEtPrix);
            outMap.putAll(mapOffresEtPrix);
        }
    }
    
    /*@Author: RWA
*@Description: Récupération des valeurs du WS prix et remise et calcul des mens
*@CreatedDate:
*@LastModified: MHA 05/03/2019
*/
    public static List<PrixOffreConsolide> getPrix(String codeFTA,String lastModifFTA,String contSouscriptionCode,String codeCommune, String codePostal, Map<String, List<String>> mapPackOffres, Map<String, String> mapCodeOffresLibPack, Map<String, Boolean> mapIsOffrePoussee,Map<String,String> mapStrucmesfour,Datetime dateEffet, String plageconso, String vpuissance, String typeDeComptage,String niveauOuvertureService,Double CAR, Double CAE, Double CAE_HP, Double CAE_HC, Double CAE_WE, Map<String, Article> mapArticle) {
        
        SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();
        
        List<gdfsuezBefCalypsoPrixetremisesV1.rechercherPrixEtRemisesInputDt> listInput = new List<gdfsuezBefCalypsoPrixetremisesV1.rechercherPrixEtRemisesInputDt>();
        gdfsuezComBefChpCommunV3.contextDt octx = initContext(octopusCS.appName__c, '1.00');
        for (String pack : mapPackOffres.keyset()) {
            /*Contruction des parametres*/
            gdfsuezBefCalypsoPrixetremisesV1.rechercherPrixEtRemisesInputDt prixService = new gdfsuezBefCalypsoPrixetremisesV1.rechercherPrixEtRemisesInputDt();
            /*identifiantsLieuDt */
            gdfsuezBefCalypsoPrixetremisesV1.identifiantsLieuDt identifiantsLieu = new gdfsuezBefCalypsoPrixetremisesV1.identifiantsLieuDt();
            identifiantsLieu.codeCommune = codeCommune;
            identifiantsLieu.codePostal = codePostal;
            prixService.identifiantsLieu = identifiantsLieu;
            prixService.dateEffetContrat = dateEffet;
            //dateEffet;
            prixService.datePropositionCommerciale = System.now();
            //Datetime.valueOf('2018-07-03 00:00:00');
            //System.now();
            //prixService.dateValiditePrix = System.now();
            prixService.dateValiditePrix = dateEffet;
            //Datetime.valueOf('2018-07-03 00:00:00');
            prixService.idPack = pack;
            System.debug(' ### akakakaka mapPackOffres.get(pack) ' +  mapPackOffres.get(pack));
            prixService.idOffre = mapPackOffres.get(pack);
            System.debug(' ### akakakaka prixService.idOffre ' + prixService.idOffre);
            gdfsuezComBefChpCommunV3.listeValeursDt codeEnseigneSouscription = new gdfsuezComBefChpCommunV3.listeValeursDt();
            codeEnseigneSouscription.code = 'PPO';
            prixService.enseigneSouscription = codeEnseigneSouscription;
            
            gdfsuezComBefChpCommunV3.listeValeursDt contexteSouscription = new gdfsuezComBefChpCommunV3.listeValeursDt();
            contexteSouscription.code = contSouscriptionCode;
            prixService.contexteSouscription = contexteSouscription;
            
            /*Constution des caractistiques GAZ*/
            if (!String.isBlank(plageconso)) {
                gdfsuezBefCalypsoPrixetremisesV1.caracteristiquesOffreGazDt carGaz = new gdfsuezBefCalypsoPrixetremisesV1.caracteristiquesOffreGazDt();
                gdfsuezComBefChpCommunV3.listeValeursDt plageConsommation = new gdfsuezComBefChpCommunV3.listeValeursDt();
                plageConsommation.code = plageconso;
                carGaz.plageConsommation = plageConsommation;
                prixService.caracteristiquesOffreGaz = carGaz;
                
            }
            
            /*Constution des caractistiques ELEC*/
            if (!String.isBlank(vpuissance) || !String.isBlank(typeDeComptage)) {
                System.debug('#### contSouscriptionCode ' + contSouscriptionCode);
                if(contSouscriptionCode == 'CHGT_FOURN'){
                    prixService.dateDerniereModificationFormuleTarifaireAcheminement = lastModifFTA;                
                    gdfsuezComBefChpCommunV3.listeValeursDt formuleTarifaireAcheminement = new gdfsuezComBefChpCommunV3.listeValeursDt();
                    formuleTarifaireAcheminement.code = codeFTA;
                    prixService.formuleTarifaireAcheminement = formuleTarifaireAcheminement; 
                }
                
                gdfsuezBefCalypsoPrixetremisesV1.caracteristiquesOffreElecDt carElec = new gdfsuezBefCalypsoPrixetremisesV1.caracteristiquesOffreElecDt();
                if (!String.isBlank(vpuissance) ) {
                    gdfsuezComBefChpCommunV3.listeValeursDt puissanceV = new gdfsuezComBefChpCommunV3.listeValeursDt();
                    puissanceV.code = vpuissance;
                    carElec.puissance = puissanceV;
                }
                /*if (!String.isBlank(typeDeComptage) ) {
gdfsuezComBefChpCommunV3.listeValeursDt typeComptageV = new gdfsuezComBefChpCommunV3.listeValeursDt();
typeComptageV.code = typeDeComptage;
carElec.typeComptage = typeComptageV;

system.debug('typeComptageV' + typeComptageV);

}*/
                system.debug('## pack '+pack);
                if(mapStrucmesfour.get(pack) != null){
                    gdfsuezComBefChpCommunV3.listeValeursDt structureMesureFournisseur = new gdfsuezComBefChpCommunV3.listeValeursDt();
                    structureMesureFournisseur.code = mapStrucmesfour.get(pack);
                    carElec.structureMesureFournisseur = structureMesureFournisseur;
                }
                if(CAE != null && CAE != 0){
                    carElec.CAEElec = CAE.intValue();
                }
                system.debug('## niveauOuvertureService '+niveauOuvertureService);
                if(niveauOuvertureService != null && niveauOuvertureService != ''){
                    carElec.niveauOuvertureService = niveauOuvertureService;
                }
                prixService.caracteristiquesOffreElec = carElec;
            }
            
            listInput.add(prixService);
        }
        system.debug('@@ liste des inputs size ' + listInput.size());
        system.debug('@@ liste des inputs ' + listInput);
        gdfsuezBefCalypsoPrixetremisesV1.PrixEtRemisesPort prixRemiseService = new gdfsuezBefCalypsoPrixetremisesV1.PrixEtRemisesPort();
        prixRemiseService.clientCertName_x = octopusCS.certName__c;
        prixRemiseService.timeout_x = 30000;
        //prixRemiseService.endpoint_x = 'https://ensz18a1rn6k.x.pipedream.net/';
        prixRemiseService.endpoint_x = octopusCS.endpoint__c + 'E-PrixEtRemises_v1';
        system.debug('endpoint ' +  prixRemiseService.endpoint_x);
        prixRemiseService.inputHttpHeaders_x = new Map<String, String> {'Content-Type' => 'text/xml;charset=utf-8'};
            
            gdfsuezBefCalypsoPrixetremisesV1.rechercherPrixEtRemisesResponse_element response = new gdfsuezBefCalypsoPrixetremisesV1.rechercherPrixEtRemisesResponse_element();
        system.debug('@@ response ' + JSON.serialize(response));
        System.debug('### listInput '+ JSON.serialize(listInput));
        if (!Test.isRunningTest()) {
            response = prixRemiseService.RechercherPrixEtRemises(listInput, octx);
            system.debug('@@ response AKAAA ' + JSON.serialize(response));
        } else {
            Test.setMock(WebServiceMock.class, new gdfsuezBefCalypsoPrixetremisesV1MockImpl());
            gdfsuezBefCalypsoPrixetremisesV1.PrixEtRemisesPort testObject = new gdfsuezBefCalypsoPrixetremisesV1.PrixEtRemisesPort();
            system.debug('@@ start of mock');
            response = testObject.RechercherPrixEtRemises(listInput, octx);
            system.debug('@@ end of mock');
        }
        
        List<PrixOffreConsolide> listOffreAvecPrix = new  List<PrixOffreConsolide>();
        Map<String, PrixOffreConsolide> mapLibelleParPix = new Map<String, PrixOffreConsolide>();
        
        if (response != null && response.messageRetours != null && response.messageRetours.messageRetour != null ) {
            for (gdfsuezComBefChpCommunV3.messageRetour_element msgRetour : response.messageRetours.messageRetour) {
                if ('ERREUR'.equalsIgnoreCase(msgRetour.type_x)) {
                    system.debug('@@ erreur lors de la recuperations des prix code erreur ' + msgRetour.code);
                    system.debug('@@ erreur lors de la recuperations des prix libelle erreur ' + msgRetour.libelle);
                    /*return null;*/
                }
            }
        }
        
        gdfsuezBefCalypsoPrixetremisesV1.rechercherPrixEtRemisesOutputDt[] rechercherPrixEtRemisesOutput = response.rechercherPrixEtRemisesOutput;
        
        for (gdfsuezBefCalypsoPrixetremisesV1.rechercherPrixEtRemisesOutputDt donneesRetour : rechercherPrixEtRemisesOutput) {
            String packId;
            if (donneesRetour != null && donneesRetour.donneesPack != null && donneesRetour.donneesPack.idPack != null) {
                packId = donneesRetour.donneesPack.idPack;
            }
            if (donneesRetour != null && donneesRetour.donneesOffre != null) {
                gdfsuezBefCalypsoPrixetremisesV1.donneesOffreDt[] donneesOffre = donneesRetour.donneesOffre;
                for (gdfsuezBefCalypsoPrixetremisesV1.donneesOffreDt data : donneesOffre) {
                    gdfsuezBefCalypsoPrixetremisesV1.listePrixDt listePrix = data.listePrix;
                    if (listePrix != null) {
                        System.debug('@MHA listePrix:' + listePrix);
                        /*String jsonOut = JSON.serialize(listePrix);
system.debug('@@ json ' + jsonOut);*/
                        String libellePackDeLOffre = mapCodeOffresLibPack.get(data.idOffre);
                        Boolean isOffrePoussee = mapIsOffrePoussee.get(data.idOffre);
                        
                        Article article = mapArticle.get(data.idOffre);

                        Map<String, Map<String, Double>> mapConsoByTypeComptage = new Map<String, Map<String, Double>>();
                        Map<String, Map<String, Double>> mapConsoGazByTypeComptage = new Map<String, Map<String, Double>>();
                        wrapperPrix prixElec = new wrapperPrix('Elec', Double.valueOf('0'), Double.valueOf('0'), mapConsoByTypeComptage, mapIsOffrePoussee.get(data.idOffre));
                        wrapperPrix prixGaz = new wrapperPrix('Gaz', Double.valueOf('0'), Double.valueOf('0'), mapConsoGazByTypeComptage, mapIsOffrePoussee.get(data.idOffre));
                        
                        for (gdfsuezBefCalypsoPrixetremisesV1.prixDt prix : listePrix.prix) {
                            /*Si l'offre contioent des caracteristique GAZ je recupere les prix de l'ABO et de la CONS*/
                            if (prix.caracteristiquesGaz != null && prix.caracteristiquesGaz.typePrix != null
                                && prix.caracteristiquesGaz.plageconsommation != null
                                && (prix.caracteristiquesGaz.typePrix.code == 'AB' || prix.caracteristiquesGaz.typePrix.code == 'CO')) {
                                    Double montantHT = prix.montantHT;
                                    Double montantTTC = prix.montantTTC;
                                    if (prix.caracteristiquesGaz.typePrix.code == 'AB') {
                                        prixGaz.AboTTC = montantTTC;
                                        prixGaz.AboHT = montantHT;
                                        
                                    }
                                    
                                    if (prix.caracteristiquesGaz.typePrix.code == 'CO') {
                                        // consoGaz=String.valueOf(Decimal.valueOf(montantTTC).setscale(2))+ ' €/kWh TTC ('+String.valueOf(Decimal.valueOf(montantHT).setscale(5))+' HT)';
                                        Map<String, Double> montants = new Map<String, Double>();
                                        montants.put('TTC', montantTTC);
                                        montants.put('HT', montantHT);
                                        mapConsoGazByTypeComptage.put('consoGaz', montants);
                                        prixGaz.mapConsoByType = mapConsoGazByTypeComptage;
                                    }
                                }
                            
                            /*Si l'offre contient des caracteristique ELEC je recupere les prix de l'ABO et de la CONS*/
                            if (prix.caracteristiquesElec != null && prix.caracteristiquesElec.typePrix != null
                                && prix.caracteristiquesElec.puissance != null && prix.caracteristiquesElec.typeComptage != null
                                && (prix.caracteristiquesElec.typePrix.code == 'AB' || prix.caracteristiquesElec.typePrix.code == 'CO')) {
                                    Double montantHT = prix.montantHT;
                                    Double montantTTC = prix.montantTTC;
                                    if (prix.caracteristiquesElec.typePrix.code == 'AB') {
                                        //aboElec=String.valueOf(Decimal.valueOf(montantTTC).setscale(2))+ ' €/an TTC ('+String.valueOf(Decimal.valueOf(montantHT).setscale(2))+' HT)';
                                        prixElec.AboTTC = montantTTC;
                                        prixElec.AboHT = montantHT;
                                    }
                                    
                                    if (prix.caracteristiquesElec.typePrix.code == 'CO'
                                        && prix.caracteristiquesElec.typeComptage != null
                                        && !mapConsoByTypeComptage.keyset().contains(prix.caracteristiquesElec.typeComptage.libelleCourt)) {
                                            Map<String, Double> montants = new Map<String, Double>();
                                            montants.put('TTC', montantTTC);
                                            montants.put('HT', montantHT);
                                            mapConsoByTypeComptage.put(prix.caracteristiquesElec.typeComptage.code, montants);
                                            // consoElec=String.valueOf(Decimal.valueOf(montantTTC).setscale(2))+ ' €/kWh TTC ('+String.valueOf(Decimal.valueOf(montantHT).setscale(5))+' HT)';
                                            prixElec.mapConsoByType = mapConsoByTypeComptage;
                                        }
                                    
                                }
                        }
                        
                        System.debug('@@ offre ' + libellePackDeLOffre + ' existe ?' + mapLibelleParPix.get(libellePackDeLOffre));
                        
                        if (mapLibelleParPix.get(libellePackDeLOffre) == null) {
                            PrixOffreConsolide offreValue = new PrixOffreConsolide(libellePackDeLOffre,
                                                                                   data.idOffre,
                                                                                   isOffrePoussee,
                                                                                   packId,
                                                                                   mapPackOffres.get(packId),
                                                                                   prixELec,
                                                                                   prixGaz,
                                                                                   CAR,
                                                                                   CAE,
                                                                                   CAE_HP,
                                                                                   CAE_HC,
                                                                                   CAE_WE,
                                                                                   article);
                            
                            Double mensValue = 0;
                            Double mensGazValue = 0;
                            if (!string.isBlank(offreValue.mens)) {
                                mensValue = Double.valueOf(offreValue.mens);
                            }
                            
                            if (!string.isBlank(offreValue.mensGaz)) {
                                mensGazValue = Double.valueOf(offreValue.mensGaz);
                            }
                            
                            offreValue.mensTotal = String.valueOf(mensValue + mensGazValue);
                            mapLibelleParPix.put(libellePackDeLOffre, offreValue );
                        } else {
                            PrixOffreConsolide offreNouveauInit = new PrixOffreConsolide(libellePackDeLOffre,
                                                                                         data.idOffre,
                                                                                         isOffrePoussee,
                                                                                         packId,
                                                                                         mapPackOffres.get(packId),
                                                                                         prixELec,
                                                                                         prixGaz,
                                                                                         CAR,
                                                                                         CAE,
                                                                                         CAE_HP,
                                                                                         CAE_HC,
                                                                                         CAE_WE,
                                                                                         article)  ;
                            /*System.debug('###TestMHA'+offreNouveauInit);*/
                            PrixOffreConsolide offreExistant = mapLibelleParPix.get(libellePackDeLOffre);
                            offreExistant.codeOffre = offreExistant.codeOffre + data.idOffre;
                            offreExistant.isOffrePoussee = offreExistant.isOffrePoussee ? true : isOffrePoussee;
                            /*  offreExistant.aboElec=offreExistant.aboElec==null?offreNouveauInit.aboElec:offreExistant.aboElec;
offreExistant.mapConsoByTypeComptage=offreExistant.aboElec==null?offreNouveauInit.mapConsoByTypeComptage:offreExistant.mapConsoByTypeComptage;
offreExistant.mens=offreExistant.mens==null?offreNouveauInit.mens:offreExistant.mens;*/
                            Double mensValue = 0;
                            Double mensGazValue = 0;
                            System.debug('@MHA offreExistant' + offreExistant);
                            if (offreExistant.aboElec == null) {
                                offreExistant.aboElec = offreNouveauInit.aboElec;
                                offreExistant.mapConsoByTypeComptage = offreNouveauInit.mapConsoByTypeComptage;
                                offreExistant.mens = offreNouveauInit.mens;
                                system.debug('@MHA offreExistant.mens:' + offreExistant.mens);
                                if (offreExistant.mens == null) {
                                    mensValue = 0;
                                } else {
                                    mensValue = Double.valueOf(offreExistant.mens);
                                }
                                
                                System.debug('@MHA test' + mensValue);
                            }
                            
                            if (offreExistant.aboGaz == null) {
                                offreExistant.mapConsoGazByTypeComptage = offreNouveauInit.mapConsoGazByTypeComptage;
                                offreExistant.aboGaz = offreNouveauInit.aboGaz;
                                offreExistant.mensGaz = offreNouveauInit.mensGaz;
                                system.debug('@MHA offreExistant.mensGaz:' + offreExistant.mensGaz);
                                if (offreExistant.mensGaz == null) {
                                    mensGazValue = 0;
                                } else {
                                    mensGazValue = Double.valueOf(offreExistant.mensGaz);
                                }
                                System.debug('@MHA test Gaz' + mensGazValue);
                            }
                            
                            System.debug('@MHA offreExistant test2' + offreExistant);
                            if (offreExistant.mens != null && offreExistant.mensGaz != null) {
                                offreExistant.mensTotal = String.valueOf(Double.valueOf(offreExistant.mens) + Double.valueOf(offreExistant.mensGaz));
                            } else if (offreExistant.mens != null && offreExistant.mensGaz == null) {
                                offreExistant.mensTotal = String.valueOf(Double.valueOf(offreExistant.mens));
                            } else if (offreExistant.mens == null && offreExistant.mensGaz != null) {
                                offreExistant.mensTotal = String.valueOf(Double.valueOf(offreExistant.mensGaz));
                            } else {
                                offreExistant.mensTotal = String.valueOf(0);
                            }
                            
                            mapLibelleParPix.put(libellePackDeLOffre, offreExistant );
                            System.debug('###TestMHA' + offreExistant);
                            /*offreExistant.mapConsoGazByTypeComptage=offreExistant.aboGaz==null?offreNouveauInit.mapConsoGazByTypeComptage:offreExistant.mapConsoGazByTypeComptage;
offreExistant.aboGaz=offreExistant.aboGaz==null?offreNouveauInit.aboGaz:offreExistant.aboGaz;
offreExistant.mensGaz=offreExistant.mensGaz==null?offreNouveauInit.mensGaz:offreExistant.mensGaz;*/
                        }
                    }
                }
            }
        }
        
        listOffreAvecPrix.addAll(mapLibelleParPix.values());
        system.debug('@@ listOffreAvecPrix final ' + listOffreAvecPrix);
        for (PrixOffreConsolide offreAffiche : listOffreAvecPrix) {
            if (offreAffiche.mens != null && offreAffiche.mensGaz != null) {
                /*offreAffiche.mens = String.ValueOf(Decimal.valueOf(offreAffiche.mens) + Decimal.valueOf(offreAffiche.mensGaz)) + ' €/mois';*/
                offreAffiche.mensTotal = String.ValueOf(Decimal.valueOf(offreAffiche.mens) + Decimal.valueOf(offreAffiche.mensGaz));
                offreAffiche.mens = String.ValueOf(Decimal.valueOf(offreAffiche.mens)) + ' €/mois';
                offreAffiche.mensGaz = String.ValueOf(Decimal.valueOf(offreAffiche.mensGaz)) + ' €/mois';
            } else {
                if (offreAffiche.mens != null) {
                    offreAffiche.mens = offreAffiche.mens + ' €/mois';
                }
                
                if (offreAffiche.mensGaz != null) {
                    offreAffiche.mensGaz = offreAffiche.mensGaz + ' €/mois';
                }
                
            }
            
        }
        
        system.debug('@@@ mapOffrePrix json ' + JSON.serialize(listOffreAvecPrix));
        return listOffreAvecPrix;
    }
    
    /*@Author: RWA
*@Description: model du wrapper
*@CreatedDate:
*@LastModified: RWA
*/
    public class wrapperPrix {
        public String typeEnergie;
        public Double AboTTC;
        public Double AboHT;
        public Map<String, Map<String, Double>> mapConsoByType;
        Boolean isOffrePousse;
        
        /*@Author: RWA
*@Description: constructeur du wrapper
*@CreatedDate:
*@LastModified: MHA 22/02/2019
*/
        public wrapperPrix(String typeEnergie, Double AboTTC, Double AboHT, Map<String, Map<String, Double>>  mapConsoByType, Boolean isOffrePousse) {
            this.typeEnergie = typeEnergie;
            this.AboTTC = AboTTC;
            this.AboHT = AboHT;
            this.mapConsoByType = mapConsoByType;
            this.isOffrePousse = isOffrePousse;
        }
    }
    
    /* @Author: Joel
*@Description : vérifier l'éligilité à une offre

*/
  /*  public static Boolean checkEligibility(String codeOffre,String codePackage,String niveauOuvertureService,String typePdl){
        Boolean resultEligibility = false;
        list<OffresConditionnel__mdt> listOffresConditionne = [select CodeOffre__c,CodePackage__c,NiveauOuvertureService__c,TypePdl__c from OffresConditionnel__mdt where 
                                                               CodeOffre__c =:codeOffre and CodePackage__c =:codePackage];
        
        if (listOffresConditionne.size() > 0) {
            for (OffresConditionnel__mdt offreConditionnel : listOffresConditionne) {
                if (offreConditionnel.NiveauOuvertureService__c == niveauOuvertureService && offreConditionnel.TypePdl__c == typePdl) {
                    resultEligibility = true;
                } 
            }   
        }else {
            resultEligibility = true;
        }
        system.debug('### resultEligibility '+resultEligibility+' codeOffre '+codeOffre+' codePackage '+codePackage);
        
        return resultEligibility;
    } */
    
    /*@Author: RWA
*@Description: model des offres consolidées
*@CreatedDate:
*@LastModified: MHA 05/03/2019
*/
    public class PrixOffreConsolide {
        public String libelleOffre;
        public String codeOffre;
        public String idPack;
        public List<String> idOffreList;
        public String aboElec;
        public Map<String, String> mapConsoByTypeComptage = new Map<String, String>();
        public String mens;
        public String aboGaz;
        public Map<String, String> mapConsoGazByTypeComptage = new Map<String, String>();
        public String mensGaz;
        public String mensTotal;
        public Boolean isOffrePoussee;
        public Double CAR;
        public Double CAE;
        public Double CAE_HP;
        public Double CAE_HC;
        public Double CAE_WE;
        public String articleURL;
        public String articlePreview;
        
        
        /*@Author: RWA
*@Description: constructeur des offres consolidées
*@CreatedDate:
*@LastModified: MHA 06/03/2019
*/
        public PrixOffreConsolide(String libelleOffre, String codeOffre, Boolean isOffrePoussee, String idPack, List<String> idOffreList,
                                  wrapperPrix prixELec, wrapperPrix prixGaz, Double CAR, Double CAE, Double CAE_HP, Double CAE_HC, Double CAE_WE, Article article) {
                                      this.codeOffre = codeOffre;
                                      this.libelleOffre = libelleOffre;
                                      this.isOffrePoussee = isOffrePoussee;
                                      this.idPack = idPack;
                                      this.idOffreList = idOffreList;
                                      this.CAR = CAR;
                                      this.CAE = CAE;
                                      this.articleURL = article.url;
                                      this.articlePreview = article.preview;
                                      system.debug('@@ prixELec ' + prixELec);
                                      system.debug('@@ prixGaz ' + prixGaz);
                                      if (Double.valueOf('0') == prixELec.AboTTC) {
                                          this.aboElec = null;
                                          this.mens = null;
                                      } else {
                                          this.aboElec = String.valueOf(Decimal.valueOf(prixELec.AboTTC).setscale(2)) + ' € TTC (' + String.valueOf(Decimal.valueOf(prixELec.AboHT).setscale(2)) + ' HT)';
                                          Map<String, Map<String, Double>> mapConsoByType = prixELec.mapConsoByType;
                                          List<Double> listConsoTTC = new List<Double>();
                                          for (String consLabel : mapConsoByType.keySet()) {
                                              Map<String, Double> montants = mapConsoByType.get(consLabel);
                                              String consValue = String.valueOf(Decimal.valueOf(montants.get('TTC')).setscale(5)) + ' €/kWh TTC (' + String.valueOf(Decimal.valueOf(montants.get('HT')).setscale(5)) + ' HT)';
                                              String consolLabelTransc;
                                              if (consLabel == 'P') {
                                                  consolLabelTransc = 'HP';
                                                  consLabel = 'P';
                                                  listConsoTTC.add(calculConsommation(montants.get('TTC'),CAE_HP));
                                              } else if (consLabel == 'C') {
                                                  consolLabelTransc = 'HC';
                                                  consLabel = 'C';
                                                  listConsoTTC.add(calculConsommation(montants.get('TTC'),CAE_HC));
                                              } else if(consLabel == 'WE'){
                                                  consolLabelTransc = consLabel;
                                                  consLabel = 'WE';
                                                  listConsoTTC.add(calculConsommation(montants.get('TTC'),CAE_WE));
                                              }else{
                                                  consolLabelTransc = consLabel;
                                                  listConsoTTC.add(calculConsommation(montants.get('TTC'),CAE));
                                              }
                                              System.debug('MHA libelle conso:'+consolLabelTransc);
                                              System.debug('MHA conso:'+listConsoTTC);
                                              mapConsoByTypeComptage.put(consolLabelTransc, consolLabelTransc + ':' + consValue);
                                              /*listConsoTTC.add(montants.get('TTC'));*/
                                          }
                                          
                                          System.debug('@MHA listConso' + listConsoTTC);
                                          this.mens = String.ValueOf(calculMens( Double.valueOf(prixELec.AboTTC), listConsoTTC, this.CAE));
                                          System.debug('@MHA Mens Elec:' + this.mens);
                                          //+ ' €/mois'
                                      }
                                      
                                      if (Double.valueOf('0') == prixGaz.AboTTC) {
                                          this.aboGaz = null;
                                          this.mensGaz = null;
                                      } else {
                                          this.aboGaz = String.valueOf(Decimal.valueOf(prixGaz.AboTTC).setscale(2)) + ' € TTC (' + String.valueOf(Decimal.valueOf(prixGaz.AboHT).setscale(2)) + ' HT)';
                                          Map<String, Map<String, Double>> mapConsoByTypeGAz = prixGaz.mapConsoByType;
                                          List<Double> listConsoTTCGaz = new List<Double>();
                                          for (String consLabel : mapConsoByTypeGAz.keySet()) {
                                              Map<String, Double> montants = mapConsoByTypeGAz.get(consLabel);
                                              String consValueGaz = String.valueOf(Decimal.valueOf(montants.get('TTC')).setscale(5)) + ' €/kWh TTC (' + String.valueOf(Decimal.valueOf(montants.get('HT')).setscale(5)) + ' HT)';
                                              mapConsoGazByTypeComptage.put(consLabel, consValueGaz);
                                              listConsoTTCGaz.add(calculConsommation(montants.get('TTC'),CAR));
                                          }
                                          
                                          System.debug('@MHA listConso' + listConsoTTCGaz);
                                          this.mensGaz = String.ValueOf(calculMens( Double.valueOf(prixGaz.AboTTC), listConsoTTCGaz, this.CAR));
                                          System.debug('@MHA Mens Gaz:' + this.mensGaz);
                                          
                                      }
                                      
                                      double mensValue = 0;
                                      double mensGazValue = 0;
                                      if (this.mens != null) {
                                          mensValue = Double.valueOf(this.mens);
                                      }
                                      
                                      if (this.mensGaz != null) {
                                          mensGazValue = Double.valueOf(this.mensGaz);
                                      }
                                      
                                      this.mensTotal = String.valueOf(mensValue + mensGazValue);
                                      system.debug('@MHA mensTotal' + this.mensTotal);
                                  }
    }
    
    /*@Author: RWA
*@Description: initialisation du contexte
*@CreatedDate:
*@LastModified: MHA 22/02/2019
*/
    public static gdfsuezComBefChpCommunV3.contextDt initContext(String application, String version) {
        // Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
        gdfsuezComBefChpCommunV3.system_element osource = new gdfsuezComBefChpCommunV3.system_element();
        osource.systemId = application;
        gdfsuezComBefChpCommunV3.contextDt octx = new gdfsuezComBefChpCommunV3.contextDt();
        octx.version = version;
        octx.systemPath = new gdfsuezComBefChpCommunV3.systemPath_element();
        octx.systemPath.system_x = new gdfsuezComBefChpCommunV3.system_element[] {osource};
            //octx.systemPath.system_x.add(osource);
            
            return octx;
    }
    
    /*@Author: RWA
*@Description: calcul de la mens
*@CreatedDate:
*@LastModified: MHA 05/03/2019
*/
    public static Decimal calculMens(Double Abo, List<Double> mapConsoByCAECAR, Double CAECAR) {
        system.debug('@@ Abo' + Abo);
        system.debug('@@ mapConsoByCAECAR' + mapConsoByCAECAR);
        system.debug('@@ CAECAR' + CAECAR);
        
        Double mens;
        Double estimationConsTotal = 0;
        
        for (Double estimationCons : mapConsoByCAECAR) {
            //estimationConsTotal = estimationConsTotal + (estimationCons * CAECAR);
            estimationConsTotal = estimationConsTotal + estimationCons;
        }
        system.debug('estimationConsTotal' + estimationConsTotal);
        mens = (Abo + estimationConsTotal) / 11;
        system.debug('mens' + mens);
        Decimal mensCalcule = Decimal.valueOf(mens).setscale(0);
        system.debug('mensCalcule' + mensCalcule);
        return mensCalcule;
    }
    
    /*@Author: MHA
*@Description: calcul Consommation
*@CreatedDate: 05/03/2019
*@LastModified: MHA 05/03/2019
*/
    public static Decimal calculConsommation(Double consoByCAECAR, Double CARCAE) {
        Double consoByCAECARResult = 0;
        consoByCAECARResult = consoByCAECAR * CARCAE;
        return consoByCAECARResult;
    }
    
    public class Article {
        public String url;
        public String preview;
    }
}