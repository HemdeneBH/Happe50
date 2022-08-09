/*@Auhtor: MHA
*@Description: Test de l'Appel de l'API SMILE banques
*@CreatedDate: 02/01/2019
*@LastModified: MHA 02/01/2019
*/
@isTest
private class SM_AP52_BanquesApiService_TEST {
	/*@Auhtor: MHA
	*@Description: Test de l'Appel de l'API SMILE banques rapportant le nom de l'institut bancaire grâce à l'IBAN
	*@CreatedDate: 02/01/2019
	*@LastModified: MHA 02/01/2019
	*/
	@isTest static void getInstitutBanqueByIBAN_Test() {
		// Implement test code
		Map<String, Object> inputMap = new Map<String, Object>();
		/*Map<String, Object> gest = new Map<String, Object>();
		Map<String, Object> editBlock = new Map<String, Object>();*/
		inputMap.put('IbanNumber','FR7610206024319837747102224');
		/*gest.put('EditBlock1',editBlock);
		inputMap.put('ServicesGestion',gest);*/
		Map<String, Object> outputMap = new Map<String, Object>();

		SM_AP52_BanquesApiService service =  new SM_AP52_BanquesApiService();
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource('SM_mockBanques');
		mock.setStatusCode(200);
		mock.setHeader('Content-Type', 'application/json');
		// Set the mock callout mode
		Test.setMock(HttpCalloutMock.class, mock);
		HttpRequest request = new HttpRequest();
		HttpResponse response = new Http().send(request);
		system.debug(response.getBody());
		service.invokeMethod('getInstitutBanqueByIBAN',inputMap,outputMap,null);
		System.assertEquals('FR7610206024319837747102224',inputMap.get('IbanNumber'));
		System.assertEquals('CREDIT LYONNAIS',outputMap.get('nomInstitutBancaire'));
	}

}