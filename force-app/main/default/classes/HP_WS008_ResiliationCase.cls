/**
 * @File Name          : HP_CancelationCaseResource.cls
 * @Description        : 
 * @Author             : Mohamed Aamer
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 28/02/2020 à 14:05:05
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    27/02/2020   Mohamed Aamer     Initial Version
**/
@RestResource(urlMapping='/case/cancelation/*')
global with sharing class HP_WS008_ResiliationCase {

	@httpPost
	global static void cancelation (){
		preCancelation(RestContext.request);
	}

	public static void preCancelation (RestRequest restRequest){
		Datetime startCall = Datetime.now();
		final HP_CancelationCaseRestResourceModel cancelationCaseRestResource;
		RestResponse restResponse = RestContext.response;
		HP_WRP022_SFResponse response = new HP_WRP022_SFResponse(HP_HttpStatus.OK);
		String body =restRequest.requestBody.toString();
		cancelationCaseRestResource = (HP_CancelationCaseRestResourceModel) JSON.deserialize(body, HP_CancelationCaseRestResourceModel.class);
		try{
			if (cancelationCaseRestResource.selfcareCase.cancelationCase_v0_1 != null) {
				cancelationProcess(cancelationCaseRestResource.selfcareCase.cancelationCase_v0_1, cancelationCaseRestResource.selfcareCase.personXdataId, cancelationCaseRestResource.selfcareCase.effectiveDate,response);
			}
			restResponse.statusCode = response.code;
			restResponse.responseBody = Blob.valueOf(JSON.serializePretty(response));
		}catch(HP_WRP022_SFResponse.APIException ex) {
			restResponse.statusCode = response.code ;
			restResponse.responseBody = Blob.valueOf(JSON.serializePretty(response));
			
		}finally {
			RestContext.response.statusCode = response.code;
			RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(response));
			HP_UTIL_HTTPUtils.saveLogResponse(restRequest, restResponse, (Datetime.now().getTime() - startCall.getTime()));
		}
		
	}

	@HttpPut
	global static void firstUpdate() {
		preCancelation (RestContext.request);
	}

	private static void cancelationProcess(final HP_CancelationCaseRestResourceModel.CancelationCase_v0_1 cancelationCase, final Integer personXdataId, final Date effectiveDate ,final HP_WRP022_SFResponse response){
		final Contact primaryContact = HP_EM020_Contact.getContactByXdataId(personXdataId);
		HP_CancelationCaseUtils.handleCancelationCase(cancelationCase, primaryContact, effectiveDate,response);//FIXME switch to no selfcareId context [external Id for Account]
	}
}