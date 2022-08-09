@isTest
    public class StringUtils_Test {
        @isTest
        public static void date_fr_format() {
        List<Object> arguments;
        arguments = new List<Object>();
        arguments.add('2015/05/01');
       

        StringUtils strUtils = new StringUtils();
        Map<String, Object> inputs = new Map<String, Object>();
        Map<String,Object> output = new Map<String,Object>();
        Map<String, Object> options = new Map<String, Object>();
        inputs.put('arguments', arguments);
        strUtils.invokeMethod('date_fr_format', inputs, output, options);
        strUtils.invokeMethod('text_size', inputs, output, options);
        String result;

       // System.assert(!drs.invokeMethod(methodname, inputs, output, options), methodName + ' Phantom Function Test: Returned true not false');
        //result = (String) output.get('result');
        //System.assert(result.startsWith('Error:'), methodName + ' Phantom Function Test: Did not return error message');

    }
    }