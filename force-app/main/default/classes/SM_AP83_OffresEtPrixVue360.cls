/**
 * @Author: MBA
 * @Description: Récupération des valeurs du WS prix et remise et calcul des mens
 * @CreatedDate:
 * @LastModified: MBA 26/05/2020
 */
global class SM_AP83_OffresEtPrixVue360 {
    
    /**
     * @Author: MBA 09/03/2020
     * @Description: appel de la méthode
     * @CreatedDate:
     * @LastModified: MBA 26/05/2020
    */
    public static final MAP<String,String> typeOfProduct = new MAP<String,String>();
    public static PrixOffreConsolide  OffreChoisie = null;
    
    /**
     * @Author: MBA 09/03/2020
     * @Description: Récupération des valeurs du WS prix et remise et calcul des mens
     * @CreatedDate:
     * @LastModified: MBA 26/05/2020
     */
    @AuraEnabled(cacheable=true)
    public static Map < String, Object > getOffresEtPrix(Map < String, Object > inputMap) {
        Map < String, Object > outMap  = new Map<String, Object>();
        String vEnergyTypeOptions = (String) inputMap.get('EnergyTypeOptions');
        /* recuperer la date d'effet souhaitee */
        String vDateEffet = (String) inputMap.get('dateEffetContrat');
        Date tempDate = Date.ValueOf(vDateEffet.substring(0, 10));
        Datetime vDateEffetSouhaitee = Datetime.newInstanceGmt(tempDate.year(), tempDate.month(), tempDate.day());
        String vCodeInsee = String.valueOf(inputMap.get('codeCommune') );
        String vCodePostal = String.valueOf(inputMap.get('codePostal'));
                
        //Récupération de la CAR et la CAE
        Double CAR = 0;
        Double CAE = 0;
        if (inputMap.get('CAR') != null && inputMap.get('CAR') != '') {
            CAR = Double.valueOf(inputMap.get('CAR'));
        }
        
        if (inputMap.get('CAEElec') != null && inputMap.get('CAEElec') != '') {
            CAE = Double.valueOf(inputMap.get('CAEElec'));
        }
        
        /*Recuperer les caracteristiques Gaz ou Elec*/
        String vPuissance = '';
        String vTypeComptage = '';
        String vCodePlageConso = '';
        if (vEnergyTypeOptions == 'Gaz') {
            vCodePlageConso = String.valueOf(inputMap.get('codePlageConso'));
        }

        if (vEnergyTypeOptions != 'Gaz') {
            vPuissance = String.valueOf(inputMap.get('Puissance'));
            //vTypeComptage = String.valueOf(inputMap.get('codeTypeComptage'));
            vCodePlageConso = String.valueOf(inputMap.get('codePlageConso'));
        }
        String niveauOuvertureService;
        String codeFTA;
        String lastModifFTA;
        String typedecompteur;
        String sellingOption = (inputMap.get('contexteSouscription')!=null && inputMap.get('contexteSouscription')!='')?String.valueOf(inputMap.get('contexteSouscription')):'MES_EMM';
        niveauOuvertureService = String.valueOf(inputMap.get('niveauOuvertureServices'));
        
        if(inputMap.get('dateDerniereModificationFormuleTarifaireAcheminement') != null){
            lastModifFTA = (String) inputMap.get('dateDerniereModificationFormuleTarifaireAcheminement');
        }
                
        if(inputMap.get('ftaCode') != null && inputMap.get('ftaCode') != 0){
            codeFTA = (String) inputMap.get('ftaCode');
        }
        // FT3-922
        if(inputMap.get('typeComptageDifferencie') != null){
            String typeComptageInput = (String) inputMap.get('typeComptageDifferencie');
            if (typeComptageInput.equalsIgnoreCase('SIMPLE')) {
                vTypeComptage = 'Simple';
            } else if (typeComptageInput.equalsIgnoreCase('HPHC')) {
                vTypeComptage = 'Double';
            } else {
                vTypeComptage = 'Triple';
            }
        }
        
        // if(inputMap.get('typeCompteur') != null){
        //     typedecompteur = (String) inputMap.get('typeCompteur');
        // }

        list<SM_TranscoTypeComptageStrucMesFour__mdt> listTrascoTypeCompt = [select StructureMesureFournisseur__c from SM_TranscoTypeComptageStrucMesFour__mdt where TypeComptage__c =:vTypeComptage];
        list<String> listStrucMesFour = new list<String>();
        for(SM_TranscoTypeComptageStrucMesFour__mdt transco : listTrascoTypeCompt){
            listStrucMesFour.add(transco.StructureMesureFournisseur__c);
        }
        List<Product2> offres;
        String idOffre = (String) inputMap.get('idOffre');
        String idOffre1 = (String) inputMap.get('idOffre1');
        String idOffre2 = (String) inputMap.get('idOffre2');
        String idpack = (String) inputMap.get('idPack');
        List<String> listOffresNew = new List<String>();
        if(idOffre != null && idOffre != '') {
            listOffresNew.add(idOffre);
        } else if (idOffre1 != null && idOffre1 != '' && idOffre2 != null && idOffre2 != '') {
            listOffresNew.add(idOffre1);
            listOffresNew.add(idOffre2);

        }
        List<String> listOffres = new List<String>();

        System.debug('listStrucMesFour');
        System.debug(listStrucMesFour);
        if (listStrucMesFour.size() != 0 && idOffre != null && idOffre != '') {
            offres = [SELECT id, TypeOffre__c, offreVerte__c, FamilyLabel__c,SM_structureMesureFournisseur__c, Family, ProductCode, vlocity_cmt__SpecificationType__c, ArticleURL__c, ArticlePreview__c
                      FROM Product2
                      WHERE  vlocity_cmt__Type__c = : vEnergyTypeOptions 
                         //AND IsActive = true 
                         AND SM_structureMesureFournisseur__c = :listStrucMesFour 
                         AND ProductCode = :idOffre];
        } else if(idOffre != null && idOffre != ''){
            offres = [SELECT id, TypeOffre__c, offreVerte__c, FamilyLabel__c,SM_structureMesureFournisseur__c, Family, ProductCode, vlocity_cmt__SpecificationType__c, ArticleURL__c, ArticlePreview__c
                      FROM Product2
                      WHERE  vlocity_cmt__Type__c = : vEnergyTypeOptions 
                         //AND IsActive = true 
                         AND ProductCode = :idOffre];
        } else if(listStrucMesFour.size() != 0 && idOffre1 != null && idOffre1 != '' && idOffre2 != null && idOffre2 != '' ) {
            offres = [SELECT id, TypeOffre__c, offreVerte__c, FamilyLabel__c,SM_structureMesureFournisseur__c, Family, ProductCode, vlocity_cmt__SpecificationType__c, ArticleURL__c, ArticlePreview__c
                        FROM Product2
                        WHERE /*IsActive = true 
                        AND */((SM_structureMesureFournisseur__c = :listStrucMesFour AND ProductCode = :idOffre1)
                        OR  ProductCode = :idOffre2)];
        } else {
            offres = [SELECT id, TypeOffre__c, offreVerte__c, FamilyLabel__c,SM_structureMesureFournisseur__c, Family, ProductCode, vlocity_cmt__SpecificationType__c, ArticleURL__c, ArticlePreview__c
                        FROM Product2
                        WHERE /*IsActive = true 
                        AND*/ (ProductCode = :idOffre1 OR ProductCode = :idOffre2)];
        }
        
        List<String> listOffresIds = new List<String>();
        Date todayDate = date.today();
        System.debug('offres');
        System.debug(offres);
        if (offres.size() > 0) {
			for(Product2 offre : offres){
				listOffresIds.add(offre.Id);
			}
            Set<String> setProductPoussesIds = new Set<String>();
            Set<String> setProductReplisIds = new Set<String>();
            List<Choix_Offre__c> listChoixOffres = new List<Choix_Offre__c>();
            // if(typedecompteur == 'LINKY'){
            //     listChoixOffres =  [SELECT Id, ChoixOffrerepli__c, ChoixOffrerepli__r.ProductCode,ChoixOffrePoussee__c,ChoixOffrePoussee__r.ProductCode,
            //                         ChoixOffrePousseeLinky__c,ChoixOffrePousseeLinky__r.ProductCode
            //                         FROM Choix_Offre__c
            //                         WHERE Energie__c = :vEnergyTypeOptions
            //                         AND Actif__c = true];
            // } else {
            listChoixOffres =  [SELECT Id, ChoixOffrerepli__c, ChoixOffrerepli__r.ProductCode,ChoixOffrePoussee__c,ChoixOffrePoussee__r.ProductCode,
                                ChoixOffrePousseeLinky__c,ChoixOffrePousseeLinky__r.ProductCode
                                FROM Choix_Offre__c
                                WHERE Energie__c = :vEnergyTypeOptions
                                AND Actif__c = true];
            // }
            
                                                         
			if(listChoixOffres.size()>0){
				for(Choix_Offre__c choixOffre : listChoixOffres){
					// if(typedecompteur == 'LINKY'){	
					// 	setProductPoussesIds.add(choixOffre.ChoixOffrePousseeLinky__r.ProductCode);					
					// }
					// else{
					setProductPoussesIds.add(choixOffre.ChoixOffrePoussee__r.ProductCode);
					// }
					setProductReplisIds.add(choixOffre.ChoixOffrerepli__r.ProductCode);
					
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
                // Construct a MAP that holds <CodeProduit, TypeOffre> to be used later to process TradeOff offres. 
                typeOfProduct.put(offre.ProductCode, offre.TypeOffre__c);
                if (mapPackOffres.get(offre.Family) != null) {
                    mapPackOffres.get(offre.Family).add(Offre.ProductCode);
                } else {
                    mapPackOffres.put(offre.Family, new List<String> {Offre.ProductCode});
                }
                    
                mapCodeOffresLibPack.put(offre.Family, offre.FamilyLabel__c);
                // Determine Offre Poussee
                if (setProductPoussesIds.contains(offre.ProductCode)) {
                    mapIsOffrePoussee.put(offre.ProductCode, true);
                } else {
                    mapIsOffrePoussee.put(offre.ProductCode, false);
                }
                // Determine Offre Repli
                if (setProductReplisIds.contains(offre.ProductCode)) {
                    mapIsOffreRepli.put(offre.ProductCode, true);
                } else {
                    mapIsOffreRepli.put(offre.ProductCode, false);
                }

                if(Offre.SM_structureMesureFournisseur__c != null){
                    mapProdFamStrucMesFourn.put(offre.Family, Offre.SM_structureMesureFournisseur__c); 
                }

                if(offre.offreVerte__c){
                    mapIsOffreVerte.put(offre.Family, offre.offreVerte__c);
               
                }
                Article article = new Article();
                article.url = offre.ArticleURL__c;
                article.preview = offre.ArticlePreview__c;
                mapArticle.put(offre.ProductCode, article);
            }
            
            List<String> listCodesOffres = new List<String>();
            listCodesOffres.addAll(mapCodeOffresLibPack.keySet());
            Map<String, Object> mapOffresEtPrix = new Map<String, Object>();
            
            /* US FT1-3663 --> recupérer les parametres Harmonica: L'ID du pack, le conext de moveIn, le code offre gaz et le code offre Elec */
            String contextMoveIn = (String) inputMap.get('moveinContext');
            String packCode = (String) inputMap.get('packCode');
            String codeOffreGaz = (String) inputMap.get('codeOffreGaz');
            String codeOffreElec = (String) inputMap.get('codeOffreElec');
            String datePropositionCommerciale = (String) inputMap.get('datePropositionCommerciale');
            
            List<PrixOffreConsolide> OffresEtPrix = getPrix(codeFTA,lastModifFTA, sellingOption, vCodeInsee, vCodePostal, mapPackOffres, mapCodeOffresLibPack, mapIsOffrePoussee,mapProdFamStrucMesFourn, vDateEffetSouhaitee, vCodePlageConso, vPuissance, vTypeComptage,niveauOuvertureService,CAR, CAE, mapArticle, mapIsOffreRepli,contextMoveIn,packCode,codeOffreGaz,codeOffreElec,datePropositionCommerciale, idpack, listOffresNew, vEnergyTypeOptions, mapIsOffreVerte);
            mapOffresEtPrix.put('OffreCatalogue', OffresEtPrix);
            mapOffresEtPrix.put('OffreChoisis', OffreChoisie); 
            outMap.putAll(mapOffresEtPrix);
        }
        System.debug('outMap: ' + outMap);
        return outMap;
    }
    
    /**
     * @Author: MBA
     * @Description: Récupération des valeurs du WS prix et remise et calcul des mens
     * @CreatedDate:
     * @LastModified: MHA 09/03/2020
     */
    public static List<PrixOffreConsolide> getPrix(String codeFTA,String lastModifFTA, String contSouscriptionCode,String codeCommune, String codePostal, Map<String, List<String>> mapPackOffres, Map<String, String> mapCodeOffresLibPack, Map<String, Boolean> mapIsOffrePoussee,Map<String,String> mapStrucmesfour,Datetime dateEffet, String plageconso, String vpuissance, String typeDeComptage,String niveauOuvertureService,Double CAR, Double CAE, Map<String, Article> mapArticle, Map<String, Boolean> mapisOffreRepli,String contextMoveIn,String packCode,String codeOffreGaz,String codeOffreElec, String datePropositionCommerciale, String idPack, List<String> listOffreNew, String typeEnergie, Map<String, Boolean> mapIsOffreVerte) {
        SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();
        List<gdfsuezBefCalypsoPrixetremisesv2.rechercherPrixEtRemisesInputDt> listInput = new List<gdfsuezBefCalypsoPrixetremisesv2.rechercherPrixEtRemisesInputDt>();
        gdfsuezComBefChpCommunV3.contextDt octx = initContext(octopusCS.appName__c, '1.00');
        // for (String pack : mapPackOffres.keyset()) {
            /*Contruction des parametres*/
            gdfsuezBefCalypsoPrixetremisesv2.rechercherPrixEtRemisesInputDt prixService = new gdfsuezBefCalypsoPrixetremisesv2.rechercherPrixEtRemisesInputDt();
            /*identifiantsLieuDt */
            gdfsuezBefCalypsoPrixetremisesv2.identifiantsLieuDt identifiantsLieu = new gdfsuezBefCalypsoPrixetremisesv2.identifiantsLieuDt();
            identifiantsLieu.codeCommune = codeCommune;
            identifiantsLieu.codePostal = codePostal;
            prixService.identifiantsLieu = identifiantsLieu;
            prixService.dateEffetContrat = dateEffet;
            //dateEffet;
            Date d = Date.ValueOf(datePropositionCommerciale.substring(0, 10));
            Datetime vdatePropositionCommerciale = Datetime.newInstanceGmt(d.year(), d.month(), d.day());
            prixService.datePropositionCommerciale = vdatePropositionCommerciale;
            prixService.dateValiditePrix = System.now();
            prixService.idPack = idPack;
            prixService.idOffre = listOffreNew;

            gdfsuezComBefChpCommunV3.listeValeursDt codeEnseigneSouscription = new gdfsuezComBefChpCommunV3.listeValeursDt();
            codeEnseigneSouscription.code = 'PPO';
            prixService.enseigneSouscription = codeEnseigneSouscription;
            
            gdfsuezComBefChpCommunV3.listeValeursDt contexteSouscription = new gdfsuezComBefChpCommunV3.listeValeursDt();
            contexteSouscription.code = contSouscriptionCode;
            prixService.contexteSouscription = contexteSouscription;
            
            /*Constution des caractistiques GAZ*/
            if (!String.isBlank(plageconso)) {
                gdfsuezBefCalypsoPrixetremisesv2.caracteristiquesOffreGazDt carGaz = new gdfsuezBefCalypsoPrixetremisesv2.caracteristiquesOffreGazDt();
                gdfsuezComBefChpCommunV3.listeValeursDt plageConsommation = new gdfsuezComBefChpCommunV3.listeValeursDt();
                plageConsommation.code = plageconso;
                carGaz.plageConsommation = plageConsommation;
                prixService.caracteristiquesOffreGaz = carGaz;
            }
            /*Constution des caractistiques ELEC*/
            if (!String.isBlank(vpuissance) || !String.isBlank(typeDeComptage)) {
                prixService.dateDerniereModificationFormuleTarifaireAcheminement = lastModifFTA;                
                gdfsuezComBefChpCommunV3.listeValeursDt formuleTarifaireAcheminement = new gdfsuezComBefChpCommunV3.listeValeursDt();
                formuleTarifaireAcheminement.code = codeFTA;
                prixService.formuleTarifaireAcheminement = formuleTarifaireAcheminement; 
                
                gdfsuezBefCalypsoPrixetremisesv2.caracteristiquesOffreElecDt carElec = new gdfsuezBefCalypsoPrixetremisesv2.caracteristiquesOffreElecDt();
                if (!String.isBlank(vpuissance) ) {
                    gdfsuezComBefChpCommunV3.listeValeursDt puissanceV = new gdfsuezComBefChpCommunV3.listeValeursDt();
                    puissanceV.code = vpuissance;
                    carElec.puissance = puissanceV;
                }

                if (mapIsOffreVerte.get(idPack)!= null) {
                    gdfsuezComBefChpCommunV3.listeValeursDt pourcentageOffreVerte = new gdfsuezComBefChpCommunV3.listeValeursDt();
                    pourcentageOffreVerte.code = '100';
                    carElec.pourcentageOffreVerte = pourcentageOffreVerte;
                }

                if(mapStrucmesfour.get(idPack) != null){
                    gdfsuezComBefChpCommunV3.listeValeursDt structureMesureFournisseur = new gdfsuezComBefChpCommunV3.listeValeursDt();
                    structureMesureFournisseur.code = mapStrucmesfour.get(idPack);
                    carElec.structureMesureFournisseur = structureMesureFournisseur;
                }
                if(CAE != null && CAE != 0){
                    carElec.CAEElec = CAE.intValue();
                }
                if(niveauOuvertureService != null && niveauOuvertureService != ''){
                    carElec.niveauOuvertureService = niveauOuvertureService;
                }
                prixService.caracteristiquesOffreElec = carElec;
            }
            
            
            listInput.add(prixService);
        // }
        gdfsuezBefCalypsoPrixetremisesv2.PrixEtRemisesPort prixRemiseService = new gdfsuezBefCalypsoPrixetremisesv2.PrixEtRemisesPort();
        prixRemiseService.clientCertName_x = octopusCS.certName__c;
        prixRemiseService.timeout_x = 30000;
        
        SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'PrixEtRemises_v2' limit 1];
        prixRemiseService.endpoint_x = 'callout:AuthOctopus' + suffixs.suffix__c;

        //prixRemiseService.endpoint_x = 'https://ensz18a1rn6k.x.pipedream.net/';
        //prixRemiseService.endpoint_x = octopusCS.endpoint__c + 'ES-PrixEtRemises_v2';
                 
        prixRemiseService.inputHttpHeaders_x = new Map<String, String> {'Content-Type' => 'text/xml;charset=utf-8'};
        gdfsuezBefCalypsoPrixetremisesv2.rechercherPrixEtRemisesResponse_element response = new gdfsuezBefCalypsoPrixetremisesv2.rechercherPrixEtRemisesResponse_element();
        // System.debug('### listInput '+ JSON.serialize(listInput));
        if (!Test.isRunningTest()) {
            response = prixRemiseService.RechercherPrixEtRemises(listInput, octx);
        } else {
            System.debug('@@ typeEnergie: ' + typeEnergie);
            Test.setMock(WebServiceMock.class, new SM_AP83_OffresEtPrixVue360Mock(typeEnergie));

            // if (typeEnergie != 'Elec') {
            //     Test.setMock(WebServiceMock.class, new SM_AP83_OffresEtPrixVue360Mock(typeEnergie));
            // } else {
            //     Test.setMock(WebServiceMock.class, new SM_AP11_OffresEtPrixMock());
            // }
            gdfsuezBefCalypsoPrixetremisesv2.PrixEtRemisesPort testObject = new gdfsuezBefCalypsoPrixetremisesv2.PrixEtRemisesPort();
            // system.debug('@@ start of mock');
            response = testObject.RechercherPrixEtRemises(listInput, octx);
            // system.debug('@@ end of mock' + response);
        }
        // system.debug('@@ response ' + JSON.serialize(response));
        
        List<PrixOffreConsolide> listOffreAvecPrix = new  List<PrixOffreConsolide>();
        Map<String, PrixOffreConsolide> mapLibelleParPix = new Map<String, PrixOffreConsolide>();
        
        if (response != null && response.messageRetours != null && response.messageRetours.messageRetour != null ) {
            for (gdfsuezComBefChpCommunV3.messageRetour_element msgRetour : response.messageRetours.messageRetour) {
                if ('ERREUR'.equalsIgnoreCase(msgRetour.type_x)) {
                    /*return null;*/
                }
            }
        }
        
        gdfsuezBefCalypsoPrixetremisesv2.rechercherPrixEtRemisesOutputDt[] rechercherPrixEtRemisesOutput = response.rechercherPrixEtRemisesOutput;
        // system.debug('@@ rechercherPrixEtRemisesOutput ' + JSON.serialize(rechercherPrixEtRemisesOutput));
        for (gdfsuezBefCalypsoPrixetremisesv2.rechercherPrixEtRemisesOutputDt donneesRetour : rechercherPrixEtRemisesOutput) {
            String packId;
            String packLibelle;
            // System.debug('@@ donneesRetour ' + JSON.serialize(donneesRetour));
            if (donneesRetour != null && donneesRetour.donneesPack != null && donneesRetour.donneesPack.idPack != null) {
                packId = donneesRetour.donneesPack.idPack;
                packLibelle = donneesRetour.donneesPack.libellePack;
            }
            if (donneesRetour != null && donneesRetour.donneesOffre != null) {
                gdfsuezBefCalypsoPrixetremisesv2.donneesOffreDt[] donneesOffre = donneesRetour.donneesOffre;
                for (gdfsuezBefCalypsoPrixetremisesv2.donneesOffreDt data : donneesOffre) {
                    System.debug('@@ data ' + JSON.serialize(donneesRetour));
                    String ftaOutput;
                    if(data.formuleTarifaireAcheminement != null){
                        ftaOutput =  data.formuleTarifaireAcheminement.code;
                        // System.debug('ftaOutput' + ftaOutput);
                    }
                   
                    gdfsuezBefCalypsoPrixetremisesv2.listePrixDt listePrix = data.listePrix;
                    // System.debug('listePrixDt: ' + JSON.serialize(listePrix));

                    if (listePrix != null) {
                        /*String jsonOut = JSON.serialize(listePrix);
                        system.debug('@@ json ' + jsonOut);*/
                        String libellePackDeLOffre = mapCodeOffresLibPack.get(packId);
                        // System.debug('libellePackDeLOffre' + libellePackDeLOffre);
                        Boolean isOffrePoussee = mapIsOffrePoussee.get(data.idOffre);
						Boolean isOffreRepli = mapIsOffreRepli.get(data.idOffre);
                        Article article = mapArticle.get(data.idOffre);
                        Map<String, Map<String, Double>> mapConsoByTypeComptage = new Map<String, Map<String, Double>>();
                        Map<String, Map<String, Double>> mapConsoGazByTypeComptage = new Map<String, Map<String, Double>>();
                        wrapperPrix prixElec = new wrapperPrix('Elec', Double.valueOf('0'), Double.valueOf('0'), mapConsoByTypeComptage);
                        wrapperPrix prixGaz = new wrapperPrix('Gaz', Double.valueOf('0'), Double.valueOf('0'), mapConsoGazByTypeComptage);
                        
                        for (gdfsuezBefCalypsoPrixetremisesv2.prixDt prix : listePrix.prix) {
 							System.debug('@@ prix: ' + JSON.serialize(prix));
                            
                            // System.debug('### aka prix.caracteristiquesGaz ' + prix.caracteristiquesGaz);
                            /*   System.debug('### aka prix.caracteristiquesGaz.plageconsommation ' + prix.caracteristiquesGaz.plageconsommation);
                            System.debug('### aka prix.caracteristiquesGaz.typePrix.code ' + prix.caracteristiquesGaz.typePrix.code);
                             System.debug('### aka typeOfProduct.get(data.idOffre) ' + typeOfProduct.get(data.idOffre));*/
                            
                            // Si l'offre NON TRADEOFF contient des caracteristique GAZ je recupere les prix de l'ABO et de la CONS*/
                            System.debug('@@ typeProduct: ' + typeOfProduct.get(data.idOffre));
                            System.debug('@@ caracGaz: ' + typeOfProduct.get(data.idOffre));
                        
                            if (prix.caracteristiquesGaz != null && prix.caracteristiquesGaz.typePrix!= null && prix.caracteristiquesGaz.plageconsommation != null
                                && typeOfProduct.get(data.idOffre) != 'TradeOFF'
                                && (prix.caracteristiquesGaz.typePrix.code == 'AB' || prix.caracteristiquesGaz.typePrix.code == 'CO')) {
                                    // System.debug('@@ prix.caracteristiquesGaz: ' + JSON.serialize(prix.caracteristiquesGaz.typePrix));
                                    // System.debug('@@ prix.caracteristiquesGaz.code: ' + JSON.serialize(prix.caracteristiquesGaz.typePrix.code));
                                    // System.debug('@@ prix.caracteristiquesGaz.montantHT: ' + JSON.serialize(prix.montantHT));
                                    // System.debug('@@ prix.caracteristiquesGaz.montantTTC: ' + JSON.serialize(prix.montantTTC));
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
                            /*Si l'offre TRADEOFF contient des caracteristique GAZ je recupere les prix de l'ABO et de la CONS*/
                            }else if(prix.caracteristiquesGaz != null && prix.caracteristiquesGaz.typePrix != null 
                            && prix.caracteristiquesGaz.plageconsommation != null
                            && typeOfProduct.get(data.idOffre) == 'TradeOFF'){
                                    System.debug('@@ prix.caracteristiquesGaz: ' + JSON.serialize(prix.caracteristiquesGaz.typePrix));
                                    System.debug('@@ prix.caracteristiquesGaz.code: ' + JSON.serialize(prix.caracteristiquesGaz.typePrix.code));
                                    System.debug('@@ prix.caracteristiquesGaz.montantHT: ' + JSON.serialize(prix.montantHT));
                                    System.debug('@@ prix.caracteristiquesGaz.montantTTC: ' + JSON.serialize(prix.montantTTC));
                                    if(prix.caracteristiquesGaz.typePrix.code == 'TOTAB'){
                                        prixGaz.AboTTC = prix.montantTTC;
                                        prixGaz.AboHT = prix.montantHT;
                                    }
                                    if(prix.caracteristiquesGaz.typePrix.code == 'TOTCO'){
                                        prixGaz.CoTTC = prix.montantTTC;
                                        prixGaz.CoHT = prix.montantHT;
                                        Map<String, Double> montants = new Map<String, Double>();
                                        montants.put('TTC', prix.montantTTC);
                                        montants.put('HT', prix.montantHT);
                                        mapConsoGazByTypeComptage.put('consoGaz', montants);
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
                            
                            // Si l'offre NON TRADEOFF contient des caracteristique ELEC je recupere les prix de l'ABO et de la CONS*/
                            if (prix.caracteristiquesElec != null && prix.caracteristiquesElec.typePrix != null && prix.caracteristiquesElec.puissance != null 
                             && typeOfProduct.get(data.idOffre) != 'TradeOFF' && prix.caracteristiquesElec.typeComptage != null
                             && (prix.caracteristiquesElec.typePrix.code == 'AB' || prix.caracteristiquesElec.typePrix.code == 'CO')) {
                                // System.debug('@@ prix.caracteristiquesElec: ' + JSON.serialize(prix.caracteristiquesElec.typePrix));
                                // System.debug('@@ prix.caracteristiquesElec.code: ' + JSON.serialize(prix.caracteristiquesElec.typePrix.code));
                                // System.debug('@@ prix.caracteristiquesElec.montantHT: ' + JSON.serialize(prix.montantHT));
                                // System.debug('@@ prix.caracteristiquesElec.montantTTC: ' + JSON.serialize(prix.montantTTC));
                                Double montantHT = prix.montantHT;
                                Double montantTTC = prix.montantTTC;
                                if (prix.caracteristiquesElec.typePrix.code == 'AB') {
                                    //aboElec=String.valueOf(Decimal.valueOf(montantTTC).setscale(2))+ ' €/an TTC ('+String.valueOf(Decimal.valueOf(montantHT).setscale(2))+' HT)';
                                    prixElec.AboTTC = montantTTC;
                                    prixElec.AboHT = montantHT;
                                }
                                
                                if (prix.caracteristiquesElec.typePrix.code == 'CO' && prix.caracteristiquesElec.typeComptage != null
                                 && !mapConsoByTypeComptage.keyset().contains(prix.caracteristiquesElec.typeComptage.libelleCourt)) {
                                    Map<String, Double> montants = new Map<String, Double>();
                                    montants.put('TTC', montantTTC);
                                    montants.put('HT', montantHT);
                                    mapConsoByTypeComptage.put(prix.caracteristiquesElec.typeComptage.code, montants);
                                    // consoElec=String.valueOf(Decimal.valueOf(montantTTC).setscale(2))+ ' €/kWh TTC ('+String.valueOf(Decimal.valueOf(montantHT).setscale(5))+' HT)';
                                    prixElec.mapConsoByType = mapConsoByTypeComptage;
                                }
                            // Si l'offre TRADEOFF contient des caracteristique ELEC je recupere les prix de l'ABO et de la CONS
                            } else if(prix.caracteristiquesElec != null && prix.caracteristiquesElec.typePrix != null 
                            && prix.caracteristiquesElec.puissance != null
                            && typeOfProduct.get(data.idOffre) == 'TradeOFF'){
                                System.debug('@@ prix.caracteristiquesElec: ' + JSON.serialize(prix.caracteristiquesElec.typePrix));
                                System.debug('@@ prix.caracteristiquesElec.code: ' + JSON.serialize(prix.caracteristiquesElec.typePrix.code));
                                System.debug('@@ prix.caracteristiquesElec.montantHT: ' + JSON.serialize(prix.montantHT));
                                System.debug('@@ prix.caracteristiquesElec.montantTTC: ' + JSON.serialize(prix.montantTTC));
                                if (prix.caracteristiquesElec.typePrix.code == 'CO' && prix.caracteristiquesElec.typeComptage != null) {
                                    Map<String, Double> montants = new Map<String, Double>();
                                    montants.put('TTC', prix.montantTTC);
                                    montants.put('HT', prix.montantHT);
                                    mapConsoByTypeComptage.put('CO'+prix.caracteristiquesElec.typeComptage.code, montants);
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
                                }
                                if(prix.caracteristiquesElec.typePrix.code == 'AB'){
                                    Map<String, Double> montants = new Map<String, Double>();
                                    montants.put('TTC', prix.montantTTC);
                                    montants.put('HT', prix.montantHT);
                                    mapConsoByTypeComptage.put('AB', montants);
                                }
                                if(prix.caracteristiquesElec.typePrix.code == 'OB'){
                                    Map<String, Double> montants = new Map<String, Double>();
                                    montants.put('TTC', prix.montantTTC);
                                    montants.put('HT', prix.montantHT);
                                    mapConsoByTypeComptage.put('OB', montants);
                                }
                                if (prix.caracteristiquesElec.typePrix.code == 'ACHCO' 
                                 && prix.caracteristiquesElec.typeComptage != null) {
                                    Map<String, Double> montants = new Map<String, Double>();
                                    montants.put('TTC', prix.montantTTC);
                                    montants.put('HT', prix.montantHT);
                                    mapConsoByTypeComptage.put(prix.caracteristiquesElec.typeComptage.code, montants);
                                }
                                prixElec.mapConsoByType = mapConsoByTypeComptage;    
                            }

                        }                        
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
                            mapLibelleParPix.put(libellePackDeLOffre, offreValue );
                        } 
                        else {
                            PrixOffreConsolide offreNouveauInit = new PrixOffreConsolide(libellePackDeLOffre,
                                                                                         data.idOffre,
                                                                                         isOffrePoussee,
                                                                                         packId,
                                                                                         mapPackOffres.get(packId),
                                                                                         prixELec,
                                                                                         prixGaz,
                                                                                         CAR,
                                                                                         CAE,
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
                                offreExistant.consoGaz = offreNouveauInit.consoGaz;
                                if (offreExistant.mensGaz == null) {
                                    mensGazValue = 0;
                                } else {
                                    mensGazValue = Double.valueOf(offreExistant.mensGaz);
                                }
                            }
                            
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
        
        // system.debug('@@@ mapOffrePrix json ' + JSON.serialize(listOffreAvecPrix));
        return listOffreAvecPrix;
    }
    
    /**
     * @Author: RWA
     * @Description: model du wrapper
     * @CreatedDate:
     * @LastModified: RWA
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
        
        /**
         * @Author: RWA
         * @Description: constructeur du wrapper
         * @CreatedDate:
         * @LastModified: MHA 22/02/2019
         */
        public wrapperPrix(String typeEnergie, Double AboTTC, Double AboHT, Map<String, Map<String, Double>>  mapConsoByType) {
            this.typeEnergie = typeEnergie;
            this.AboTTC = AboTTC;
            this.AboHT = AboHT;
            this.mapConsoByType = mapConsoByType;
        }
    }
    
    /**
     * @Author: Joel
     * @Description : vérifier l'éligilité à une offre
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
    
    /**
     * @Author: MBA
     * @Description: model des offres consolidées
     * @CreatedDate:
     * @LastModified: MHA 26/05/20
     */
    public class PrixOffreConsolide {
        @AuraEnabled
        public String libelleOffre;
        @AuraEnabled
        public String codeOffre;
        @AuraEnabled
        public String idPack;
        @AuraEnabled
        public List<String> idOffreList;
        @AuraEnabled
        public String aboElec;
        @AuraEnabled
        public Map<String, String> mapConsoByTypeComptage = new Map<String, String>();
        @AuraEnabled
        public String mens;
        @AuraEnabled
        public String aboGaz;
        @AuraEnabled
        public Map<String, String> mapConsoGazByTypeComptage = new Map<String, String>();
        @AuraEnabled
        public String mensGaz;
        @AuraEnabled
        public String mensTotal;
        @AuraEnabled
        public Boolean isOffrePoussee;
        @AuraEnabled
        public Boolean isOffrePousseeHarmonica;
        @AuraEnabled
        public Boolean isOffreRepli;
        @AuraEnabled
        public Double CAR;
        @AuraEnabled
        public Double CAE;
        @AuraEnabled
        public String typeOffre;
        @AuraEnabled
        public String consoElec;
        @AuraEnabled
        public String consoGaz;
        @AuraEnabled
        public String articleURL;
        @AuraEnabled
        public String articlePreview;
        @AuraEnabled
        public String ftaOutput;
        
        /**
         * @Author: RWA
         * @Description: constructeur des offres consolidées
         * @CreatedDate:
         * @LastModified: MBA 07/04/2020
         */
        public PrixOffreConsolide(String libelleOffre, String codeOffre, Boolean isOffrePoussee, String idPack, List<String> idOffreList,
                                    wrapperPrix prixELec, wrapperPrix prixGaz, Double CAR, Double CAE, Article article, String ftaOutput, Boolean isOffreRepli) {
            
            this.codeOffre = codeOffre;
            this.libelleOffre = libelleOffre;
            this.isOffrePoussee = isOffrePoussee;
            this.idPack = idPack;
            this.idOffreList = idOffreList;
            this.CAR = CAR;
            this.CAE = CAE;
            this.typeOffre = typeOfProduct.get(codeOffre);
            // System.debug('@ idPack , article.url = '+idPack+' , '+article);
            if (article != null) {
                this.articleURL = article.url;
                this.articlePreview = article.preview;
            } else {
                this.articleURL = null;
                this.articlePreview = null;
            }
            
            this.ftaOutput = ftaOutput;
            this.isOffreRepli = isOffreRepli;
            if (Double.valueOf('0') == prixELec.AboTTC) {
                this.aboElec = null;
                this.mens = null;
            } else {
                this.aboElec = String.valueOf(Decimal.valueOf(prixELec.AboTTC).setscale(2)) + ' € TTC (' + String.valueOf(Decimal.valueOf(prixELec.AboHT).setscale(2)) + ' HT)';
                Map<String, Map<String, Double>> mapConsoByType = prixELec.mapConsoByType;
                List<Double> listConsoTTC = new List<Double>();
                for (String consLabel : mapConsoByType.keySet()) {
                    Map<String, Double> montants = mapConsoByType.get(consLabel);
                    String consValue = String.valueOf(Decimal.valueOf(montants.get('TTC')).setscale(5)) + ' € TTC/kWh (' + String.valueOf(Decimal.valueOf(montants.get('HT')).setscale(5)) + ' HT)';
                    String consolLabelTransc;
                    String consolwardingTransc = null;
                    if (consLabel == 'P') {
                        consolLabelTransc = 'HP';
                    } else if (consLabel == 'C') {
                        consolLabelTransc = 'HC';
                    } else if(consLabel == 'WE'){
                        consolLabelTransc = consLabel;
                    }else if (consLabel == 'S' /*&& typeOfProduct.get(codeOffre) == 'TradeOFF'*/){
                        //MEP 25
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
                        consolwardingTransc = 'HP Haute';
                        
                    }else if (consLabel == 'A'){
                        consolLabelTransc = 'HCH';
                        consolwardingTransc = 'HC Haute';
                        
                    }else if (consLabel == 'L'){
                        consolLabelTransc = 'HPB';
                        consolwardingTransc = 'HP Basse';
                        
                    }else if (consLabel == 'R'){
                        consolLabelTransc = 'HCB';
                        consolwardingTransc = 'HC Basse';
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

                    if(consolwardingTransc == null || consolwardingTransc == '') {
                        consolwardingTransc = consolLabelTransc;
                    }
                    mapConsoByTypeComptage.put(consolLabelTransc, consolwardingTransc + ': ' + consValue);
                    /*listConsoTTC.add(montants.get('TTC'));*/
                }
                                                    
                if(typeOfProduct.get(codeOffre) == 'TradeOFF'){
                    this.mens = String.ValueOf(calculMensTradeOFF(Double.valueOf(prixELec.AboTTC),Double.valueOf(prixELec.coTTC), this.CAE));
                    if (prixELec.coTTC != null && prixELec.CoHT != null) {
                        this.consoElec = 'PRIX PAR kWh '+Decimal.valueOf(prixELec.coTTC).setscale(5)+' € TTC/kWh'+' ('+Decimal.valueOf(prixELec.CoHT).setscale(5) + ' HT)';
                    } else {
                        this.consoElec = 'PRIX PAR kWh '+prixELec.coTTC+' € TTC/kWh'+' ('+prixELec.CoHT + ' HT)';
                    }
                }
                // else{
                //     this.mens = String.ValueOf(calculMens( Double.valueOf(prixELec.AboTTC), listConsoTTC, this.CAE));
                // }
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
                        consolLabelTransc = 'Acheminement_abo'; // abonement gaz
                        consValueGaz = String.valueOf(Decimal.valueOf(montants.get('TTC')).setscale(2)) + ' € TTC/an (' + String.valueOf(Decimal.valueOf(montants.get('HT')).setscale(2)) + ' HT)';
                    }else if(consLabel == 'AB'){
                        consolLabelTransc = 'Fourniture_abo';// abonement gaz
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
                    if (prixELec.coTTC != null && prixELec.CoHT != null) {
                        this.consoGaz = 'PRIX PAR kWh '+Decimal.valueOf(prixGaz.coTTC).setscale(5)+' € TTC/kWh'+' ('+Decimal.valueOf(prixGaz.CoHT).setscale(5) + ' HT)';
                    } else {
                        this.consoGaz = 'PRIX PAR kWh '+prixGaz.coTTC+' € TTC/kWh'+' ('+prixGaz.CoHT + ' HT)';
                    }                                     
                }
                // else{
                //     this.mensGaz = String.ValueOf(calculMens( Double.valueOf(prixGaz.AboTTC), listConsoTTCGaz, this.CAR));
                // } 
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
        }
    }
    

    /**
     * @Author: RWA
     * @Description: initialisation du contexte
     * @CreatedDate:
     * @LastModified: MHA 22/02/2019
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
    
    /**
     * @Author: RWA
     * @Description: calcul de la mens
     * @CreatedDate:
     * @LastModified: MHA 05/03/2019
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
    
    /**
     * @Author: MHA
     * @Description: calcul Consommation
     * @CreatedDate: 05/03/2019
     * @LastModified: MHA 05/03/2019
     */
    public static Decimal calculConsommation(Double consoByCAECAR, Double CARCAE) {
        Double consoByCAECARResult = 0;
        consoByCAECARResult = consoByCAECAR * CARCAE;
        return Decimal.valueOf(consoByCAECARResult).setscale(5);
    }

    public class Article {
        public String url;
        public String preview;
    }
    
}