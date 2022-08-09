/**
 * @author Unknown
 * @date 06/04/2022 - Sutharsan Pushparajah : Enforce Unit Testing
 * @description Test class for SM_AP29_PersonnesAPI
 */
@isTest
private class SM_AP29_PersonnesAPI_TEST {

	private static final String ID_BUSINESS_PARTNER = '0312386733';
	/**
     * @author Sutharsan Pushparajah
     * @date 06/04/2022
     * @description Creating Contact Data in Salesforce
     */
	@TestSetup
	private static void init(){
		Account acc = SM_TestDataFactory.createAccount('Test');
		insert acc;

		Contact ct = SM_TestDataFactory.createContact('lastName', acc.Id);
		ct.Identifiant_Buisness_Partener__c = ID_BUSINESS_PARTNER;
        ct.RecordTypeId = SM_EM100_Contact.RT_ID_CONTACT_SMILE;
		insert ct;
	}

	/**
     * @author Sutharsan Pushparajah
     * @date 06/04/2022
     * @description Mocking callout in test context
     */
    public inherited sharing class TestingMockHttp implements HttpCalloutMock{
		String payload = '{"_data": [{"id": 68491001,"civilite": "MME","nom": "MOUCHET","prenom": "Gaëlle","idBusinessPartner": "0312386733","idPersonneUnifiee": 0}]}';
        

		TestingMockHttp(Boolean isEmptyResponse){
			if (isEmptyResponse){
				payload  = '{"_data": []}';
			}
		}

		public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody(payload);

            return res;
        }
    }

	/**
     * @author unknown
     * @date DD/MM/YYYY
     * @description Mocking callout in test context with success path
     */
	@isTest
	private static void test(){

		Map<String , object>inputMap = new Map<String, object>();
		inputMap.put('refClientIdBP','0309980002');
		Map<String , object>outputMap = new Map<String, object>();

		SM_AP29_PersonnesAPI service = new SM_AP29_PersonnesAPI();
		Test.startTest();
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource('SM_MockResponseApiPersonne');
		mock.setStatusCode(200);
		mock.setHeader('Content-Type', 'application/json');
		// Set the mock callout mode
		Test.setMock(HttpCalloutMock.class, mock);
		service.invokeMethod('methodenotCovered', inputMap,  outputMap, null);
		service.invokeMethod('callPersonne', inputMap,  outputMap, null);
        Contact con = new Contact();
        con.LastName = 'test';
        con.Identifiant_Buisness_Partener__c = '309980002';
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Smile').getRecordTypeId();
		insert con;
        inputMap.put('idContact',con.Id);
        service.invokeMethod('callPersonneApi', inputMap,  outputMap, null) ;

		List<Object> listPersonne = new List<Object>();
		Map<String,Object>mapPersonne = new Map<String, Object>();
		mapPersonne.put('id', 'test');
		mapPersonne.put('idPersonneUnifiee', 'test');
		mapPersonne.put('idBusinessPartner', 'test');
		listPersonne.add(mapPersonne);

		SM_AP29_PersonnesAPI.transformDatatoOmniscript(listPersonne) ;
		SM_AP29_PersonnesAPI.PersonneModel QuestionConsentementModel = new  SM_AP29_PersonnesAPI.PersonneModel(null,null,null) ;
        Test.stopTest();
	}

	/**
     * @author Sutharsan Pushparajah
     * @date 06/04/2022
     * @description Testing the exception when input is not defined
     */
	@isTest
	private static void testInvokeMethod(){

		Test.startTest();

		Boolean result;
		
		SM_AP29_PersonnesAPI personnesApi = new SM_AP29_PersonnesAPI();
		result = personnesApi.invokeMethod(null, null, null, null);

		System.assertEquals(false, result);

		Test.stopTest();
	}

	/**
     * @author Sutharsan Pushparajah
     * @date 06/04/2022
     * @description Testing the padding left with 0
     */
	@isTest
	private static void testFormatIdentifiantBusinessPartner(){

		Test.startTest();

		Boolean isException = false;

		try{
			SM_AP29_PersonnesAPI.formatIdentifiantBusinessPartner(null);
		} catch(SM_AP29_PersonnesAPI.PersonnesException exp){
			isException = true;
		}
		
		System.assertEquals(true, isException);

		String result = SM_AP29_PersonnesAPI.formatIdentifiantBusinessPartner('A');
		System.assertEquals('000000000A', result);

		result = SM_AP29_PersonnesAPI.formatIdentifiantBusinessPartner('AAAA');
		System.assertEquals('000000AAAA', result);

		result = SM_AP29_PersonnesAPI.formatIdentifiantBusinessPartner('AAAAAAAAAA');
		System.assertEquals('AAAAAAAAAA', result);

		result = SM_AP29_PersonnesAPI.formatIdentifiantBusinessPartner('AAAAAAAAAAA');
		System.assertEquals('AAAAAAAAAAA', result);

		Test.stopTest();
	}

	/**
     * @author Sutharsan Pushparajah
     * @date 06/04/2022
     * @description Testing the mock of Personnes V1
     */
	@isTest
	private static void testCallPersonneApi(){
		
		MCK000_MultiRequestMock multiMockHttp = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, multiMockHttp);
        multiMockHttp.addRequestMock('PERSONNES_V1', new TestingMockHttp(false));

		Test.startTest();

		Boolean isException = false;
		Map<String, Object> result;

		//1 - Test with no input
		try{
			result = SM_AP29_PersonnesAPI.callPersonneApi(null);
		} catch(Exception exp){
			isException = true;
		}

		System.assertEquals(false, isException);
		System.assertEquals(null, result);

		//2- Test with no id contact
		isException = false;
		Map<String, Object> inputMap = new Map<String, Object>();
		inputMap.put('idContact', 'fake');

		try{
			SM_AP29_PersonnesAPI.callPersonneApi(inputMap);
		} catch(Exception exp){
			isException = true;
		}

		//3 - Test with id contact
		Map<String, Contact> ctMap = SM_EM100_Contact.getByIdentifiantBusinessPartners(new Set<String>{ID_BUSINESS_PARTNER});
		inputMap.put('idContact', ctMap.get(ID_BUSINESS_PARTNER).Id);
		result = SM_AP29_PersonnesAPI.callPersonneApi(inputMap);

		System.assertNotEquals(null, result);
		System.assertEquals(ID_BUSINESS_PARTNER, result.get('idBusinessPartner'));

		Test.stopTest();
	}

	/**
     * @author Sutharsan Pushparajah
     * @date 06/04/2022
     * @description Testing the mock of Personnes V0
     */
	@isTest
	private static void testCallPersonne(){

		MCK000_MultiRequestMock multiMockHttp = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, multiMockHttp);
        multiMockHttp.addRequestMock('PERSONNES_V0', new TestingMockHttp(true));

		Test.startTest();

		Boolean isException = false;
		Map<String, Object> result = new Map<String, Object>();
		Map<String, Object> input = new Map<String, Object>();

		//1 - Test with no input
		try{
			SM_AP29_PersonnesAPI.callPersonne(input, result, null);
		} catch(Exception exp){
			isException = true;
		}

		System.assertEquals(false, isException);
		System.assertEquals(null, result.get('personnes'));

		//2 - Test with unknonw client
		input.put('refClientIdBP', 'test');

		try{
			SM_AP29_PersonnesAPI.callPersonne(input, result, null);
		} catch(Exception exp){
			isException = true;
		}

		System.assertEquals(false, isException);
		System.assertEquals(null, result.get('personnes'));

		//3 - Test with knonw client
		multiMockHttp.addRequestMock('PERSONNES_V0', new TestingMockHttp(false));
		input.put('refClientIdBP', ID_BUSINESS_PARTNER);

		try{
			SM_AP29_PersonnesAPI.callPersonne(input, result, null);
		} catch(Exception exp){
			isException = true;
		}

		System.assertEquals(false, isException);
		Map<String, Object> persMap = (Map<String, Object>) result.get('personnes');
		System.assertNotEquals(null, persMap);
		SM_AP29_PersonnesAPI.PersonneModel personneValue = (SM_AP29_PersonnesAPI.PersonneModel) persMap.get('personne1');
		System.assertNotEquals(null, personneValue);
		System.assertEquals(ID_BUSINESS_PARTNER, personneValue.idBusinessPartner);

		Test.stopTest();
	}
}