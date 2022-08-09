@isTest
public class SM_Utilities_Flow_TEST {
private static String myString = 'First;Second; Third;First';
    private static String character = ';';
    
 	static testMethod void notUnique() {
        SM_Utilities_Flow_TEST.testScenario(false, 4);
    }
    static testMethod void unique() {
        SM_Utilities_Flow_TEST.testScenario(true, 3);
    }
    
 
    static void testScenario(Boolean uniqueOnly, Integer listSize) {
        // Set up the request
        List<SM_Utilities_Flow.FlowRequest> requests = new List<SM_Utilities_Flow.FlowRequest>();
        SM_Utilities_Flow.FlowRequest request = new SM_Utilities_Flow.FlowRequest();
        request.myString = myString;
        request.character = character;
        request.uniqueOnly = uniqueOnly;
        requests.add(request);
        // Call the method
        List<List<String>> listOfSplitStrings = SM_Utilities_Flow.splitString(requests);
        // Assert that the list has the right number of strings
        for (List<String> splitStrings : listOfSplitStrings) {
            System.assertEquals(listSize, splitStrings.size());
        }
    }
    
}