/*
* @Author: Mohamed Kchaou
* @Date: 11/02/2019
* @Description: Test Class for SM_AP12_PdlGaz
*/
@isTest
public class SM_AP12_PdlGaz_Ref_TEST {
	@testSetup 
	static void setup() {
		SM_AP08_TestLib.insertCS_SMOCTOPUS();
	}

	/*
	* @Author: Mohamed Kchaou
	* @Date: 11/02/2019
	* @Description: Test Class for SM_AP12_PdlGaz
	*/
	@isTest 
	static void testCallout() {
		Test.startTest();

		Map < String, Object > input = new Map < String, Object > ();
		input.put('selectedPCEVal', '21101817097249');
		Map < String, Object > output = new Map < String, Object > ();
		SM_AP12_PdlGaz_Ref service = new SM_AP12_PdlGaz_Ref();
		service.invokeMethod('lirePdlGaz', input, output, null);
		SM_AP12_PdlGaz_Ref.PdlInfo objectTest = new SM_AP12_PdlGaz_Ref.PdlInfo(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null, null, null,null,null,null,null);
		SM_AP12_PdlGaz_Ref.Mesures mesure = new SM_AP12_PdlGaz_Ref.Mesures(null,null);

		Test.stopTest();
	}
}