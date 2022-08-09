/*@Author: RWA
*@Description: Récupération des valeurs du WS prix et remise et calcul des mens
*@CreatedDate:
*@LastModified: RJM 17/04/2020
*/
global class SM_AP11_OffresEtPrix implements vlocity_cmt.VlocityOpenInterface {
    /*@Author: RWA
*@Description: appel de la méthode
*@CreatedDate:
*@LastModified: RWA
*/
    public static final MAP<String,String> typeOfProduct = new MAP<String,String>();
    public static PrixOffreConsolide  OffreChoisie = null;
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        if (methodName.equals('getOffresEtPrix')) {
            try {
                getOffresEtPrix(inputMap, outMap);
           } catch (Exception e) {
               system.debug('Exception Message = '+e.getMessage()+' Trace = '+e.getStackTraceString());
               return false;
           }
        }
        return true;
    }
    /*@Author: RWA
*@Description: Récupération des valeurs du WS prix et remise et calcul des mens
*@CreatedDate:
*@LastModified: RJM 17/04/2020
*/
    public static void getOffresEtPrix(Map < String, Object > inputMap, Map < String, Object > outMap) {
        /* recuperer le type denergie*/
        //  Map < String, Object > inputMapCE = (Map < String, Object >) inputMap.get('ChoixElements');
        String vEnergyTypeOptions = (String) inputMap.get('EnergyTypeOptions');
        /* recuperer la date d'effet souhaitee */
        String vDateEffet = (String) inputMap.get('EffectiveDate');
        outMap.put('debug', '123'+vDateEffet);
        // String vdate= '2018-09-24T22:00:00.000Z';
        Date d = Date.ValueOf(vDateEffet.substring(0, 10));
        /*BUG DANS L'OS MEME SI LA DATE DEFFET AFFICHE j+1 DANS LE JSON LA VALEUR EST TOUJOURS A j
BUG REMONTE A JAMILA*/
        d = d.addDays(1);
        Datetime vDateEffetSouhaitee = Datetime.newInstanceGmt(d.year(), d.month(), d.day());
        /*system.debug('@@ now ' +system.now());
Datetime vDateEffetSouhaitee=Datetime.valueOf(vDateEffet);
//Datetime.valueOf('2018-07-03 00:00:00');
*/
        //system.debug('@@ vDateEffetSouhaitee now '+system.now());
        /* recuperer le  code postal et le code insee*/
        //Map < String, Object > inputMapCE1 = (Map < String, Object >) inputMap.get('ChoixElements1');
        String vCodeInsee = String.valueOf(inputMap.get('citycodeValue') );
        String vCodePostal = String.valueOf(inputMap.get('postcodeValue'));

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
        /*Recuperer les caracteristiques Gaz ou Elec*/
        String vPuissance = '';
        String vTypeComptage = '';
        String vCodePlageConso = '';
        if (vEnergyTypeOptions != 'Elec') {
            vCodePlageConso = String.valueOf(inputMap.get('codePlageConso'));
        }
        if (vEnergyTypeOptions != 'Gaz') {
            vPuissance = String.valueOf(inputMap.get('puissance'));
            //vTypeComptage = String.valueOf(inputMap.get('codeTypeComptage'));
        }
        String niveauOuvertureService;
        String codeFTA;
        String lastModifFTA;
        String typedecompteur;
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
        if(inputMap.get('dateDerniereModificationFormuleTarifaireAcheminement') != null){
            lastModifFTA = (String) inputMap.get('dateDerniereModificationFormuleTarifaireAcheminement');
            //    lastModifFTA =  Datetime.ValueofGmt(dateTimeString.replace('T',' '));
        }
        if(inputMap.get('ftaCode') != null && inputMap.get('ftaCode') != 0){
            codeFTA = (String) inputMap.get('ftaCode');
        }
        if(inputMap.get('typeComptageDifferencie') != null){
            vTypeComptage = (String) inputMap.get('typeComptageDifferencie');
        }
        if(inputMap.get('typeCompteur') != null){
            typedecompteur = (String) inputMap.get('typeCompteur');
        }
        //  }
        String sellingOption;
        // system.debug('## inputMap.get choixelement '+inputMap.get('ChoixElements'));
        //  if(inputMap.get('ChoixElements') != null ){
        // map<String,Object> stepChoixElmts = (map<String,Object>)inputMap.get('ChoixElements');
        // RJM 03/02/2020 
        //Ajout de la sellingOption Changement d'offre 
        if(inputMap.get('chooseSellingOption') != null){
            sellingOption = String.valueOf(inputMap.get('chooseSellingOption'));
            if(sellingOption == 'Changement de fournisseur'){
                sellingOption = 'CHGT_FOURN';
            }else if(sellingOption == 'Changement d\'offre'){
                sellingOption = 'CHGT_OFFR';
            }
            else{
                sellingOption = 'MES_EMM';
            }
        }

        // Added by RJM FT2-1015
        String contexteDeSouscription = (String) inputMap.get('contexteDeSouscription') != null ? (String) inputMap.get('contexteDeSouscription') : null;
        // }
             /* US FT1-3663 --> recupérer les parametres Harmonica: L'ID du pack, le conext de moveIn, le code offre gaz et le code offre Elec */
        String contextMoveIn = (String) inputMap.get('moveinContext') != null ?  (String) inputMap.get('moveinContext') : '';
        String packCode = (String) inputMap.get('packCode') != null ?  (String) inputMap.get('packCode') : '';
        String codeOffreGaz = (String) inputMap.get('codeOffreGaz') != null ?  (String) inputMap.get('codeOffreGaz') : ''; 
        String codeOffreElec = (String) inputMap.get('codeOffreElec') != null ?  (String) inputMap.get('codeOffreElec') : '';
        list<SM_TranscoTypeComptageStrucMesFour__mdt> listTrascoTypeCompt = [select StructureMesureFournisseur__c from SM_TranscoTypeComptageStrucMesFour__mdt where TypeComptage__c =:vTypeComptage];
        list<String> listStrucMesFour = new list<String>();
        for(SM_TranscoTypeComptageStrucMesFour__mdt transco : listTrascoTypeCompt){
            listStrucMesFour.add(transco.StructureMesureFournisseur__c);
        }
        System.debug('## aka packCode ' + packCode);
        List<Product2> offres;
        List<String> listOffres = new List<String>();
        if(listStrucMesFour.size() > 0){// Dual ou Elec
                   // Si on est dans un context harmonica, récupère le produit harmonica en se basant son code pack 
            if((contextMoveIn == 'harmonica'|| contextMoveIn == 'Harmonica') && !String.isBlank(packCode)){
                offres = [SELECT id, TypeOffre__c,FamilyLabel__c,SM_structureMesureFournisseur__c, Family, ProductCode, vlocity_cmt__SpecificationType__c, ArticleURL__c, ArticlePreview__c,Ordre_daffichage__c,offreVerte__c
                          FROM Product2
                          WHERE  (vlocity_cmt__Type__c = : vEnergyTypeOptions AND IsActive = true AND SM_structureMesureFournisseur__c = :listStrucMesFour) OR 
                                 (vlocity_cmt__Type__c = : vEnergyTypeOptions AND IsActive = true AND SM_structureMesureFournisseur__c = :listStrucMesFour AND Family =: packCode)           
                          ORDER BY Ordre_daffichage__c asc];
            }else {
                offres = [SELECT id, TypeOffre__c,FamilyLabel__c,SM_structureMesureFournisseur__c, Family, ProductCode, vlocity_cmt__SpecificationType__c, ArticleURL__c, ArticlePreview__c,Ordre_daffichage__c,offreVerte__c
                          FROM Product2
                          WHERE  (vlocity_cmt__Type__c = : vEnergyTypeOptions AND IsActive = true AND SM_structureMesureFournisseur__c = :listStrucMesFour)
                          ORDER BY Ordre_daffichage__c asc];
                          
            }
            if(vEnergyTypeOptions == 'Duo' && offres.size()>0){
                List<String> listProductFamily = new List<String>();
                for(Product2 offre : offres){
                    listProductFamily.add(offre.Family);
                
                }


                // Updated by RJM (FT2-1009)


                if(listProductFamily.size()>0){
                        offres = [SELECT id,TypeOffre__c, FamilyLabel__c,SM_structureMesureFournisseur__c, Family, ProductCode, vlocity_cmt__SpecificationType__c, ArticleURL__c, ArticlePreview__c,offreVerte__c,Ordre_daffichage__c
                              FROM Product2
                              WHERE  vlocity_cmt__Type__c = : vEnergyTypeOptions
                              AND IsActive = true 
                              AND Family IN :listProductFamily
                                  AND (SM_structureMesureFournisseur__c IN:listStrucMesFour OR SM_structureMesureFournisseur__c = null)
                                 ORDER BY Ordre_daffichage__c asc ];
                
                                }
               
                /* offres = [SELECT id, FamilyLabel__c,SM_structureMesureFournisseur__c, Family, ProductCode, vlocity_cmt__SpecificationType__c
FROM Product2
WHERE  vlocity_cmt__Type__c = : vEnergyTypeOptions AND IsActive = true AND (SM_structureMesureFournisseur__c = :listStrucMesFour OR SM_structureMesureFournisseur__c = null)];*/
            }
        }else{// Gaz il n'y a pas de structure mesure fournisseur
            offres = [SELECT id,TypeOffre__c, FamilyLabel__c,SM_structureMesureFournisseur__c, Family, ProductCode, vlocity_cmt__SpecificationType__c, ArticleURL__c, ArticlePreview__c,offreVerte__c
                      FROM Product2
                      WHERE  vlocity_cmt__Type__c = : vEnergyTypeOptions AND IsActive = true];
        }        
        List<String> listOffresIds = new List<String>();
        Date todayDate = date.today();
        if (offres.size() > 0) {
            for(Product2 offre : offres){
                listOffresIds.add(offre.Id);
            }
            Set<String> setProductPousses = new Set<String>();
            Set<String> setProductReplis = new Set<String>();
            // Updated by RJM FT2-1015
            List<Choix_Offre__c> listChoixOffres = [SELECT Id,OffrePousse__c,offreRepli__c,OffrePousseLinky__c
                                                    FROM Choix_Offre__c
                                                    WHERE Energie__c = :vEnergyTypeOptions
                                                    AND Actif__c = true AND Contexte_de_souscription__c =: contexteDeSouscription];
            //
             
            if(listChoixOffres.size()>0){
                for(Choix_Offre__c choixOffre : listChoixOffres){
                    if(typedecompteur == 'LINKY'){  
                        setProductPousses.add(choixOffre.OffrePousseLinky__c);                  
                    }
                    else{
                        setProductPousses.add(choixOffre.OffrePousse__c);
                    }
                    setProductReplis.add(choixOffre.offreRepli__c);
                }
            }
            Map<String, List<String>> mapPackOffres = new Map<String, List<String>>();
            Map<String, String> mapCodeOffresLibPack = new Map<String, String>();
            Map<String, Boolean> mapIsOffrePoussee = new Map<String, Boolean>();
            Map<String, Boolean> mapIsOffreRepli = new Map<String, Boolean>();
            Map<String, String> mapProdFamStrucMesFourn = new Map<String,String>();
            Map<String, Article> mapArticle = new Map<String,Article>();
            Map<String, Boolean> mapIsOffreVerte = new Map<String, Boolean>();
            for (Product2 offre : offres) {
                //if (checkEligibility(Offre.ProductCode,offre.Family,niveauOuvertureService,typedecompteur)) {
                    // Construct a MAP that holds <CodeProduit, TypeOffre> to be used later to process TradeOff offres. 
                    typeOfProduct.put(offre.ProductCode, offre.TypeOffre__c);
                    if (mapPackOffres.get(offre.Family) != null) {
                        mapPackOffres.get(offre.Family).add(Offre.ProductCode);
                    } else {
                        mapPackOffres.put(offre.Family, new List<String> {Offre.ProductCode});
                    }
                    mapCodeOffresLibPack.put(offre.Family, offre.FamilyLabel__c);
                	if(offre.offreVerte__c){
                        mapIsOffreVerte.put(offre.Family, offre.offreVerte__c);
                	}
                  /*  if (offre.vlocity_cmt__SpecificationType__c == 'Offre poussée' ) {
                        mapIsOffrePoussee.put(offre.ProductCode, true);
                    } else {
                        mapIsOffrePoussee.put(offre.ProductCode, false);
                    }*/
                    // Determine Offre Poussee
                    if (setProductPousses.contains(offre.Family)) {
                        mapIsOffrePoussee.put(offre.ProductCode, true);
                    } else {
                        mapIsOffrePoussee.put(offre.ProductCode, false);
                    }
                    // Determine Offre Repli
                    if (setProductReplis.contains(offre.Family)) {
                        mapIsOffreRepli.put(offre.ProductCode, true);
                    } else {
                        mapIsOffreRepli.put(offre.ProductCode, false);
                    }
                    if(Offre.SM_structureMesureFournisseur__c != null){
                       mapProdFamStrucMesFourn.put(offre.Family, Offre.SM_structureMesureFournisseur__c); 
                    }
                    Article article = new Article();
                    article.url = offre.ArticleURL__c;
                    article.preview = offre.ArticlePreview__c;
                    mapArticle.put(offre.ProductCode, article);
               // }
            }
            List<String> listCodesOffres = new List<String>();
            listCodesOffres.addAll(mapCodeOffresLibPack.keySet());
            Map<String, Object> mapOffresEtPrix = new Map<String, Object>();
            mapOffresEtPrix.put('test',mapPackOffres);
            List<PrixOffreConsolide> OffresEtPrix = getPrix(codeFTA,lastModifFTA,sellingOption, vCodeInsee, vCodePostal, mapPackOffres, mapCodeOffresLibPack, mapIsOffrePoussee,mapProdFamStrucMesFourn, vDateEffetSouhaitee, vCodePlageConso, vPuissance, vTypeComptage,niveauOuvertureService,CAR, CAE, CAE_HP, CAE_HC, CAE_WE, mapArticle, mapIsOffreRepli,contextMoveIn,packCode,codeOffreGaz,codeOffreElec,mapIsOffreVerte);
            mapOffresEtPrix.put('OffreCatalogue', OffresEtPrix);
            system.debug('@@@ OffreChoisie ' + OffreChoisie);
             mapOffresEtPrix.put('OffreChoisis', OffreChoisie); 
            outMap.putAll(mapOffresEtPrix);
        }
    }
    /*@Author: RWA
*@Description: Récupération des valeurs du WS prix et remise et calcul des mens
*@CreatedDate:
*@LastModified: MHA 05/03/2019
*/
    public static List<PrixOffreConsolide> getPrix(String codeFTA,String lastModifFTA,String contSouscriptionCode,String codeCommune, String codePostal, Map<String, List<String>> mapPackOffres, Map<String, String> mapCodeOffresLibPack, Map<String, Boolean> mapIsOffrePoussee,Map<String,String> mapStrucmesfour,Datetime dateEffet, String plageconso, String vpuissance, String typeDeComptage,String niveauOuvertureService,Double CAR, Double CAE, Double CAE_HP, Double CAE_HC, Double CAE_WE, Map<String, Article> mapArticle, Map<String, Boolean> mapisOffreRepli,String contextMoveIn,String packCode,String codeOffreGaz,String codeOffreElec,Map<String,Boolean> mapIsOffreVerte) {
        system.debug('inputs codeFTA'+ codeFTA);
        system.debug('inputs lastModifFTA'+ lastModifFTA);
        system.debug('inputs contSouscriptionCode'+ contSouscriptionCode);
        system.debug('inputs codeCommune'+ codeCommune);
        system.debug('inputs codePostal'+ codePostal);
        system.debug('inputs mapPackOffres'+ mapPackOffres);
        system.debug('inputs mapIsOffrePoussee'+ mapIsOffrePoussee);
        system.debug('inputs mapStrucmesfour'+ mapStrucmesfour);
        system.debug('inputs dateEffet'+ dateEffet);
        system.debug('inputs plageconso'+ plageconso);
        system.debug('inputs vpuissance'+ vpuissance);
        system.debug('inputs typeDeComptage'+ typeDeComptage);
        system.debug('inputs niveauOuvertureService'+ niveauOuvertureService);
        system.debug('inputs CAR'+ CAR);
        system.debug('inputs CAE'+ CAE);
        system.debug('inputs CAE_HP'+ CAE_HP);
        system.debug('inputs CAE_HC'+ CAE_HC);
        system.debug('inputs CAE_WE'+ CAE_WE);
        system.debug('inputs mapArticle'+ mapArticle);
        system.debug('inputs mapisOffreRepli'+ mapisOffreRepli);
        system.debug('inputs contextMoveIn'+ contextMoveIn);
        system.debug('inputs packCode'+ packCode);
        system.debug('inputs codeOffreGaz'+ codeOffreGaz);
        system.debug('inputs codeOffreElec'+ codeOffreElec);
         system.debug('inputs mapIsOffreVert'+ mapIsOffreVerte);
        SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();
        List<gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt> listInput = new List<gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt>();
        gdfsuezComBefChpCommunV3.contextDt octx = initContext(octopusCS.appName__c, '1.00');
        for (String pack : mapPackOffres.keyset()) {
            /*Contruction des parametres*/
            gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt prixService = new gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt();
            /*identifiantsLieuDt */
            gdfsuezBefCalypsoPrixetremisesV2.identifiantsLieuDt identifiantsLieu = new gdfsuezBefCalypsoPrixetremisesV2.identifiantsLieuDt();
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
            prixService.idOffre = mapPackOffres.get(pack);
            gdfsuezComBefChpCommunV3.listeValeursDt codeEnseigneSouscription = new gdfsuezComBefChpCommunV3.listeValeursDt();
            codeEnseigneSouscription.code = 'PPO';
            prixService.enseigneSouscription = codeEnseigneSouscription;
            gdfsuezComBefChpCommunV3.listeValeursDt contexteSouscription = new gdfsuezComBefChpCommunV3.listeValeursDt();
            contexteSouscription.code = contSouscriptionCode;
            prixService.contexteSouscription = contexteSouscription;
            /*Constution des caractistiques GAZ*/
            system.debug('--- plageconso = '+String.isBlank(plageconso));
            if (!String.isBlank(plageconso)) {
                gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt carGaz = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt();
                gdfsuezComBefChpCommunV3.listeValeursDt plageConsommation = new gdfsuezComBefChpCommunV3.listeValeursDt();
                plageConsommation.code = plageconso;
                carGaz.plageConsommation = plageConsommation;
                prixService.caracteristiquesOffreGaz = carGaz;
            }
            system.debug('--- vpuissance = '+String.isBlank(vpuissance));
            /*Constution des caractistiques ELEC*/
            if (!String.isBlank(vpuissance) || !String.isBlank(typeDeComptage)) {
                if(contSouscriptionCode == 'CHGT_FOURN' ||(contSouscriptionCode == 'CHGT_OFFR')){
                    prixService.dateDerniereModificationFormuleTarifaireAcheminement = lastModifFTA;                
                    gdfsuezComBefChpCommunV3.listeValeursDt formuleTarifaireAcheminement = new gdfsuezComBefChpCommunV3.listeValeursDt();
                    formuleTarifaireAcheminement.code = codeFTA;
                    prixService.formuleTarifaireAcheminement = formuleTarifaireAcheminement; 
                }
                gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt carElec = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                if (!String.isBlank(vpuissance) ) {
                    gdfsuezComBefChpCommunV3.listeValeursDt puissanceV = new gdfsuezComBefChpCommunV3.listeValeursDt();
                    puissanceV.code = vpuissance;
                    carElec.puissance = puissanceV;
                    system.debug('--- packCode.puissance = '+packCode);
                                    if(pack == 'DGBUEBUVR1_P'){
                    system.debug('--- carElec.puissance = '+carElec.puissance);
                }
                }
                if (mapIsOffreVerte.get(pack)!= null) {
                    gdfsuezComBefChpCommunV3.listeValeursDt pourcentageOffreVerte = new gdfsuezComBefChpCommunV3.listeValeursDt();
                    pourcentageOffreVerte.code = '100';
                    carElec.pourcentageOffreVerte = pourcentageOffreVerte;
                }
                /*if (!String.isBlank(typeDeComptage) ) {
gdfsuezComBefChpCommunV3.listeValeursDt typeComptageV = new gdfsuezComBefChpCommunV3.listeValeursDt();
typeComptageV.code = typeDeComptage;
carElec.typeComptage = typeComptageV;
system.debug('typeComptageV' + typeComptageV);
}*/
                if(mapStrucmesfour.get(pack) != null){
                    gdfsuezComBefChpCommunV3.listeValeursDt structureMesureFournisseur = new gdfsuezComBefChpCommunV3.listeValeursDt();
                    structureMesureFournisseur.code = mapStrucmesfour.get(pack);
                    carElec.structureMesureFournisseur = structureMesureFournisseur;
                }
                if(CAE != null && CAE != 0){
                    carElec.CAEElec = CAE.intValue();
                }
                if(niveauOuvertureService != null && niveauOuvertureService != ''){
                    carElec.niveauOuvertureService = niveauOuvertureService;
                }
                prixService.caracteristiquesOffreElec = carElec;
                system.debug('prixService.caracteristiquesOffreElec '+prixService.caracteristiquesOffreElec);
            }
            listInput.add(prixService);
        }
        gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort prixRemiseService = new gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort();
        prixRemiseService.clientCertName_x = octopusCS.certName__c;
        prixRemiseService.timeout_x = 30000;

        //prixRemiseService.endpoint_x = 'https://enwxhs5tzn9n.x.pipedream.net';

        SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'PrixEtRemises_v2' limit 1];
        prixRemiseService.endpoint_x = octopusCS.endpoint__c + suffixs.suffix__c;
        system.debug('endpoint ' +  prixRemiseService.endpoint_x);
        prixRemiseService.inputHttpHeaders_x = new Map<String, String> {'Content-Type' => 'text/xml;charset=utf-8'};
            gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesResponse_element response = new gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesResponse_element();
        if (!Test.isRunningTest()) {
            response = prixRemiseService.RechercherPrixEtRemises(listInput, octx);
        } else {
            Test.setMock(WebServiceMock.class, new SM_AP11_OffresEtPrixMock());
            gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort testObject = new gdfsuezBefCalypsoPrixetremisesV2.PrixEtRemisesPort();
            system.debug('@@ start of mock');
            response = testObject.RechercherPrixEtRemises(listInput, octx);
            system.debug('@@ end of mock' + response);
        }
        List<PrixOffreConsolide> listOffreAvecPrix = new  List<PrixOffreConsolide>();
        Map<String, PrixOffreConsolide> mapLibelleParPix = new Map<String, PrixOffreConsolide>();
        if (response != null && response.messageRetours != null && response.messageRetours.messageRetour != null ) {
            for (gdfsuezComBefChpCommunV3.messageRetour_element msgRetour : response.messageRetours.messageRetour) {
                if ('ERREUR'.equalsIgnoreCase(msgRetour.type_x)) {
                    /*return null;*/
                }
            }
        }
        gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesOutputDt[] rechercherPrixEtRemisesOutput = response.rechercherPrixEtRemisesOutput;
        for (gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesOutputDt donneesRetour : rechercherPrixEtRemisesOutput) {
            String packId;
            String packLibelle;
            if (donneesRetour != null && donneesRetour.donneesPack != null && donneesRetour.donneesPack.idPack != null) {
                System.debug('## aka 1');
                packId = donneesRetour.donneesPack.idPack;
                packLibelle = donneesRetour.donneesPack.libellePack;
            }
            if (donneesRetour != null && donneesRetour.donneesOffre != null) {
                System.debug('## aka 2');
                gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt[] donneesOffre = donneesRetour.donneesOffre;
                for (gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt data : donneesOffre) {
                    
                    String ftaOutput;
                   if(data.formuleTarifaireAcheminement != null){
                         ftaOutput =  data.formuleTarifaireAcheminement.code;
                    }
                    gdfsuezBefCalypsoPrixetremisesV2.listePrixDt listePrix = data.listePrix;
                    System.Debug('### aka data ' + data);
					 System.debug('## aka listPrix ' + listePrix);
                    if (listePrix != null) {
                        /*String jsonOut = JSON.serialize(listePrix);
system.debug('@@ json ' + jsonOut);*/
                        String libellePackDeLOffre = mapCodeOffresLibPack.get(packId);
                        System.debug('### aka libellePackDeLOffre ' + libellePackDeLOffre );
                        Boolean isOffrePoussee = mapIsOffrePoussee.get(data.idOffre);
                        Boolean isOffreRepli = mapIsOffreRepli.get(data.idOffre);
                        Article article = mapArticle.get(data.idOffre);
                        Map<String, Map<String, Double>> mapConsoByTypeComptage = new Map<String, Map<String, Double>>();
                        Map<String, Map<String, Double>> mapConsoGazByTypeComptage = new Map<String, Map<String, Double>>();
                        wrapperPrix prixElec = new wrapperPrix('Elec', Double.valueOf('0'), Double.valueOf('0'), mapConsoByTypeComptage);
                        wrapperPrix prixGaz = new wrapperPrix('Gaz', Double.valueOf('0'), Double.valueOf('0'), mapConsoGazByTypeComptage);
                        for (gdfsuezBefCalypsoPrixetremisesV2.prixDt prix : listePrix.prix) {
                            if (prix.caracteristiquesGaz != null && prix.caracteristiquesGaz.typePrix!= null
                                && prix.caracteristiquesGaz.plageconsommation != null
                                && typeOfProduct.get(data.idOffre) != 'TradeOFF'
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
                                }else if(prix.caracteristiquesGaz != null && prix.caracteristiquesGaz.typePrix != null
                                && prix.caracteristiquesGaz.plageconsommation != null
                                && typeOfProduct.get(data.idOffre) == 'TradeOFF'
                                ){
                                       if(prix.caracteristiquesGaz.typePrix.code == 'TOTAB'){
                                            prixGaz.AboTTC = prix.montantTTC;
                                            prixGaz.AboHT = prix.montantHT;
                                           System.debug('ACH TOTAB'+  prixGaz.AboTTC);
                                       }
                                       if(prix.caracteristiquesGaz.typePrix.code == 'TOTCO'){
                                            prixGaz.CoTTC = prix.montantTTC;
                                            prixGaz.CoHT = prix.montantHT;
                                            Map<String, Double> montants = new Map<String, Double>();
                                            montants.put('TTC', prix.montantTTC);
                                            montants.put('HT', prix.montantHT);
                                            mapConsoGazByTypeComptage.put('consoGaz', montants);
                                           System.debug('ACH TOTCO'+  prixGaz.AboTTC);
                                       }
                                       if(prix.caracteristiquesGaz.typePrix.code == 'ACHAB'){
                                            Map<String, Double> montants = new Map<String, Double>();
                                            montants.put('TTC', prix.montantTTC);
                                            montants.put('HT', prix.montantHT);
                                            mapConsoGazByTypeComptage.put('ACHAB', montants);
                                        }
                                        if(prix.caracteristiquesGaz.typePrix.code == 'AB'){
                                            Map<String, Double> montants = new Map<String, Double>();
                                            montants.put('TTC', prix.montantTTC);
                                            montants.put('HT', prix.montantHT);
                                            mapConsoGazByTypeComptage.put('AB', montants);
                                        }
                                        if(prix.caracteristiquesGaz.typePrix.code == 'ACHCO'){
                                            Map<String, Double> montants = new Map<String, Double>();
                                            montants.put('TTC', prix.montantTTC);
                                            montants.put('HT', prix.montantHT);
                                            mapConsoGazByTypeComptage.put('ACHCO', montants);
                                        }
                                        if(prix.caracteristiquesGaz.typePrix.code == 'CO'){
                                            Map<String, Double> montants = new Map<String, Double>();
                                            montants.put('TTC', prix.montantTTC);
                                            montants.put('HT', prix.montantHT);
                                            mapConsoGazByTypeComptage.put('CO', montants);
                                        }
                                        if(prix.caracteristiquesGaz.typePrix.code == 'OB'){
                                            Map<String, Double> montants = new Map<String, Double>();
                                            montants.put('TTC', prix.montantTTC);
                                            montants.put('HT', prix.montantHT);
                                            mapConsoGazByTypeComptage.put('OB', montants);
                                        }
                                        prixGaz.mapConsoByType = mapConsoGazByTypeComptage;
                                }
                            /*Si l'offre contient des caracteristique ELEC je recupere les prix de l'ABO et de la CONS*/
                            if (prix.caracteristiquesElec != null && prix.caracteristiquesElec.typePrix != null
                                && prix.caracteristiquesElec.puissance != null && prix.caracteristiquesElec.typeComptage != null
                                && typeOfProduct.get(data.idOffre) != 'TradeOFF' 
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
                                }else if(prix.caracteristiquesElec != null && prix.caracteristiquesElec.typePrix != null 
                                && prix.caracteristiquesElec.puissance != null  
                                && typeOfProduct.get(data.idOffre) == 'TradeOFF' 
                                ){
                                      if (prix.caracteristiquesElec.typePrix.code == 'CO'
                                            && prix.caracteristiquesElec.typeComptage != null
                                        ) {
                                            Map<String, Double> montants = new Map<String, Double>();
                                            montants.put('TTC', prix.montantTTC);
                                            montants.put('HT', prix.montantHT);
                                            mapConsoByTypeComptage.put('CO'+prix.caracteristiquesElec.typeComptage.code, montants);
                                            // consoElec=String.valueOf(Decimal.valueOf(montantTTC).setscale(2))+ ' €/kWh TTC ('+String.valueOf(Decimal.valueOf(montantHT).setscale(5))+' HT)';
                                            prixElec.mapConsoByType = mapConsoByTypeComptage;
                                        }
                                       if(prix.caracteristiquesElec.typePrix.code == 'TOTAB'){
                                            prixElec.AboTTC = prix.montantTTC;
                                            prixElec.AboHT = prix.montantHT;
                                       }
                                       if(prix.caracteristiquesElec.typePrix.code == 'TOTCO'){
                                            prixElec.CoTTC = prix.montantTTC;
                                            prixElec.CoHT = prix.montantHT;
                                       }
                                       if(prix.caracteristiquesElec.typePrix.code == 'ACHAB'){
                                            Map<String, Double> montants = new Map<String, Double>();
                                            montants.put('TTC', prix.montantTTC);
                                            montants.put('HT', prix.montantHT);
                                            mapConsoByTypeComptage.put('ACHAB', montants);
                                            /*prixElec.AboAcheminementTTC = prix.montantTTC;
                                            prixElec.AboAcheminementHT = prix.montantHT;
                                            system.debug('---> PrixElec AboAcheminementTTC = '+prixElec.AboTTC+', AboAcheminementHT = '+prixElec.AboHT);*/
                                        }
                                       if(prix.caracteristiquesElec.typePrix.code == 'AB'){
                                            Map<String, Double> montants = new Map<String, Double>();
                                            montants.put('TTC', prix.montantTTC);
                                            montants.put('HT', prix.montantHT);
                                            mapConsoByTypeComptage.put('AB', montants);
                                            /*prixElec.AboFournitureTTC = prix.montantTTC;
                                            prixElec.AboFournitureHT = prix.montantHT;
                                            system.debug('---> PrixElec AboFournitureTTC = '+prixElec.AboTTC+', AboFournitureHT = '+prixElec.AboHT);*/
                                        }
                                        if(prix.caracteristiquesElec.typePrix.code == 'OB'){
                                            Map<String, Double> montants = new Map<String, Double>();
                                            montants.put('TTC', prix.montantTTC);
                                            montants.put('HT', prix.montantHT);
                                            mapConsoByTypeComptage.put('OB', montants);
                                            /*prixElec.AboFournitureTTC = prix.montantTTC;
                                            prixElec.AboFournitureHT = prix.montantHT;
                                            system.debug('---> PrixElec AboFournitureTTC = '+prixElec.AboTTC+', AboFournitureHT = '+prixElec.AboHT);*/
                                        }
                                        if (prix.caracteristiquesElec.typePrix.code == 'ACHCO'
                                        && prix.caracteristiquesElec.typeComptage != null
                                        ) {
                                            Map<String, Double> montants = new Map<String, Double>();
                                            montants.put('TTC', prix.montantTTC);
                                            montants.put('HT', prix.montantHT);
                                            mapConsoByTypeComptage.put(prix.caracteristiquesElec.typeComptage.code, montants);
                                            // consoElec=String.valueOf(Decimal.valueOf(montantTTC).setscale(2))+ ' €/kWh TTC ('+String.valueOf(Decimal.valueOf(montantHT).setscale(5))+' HT)';
                                }
                                        prixElec.mapConsoByType = mapConsoByTypeComptage;
                        }
                        }
                        System.debug('### aka mapLibelleParPix ' + mapLibelleParPix.get(libellePackDeLOffre) );
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
                                                                                   article,
                                                                                  ftaOutput,
                                                                                  isOffreRepli);
                            Double mensValue = 0;
                            Double mensGazValue = 0;
                            if (!string.isBlank(offreValue.mens)) {
                                mensValue = Double.valueOf(offreValue.mens);
                            }
                            if (!string.isBlank(offreValue.mensGaz)) {
                                mensGazValue = Double.valueOf(offreValue.mensGaz);
                            }
                            offreValue.mensTotal = String.valueOf(mensValue + mensGazValue);
                            //RJM : 17/04/2020 FT2-445
                            offreValue.mensTotalDecimal = Decimal.valueOf(mensValue + mensGazValue).setScale(2);
                            //
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
                                                                                         article,
                                                                                         ftaOutput,
                                                                                         isOffreRepli);
                            /*System.debug('###TestMHA'+offreNouveauInit);*/
                            PrixOffreConsolide offreExistant = mapLibelleParPix.get(libellePackDeLOffre);
                            offreExistant.codeOffre = offreExistant.codeOffre + data.idOffre;
                            offreExistant.isOffrePoussee = offreExistant.isOffrePoussee ? true : isOffrePoussee;
                            /*  offreExistant.aboElec=offreExistant.aboElec==null?offreNouveauInit.aboElec:offreExistant.aboElec;
offreExistant.mapConsoByTypeComptage=offreExistant.aboElec==null?offreNouveauInit.mapConsoByTypeComptage:offreExistant.mapConsoByTypeComptage;
offreExistant.mens=offreExistant.mens==null?offreNouveauInit.mens:offreExistant.mens;*/
                            Double mensValue = 0;
                            Double mensGazValue = 0;
                            if (offreExistant.aboElec == null) {
                                offreExistant.aboElec = offreNouveauInit.aboElec;
                                offreExistant.mapConsoByTypeComptage = offreNouveauInit.mapConsoByTypeComptage;
                                offreExistant.mens = offreNouveauInit.mens;
                                if (offreExistant.mens == null) {
                                    mensValue = 0;
                                } else {
                                    mensValue = Double.valueOf(offreExistant.mens);
                                }
                            }
                            if (offreExistant.aboGaz == null) {
                                offreExistant.mapConsoGazByTypeComptage = offreNouveauInit.mapConsoGazByTypeComptage;
                                offreExistant.aboGaz = offreNouveauInit.aboGaz;
                                offreExistant.mensGaz = offreNouveauInit.mensGaz;
                                if (offreExistant.mensGaz == null) {
                                    mensGazValue = 0;
                                } else {
                                    mensGazValue = Double.valueOf(offreExistant.mensGaz);
                                }
                            }
                            if (offreExistant.mens != null && offreExistant.mensGaz != null) {
                                offreExistant.mensTotal = String.valueOf(Double.valueOf(offreExistant.mens) + Double.valueOf(offreExistant.mensGaz));
                                //RJM : 17/04/2020 FT2-445
                                offreExistant.mensTotalDecimal = Decimal.valueOf(Double.valueOf(offreExistant.mens) + Double.valueOf(offreExistant.mensGaz)).setScale(2);
                                //
                            } else if (offreExistant.mens != null && offreExistant.mensGaz == null) {
                                offreExistant.mensTotal = String.valueOf(Double.valueOf(offreExistant.mens));
                                //RJM : 17/04/2020 FT2-445
                                offreExistant.mensTotalDecimal = Decimal.valueOf(Double.valueOf(offreExistant.mens)).setScale(2);
                                //
                            } else if (offreExistant.mens == null && offreExistant.mensGaz != null) {
                                offreExistant.mensTotal = String.valueOf(Double.valueOf(offreExistant.mensGaz));
                                //RJM : 17/04/2020 FT2-445
                                offreExistant.mensTotalDecimal = Decimal.valueOf(Double.valueOf(offreExistant.mensGaz)).setScale(2);
                                //
                            } else {
                                offreExistant.mensTotal = String.valueOf(0);
                                //RJM : 17/04/2020 FT2-445
                                offreExistant.mensTotalDecimal = Decimal.valueOf(0).setScale(2);
                                //
                            }
                            system.debug('@@@ offreExistant ' + offreExistant);
                            system.debug('@@@ libellePackDeLOffre ' + libellePackDeLOffre);
                            mapLibelleParPix.put(libellePackDeLOffre, offreExistant );
                            /*offreExistant.mapConsoGazByTypeComptage=offreExistant.aboGaz==null?offreNouveauInit.mapConsoGazByTypeComptage:offreExistant.mapConsoGazByTypeComptage;
offreExistant.aboGaz=offreExistant.aboGaz==null?offreNouveauInit.aboGaz:offreExistant.aboGaz;
offreExistant.mensGaz=offreExistant.mensGaz==null?offreNouveauInit.mensGaz:offreExistant.mensGaz;*/
                        }
                    }
                }
            }
        }
        listOffreAvecPrix.addAll(mapLibelleParPix.values());
        for (PrixOffreConsolide offreAffiche : listOffreAvecPrix) {
            if (offreAffiche.mens != null && offreAffiche.mensGaz != null) {
                /*offreAffiche.mens = String.ValueOf(Decimal.valueOf(offreAffiche.mens) + Decimal.valueOf(offreAffiche.mensGaz)) + ' €/mois';*/
                offreAffiche.mensTotal = String.ValueOf(Decimal.valueOf(offreAffiche.mens) + Decimal.valueOf(offreAffiche.mensGaz));
                //RJM : 17/04/2020 FT2-445
                offreAffiche.mensTotalDecimal = (Decimal.valueOf(offreAffiche.mens) + Decimal.valueOf(offreAffiche.mensGaz)).setScale(2);
                //
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
             if(!String.isBlank(contextMoveIn) && !String.isBlank(packCode) && (contextMoveIn == 'harmonica'|| contextMoveIn == 'Harmonica') && offreAffiche.idPack == packCode){
                offreAffiche.isOffrePousseeHarmonica = true;
                OffreChoisie =  offreAffiche;
             }
        }
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
        public Double CoTTC;// tradeOff
        public Double CoHT;// tradeOff
        public Double AboAcheminementTTC; // tradeOff
        public Double AboAcheminementHT; // tradeOff
        public Double AboFournitureHT;
        public Double AboFournitureTTC;
        public Map<String, Map<String, Double>> mapConsoByType;
        /*@Author: RWA
*@Description: constructeur du wrapper
*@CreatedDate:
*@LastModified: MHA 22/02/2019
*/
        public wrapperPrix(String typeEnergie, Double AboTTC, Double AboHT, Map<String, Map<String, Double>>  mapConsoByType) {
            this.typeEnergie = typeEnergie;
            this.AboTTC = AboTTC;
            this.AboHT = AboHT;
            this.mapConsoByType = mapConsoByType;
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
        public Boolean isOffrePousseeHarmonica;
        public Boolean isOffreRepli;
        public Double CAR;
        public Double CAE;
        public Double CAE_HP;
        public Double CAE_HC;
        public Double CAE_WE;
        public String typeOffre;
        public String consoElec;
        public String articleURL;
        public String articlePreview;
        public String ftaOutput;
        //RJM : 17/04/2020 FT2-445
        public Decimal mensTotalDecimal;
        /*@Author: RWA
*@Description: constructeur des offres consolidées
*@CreatedDate:
*@LastModified: MHA 06/03/2019
*/
        public PrixOffreConsolide(String libelleOffre, String codeOffre, Boolean isOffrePoussee, String idPack, List<String> idOffreList,
                                  wrapperPrix prixELec, wrapperPrix prixGaz, Double CAR, Double CAE, Double CAE_HP, Double CAE_HC, Double CAE_WE, Article article, String ftaOutput, Boolean isOffreRepli) {
                                      this.codeOffre = codeOffre;
                                      this.libelleOffre = libelleOffre;
                                      this.isOffrePoussee = isOffrePoussee;
                                      this.idPack = idPack;
                                      this.idOffreList = idOffreList;
                                      this.CAR = CAR;
                                      this.CAE = CAE;
                                      this.typeOffre = typeOfProduct.get(codeOffre);
                                      this.articleURL = (article != null ? article.url : '');
                                      this.articlePreview = (article != null ? article.preview : '');
                                      this.ftaOutput = ftaOutput;
                                      this.isOffreRepli = isOffreRepli;
                                  if (Double.valueOf('0') == prixELec.AboTTC) {
                                          this.aboElec = null;
                                          this.mens = null;
                                      } else {
                                          this.aboElec = String.valueOf(Decimal.valueOf(prixELec.AboTTC).setscale(2)) + ' € TTC/an (' + String.valueOf(Decimal.valueOf(prixELec.AboHT).setscale(2)) + ' HT)';
                                          Map<String, Map<String, Double>> mapConsoByType = prixELec.mapConsoByType;
                                          List<Double> listConsoTTC = new List<Double>();
                                          for (String consLabel : mapConsoByType.keySet()) {
                                              Map<String, Double> montants = mapConsoByType.get(consLabel);
                                              String consValue = String.valueOf(Decimal.valueOf(montants.get('TTC')).setscale(5)) + ' € TTC/kWh  (' + String.valueOf(Decimal.valueOf(montants.get('HT')).setscale(5)) + ' HT)';
                                              String consolLabelTransc;
                                              if (consLabel == 'P') {
                                                  consolLabelTransc = 'HP';
                                                  listConsoTTC.add(calculConsommation(montants.get('TTC'),CAE_HP));
                                              } else if (consLabel == 'C') {
                                                  consolLabelTransc = 'HC';
                                                  listConsoTTC.add(calculConsommation(montants.get('TTC'),CAE_HC));
                                              } else if(consLabel == 'WE'){
                                                  consolLabelTransc = consLabel;
                                                  listConsoTTC.add(calculConsommation(montants.get('TTC'),CAE_WE));
                                              }else if (consLabel == 'S' && typeOfProduct.get(codeOffre) == 'TradeOFF'){
                                                  consolLabelTransc = 'Base';    // base acheminement                                          
                                              }else if (consLabel == 'COS') {
                                                  consolLabelTransc = 'Base_';  // base fourniture
                                              }else if (consLabel == 'COP') {
                                                  consolLabelTransc = 'HP_';  
                                              }else if (consLabel == 'COC') {
                                                  consolLabelTransc = 'HC_';  
                                              }else if (consLabel == 'COHP') {
                                                  consolLabelTransc = 'HP_';  
                                              }else if (consLabel == 'COHC') {
                                                  consolLabelTransc = 'HC_';  
                                              }else if (consLabel == 'COWE') {
                                                  consolLabelTransc = 'WE_';  
                                              }
                                              /*else if (consLabel == 'P' ){
                                                  consolLabelTransc = 'HP';
                                              }else if (consLabel == 'C'){
                                                  consolLabelTransc = 'HC';
                                              }*/else if (consLabel == 'U'){
                                                  consolLabelTransc = 'HPH';
                                              }else if (consLabel == 'A'){
                                                  consolLabelTransc = 'HCH';
                                              }else if (consLabel == 'L'){
                                                  consolLabelTransc = 'HPB';
                                              }else if (consLabel == 'R'){
                                                  consolLabelTransc = 'HCB';
                                              }else if( consLabel == 'ACHAB'){
                                                  consolLabelTransc = 'Acheminement'; // abonement elec
                                                  consValue = String.valueOf(Decimal.valueOf(montants.get('TTC')).setscale(2)) + ' € TTC/an (' + String.valueOf(Decimal.valueOf(montants.get('HT')).setscale(2)) + ' HT)';
                                              }else if(consLabel == 'AB'){
                                                  consolLabelTransc = 'Fourniture';// abonement elec
                                                  consValue = String.valueOf(Decimal.valueOf(montants.get('TTC')).setscale(2)) + ' € TTC/an (' + String.valueOf(Decimal.valueOf(montants.get('HT')).setscale(2)) + ' HT)';
                                              }
                                              else if(consLabel == 'OB'){
                                                  consolLabelTransc = 'OBLIGATIONS';
                                                  consValue = String.valueOf(Decimal.valueOf(montants.get('TTC')).setscale(5)) + ' € TTC/kWh (' + String.valueOf(Decimal.valueOf(montants.get('HT')).setscale(5)) + ' HT)';
                                              }
                                              else{
                                                  consolLabelTransc = consLabel;
                                                  listConsoTTC.add(calculConsommation(montants.get('TTC'),CAE));
                                              }
                                              mapConsoByTypeComptage.put(consolLabelTransc, consolLabelTransc + ':' + consValue);
                                              /*listConsoTTC.add(montants.get('TTC'));*/
                                          }
                                          if(typeOfProduct.get(codeOffre) == 'TradeOFF'){
                                              this.mens = String.ValueOf(calculMensTradeOFF(Double.valueOf(prixELec.AboTTC),Double.valueOf(prixELec.coTTC), this.CAE));
                                              this.consoElec = 'CONSOMMATION:'+Decimal.valueOf(prixELec.coTTC).setscale(5)+' € TTC/kWh'+' ('+Decimal.ValueOf(prixELec.CoHT).setscale(5)+ ' HT)';
                                          }else{
                                              this.mens = String.ValueOf(calculMens( Double.valueOf(prixELec.AboTTC), listConsoTTC, this.CAE));
                                              //+ ' €/mois'
                                          }
                                      }
                                      if (Double.valueOf('0') == prixGaz.AboTTC) {
                                          this.aboGaz = null;
                                          this.mensGaz = null;
                                      } else {
                                          this.aboGaz = String.valueOf(Decimal.valueOf(prixGaz.AboTTC).setscale(2)) + ' € TTC/an (' + String.valueOf(Decimal.valueOf(prixGaz.AboHT).setscale(2)) + ' HT)';
                                          Map<String, Map<String, Double>> mapConsoByTypeGAz = prixGaz.mapConsoByType;
                                          List<Double> listConsoTTCGaz = new List<Double>();
                                          for (String consLabel : mapConsoByTypeGAz.keySet()) {
                                              Map<String, Double> montants = mapConsoByTypeGAz.get(consLabel);
                                              String consolLabelTransc;
                                              String consValueGaz = String.valueOf(Decimal.valueOf(montants.get('TTC')).setscale(5)) + ' € TTC/kWh (' + String.valueOf(Decimal.valueOf(montants.get('HT')).setscale(5)) + ' HT)';
                                              if( consLabel == 'ACHAB'){
                                                  consolLabelTransc = 'Acheminement_abo'; // abonement elec
                                                  consValueGaz = String.valueOf(Decimal.valueOf(montants.get('TTC')).setscale(2)) + ' € TTC/an (' + String.valueOf(Decimal.valueOf(montants.get('HT')).setscale(2)) + ' HT)';
                                              }else if(consLabel == 'AB'){
                                                  consolLabelTransc = 'Fourniture_abo';// abonement elec
                                                  consValueGaz = String.valueOf(Decimal.valueOf(montants.get('TTC')).setscale(2)) + ' € TTC/an (' + String.valueOf(Decimal.valueOf(montants.get('HT')).setscale(2)) + ' HT)';
                                              }else if(consLabel == 'OB'){
                                                  consolLabelTransc = 'OBLIGATIONS';
                                                  consValueGaz = String.valueOf(Decimal.valueOf(montants.get('TTC')).setscale(5)) + ' € TTC/kWh (' + String.valueOf(Decimal.valueOf(montants.get('HT')).setscale(5)) + ' HT)';
                                              }else if(consLabel == 'ACHCO'){
                                                  consolLabelTransc = 'Acheminement_conso'; // conso gaz
                                              }else if(consLabel == 'CO'){
                                                  consolLabelTransc = 'Fourniture_conso'; // conso gaz
                                              }else{
                                                  consolLabelTransc = consLabel;
                                              }
                                              mapConsoGazByTypeComptage.put(consolLabelTransc, consValueGaz);
                                              listConsoTTCGaz.add(calculConsommation(montants.get('TTC'),CAR));
                                          }
                                          if(typeOfProduct.get(codeOffre) == 'TradeOFF'){
                                            this.mensGaz = String.ValueOf(calculMensTradeOFF(Double.valueOf(prixGaz.AboTTC),Double.valueOf(prixGaz.coTTC), this.CAR));                                             
                                          }else{
                                            this.mensGaz = String.ValueOf(calculMens( Double.valueOf(prixGaz.AboTTC), listConsoTTCGaz, this.CAR));
                                          }
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
                                      //RJM : 17/04/2020 FT2-445
                                      this.mensTotalDecimal = Decimal.valueOf(mensValue + mensGazValue).setscale(2);
                                      //
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
        Double mens;
        Double estimationConsTotal = 0;
        for (Double estimationCons : mapConsoByCAECAR) {
            //estimationConsTotal = estimationConsTotal + (estimationCons * CAECAR);
            estimationConsTotal = estimationConsTotal + estimationCons;
        }
        mens = (Abo + estimationConsTotal) / 11;
        Decimal mensCalcule = Decimal.valueOf(mens).setscale(0);
        return mensCalcule;
    }
    public static Decimal calculMensTradeOFF(Double AboTTC,Double coTTC, Double CAECAR) {
        Double mens;
        mens = (AboTTC+(coTTC*CAECAR))/11;
        Decimal mensCalcule = Decimal.valueOf(mens).setscale(0);
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