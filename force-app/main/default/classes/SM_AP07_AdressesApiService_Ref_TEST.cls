@isTest
public class SM_AP07_AdressesApiService_Ref_TEST {

	@testSetup static void setup() {
		SM_AP08_TestLib.insertCS_GenericEndpoints();
		SM_AP08_TestLib.insertCS_XDATACredentials();
	}


	@isTest
	public static void testSearchPdlPceFromPDL() {
		Test.startTest();
		Map<String, Object> mapParam = new Map<String, Object>();
        Map<String, Object> mapParam2 = new Map<String, Object>();
        Map<String, Object> mapParam3 = new Map<String, Object>();
		Map<String, Object> outputMap = new Map<String, Object>();
		/*Build map for PDL/PCE fields*/
		mapParam.put('selectedPCE', '01100144562464');
		mapParam2.put('selectedPDL', '01199999844520');

		/* Build map for address if not same than existing*/
		mapParam3.put('idAddr', 'ADRNIVX_0000000331881839');

		/* Build map for address if  same than existing*/
	//	Map<String, String> inputAddrExist = new Map<String, String>();
		mapParam.put('isBillingAddressSameAsLiving', 'OUI');
	//	mapParam.put('Address', inputAddrExist);


		/* Build ChoixElements1*/
	/*	Map<string, Object> inputChoixElements1 = new Map<string, Object>();
		inputChoixElements1.put('ChoixElements1', mapParam);*/
		mapParam.put('searchAddr', '185 Rue Solférino 59000 Lille');
		SM_AP07_AdressesApiService_Ref service = new SM_AP07_AdressesApiService_Ref() ;
		service.invokeMethod('searchAddress', mapParam,  outputMap, null) ;
        service.invokeMethod('searchAddress', mapParam2,  outputMap, null) ;
        service.invokeMethod('searchAddress', mapParam3,  outputMap, null) ;
        service.invokeMethod('getIdBanIfSameAddr', mapParam,  outputMap, null) ;
		System.debug('outputMap:' + outputMap);
		Map<String, Object> data = (Map<String, Object>)outputMap.get('data');
		List<Object> resultdata = (List<Object>)data.get('resultdata');
		SM_AP07_AdressesApiService_Ref.AdresseModel response1 = (SM_AP07_AdressesApiService_Ref.AdresseModel)resultdata[0];
		System.assertEquals(response1.citycode, '59599');
		System.assertEquals(response1.postcode, '59200');
		System.assertEquals(response1.valueChb, '215 RUE DES PIATS 59200 TOURCOING');
		Test.stopTest();
	}

/*
	@isTest
	public static void testSearchPdlPceFromPCE() {
		Test.startTest();
		Map<String, Object> mapParam = new Map<String, Object>();
		Map<String, Object> outputMap = new Map<String, Object>();

		Map<String, String> inputPDLPCEValues = new Map<String, String>();
		inputPDLPCEValues.put('PCENumber', '01100144562464');
		inputPDLPCEValues.put('PDLNumber', null);
		mapParam.put('SearchByPDLPCE', inputPDLPCEValues);


		Map<String, String> inputAddr = new Map<String, String>();
		inputAddr.put('id', 'ADRNIVX_0000000331881839');
		Map<String, Object> inputMapAddr = new Map<String, Object>();
		mapParam.put('SearchByAddress-Block', inputAddr);

		Map<String, String> inputAddrExist = new Map<String, String>();
		inputAddrExist.put('isBillingAddressSameAsLiving', 'OUI');
		mapParam.put('Address', inputAddrExist);



		Map<string, Object> inputChoixElements1 = new Map<string, Object>();
		inputChoixElements1.put('ChoixElements1', mapParam);
		inputChoixElements1.put('searchAddr', '185 Rue Solférino 59000 Lille');
		SM_AP07_AdressesApiService_Ref service = new SM_AP07_AdressesApiService_Ref() ;
		service.invokeMethod('searchAddress', inputChoixElements1,  outputMap, null) ;
		System.debug('outputMap:' + outputMap);
		Map<String, Object> data = (Map<String, Object>)outputMap.get('data');
		List<Object> resultdata = (List<Object>)data.get('resultdata');
		SM_AP07_AdressesApiService_Ref.AdresseModel response1 = (SM_AP07_AdressesApiService_Ref.AdresseModel)resultdata[0];
		System.assertEquals(response1.citycode, '59599');
		System.assertEquals(response1.postcode, '59200');
		System.assertEquals(response1.valueChb, '215 RUE DES PIATS 59200 TOURCOING');
		Test.stopTest();
	}

	@isTest
	public static void testSearchPdlPceFromAddr() {
		Test.startTest();
		system.debug('testSearchPdlPceFromAddr');
		Map<String, Object> mapParam = new Map<String, Object>();
		Map<String, Object> outputMap = new Map<String, Object>();

		Map<String, String> inputPDLPCEValues = new Map<String, String>();
		inputPDLPCEValues.put('PCENumber', null);
		inputPDLPCEValues.put('PDLNumber', null);
		mapParam.put('SearchByPDLPCE', inputPDLPCEValues);


		Map<String, String> inputAddr = new Map<String, String>();
		inputAddr.put('id', 'ADRNIVX_0000000331881839');
		Map<String, Object> inputMapAddr = new Map<String, Object>();
		mapParam.put('SearchByAddress-Block', inputAddr);

		Map<String, String> inputAddrExist = new Map<String, String>();
		inputAddrExist.put('isBillingAddressSameAsLiving', 'NON');
		mapParam.put('Address', inputAddrExist);


		Map<string, Object> inputChoixElements1 = new Map<string, Object>();
		inputChoixElements1.put('ChoixElements1', mapParam);
		inputChoixElements1.put('searchAddr', '185 Rue Solférino 59000 Lille');
		SM_AP07_AdressesApiService_Ref service = new SM_AP07_AdressesApiService_Ref() ;
		service.invokeMethod('searchAddress', inputChoixElements1,  outputMap, null) ;
		System.debug('outputMap:' + outputMap);
		Map<String, Object> data = new  Map<String, Object>();
	   // if(outputMap.get('_data') != null){
			data = (Map<String, Object>)outputMap.get('data');  
		List<Object> resultdata = (List<Object>)data.get('resultdata');
		SM_AP07_AdressesApiService_Ref.AdresseModel response1 = (SM_AP07_AdressesApiService_Ref.AdresseModel)resultdata[0];
		System.assertEquals(response1.citycode, '59599');
		System.assertEquals(response1.postcode, '59200');
		System.assertEquals(response1.valueChb, '215 RUE DES PIATS 59200 TOURCOING');
	   // }
		Test.stopTest();
	}
*/
	@isTest
	public static void testsearchAddressById() {
		Test.startTest();
		Map<String, Object> mapParam = new Map<String, Object>();
		Map<String, Object> outputMap = new Map<String, Object>();


		mapParam.put('idLogement', 'idLogementTest');
		SM_AP07_AdressesApiService_Ref service = new SM_AP07_AdressesApiService_Ref() ;
		service.invokeMethod('searchAddressById', mapParam,  outputMap, null) ;
		System.debug('outputMap:' + outputMap);
		Map<String, Object>results = (Map<String, Object>)outputMap.get('results');
		System.assertEquals(String.valueOf(results.get('PDL')),'01199999844520');
		System.assertEquals(String.valueOf(results.get('PCE')),'01100144562464');
		Test.stopTest();
	}

	@isTest
	public static void testgetAddressById() {
		Test.startTest();
		Map<String, Object> mapParam = new Map<String, Object>();
		Map<String, Object> outputMap = new Map<String, Object>();

		mapParam.put('idAddress', '41770');
		SM_AP07_AdressesApiService_Ref service = new SM_AP07_AdressesApiService_Ref() ;
		service.invokeMethod('getAddressById', mapParam,  outputMap, null) ;
		System.debug('outputMap:' + outputMap);
		Map<String, Object>results = (Map<String, Object>)outputMap.get('results');
		System.assertEquals(results.get('idBan'),null);
		Test.stopTest();
	}

	@isTest
	public static void testSearchAddressSelfcare() {
		Test.startTest();
		

		Set<String> elec = new Set<String>();
		elec.add('01199999844520');
		Set<String> gaz = new Set<String>();
		gaz.add('01100144562464');

		Map<String, Object> objMap = new Map<String, Object>();
		objMap.put('gaz', gaz);
		objMap.put('elec', elec);

		Map<String, Object> inputMap = new Map<String, Object>();
		inputMap.put('WSContrat', objMap);

		Map<String, Object> outputMap = new Map<String, Object>();

		SM_AP07_AdressesApiService_Ref service = new SM_AP07_AdressesApiService_Ref() ;
		service.invokeMethod('searchAddressSelfcare', inputMap,  outputMap, null) ;
		System.debug('outputMap:' + outputMap);
        List<Object> listObjects = (List<Object>)outputMap.get('data');
		//Map<String, Object> data = (Map<String, Object>)
		System.debug('*** data : ' + listObjects);
		Test.stopTest();
	}

      @isTest
    public static void testSearchAddressSelfcare_sameAdressPDLPCE() {
        Test.startTest();
        system.debug('in testSearchAddressSelfcare_sameAdressPDLPCE');
        Map < String, Object > inputMap = new Map<String,Object>();
		
        //Recherche si pdl pce appartenant à la même adresse
        String inputAsStringElec ='{"ops":{"01199999844520":{"idPrestationServiceFournisseur":"0090644876","statutPrestationService":"Programmée chez EGD","codePrestationService":"E0005","idPrestationServiceDistrib":"A03QHIZA","libellePrestation":"MES sur raccordement existant"}}}';
        inputMap.put('RechercherPrestaElec',(Map < String, Object > ) JSON.deserializeUntyped(inputAsStringElec));
        String inputAsStringGaz = '{"ops":{"01100144562464":{"idPrestationServiceFournisseur":"0090644876","statutPrestationService":"Programmée chez EGD","codePrestationService":"E0005","idPrestationServiceDistrib":"A03QHIZA","libellePrestation":"MES sur raccordement existant"}}}';
        inputMap.put('RechercherPrestaGaz',(Map < String, Object > ) JSON.deserializeUntyped(inputAsStringGaz));
		
        Map<String, Object> outputMap = new Map<String, Object>();

		SM_AP07_AdressesApiService_ref service = new SM_AP07_AdressesApiService_ref() ;
		service.invokeMethod('searchAddressSelfcare', inputMap,  outputMap, null) ;
		System.debug('outputMap:' + outputMap);
		List<Object> data = (List<Object>)outputMap.get('data');
		System.debug('*** data : ' + data);
        Test.stopTest();
    }

   
    
     @isTest
    public static void testSearchAddressSelfcare_pdl() {
        Test.startTest();
        system.debug('in testSearchAddressSelfcare_pdl');
        Map < String, Object > inputMap = new Map<String,Object>();
		
        //recherche pdl
       String inputAsStringElec ='{"ops":{"01199999844520":{"idPrestationServiceFournisseur":"0090644876","statutPrestationService":"Programmée chez EGD","codePrestationService":"E0005","idPrestationServiceDistrib":"A03QHIZA","libellePrestation":"MES sur raccordement existant"}}}';
        inputMap.put('RechercherPrestaElec',(Map < String, Object > ) JSON.deserializeUntyped(inputAsStringElec));
        String inputAsStringGaz = '{"ops":{}}';
        inputMap.put('RechercherPrestaGaz',(Map < String, Object > ) JSON.deserializeUntyped(inputAsStringGaz));
      
        Map<String, Object> outputMap = new Map<String, Object>();

		SM_AP07_AdressesApiService_ref service = new SM_AP07_AdressesApiService_ref() ;
		service.invokeMethod('searchAddressSelfcare', inputMap,  outputMap, null) ;
		System.debug('outputMap:' + outputMap);
		List<Object> data = (List<Object>)outputMap.get('data');
		System.debug('*** data : ' + data);
        Test.stopTest();
    }
    
     @isTest
    public static void testSearchAddressSelfcare_pce() {
        Test.startTest();
        system.debug('in testSearchAddressSelfcare_pce');
        Map < String, Object > inputMap = new Map<String,Object>();
		
        //recherche pce	
        String inputAsStringGaz = '{"ops":{"01100144562464":{"idPrestationServiceFournisseur":"0090644876","statutPrestationService":"Programmée chez EGD","codePrestationService":"E0005","idPrestationServiceDistrib":"A03QHIZA","libellePrestation":"MES sur raccordement existant"}}}';
        inputMap.put('RechercherPrestaGaz',(Map < String, Object > ) JSON.deserializeUntyped(inputAsStringGaz));
		 system.debug('in testSearchAddressSelfcare_pce 2 ');
		String inputAsStringElec ='{"ops":{}}';
        inputMap.put('RechercherPrestaElec',(Map < String, Object > ) JSON.deserializeUntyped(inputAsStringElec));
 system.debug('in testSearchAddressSelfcare_pce 3 ');
        Map<String, Object> outputMap = new Map<String, Object>();

		SM_AP07_AdressesApiService_ref service = new SM_AP07_AdressesApiService_ref() ;
         system.debug('in testSearchAddressSelfcare_pce 4 ');
		service.invokeMethod('searchAddressSelfcare', inputMap,  outputMap, null) ;
         system.debug('in testSearchAddressSelfcare_pce 5 ');
		System.debug('outputMap:' + outputMap);
		List<Object> data = (List<Object>)outputMap.get('data');
		System.debug('*** data : ' + data);

        Test.stopTest();
    }

}