@isTest
private class SM_AP53_ContratWS_TEST
{
	/*
	*	@description : Appel depuis le selfcare
	*/
	@isTest(SeeAllData = false)
	public static void rechercheContratWS()
	{
		System.debug('*** recherceContratWS');
		Map < String, Object > inputMap = new Map < String, Object >();		
		Map < String, Object > outMap = new Map < String, Object >();	
        
        inputMap.put('idBp','IDBP');
		
		SM_AP53_ContratWS contratWS = new SM_AP53_ContratWS();
        
        contratWS.invokeMethod('rechercherContrat',inputMap,outMap,null);
        System.assertEquals('OCTOPUS_RechercherContrat_01', outMap.get('rechercheContratRet'));
    }

    /*
	*	@description : Appel depuis la vue 360
	*/
	@isTest(SeeAllData = false)
	public static void rechercheContratWS_Vue360()
	{
		System.debug('*** recherceContratWS_Vue360');
		Map < String, Object > inputMap = new Map < String, Object >();		
		Map < String, Object > outMap = new Map < String, Object >();	
        
        inputMap.put('idBp','IDBP');
        inputMap.put('NoCompteClient','123456789');
        inputMap.put('typeEnergie','E');
        inputMap.put('origineAppel','Vue360');
		
		SM_AP53_ContratWS contratWS = new SM_AP53_ContratWS();
        
        contratWS.invokeMethod('rechercherContrat',inputMap,outMap,null);
        System.assertEquals('OCTOPUS_RechercherContrat_01', outMap.get('rechercheContratRet'));

        List<Object> objRes = (List<Object>) outMap.get('resultdata');
        System.assertEquals(1, objRes.size());
    }

	/*
	*	@description : Appel depuis la vue 360
	*/
	@isTest(SeeAllData = false)
	public static void rechercheContratWS_Vue360_LWC()
	{
		System.debug('*** recherceContratWS_Vue360_LWC');
		Map < String, Object > inputMap = new Map < String, Object >();		
		Map < String, Object > outMap = new Map < String, Object >();	
        // NoCompteClient: "000516675793"
		// PersonneIdentifier: "0312363915"
		// idBp: "0312363915"
		// idPortefeuille: 251760
		// origineAppel: "Vue360"
        inputMap.put('idBp','0312363915');
        inputMap.put('NoCompteClient','000516675793');
        inputMap.put('PersonneIdentifier','0312363915');
        inputMap.put('idPortefeuille','251760');
        inputMap.put('origineAppel','Vue360');
		
		SM_AP53_ContratWS contratWS = new SM_AP53_ContratWS();
        
        outMap = SM_AP53_ContratWS.rechercherContratLightning(inputMap);
        // System.assertEquals(3, outMap.size());
    }
}