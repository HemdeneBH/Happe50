/*@Author: RWA
*@Description: class de test des offres
*@CreatedDate:
*@LastModified: RJM 23/04/2020
*/
@isTest
public class SM_AP11_OffresEtPrixTest {
    /*@Author: RWA
*@Description: setup du WS prix et remise
*@CreatedDate:
*@LastModified: MHA 22/02/2019
*/
    @testSetup static void setup() {
        SM_AP08_TestLib.insertCS_SMOCTOPUS();
    }
    /*@Author: RWA
*@Description: test de l'appel Dual
*@CreatedDate:
*@LastModified: RJM 23/04/2020
*/
    @isTest static void testCalloutDual() {
        Product2  offreDuo = new Product2();
        offreDuo.FamilyLabel__c = 'Duo Energie Garantie 3 ans';
        offreDuo.name = 'Gaz Energie Garantie 3 ans';
        offreDuo.Family = 'DGBUEBUKF3VGO_P';
        offreDuo.vlocity_cmt__SpecificationType__c = 'Offre poussée';
        offreDuo.vlocity_cmt__Type__c = 'Duo';
        offreDuo.ProductCode = 'DGBUEBUKF3VGO_P';
        offreDuo.IsActive = true;
        Product2 offreDuorepli = new Product2();
        offreDuorepli.FamilyLabel__c = 'Duo Energie Garantie 2 ans';
        offreDuorepli.Family = 'DGBUEBUKF2VGO_P';
        offreDuorepli.name = 'Gaz Energie Garantie 2 ans';
        offreDuorepli.vlocity_cmt__SpecificationType__c = 'Offre de repli';
        offreDuorepli.vlocity_cmt__Type__c = 'Duo'; //'Duo';
        offreDuorepli.SM_structureMesureFournisseur__c = 'SMF3C0PM001';
        offreDuorepli.ProductCode = 'DGBUEBUKF2VGO_P';
        offreDuoRepli.TypeOffre__c = 'TradeOFF';
        offreDuorepli.IsActive = true;
        List<Product2> prodList = new List<Product2>();
        prodList.add(offreDuo);
        prodList.add(offreDuorepli);
        insert prodList;
        Choix_Offre__c choixOffre = new Choix_Offre__c();
        choixOffre.ChoixOffrerepli__c = offreDuo.Id;
        choixOffre.ChoixOffrePousseeLinky__c = offreDuo.Id;
        choixOffre.ChoixOffrePoussee__c = offreDuorepli.Id;
        choixOffre.debut_Validite_Offre__c = date.today();
        choixOffre.Energie__c = 'Duo';
        choixOffre.Actif__c = true;
        insert choixOffre;
        Test.startTest();
        Map < String, Object > inputMapCE = new Map < String, Object >();
        inputMapCE.put('EnergyTypeOptions', 'Duo'); //'Duo');
        inputMapCE.put('EffectiveDate', '2018-07-03 00:00:00');
        inputMapCE.put('chooseSellingOption','Emmenagement'); 
        Map<String, Object> mapParam = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        /*Build map for PDL/PCE fields*/
        Map<String, String> inputPDLPCEValues = new Map<String, String>();
        inputPDLPCEValues.put('PCENumber', '01100144562464');
        inputPDLPCEValues.put('PDLNumber', '01199999844520');
        inputMapCE.put('citycodeValue', '59350');
        inputMapCE.put('postcodeValue', '59000');
        inputMapCE.put('niveauOuvertureServices', 'Niveau 0');
        inputMapCE.put('dateDerniereModificationFormuleTarifaireAcheminement','2018-07-03 00:00:00');
        inputMapCE.put('searchAddr', '185 Rue Solférino 59000 Lille');
        inputMapCE.put('codePlageConso', '6000');
        inputMapCE.put('codeTypeComptage', 'S');
        inputMapCE.put('puissance', '3');
        inputMapCE.put('ftaCode', '32');
        inputMapCE.put('typeComptageDifferencie', 'Triple');
        inputMapCE.put('typeCompteur', 'LINKY');
        inputMapCE.put('CAR', 5500);
        inputMapCE.put('CAE', 5500);
        inputMapCE.put('CAE_HC', 2500);
        inputMapCE.put('CAE_HP', 1000);
        inputMapCE.put('CAE_WE', 5478);
        SM_AP11_OffresEtPrix service = new SM_AP11_OffresEtPrix() ;
        SM_AP11_OffresEtPrix.typeOfProduct.put('DGBUEBUKF2VGO_P','TradeOFF');
        SM_AP11_OffresEtPrix.typeOfProduct.put('DGBUEBUKF3VGO_P','non TradeOFF');
        SM_AP11_OffresEtPrix.Article article = new SM_AP11_OffresEtPrix.Article();
        article.url= '/test';
        article.preview = 'preview';
        service.invokeMethod('getOffresEtPrix', inputMapCE,  outputMap, null);
        system.debug('@outputMap: '+outputMap);
        Test.stopTest();
    }
   /*@Author: RJM
*@Description: test de l'appel Gaz
*@CreatedDate:
*@LastModified: RJM 23/04/2020
*/  
        @isTest static void testCalloutGaz() {
        Product2 offreGaz = new Product2();
        offreGaz.FamilyLabel__c = 'Gaz Ajust 3 ans';
        offreGaz.name = 'Gaz Ajust 3 ans';
        offreGaz.Family = 'GBUAK3_P';
        offreGaz.vlocity_cmt__SpecificationType__c = 'Offre poussée';
        offreGaz.vlocity_cmt__Type__c = 'Gaz';
        offreGaz.ProductCode = 'GBUA3';
        offreGaz.IsActive = true;
        Product2 offreDuorepliGaz = new Product2();
        offreDuorepliGaz.FamilyLabel__c = 'Gaz Ajust 4 ans';
        offreDuorepliGaz.Family = 'GBUAK4_P';
        offreDuorepliGaz.name = 'Gaz Ajust 4 ans';
        offreDuorepliGaz.vlocity_cmt__SpecificationType__c = 'Offre de repli';
        offreDuorepliGaz.vlocity_cmt__Type__c = 'Gaz'; //'Duo';
        offreDuorepliGaz.ProductCode = 'GBUA4';
        offreDuorepliGaz.TypeOffre__c = 'TradeOFF';
        offreDuorepliGaz.IsActive = true;
        List<Product2> prodList = new List<Product2>();
        prodList.add(offreGaz);
        prodList.add(offreDuorepliGaz);
        insert prodList;
        Choix_Offre__c choixOffre = new Choix_Offre__c();
        choixOffre.ChoixOffrerepli__c = offreGaz.Id;
        choixOffre.ChoixOffrePousseeLinky__c = offreGaz.Id;
        choixOffre.ChoixOffrePoussee__c = offreDuorepliGaz.Id;
        choixOffre.debut_Validite_Offre__c = date.today();
        choixOffre.Energie__c = 'Gaz';
        choixOffre.Actif__c = true;
        insert choixOffre;
        Test.startTest();
        Map < String, Object > inputMapCE = new Map < String, Object >();
        inputMapCE.put('EnergyTypeOptions', 'Gaz'); //'Duo');
        inputMapCE.put('EffectiveDate', '2018-07-03 00:00:00');
        inputMapCE.put('chooseSellingOption','Changement de fournisseur'); 
        Map<String, Object> mapParam = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        inputMapCE.put('citycodeValue', '59350');
        inputMapCE.put('postcodeValue', '59000');
        inputMapCE.put('searchAddr', '185 Rue Solférino 59000 Lille');
        inputMapCE.put('niveauOuvertureServices', 'Niveau 1');
        inputMapCE.put('codePlageConso', '6000');
        inputMapCE.put('codeTypeComptage', 'S');
        inputMapCE.put('puissance', '3');
        inputMapCE.put('ftaCode', '32');
        inputMapCE.put('CAR', 5500);
        SM_AP11_OffresEtPrix service = new SM_AP11_OffresEtPrix() ;
        SM_AP11_OffresEtPrix.Article article = new SM_AP11_OffresEtPrix.Article();
        article.url= '/test';
        article.preview = 'preview';
        service.invokeMethod('getOffresEtPrix', inputMapCE,  outputMap, null);
        system.debug('@outputMap: '+outputMap);
        Test.stopTest();
    }
    /*@Author: RWA
*@Description: test des static méthode
*@CreatedDate:
*@LastModified: RJM 23/04/2020
*/
    @isTest static void testStaticMethodsForCoverage() {
        Datetime nowdateTime =  Datetime.now();
        //Static getPrix
        try {
            List<String> stringList = new List<String>();
            stringList.add('Elec'); stringList.add('Elec');
            Map<String, List<String>> mapPackOffres = new Map<String, List<String>>();
            mapPackOffres.put('Elec', stringList);
            Map<String, SM_AP11_OffresEtPrix.Article> mapArticle = new Map<String, SM_AP11_OffresEtPrix.Article>();
            Map<String, Boolean> mapisOffreRepli = new Map<String, Boolean>();
            Map<String, Boolean> mapIsOffreVerte = new Map<String, Boolean>();
            String contextMoveIn = '';
            String packCode = '';
            String codeOffreGaz = '';
            String codeOffreElec = '';
            List<SM_AP11_OffresEtPrix.PrixOffreConsolide> listPrixOffre = SM_AP11_OffresEtPrix.getPrix('codeFTA',String.ValueOf(system.now()),'contSouscriptionCode','codeCommune', 'codePostal', mapPackOffres, new Map<String, String>(), new Map<String, Boolean>(),new Map<String,String>() ,nowdateTime, 'plageconso', 'vpuissance', 'typeDeComptage','2',20000, 20000,2000,2000,2000, mapArticle, mapisOffreRepli,contextMoveIn, packCode, codeOffreGaz, codeOffreElec,mapIsOffreVerte);
        } catch (exception e) {}
        //Static test wrapperPrix
        Double dnum = 4.2;
        Map<String, Map<String, Double>>  mapConsoByType = new Map<String, Map<String, Double>>();
        Map<String, Double> mapStringDouble1 = new Map<String, Double>();
        mapStringDouble1.put('TTC', 4.21);
        mapStringDouble1.put('HT', 4.21);
        mapConsoByType.put('P', mapStringDouble1);
        Map<String, Double> mapStringDouble2 = new Map<String, Double>();
        mapStringDouble2.put('TTC', 4.21);
        mapStringDouble2.put('HT', 4.21);
        mapConsoByType.put('C', mapStringDouble2);
        Map<String, Double> mapStringDouble3 = new Map<String, Double>();
        mapStringDouble3.put('TTC', 4.21);
        mapStringDouble3.put('HT', 4.21);
        mapConsoByType.put('D', mapStringDouble3); 
        Map<String, Double> mapStringDouble4 = new Map<String, Double>();
        mapStringDouble4.put('TTC', 4.21);
        mapStringDouble4.put('HT', 4.21);
        mapConsoByType.put('WE', mapStringDouble4); 
        Map<String, Double> mapStringDouble6 = new Map<String, Double>();
        mapStringDouble6.put('TTC', 4.21);
        mapStringDouble6.put('HT', 4.21);
        mapConsoByType.put('ACHAB', mapStringDouble6); 
        Map<String, Double> mapStringDouble7 = new Map<String, Double>();
        mapStringDouble7.put('TTC', 4.21);
        mapStringDouble7.put('HT', 4.21);
        mapConsoByType.put('AB', mapStringDouble7); 
        Map<String, Double> mapStringDouble8 = new Map<String, Double>();
        mapStringDouble8.put('TTC', 4.21);
        mapStringDouble8.put('HT', 4.21);
        mapConsoByType.put('OB', mapStringDouble8); 
        Map<String, Double> mapStringDouble9 = new Map<String, Double>();
        mapStringDouble9.put('TTC', 4.21);
        mapStringDouble9.put('HT', 4.21);
        mapConsoByType.put('ACHCO', mapStringDouble9); 
        Map<String, Double> mapStringDouble10 = new Map<String, Double>();
        mapStringDouble10.put('TTC', 4.21);
        mapStringDouble10.put('HT', 4.21);
        mapConsoByType.put('CO', mapStringDouble10); 
        Map<String, Double> mapStringDouble11 = new Map<String, Double>();
        mapStringDouble11.put('TTC', 4.21);
        mapStringDouble11.put('HT', 4.21);
        mapConsoByType.put('R', mapStringDouble11); 
        Map<String, Double> mapStringDouble12 = new Map<String, Double>();
        mapStringDouble12.put('TTC', 4.21);
        mapStringDouble12.put('HT', 4.21);
        mapConsoByType.put('L', mapStringDouble12);
        Map<String, Double> mapStringDouble13 = new Map<String, Double>();
        mapStringDouble13.put('TTC', 4.21);
        mapStringDouble13.put('HT', 4.21);
        mapConsoByType.put('A', mapStringDouble13);
        Map<String, Double> mapStringDouble14 = new Map<String, Double>();
        mapStringDouble14.put('TTC', 4.21);
        mapStringDouble14.put('HT', 4.21);
        mapConsoByType.put('U', mapStringDouble14);
        Map<String, Double> mapStringDouble15 = new Map<String, Double>();
        mapStringDouble15.put('TTC', 4.21);
        mapStringDouble15.put('HT', 4.21);
        mapConsoByType.put('COWE', mapStringDouble15);
        Map<String, Double> mapStringDouble16 = new Map<String, Double>();
        mapStringDouble16.put('TTC', 4.21);
        mapStringDouble16.put('HT', 4.21);
        mapConsoByType.put('COHC', mapStringDouble16);
        Map<String, Double> mapStringDouble17 = new Map<String, Double>();
        mapStringDouble17.put('TTC', 4.21);
        mapStringDouble17.put('HT', 4.21);
        mapConsoByType.put('COHP', mapStringDouble17);
        Map<String, Double> mapStringDouble18 = new Map<String, Double>();
        mapStringDouble18.put('TTC', 4.21);
        mapStringDouble18.put('HT', 4.21);
        mapConsoByType.put('COC', mapStringDouble18);
        Map<String, Double> mapStringDouble19 = new Map<String, Double>();
        mapStringDouble19.put('TTC', 4.21);
        mapStringDouble19.put('HT', 4.21);
        mapConsoByType.put('COP', mapStringDouble19);
        Map<String, Double> mapStringDouble20 = new Map<String, Double>();
        mapStringDouble20.put('TTC', 4.21);
        mapStringDouble20.put('HT', 4.21);
        mapConsoByType.put('COS', mapStringDouble20);
        SM_AP11_OffresEtPrix.wrapperPrix wp1 = new SM_AP11_OffresEtPrix.wrapperPrix('typeEnergie', dnum, dnum, mapConsoByType);
        SM_AP11_OffresEtPrix.wrapperPrix wp2 = new SM_AP11_OffresEtPrix.wrapperPrix('typeEnergie', 0, 0, mapConsoByType);
        //Static test PrixOffreConsolide
        List<String> idOffreList = new List<String>();
        SM_AP11_OffresEtPrix.Article article = new SM_AP11_OffresEtPrix.Article();
        article.url= '/test';
        article.preview = 'preview';
        SM_AP11_OffresEtPrix.PrixOffreConsolide poc = new SM_AP11_OffresEtPrix.PrixOffreConsolide('libelleOffre', 'codeOffre', true, 'idPack', idOffreList, wp2, wp2, 20000, 20000,2000,2000,2000, article,'', true);
        SM_AP11_OffresEtPrix.PrixOffreConsolide poc2 = new SM_AP11_OffresEtPrix.PrixOffreConsolide('libelleOffre', 'codeOffre', true, 'idPack', idOffreList, wp1, wp1, 20000, 20000,2000,2000,2000, article,'', false);
        //Static test initContext(String application, String version)
        SM_AP11_OffresEtPrix.initContext('application', 'version');
        //Static test calculMens
        List<Double> mapConsoByCAECAR = new List<Double>();
        mapConsoByCAECAR.add(dnum);
        SM_AP11_OffresEtPrix.calculMens(dnum, mapConsoByCAECAR, dnum);
        //Static test calculMensTradeOFF
        SM_AP11_OffresEtPrix.calculMensTradeOFF(dnum, dnum, dnum);
    }
}