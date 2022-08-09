public with sharing class HP_UTIL_CustomSetting {
    
	public static Map<String, HP_Offre__c> codeOffreByXdataId;

	static {
		loadCustomSettingOffre();
    }

    /**
	 * @description Construction de la map de la custom Setting HP_Offre__c 
	 * @author Vincent Albiser | 11/02/2020
	 * @return void
	 **/
	public static void loadCustomSettingOffre() {
        codeOffreByXdataId = new Map<String, HP_Offre__c>();
		for (HP_Offre__c offre : [SELECT offreCode__c,offreId__c,marqueCode__c,packId__c,offreLibelle__c FROM HP_Offre__c]) {
            codeOffreByXdataId.put(offre.offreCode__c, offre);
		}
	}
	
	public static HP_Offre__c getOffrebyCodeOffre(String codeOffre) {
		HP_Offre__c result;
		if (!String.isBlank(codeOffre) && codeOffreByXdataId.containsKey(codeOffre)) {
			result = codeOffreByXdataId.get(codeOffre);
		}
		if(result == null) {
			System.debug('### Code offre inexistant : ' + codeOffre);
		}
		return result;
	}
	// Méthode non utilisée
/*
    public static String getCodeOffre(Integer codeOffreId) {
		String resultString = null;
		if (codeOffreId != null) {
            for (String code : codeOffreByXdataId.keySet()){
                if (codeOffreByXdataId.get(code).offreId__c == codeOffreId){
                    resultString = code;
                }  
            }	
		}
		if(resultString == null) {
			System.debug('### Code offre Id inexistant : ' + codeOffreId);
		}
		return resultString;
    }
*/

}