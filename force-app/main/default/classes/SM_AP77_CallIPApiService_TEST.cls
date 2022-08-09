@isTest
private class SM_AP77_CallIPApiService_TEST
{
	/*
	*	@description : Appel depuis la vue 360
	*/
	@isTest(SeeAllData = false)
	public static void CallIP()
    {
        Map < String, Object > inputMap = new Map < String, Object >();		
        Map < String, Object > outMap = new Map < String, Object >();
        inputMap.put('idsPortefeuilleContrat','251760');
        String nameIP = 'TEST_IP';
        
        outMap = SM_AP77_CallIPApiService.callIP(inputMap, nameIP);
        // System.assertEquals(3, outMap.size());
    }
}