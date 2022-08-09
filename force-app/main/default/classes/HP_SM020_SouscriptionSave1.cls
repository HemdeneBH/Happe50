/**
 * @File Name          : HP_SM020_SouscriptionSave1.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 24/03/2020 à 02:58:21
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    07/02/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public without sharing class HP_SM020_SouscriptionSave1 {
   
    public static void execute(final HP_EnrolmentRestResourceModel.FirstSave_v0_1 selfcare, HP_WRP022_SFResponse response) {
        //Map<String, String> resultCallApi = callAPIProcessing(selfcare, response);
        validationData(selfcare,response);
        updateDataProcessing(selfcare, response);
    }

   /* public void callAPIProcessing(final HP_EnrolmentRestResourceModel.FirstSave_v0_1 selfcare, HP_WRP022_SFResponse response) {
        
    }*/

    public static void validationData(final HP_EnrolmentRestResourceModel.FirstSave_v0_1 selfcare, HP_WRP022_SFResponse response) {
		if (!checkCanalName(selfcare.salesChannel)){
            response.code = HP_HttpStatus.BAD_REQUEST;
            response.addError('SM020-5', 'Canal de vente '+ selfcare.salesChannel +' introuvable.');
            throw new  HP_WRP022_SFResponse.APIException();
        }
    }
    
    public static Boolean checkCanalName(String canalVente) {
        Boolean isExisting = false;
		for(HP_PortailCanal__c canal :[SELECT Name FROM HP_PortailCanal__c]) {
			if(canal.Name == canalVente) {
				isExisting = true;
			}
		}
		return  isExisting;
	}

    public static void updateDataProcessing(final HP_EnrolmentRestResourceModel.FirstSave_v0_1 selfcare, HP_WRP022_SFResponse response) {
        String souscriptionId = null;
        try{
            souscriptionId = HP_EM005_Souscription.saveSouscription(selfcare);
            response.addinfo('SM020-1', 'Souscription est créé avec Id : ' + souscriptionId);
        }catch(Exception ex) {
            response.code = HP_HttpStatus.BAD_REQUEST;
            response.message = ex.getMessage();
            response.addError('SM020-2', 'Error au niveau de la création de la souscription');
            throw new HP_WRP022_SFResponse.APIException();
        }

        try{
             List<String> contractIdList = HP_EM023_Contrat.saveContrat(selfcare, souscriptionId);
             response.addinfo('SM020-3', 'Contrats sont créés avec Id : ' + contractIdList);
        }catch(Exception ex) {
            response.code = HP_HttpStatus.BAD_REQUEST;
            response.message = ex.getMessage();
            response.addError('SM020-4', 'Error au niveau de la création des contrats');
            throw new HP_WRP022_SFResponse.APIException();
        }
    }
}