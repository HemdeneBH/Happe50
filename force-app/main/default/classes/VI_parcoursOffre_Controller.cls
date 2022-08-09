/*
*@Author: Amal Chreiteh
*@Description: Remonter les offres à afficher dans le parcours
*@CreatedDate: 2/12/2020
*@LastModified:  19/07/2021
*/

public without sharing class VI_parcoursOffre_Controller {
    
    public static Choix_Offre__c choixOffre;
    public static String AccountId;
    
    /* @author Amal Chreiteh
* @date 2/12/2020
* @description Recuperer les choix des offres et les produits de salesforce
* @param energie (gaz, Elec, Duo), typeComptage ( HPHC ou Simple), ChoisParcours( EM ou CHF)
* @return void List<Product2>
*/
    
    @AuraEnabled(cacheable=false)
    public static List<Product2> getChoixdoffreSF(String energie, String typeComptage, String canal,String choixParcours){
        choixParcours = canal + choixParcours;
        String typeComptageChoixOffre = (typeComptage == 'HPHC'? 'Double': 'Simple'); 
        if(energie!= null && energie != ''){
            try{
                system.debug('choixParcours'+ choixParcours);
                User currentUser = [SELECT Id, AccountId, Account.Name
                                    FROM User 
                                    WHERE Id =: UserInfo.getUserId()];
                AccountId = currentUser.AccountId;
                List<VI_JonctionChoixOffre_Compte__c> jonctionOffreCompte = [Select Id, VI_ChoixOffre__c, Partenaire__c, VI_ChoixOffre__r.Name, VI_ChoixOffre__r.Energie__c, VI_ChoixOffre__r.OffrePousse__c, VI_ChoixOffre__r.offreRepli__c, VI_ChoixOffre__r.OffrePousseLinky__c 
                                                                             From VI_JonctionChoixOffre_Compte__c
                                                                             Where Partenaire__c = :currentUser.AccountId AND VI_ChoixOffre__r.energie__c = :energie AND /*VI_ChoixOffre__r.Actif__c = true AND*/ VI_ChoixOffre__r.contexte_de_souscription__c = :choixParcours];
                Set<String> offres = new Set<String>();
                for(VI_JonctionChoixOffre_Compte__c choixOffre : jonctionOffreCompte){
                    offres.add(choixOffre.VI_ChoixOffre__r.OffrePousse__c);
                    offres.add(choixOffre.VI_ChoixOffre__r.offreRepli__c);
                }
                choixOffre = new Choix_Offre__c(OffrePousse__c = jonctionOffreCompte[0].VI_ChoixOffre__r.OffrePousse__c, offreRepli__c = jonctionOffreCompte[0].VI_ChoixOffre__r.offreRepli__c);
                system.debug('choixOffre'+ choixOffre);
                system.debug('offres'+ offres);
                List<Product2> Products = new List<Product2>();
                list<String> listStrucMesFour = new list<String>();
                if(energie != 'Gaz'){
                    for(SM_TranscoTypeComptageStrucMesFour__mdt transco : [SELECT StructureMesureFournisseur__c 
                                                                           FROM SM_TranscoTypeComptageStrucMesFour__mdt 
                                                                           WHERE TypeComptage__c =:typeComptageChoixOffre]){
                                                                               
                                                                               listStrucMesFour.add(transco.StructureMesureFournisseur__c);
                                                                           }
                    system.debug('listStrucMesFourlistStrucMesFour '+listStrucMesFour);
                    //ELec
                    if(energie == 'Elec'){
                        Products = [SELECT id, Family,SM_structureMesureFournisseur__c, ArticleURL__c, ProductCode,offreVerte__c, TypeOffre__c, FamilyLabel__c,Name
                                    FROM Product2
                                    WHERE  IsActive = true AND Family=:offres AND SM_structureMesureFournisseur__c =:listStrucMesFour AND vlocity_cmt__Type__c =: energie];
                    }
                    //Duo
                    if(energie == 'Duo'){
                        Products = [SELECT id, Family,SM_structureMesureFournisseur__c, ArticleURL__c, ProductCode,offreVerte__c, TypeOffre__c, FamilyLabel__c,Name
                                    FROM Product2
                                    WHERE  (IsActive = true AND Family=:offres AND SM_structureMesureFournisseur__c =:listStrucMesFour AND vlocity_cmt__Type__c =: energie)
                                    OR  (IsActive = true AND Family=:offres AND vlocity_cmt__Type__c =: energie AND SM_structureMesureFournisseur__c=null)];
                    }
                    
                }
                else{//Gaz
                    
                    Products = [SELECT id, Family,SM_structureMesureFournisseur__c,ArticleURL__c, ProductCode,offreVerte__c, TypeOffre__c, FamilyLabel__c,Name
                                FROM Product2
                                WHERE  IsActive = true AND Family=:offres AND vlocity_cmt__Type__c =: energie];
                } 
                system.debug('Products'+ Products);
                return Products;
            }
            catch(exception e){
                system.debug('¤¤¤ Erreur ¤¤¤');
                return null;
            }
        }
        return null;
        
    }
    /* @author Amal Chreiteh
* @date 2/12/2020
* @description Recuperer les offres pour les affichier 
* @param parcours
* @return OffreList wrapper defined in this class
*/
    
    @AuraEnabled(cacheable=false)
    public static OffreList getOffersOctopusParcours(VI_parcours__c parcours){
        system.debug('### Start getOffersOctopusParcours : ');
        OffreList offresToShow = new OffreList();
        String contexteSouscription = (parcours.VI_ChoixParcours__c == 'EM'?'MES_EMM':'CHGT_FOURN');
        String energie = (parcours.VI_ChoixEnergie__c == 'Electricité'? 'Elec':(parcours.VI_ChoixEnergie__c == 'Gaz'?'Gaz':'Duo'));
        String codePostal = parcours.VI_CodePostalRechercheLocal__c;
        String canal = 'PP-';
        String commune = parcours.VI_CommuneRechercheLocal__c;
        Integer estHP, estHC;
        
        String codeCommune;
        if(codePostal != null){
            List<VI_SM002_AdresseDQE.AdressesWrapper> codePostalList = VI_parcoursPPRechercheClient_Controller.getVillesCodePostal(codePostal);
            for(VI_SM002_AdresseDQE.AdressesWrapper codePostalWS: codePostalList){
                if(codePostalWS.ville == commune){
                    codeCommune = codePostalWS.idLocalite;
                    break;
                } 
            }
        }
        
        if(codeCommune == null){
            offresToShow.message = 'Merci de rensigner une commune qui correspond au code postal';
            return offresToShow;
        }
        else{
            parcours.VI_CodeCommuneIdentificationLocal__c = codeCommune;
        }
        String pdl = parcours.VI_PDLRechercheLocal__c;
        String pce = parcours.VI_PCERechercheLocal__c;
        Integer CAEElec;
        Integer CAR;
        
        //estimation
        if(parcours.VI_ChoixEstimation__c == 'Estimer la consommation d\'énergie'){
            if(parcours.VI_Estimation_conso_elec_HC__c == null 
               && parcours.VI_Estimation_conso_elec_HP__c == null 
               && parcours.VI_Estimation_conso_gaz__c == null
               && parcours.VI_TypeResidenceSaisieConso__c != null
               && parcours.VI_AnneeConstructionLogementSaisieConso__c != null
               && parcours.VI_TypeLogementSaisieConso__c != null
               && parcours.VI_SurfaceLogementSaisieConso__c != null
               && parcours.VI_SaisieEstimationConsoElec_HP_HC__c != null
               && parcours.VI_DispositifChauffageSaisieConso__c != null
               && parcours.VI_EnergieChauffageSaisieConso__c != null
               && parcours.VI_DispositifEauChaudeSaisieConso__c != null
               && parcours.VI_EnergieEauChaudeSaisieConso__c != null
               && parcours.VI_EnergieCuissonSaisieConso__c != null
               && parcours.VI_NombreOccupantLogementSaisieConso__c != null
              ){
                  VI_parcoursConso_Controller.ConsoResponse consoResponse = VI_parcoursConso_Controller.getEstimationLWC(parcours);
                  if(consoResponse.message != null){
                      offresToShow.message = consoResponse.message;
                      return offresToShow;
                  }else{
                      parcours = consoResponse.parcours;
                  }
              }
            if(parcours.VI_Estimation_conso_elec_HC__c != null ){
                CAEElec= (parcours.VI_Estimation_conso_elec_HP__c + parcours.VI_Estimation_conso_elec_HC__c).intValue();
                estHP = parcours.VI_Estimation_conso_elec_HP__c.intValue();
                estHC = parcours.VI_Estimation_conso_elec_HC__c.intValue();
            }
            else if(parcours.VI_Estimation_conso_elec_HP__c != null){
                CAEElec= parcours.VI_Estimation_conso_elec_HP__c.intValue();
                estHP = parcours.VI_Estimation_conso_elec_HP__c.intValue();
            }     
            if(parcours.VI_Estimation_conso_gaz__c != null){
                CAR=  parcours.VI_Estimation_conso_gaz__c.intValue();
            }   
        }
        //saisie
        else if(parcours.VI_ChoixEstimation__c == 'Saisir la consommation d\'énergie'){
            if(parcours.VI_SaisieConsommationElec_HP_HC__c == true ){
                CAEElec = (parcours.VI_SaisieConsommationHeuresPleines__c + parcours.VI_SaisieConsommationHeuresCreuses__c).intValue();
                estHP = parcours.VI_SaisieConsommationHeuresPleines__c.intValue();
                estHC = parcours.VI_SaisieConsommationHeuresCreuses__c.intValue();
            }
            else if(parcours.VI_SaisieConsommationHeuresPleines__c != null){ 
                CAEElec= parcours.VI_SaisieConsommationHeuresPleines__c.intValue();
                estHP = parcours.VI_SaisieConsommationHeuresPleines__c.intValue();
            }     
            if(parcours.VI_ConsommationGazKwHSaisieConso__c != null){
                CAR=  parcours.VI_ConsommationGazKwHSaisieConso__c.intValue();
            }  
        }
        //passer cette etape --> on ne peut rien faire
        Date temp = parcours.VI_InfosCompl_DateContratEffectif__c;
        DateTime dateEffetContrat = system.now();//(temp != null?DateTime.newInstance(temp.year(), temp.month(), temp.day()): system.now()) ;
        String niveauOuvertureServices = null;
        String puissance = null;
        String plageConsommation = null;
        DateTime dateDerniereModificationFormuleTarifaireAcheminement = null;
        String ftaCode = null;
        String typeComptage;  
        if(pce!= null && pce != ''){
            /*String CARLirePDLGaz = VI_SM010_PdlGaz.lirePdlV2( pce, 'VI', '3', 'callout:VI_AuthOctopus');
if(CARLirePDLGaz!= null){
CAR = Integer.ValueOf(CARLirePDLGaz);
system.debug('CAR'+ CAR);
}*/
        }
        if(CAR != null ){
            plageConsommation = (CAR<= 5999? '6000': (CAR <= 29999?'30000':(CAR >= 30000? '300000': '0') ));
            parcours.VI_GazPlageConso__c = Integer.ValueOf(plageConsommation);
            //Libelle => CAR <= 5999 ->"de 0 à 5 999 kWh/an";CAR <= 29999 ->"de 6 000 à 29 999 kWh/an";CAR >= 30000->"Supérieur à 30 000 kWh/an";"hors scope"
        }
        if(pdl!= null && pdl != ''){
            system.debug('pdl'+ pdl);
            VI_SM009_PdlElec.PdlInfo  pdlInfo= VI_SM009_PdlElec.lirePdl(pdl, 'VI', '3', 'callout:VI_AuthOctopus');
            /*correction ticket annomalie */
            if(pdlInfo!= null){
                if(pdlInfo.niveauOuvertureServices=='Niveau 2'){
                    niveauOuvertureServices='2';
                }
                else if(pdlInfo.niveauOuvertureServices=='Niveau 0'){
                    niveauOuvertureServices='0';
                }
                else if(pdlInfo.niveauOuvertureServices=='Niveau 1'){
                    niveauOuvertureServices='1';
                }
                puissance = String.valueOf(pdlInfo.puissanceSouscriteValeur);
                List<String> listeOptions= new List<String>{'3','6','9','12','15','18','24','30','36'};
                    if(!listeOptions.contains(puissance)){
                        puissance=null;
                    }
                dateDerniereModificationFormuleTarifaireAcheminement = pdlInfo.dateDerniereModificationFormuleTarifaireAcheminement;
                ftaCode = pdlInfo.ftaCode;
                //typeComptage = (pdlInfo.typeComptageDifferencie == 'Simple'? 'SIMPLE':'HPHC');
                if(pdlInfo.cAEGlobale != null){
                    CAEElec = pdlInfo.cAEGlobale.valeur; // releves de compteur
                    system.debug('CAEElec'+ CAEElec);
                }
            }
        }
        
        if(typeComptage == null){
            typeComptage = (parcours.VI_SaisieConsommationElec_HP_HC__c == true || parcours.VI_SaisieEstimationConsoElec_HP_HC__c == 'Oui' ? 'HPHC':'SIMPLE');
        }
        if(puissance == null){
            puissance = parcours.VI_PuissanceCompteurElecSaisieConso__c;
            if(puissance == null){
                puissance = '6';
            }
        }
        if(niveauOuvertureServices == null){
            if(parcours.VI_ChoixEstimation__c == 'Saisir la consommation d\'énergie' ){
                niveauOuvertureServices = (parcours.VI_CompteurCommunicantLinkySaisieConso__c == true ?'2': '0');
            }
            else if(parcours.VI_ChoixEstimation__c == 'Estimer la consommation d\'énergie'){
                niveauOuvertureServices = (parcours.VI_SaisieEstimationConsoElec_Linky__c == 'Oui'?'2': '0');
            }
            else{
                niveauOuvertureServices = '0';
            }
        }
        parcours.VI_EstimationPuissance__c   = puissance;
        parcours.VI_EstimationNiveauOuvertureServices__c = niveauOuvertureServices;
        parcours.VI_EstimationFtaCode__c  = ftaCode;
        parcours.VI_CAEElec__c = CAEElec;
        parcours.VI_DateLastModifFormTarifaireAcheminemt__c   = dateDerniereModificationFormuleTarifaireAcheminement;
        if(plageConsommation == null){
            plageConsommation = '6000';
        }
        offresToShow =  getOffersOctopusNew( offresToShow,  energie,  codeCommune, codePostal ,   CAEElec,  CAR, dateEffetContrat,  typeComptage, canal, puissance,  niveauOuvertureServices,  
                                            dateDerniereModificationFormuleTarifaireAcheminement,  ftaCode,  contexteSouscription,  plageConsommation, parcours.VI_ChoixEnergie__c, parcours.VI_ChoixParcours__c,
                                            estHP, estHC,parcours);
        
        offresToShow.parcours =  parcours;
        return offresToShow;
        
    }
    
    /* @author Amal Chreiteh
* @date 2/12/2020
* @description Recuperer les offres pour les affichier 
* @param parcours
* @return OffreList wrapper defined in this class
*/
    
    
    @AuraEnabled(cacheable=false)
    public static OffreList getOffersOctopusNew(  OffreList offresToShow, String energie, String codeCommune, string codePostal,  Integer CAEElec, Integer CAR,
                                                DateTime dateEffetContrat, String typeComptage, String canal, string puissance, String niveauOuvertureServices, DateTime dateDerniereModificationFormuleTarifaireAcheminement, 
                                                String ftaCode, String contexteSouscription, String plageConsommation, String choixEnergie, String choixParcours, Integer estHP, Integer estHC,VI_Parcours__c currentParcours){
                                                    List<Product2> offres = getChoixdoffreSF (energie, typeComptage, canal, choixParcours);
                                                    String ftaOutput;
                                                    Map<String, String> ArticleKnowledge = new Map<String, String>();
                                                    List< VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt> inputs = new List< VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt>();
                                                    Map<String, String> productFamily = new Map<String, String>();
                                                    Map<String, List<String>> mapPackOffres = new Map<String, List<String>>();
                                                    Map<String, String> productFamilyLabels = new Map<String, String>();
                                                    Map<String, String> productOffreVerte = new Map<String, String>();
                                                    Map<String, String> productArticle = new Map<String, String>();
                                                    Map<String, String> productstructureFournisseur = new Map<String, String>();
                                                    Map<String, String> familystructureFournisseur = new Map<String, String>();
                                                    Map<String,String> typeOfProduct = new MAP<String,String>();
                                                    for(Product2 p:offres){
                                                        String pourcentageOffreVerte = (p.offreVerte__c?'100':null);
                                                        productOffreVerte.put(p.ProductCode,pourcentageOffreVerte);
                                                        String structureMesureFournisseur = p.SM_structureMesureFournisseur__c;
                                                        productstructureFournisseur.put(p.ProductCode,structureMesureFournisseur);
                                                        if(!String.isBlank(structureMesureFournisseur)){
                                                            familystructureFournisseur.put(p.family,structureMesureFournisseur);
                                                        }
                                                        productFamily.put(p.ProductCode, p.Family);
                                                        productFamilyLabels.put(p.Family, p.FamilyLabel__c);
                                                        productArticle.put(p.ProductCode, p.ArticleURL__c);
                                                        typeOfProduct.put(p.ProductCode, p.TypeOffre__c);
                                                        List<String> idOffre = new List<String>();
                                                        if (mapPackOffres.get(p.Family) != null) {
                                                            mapPackOffres.get(p.Family).add(p.ProductCode);
                                                        } else {
                                                            mapPackOffres.put(p.Family, new List<String> {p.ProductCode});
                                                        }
                                                    }
                                                    for (String pack : productFamilyLabels.keySet()){
                                                        VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt input = prepareOffer(codeCommune, codePostal, pack, mapPackOffres.get(pack),
                                                                                                                                                puissance,'100', familystructureFournisseur.get(pack), CAEElec,
                                                                                                                                                niveauOuvertureServices,plageConsommation,dateEffetContrat,
                                                                                                                                                dateDerniereModificationFormuleTarifaireAcheminement,ftaCode,
                                                                                                                                                contexteSouscription); 
                                                        inputs.add(input);
                                                        
                                                    } 
                                                    
                                                    List <Knowledge__kav> knowledgeArticles = [Select Id, Categorie_Consigne__c, Cle_Migration__c, Consigne__c, KnowledgeArticleId, Etape_de_l_omniscript__c, UrlName 
                                                                                               FROM Knowledge__kav where UrlName =:productArticle.values() and Archiveddate=null]; 
                                                    
                                                    for(Knowledge__kav knowledge: knowledgeArticles){
                                                        ArticleKnowledge.put(knowledge.UrlName, knowledge.Consigne__c.stripHtmlTags().substringBeforeLast('"').substringAfterLast('"'));
                                                        
                                                    }
                                                    
                                                    VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesResponse_element response = VI_SM022_PrixEtRemises.recherchePrixetRemise(inputs, 'callout:VI_AuthOctopus', 'VI', 'V2');     
                                                    system.debug('response.rechercherPrixEtRemisesOutput'+ response);  
                                                    
                                                    if (response != null && response.messageRetours != null && response.messageRetours.messageRetour != null ) {
                                                        system.debug('response.messageRetours'+ response.messageRetours);
                                                        for (VI_gdfsuezComBefChpCommunV3.messageRetour_element msgRetour : response.messageRetours.messageRetour) {
                                                            if ('ERREUR'.equalsIgnoreCase(msgRetour.type_x)) {
                                                                system.debug('ERREUR'+ msgRetour.libelle );
                                                                system.debug('ERREUR'+ msgRetour.code );
                                                                if(msgRetour.code == 'OCTOPUS_RechercherPrixEtRemisesServices_06'){offresToShow.message = 'La commune choisie n’est pas éligible aux offres d’énergie ENGIE ('+ choixEnergie +')';
                                                                                                                                  }
                                                                else{
                                                                    offresToShow.message = msgRetour.libelle;
                                                                }
                                                                return offresToShow;
                                                            }
                                                            
                                                        }
                                                    }
                                                    
                                                    
                                                    for (VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesOutputDt donneesRetour : response.rechercherPrixEtRemisesOutput) {
                                                        String idOffre;
                                                        String libelleOffre;
                                                        String idPack;
                                                        String packLibelle;
                                                        String secteurActivite;
                                                        XMLSerializer serializer = new XMLSerializer();
                                                        String serializedXML = serializer.serialize(donneesRetour,true, null); 
                                                        system.debug('serializedXML donnees retour rechercherPrixEtRemisesOutput'+ serializedXML);
                                                        if (donneesRetour != null && donneesRetour.donneesPack != null && donneesRetour.donneesPack.idPack != null) {
                                                            idPack = donneesRetour.donneesPack.idPack;
                                                            packLibelle = donneesRetour.donneesPack.libellePack;
                                                        }
                                                        system.debug('donneesRetour'+ donneesRetour);
                                                        system.debug('donneesRetour.donneesOffre'+ donneesRetour.donneesOffre);
                                                        if (donneesRetour != null && donneesRetour.donneesOffre != null) {
                                                            VI_gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt[] donneesOffre = donneesRetour.donneesOffre;
                                                            for (VI_gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt data : donneesOffre) {
                                                                
                                                                if(data.formuleTarifaireAcheminement != null){	
                                                                    ftaOutput =  data.formuleTarifaireAcheminement.code;
                                                                }
                                                                idOffre = data.idOffre;
                                                                libelleOffre = data.libelleOffre;
                                                                if(data.secteurActivite != null){
                                                                    secteurActivite = data.secteurActivite.code;
                                                                }
                                                                system.debug('data'+ data);
                                                                VI_gdfsuezBefCalypsoPrixetremisesV2.listePrixDt listePrix = data.listePrix;
                                                                if (listePrix != null) {
                                                                    Boolean isGaz = false;
                                                                    Boolean isElec = false;
                                                                    wrapperPrix prixElec = new wrapperPrix('Elec');
                                                                    wrapperPrix prixGaz = new wrapperPrix('Gaz');
                                                                    XMLSerializer serializer2 = new XMLSerializer();
                                                                    String serializedXML2 = serializer2.serialize(listePrix,true, null); 
                                                                    system.debug('serializedXML listePrix'+ serializedXML2);
                                                                    for (VI_gdfsuezBefCalypsoPrixetremisesV2.prixDt prix : listePrix.prix) {
                                                                        //Get Gaz caracteristiques
                                                                        if (prix.caracteristiquesGaz != null && prix.caracteristiquesGaz.typePrix!= null
                                                                            && prix.caracteristiquesGaz.plageconsommation != null
                                                                            && prix.caracteristiquesGaz.plageconsommation.code == plageConsommation
                                                                            && typeOfProduct.get(data.idOffre) != 'TradeOFF'
                                                                            && (prix.caracteristiquesGaz.typePrix.code == 'AB' || prix.caracteristiquesGaz.typePrix.code == 'CO')) {
                                                                                if (prix.caracteristiquesGaz.typePrix.code == 'AB') {
                                                                                    isGaz = true;
                                                                                    prixGaz.AboTTC = Decimal.valueOf(prix.montantTTC).setScale(3);
                                                                                    prixGaz.AboHT = Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                }
                                                                                if (prix.caracteristiquesGaz.typePrix.code == 'CO') {
                                                                                    prixGaz.CoTTC = Decimal.valueOf(prix.montantTTC).setScale(3);
                                                                                    prixGaz.CoHT =  Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                }
                                                                            }
                                                                        else if(prix.caracteristiquesGaz != null && prix.caracteristiquesGaz.typePrix != null
                                                                                && prix.caracteristiquesGaz.plageconsommation != null
                                                                                && prix.caracteristiquesGaz.plageconsommation.code == plageConsommation
                                                                                && typeOfProduct.get(data.idOffre) == 'TradeOFF'
                                                                               ){
                                                                                   isGaz = true;
                                                                                   if(prix.caracteristiquesGaz.typePrix.code == 'TOTAB'){
                                                                                       prixGaz.TOTAB = Decimal.valueOf(prix.montantTTC).setScale(3);
                                                                                       prixGaz.TOTABHT = Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                   }
                                                                                   if(prix.caracteristiquesGaz.typePrix.code == 'TOTCO'){
                                                                                       prixGaz.TOTCO = Decimal.valueOf(prix.montantTTC).setScale(3);
                                                                                       prixGaz.TOTCOHT = Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                   }
                                                                                   if(prix.caracteristiquesGaz.typePrix.code == 'ACHAB'){
                                                                                       if(  prixGaz.AboACHTTC == null){prixGaz.AboACHTTC = Decimal.valueOf(prix.montantTTC).setScale(3); }
                                                                                       if(prixGaz.AboACHHT == null){ prixGaz.AboACHHT = Decimal.valueOf(prix.montantHT).setScale(3);}
                                                                                       else{ prixGaz.AboACHHT = prixGaz.AboACHHT + Decimal.valueOf(prix.montantHT).setScale(3); }
                                                                                   }
                                                                                   if(prix.caracteristiquesGaz.typePrix.code == 'AB'){
                                                                                       if(  prixGaz.AboTTC == null){
                                                                                           prixGaz.AboTTC = Decimal.valueOf(prix.montantTTC).setScale(3);
                                                                                           prixGaz.AboHT = Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                       }
                                                                                       else{
                                                                                           prixGaz.AboTTC = prixGaz.AboTTC+ Decimal.valueOf(prix.montantTTC).setScale(3);
                                                                                           prixGaz.AboHT =prixGaz.AboHT+  Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                       }
                                                                                       
                                                                                   }
                                                                                   if(prix.caracteristiquesGaz.typePrix.code == 'ACHCO'){
                                                                                       prixGaz.CoACHTTC = Decimal.valueOf(prix.montantTTC).setScale(3);
                                                                                       prixGaz.CoACHHT = Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                   }
                                                                                   if(prix.caracteristiquesGaz.typePrix.code == 'CO'){
                                                                                       prixGaz.CoTTC = Decimal.valueOf(prix.montantTTC).setScale(3);
                                                                                       prixGaz.CoHT = Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                   }
                                                                                   if(prix.caracteristiquesGaz.typePrix.code == 'OB'){
                                                                                       prixGaz.ObTTC = Decimal.valueOf(prix.montantTTC).setScale(3);
                                                                                       prixGaz.ObHT = Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                   }
                                                                               }
                                                                        if (prix.caracteristiquesElec != null && prix.caracteristiquesElec.typePrix != null
                                                                            && prix.caracteristiquesElec.puissance != null && prix.caracteristiquesElec.typeComptage != null
                                                                            && prix.caracteristiquesElec.puissance.code == puissance
                                                                            && typeOfProduct.get(data.idOffre) != 'TradeOFF' 
                                                                            && (prix.caracteristiquesElec.typePrix.code == 'AB' || prix.caracteristiquesElec.typePrix.code == 'CO')) {
                                                                                system.debug('typeComptage'+ typeComptage);
                                                                                if(typeComptage == 'SIMPLE'){
                                                                                    if (prix.caracteristiquesElec.typePrix.code == 'AB' && prix.caracteristiquesElec.typeComptage.code == 'S') {
                                                                                        isElec = true;
                                                                                        prixElec.AboTTC =Decimal.valueOf(prix.montantTTC).setScale(3);
                                                                                        prixElec.AboHT = Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                    }
                                                                                    if (prix.caracteristiquesElec.typePrix.code == 'CO') {
                                                                                        if(prix.caracteristiquesElec.typeComptage.code == 'S'){
                                                                                            prixElec.CoTTC = Decimal.valueOf(prix.montantTTC).setScale(3);
                                                                                            prixElec.CoHT = Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                        }
                                                                                    }
                                                                                }
                                                                                else if(typeComptage == 'HPHC'){
                                                                                    if (prix.caracteristiquesElec.typePrix.code == 'AB' && prix.caracteristiquesElec.typeComptage.code == 'C') {
                                                                                        isElec = true;
                                                                                        prixElec.AboTTC = Decimal.valueOf(prix.montantTTC).setScale(3);
                                                                                        prixElec.AboHT = Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                    }
                                                                                    if (prix.caracteristiquesElec.typePrix.code == 'CO') {
                                                                                        if(prix.caracteristiquesElec.typeComptage.code == 'P'){
                                                                                            prixElec.CoTTC = Decimal.valueOf(prix.montantTTC).setScale(3);
                                                                                            prixElec.CoHT = Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                        }
                                                                                        else if(prix.caracteristiquesElec.typeComptage.code == 'C'){
                                                                                            prixElec.CoTTCHC = Decimal.valueOf(prix.montantTTC).setScale(3);
                                                                                            prixElec.CoHTHC = Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                        }
                                                                                    }
                                                                                    
                                                                                }
                                                                                
                                                                            }
                                                                        else  if (prix.caracteristiquesElec != null && prix.caracteristiquesElec.typePrix != null
                                                                                  && typeOfProduct.get(data.idOffre) == 'TradeOFF' )
                                                                        {
                                                                            system.debug('prix.caracteristiquesElec.typePrix.code '+prix.caracteristiquesElec.typePrix.code);
                                                                            if(prix.caracteristiquesElec.puissance != null && prix.caracteristiquesElec.puissance.code == puissance){
                                                                                
                                                                                if (prix.caracteristiquesElec.typePrix.code == 'AB') {
                                                                                    isElec = true;
                                                                                    if(prixElec.AboTTC == null){
                                                                                        prixElec.AboTTC = Decimal.valueOf(prix.montantTTC).setScale(3);
                                                                                        prixElec.AboHT = Decimal.valueOf(prix.montantHT).setScale(3); 
                                                                                    }
                                                                                    else{
                                                                                        prixElec.AboTTC = prixElec.AboTTC +  Decimal.valueOf(prix.montantTTC).setScale(3);
                                                                                        prixElec.AboHT = prixElec.AboHT + Decimal.valueOf(prix.montantHT).setScale(3); 
                                                                                    }
                                                                                }
                                                                                if(prix.caracteristiquesElec.typePrix.code == 'ACHAB'){
                                                                                    if (prixElec.AboACHTTC == null) {
                                                                                        prixElec.AboACHTTC = Decimal.valueOf(prix.montantTTC).setScale(3);
                                                                                        prixElec.AboACHHT = Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                    }
                                                                                    else{
                                                                                        prixElec.AboACHTTC = prixElec.AboACHTTC+ Decimal.valueOf(prix.montantTTC).setScale(3);
                                                                                        prixElec.AboACHHT = prixElec.AboACHHT+ Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                    }
                                                                                }
                                                                                if(prix.caracteristiquesElec.typePrix.code == 'OB'){
                                                                                    prixElec.ObTTC = Decimal.valueOf(prix.montantTTC).setScale(3);
                                                                                    prixElec.ObHT = Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                }
                                                                                if(prix.caracteristiquesElec.typePrix.code == 'CO' &&  prix.caracteristiquesElec.typeComptage != null  ){
                                                                                    
                                                                                    if (prix.caracteristiquesElec.typeComptage.code == 'S'|| prix.caracteristiquesElec.typeComptage.code == 'STR_MESURE_SIMPLE'|| prix.caracteristiquesElec.typeComptage.code == 'BASE') {
                                                                                        prixElec.CoTTC = Decimal.valueOf(prix.montantTTC).setScale(3);
                                                                                        prixElec.CoHT = Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                    }
                                                                                    else if(prix.caracteristiquesElec.typeComptage.code == 'P' || prix.caracteristiquesElec.typeComptage.code == 'HP'){
                                                                                        prixElec.CoTTC = Decimal.valueOf(prix.montantTTC).setScale(3);
                                                                                        prixElec.CoHT = Decimal.valueOf(prix.montantHT).setScale(3); 
                                                                                    }
                                                                                    else if(prix.caracteristiquesElec.typeComptage.code == 'C'|| prix.caracteristiquesElec.typeComptage.code == 'HC'){
                                                                                        prixElec.CoTTCHC = Decimal.valueOf(prix.montantTTC).setScale(3);
                                                                                        prixElec.CoHTHC = Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                    }
                                                                                }
                                                                                if(prix.caracteristiquesElec.typePrix.code == 'TOTAB'){
                                                                                    prixElec.TOTAB =Decimal.valueOf(prix.montantTTC).setScale(3);
                                                                                    prixElec.TOTABHT =Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                }
                                                                                if(prix.caracteristiquesElec.typePrix.code == 'TOTCO'){
                                                                                    prixElec.TOTCO = Decimal.valueOf(prix.montantTTC).setScale(3);
                                                                                    prixElec.TOTCOHT = Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                }
                                                                                
                                                                                if (prix.caracteristiquesElec.typePrix.code == 'ACHCO'&& prix.caracteristiquesElec.typeComptage != null)
                                                                                {
                                                                                    if(prix.caracteristiquesElec.typeComptage.code == 'S'|| prix.caracteristiquesElec.typeComptage.code == 'STR_MESURE_SIMPLE'|| prix.caracteristiquesElec.typeComptage.code == 'BASE'){
                                                                                        prixElec.CoACHTTC = Decimal.valueOf(prix.montantTTC).setScale(3);prixElec.CoACHHT = Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                    }
                                                                                    else if(prix.caracteristiquesElec.typeComptage.code == 'P' || prix.caracteristiquesElec.typeComptage.code == 'HP'){
                                                                                        prixElec.CoACHTTC = Decimal.valueOf(prix.montantTTC).setScale(3); prixElec.CoACHHT = Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                    }
                                                                                    else if(prix.caracteristiquesElec.typeComptage.code == 'C' || prix.caracteristiquesElec.typeComptage.code == 'HC'){
                                                                                        prixElec.CoACHHCTTC = Decimal.valueOf(prix.montantTTC).setScale(3); prixElec.CoACHHCHT = Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                    }
                                                                                    else if(prix.caracteristiquesElec.typeComptage.code == 'U' && (ftaOutput == 'BTINFCU4' || ftaOutput == 'BTINFMU4')){
                                                                                        prixElec.CoACHHPHTTC = Decimal.valueOf(prix.montantTTC).setScale(3);prixElec.CoACHHPHHT = Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                    }
                                                                                    else if(prix.caracteristiquesElec.typeComptage.code == 'A' && (ftaOutput == 'BTINFCU4' || ftaOutput == 'BTINFMU4')){
                                                                                        prixElec.CoACHHCHTTC = Decimal.valueOf(prix.montantTTC).setScale(3);prixElec.CoACHHCHHT = Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                    }
                                                                                    else if(prix.caracteristiquesElec.typeComptage.code == 'L' && (ftaOutput == 'BTINFCU4' || ftaOutput == 'BTINFMU4')){
                                                                                        prixElec.CoACHHPBTTC = Decimal.valueOf(prix.montantTTC).setScale(3); prixElec.CoACHHPBHT = Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                    }
                                                                                    else if(prix.caracteristiquesElec.typeComptage.code == 'R' && (ftaOutput == 'BTINFCU4' || ftaOutput == 'BTINFMU4')){
                                                                                        prixElec.CoACHHCBTTC = Decimal.valueOf(prix.montantTTC).setScale(3); prixElec.CoACHHCBHT = Decimal.valueOf(prix.montantHT).setScale(3);
                                                                                    }
                                                                                    
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                               
                                                                    if(typeOfProduct.get(data.idOffre) == 'TradeOFF'){
                                                                        prixElec.prixMensuel = calculatePrixMensuel (prixElec.TOTAB, prixElec.TOTCO, CAEElec);
                                                                        prixGaz.prixMensuel = calculatePrixMensuel (prixGaz.TOTAB, prixGaz.TOTCO, CAR);
                                                                    }
                                                                    else{
                                                                        prixElec.prixMensuel = calculatePrixMensuel (prixElec.AboTTC, prixElec.CoTTC,prixElec.CoTTCHC,  estHP, estHC);
                                                                        prixGaz.prixMensuel = calculatePrixMensuel (prixGaz.AboTTC, prixGaz.CoTTC, CAR);
                                                                    }
                                                                    // Start DDPCM 1192
                                                                    String family = productFamily.get(idOffre);
                                                                    String familyLabel = productFamilyLabels.get(family);
                                                                    system.debug('choixOffre.OffrePousse__c '+choixOffre.OffrePousse__c);
                                                                    system.debug('choixOffre.offreRepli__c'+choixOffre.offreRepli__c);
                                                                    system.debug('fam '+family);
                                                                    system.debug('familyLabel '+familyLabel);
                                                                    system.debug('fam '+idOffre);
                                                                    if(choixOffre.OffrePousse__c == family){ 
                                                                        if( typeOfProduct.get(idOffre)=='TradeOFF'){offresToShow.isTradeOffPoussee=true; }
                                                                        if(offresToShow.offrePoussee == null ){ offresToShow.offrePoussee = new Offre(family, familyLabel, idOffre, null, null); }
                                                                        if(productArticle!= null && productArticle.containsKey(idOffre)&& ArticleKnowledge!= null && ArticleKnowledge.containsKey(productArticle.get(idOffre))){
                                                                            offresToShow.offrePoussee.descriptif1 = ArticleKnowledge.get(productArticle.get(idOffre)).removeEnd('.').substringBeforeLast('.');
                                                                            offresToShow.offrePoussee.descriptif2 = ArticleKnowledge.get(productArticle.get(idOffre)).removeEnd('.').substringAfterLast('.');
                                                                        }
                                                                        if(isGaz){
                                                                            offresToShow.offrePoussee.secteurActiviteGaz = secteurActivite;
                                                                            offresToShow.offrePoussee.codeGaz = idOffre; offresToShow.offrePoussee.prixGaz = prixGaz;
                                                                        }
                                                                        else{
                                                                            offresToShow.offrePoussee.ftaOutput = ftaOutput;offresToShow.offrePoussee.secteurActiviteElec = secteurActivite;
                                                                            offresToShow.offrePoussee.codeElec = idOffre;offresToShow.offrePoussee.prixElec = prixElec;
                                                                            offresToShow.offrePoussee.MesureFournisseurElec = productstructureFournisseur.get(idOffre);
                                                                            offresToShow.offrePoussee.PourcentageOffreVertElec = productOffreVerte.get(idOffre);
                                                                        }
                                                                        if(energie== 'Duo' && offresToShow.offrePoussee.prixElec!= null && offresToShow.offrePoussee.prixElec.PrixMensuel!= null 
                                                                           && offresToShow.offrePoussee.prixGaz != null && offresToShow.offrePoussee.prixGaz.PrixMensuel!= null)
                                                                        {
                                                                            offresToShow.offrePoussee.totalPrice = offresToShow.offrePoussee.prixElec.PrixMensuel + offresToShow.offrePoussee.prixGaz.PrixMensuel;
                                                                        }
                                                                        else if(energie== 'Elec' && offresToShow.offrePoussee.prixElec!= null && offresToShow.offrePoussee.prixElec.PrixMensuel!= null){
                                                                            offresToShow.offrePoussee.totalPrice = offresToShow.offrePoussee.prixElec.PrixMensuel;
                                                                        }
                                                                        else if(energie== 'Gaz' && offresToShow.offrePoussee.prixGaz!= null && offresToShow.offrePoussee.prixGaz.PrixMensuel!= null){
                                                                            offresToShow.offrePoussee.totalPrice = offresToShow.offrePoussee.prixGaz.PrixMensuel;
                                                                        }
                                                                    }
                                                                    else if(choixOffre.offreRepli__c == family){
                                                                        if( typeOfProduct.get(idOffre)=='TradeOFF'){offresToShow.isTradeOffRepli=true; }
                                                                        if(offresToShow.offreDeReplis == null ){ offresToShow.offreDeReplis = new Offre(family, familyLabel, idOffre, null, null);  }
                                                                        if(productArticle!= null && productArticle.containsKey(idOffre)&& ArticleKnowledge!= null && ArticleKnowledge.containsKey(productArticle.get(idOffre))){
                                                                            offresToShow.offreDeReplis.descriptif1 = ArticleKnowledge.get(productArticle.get(idOffre)).removeEnd('.').substringBeforeLast('.');
                                                                            offresToShow.offreDeReplis.descriptif2 = ArticleKnowledge.get(productArticle.get(idOffre)).removeEnd('.').substringAfterLast('.');
                                                                        }
                                                                        if(isGaz){ 
                                                                            offresToShow.offreDeReplis.secteurActiviteGaz = secteurActivite; offresToShow.offreDeReplis.codeGaz = idOffre;offresToShow.offreDeReplis.prixGaz = prixGaz;
                                                                        }
                                                                        else{
                                                                            offresToShow.offreDeReplis.ftaOutput = ftaOutput; offresToShow.offreDeReplis.secteurActiviteElec = secteurActivite;
                                                                            offresToShow.offreDeReplis.codeElec = idOffre; offresToShow.offreDeReplis.prixElec = prixElec;
                                                                            offresToShow.offreDeReplis.MesureFournisseurElec = productstructureFournisseur.get(idOffre);
                                                                            offresToShow.offreDeReplis.PourcentageOffreVertElec = productOffreVerte.get(idOffre);
                                                                        }
                                                                        if(energie== 'Duo' && offresToShow.offreDeReplis.prixElec!= null && offresToShow.offreDeReplis.prixElec.PrixMensuel!= null && offresToShow.offreDeReplis.prixGaz != null && offresToShow.offreDeReplis.prixGaz.PrixMensuel!= null){
                                                                               offresToShow.offreDeReplis.totalPrice = offresToShow.offreDeReplis.prixElec.PrixMensuel + offresToShow.offreDeReplis.prixGaz.PrixMensuel;}
                                                                        else if(energie== 'Elec' && offresToShow.offreDeReplis.prixElec!= null && offresToShow.offreDeReplis.prixElec.PrixMensuel!= null){offresToShow.offreDeReplis.totalPrice = offresToShow.offreDeReplis.prixElec.PrixMensuel;}
                                                                        else if(energie== 'Gaz' && offresToShow.offreDeReplis.prixGaz!= null && offresToShow.offreDeReplis.prixGaz.PrixMensuel!= null){ offresToShow.offreDeReplis.totalPrice = offresToShow.offreDeReplis.prixGaz.PrixMensuel;}
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                    system.debug('offresToShow'+ offresToShow);
                                                    return offresToShow; 
                                                }
    
    /* @author Amal Chreiteh
* @date 2/12/2020
* @description Creation de l'input pour la recherche d'une offre
* @param 
* @return VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt wrapper defined in this class: VI_gdfsuezBefCalypsoPrixetremisesV2
*/
    
    @AuraEnabled(cacheable=false)
    public static VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt 
        prepareOffer(      String codeCommune, 
                     String codePostal/*not required can be set to null*/, 
                     String idPack /*Family*/, 
                     String[] idOffre/*ids of the offers belonging to the product family*/,
                     String puissance/*filled by the puissance only for Elec - not required*/,
                     String pourcentageOffreVerte/* si offre verte exist, rempli par 100 - only for Elec*/,
                     String structureMesureFournisseur/* structureMesureFournisseur sur product2 - only for Elec */,
                     Integer CAEElec /*Consommation - only for Elec */,
                     String niveauOuvertureService/* filled with 0, 1 or 2 */,
                     String plageConsommation/*for gaz only plageConsommation - not required*/,
                     DateTime dateEffetContrat/*Datetime.newInstanceGmt(d.year(), d.month(), d.day());*/, 
                     DateTime dateDerniereModificationFormuleTarifaireAcheminement/*filled only in case of CHF*/,
                     String formuleTarifaireAcheminement/*codeFTA - filled only in case of CHF*/,
                     String contexteSouscription/*'CHGT_FOURN' ou 'MES_EMM'*/)
    {
        VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesInputDt input = VI_SM022_PrixEtRemises.createInputV2(  codeCommune, codePostal,idPack,  null/*idGroupeOffres - not used by SMILE can be set to null*/,
                                                                                                                        idOffre,null/* typePrix - not used by SMILE can be set to null*/,
                                                                                                                        null /*versionUtilisation - not used by SMILE can be set to null*/ ,
                                                                                                                        puissance,'Simple'/*typeComptage - not used by SMILE can be set to null*/,
                                                                                                                        pourcentageOffreVerte,structureMesureFournisseur,CAEElec,null/*CoefRepartition - not used by SMILE can be set to null*/, 
                                                                                                                        niveauOuvertureService,plageConsommation,null/*CAEGaz - not used by SMILE can be set to null*/, 
                                                                                                                        null/*caracteristique - not used by SMILE can be set to null*/,
                                                                                                                        dateEffetContrat,system.now()/*datePropositionCommerciale*/,
                                                                                                                        dateEffetContrat/*dateValiditePrix*/,  
                                                                                                                        'PPO'/*enseigneSouscription - same as SMILE*/,
                                                                                                                        null/*motifSouscriptionPropositionCommerciale - not used by SMILE can be set to null*/, 
                                                                                                                        null/*typeDonneesRemontees - not used by SMILE can be set to null*/, 
                                                                                                                        dateDerniereModificationFormuleTarifaireAcheminement,
                                                                                                                        formuleTarifaireAcheminement,contexteSouscription);
        XMLSerializer serializer1 = new XMLSerializer();
        String serializedXML1 = serializer1.serialize(input,true, null); 
        system.debug('serializedXML rechercherPrixEtRemisesInputDt '+ serializedXML1);
        return input;
    }
    

    public class wrapperPrix {
        @AuraEnabled
        public String typeEnergie;
        @AuraEnabled
        public Double AboTTC;
        @AuraEnabled
        public Double AboHT;
        @AuraEnabled
        public Double CoTTC;
        @AuraEnabled
        public Double CoHT;
        @AuraEnabled
        public Double TOTAB;
        @AuraEnabled
        public Double TOTABHT;
        @AuraEnabled
        public Double TOTCO;
        @AuraEnabled
        public Double TOTCOHT;
        @AuraEnabled
        public Double AboACHTTC;// tradeOff
        @AuraEnabled
        public Double AboACHHT;//tradeoff
        @AuraEnabled
        public Double CoACHTTC;// tradeOff - 1 cadran
        @AuraEnabled
        public Double CoACHHT;// tradeOff - 1 cadran
        @AuraEnabled
        public Double CoACHHCTTC;// tradeOff - 2 cadrans
        @AuraEnabled
        public Double CoACHHCHT;// tradeOff- 2 cadrans
        @AuraEnabled
        public Double CoACHHCHTTC;// tradeOff- 4 cadrans HC Haute
        @AuraEnabled
        public Double CoACHHCHHT;// tradeOff - 4 cadrans HC Haute
        @AuraEnabled
        public Double CoACHHCBTTC;// tradeOff - 4 cadrans HC Basse
        @AuraEnabled
        public Double CoACHHCBHT;// tradeOff - 4 cadrans HC Basse
        @AuraEnabled
        public Double CoACHHPHTTC;// tradeOff- 4 cadrans HP Haute
        @AuraEnabled
        public Double CoACHHPHHT;// tradeOff - 4 cadrans HP Haute
        @AuraEnabled
        public Double CoACHHPBTTC;// tradeOff - 4 cadrans HP Basse
        @AuraEnabled
        public Double CoACHHPBHT;// tradeOff - 4 cadrans HP Basse
        @AuraEnabled
        public Double CoTTCHC;
        @AuraEnabled
        public Double CoHTHC;
        @AuraEnabled
        public Double CoTTCHWE;
        @AuraEnabled
        public Double CoHTHWE;
        @AuraEnabled
        public Double ObTTC;//tradeOff	
        @AuraEnabled
        public Double ObHT;//tradeoff
        @AuraEnabled
        public Double prixMensuel;
        public wrapperPrix(String typeEnergie){
            this.typeEnergie = typeEnergie;
        }
    }
    
    public class Offre{
        
        @AuraEnabled
        public String idPack;
        @AuraEnabled
        public String libelle;
        @AuraEnabled
        public String code;
        @AuraEnabled
        public String codeElec;
        @AuraEnabled
        public String secteurActiviteElec;
        @AuraEnabled
        public String codeGaz;
        @AuraEnabled
        public String secteurActiviteGaz;
        @AuraEnabled
        public String MesureFournisseurElec;
        @AuraEnabled
        public String PourcentageOffreVertElec;
        @AuraEnabled
        public String descriptif1;
        @AuraEnabled
        public String descriptif2;
        @AuraEnabled
        public wrapperPrix prixGaz;
        @AuraEnabled
        public wrapperPrix prixElec;
        @AuraEnabled
        public Decimal totalPrice;
        @AuraEnabled
        public String ftaOutput;
        public Offre(String idPack, String libelle, String code, wrapperPrix prixGaz, wrapperPrix prixElec ){
            this.idPack = idPack;
            this.libelle = libelle;
            this.code =code;
            this.prixGaz = prixGaz;
            this.prixElec = prixElec;
            Double prixG = (prixGaz!= null && prixGaz.prixMensuel!= null?prixGaz.prixMensuel:0);
            Double prixE = (prixElec!= null && prixElec.prixMensuel!= null?prixElec.prixMensuel:0);
            this.totalPrice = Decimal.valueOf(prixG + prixE).setscale(2);
        }
    }
    
    public class OffreList{
        @AuraEnabled
        public VI_parcours__c parcours;
        @AuraEnabled
        public Offre offrePoussee;
        @AuraEnabled
        public Offre offreDeReplis;
        @AuraEnabled
        public String optionCode;
        @AuraEnabled
        public String optionLabel;
        @AuraEnabled
        public Decimal optionValue;
        @AuraEnabled
        public Decimal optionValueHT;
        @AuraEnabled
        public String optionCodeGaz;
        @AuraEnabled
        public String optionLabelGaz;
        @AuraEnabled
        public Decimal optionValueGaz;
        @AuraEnabled
        public Decimal optionValueGazHT;
        @AuraEnabled
        public String message;
        @AuraEnabled
        public Boolean isTradeOffPoussee=false;
        @AuraEnabled
        public Boolean isTradeOffRepli=false;
        public OffreList(){
        }
    }
    public class optionValues{
        @AuraEnabled
        public Decimal optionValue;
        @AuraEnabled
        public Decimal optionValueHT;
        public optionValues(Decimal optionValue, Decimal optionValueHT){
            this.optionValue = optionValue;
            this.optionValueHT = optionValueHT;
        }
    }
    
    public static Decimal calculatePrixMensuel(Double AboTTC,Double coTTC, Double CAECAR) {
        Double mens;
        Decimal mensCalcule = null;
        if(AboTTC!= null && coTTC != null &&  CAECAR!= null ){
            mens = (AboTTC+(coTTC*CAECAR))/11;
            mensCalcule= Decimal.valueOf(mens).setscale(0);
        }
        return mensCalcule;
    }
    
    public static Decimal calculatePrixMensuel(Double AboTTC,Double coTTC, Double CoTTCHC, Double EstHP, Double EstHC) {
        Double mens;
        Decimal mensCalcule = null;
        if(AboTTC!= null && coTTC != null &&  EstHP!= null ){
            if(CoTTCHC != null && EstHC != null){
                mens = (AboTTC+(coTTC*EstHP)+ (CoTTCHC*EstHC))/11;
                mensCalcule= Decimal.valueOf(mens).setscale(0); 
            }
            else{
                mens = (AboTTC+(coTTC*EstHP))/11;
                mensCalcule= Decimal.valueOf(mens).setscale(0);
            }
            
        }
        
        return mensCalcule;
    }
    
    /**
* @author CLément BOUQUIN
* @date 28/07/2021
* @description Récupération des inforamations du contact reliés au parcours pour le formulaire d'AF
* @param parcours provenant du lwc qui contient
* @return contactX contactInfo qui contient les info préremplis du contact pour le formulaire d'AF
*/
    
    @AuraEnabled(cacheable=false)
    public static contactX getInfoSelectedContact(VI_parcours__c parcours) {
        List<Contact> contacts = [SELECT Id, LastName, FirstName, Salutation 
                                  FROM Contact 
                                  WHERE Id  =: parcours.VI_Contact__c];
        contactX contactInfo = new ContactX(contacts[0]);
        return contactInfo;
    }
    
    public class ContactX{
        @AuraEnabled
        public String LastName{get;set;}
        @AuraEnabled
        public String FirstName{get;set;}
        @AuraEnabled
        public String Salutation{get;set;}
        
        public ContactX(Contact contact){
            this.LastName = contact.LastName;
            this.FirstName = contact.FirstName;
            this.Salutation = contact.Salutation;
        }
    }
    
}