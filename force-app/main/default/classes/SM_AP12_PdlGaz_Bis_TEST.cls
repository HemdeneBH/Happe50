@isTest
private class SM_AP12_PdlGaz_Bis_TEST{

	@testSetup static void setup(){
		SM_AP08_TestLib.insertCS_SMOCTOPUS();

		
	}

	@isTest 
	static void testCallout() {
		Test.startTest();

		Map < String, Object > input = new Map < String, Object > ();
		input.put('pce', '21101817097249');
		Map < String, Object > output = new Map < String, Object > ();
		SM_AP12_PdlGaz_Bis service = new SM_AP12_PdlGaz_Bis();
		service.invokeMethod('lirePdlGaz', input, output, null);
		SM_AP12_PdlGaz_Bis.PdlInfo objectTest = new SM_AP12_PdlGaz_Bis.PdlInfo(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null, null, null,null,null,null,null);
		SM_AP12_PdlGaz_Bis.Mesures mesure = new SM_AP12_PdlGaz_Bis.Mesures(null,null);

		Test.stopTest();
	}
}