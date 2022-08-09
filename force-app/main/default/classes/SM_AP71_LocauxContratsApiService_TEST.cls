@isTest
private class SM_AP71_LocauxContratsApiService_TEST
{
	/*
	*	@description : Appel depuis la vue 360
	*/
	@isTest(SeeAllData = false)
	public static void locauxContrats_Vue360_LWC()
    {
        System.debug('*** locauxContrats_Vue360_LWC');
        Map < String, Object > inputMap = new Map < String, Object >();		
        Map < String, Object > outMap = new Map < String, Object >();
        inputMap.put('idsPortefeuilleContrat','251760');
        
        // SM_AP53_ContratWS contratWS = new SM_AP53_ContratWS();
        MP_Generics_Endpoints__c endpoint = new MP_Generics_Endpoints__c();
        endpoint.EndPoint__c = 'https://auth.ext.rec.api.engie.fr';
        endpoint.Name = 'api_endpoint';
        insert endpoint;

        MP_Xdata_credentials__c sm_api_version = new MP_Xdata_credentials__c();
        sm_api_version.Value__c = '0.1';
        sm_api_version.Name = 'sm_api_version';
        insert sm_api_version;

        MP_Xdata_credentials__c sm_api_key_INT = new MP_Xdata_credentials__c();
        sm_api_key_INT.Value__c = 'l7xx914e96a9169640b2ab5afd09c6163829';
        sm_api_key_INT.Name = 'sm_api_key_INT';
        insert sm_api_key_INT;
        
        outMap = SM_AP71_LocauxContratsApiService.callLocauxContrats(inputMap);
        inputMap.put('idsPortefeuilleContrat',null);
        outMap = SM_AP71_LocauxContratsApiService.callLocauxContrats(inputMap);

        // System.assertEquals(3, outMap.size());
    }
}