global class StringUtils implements vlocity_cmt.VlocityOpenInterface {

        /*

        inputs - arguments - List<Object> of passed in arguments

        output - result - The result of the Function being called. Supports single Object values, List<Object> or Map<String, Object>

    */

    
     global Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options)

    {

        // SUM Returns a single value

      
    //    deactivated on November 12th 2018 - TO BE DELETED
       if (methodName == 'text_size')

        {

            List<Object> arguments = (List<Object>)inputs.get('arguments');
            output.put('result', text_size(arguments));

        }
      
        
        /*

            Split Returns a Map<String, Object of values. Not all functions will be able to handle Map<String, Object> results,

            so be careful when using these functions.

            In a DataRaptor Transform step returning a Map<String, Object> from a Formula will result in applying that Map to the

            JSON Data at the FormulaResultPath. See https://vlocity.atlassian.net/wiki/display/RAP/Transforms

        */
        /*  deactivated on November 12th 2018 - TO BE DELETED
        else if (methodName == 'split')

        {

            List<Object> arguments = (List<Object>)inputs.get('arguments');

            output.put('result', split(arguments));

        }
        */
        /* Format Date "YYYY-MM-DD" => "DD/MM/YYYY" - To use in formula */
        if (methodName == 'date_fr_format')
        {           
            List<Object> arguments = (List<Object>)inputs.get('arguments');
            output.put('result', date_fr_format(arguments));            
        }
        return true;

    }

  

    Double text_size(List<Object> arguments)

    {
     return ((String)arguments.get(0)).length();
       

    }
   
    String date_fr_format(List<Object> arguments)

    {  //Date "YYYY-MM-DD" => "DD/MM/YYYY"
        return String.valueOf(arguments.get(0)).substring(8,10)+'/'+String.valueOf(arguments.get(0)).substring(5,7)+'/'+String.valueOf(arguments.get(0)).substring(0,4);
    }
    /*
    Map<String, String> split(List<Object> arguments)

    {

        Map<String, String> result = new Map<String, String>();

        String toSplit = (String)arguments[0];

        String splitter = (String)arguments[1];

        List<String> splitList = toSplit.split(splitter);

  

        for (Integer i = 0; i < splitList.size(); i++)

        {

            if (arguments.size() > i+2)

            {

                result.put((String)arguments[i+2], splitList[i]);

            }

            else

            {

                result.put('Split'+i, splitList[i]);

            }

        }

        return result;

    }
    */
}