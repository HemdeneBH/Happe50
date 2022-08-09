/**
 * @File Name          : HP_WS010_Case.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 17/03/2020 à 04:11:05
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    17/03/2020   Vincent Albiser     Initial Version
**/
@RestResource(urlMapping='/v1/case/*')
global  class HP_WS010_Case {

    @HttpPost
	global static void caseCreation() {

        Datetime startCall = Datetime.now();
        HP_WRP034_Case.Request req;
        HP_WRP022_SFResponse response = new HP_WRP022_SFResponse (HP_HttpStatus.OK);
        RestResponse restResponse = RestContext.response;        

        try{
            String body = RestContext.request.requestBody.toString();
            req = (HP_WRP034_Case.Request) JSON.deserialize(body, HP_WRP034_Case.Request.class);
            HP_SM025_CaseAPI.caseCreation(req, response);
        }
        catch(Exception e){
            response.addError('SF Standard', e.getMessage());
            response.code = HP_HttpStatus.BAD_REQUEST;
        }
        finally {
			restResponse.statusCode = response.code;
			restResponse.responseBody = Blob.valueOf(JSON.serializePretty(response));
			HP_UTIL_HTTPUtils.saveLogResponse(RestContext.request, restResponse, (Datetime.now().getTime() - startCall.getTime()));
		}
    }
}