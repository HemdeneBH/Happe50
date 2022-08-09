@isTest 
public class SM_AP96_ArrayToJsonIP_Test {
     @isTest 
	static void testsplitdataToJson() {
		Test.startTest();
        String arguments='congelateur;piscine';
        Map<String, Object> inputs = new Map<String, Object>();
        Map < String, Object > output = new Map < String, Object > ();
        inputs.put('arguments',arguments);
        SM_AP96_ArrayToJsonIP sm= new SM_AP96_ArrayToJsonIP();
        Boolean response=sm.invokeMethod('splitdataToJson',inputs ,output , null   ); 
        System.assertEquals(response, true);
        Test.stopTest();
    }

}