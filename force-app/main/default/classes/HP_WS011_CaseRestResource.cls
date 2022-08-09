/**
 * @File Name          : HP_CaseRestResource.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 28/04/2020 à 05:40:36
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    25/03/2020   Mouhamadoune Coulibaly     Initial Version
**/
@RestResource(urlMapping='/case/recontact/*')
global with sharing class HP_WS011_CaseRestResource {

	private static final String BASE_URL = '/case/recontact/';
	private static final String URL_EMPTY = '';
	private static final String URL_SUBSCRIPTION = 'subscription';
	private static final String URL_SERVICE = 'service';

	@httpPost
	global static void save() {
		preSave(RestContext.request);
	}


	@HttpPut
	global static void firstUpdate() {
		preSave(RestContext.request);
	}


	public static void preSave(RestRequest restRequest) {

		Datetime startCall = Datetime.now();
		RestResponse restResponse = RestContext.response;
		HP_WRP022_SFResponse response = new HP_WRP022_SFResponse(HP_HttpStatus.OK);
		final HP_CaseRestResourceModel caseResource;
		try{
			String body = restRequest.requestBody.toString();
			caseResource = (HP_CaseRestResourceModel) JSON.deserialize(body, HP_CaseRestResourceModel.class);

			if (caseResource.selfcareCase.enrolmentCase_v0_1 != null) {
				// identify the requested service using the URL
				String serviceString = RestContext.request.requestURI.remove(BASE_URL);
				System.debug(serviceString);
				// treat separately each service called in the URL
				if (serviceString.startsWith(URL_SUBSCRIPTION)) {
					saveCase(caseResource.selfcareCase.enrolmentCase_v0_1);
					response.addInfo('SF-CaseRecontact-01', 'Insertion du case ' + caseResource.selfcareCase.enrolmentCase_v0_1.caseName);
				}
				else if (serviceString.startsWith(URL_SERVICE)) {
					//selfcareCase.enrolmentCase_v0_1.Type = HP_SLCT_Case.Type.HP_CaseRecontact;
					saveCase(caseResource.selfcareCase.enrolmentCase_v0_1);//TODO param distinction? general service data model
					response.addInfo('SF-CaseRecontact-01', 'Insertion du case ' + caseResource.selfcareCase.enrolmentCase_v0_1.caseName);
				}
				else if (serviceString == URL_EMPTY) {
					System.debug('No service specified');
					response.addInfo('SF-CaseRecontact-02', 'No service specified');
				}
				else {
					System.debug('Unknown service');
					response.addInfo('SF-CaseRecontact-03', 'Unknown service');
				}
				//saveCase(selfcareCase.enrolmentCase_v0_1);
			}
			restResponse.statusCode = response.code;
			restResponse.responseBody = Blob.valueOf(JSON.serializePretty(response));
		}catch (HP_WRP022_SFResponse.APIException ex) {
            restResponse.statusCode = HP_HttpStatus.BAD_REQUEST; 
            restResponse.responseBody = Blob.valueOf(JSON.serializePretty(response));
            
		}catch(Exception ex) {
			response.code = HP_HttpStatus.BAD_REQUEST;
			response.addError(String.valueOf(response.code), ex.getMessage());
			restResponse.statusCode = response.code;
			restResponse.responseBody = Blob.valueOf(JSON.serializePretty(response));
		}finally {
			RestContext.response.statusCode = response.code;
			RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(response));
			HP_UTIL_HTTPUtils.saveLogResponse(restRequest, restResponse, (Datetime.now().getTime() - startCall.getTime()));
		}

	}





	private static void saveCase(final HP_CaseRestResourceModel.EnrolmentCase_v0_1 selfcareCase) {

		final Id caseRecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case','HP_CaseRecontact');

		Case c = new Case();
		c.RecordTypeId = caseRecordTypeId;
		c.SuppliedName= selfcareCase.lastName + ' ' +selfcareCase.Surname;
		c.SuppliedPhone = selfcareCase.phoneNumber;
		c.SuppliedEmail = selfcareCase.email;
		c.Subject = selfcareCase.caseName;
		c.Status = 'TO_DO';
		c.HP_Type__c = 'HP_SouscriptionDigital';

		Database.insert(c);
	}

}