/*
* @Author: Mohamed Kchaou
* @Date: 11/02/2019
* @Description: Test Class for SM_AP13_PdlElec
*/
@isTest
public class SM_AP13_PdlElec_Ref_TEST {
	/*
	* @Author: Mohamed Kchaou
	* @Date: 11/02/2019
	* @Description: method to create data
	*/
	@testSetup 
	static void setup() {
			SM_AP08_TestLib.insertCS_SMOCTOPUS();
	}

	/*
	* @Author: Mohamed Kchaou
	* @Date: 11/02/2019
	* @Description: method to test lirePDL in SM_AP13_PdlElec
	*/
	@isTest 
	static void testCallout() {
			Test.startTest();

			Map < String, Object > input = new Map < String, Object > ();
			input.put('selectedPDLVal', '01199999844520');
			Map < String, Object > output = new Map < String, Object > ();
			SM_AP13_PdlElec_Ref service = new SM_AP13_PdlElec_Ref();
			service.invokeMethod('lirePdlElec', input, output, null);

			Test.stopTest();
	}
}