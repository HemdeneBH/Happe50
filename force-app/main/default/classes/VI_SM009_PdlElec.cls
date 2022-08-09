/*
*@Author: Paul Ghousoub
*@Description: Appel de PdlElec
*@CreatedDate: 27/10/2020
*@LastModified: 27/10/2020
*/
public class VI_SM009_PdlElec {
    public static VI_UTIL006_Cache_Management service = new VI_UTIL006_Cache_Management();
    
    public static gdfsuezComBefChpPivot.contextDt initContext(String application, String version) {
        return VI_UTIL005_OctopusCalloutUtils.initContext(application,version, false );
    }
    
    public static gdfsuezBefCalypsoPdlelectriciteV3.Dependency initPort(String NamedCredentialName) {
        gdfsuezBefCalypsoPdlelectriciteV3.Dependency port = new gdfsuezBefCalypsoPdlelectriciteV3.Dependency();
        port.endpoint_x = NamedCredentialName + '/ES-PDLElec_v3';
        port.inputHttpHeaders_x = new Map < String, String > {
            'Content-Type' => 'text/xml;charset=utf-8'
                };
                    return port;
    }
    
    public static gdfsuezBefCalypsoPdlelectriciteV3.PDLElectricite_element createElement(String idPDLElectricite, Boolean autorisationClient, Boolean contratConcluNouveauClientSurSite){
        gdfsuezBefCalypsoPdlelectriciteV3.PDLElectricite_element element = new gdfsuezBefCalypsoPdlelectriciteV3.PDLElectricite_element();
        element.PDLElectricite = new gdfsuezComBefCalypsoPdlelectricite.PDLElectriciteAbstract();
        element.PDLElectricite.idPDLElectricite = idPDLElectricite ;//'01199999844520' ;
        if(autorisationClient!= null || contratConcluNouveauClientSurSite!= null){
            gdfsuezBefCalypsoPdlelectriciteV3.accordFournisseurNonTitulaire_element elementAccordFournisseurNonTitulaire = new gdfsuezBefCalypsoPdlelectriciteV3.accordFournisseurNonTitulaire_element();
            if(autorisationClient!= null){
                elementAccordFournisseurNonTitulaire.autorisationClient= autorisationClient;
            }
            if(contratConcluNouveauClientSurSite!= null){
                elementAccordFournisseurNonTitulaire.contratConcluNouveauClientSurSite = contratConcluNouveauClientSurSite;
            }
        }
        return element;
    }
    public static gdfsuezBefCalypsoPdlelectriciteV3.lirePDLElectriciteInputDt createInput(Boolean online, String loginUtilisateur, String typeOffre,Boolean historiqueConsommations, gdfsuezBefCalypsoPdlelectriciteV3.PDLElectricite_element[] PDLElectricite){
        gdfsuezBefCalypsoPdlelectriciteV3.lirePDLElectriciteInputDt input = new gdfsuezBefCalypsoPdlelectriciteV3.lirePDLElectriciteInputDt();
        input.online = online;
        input.loginUtilisateur = loginUtilisateur;
        input.typeOffre = VI_UTIL005_OctopusCalloutUtils.initValue(typeOffre);
        input.PDLElectricite = PDLElectricite;
        input.historiqueConsommations = historiqueConsommations;
        return input;
    }
    
    public static gdfsuezBefCalypsoPdlelectriciteV3.lirePDLElectriciteResponse_element LirePDL(String pdlElc,Boolean autorisationClient, Boolean contratConcluNouveauClientSurSite, Boolean online, String loginUtilisateur, String typeOffre,Boolean historiqueConsommations, String application, String version,String NamedCredentialName){
        gdfsuezComBefChpPivot.contextDt octx = VI_UTIL005_OctopusCalloutUtils.initContext(application,version, false );
        gdfsuezBefCalypsoPdlelectriciteV3.Dependency port = initPort(NamedCredentialName);
        gdfsuezBefCalypsoPdlelectriciteV3.PDLElectricite_element[] PDLElectricite = new gdfsuezBefCalypsoPdlelectriciteV3.PDLElectricite_element[] {createElement(pdlElc,autorisationClient, contratConcluNouveauClientSurSite)};
            gdfsuezBefCalypsoPdlelectriciteV3.lirePDLElectriciteInputDt input = createInput(online, loginUtilisateur, typeOffre,historiqueConsommations, PDLElectricite);
        gdfsuezBefCalypsoPdlelectriciteV3.lirePDLElectriciteResponse_element response;
        if (!Test.isRunningTest()) {
            response = port.LirePDLElectricite(input, octx);
            system.debug('response '+response);
        } else {
            Test.setMock(WebServiceMock.class, new SM_AP13_PdlElecMock());
            gdfsuezBefCalypsoPdlelectriciteV3.Dependency porttest = new gdfsuezBefCalypsoPdlelectriciteV3.Dependency();
            system.debug('@@ start of mock');
            response = porttest.LirePDLElectricite(input, octx);
            system.debug('@@ end of mock');
        }
        return response;
    }
    
    public static pdlInfo lirePdl(String pdlElc, String application, String version,String NamedCredentialName){
        gdfsuezBefCalypsoPdlelectriciteV3.lirePDLElectriciteResponse_element response = LirePDL(pdlElc,true, null, true, 'homologation@engie.com', 'INDUSTRIELLE',true, application,version,NamedCredentialName);       
        if (response != null && response.lirePDLElectriciteOutput != null) {
            if (response.lirePDLElectriciteOutput.donneesPDL != null) {
                pdlInfo pdlElecInfo = parseResponse(response.lirePDLElectriciteOutput.donneesPDL[0]);
                return pdlElecInfo;
            }
            return null;
        }
        return null;
    }
    public Static pdlInfo parseResponse(gdfsuezComBefCalypsoPdlelectricite.PDLElectricite donneesPDL){
        pdlInfo pdlElecInfo = new pdlInfo(donneesPDL.idPDLElectricite, 'Elec', 'A initier');
        String natureIndexPublies,natureIndexCodePublies,indexBasePublies,indexHPPublies,indexHCPublies;
        String natureIndexReleve,natureIndexReleveCode,indexBaseReleve,indexHPReleve,indexHCReleve ;
        datetime dateDernierIndex, dateDernierIndexPublies;
        gdfsuezComBefCalypsoPdlelectricite.cAEParCadran_element cAEParCadran;
        gdfsuezComBefChpDistributeurelectric.quantiteSansDecimalDt cAEGlobale;
        parseSituationContractuelle(pdlElecInfo, donneesPDL.situationContractuelle);
        parseDonneesGenerales(pdlElecInfo, donneesPDL.donneesGenerales);
        parseSituationComptage(pdlElecInfo, donneesPDL.situationComptage );
        parseDerniersIndexReleves(dateDernierIndex,natureIndexReleve,natureIndexReleveCode,indexBaseReleve, 
                                  indexHPReleve, indexHCReleve, donneesPDL.derniersIndexReleves);
        parsehistoriqueMesures( pdlElecInfo,dateDernierIndex, dateDernierIndexPublies,natureIndexPublies, natureIndexCodePublies,
                               indexBasePublies, indexHPPublies,indexHCPublies, donneesPDL.historiqueMesures);
        IndexInfo indexObject  = getIndex( dateDernierIndex , natureIndexReleve , natureIndexReleveCode ,
                                          indexBaseReleve , indexHPReleve ,indexHCReleve , dateDernierIndexPublies ,
                                          natureIndexPublies, natureIndexCodePublies,  indexBasePublies, indexHPPublies, 
                                          indexHCPublies ) ;
        parseSituationAlimentation(pdlElecInfo, donneesPDL.situationAlimentation);
        object x;
        pdlElecInfo.autoreleve = VI_UTIL002_Utilities.processAutoReleve(donneesPDL, x, pdlElecInfo.etatPdl, pdlElecInfo.typeCompteur, pdlElecInfo.situationContractuelle, pdlElecInfo.niveauOuvertureServices);
        parseIndex(pdlElecInfo, indexObject);
        return pdlElecInfo;
    }
    
    public static void parseSituationAlimentation(pdlInfo pdlElecInfo, List <gdfsuezComBefCalypsoPdlelectricite.situationAlimentation_element> situationAlimentation){
        pdlElecInfo.etatCompteur = 'non coupe' ; // si balises non remonté 
        if (situationAlimentation != null){
            If(situationAlimentation[0].limitation != null && situationAlimentation[0].limitation.puissanceLimitee != null) {
                pdlElecInfo.puissancelimitee = String.valueOf(situationAlimentation[0].limitation.puissanceLimitee.valeur);
            }
            if (situationAlimentation[0].etatAlimentation != null &&  !String.isBlank(situationAlimentation[0].etatAlimentation.code)  ) {
                if(situationAlimentation[0].etatAlimentation.code.equals('ALIM')){
                    pdlElecInfo.etatCompteur = 'non coupe' ;
                }
                if( ! situationAlimentation[0].etatAlimentation.code.equals('LIMI') && ! situationAlimentation[0].etatAlimentation.code.equals('ALIM')     ){
                    pdlElecInfo.etatCompteur = 'coupe' ;
                }
                if( situationAlimentation[0].etatAlimentation.code.equals('LIMI')){
                    pdlElecInfo.etatCompteur ='non coupe' ;  
                }
                if( situationAlimentation[0].etatAlimentation.code.equals('NRAC')){
                    pdlElecInfo.etatCompteur ='première MES' ;  
                }
            }
        }
    }
    public static void parsehistoriqueMesures( pdlInfo pdlElecInfo,DateTime dateDernierIndex, DateTime dateDernierIndexPublies, String natureIndexPublies,
                                              String natureIndexCodePublies,String indexBasePublies, String indexHPPublies,String indexHCPublies,
                                              gdfsuezComBefCalypsoPdlelectricite.historiqueMesures_element historiqueMesures){
                                                  pdlElecInfo.dateDernierIndex = dateDernierIndex;
                                                  if ( historiqueMesures != null){ 
                                                      if( historiqueMesures.derniersIndexPublies != null&& historiqueMesures.derniersIndexPublies.programmationFournisseur != null &&
                                                         historiqueMesures.derniersIndexPublies.programmationFournisseur.mesuresIndex != null  && historiqueMesures.derniersIndexPublies.programmationFournisseur.mesuresIndex.mesureIndex != null ) {
                                                             if(dateDernierIndex == null ||  historiqueMesures.derniersIndexPublies.date_x >  dateDernierIndex) {
                                                                 dateDernierIndexPublies = historiqueMesures.derniersIndexPublies.date_x;
                                                                 natureIndexPublies =   historiqueMesures.derniersIndexPublies.nature.libelleCourt;
                                                                 natureIndexCodePublies =  historiqueMesures.derniersIndexPublies.nature.code;
                                                                 for(gdfsuezComBefCalypsoPdlelectricite.mesureIndex_element mesureIndex :  historiqueMesures.derniersIndexPublies.programmationFournisseur.mesuresIndex.mesureIndex){
                                                                     if(mesureIndex.mesureIndex != null &&  mesureIndex.mesureIndex.code != null &&  mesureIndex.mesureIndex.code.equals('BASE')){
                                                                         indexBasePublies = String.valueOf(mesureIndex.indexes[0].index.valeur);                             
                                                                     }else if(mesureIndex.mesureIndex != null &&  mesureIndex.mesureIndex.code != null &&  mesureIndex.mesureIndex.code.equals('HP')){
                                                                         indexHPPublies = String.valueOf(mesureIndex.indexes[0].index.valeur);
                                                                     }else if(mesureIndex.mesureIndex != null &&  mesureIndex.mesureIndex.code != null &&  mesureIndex.mesureIndex.code.equals('HC')){
                                                                         indexHCPublies = String.valueOf( mesureIndex.indexes[0].index.valeur);
                                                                     }
                                                                 }
                                                             }
                                                         }
                                                      
                                                      if (historiqueMesures.consommations != null ) {
                                                          pdlElecInfo.cAEParCadran  = historiqueMesures.consommations.cAEParCadran;
                                                          // mise en place  de la récupération de CAE HP, HC et WE
                                                          if (pdlElecInfo.cAEParCadran != null && pdlElecInfo.cAEParCadran.cadran != null) {
                                                              List<gdfsuezComBefCalypsoPdlelectricite.cadran_element>cadrans = pdlElecInfo.cAEParCadran.cadran;
                                                              for (gdfsuezComBefCalypsoPdlelectricite.cadran_element cadran : cadrans) {
                                                                  String codeCadran = String.valueOf(cadran.codeCadran.code);
                                                                  Integer valueCadran = Integer.valueOf(cadran.cAE.valeur);
                                                                  if (codeCadran == 'HC') {
                                                                      pdlElecInfo.cAE_HC = valueCadran;
                                                                  }
                                                                  if (codeCadran == 'HP') {
                                                                      pdlElecInfo.cAE_HP = valueCadran;
                                                                  }
                                                                  if (codeCadran == 'WE') {
                                                                      pdlElecInfo.cAE_WE = valueCadran;
                                                                  }
                                                              }
                                                          }
                                                          pdlElecInfo.cAEGlobale  = historiqueMesures.consommations.cAEGlobale;
                                                      }
                                                  }
                                              }
    
    public static void parseDerniersIndexReleves( Datetime dateDernierIndexReleve, String natureIndexReleve, String natureIndexReleveCode, 
                                                 String indexBaseReleve, String indexHPReleve, String indexHCReleve,
                                                 List<gdfsuezComBefCalypsoPdlelectricite.derniersIndexReleves_element> derniersIndexReleves){
                                                     if (derniersIndexReleves != null && derniersIndexReleves[0]!= null){
                                                         dateDernierIndexReleve = derniersIndexReleves[0].date_x;
                                                         if(derniersIndexReleves[0].nature!=null){
                                                             natureIndexReleve =   derniersIndexReleves[0].nature.libelleCourt;
                                                             natureIndexReleveCode =   derniersIndexReleves[0].nature.code;
                                                         }
                                                         if(derniersIndexReleves[0].programmationFournisseur != null && derniersIndexReleves[0].programmationFournisseur.mesuresIndex != null  && derniersIndexReleves[0].programmationFournisseur.mesuresIndex.mesureIndex != null ) { 
                                                             for(gdfsuezComBefCalypsoPdlelectricite.mesureIndex_element mesureIndex :  derniersIndexReleves[0].programmationFournisseur.mesuresIndex.mesureIndex){
                                                                 if(mesureIndex.mesureIndex != null &&  mesureIndex.mesureIndex.code != null &&  mesureIndex.mesureIndex.code.equals('BASE')){
                                                                     indexBaseReleve = String.valueOf(mesureIndex.indexes[0].index.valeur);                             
                                                                 }else if(mesureIndex.mesureIndex != null &&  mesureIndex.mesureIndex.code != null &&  mesureIndex.mesureIndex.code.equals('HP')){
                                                                     indexHPReleve = String.valueOf(mesureIndex.indexes[0].index.valeur);
                                                                 }else if(mesureIndex.mesureIndex != null &&  mesureIndex.mesureIndex.code != null &&  mesureIndex.mesureIndex.code.equals('HC')){
                                                                     indexHCReleve = String.valueOf( mesureIndex.indexes[0].index.valeur);
                                                                 }
                                                             }
                                                         }
                                                     } 
                                                 }
    public static void parseSituationComptage( pdlInfo pdlElecInfo, List<gdfsuezComBefCalypsoPdlelectricite.situationComptage_element> situationComptage ){
        pdlElecInfo.situationCompteur = null;
        if (situationComptage != null && situationComptage[0]!= null){
            if(situationComptage[0].dispositifComptage != null) {
                if (situationComptage[0].dispositifComptage.compteurs != null && situationComptage[0].dispositifComptage.compteurs.compteur!= null && situationComptage[0].dispositifComptage.compteurs.compteur.size()>0){
                    if(situationComptage[0].dispositifComptage.compteurs.compteur[0]  != null ) {
                        system.debug('pdlElecInfo.acessibilite = situationComptage[0].dispositifComptage.compteurs.compteur '+ situationComptage[0].dispositifComptage.compteurs.compteur );
                        system.debug('pdlElecInfo.acessibilite = situationComptage[0].dispositifComptage.compteurs.compteur[0] '+situationComptage[0].dispositifComptage.compteurs.compteur[0] );
                        system.debug('matricule '+ situationComptage[0].dispositifComptage.compteurs.compteur[0].matricule );
                        if(situationComptage[0].dispositifComptage.compteurs.compteur[0].accessibilite != null){
                            pdlElecInfo.acessibilite = situationComptage[0].dispositifComptage.compteurs.compteur[0].accessibilite ? 'Accessible' : 'Non accesssible';
                        }
                        if(situationComptage[0].dispositifComptage.compteurs.compteur[0].matricule != null){
                            pdlElecInfo.matricule = situationComptage[0].dispositifComptage.compteurs.compteur[0].matricule;
                        }
                        if(situationComptage[0].dispositifComptage.compteurs.compteur[0].periodeDeploiementLinky != null){
                            pdlElecInfo.periodeDeDeploiement= situationComptage[0].dispositifComptage.compteurs.compteur[0].periodeDeploiementLinky  ;
                        }
                        if (situationComptage[0].dispositifComptage.compteurs.compteur[0].modeleCompteur != null && situationComptage[0].dispositifComptage.compteurs.compteur[0].modeleCompteur.nbRoues != null) {
                            pdlElecInfo.numRoues = situationComptage[0].dispositifComptage.compteurs.compteur[0].modeleCompteur.nbRoues;
                            pdlElecInfo.numbreCadrans = situationComptage[0].dispositifComptage.compteurs.compteur[0].modeleCompteur.nbCadrans;
                        }
                    }
                    
                    if(situationComptage[0].dispositifComptage.compteurs.compteur[0].localisation != null ){
                        pdlElecInfo.situationCompteur = situationComptage[0].dispositifComptage.compteurs.compteur[0].localisation.libelleCourt.toLowerCase('fr');  
                    }
                    
                }
                if (situationComptage[0].dispositifComptage.typeComptage != null &&
                    situationComptage[0].dispositifComptage.compteurs!=null && 
                    situationComptage[0].dispositifComptage.compteurs.compteur[0]!=null&&
                    situationComptage[0].dispositifComptage.compteurs.compteur[0].localisation != null && 
                    situationComptage[0].dispositifComptage.compteurs.compteur[0].localisation.libelleCourt != null) {
                        pdlElecInfo.typeCompteur = situationComptage[0].dispositifComptage.typeComptage.code;
                        if (pdlElecInfo.typeCompteur != null) {
                            if (!pdlElecInfo.typeCompteur.equals('LINKY') && !pdlElecInfo.typeCompteur.equals('Inconnu')) {
                                pdlElecInfo.typeCompteur = 'Historique'; 
                            }
                        }
                    }
            }
        }
    }
    public static void parseDonneesGenerales(pdlInfo pdlElecInfo, List<gdfsuezComBefCalypsoPdlelectricite.donneesGenerales_element> donneesGenerales){                              
        if(donneesGenerales != null && donneesGenerales[0] != null){
            if( donneesGenerales[0].dateDerniereModificationFormuleTarifaireAcheminement != null ){
                pdlElecInfo.dateDerniereModificationFormuleTarifaireAcheminement =  donneesGenerales[0].dateDerniereModificationFormuleTarifaireAcheminement  ;
            }
            pdlElecInfo.niveauOuvertureServices = null;
            system.debug('pdlElecInfo.niveauOuvertureServices'+ pdlElecInfo.niveauOuvertureServices);
            if (donneesGenerales[0].niveauOuvertureServices != null && donneesGenerales[0].niveauOuvertureServices.code!= null) {
                pdlElecInfo.niveauOuvertureServices = donneesGenerales[0].niveauOuvertureServices.code;
                if (pdlElecInfo.niveauOuvertureServices != null) {
                    if (pdlElecInfo.niveauOuvertureServices.equals('0')) {
                        pdlElecInfo.niveauOuvertureServices = 'Niveau 0';
                    } else if (pdlElecInfo.niveauOuvertureServices.equals('1')) {
                        pdlElecInfo.niveauOuvertureServices = 'Niveau 1';
                    } else if (pdlElecInfo.niveauOuvertureServices.equals('2')) {
                        pdlElecInfo.niveauOuvertureServices = 'Niveau 2';
                    } else {
                        pdlElecInfo.niveauOuvertureServices = 'Inconnu';
                    }
                    
                }
                
            }
            if (donneesGenerales[0].etatContractuel != null) {
                pdlElecInfo.etatPdl = donneesGenerales[0].etatContractuel.libelleCourt;
            }
        }
    }
    public static void parseSituationContractuelle( PdlInfo pdlElecInfo,  List<gdfsuezComBefCalypsoPdlelectricite.situationContractuelle_element> situationContractuelle){
        pdlElecInfo.perimetre = 'PDL hors périmètre'; //default Value
        pdlElecInfo.situationContractuelle = null;//default Value                                  
        if(situationContractuelle != null && situationContractuelle[0] != null){
            pdlElecInfo.dateMHS = situationContractuelle[0].dateFin;
            if (situationContractuelle[0].contratID != null && situationContractuelle[0].contratID.equals('GRD-F006')) {
                pdlElecInfo.perimetre = 'PDL dans le périmètre';
            }
            if ( situationContractuelle[0].sIContractuel != null) {
                pdlElecInfo.situationContractuelle = situationContractuelle[0].sIContractuel.code;
            }
            if(situationContractuelle[0].structureTarifaire != null){
                if(situationContractuelle[0].structureTarifaire.formuleTarifaireAcheminement != null ){
                    if ( situationContractuelle[0].structureTarifaire.formuleTarifaireAcheminement.libelleCourt != null) {
                        pdlElecInfo.ftaLibelle = situationContractuelle[0].structureTarifaire.formuleTarifaireAcheminement.libelleCourt;
                    }
                    if (situationContractuelle[0].structureTarifaire.formuleTarifaireAcheminement.code != null) {
                        pdlElecInfo.ftaCode = situationContractuelle[0].structureTarifaire.formuleTarifaireAcheminement.code;
                    }
                }
                if(situationContractuelle[0].structureTarifaire.calendrierFournisseur != null ){
                    if (situationContractuelle[0].structureTarifaire.calendrierFournisseur.code != null) {
                        pdlElecInfo.calendrierFournisseurCode = situationContractuelle[0].structureTarifaire.calendrierFournisseur.code;
                    }
                    if ( situationContractuelle[0].structureTarifaire.calendrierFournisseur.libelleCourt != null) {
                        pdlElecInfo.calendrierFournisseurLibelleCourt = situationContractuelle[0].structureTarifaire.calendrierFournisseur.libelleCourt;
                    }
                }
                if(situationContractuelle[0].structureTarifaire.puissanceSouscriteMax != null){
                    if ( situationContractuelle[0].structureTarifaire.puissanceSouscriteMax.valeur != null) {
                        pdlElecInfo.puissanceSouscriteValeur =situationContractuelle[0].StructureTarifaire.puissanceSouscriteMax.valeur;
                    }
                    if (situationContractuelle[0].structureTarifaire.puissanceSouscriteMax.unite != null) {
                        pdlElecInfo.puissanceSouscriteUnite = situationContractuelle[0].structureTarifaire.puissanceSouscriteMax.unite;
                    }
                }
            }
        }
    }
    public class IndexInfo{
        public String  index  ;
        public  String  hp ;
        public  String    hc ;
        public  Datetime     dateDernierIndex  ;
        public  String   natureIndex  ;
        
    }
    public class PdlInfo {
        
        public String idPDLElectricite = null;
        public String secteurActivite;
        public String situationContractuelle = null;
        public String typeCompteur = null;
        public String niveauOuvertureServices = null;
        public String index;
        public String statut;
        public String matricule;
        public String etatPdl;
        public datetime dateMHS;
        public datetime dateDernierIndex;
        public Integer numbreCadrans;
        public Integer numRoues;
        public String acessibilite;
        public String indexHp;
        public String indexHC;
        boolean autoreleve;
        String etatCompteur;
        Public String puissancelimitee;
        public String ftaCode;
        public String ftaLibelle;
        public String calendrierFournisseurCode;
        public String calendrierFournisseurLibelleCourt;
        public Integer puissanceSouscriteValeur;
        public String puissanceSouscriteUnite;
        public gdfsuezComBefCalypsoPdlelectricite.cAEParCadran_element cAEParCadran;
        public Integer cAE_HP;
        public Integer cAE_HC;
        public Integer cAE_WE;
        public gdfsuezComBefChpDistributeurelectric.quantiteSansDecimalDt cAEGlobale;
        public String natureIndex;
        public String perimetre;
        public String periodeDeDeploiement ;
        public String typeComptageDifferencie;
        public Datetime dateDerniereModificationFormuleTarifaireAcheminement ;
        public String situationCompteur;     //donneesPDL . situationComptage . dispositifComptage . compteurs . compteur . localisation . libelleCourt
        public pdlInfo( String idPDLElectricite, String secteurActivite, String statut){
            this.idPDLElectricite = idPDLElectricite;
            this.secteurActivite = secteurActivite;
            this.statut = statut;
        }
    }
    public static void parseIndex(pdlInfo pdlElecInfo,IndexInfo indexObject) {
        pdlElecInfo.index = indexObject.index;
        pdlElecInfo.dateDernierIndex = indexObject.dateDernierIndex;
        pdlElecInfo.indexHC = indexObject.hC;
        pdlElecInfo.indexHp = indexObject.hp;
        pdlElecInfo.natureIndex = indexObject.natureIndex;
        if('DISCO'.equalsIgnoreCase(pdlElecInfo.situationContractuelle)){
            switch on pdlElecInfo.numbreCadrans {
                when 1 {
                    pdlElecInfo.typeComptageDifferencie='Simple';
                }
                when 2 {
                    pdlElecInfo.typeComptageDifferencie='Double';
                }
                when 3 {
                    pdlElecInfo.typeComptageDifferencie='Triple';
                }
                when else {
                    pdlElecInfo.typeComptageDifferencie='Inconnu';
                }
            }    
        }
        else if ('GINKO'.equalsIgnoreCase(pdlElecInfo.situationContractuelle) && pdlElecInfo.calendrierFournisseurCode!=null){
            List<SM_TranscoTypeComptage__mdt> trancoList= [select MasterLabel 
                                                           from  SM_TranscoTypeComptage__mdt 
                                                           where DeveloperName=:pdlElecInfo.calendrierFournisseurCode];
            if(trancoList!=null && trancoList.size()>0){
                pdlElecInfo.typeComptageDifferencie=trancoList[0].MasterLabel;
            }
            
        }
    }
    
    
    
    
    public static VI_SM009_PdlElec.IndexInfo  getIndex(Datetime dateDernierIndexReleve, String natureIndexReleve, String natureIndexReleveCode, String indexBaseReleve, 
                                                       String indexHPReleve, String indexHCReleve, Datetime dateDernierIndexPublies, String natureIndexPublies, 
                                                       String natureIndexCodePublies, String indexBasePublies, String indexHPPublies, String indexHCPublies)
    {
        
        VI_SM009_PdlElec.IndexInfo index= new VI_SM009_PdlElec.IndexInfo() ;
        if(natureIndexCodePublies != null && natureIndexReleveCode != null){
            
            if(natureIndexCodePublies.equalsIgnoreCase('REEL') && natureIndexReleveCode.equalsIgnoreCase('REEL')){
                if(dateDernierIndexPublies >= dateDernierIndexReleve){
                    index.index =indexBasePublies ;
                    index.hp = indexHPPublies ;
                    index.hc = indexHCPublies ;
                    index.dateDernierIndex = dateDernierIndexPublies ;
                    index.natureIndex = natureIndexPublies ;
                }else{
                    index.index =indexBaseReleve ;
                    index.hp = indexHPReleve ;
                    index.hc = indexHCReleve ;
                    index.dateDernierIndex = dateDernierIndexReleve ;
                    index.natureIndex = natureIndexReleve ;
                }
            }else if(natureIndexCodePublies.equalsIgnoreCase('REEL')){
                index.index =indexBasePublies ;
                index.hp = indexHPPublies ;
                index.hc = indexHCPublies ;
                index.dateDernierIndex = dateDernierIndexPublies ;
                index.natureIndex = natureIndexPublies ;
            }else if(natureIndexReleveCode.equalsIgnoreCase('REEL')) {
                index.index =indexBaseReleve ;
                index.hp = indexHPReleve ;
                index.hc = indexHCReleve ;
                index.dateDernierIndex = dateDernierIndexReleve ;
                index.natureIndex = natureIndexReleve ;
            }else{
                
                if(dateDernierIndexPublies >= dateDernierIndexReleve){
                    index.index =indexBasePublies ;
                    index.hp = indexHPPublies ;
                    index.hc = indexHCPublies ;
                    index.dateDernierIndex = dateDernierIndexPublies ;
                    index.natureIndex = natureIndexPublies ;
                }else{
                    index.index =indexBaseReleve ;
                    index.hp = indexHPReleve ;
                    index.hc = indexHCReleve ;
                    index.dateDernierIndex = dateDernierIndexReleve ;
                    index.natureIndex = natureIndexReleve ;
                }
                
            }
            
        }else if(natureIndexReleve != null){
            index.index =indexBaseReleve ;
            index.hp = indexHPReleve ;
            index.hc = indexHCReleve ;
            index.dateDernierIndex = dateDernierIndexReleve ;
            index.natureIndex = natureIndexReleve ; 
        }else if(natureIndexPublies != null ){
            index.index =indexBasePublies ;
            index.hp = indexHPPublies ;
            index.hc = indexHCPublies ;
            index.dateDernierIndex = dateDernierIndexPublies ;
            index.natureIndex = natureIndexPublies ;
        }
        
        return index ;
        
    }
}