/**
 * @File Name          : HP_FlyoutPDL.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 28/04/2020 à 07:06:14
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    24/03/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class HP_FlyoutPDL {

	private static String PDLInscope(String contratID){
		return ( (contratID == 'GRD-F006') ? ('PDL dans le périmètre') : ('PDL hors périmètre'));
	}

	@AuraEnabled(cacheable=true)
	public static Map<String,Object> getFlyoutPDL( String pdlElectricity){
		Map < String, Object > outputMap = new Map < String, Object >();
		try{
			final HP_EnergyRequest energyRequest = new HP_EnergyRequest(pdlElectricity);
			final HP_PreContractService service = new HP_SM028_DistGetPdlElec();
			final HP_EnergyResponse energyResponse = service.retrieveEnergyMeterInformations(energyRequest);
			System.debug('##### contract id '+PDLInscope(energyResponse.contractID));
			outputMap.put('perimetre', PDLInscope(energyResponse.contractID));
			outputMap.put('puissanceSouscriteValeur', energyResponse.electricityPowerRatingKiloVoltAmpere);
			outputMap.put('puissanceSouscriteUnite', energyResponse.electricityPowerRatingKiloVoltAmpereUnit);
			outputMap.put('niveauServices', energyResponse.serviceOpeningLevelCode + ' - '+ energyResponse.serviceOpeningLevel);
			outputMap.put('etatCompteur', energyResponse.contractualState);
			outputMap.put('numbreCadrans', energyResponse.numberOfDials);
			outputMap.put('typeCompteur', energyResponse.meterType);
			outputMap.put('transactionId', HP_UTIL_HTTPUtils.getTransactionId());
			return outputMap;
		}catch(Exception e) {
			outputMap.put('transactionId', HP_UTIL_HTTPUtils.getTransactionId());
			outputMap.put('error',true);
			return outputMap;
		}
		
	}

}