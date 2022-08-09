/**
 * @File Name          : HP_APIHourCommercialPropositionService.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 11-15-2021
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    24/01/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class HP_APIHourCommercialPropositionService {

	public void updateList(final List<HP_CommercialProposition> commercialPropositionList){
		for(HP_CommercialProposition commercialProposition : commercialPropositionList) {
			HP_APIHourCommercialProposition xdataCommercialProposition = new HP_APIHourCommercialProposition(commercialProposition);
			HP_UTIL_HTTPUtils.calloutPut(HP_Constantes.XDATA_PROPOSITIONS_COMMERCIALES, System.JSON.serialize(xDataCommercialProposition), '/' + commercialProposition.xdataId);
		}
	}

	@future(callout=true)
	public static void updateCommmercialPropositionAsync(final List<Integer> commercialPropositionIdList, final String status, final String codeStatutPropositionCommercialePoste) {
		updateCommmercialPropositionSync(commercialPropositionIdList, status, codeStatutPropositionCommercialePoste);
	}

	public static void updateCommmercialPropositionSync(final List<Integer> commercialPropositionIdList, final String status) {
		updateCommmercialPropositionSync(commercialPropositionIdList, status,null);
	}

	
	public static void updateCommmercialPropositionSync(final List<Integer> commercialPropositionIdList, final String status, final String codeStatutPropositionCommercialePoste) {
		if(!commercialPropositionIdList.isEmpty()) { 
			final HP_APIHourCommercialPropositionService opportunityService = new HP_APIHourCommercialPropositionService();//TODO pattern
			final List<HP_CommercialProposition> commercialPropositionList = new List<HP_CommercialProposition>();
			for (Integer commercialPropositionId : commercialPropositionIdList) {
				commercialPropositionList.add(new HP_CommercialProposition(commercialPropositionId, status, codeStatutPropositionCommercialePoste));
			}
			opportunityService.updateList(commercialPropositionList);
		}
	}
}