/**
 * @File Name          : HP_WS001_PortailAuth.cls
 * @Description        : WS d'authentitifaction pour le portail Admin
 * @Author             : Vincent Albiser
 * @Group              :
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 25/03/2020 à 11:31:12
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    10/12/2019   Vincent Albiser     Initial Version
 **/
@RestResource(urlMapping='/portailAdmin/profil/*')
global with sharing class HP_WS001_PortailAuth {

	/**
	 * @description Authentification du portail Admin
	 * @author Vincent Albiser | 10/12/2019
	 * @return void
	 **/
	@HttpPost
	global static void checkAuth() {
		Datetime startCall = Datetime.now();
		RestResponse restResponse = RestContext.response;
		HP_WRP022_SFResponse response = new HP_WRP022_SFResponse(HP_HttpStatus.OK);
		try {
			String body = RestContext.request.requestBody.toString();
			HP_WRP003_PortailAuth.Request req = (HP_WRP003_PortailAuth.Request) JSON.deserialize(body, HP_WRP003_PortailAuth.Request.class);
			HP_WRP003_PortailAuth.Response resp = HP_SM002_PortailUtilisateur.verifierLogin(req);
			response.output = resp;
			response.message = 'Vérification Login';
			restResponse.statusCode = response.code;
			restResponse.responseBody = Blob.valueOf(JSON.serializePretty(response));
		}
		catch (HP_SM002_PortailUtilisateur.PortailException ex) {
			response.code =  HP_HttpStatus.UNAUTHTORIZED;
			response.addError(String.valueOf(response.code), ex.getMessage());
			restResponse.statusCode = response.code;
			restResponse.responseBody = Blob.valueOf(JSON.serializePretty(response));
		}
		catch (Exception ex) {
			response.code  = HP_HttpStatus.BAD_REQUEST;
			response.addError(String.valueOf(response.code), ex.getMessage());
			restResponse.statusCode = response.code;
			restResponse.responseBody = Blob.valueOf(JSON.serializePretty(response));
		}finally {
			RestContext.response.statusCode = response.code;
			RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(response));
			HP_UTIL_HTTPUtils.saveLogResponse(RestContext.request, restResponse, (Datetime.now().getTime() - startCall.getTime()));
		}
	}
}