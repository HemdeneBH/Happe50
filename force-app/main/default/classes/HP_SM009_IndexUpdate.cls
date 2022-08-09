/**
 * @File Name          : HP_SM009_IndexUpdate.cls
 * @Description        :
 * @Author             : Vincent Albiser
 * @Group              :
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 03/03/2020 à 14:31:37
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    16/01/2020   Vincent Albiser     Initial Version
 **/
public with sharing class HP_SM009_IndexUpdate {

	/**
	 * @description mise à jour des index de l'asset
	 * @author Vincent Albiser | 16/01/2020
	 * @param HP_WRP009_IndexUpdate.Request req , HP_WRP022_SFResponse response
	 * @return HP_WRP022_SFResponse
	 **/
	public static void updateIndex(HP_WRP009_IndexUpdate.Request req, HP_WRP022_SFResponse response){

        try{
			HP_SM009_IndexUpdate.dataValidation(false, req, response);
			if(!response.errors.isEmpty()){
				throw new HP_WRP022_SFResponse.APIException();
			}
			Decimal indexGaz       = req.energie.equals('gaz') ? req.indexGaz : null;
			Decimal indexElec      = req.energie.equals('electricite') && req.indexElecHC == null? req.indexElec : null;
			Decimal indexElecHC = req.indexElecHC != null ? req.indexElecHC : null;
			Decimal indexElecHP = req.indexElecHC != null ? req.indexElec : null;
			HP_EM023_Contrat.upsertContratIndexByXdataId(req.xDataContractId, indexGaz, indexElec, indexElecHC, indexElecHP);
        }
        catch(Exception e){
            response.addError(e.getMessage(), 'SF Standard');
            response.code = 400;
		}  
	}

	public static void updateIndexResiliation(HP_WRP009_IndexUpdate.Request req, HP_WRP022_SFResponse response){

        try{
			HP_SM009_IndexUpdate.dataValidation(true, req, response);
			if(!response.errors.isEmpty()){
				throw new HP_WRP022_SFResponse.APIException();
			}
			Decimal index       = req.energie.equals('gaz') ? req.indexGaz : req.indexElec;
			Decimal indexElecHC = req.indexElecHC != null ? req.indexElecHC : null;
			HP_EM010_Case.updateCaseResiliationIndex(req.xDataContractId, req.indexElec, req.indexElecHC, req.indexGaz, response);
        }
        catch(Exception e){
            response.addError(e.getMessage(), 'SF Standard');
            response.code = 400;
		}  
	}

	/**
	 * @description vérification de l'input
	 * @author Vincent Albiser | 16/01/2020
	 * @param HP_WRP009_IndexUpdate.Request req
	 * @param HP_WRP022_SFResponse response
	 * @return void
	 **/

	public static void dataValidation(Boolean isCancelation, HP_WRP009_IndexUpdate.Request req, HP_WRP022_SFResponse response){

		if(req.xDataContractId == null) {
			response.addError('SM009-1','xDataContractId can\'t be null');
		}
		else{
			if(HP_EM023_Contrat.loadContratListByXdataId(req.xDataContractId).isEmpty()){
				response.addError( 'SM009-2','xDataContractId doesn\'t exist');
			}
			else if(!isCancelation){
				List<Case> caseList = HP_EM010_Case.getContratCasesPrestation(req.xDataContractId);
				if(caseList.isEmpty()) {
					response.addError( 'SM009-3','No Prestation GRD case for this contract');
				}
			}
		}
		if(String.isBlank(req.energie)) {
			response.addError('SM009-4','energie can\'t be null (or unsupported value)');
		}
		else{
			if(!req.energie.equals('gaz') && !req.energie.equals('electricite')) {
				response.addError( 'SM009-4','energie can\'t be null (or unsupported value)');
			}
			else{
				if(req.energie.equals('gaz') && req.indexGaz == null) {
					response.addError( 'SM009-5','indexGaz can\'t be null when \'energie\' is \'gaz\'');
				}
				if(req.energie.equals('electricite') && req.indexElec == null) {
					response.addError( 'SM009-6','indexElec can\'t be null when \'energie\' is \'electricite\'');
				}
			}
		}
	}
}