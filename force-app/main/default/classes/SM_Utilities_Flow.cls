public class SM_Utilities_Flow{
    
    //FlowUtility_SplitString
    @InvocableMethod(label = 'Split Variable By Character')
    public static List<List<String>> splitString(List<FlowRequest> requests) {
        List<List<String>> listOfSplitStrings = new List<List<String>>();
        for(FlowRequest request : requests) {
            String character = request.character;
            // Accounting for whitespace between the split char and the next value
            // For example, Flow multi-select input fields give us this extra space
            String myString = request.myString.replace(character + ' ', character);
            system.debug('myString = '+myString);   
            List<String> splitStrings = myString.split(character);
            if(request.uniqueOnly) {
                // I'm doing this quirky thing because we can't return a set
                listOfSplitStrings.add(
                        new List<String>(
                                new Set<String>(splitStrings)
                        )
                );
            } else {
                listOfSplitStrings.add(splitStrings);
            }
        }
        return listOfSplitStrings;
    }
    // This will come from the Flow
    public class FlowRequest {
        @InvocableVariable(label = 'String To Split' required = true)
        public String myString;
        @InvocableVariable(label = 'Character To Split By' required = true)
        public String character;
        @InvocableVariable(label = 'Return Only Unique Values' required = true)
        public Boolean uniqueOnly;
    }
}