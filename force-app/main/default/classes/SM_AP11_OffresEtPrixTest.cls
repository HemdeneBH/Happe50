/*@Author: RWA
*@Description: class de test des offres
*@CreatedDate:
*@LastModified: MHA 22/02/2019
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
  /* @isTest static void testWrapper() {
	   String libelleOffre='';
	   String codeOffre='';
	   String aboElec='';
	   String consoElec='';
	   String mensElec='';
	   String aboGaz='';
	   String consoGaz='';
	   String mensGaz='';
	   Boolean isOffrePoussee=false;
	   SM_AP11_OffresEtPrix.PrixOffreConsolide pOC=new SM_AP11_OffresEtPrix.PrixOffreConsolide(libelleOffre,codeOffre,aboElec,consoElec,mensElec,aboGaz,consoGaz,mensGaz,isOffrePoussee);

   }*/

  /*@Author: RWA
  *@Description: test de l'appel
  *@CreatedDate:
  *@LastModified: MHA 22/02/2019
  */
  @isTest static void testCallout() {

	/* Build propositions */
	/*   List<Object> ResultOfferMatrix = new List<Object>();
	   Map<string,Object> offerMatrix=new Map<string,Object>();
		Map<string,Object> propostionsInput=new Map<string,Object>();
	   propostionsInput.put('OffresPousseesMatrixDual__PropositionN1Conseiller','EBUKF3V100');
	   propostionsInput.put('OffresPousseesMatrixDual__PropositionN1Conseiller','EBUKF2V100');
	offerMatrix.put('ResultOfferMatrix',propostionsInput);
	ResultOfferMatrix.add(offerMatrix)    ;*/


	Product2  offreDuo = new Product2();
	offreDuo.FamilyLabel__c = 'Duo Ajust 3 ans';
	offreDuo.name = 'Gaz Ajust 3 ans';
	offreDuo.Family = 'DGBUEBUF3AK_P';
	offreDuo.vlocity_cmt__SpecificationType__c = 'Offre poussée';
	offreDuo.vlocity_cmt__Type__c = 'Gaz';
	offreDuo.ProductCode = 'EBUKF3V100';
	offreDuo.IsActive = true;

	Product2 offreDuorepli = new Product2();
	offreDuorepli.FamilyLabel__c = 'Duo Energie Garantie 2 ans';
	offreDuorepli.Family = 'DGBUEBUKF2VGO_P';
	offreDuorepli.name = 'Gaz Energie Garantie 2 ans';
	offreDuorepli.vlocity_cmt__SpecificationType__c = 'Offre de repli';
	offreDuorepli.vlocity_cmt__Type__c = 'Elec'; //'Duo';
	offreDuorepli.ProductCode = 'EBUKF2V100';
	offreDuorepli.IsActive = true;

	List<Product2> prodList = new List<Product2>();
	prodList.add(offreDuo);
	prodList.add(offreDuorepli);
	insert prodList;
	Test.startTest();
	Map < String, Object > inputMapCE = new Map < String, Object >();
	inputMapCE.put('EnergyTypeOptions', 'Elec'); //'Duo');
	inputMapCE.put('EffectiveDate', '2018-07-03 00:00:00');
	inputMapCE.put('chooseSellingOption','Emmenagement'); 



	Map<String, Object> mapParam = new Map<String, Object>();
	Map<String, Object> outputMap = new Map<String, Object>();
	/*Build map for PDL/PCE fields*/
	Map<String, String> inputPDLPCEValues = new Map<String, String>();
	inputPDLPCEValues.put('PCENumber', '01100144562464');
	inputPDLPCEValues.put('PDLNumber', '01199999844520');
	/*   inputPDLPCEValues.put('PCENumber','01100144562464');
		   inputPDLPCEValues.put('PDLNumber','01199999844520');
		   mapParam.put('SearchByPDLPCE',inputPDLPCEValues);*/

	/* Build map for address if not same than existing*/
	//Map<String, String> inputAddr = new Map<String, String>();
	//inputAddr.put('id', 'ADRNIVX_0000000331881839');
	//Map<String, Object> inputMapAddr = new Map<String, Object>();
	//mapParam.put('SearchByAddress-Block', inputAddr);

	/* Build map for address if  same than existing*/
//	Map<String, String> inputAddrExist = new Map<String, String>();
	//inputAddrExist.put('isBillingAddressSameAsLiving', 'OUI');
	//inputMapCE.put('Address', inputAddrExist);

	//215 rue des piats
	/* mapParam.put('citycodeValue','59599');
		mapParam.put('postcodeValue','59200');*/

	inputMapCE.put('citycodeValue', '59350');
	inputMapCE.put('postcodeValue', '59000');
      inputMapCE.put('niveauOuvertureServices', 'Niveau 0');
      inputMapCE.put('dateDerniereModificationFormuleTarifaireAcheminement','2018-07-03 00:00:00');
	/* Build ChoixElements1*/
	//Map<string, Object> inputChoixElements1 = new Map<string, Object>();
	//inputChoixElements1.put('ChoixElements', inputMapCE);
	//inputChoixElements1.put('ChoixElements1', mapParam);
	inputMapCE.put('searchAddr', '185 Rue Solférino 59000 Lille');
	inputMapCE.put('codePlageConso', '6000');
	inputMapCE.put('codeTypeComptage', 'S');
	inputMapCE.put('puissance', '3');
      inputMapCE.put('ftaCode', '32');
    inputMapCE.put('typeComptageDifferencie', 'Triple');
       inputMapCE.put('typeCompteur', 'LINKY');
	inputMapCE.put('CAR', 5500);
	inputMapCE.put('CAE', 5500);
	


	Map < String, Object > inputMapDL = new Map < String, Object >();
	inputMapDL.put('EnergyTypeOptions', 'Gaz'); //'Duo');
	Map<String, String> mapObject = new Map<String, String> {'OffresPousseesMatrixGaz__PropositionN1Conseiller' => '', 'OffresPousseesMatrixGaz__PropositionN2Conseiller' => ''};
	inputMapDL.put('EffectiveDate', '2018-07-03 00:00:00');
      inputMapDL.put('chooseSellingOption','Changement de fournisseur'); 
      inputMapDL.put('citycodeValue', '59350');
	inputMapDL.put('postcodeValue', '59000');
	/* Build ChoixElements2*/
	Map<string, Object> inputChoixElements2 = new Map<string, Object>();
	//inputChoixElements2.put('ChoixElements', inputMapDL);
	//inputChoixElements2.put('ChoixElements1', mapParam);
	//inputChoixElements2.put('searchAddr', '185 Rue Solférino 59000 Lille');
	inputMapDL.put('codePlageConso', '6000');
	inputMapDL.put('codeTypeComptage', 'S');
	inputMapDL.put('puissance', '3');
	//inputChoixElements2.put('ResultOfferMatrix', new List<Map<String, Object>> {mapObject});


	SM_AP11_OffresEtPrix service = new SM_AP11_OffresEtPrix() ;
	service.invokeMethod('getOffresEtPrix', inputMapCE,  outputMap, null);
	service.invokeMethod('getOffresEtPrix', inputMapDL,  outputMap, null) ;
	system.debug('@outputMap: '+outputMap);
	Test.stopTest();
  }

  /*@Author: RWA
  *@Description: test des static méthode
  *@CreatedDate:
  *@LastModified: MHA 22/02/2019
  */
  @isTest static void testStaticMethodsForCoverage() {
	Datetime nowdateTime =  Datetime.now();
	//Static getPrix
	try {
	  List<String> stringList = new List<String>();
	  stringList.add('Elec'); stringList.add('Elec');
	  Map<String, List<String>> mapPackOffres = new Map<String, List<String>>();
	  mapPackOffres.put('Elec', stringList);
	  //SM_AP11_OffresEtPrix.Article
	  Map<String, SM_AP11_OffresEtPrix.Article> mapArticle = new Map<String, SM_AP11_OffresEtPrix.Article>();
	  List<SM_AP11_OffresEtPrix.PrixOffreConsolide> listPrixOffre = SM_AP11_OffresEtPrix.getPrix('codeFTA',String.ValueOf(system.now()),'contSouscriptionCode','codeCommune', 'codePostal', mapPackOffres, new Map<String, String>(), new Map<String, Boolean>(),new Map<String,String>() ,nowdateTime, 'plageconso', 'vpuissance', 'typeDeComptage','2',20000, 20000,2000,2000,2000,mapArticle);
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
	mapConsoByType.put('WE', mapStringDouble3);
	Map<String, Double> mapStringDouble4 = new Map<String, Double>();
	mapStringDouble4.put('TTC', 4.21);
	mapStringDouble4.put('HT', 4.21);
	mapConsoByType.put('D', mapStringDouble4);


	SM_AP11_OffresEtPrix.wrapperPrix wp1 = new SM_AP11_OffresEtPrix.wrapperPrix('typeEnergie', dnum, dnum, mapConsoByType, true);
	SM_AP11_OffresEtPrix.wrapperPrix wp2 = new SM_AP11_OffresEtPrix.wrapperPrix('typeEnergie', 0, 0, mapConsoByType, true);

	//Static test PrixOffreConsolide
	List<String> idOffreList = new List<String>();
	SM_AP11_OffresEtPrix.Article article = new SM_AP11_OffresEtPrix.Article();
	SM_AP11_OffresEtPrix.PrixOffreConsolide poc = new SM_AP11_OffresEtPrix.PrixOffreConsolide('libelleOffre', 'codeOffre', true, 'idPack', idOffreList, wp2, wp2, 20000, 20000,2000,2000,2000,article);
	SM_AP11_OffresEtPrix.PrixOffreConsolide poc2 = new SM_AP11_OffresEtPrix.PrixOffreConsolide('libelleOffre', 'codeOffre', true, 'idPack', idOffreList, wp1, wp1, 20000, 20000,2000,2000,2000,article);

	//Static test initContext(String application, String version)
	SM_AP11_OffresEtPrix.initContext('application', 'version');

	//Static test calculMens
	List<Double> mapConsoByCAECAR = new List<Double>();
	mapConsoByCAECAR.add(dnum);
	SM_AP11_OffresEtPrix.calculMens(dnum, mapConsoByCAECAR, dnum);

	SM_AP11_OffresEtPrix.calculConsommation(dnum,dnum);
  }
}