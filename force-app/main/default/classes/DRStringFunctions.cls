/**
 * Wrapper around APEX String class methods for DataRaptor
 * <p>
 * Exposes useful String methods as callable functions to allow data
 * manipulation in the new transform section of data traptors.
 * <p>
 * Not all methods are exposed, just a useful subset.
 *
 * @author      Charles McGuinness <cmcguinness@vlocity.com>
 * @version     1.0
 */
global class DRStringFunctions implements vlocity_cmt.VlocityOpenInterface
{

    //  -------------------------------------------------------------------
    //  Lists of the functions we support, organized by argument list
    //  type.  This is useful for producting more reusable code
    //  -------------------------------------------------------------------

    // List of all functions that have an argument list of (String)
    private static final Set<String> funcsString = new Set<String> {
            'capitalize', 'deleteWhitespace',
            'escapeEcmaScript', 'escapeHtml4','escapeSingleQuotes', 'escapeUnicode', 'escapeXml',
            'isBlank', 'isNumeric', 'length', 'normalizeSpace', 'reverse', 'stripHtmlTags',
            'swapCase', 'toLowerCaseS', 'toUpperCaseS',
            'trim', 'uncapitalize',
            'unescapeEcmaScript', 'unescapeHtml4', 'unescapeUnicode', 'unescapeXml'
    };

    // List of functions that have an argument list of (String, Integer)
    private static final Set<String> funcsStringInteger = new Set<String> {
            'abbreviate', 'left', 'leftPad', 'right', 'rightPad', 'substringSI'
    };

    // List of functions that have an argument list of (String, String)
    private static final Set<String> funcsStringString = new Set<String> {
            'compareTo', 'contains', 'endsWith', 'endsWithIgnoreCase', 'equals', 'equalsIgnoreCase','indexOfSS', 'lastIndexOfSS',
            'remove', 'removeEnd', 'removeEndIgnoreCase', 'removeStart', 'removeStartIgnoreCase',
            'startsWith', 'startsWithIgnoreCase', 'substringAfter', 'substringAfterLast',
            'substringBefore', 'substringBeforeLast', 'substringBetweenSS',
            'toLowerCaseSS', 'toUpperCaseSS','concatString'
    };

    // List of functions that have an argument list of (String, String, Integer)
    private static final Set<String> funcsStringStringInteger = new Set<String> {
            'indexOfSSI', 'lastIndexOfSSI'
    };

    // List of functions that have an argument list of (String, Integer, Integer)
    private static final Set<String> funcsStringIntegerInteger = new Set<String> {
            'mid', 'substringSII'
    };


    // List of functions that have an argument list of (String, String, String)
    private static final Set<String> funcsStringStringString = new Set<String> {
            'replace', 'replaceAll', 'replaceFirst', 'substringBetweenSSS'
    };


    //  -------------------------------------------------------------------
    //  Generic Validation Methods:
    //
    //  These are used for generic validation of input arguments
    //  -------------------------------------------------------------------


    /**
     * Validate that there are the correct number of arguments passed to a function
     *
     * @param   methodName  Name of method that's been invoked
     * @param   output      We will put an error message into it if the argument count is invalid
     * @param   arguments   The input arguments we're checking
     * @param   cnt         The number of arguments we expect
     * @returns Boolean, true == valid, false == invalid
    */
    private Boolean validateArgCount(String methodName, Map<String, Object> output, List<Object> arguments, Integer cnt) {
        if (cnt == arguments.size()) {
            return true;
        }
        String errorMessage;

        errorMessage = 'Error: Method ' + methodName + ' expects ' + String.valueOf(cnt) + ' arguments, received ' + String.valueOf(arguments.size());
        // System.debug(errorMessage);
        output.put('result', errorMessage);
        return false;

    }

    /**
     * Check to see if a given argument is a String (isArgString) or an Integer (isArgInteger)
     * <p>
     * Helps simplify validating parameters to functions.  Note that isArgInteger will
     * attempt to convert the argument to an integer if it is not.  If it succeeds, it
     * updates the argument list.
     *
     * @param   methodName  Name of method that's been invoked
     * @param   output      We will put an error message into it if the argument is invalid
     * @param   arguments   The input arguments we're checking
     * @param   position    The location in the argument list to check.
     * @returns Boolean, true == valid, false == invalid
    */
    private Boolean isArgString(String methodName, Map<String, Object> output, List<Object> arguments, Integer position) {
        if (arguments[position] instanceof String) {
            return true;
        }

        String errorMessage;

        errorMessage = 'Error: In method ' + methodName + ', argument #' + String.valueOf(position) + ' should be a String';
        // System.debug(errorMessage);
        output.put('result', errorMessage);
        return false;

    }

    private Boolean isArgInteger(String methodName, Map<String, Object> output, List<Object> arguments, Integer position) {
        if (arguments[position] instanceof Integer) {
            return true;
        }

        try {
            Integer i = Integer.valueOf(arguments[position]);
            arguments[position] = i;
            return true;
        } catch (exception e) {
            // fall through...
        }

        String errorMessage;

        errorMessage = 'Error: In method ' + methodName + ', argument #' + String.valueOf(position) + ' should be an Integer';
        System.debug(errorMessage);
        output.put('result', errorMessage);
        return false;

    }



    //  -------------------------------------------------------------------
    //  Methods for handling particular method signatures
    //  -------------------------------------------------------------------


    /**
     * Handle functions that take, as parameters, (String)
     *
     * @param   methodName
     * @param   arguments
     * @param   output
     */
    private Boolean handleString(String methodName, String urMethodName, List<Object> arguments, Map<String, Object> output) {
        if (! validateArgCount(urMethodName, output, arguments, 1)) {
            return false;
        }
        if (! isArgString(urMethodName, output, arguments, 0)) {
            return false;
        }

        String a0 = (String) arguments[0];

        if (methodName == 'capitalize') {
            output.put('result', a0.capitalize());
            return true;
        }

        if (methodName == 'deleteWhitespace') {
            output.put('result', a0.deleteWhitespace());
            return true;
        }

        if (methodName == 'escapeEcmaScript') {
            output.put('result', a0.escapeEcmaScript());
            return true;
        }

        if (methodName == 'escapeHtml4') {
            output.put('result', a0.escapeHtml4());
            return true;
        }

        if (methodName == 'escapeSingleQuotes') {
            output.put('result', String.escapeSingleQuotes(a0));
            return true;
        }

        if (methodName == 'escapeUnicode') {
            output.put('result', a0.escapeUnicode());
            return true;
        }

        if (methodName == 'escapeXml') {
            output.put('result', a0.escapeXml());
            return true;
        }

        if (methodName == 'isBlank') {
            output.put('result', String.isBlank(a0));
            return true;
        }

        if (methodName == 'isNumeric') {
            output.put('result', a0.isNumeric());
            return true;
        }

        if (methodName == 'length') {
            output.put('result', a0.length());
            return true;
        }

        if (methodName == 'normalizeSpace') {
            output.put('result', a0.normalizeSpace());
            return true;
        }

        if (methodName == 'reverse') {
            output.put('result', a0.reverse());
            return true;
        }

        if (methodName == 'stripHtmlTags') {
            output.put('result', a0.stripHtmlTags());
            return true;
        }

        if (methodName == 'swapCase') {
            output.put('result', a0.swapCase());
            return true;
        }

        if (methodName == 'toLowerCaseS') {
            output.put('result', a0.toLowerCase());
            return true;
        }

        if (methodName == 'toUpperCaseS') {
            output.put('result', a0.toUpperCase());
            return true;
        }

        if (methodName == 'trim') {
            output.put('result', a0.trim());
            return true;
        }

        if (methodName == 'uncapitalize') {
            output.put('result', a0.uncapitalize());
            return true;
        }

        if (methodName == 'unescapeEcmaScript') {
            output.put('result', a0.unescapeEcmaScript());
            return true;
        }

        if (methodName == 'unescapeHtml4') {
            output.put('result', a0.unescapeHtml4());
            return true;
        }

        if (methodName == 'escapeSingleQuotes') {
            output.put('result', String.escapeSingleQuotes(a0));
            return true;
        }

        if (methodName == 'unescapeUnicode') {
            output.put('result', a0.unescapeUnicode());
            return true;
        }

        if (methodName == 'unescapeXml') {
            output.put('result', a0.unescapeXml());
            return true;
        }


        output.put('result', 'Error: No Matching Function Found');
        return false;
    }

    /**
     * Handle functions that take, as parameters, (String, Integer)
     *
     * @param   methodName
     * @param   arguments
     * @param   output
     * @return  Boolean, success if true
     */
    private Boolean handleStringInteger(String methodName, String urMethodName,  List<Object> arguments, Map<String, Object> output) {

        if (! validateArgCount(urMethodName, output, arguments, 2)) {
            return false;
        }
        if (! isArgString(urMethodName, output, arguments, 0)) {
            return false;
        }
        if (! isArgInteger(urMethodName, output, arguments, 1)) {
            return false;
        }

        String a0 = (String) arguments[0];
        Integer a1 = Integer.valueOf(arguments[1]);

        if (methodName == 'abbreviate') {
            output.put('result', a0.abbreviate(a1));
            return true;
        }

        if (methodName == 'left') {
            output.put('result', a0.left(a1));
            return true;
        }

        if (methodName == 'leftPad') {
            output.put('result', a0.leftPad(a1));
            return true;
        }

        if (methodName == 'right') {
            output.put('result', a0.right(a1));
            return true;
        }

        if (methodName == 'rightPad') {
            output.put('result', a0.rightPad(a1));
            return true;
        }

        if (methodName == 'substringSI') {
            output.put('result', a0.substring(a1));
            return true;
        }

        output.put('result', 'Error: No Matching Function ' + urMethodName + ' Found');
        return false;
    }

    /**
     * Handle functions that take, as parameters, (String, String)
     *
     * @param   methodName
     * @param   arguments
     * @param   output
     * @return  Boolean, success if true
     */
    private Boolean handleStringString(String methodName, String urMethodName, List<Object> arguments, Map<String, Object> output) {
        if (! validateArgCount(urMethodName, output, arguments, 2)) {
            return false;
        }
        if (! isArgString(urMethodName, output, arguments, 0)) {
            return false;
        }
        if (! isArgString(urMethodName, output, arguments, 1)) {
            return false;
        }

        String a0 = (String) arguments[0];
        String a1 = (String) arguments[1];

        if (methodName == 'compareTo') {
            output.put('result', ((String) arguments[0]).compareTo((String) arguments[1]));
            return true;
        }

        if (methodName == 'contains') {
            output.put('result', ((String) arguments[0]).contains((String) arguments[1]));
            return true;
        }

        if (methodName == 'endsWith') {
            output.put('result', ((String) arguments[0]).endsWith((String) arguments[1]));
            return true;
        }

        if (methodName == 'endsWithIgnoreCase') {
            output.put('result', ((String) arguments[0]).endsWithIgnoreCase((String) arguments[1]));
            return true;
        }
        if (methodName == 'equals') {
            output.put('result', ((String) arguments[0]).equals((String) arguments[1]));
            return true;
        }

        if (methodName == 'equalsIgnoreCase') {
            output.put('result', ((String) arguments[0]).equalsIgnoreCase((String) arguments[1]));
            return true;
        }

        if (methodName == 'indexOfSS') {
            output.put('result', a0.indexOf(a1));
            return true;
        }

        if (methodName == 'lastIndexOfSS') {
            output.put('result', a0.lastIndexOf(a1));
            return true;
        }

        if (methodName == 'remove') {
            output.put('result', ((String) arguments[0]).remove((String) arguments[1]));
            return true;
        }

        if (methodName == 'removeEnd') {
            output.put('result', ((String) arguments[0]).removeEnd((String) arguments[1]));
            return true;
        }

        if (methodName == 'removeEndIgnoreCase') {
            output.put('result', ((String) arguments[0]).removeEndIgnoreCase((String) arguments[1]));
            return true;
        }
        if (methodName == 'removeStart') {
            output.put('result', ((String) arguments[0]).removeStart((String) arguments[1]));
            return true;
        }
        if (methodName == 'removeStartIgnoreCase') {
            output.put('result', ((String) arguments[0]).removeStartIgnoreCase((String) arguments[1]));
            return true;
        }
        if (methodName == 'startsWith') {
            output.put('result', a0.startsWith(a1));
            return true;
        }
        if (methodName == 'startsWithIgnoreCase') {
            output.put('result', a0.startsWithIgnoreCase(a1));
            return true;
        }

        if (methodName == 'substringAfter') {
            output.put('result', a0.substringAfter(a1));
            return true;
        }

        if (methodName == 'substringAfterLast') {
            output.put('result', a0.substringAfterLast(a1));
            return true;
        }

        if (methodName == 'substringBefore') {
            output.put('result', a0.substringBefore(a1));
            return true;
        }

        if (methodName == 'substringBeforeLast') {
            output.put('result', a0.substringBeforeLast(a1));
            return true;
        }

        if (methodName == 'substringBetweenSS') {
            output.put('result', a0.substringBetween(a1));
            return true;
        }

        if (methodName == 'toLowerCaseSS') {
            output.put('result', a0.toLowerCase(a1));
            return true;
        }

        if (methodName == 'toUpperCaseSS') {
            output.put('result', a0.toUpperCase(a1));
            return true;
        }
        
         if (methodName == 'concatString') {
            output.put('result', a0+a1);
            return true;
        }        
        

        output.put('result', 'Error: No Matching Function Found');
        return false;
    }

    /**
     * Handle functions that take, as parameters, (String, String, String)
     * <p>
     * Louis Prima would like this method.
     *
     * @param   methodName
     * @param   arguments
     * @param   output
     * @return  Boolean, success if true
     */
    private Boolean handleStringStringString(String methodName, String urMethodName, List<Object> arguments, Map<String, Object> output) {

        if (! validateArgCount(urMethodName, output, arguments, 3)) {
            return false;
        }
        if (! isArgString(urMethodName, output, arguments, 0)) {
            return false;
        }
        if (! isArgString(urMethodName, output, arguments, 1)) {
            return false;
        }
        if (! isArgString(urMethodName, output, arguments, 2)) {
            return false;
        }

        String a0 = (String) arguments[0];
        String a1 = (String) arguments[1];
        String a2 = (String) arguments[2];

        if (methodName == 'replace') {
            output.put('result', a0.replace(a1,a2));
            return true;
        }

        if (methodName == 'replaceAll') {
            output.put('result', a0.replaceAll(a1,a2));
            return true;
        }

        if (methodName == 'replaceFirst') {
            output.put('result', a0.replaceFirst(a1,a2));
            return true;
        }

        if (methodName == 'substringBetweenSSS') {
            output.put('result', a0.substringBetween(a1,a2));
            return true;
        }


        output.put('result', 'Error: No Matching Function Found');
        return false;
    }

    /**
     * Handle functions that take, as parameters, (String, Integer, Integer)
     *
     * @param   methodName
     * @param   arguments
     * @param   output
     * @return  Boolean, success if true
     */
    private Boolean handleStringIntegerInteger(String methodName, String urMethodName, List<Object> arguments, Map<String, Object> output) {

        if (! validateArgCount(urMethodName, output, arguments, 3)) {
            return false;
        }
        if (! isArgString(urMethodName, output, arguments, 0)) {
            return false;
        }
        if (! isArgInteger(urMethodName, output, arguments, 1)) {
            return false;
        }
        if (! isArgInteger(urMethodName, output, arguments, 2)) {
            return false;
        }

        String a0 = (String) arguments[0];
        Integer a1 = Integer.valueOf(arguments[1]);
        Integer a2 = Integer.valueOf(arguments[2]);

        if (methodName == 'mid') {
            output.put('result', a0.mid(a1,a2));
            return true;
        }

        if (methodName == 'substringSII') {
            output.put('result', a0.substring(a1,a2));
            return true;
        }

        output.put('result', 'Error: No Matching Function Found');
        return false;
    }

    /**
     * Handle functions that take, as parameters, (String, String, Integer)
     *
     * @param   methodName
     * @param   arguments
     * @param   output
     * @return  Boolean, success if true
     */
    private Boolean handleStringStringInteger(String methodName, String urMethodName, List<Object> arguments, Map<String, Object> output) {

        if (! validateArgCount(urMethodName, output, arguments, 3)) {
            return false;
        }
        if (! isArgString(urMethodName, output, arguments, 0)) {
            return false;
        }
        if (! isArgString(urMethodName, output, arguments, 1)) {
            return false;
        }
        if (! isArgInteger(urMethodName, output, arguments, 2)) {
            return false;
        }

        String a0 = (String) arguments[0];
        String a1 = (String) arguments[1];
        Integer a2 = Integer.valueOf(arguments[2]);

        if (methodName == 'indexOfSSI') {
            output.put('result', a0.indexOf(a1, a2));
            return true;
        }


        if (methodName == 'lastIndexOfSSI') {
            output.put('result', a0.lastIndexOf(a1, a2));
            return true;
        }

        output.put('result', 'Error: No Matching Function Found');
        return false;
    }



    //  -------------------------------------------------------------------
    //  Primary entry point for this class
    //  -------------------------------------------------------------------

    /**
     * Implementation of invokeMethod from VlocityOpenInterface
     * <p>
     * Documentation for specific functions is given in their methods
     *
     * @param    methodName Name of method to invoke
     * @param    inputs Arguments - List<Object> of passed in arguments
     * @param    output The result of the Function being called. Supports single Object values, List<Object> or Map<String, Object>
     * @param    options Options, not used in this class
     * @returns  Boolean, indicating success or failure    
    */
    global Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options)
    {
        //  This is useful debugging code in case somebody returns without setting a result by mistake
        output.put('result', 'Error: result not set');

        // Retrieve the argument lists
        List<Object> arguments = (List<Object>)inputs.get('arguments');


        //  -------------------------------------------------------------------
        //  This is a hack for polymorphic functions, to turn them into one
        //  of two non-polymorphic functions:
        //  -------------------------------------------------------------------

        String urMethodName = methodName;   // Save the real method name for error messages...

        Set<String> funcsPolymorphicSS = new Set<String> { 'toLowerCase', 'toUpperCase'};

        if (funcsPolymorphicSS.contains(methodName)) {
            if (arguments != null && arguments.size() == 1) {
                methodName = methodName + 'S';
            } else {
                methodName = methodName + 'SS';
            }
        }

        Set<String> funcsPolymorphicSSI = new Set<String> { 'indexOf', 'lastIndexOf'};

        if (funcsPolymorphicSSI.contains(methodName)) {
            if (arguments != null && arguments.size() == 2) {
                methodName = methodName + 'SS';
            } else {
                methodName = methodName + 'SSI';
            }
        }
        Set<String> funcsPolymorphicSII = new Set<String> { 'substring' };

        if (funcsPolymorphicSII.contains(methodName)) {
            if (arguments != null && arguments.size() == 2) {
                methodName = methodName + 'SI';
            } else {
                methodName = methodName + 'SII';
            }
        }

        Set<String> funcsPolymorphicSSS = new Set<String> { 'substringBetween' };

        if (funcsPolymorphicSSS.contains(methodName)) {
            if (arguments != null && arguments.size() == 2) {
                methodName = methodName + 'SS';
            } else {
                methodName = methodName + 'SSS';
            }
        }

        //  -------------------------------------------------------------------
        //  Step 1:
        //  Validate the input arguments are of the right type(s) and number
        //
        //  I suppose it would be OK to just let exceptions ripple back up, but
        //  I think the exception details would get lost before being noticed and thus be
        //  very hard to debug.  Instead, I'll pass back an error message in the
        //  result - it will show up somewhere that someone will notice it.
        //  -------------------------------------------------------------------

        //  1a: Are there any arguments at all?
        if (arguments == null) {
            String errorMessage;

            errorMessage = 'Error: In method ' + methodName + ', no arguments passed';
            // System.debug(errorMessage);
            output.put('result', errorMessage);
            return false;
        }

        //  -------------------------------------------------------------------
        //  Step 2:
        //  Find the right signature, dispatch to handler
        //  -------------------------------------------------------------------

        // a: func(String)
        if (funcsString.contains(methodName)) {
            return handleString(methodName, urMethodName, arguments, output);
        }

        // b: func(String,Integer)
        if (funcsStringInteger.contains(methodName)) {
            return handleStringInteger(methodName, urMethodName, arguments, output);
        }

        // c: func(String,String)
        if (funcsStringString.contains(methodName)) {
            return handleStringString(methodName, urMethodName, arguments, output);
        }

        // d: func(String,String,Integer)
        if (funcsStringStringInteger.contains(methodName)) {
            return handleStringStringInteger(methodName, urMethodName, arguments, output);
        }

        // e: func(String,Integer,Integer)
        if (funcsStringIntegerInteger.contains(methodName)) {
            return handleStringIntegerInteger(methodName, urMethodName, arguments, output);
        }

        // f: func(String,String,String)
        if (funcsStringStringString.contains(methodName)) {
            return handleStringStringString(methodName, urMethodName, arguments, output);
        }

        output.put('result', 'Error: No Matching Function Found');
        return false;
    }

}