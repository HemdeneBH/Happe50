/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-03-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   02-19-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/

@RestResource(urlMapping='/v1/portailAdmin/devis/*')
global with sharing class HP_WS013_PortailDevis {

    @HttpPost
	global static void souscriptionDevis () {

        Datetime startCall = Datetime.now();
        HP_WRP039_Devis.Request req;
        HP_WRP022_SFResponse response = new HP_WRP022_SFResponse (HP_HttpStatus.OK);
        RestResponse restResponse = RestContext.response;     

        try{
            String body = RestContext.request.requestBody.toString();
            req = (HP_WRP039_Devis.Request) JSON.deserialize(body, HP_WRP039_Devis.Request.class);
            if(String.isNotBlank(req.digitalId) && req.digitalId.length() != 13 && (req.digitalId.isNumeric())) {
                response.addError('WS013-PD0','ID non valide');
                throw  new HP_WRP039_Devis.APIException();
            }
            if(String.isBlank(req.digitalId)) {
                response.addError('WS013-PD1','Veuillez saisir un ID');
                throw  new HP_WRP039_Devis.APIException();
            }
            if(String.isNotBlank(req.digitalId) && !(req.digitalId.isNumeric())) {
                response.addError('WS013-PD2','Veuillez saisir un ID numérique');
                throw  new HP_WRP039_Devis.APIException();
            }
            try{
                HP_WRP039_Devis.Response souscriptionStatusResponse  = HP_SM039_SouscriptionInfos.getDevis(req);
                response.output = souscriptionStatusResponse;
                response.message = 'List des devis';
                restResponse.statusCode = response.code;
                restResponse.responseBody = Blob.valueOf(JSON.serializePretty(response));
            }catch(HP_WRP039_Devis.APIException e){
                response.addError('WS013-PD3','statut supérieur');
                response.code = HP_HttpStatus.BAD_REQUEST;
            }
           
        }
        catch(HP_WRP039_Devis.APIException e){
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