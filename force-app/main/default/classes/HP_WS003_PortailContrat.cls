/**
 * @File Name          : HP_WS003_PortailContrat.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 25/03/2020 à 11:18:49
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    01/01/2020   Vincent Albiser     Initial Version
**/
@RestResource(urlMapping='/portailAdmin/contrats/*')
global  with sharing class HP_WS003_PortailContrat {
    
	/**
	* @description Récupération des contrats par le Digital (portail admin)
	* @author Vincent Albiser | 01/01/2020 
	* @return void 
	**/
    @HttpPost
	global static void getContrats() {
        Datetime startCall = Datetime.now();
		RestResponse restResponse = RestContext.response;
        HP_WRP022_SFResponse response = new HP_WRP022_SFResponse(HP_HttpStatus.OK);
        try {
            String body = RestContext.request.requestBody.toString();
            HP_WRP006_PortailRecords.Request req = (HP_WRP006_PortailRecords.Request) JSON.deserialize(body, HP_WRP006_PortailRecords.Request.class);
            HP_WRP006_PortailRecords.Response resp = HP_SM005_PortailGetRecords.getRecords(req, 'contrat');
            response.output = resp;
            response.message = 'Liste des contrats';
            restResponse.statusCode = response.code;
			restResponse.responseBody = Blob.valueOf(JSON.serializePretty(response));
        }
        catch (Exception ex) {
            response.code = HP_HttpStatus.BAD_REQUEST;
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