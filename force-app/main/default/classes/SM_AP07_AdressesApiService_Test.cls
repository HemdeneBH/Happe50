@isTest
public class SM_AP07_AdressesApiService_Test {

	@testSetup static void setup() {
		SM_AP08_TestLib.insertCS_GenericEndpoints();
		SM_AP08_TestLib.insertCS_XDATACredentials();
	}


	@isTest
	public static void testSearchPdlPceFromPDL() {
		Test.startTest();
		Map<String, Object> mapParam = new Map<String, Object>();
		Map<String, Object> outputMap = new Map<String, Object>();
		/*Build map for PDL/PCE fields*/
		Map<String, String> inputPDLPCEValues = new Map<String, String>();
		inputPDLPCEValues.put('PCENumber', '01100144562464');
		inputPDLPCEValues.put('PDLNumber', '01199999844520');
		mapParam.put('SearchByPDLPCE', inputPDLPCEValues);

		/* Build map for address if not same than existing*/
		Map<String, String> inputAddr = new Map<String, String>();
		inputAddr.put('id', 'ADRNIVX_0000000331881839');
		Map<String, Object> inputMapAddr = new Map<String, Object>();
		mapParam.put('SearchByAddress-Block', inputAddr);

		/* Build map for address if  same than existing*/
		Map<String, String> inputAddrExist = new Map<String, String>();
		inputAddrExist.put('isBillingAddressSameAsLiving', 'OUI');
		mapParam.put('Address', inputAddrExist);


		/* Build ChoixElements1*/
		Map<string, Object> inputChoixElements1 = new Map<string, Object>();
		inputChoixElements1.put('ChoixElements1', mapParam);
		inputChoixElements1.put('searchAddr', '185 Rue Solférino 59000 Lille');
		SM_AP07_AdressesApiService service = new SM_AP07_AdressesApiService() ;
		service.invokeMethod('searchAddress', inputChoixElements1,  outputMap, null) ;
		System.debug('outputMap:' + outputMap);
		Map<String, Object> data = (Map<String, Object>)outputMap.get('data');
		List<Object> resultdata = (List<Object>)data.get('resultdata');
		SM_AP07_AdressesApiService.AdresseModel response1 = (SM_AP07_AdressesApiService.AdresseModel)resultdata[0];
		System.assertEquals(response1.citycode, '59599');
		System.assertEquals(response1.postcode, '59200');
		System.assertEquals(response1.valueChb, '215 RUE DES PIATS 59200 TOURCOING');
		Test.stopTest();
	}


	@isTest
	public static void testSearchPdlPceFromPCE() {
		Test.startTest();
		Map<String, Object> mapParam = new Map<String, Object>();
		Map<String, Object> outputMap = new Map<String, Object>();
		/*Build map for PDL/PCE fields*/
		Map<String, String> inputPDLPCEValues = new Map<String, String>();
		inputPDLPCEValues.put('PCENumber', '01100144562464');
		inputPDLPCEValues.put('PDLNumber', null);
		mapParam.put('SearchByPDLPCE', inputPDLPCEValues);

		/* Build map for address*/
		Map<String, String> inputAddr = new Map<String, String>();
		inputAddr.put('id', 'ADRNIVX_0000000331881839');
		Map<String, Object> inputMapAddr = new Map<String, Object>();
		mapParam.put('SearchByAddress-Block', inputAddr);

		Map<String, String> inputAddrExist = new Map<String, String>();
		inputAddrExist.put('isBillingAddressSameAsLiving', 'OUI');
		mapParam.put('Address', inputAddrExist);


		/* Build ChoixElements1*/
		Map<string, Object> inputChoixElements1 = new Map<string, Object>();
		inputChoixElements1.put('ChoixElements1', mapParam);
		inputChoixElements1.put('searchAddr', '185 Rue Solférino 59000 Lille');
		SM_AP07_AdressesApiService service = new SM_AP07_AdressesApiService() ;
		service.invokeMethod('searchAddress', inputChoixElements1,  outputMap, null) ;
		System.debug('outputMap:' + outputMap);
		Map<String, Object> data = (Map<String, Object>)outputMap.get('data');
		List<Object> resultdata = (List<Object>)data.get('resultdata');
		SM_AP07_AdressesApiService.AdresseModel response1 = (SM_AP07_AdressesApiService.AdresseModel)resultdata[0];
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
		/*Build map for PDL/PCE fields*/
		Map<String, String> inputPDLPCEValues = new Map<String, String>();
		inputPDLPCEValues.put('PCENumber', null);
		inputPDLPCEValues.put('PDLNumber', null);
		mapParam.put('SearchByPDLPCE', inputPDLPCEValues);

		/* Build map for address*/
		Map<String, String> inputAddr = new Map<String, String>();
		inputAddr.put('id', 'ADRNIVX_0000000331881839');
		Map<String, Object> inputMapAddr = new Map<String, Object>();
		mapParam.put('SearchByAddress-Block', inputAddr);

		Map<String, String> inputAddrExist = new Map<String, String>();
		inputAddrExist.put('isBillingAddressSameAsLiving', 'NON');
		mapParam.put('Address', inputAddrExist);


		/* Build ChoixElements1*/
		Map<string, Object> inputChoixElements1 = new Map<string, Object>();
		inputChoixElements1.put('ChoixElements1', mapParam);
		inputChoixElements1.put('searchAddr', '185 Rue Solférino 59000 Lille');
		SM_AP07_AdressesApiService service = new SM_AP07_AdressesApiService() ;
		service.invokeMethod('searchAddress', inputChoixElements1,  outputMap, null) ;
		System.debug('outputMap:' + outputMap);
		Map<String, Object> data = new  Map<String, Object>();
	   // if(outputMap.get('_data') != null){
			data = (Map<String, Object>)outputMap.get('data');  
		List<Object> resultdata = (List<Object>)data.get('resultdata');
		SM_AP07_AdressesApiService.AdresseModel response1 = (SM_AP07_AdressesApiService.AdresseModel)resultdata[0];
		System.assertEquals(response1.citycode, '59599');
		System.assertEquals(response1.postcode, '59200');
		System.assertEquals(response1.valueChb, '215 RUE DES PIATS 59200 TOURCOING');
	   // }
		Test.stopTest();
	}

	@isTest
	public static void testsearchAddressById() {
		Test.startTest();
		Map<String, Object> mapParam = new Map<String, Object>();
		Map<String, Object> outputMap = new Map<String, Object>();

		/* Build ChoixElements1*/
		mapParam.put('idLogement', 'idLogementTest');
		SM_AP07_AdressesApiService service = new SM_AP07_AdressesApiService() ;
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
		SM_AP07_AdressesApiService service = new SM_AP07_AdressesApiService() ;
		service.invokeMethod('getAddressById', mapParam,  outputMap, null) ;
		System.debug('outputMap:' + outputMap);
		Map<String, Object>results = (Map<String, Object>)outputMap.get('results');
		System.assertEquals(results.get('idBan'),null);
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

		SM_AP07_AdressesApiService service = new SM_AP07_AdressesApiService() ;
		service.invokeMethod('searchAddressSelfcare', inputMap,  outputMap, null) ;
		System.debug('outputMap:' + outputMap);
		List<Object> data = (List<Object>)outputMap.get('data');
		System.debug('*** data : ' + data);

        // Il n'y a qu'un seul enregistrement suite au dédoublonnement
       	System.assertEquals(1, data.size());
        system.debug('out testSearchAddressSelfcare_sameAdressPDLPCE');
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

		SM_AP07_AdressesApiService service = new SM_AP07_AdressesApiService() ;
		service.invokeMethod('searchAddressSelfcare', inputMap,  outputMap, null) ;
		System.debug('outputMap:' + outputMap);
		List<Object> data = (List<Object>)outputMap.get('data');
		System.debug('*** data : ' + data);

        // Il n'y a qu'un seul enregistrement suite au dédoublonnement
       	System.assertEquals(1, data.size());
        system.debug('out testSearchAddressSelfcare_pdl');
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
		
		String inputAsStringElec ='{"ops":{}}';
        inputMap.put('RechercherPrestaElec',(Map < String, Object > ) JSON.deserializeUntyped(inputAsStringElec));

        Map<String, Object> outputMap = new Map<String, Object>();

		SM_AP07_AdressesApiService service = new SM_AP07_AdressesApiService() ;
		service.invokeMethod('searchAddressSelfcare', inputMap,  outputMap, null) ;
		System.debug('outputMap:' + outputMap);
		List<Object> data = (List<Object>)outputMap.get('data');
		System.debug('*** data : ' + data);

        // Il n'y a qu'un seul enregistrement suite au dédoublonnement
       	System.assertEquals(1, data.size());
        system.debug('out testSearchAddressSelfcare_pce');
        Test.stopTest();
    }

}