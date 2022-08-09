/**
 * @File Name          : HP_WS009_ResiliationIndexUpdate.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 25/03/2020 à 11:42:46
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    03/03/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/

@RestResource(urlMapping='/resiliation/index/*')
global with sharing class HP_WS009_ResiliationIndexUpdate {

    @HttpPost
	global static void setIndex() {

        Datetime startCall = Datetime.now();
		RestResponse restResponse = RestContext.response;
        HP_WRP009_IndexUpdate.Request req;
        HP_WRP022_SFResponse response = new HP_WRP022_SFResponse (HP_HttpStatus.OK);

        try{
            String body = RestContext.request.requestBody.toString();
            req = (HP_WRP009_IndexUpdate.Request) JSON.deserialize(body, HP_WRP009_IndexUpdate.Request.class);
            HP_SM009_IndexUpdate.updateIndexResiliation(req,response);  
        }
        catch(Exception e){
            response.addError('WS009-1', e.getMessage());
            response.code = HP_HttpStatus.BAD_REQUEST;
        }finally {
            restResponse.statusCode = response.code;
			restResponse.responseBody = Blob.valueOf(JSON.serializePretty(response));
			RestContext.response.statusCode = response.code;
			RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(response));
			HP_UTIL_HTTPUtils.saveLogResponse(RestContext.request, restResponse, (Datetime.now().getTime() - startCall.getTime()));
		}
    }
}