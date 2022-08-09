/**
 * @File Name          : HP_WS012_SouscriptionStatus.cls
 * @Description        : 
 * @Author             : Antoine Latour
 * @Group              : 
 * @Last Modified By   : Antoine Latour
 * @Last Modified On   : 25/09/2020 à 12:00:05
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    25/09/2020   Antoine Latour     Initial Version
**/
@RestResource(urlMapping='/v1/souscription/status/*')
global with sharing class HP_WS012_SouscriptionStatus {

    @HttpPost
	global static void souscriptionStatusRecuperation() {

        Datetime startCall = Datetime.now();
        HP_WRP038_SouscritpionStatus.Request req;
        HP_WRP022_SFResponse response = new HP_WRP022_SFResponse (HP_HttpStatus.OK);
        RestResponse restResponse = RestContext.response;     

        try{
            String body = RestContext.request.requestBody.toString();
            req = (HP_WRP038_SouscritpionStatus.Request) JSON.deserialize(body, HP_WRP038_SouscritpionStatus.Request.class);
            HP_WRP038_SouscritpionStatus.Response souscriptionStatusResponse  = HP_SM039_SouscriptionInfos.getSouscriptionsInfo(req);
            response.output = souscriptionStatusResponse;
			response.message = 'Informations sur les souscriptions';
			restResponse.statusCode = response.code;
			restResponse.responseBody = Blob.valueOf(JSON.serializePretty(response));
        }
        catch(Exception e){
            response.code = HP_HttpStatus.BAD_REQUEST;
			response.addError(String.valueOf(response.code), e.getMessage());
			restResponse.statusCode = response.code;
			restResponse.responseBody = Blob.valueOf(JSON.serializePretty(response));
        }
        finally {
			RestContext.response.statusCode = response.code;
			RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(response));
			HP_UTIL_HTTPUtils.saveLogResponse(RestContext.request, restResponse, (Datetime.now().getTime() - startCall.getTime()));
		}
    }
}