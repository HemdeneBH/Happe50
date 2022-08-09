@isTest
public class SM_AP13_PdlElec_Bis_TEST {
   
	@testSetup 
	static void setup() {
			SM_AP08_TestLib.insertCS_SMOCTOPUS();
	}

	/*
	* @Author: Raouaa Jmour
	* @Date: 27/01/2020
	* @Description: method to test lirePDL in SM_AP13_PdlElec_Bis
	*/
	@isTest 
	static void testCallout() {
			Test.startTest();

			Map < String, Object > input = new Map < String, Object > ();
			Map < String, Object > chois = new Map < String, Object > ();
			input.put('pdl', '01199999844520');
			Map < String, Object > output = new Map < String, Object > ();
			SM_AP13_PdlElec_Bis service = new SM_AP13_PdlElec_Bis();
			service.invokeMethod('lirePdlElec', input, output, null);

			Test.stopTest();
	}
}