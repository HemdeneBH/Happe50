/**
 * @File Name          : HP_WS007_Souscription.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 08-14-2020
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    07/02/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
@RestResource(urlMapping='/v1/enrolment/*')
global with sharing class HP_WS007_Souscription {

    
    @HttpPost
	global static void post() {
		processingResponse(RestContext.request);
	}

    @HttpPut // Can't put two annotations on the same method
	global static void put() {
		processingResponse(RestContext.request);
	}

    global static void processingResponse(RestRequest restRequest){ 
        
            Datetime startCall = Datetime.now();
            HP_EnrolmentRestResourceModel enrolmentRestRessource;
            RestResponse restResponse = RestContext.response;
            HP_WRP022_SFResponse response = new HP_WRP022_SFResponse(HP_HttpStatus.OK);
            try{
                String body = restRequest.requestBody.toString();
                System.debug('requestBody**** =============================' +  restRequest.requestBody );
                System.debug('body**** =============================' +  body );
                enrolmentRestRessource = (HP_EnrolmentRestResourceModel) JSON.deserialize(body, HP_EnrolmentRestResourceModel.class);
                



       
            if (enrolmentRestRessource.selfcareLead.firstSave_v0_1 != null) {
            HP_SM020_SouscriptionSave1.execute(enrolmentRestRessource.selfcareLead.firstSave_v0_1, response);
            }
         if (enrolmentRestRessource.selfcareLead.secondSave_v0_1 != null) {
                HP_SM021_SouscriptionSave2.execute(enrolmentRestRessource.selfcareLead.secondSave_v0_1, response);
            }
            if (enrolmentRestRessource.selfcareLead.thirdSave_v0_1 != null) {
                HP_SM022_SouscriptionSave3.execute(enrolmentRestRessource.selfcareLead.thirdSave_v0_1, response);
            }
           
            restResponse.statusCode = response.code;
			restResponse.responseBody = Blob.valueOf(JSON.serializePretty(response));
         
            
        }catch (HP_WRP022_SFResponse.APIException ex) {
            
                restResponse.statusCode = HP_HttpStatus.BAD_REQUEST; 
                restResponse.responseBody = Blob.valueOf(JSON.serializePretty(response));
            
           
            
		}
         catch (Exception ex) {
            response.code = HP_HttpStatus.BAD_REQUEST;
            response.message = ex.getMessage() + '   ' + ex.getStackTraceString();
            
                restResponse.statusCode = HP_HttpStatus.BAD_REQUEST;
                restResponse.responseBody = Blob.valueOf(JSON.serializePretty(response));   
         
           

		} finally {
            // Traitement spécefique pour le save1 avec image de compteur(Elec/Gaz)

            System.debug('*************finnaly**** =============================' );
            
        if(enrolmentRestRessource != null && enrolmentRestRessource.selfcareLead != null && enrolmentRestRessource.selfcareLead.firstSave_v0_1 != null){

            String energy = enrolmentRestRessource.selfcareLead.firstSave_v0_1.energyType;
            Boolean hasElec = energy == 'ELECTRICITY' || energy == 'COMBINED_GAS_AND_ELECTRICITY';
            Boolean hasGaz = energy == 'GAS' || energy == 'COMBINED_GAS_AND_ELECTRICITY';

            Boolean hasElecImage = enrolmentRestRessource.selfcareLead.firstSave_v0_1.electricityPhoto != null && enrolmentRestRessource.selfcareLead.firstSave_v0_1.electricityPhoto.body != null;
            Boolean hasGazImage =  enrolmentRestRessource.selfcareLead.firstSave_v0_1.gasPhoto != null &&  enrolmentRestRessource.selfcareLead.firstSave_v0_1.gasPhoto.body != null;

            if(hasElec && hasElecImage) enrolmentRestRessource.selfcareLead.firstSave_v0_1.electricityPhoto.body = 'Content Elec too long to be saved';
            if(hasGaz && hasGazImage) enrolmentRestRessource.selfcareLead.firstSave_v0_1.gasPhoto.body = 'Content Gas too long to be saved';

            String newBody = JSON.serialize(enrolmentRestRessource,true);
            restRequest.requestBody = Blob.valueof(newBody);
        }
        
    
			HP_UTIL_HTTPUtils.saveLogResponse(restRequest, restResponse, (Datetime.now().getTime() - startCall.getTime()));
		}
        
    }
}