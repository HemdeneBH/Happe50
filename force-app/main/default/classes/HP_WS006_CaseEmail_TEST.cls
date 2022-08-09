/**
 * @File Name          : HP_WS006_CaseEmail_TEST.cls
 * @Description        :
 * @Author             : Colince FOTSO
 * @Group              :
 * @Last Modified By   : Colince FOTSO
 * @Last Modified On   : 30/01/2020 à 14:52:51
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    30/01/2020   Colince FOTSO     Initial Version
 **/
@isTest
public class HP_WS006_CaseEmail_TEST {

	@TestSetUp 
	private static void insertTestData(){
		System.runAs(HP_UTIL_SmartFactory.insertUserHP()){
		}
	}
	

	@isTest
	private static void requestForRecontactTest(){
		System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
			Test.startTest();
			String json = '{"reason": "L’accès à votre espace client(obligatoire)",'+
					  '"civility": "Mr",'+
					  '"firstName": "John",'+
					  '"lastName": "Doe",'+
					  '"emailAddress": "contact@email.cm",'+
					  '"message": "test",'+
					  '"streetNumber": "test",'+
					  '"streetLabel": "test",'+
					  '"postalCode": "92900",'+
					  '"town": "La ville",'+
					  '"attachments": [{"filename": "testfilename","body": "testBody"}]}';
	
			RestRequest req = new RestRequest();
			RestResponse res = new RestResponse();
		  
			req.requestURI = '/services/apexrest/case/email';
			req.httpMethod = 'POST';
			req.addHeader('Content-Type', 'application/json');
			req.requestBody = Blob.valueOf(json);
	
			RestContext.request = req;
			RestContext.response = res;
	
			HP_WS006_CaseEmail.requestForRecontact();
	
			System.assert (HP_HttpStatus.OK == res.statusCode, 'Demande de recontact est envoyée');
	
			Test.stopTest();
		}
	}

}