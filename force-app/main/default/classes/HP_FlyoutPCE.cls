/**
 * @File Name          : HP_FlyoutPCE.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 27/04/2020 à 11:56:45
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    24/03/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class HP_FlyoutPCE {

	private static String isPCEinScope(final Boolean PerimetrePCE){
		return ( (PerimetrePCE == true)
		         ? ('PCE dans le périmètre')
		         : ('PCE hors périmètre')
		         );
	}

	@AuraEnabled(cacheable=true)
	public static Map<String,Object> getFlyoutPCE(final String PCEIdentifier, final Boolean PerimetrePCE){
		Map < String, Object > outputMap = new Map < String, Object >();
		try{
			
			final HP_PreContractService service = new HP_SM029_DistGetPdlGaz();
			final HP_EnergyRequest energyRequest = new HP_EnergyRequest(PCEIdentifier);
			final HP_EnergyResponse energyResponse = service.retrieveEnergyMeterInformations(energyRequest);
			outputMap.put('PerimetrePCE',isPCEinScope(PerimetrePCE));
			outputMap.put('TypeCompteur',energyResponse.meterType);
			outputMap.put('ConsommationAnnuelle',energyResponse.gazAnnualConsumption);
			outputMap.put('etatAlimentation',energyResponse.contractualState);
			outputMap.put('transactionId', HP_UTIL_HTTPUtils.getTransactionId());
			return outputMap;
		}catch(Exception e) {
			outputMap.put('transactionId', HP_UTIL_HTTPUtils.getTransactionId());
			outputMap.put('error',true);
			return outputMap;
		}
		
	}

}