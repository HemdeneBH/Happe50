/** 
* @author Slimen Belhaj Ali 
* @date 12/12/2019 
* @description Classe de test pour les WS de souscription
*/
@IsTest
public with sharing class HP_EnrolmentRestResource_TEST {

	/** 
    * @author Slimene Belhaj Ali
    * @date 12/12/2019 
    * @description Methode permet de créer les jeux de données
    */
	//@TestSetUp 
/* 	private static void insertTestData() {
		List<Account> accountList = new List<Account>();
		accountList.add((Account) HP_UTIL_SmartFactory.createSObject('Account', new Map<String, Object>{'HP_TECH_ExternalId__c' => 'HP_ENEDIS'}, null));
		accountList.add((Account) HP_UTIL_SmartFactory.createSObject('Account', new Map<String, Object>{'HP_TECH_ExternalId__c' => 'HP_GRDF'}, null));
		insert accountList;

		PriceBook2 happePriceBook =(PriceBook2) HP_UTIL_SmartFactory.createSObject('PriceBook2',new Map<String, Object>{'HP_TECH_ExternalId__c' => 'HP_PriceBook'},null);
		insert happePriceBook;
		List<Account> accountToAddList = new List<Account>();

		Asset ass = (Asset) HP_UTIL_SmartFactory.createSObject('Asset', new Map<String, Object>{'HP_TECH_ExternalId__c' => 'null/testGazElec-01', 'AccountId' => accountList.get(0).Id}, null);
		insert ass;

		List<String> productList = new List<String>{'HP_ELECTRICITY_METER', 'HP_GAS_METER', 'HP_ELECTRICITY_OPTION_PRICING_PLAN_BASE',
		'HP_ELECTRICITY_06_KVA', 'HP_GAS_CLASS_B0'};
		 List<Product2> productToAddList = new List<Product2>();
		 List<PricebookEntry> priceBookEntyToAddList = new List<PricebookEntry>();
		 for(String prod : productList) {
			 	productToAddList.add((Product2) HP_UTIL_SmartFactory.createSObject('Product2', new Map<String, Object>{'HP_TECH_ExternalId__c' => prod}, null));

				priceBookEntyToAddList.add( (PricebookEntry) HP_UTIL_SmartFactory.createSObject('PricebookEntry', new Map<String, Object>{'Pricebook2Id' =>  Test.getStandardPricebookId(), 'IsActive' =>true, 'UnitPrice' =>0}, 
				new Map<String, SObject>{'Product2' => new Product2(HP_TECH_ExternalId__c = prod)}));
				priceBookEntyToAddList.add( (PricebookEntry) HP_UTIL_SmartFactory.createSObject('PricebookEntry', new Map<String, Object>{'Pricebook2Id' =>  happePriceBook.Id, 'IsActive' =>true, 'UnitPrice' =>0}, 
				new Map<String, SObject>{'Product2' => new Product2(HP_TECH_ExternalId__c = prod)}));
												
		 }

		insert productToAddList;
		insert priceBookEntyToAddList;

		HP_DataFactory.initPortailAdmin();
	} */
	/** 
    * @author Slimene Belhaj Ali
    * @date 12/12/2019 
    * @description enum permet de définir les resources statiques utilisées
    */
/* 	private enum StaticResource {
		HP_EnrolmentRestResourceSave1_TEST,
		HP_EnrolmentRestResourceSave2_TEST,
		HP_EnrolmentRestResourceSave3_TEST,
		HP_APIHourAccessTokenResponse_MOCK
	} */

	/** 
    * @author Slimene Belhaj Ali
    * @date 12/12/2019 
    * @description Methode permet tester les trois méthodes de Save, car, ils sont liés, le résultat d'une presente un jeux de données pour la suivante.
    */
/* 	@IsTest
	static void save(){

		//Configurer le Mock (les WS, body, Header....)
		Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
			StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
			new Map<String, String> {'Content-Type' => 'application/json'}),

			'portefeuilles-contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
			null,
			new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'})
			};
		
		
		
		//Save1
		final String enrolmentRestResourceSave1Json = HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(StaticResource.HP_EnrolmentRestResourceSave1_TEST.name());
		//final HP_EnrolmentRestResourceModel enrolmentRestResourceSave1 = (HP_EnrolmentRestResourceModel)HP_ParseUtils.parse(enrolmentRestResourceSave1Json, HP_EnrolmentRestResourceModel.class);
		RestRequest reqSave1 = new RestRequest(); 	 
		reqSave1.requestURI = '/services/apexrest/enrolment';
		reqSave1.httpMethod = 'POST';
		reqSave1.requestBody = Blob.valueof(enrolmentRestResourceSave1Json);
		RestContext.request = reqSave1;
		HP_EnrolmentRestResource.post();
		
		//Save2
		final String enrolmentRestResourceSave2Json = HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(StaticResource.HP_EnrolmentRestResourceSave2_TEST.name());
		//final HP_EnrolmentRestResourceModel enrolmentRestResourceSave2 = (HP_EnrolmentRestResourceModel)HP_ParseUtils.parse(enrolmentRestResourceSave2Json, HP_EnrolmentRestResourceModel.class);
		RestRequest reqSave2 = new RestRequest();
		reqSave2.requestURI = '/services/apexrest/enrolment';
		reqSave2.httpMethod = 'POST';
		reqSave2.requestBody = Blob.valueof(enrolmentRestResourceSave2Json);
		RestContext.request = reqSave2;

		Test.startTest();
		RestContext.response= new RestResponse();
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
		
		//Save2
		HP_EnrolmentRestResource.post();
		Test.stopTest();

		//Save3
		final String enrolmentRestResourceSave3Json = HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(StaticResource.HP_EnrolmentRestResourceSave3_TEST.name());
		//final HP_EnrolmentRestResourceModel enrolmentRestResourceSave3 = (HP_EnrolmentRestResourceModel)HP_ParseUtils.parse(enrolmentRestResourceSave3Json, HP_EnrolmentRestResourceModel.class);
		RestRequest reqSave3 = new RestRequest();
		reqSave3.requestURI = '/services/apexrest/enrolment';
		reqSave3.httpMethod = 'POST';
		reqSave3.requestBody = Blob.valueof(enrolmentRestResourceSave3Json);
		RestContext.request = reqSave3;
		
		HP_EnrolmentRestResource.post();

		System.assertEquals(1, (Integer)[select count() from lead]);
		System.assertEquals(1, (Integer)[select count() from opportunity]);
		System.assertEquals(3, (Integer)[select count() from asset]);
		System.assertEquals(3, (Integer)[select count() from OpportunityLineItem]);
		System.assertEquals(1, (Integer)[select count() from HP_EnrolmentDetails__c]);
		//System.assertEquals(1, (Integer)[select count() from Contact]);

	} */

}