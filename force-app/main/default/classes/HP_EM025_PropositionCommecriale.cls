/**
 * @File Name          : HP_EM025_PropositionCommecriale.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 25/02/2020 à 16:51:37
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    11/02/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class HP_EM025_PropositionCommecriale {
    
    
    public static String createPropositionCommecrialeXdata(HP_WRP023_XdataPropositionCommecriale propositionCommecriale) {
        final String bodyString = System.JSON.serialize(propositionCommecriale);
		final String jsonString = HP_UTIL_HTTPUtils.calloutPost(HP_Constantes.XDATA_PROPOSITIONS_COMMERCIALES, bodyString).getBody();
		List<Integer> alist = (List<Integer>)JSON.deserialize(jsonString, List<Integer>.class);
		if(alist.size() >=2) {
			return String.valueOf(alist.get(1));
		}
		return '0';
	}
	
	public static void updatePropositionCommecrialeXdata(String pcId, HP_WRP023_XdataPropositionCommecriale propositionCommecriale) {
        final String bodyString = System.JSON.serialize(propositionCommecriale);
		HP_UTIL_HTTPUtils.calloutPut(HP_Constantes.XDATA_PROPOSITIONS_COMMERCIALES, bodyString, '/' + pcId);

	}
	/*
	@future(callout=true)
	public static void updatePropositionCommecrialeXdataAsync(String pcId, String status) {
		HP_WRP023_XdataPropositionCommecriale cp = new HP_WRP023_XdataPropositionCommecriale(Integer.valueOf(pcId), status);
		updatePropositionCommecrialeXdata(pcId, cp);
	}*/
}