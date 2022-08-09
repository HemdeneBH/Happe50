/**
 * Test class for DRStringFunctions
 * <p>
 *  This class is designed to test the functions in DRStringFunctions.  As that class
 *  is just a wrapper around string functions, there's a great deal of parallelism
 *  between this class and that one: we test by passing test strings to the DR... and
 *  also running the wrapped functions ourselves.
 *  <p>
 *  The errors we might find, then, are not in String's methods themselves, but in
 *  how they are wrapped (e.g., the wrong method is called, the output is lost etc.)
 *
 * @author      Charles McGuinness <cmcguinness@vlocity.com>
 * @version     1.0
 */
@isTest
private Class DRStringFunctionsTest {

    // These are the names of the methods we support sorted by signature; we can perform
    // generic testing on them knowing the arguments they take
    private static List<String> funcsString = new List<String> {
            'captialize', 'deleteWhitespace',
            'escapeEcmaScript', 'escapeHtml4','escapeSingleQuotes', 'escapeUnicode', 'escapeXml',
            'isBlank', 'isNumeric', 'length', 'normalizeSpace', 'reverse',
            'stripHtmlTags', 'swapCase','toLowerCase', 'toUpperCase',
            'trim', 'uncapitalize', 'unescapeEcmaScript', 'unescapeHtml4', 'unescapeUnicode', 'unescapeXml'

    };

    private static list<String> funcsStringInteger = new List<String> {
            'abbreviate', 'left', 'leftPad', 'right', 'rightPad', 'substring'
    };

    private static list<String> funcsStringString = new List<String> {
            'compareTo', 'contains', 'endsWith',  'endsWithIgnoreCase', 'equals', 'equalsIgnoreCase', 'indexOf', 'lastIndexOf',
            'remove', 'removeEnd', 'removeEndIgnoreCase', 'removeStart', 'removeStartIgnoreCase',
            'startsWith', 'startsWithIgnoreCase',
            'substringAfter', 'substringAfterLast', 'substringBefore', 'substringBeforeLast',
            'substringBetween',
            'toLowerCase', 'toUpperCase'
    };

    private static list<String> funcsStringStringInteger = new List<String> {
            'indexOf', 'lastIndexOf'
    };

    private static list<String> funcsStringIntegerInteger = new List<String> {
            'mid', 'substring'
    };

    private static list<String> funcsStringStringString = new List<String> {
            'replace', 'replaceAll', 'replaceFirst', 'substringBetween'
    };


    //                                             01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
    private static String  testLongString       = 'This is a fairly long string and this can be used in this place where long length is important';
    private static String  testLongSubString    = 'string';      // MUST NOT BE AT END OF STRING
    private static String  testLongStart        = 'This is';     // MUST BE AT START OF STRING
    private static String  testLongStartCase    = 'THIS is';     // MUST BE AT START OF STRING WE
    private static String  testLongEnd          = ' important';  // MUST BE AT END OF STRING
    private static String  testLongEndCase      = ' impORTant';  // MUST BE AT END OF STRING WITH DIFFERENT CASE
    private static String  testLongMiddle       = 'long';
    private static String  testShortString6     = 'Shorty';
    private static String  testShortStart       = 'Sho';
    private static String  testShortStartCase   = 'sHO';
    private static String  testShortSubString   = 'ort';         // MUST NOT BE AT END OF STRING
    private static String  testShortEnd         = 'ty';          // MUST BE AT END OF STRING
    private static String  testShortEndCase     = 'Ty';          // MUST BE AT END OF STRING WITH DIFFERENT CASE
    private static String  testGerman           = 'Hier sind deutschen Buchstaben: üÜ';
    private static String  testInteger          = '1234';
    private static String  testNotAnInteger     = '0x200';
    private static String  testLongRegexString  = 'long.*this';
    private static String  testLongRegexRepeat  = '[Tt]his';
    private static String  testShortRegexString = '[or]*';
    private static String  testBadRegexString   = 'NOT.*PRESENT';
    private static String  testBadSubString     = 'THIS IS NOT IN ANY OTHER STRING';
    private static String  testTrimString       = '  spaces     spaces   everywhere   ';


    /**
     * This is a utility function to see if we get the right results from invoking a method
     *
     * @param   methodName      The name of the method in DRStringFunctions class to invoke
     * @param   testName        The name of the test to show in an error message
     * @param   arguments       The argument list to pass to methodName
     * @param   expecteResults  What we expect output.get('result') to contain
     */
    static void testCorrectResults(String methodName, String testName, List<Object> arguments, String expectedResult) {
        DRStringFunctions drs = new DRStringFunctions();
        Map<String, Object> inputs = new Map<String, Object>();
        Map<String, Object> output = new Map<String,Object>();
        Map<String, Object> options = new Map<String, Object>();
        String result;
        String safeResult;

        Boolean success;

        inputs.put('arguments', arguments);

        success = drs.invokeMethod(methodname, inputs, output, options);

        result = (String) output.get('result');
        safeResult = result;
        if (result == null) {
            safeResult = 'null';
        }


        System.assert(success, methodName + ' test ' + testName + ': Returned false not true.  Result = ' + safeResult);
        System.assertEquals(expectedResult, result, methodName + ' test ' + testName + ': Unexpected return value');

    }

    static void testCorrectResults(String methodName, String testName, List<Object> arguments, Integer expectedResult) {
        DRStringFunctions drs = new DRStringFunctions();
        Map<String, Object> inputs = new Map<String, Object>();
        Map<String,Object> output = new Map<String,Object>();
        Map<String, Object> options = new Map<String, Object>();
        String result;

        Boolean success;

        inputs.put('arguments', arguments);

        success = drs.invokeMethod(methodname, inputs, output, options);

        if (output.get('result') == null) {
            result = '<no result>';
        }

        if (output.get('result') instanceof Integer) {
            result = String.valueOf(output.get('result'));
        }

        if (output.get('result') instanceof String) {
            result = (String) output.get('result');
        }

        System.assert(success, methodName + ' test ' + testName + ': Returned false not true, Result = ' + result);
        System.assertEquals(expectedResult, (Integer) output.get('result'), methodName + ' test ' + testName + ': Unexpected return value');
    }

    static void testCorrectResults(String methodName, String testName, List<Object> arguments, Boolean expectedResult) {
        DRStringFunctions drs = new DRStringFunctions();
        Map<String, Object> inputs = new Map<String, Object>();
        Map<String,Object> output = new Map<String,Object>();
        Map<String, Object> options = new Map<String, Object>();
        String result;

        Boolean success;

        inputs.put('arguments', arguments);

        success = drs.invokeMethod(methodname, inputs, output, options);

        if (output.get('result') == null) {
            result = '<no result>';
        }

        if (output.get('result') instanceof Boolean) {
            result = String.valueOf(output.get('result'));
        }

        if (output.get('result') instanceof String) {
            result = (String) output.get('result');
        }

        System.assert(success, methodName + ' test ' + testName + ': Returned false not true, Result = ' + result);
        System.assertEquals(expectedResult, (Boolean) output.get('result'), methodName + ' test ' + testName + ': Unexpected return value');
    }

    /**
     *  Test phantom function
     *  <p>
     *  Tries to call a function that does not exist.
     */
    static testMethod void testPhantom() {
        String methodName = 'thisdoesnotexist';
        List<Object> arguments;
        arguments = new List<Object>();
        arguments.add('Something');

        DRStringFunctions drs = new DRStringFunctions();
        Map<String, Object> inputs = new Map<String, Object>();
        Map<String,Object> output = new Map<String,Object>();
        Map<String, Object> options = new Map<String, Object>();
        String result;

        System.assert(!drs.invokeMethod(methodname, inputs, output, options), methodName + ' Phantom Function Test: Returned true not false');
        result = (String) output.get('result');
        System.assert(result.startsWith('Error:'), methodName + ' Phantom Function Test: Did not return error message');
    }

    /**
     * Test a single method to see if it handles missing arguments properly
     *
     * @param   methodName      The name of the method in DRStringFunctions class to invoke
     * @param   testName        The name of the test to show in an error message
     */
    static void testNoArgumentsSingle(String methodName, String testName) {
        DRStringFunctions drs = new DRStringFunctions();
        Map<String, Object> inputs = new Map<String, Object>();
        Map<String,Object> output = new Map<String,Object>();
        Map<String, Object> options = new Map<String, Object>();
        String result;

        System.assert(!drs.invokeMethod(methodname, inputs, output, options), methodName + ' test ' + testName + ': Returned true not false');
        result = (String) output.get('result');
        System.assert(result.startsWith('Error:'), methodName + ' test ' + testName + ': Did not return error message');
    }

    /**
     * Test all methods to ensure they properly handle "no arguments"
     */
    static testMethod void testNoArgumentsAll() {
        for (String f: funcsString) {
            testNoArgumentsSingle(f, 'no args');
        }

        for (String f: funcsStringInteger) {
            testNoArgumentsSingle(f, 'no args');
        }

        for (String f: funcsStringString) {
            testNoArgumentsSingle(f, 'no args');
        }
    }

    /**
     * Test a single method to see if it handles missing arguments properly
     *
     * @param   methodName      The name of the method in DRStringFunctions class to invoke
     * @param   testName        The name of the test to show in an error message
     * @param   arguments       The argument list to pass to methodName
     */
    static void testBadArgs(String methodName, String testName, List<Object> arguments) {
        DRStringFunctions drs = new DRStringFunctions();
        Map<String, Object> inputs = new Map<String, Object>();
        Map<String,Object> output = new Map<String,Object>();
        Map<String, Object> options = new Map<String, Object>();
        String result;

        inputs.put('arguments', arguments);
        System.assert(!drs.invokeMethod(methodname, inputs, output, options), methodName + ' test ' + testName + ': Returned true not false');
        result = (String) output.get('result');
        System.assert(result != null,  methodName + ' test ' + testName + ': Did not return result');
        System.assert(result.startsWith('Error:'), methodName + ' test ' + testName + ': Did not return error message');
    }

    /**
     *  Verify that all method under test handle bad arguments
     *  <p>
     *     This tries all blantantly bad combinations of arguments, including:
     *     No Arguments,
     *     The wrong count of arguments, and
     *     Non-Integer values where an Integer is expected.
     *
     */
    static testMethod void testBadArgsAll() {
        List<Object> arguments;

        // Test single string functions
        arguments = new List<Object>();
        arguments.add('THIS IS A STRING');
        arguments.add('THIS IS A SECOND STRING WHICH IS NOT SUPPOSED TO BE HERE');
        arguments.add('THIS IS A THIRD STRING WHICH IS NOT SUPPOSED TO BE HERE');
        for (String f: funcsString) {
            testBadArgs(f, 'arg count', arguments);
        }

        //  For String,Integer functions, test (a) the arg count and (b) the second arg must be convertable to Integer
        arguments = new List<Object>();
        arguments.add('THIS IS A STRING BUT THERE IS NO SECOND ARG');
        for (String f: funcsStringInteger) {
            testBadArgs(f, 'arg count', arguments);
        }

        arguments = new List<Object>();
        arguments.add('this is a very very very very long string');
        arguments.add('NOT AN INTEGER');
        for (String f: funcsStringInteger) {
            testBadArgs(f, 'second arg int', arguments);
        }

        //  For String,String functions, test the arg count
        arguments = new List<Object>();
        // There are zero arguments
        for (String f: funcsStringString) {
            testBadArgs(f, 'arg count', arguments);
        }

        //  For String,Integer,Integer functions, test (a) the arg count and (b) the 2nc 3rd args must be convertable to Integer
        arguments = new List<Object>();
        arguments.add('THIS IS A STRING BUT THERE IS NO SECOND ARG');
        for (String f: funcsStringIntegerInteger) {
            testBadArgs(f, 'arg count', arguments);
        }

        arguments = new List<Object>();
        arguments.add('THIS IS A STRING BUT THERE IS NO THIRD ARG');
        arguments.add('THIS IS A STRING BUT THERE IS NO THIRD ARG');
        for (String f: funcsStringIntegerInteger) {
            testBadArgs(f, 'arg count', arguments);
        }

        arguments = new List<Object>();
        arguments.add(testLongString);
        arguments.add(testInteger);
        arguments.add(testNotAnInteger);
        for (String f: funcsStringIntegerInteger) {
            testBadArgs(f, 'third arg int', arguments);
        }

        arguments = new List<Object>();
        arguments.add(testLongString);
        arguments.add(testNotAnInteger);
        arguments.add(testInteger);
        for (String f: funcsStringIntegerInteger) {
            testBadArgs(f, 'second arg int', arguments);
        }

    }

    /**
     *  Test the abbreviate method
     */
    static testMethod void testAbbreviate() {
        String methodName = 'abbreviate';
        List<Object> arguments;
        String testString;

        // Test: Correct functioning where string is short enough
        testString = 'this is a short string';
        arguments = new List<Object>();
        arguments.add(testString);
        arguments.add('30');
        testCorrectResults(methodName, 'valid results', arguments, testString.abbreviate(30));

        // Test: Correct functioning where string is too long
        testString = 'this is a very very very very long string';
        arguments = new List<Object>();
        arguments.add(testString);
        arguments.add('10');
        testCorrectResults(methodName, 'valid results', arguments, testString.abbreviate(10));
    }

    /**
     *  Test the capitalize method
     */
    static testMethod void testCapitalize() {
        String methodName = 'capitalize';
        List<Object> arguments;
        String testString;

        // Test: Simple ASCII
        testString = testGerman;
        arguments = new List<Object>();
        arguments.add(testString);
        testCorrectResults(methodName, 'ascii caps', arguments, testString.capitalize());

        // Test: More esoteric
        testString = 'Deutsch: über, Straße';   // ß is, in upper case, SS
        arguments = new List<Object>();
        arguments.add(testString);
        testCorrectResults(methodName, 'german caps', arguments, testString.capitalize());
    }

    /**
     *  Test the compareTo method
     */
    static testMethod void testCompareTo() {
        String methodName = 'compareTo';
        List<Object> arguments;
        String testString1;
        String testString2;

        testString1 = 'This is a simple string';

        // Test when they are the same
        testString2 = testString1;
        arguments = new List<Object>();
        arguments.add(testString1);
        arguments.add(testString2);
        testCorrectResults(methodName, 'strings are equal', arguments, testString1.compareTo(testString2));

        // Test when they are not the same
        testString2 = 'This is a different string';
        arguments = new List<Object>();
        arguments.add(testString1);
        arguments.add(testString2);
        testCorrectResults(methodName, 'strings are not equal', arguments, testString1.compareTo(testString2));
    }

    /**
     *  Test the contains method
     */
    static testMethod void testContains() {
        String methodName = 'contains';
        List<Object> arguments;
        String testString1;
        String testString2;

        testString1 = 'This is a simple string';

        // Test when string 2 is in string 1
        testString2 = 'simple';
        arguments = new List<Object>();
        arguments.add(testString1);
        arguments.add(testString2);
        testCorrectResults(methodName, 'string 1 contains string 2', arguments, testString1.contains(testString2));

        // Test when string 2 is NOT in string 1
        testString2 = 'complex';
        arguments = new List<Object>();
        arguments.add(testString1);
        arguments.add(testString2);
        testCorrectResults(methodName, 'string 1 does not contain string 2', arguments, testString1.contains(testString2));
    }

    /**
     *  Test the deleteWhitespace method
     */
    static testMethod void testDeleteWhitespace() {
        String methodName = 'deleteWhitespace';
        List<Object> arguments;
        String testString;

        // Test: Simple ASCII
        testString = 'This is a simple string';
        arguments = new List<Object>();
        arguments.add(testString);
        testCorrectResults(methodName, 'whitspace', arguments, testString.deleteWhitespace());
    }

    /**
     *  Test the endsWith method
     */
    static testMethod void testEndsWith() {
        String methodName = 'endsWith';
        List<Object> arguments;
        String [] testString1 = new String [] { testLongString, testLongString, testLongString};
        String [] testString2  = new String [] { testLongEnd, testLongEndCase, testBadSubString};

        for (Integer i=0;i<testString1.size();i++) {
            arguments = new List<Object>();
            arguments.add(testString1[i]);
            arguments.add(testString2[i]);
            testCorrectResults(methodName, 'string 1 ends with string 2', arguments, testString1[i].endsWith(testString2[i]));

        }
    }

    /**
     *  Test the endsWithIgnoreCase method
     */
    static testMethod void testEndsWithIgnoreCase() {
        String methodName = 'endsWithIgnoreCase';
        List<Object> arguments;
        String [] testString1 = new String [] { testLongString, testLongString, testLongString};
        String [] testString2  = new String [] { testLongEnd, testLongEndCase, testBadSubString};

        for (Integer i=0;i<testString1.size();i++) {
            arguments = new List<Object>();
            arguments.add(testString1[i]);
            arguments.add(testString2[i]);
            testCorrectResults(methodName, 'string 1 ends with string 2', arguments, testString1[i].endsWithIgnoreCase(testString2[i]));

        }
    }

    /**
     *  Test the equals method
     */
    static testMethod void testEquals() {
        String methodName = 'equals';
        List<Object> arguments;
        String testString1;
        String testString2;

        testString1 = 'This is a simple string';

        // Test when string 1 = string 2
        testString2 = testString1;
        arguments = new List<Object>();
        arguments.add(testString1);
        arguments.add(testString2);
        testCorrectResults(methodName, 'string 1 == string 2', arguments, testString1.equals(testString2));

        // Test when string 1 != string 2
        testString2 = 'stringzzz';
        arguments = new List<Object>();
        arguments.add(testString1);
        arguments.add(testString2);
        testCorrectResults(methodName, 'string 1 != string 2', arguments, testString1.equals(testString2));
    }

    /**
     *  Test the equalsIgnoreCase method
     */
    static testMethod void testequalsIgnoreCase() {
        String methodName = 'equalsIgnoreCase';
        List<Object> arguments;
        String testString1;
        String testString2;

        testString1 = 'this is a simple string üé';

        // Test when string 1 = string 2
        testString2 = 'this IS a SIMPLE string ÜÉ';
        arguments = new List<Object>();
        arguments.add(testString1);
        arguments.add(testString2);
        testCorrectResults(methodName, 'string 1 == string 2', arguments, testString1.equalsIgnoreCase(testString2));

        // Test when string 1 != string 2
        testString2 = 'this is a simple string ueß';
        arguments = new List<Object>();
        arguments.add(testString1);
        arguments.add(testString2);
        testCorrectResults(methodName, 'string 1 != string 2', arguments, testString1.equalsIgnoreCase(testString2));
    }

    /**
     *  Test the escapeEcmaScript method
     */
    static testMethod void testEscapeEcmaScript() {
        String methodName = 'escapeEcmaScript';
        List<Object> arguments;
        String testString;

        // Test: A very simple string
        testString = 'This is a & <simple> string';
        arguments = new List<Object>();
        arguments.add(testString);
        testCorrectResults(methodName, 'simple string', arguments, testString.escapeEcmaScript());

        // Test: More esoteric
        testString = 'https://ins-tso--vlocityinsdemo.na55.visual.force.com/apex/vlocityinsdemo__OmniScriptUniversalPage?id={0}&OmniScriptType=Small%20Group&OmniScriptSubType=MinInfo&OmniScriptLang=English&PrefillDataRaptorBundle=&scriptMode=vertical&ContextId={0}';
        arguments = new List<Object>();
        arguments.add(testString);
        testCorrectResults(methodName, 'complicated string', arguments, testString.escapeEcmaScript());
    }

    /**
     *  Test the escapeHtml4 method
     */
    static testMethod void testEscapeHtml4() {
        String methodName = 'escapeHtml4';
        List<Object> arguments;
        String testString;

        // Test: A very simple string
        testString = 'This is a & <simple> string';
        arguments = new List<Object>();
        arguments.add(testString);
        testCorrectResults(methodName, 'simple string', arguments, testString.escapeHtml4());

        // Test: More esoteric
        testString = 'https://ins-tso--vlocityinsdemo.na55.visual.force.com/apex/vlocityinsdemo__OmniScriptUniversalPage?id={0}&OmniScriptType=Small%20Group&OmniScriptSubType=MinInfo&OmniScriptLang=English&PrefillDataRaptorBundle=&scriptMode=vertical&ContextId={0}';
        arguments = new List<Object>();
        arguments.add(testString);
        testCorrectResults(methodName, 'complicated string', arguments, testString.escapeHtml4());
    }

    /**
     *  Test the escapeSingleQuotes method
     */
    static testMethod void testEscapeSingleQuotes() {
        String methodName = 'escapeSingleQuotes';
        List<Object> arguments;
        String testString;

        // Test: A very simple string
        testString = 'This is a \'simple\' string';
        arguments = new List<Object>();
        arguments.add(testString);
        testCorrectResults(methodName, 'simple string', arguments, String.escapeSingleQuotes(testString));

        // Test: More esoteric
        testString = 'This is a "less" \'simple\' string with backslash \\ and single quotes \\\'';
        arguments = new List<Object>();
        arguments.add(testString);
        testCorrectResults(methodName, 'complicated string', arguments, String.escapeSingleQuotes(testString));
    }

    /**
     *  Test the escapeUnicode method
     */
    static testMethod void testEscapeUnicode() {
        String methodName = 'escapeUnicode';
        List<Object> arguments;
        String testString;

        testString = testGerman;
        arguments = new List<Object>();
        arguments.add(testString);
        testCorrectResults(methodName, 'german letters', arguments, testString.escapeUnicode());
    }

    /**
     *  Test the escapeXml method
     */
    static testMethod void testEscapeXml() {
        String methodName = 'escapeXml';
        List<Object> arguments;
        String testString;

        // Test: A very simple string
        testString = 'This is a & <simple> string';
        arguments = new List<Object>();
        arguments.add(testString);
        testCorrectResults(methodName, 'simple string', arguments, testString.escapeXml());

        // Test: More esoteric
        testString = 'https://ins-tso--vlocityinsdemo.na55.visual.force.com/apex/vlocityinsdemo__OmniScriptUniversalPage?id={0}&OmniScriptType=Small%20Group&OmniScriptSubType=MinInfo&OmniScriptLang=English&PrefillDataRaptorBundle=&scriptMode=vertical&ContextId={0}';
        arguments = new List<Object>();
        arguments.add(testString);
        testCorrectResults(methodName, 'complicate string', arguments, testString.escapeXml());
    }

    /**
     *  Test the indexOf method with two strings
     */
    static testMethod void testIndexOfSS() {
        String methodName = 'indexOf';
        List<Object> arguments;
        String testString1;
        String testString2;

        testString1 = 'This is a simple string';

        // Test when string 1 contains string 2
        testString2 = 'simple';
        arguments = new List<Object>();
        arguments.add(testString1);
        arguments.add(testString2);
        testCorrectResults(methodName, 'string 1 contains string 2', arguments, testString1.indexOf(testString2));

        // Test when string 1 does not contain string 2
        testString2 = 'stringzzz';
        arguments = new List<Object>();
        arguments.add(testString1);
        arguments.add(testString2);
        testCorrectResults(methodName, 'string 1 does not contain string 2', arguments, testString1.indexOf(testString2));
    }

    /**
     *  Test the indexOf method with two strings and an index
     */
    static testMethod void testIndexOfSSI() {
        String methodName = 'indexOf';
        List<Object> arguments;
        String testString1;
        String testString2;

        //             0123456789012345678901234567890123456789012
        testString1 = 'This is a simple string, very simple indeed';

        // Test when string 1 contains string 2 twice, find the first
        testString2 = 'simple';
        arguments = new List<Object>();
        arguments.add(testString1);
        arguments.add(testString2);
        arguments.add(5);
        testCorrectResults(methodName, 'find first string 2 in string 1', arguments, testString1.indexOf(testString2, 5));

        // Test when string 1 contains string 2 twice, find the second
        testString2 = 'simple';
        arguments = new List<Object>();
        arguments.add(testString1);
        arguments.add(testString2);
        arguments.add(25);
        testCorrectResults(methodName, 'find second string 2 in string 1', arguments, testString1.indexOf(testString2, 25));
    }

    /**
     *  Test the isBlank method with two strings and an index
     */
    static testMethod void testIsBlank() {
        String methodName = 'isBlank';
        List<Object> arguments;
        String testString1 = '';
        String testString2 = 'Not Blank';

        arguments = new List<Object>();
        arguments.add(testString1);
        testCorrectResults(methodName, 'blank string', arguments, String.isBlank(testString1));
        arguments = new List<Object>();
        arguments.add(testString2);
        testCorrectResults(methodName, 'not blank string', arguments, String.isBlank(testString2));
    }

    /**
     *  Test the isBlank method with two strings and an index
     */
    static testMethod void testIsNumeric() {
        String methodName = 'isNumeric';
        List<Object> arguments;
        String testString1 = '0123434';
        String testString2 = 'Not Numeric';

        arguments = new List<Object>();
        arguments.add(testString1);
        testCorrectResults(methodName, 'numeric string', arguments, testString1.isNumeric());
        arguments = new List<Object>();
        arguments.add(testString2);
        testCorrectResults(methodName, 'not numeric string', arguments, testString2.isNumeric());
    }

    /**
     *  Test the lastIndexOf method with two strings
     */
    static testMethod void testLastIndexOfSS() {
        String methodName = 'lastIndexOf';
        List<Object> arguments;
        String testString1;
        String testString2;

        testString1 = 'This is a simple string';

        // Test when string 1 contains string 2
        testString2 = 'simple';
        arguments = new List<Object>();
        arguments.add(testString1);
        arguments.add(testString2);
        testCorrectResults(methodName, 'string 1 contains string 2', arguments, testString1.lastIndexOf(testString2));

        // Test when string 1 does not contain string 2
        testString2 = 'stringzzz';
        arguments = new List<Object>();
        arguments.add(testString1);
        arguments.add(testString2);
        testCorrectResults(methodName, 'string 1 does not contain string 2', arguments, testString1.lastIndexOf(testString2));
    }

    /**
     *  Test the indexOf method with two strings and an index
     */
    static testMethod void testLastIndexOfSSI() {
        String methodName = 'lastIndexOf';
        List<Object> arguments;
        String testString1;
        String testString2;

        //             0123456789012345678901234567890123456789012
        testString1 = 'This is a simple string, very simple indeed';

        // Test when string 1 contains string 2 twice, find the last
        testString2 = 'simple';
        arguments = new List<Object>();
        arguments.add(testString1);
        arguments.add(testString2);
        arguments.add(5);
        testCorrectResults(methodName, 'find first string 2 in string 1', arguments, testString1.lastIndexOf(testString2, 5));

        // Test when string 1 contains string 2 twice, find the last
        testString2 = 'simple';
        arguments = new List<Object>();
        arguments.add(testString1);
        arguments.add(testString2);
        arguments.add(25);
        testCorrectResults(methodName, 'find second string 2 in string 1', arguments, testString1.lastIndexOf(testString2, 25));
    }

    /**
     *  Test the left method
     */
    static testMethod void testLeft() {
        String methodName = 'left';
        List<Object> arguments;
        String testString;

        // Test: Correct functioning where string is short enough
        testString = testShortString6;
        arguments = new List<Object>();
        arguments.add(testString);
        arguments.add('30');
        testCorrectResults(methodName, 'valid results', arguments, testString.left(30));

        // Test: Correct functioning where string is too long
        testString = testLongString;
        arguments = new List<Object>();
        arguments.add(testString);
        arguments.add('10');
        testCorrectResults(methodName, 'valid results', arguments, testString.left(10));
    }

    /**
     *  Test the leftPad method
     */
    static testMethod void testLeftPad() {
        String methodName = 'leftPad';
        List<Object> arguments;
        String testString;

        // Test: Correct functioning where string is short enough
        testString = testShortString6;
        arguments = new List<Object>();
        arguments.add(testString);
        arguments.add('30');
        testCorrectResults(methodName, 'valid results', arguments, testString.leftPad(30));

        // Test: Correct functioning where string is too long
        testString = testLongString;
        arguments = new List<Object>();
        arguments.add(testString);
        arguments.add('10');
        testCorrectResults(methodName, 'valid results', arguments, testString.leftPad(10));
    }

    /**
     *  Test the length method
     */
    static testMethod void testLength() {
        String methodName = 'length';
        List<Object> arguments;
        String testString;

        // Test: Correct functioning where string is short
        testString = testShortString6;
        arguments = new List<Object>();
        arguments.add(testString);
        testCorrectResults(methodName, 'valid results', arguments, testString.length());

        // Test: Correct functioning where string is long
        testString = testLongString;
        arguments = new List<Object>();
        arguments.add(testString);
        testCorrectResults(methodName, 'valid results', arguments, testString.length());
    }

    /**
     *  Test the mid method
     */
    static testMethod void testMid() {
        String methodName = 'mid';
        List<Object> arguments;
        String testString;

        // Test: Correct functioning where string is short
        testString = testShortString6;
        arguments = new List<Object>();
        arguments.add(testString);
        arguments.add(1);
        arguments.add(2);
        testCorrectResults(methodName, 'valid results', arguments, testString.mid(1,2));

        // Test: Correct functioning where string is long
        testString = testLongString;
        arguments = new List<Object>();
        arguments.add(testString);
        arguments.add(10);
        arguments.add(20);
        testCorrectResults(methodName, 'valid results', arguments, testString.mid(10,20));
    }

    /**
     *  Test the normalizeSpace method
     */
    static testMethod void testNormalizeSpace() {
        String methodName = 'normalizeSpace';
        List<Object> arguments;
        String testString;

        // Test: Correct functioning where string is short
        testString = 'String  extra \t space';
        arguments = new List<Object>();
        arguments.add(testString);
        testCorrectResults(methodName, 'valid results', arguments, testString.normalizeSpace());

        // Test: Correct functioning where string is long
        testString = '           String  extra \t space           and   some   more stuff\there\t\tand\t\t\tthere';
        arguments = new List<Object>();
        arguments.add(testString);
        testCorrectResults(methodName, 'valid results', arguments, testString.normalizeSpace());
    }

    /**
     *  Test the remove method
     */
    static testMethod void testRemove() {
        String methodName = 'remove';
        List<Object> arguments;
        String testString;

        // Test: Correct functioning where string is short
        arguments = new List<Object>();
        arguments.add(testShortString6);
        arguments.add(testShortSubString);
        testCorrectResults(methodName, 'valid results', arguments, testShortString6.remove(testShortSubString));

        // Test: Correct functioning where string is long
        arguments = new List<Object>();
        arguments.add(testLongString);
        arguments.add(testLongSubString);
        testCorrectResults(methodName, 'valid results', arguments, testLongString.remove(testLongSubString));
    }


    /**
     *  Test the removeEnd method
     */
    static testMethod void testRemoveEnd() {
        String methodName = 'removeEnd';
        List<Object> arguments;
        String testString;

        // Test: Correct functioning where string is short
        arguments = new List<Object>();
        arguments.add(testShortString6);
        arguments.add(testShortSubString);
        testCorrectResults(methodName, 'valid results', arguments, testShortString6.removeEnd(testShortSubString));

        arguments = new List<Object>();
        arguments.add(testShortString6);
        arguments.add(testShortEnd);
        testCorrectResults(methodName, 'valid results', arguments, testShortString6.removeEnd(testShortEnd));

        // Test: Correct functioning where string is long
        arguments = new List<Object>();
        arguments.add(testLongString);
        arguments.add(testLongSubString);
        testCorrectResults(methodName, 'valid results', arguments, testLongString.removeEnd(testLongSubString));

        arguments = new List<Object>();
        arguments.add(testLongString);
        arguments.add(testLongEnd);
        testCorrectResults(methodName, 'valid results', arguments, testLongString.removeEnd(testLongEnd));

    }

    /**
     *  Test the removeEndIgnoreCase method
     */
    static testMethod void testRemoveEndIgnoreCase() {
        String methodName = 'removeEndIgnoreCase';
        List<Object> arguments;
        String testString;

        // Test: Correct functioning where string is short
        arguments = new List<Object>();
        arguments.add(testShortString6);
        arguments.add(testShortSubString);
        testCorrectResults(methodName, 'valid results', arguments, testShortString6.removeEndIgnoreCase(testShortSubString));

        arguments = new List<Object>();
        arguments.add(testShortString6);
        arguments.add(testShortEnd);
        testCorrectResults(methodName, 'valid results', arguments, testShortString6.removeEndIgnoreCase(testShortEnd));

        arguments = new List<Object>();
        arguments.add(testShortString6);
        arguments.add(testShortEndCase);
        testCorrectResults(methodName, 'valid results', arguments, testShortString6.removeEndIgnoreCase(testShortEndCase));

        // Test: Correct functioning where string is long
        arguments = new List<Object>();
        arguments.add(testLongString);
        arguments.add(testLongSubString);
        testCorrectResults(methodName, 'valid results', arguments, testLongString.removeEndIgnoreCase(testLongSubString));

        arguments = new List<Object>();
        arguments.add(testLongString);
        arguments.add(testLongEnd);
        testCorrectResults(methodName, 'valid results', arguments, testLongString.removeEndIgnoreCase(testLongEnd));

        arguments = new List<Object>();
        arguments.add(testLongString);
        arguments.add(testLongEndCase);
        testCorrectResults(methodName, 'valid results', arguments, testLongString.removeEndIgnoreCase(testLongEndCase));
    }

    /**
     *  Test the removeEnd method
     */
    static testMethod void testRemoveStart() {
        String methodName = 'removeStart';
        List<Object> arguments;
        String testString;

        // Test: Correct functioning where string is short
        arguments = new List<Object>();
        arguments.add(testShortString6);
        arguments.add(testShortSubString);
        testCorrectResults(methodName, 'valid results', arguments, testShortString6.removeStart(testShortSubString));

        arguments = new List<Object>();
        arguments.add(testShortString6);
        arguments.add(testShortStart);
        testCorrectResults(methodName, 'valid results', arguments, testShortString6.removeStart(testShortStart));

        // Test: Correct functioning where string is long
        arguments = new List<Object>();
        arguments.add(testLongString);
        arguments.add(testLongSubString);
        testCorrectResults(methodName, 'valid results', arguments, testLongString.removeStart(testLongSubString));

        arguments = new List<Object>();
        arguments.add(testLongString);
        arguments.add(testLongStart);
        testCorrectResults(methodName, 'valid results', arguments, testLongString.removeStart(testLongStart));

    }

    /**
     *  Test the removeStartIgnoreCase method
     */
    static testMethod void testRemoveStartIgnoreCase() {
        String methodName = 'removeStartIgnoreCase';
        List<Object> arguments;
        String testString;

        // Test: Correct functioning where string is short
        arguments = new List<Object>();
        arguments.add(testShortString6);
        arguments.add(testShortSubString);
        testCorrectResults(methodName, 'valid results', arguments, testShortString6.removeStartIgnoreCase(testShortSubString));

        arguments = new List<Object>();
        arguments.add(testShortString6);
        arguments.add(testShortStart);
        testCorrectResults(methodName, 'valid results', arguments, testShortString6.removeStartIgnoreCase(testShortStart));

        arguments = new List<Object>();
        arguments.add(testShortString6);
        arguments.add(testShortStartCase);
        testCorrectResults(methodName, 'valid results', arguments, testShortString6.removeStartIgnoreCase(testShortStartCase));

        // Test: Correct functioning where string is long
        arguments = new List<Object>();
        arguments.add(testLongString);
        arguments.add(testLongSubString);
        testCorrectResults(methodName, 'valid results', arguments, testLongString.removeStartIgnoreCase(testLongSubString));

        arguments = new List<Object>();
        arguments.add(testLongString);
        arguments.add(testLongStart);
        testCorrectResults(methodName, 'valid results', arguments, testLongString.removeStartIgnoreCase(testLongStart));

        arguments = new List<Object>();
        arguments.add(testLongString);
        arguments.add(testLongStartCase);
        testCorrectResults(methodName, 'valid results', arguments, testLongString.removeStartIgnoreCase(testLongStartCase));
    }

    /**
     *  Test the replace method
     */
    static testMethod void testReplace() {
        String methodName = 'replace';
        List<Object> arguments;
        String [] testStrings = new String []{
                testLongString, testLongString, testShortString6, testShortString6
        };
        String [] targetStrings = new String []{
                testLongSubString, testLongEnd, testShortSubString, testShortStart
        };
        String [] replacementStrings = new String []{
                'zz1zz', 'zz2zz', 'zz3zz', 'zz4zz'
        };

        for (Integer i = 0; i < testStrings.size(); i++) {
            arguments = new List<Object>();
            arguments.add(testStrings[i]);
            arguments.add(targetStrings[i]);
            arguments.add(replacementStrings[i]);

            testCorrectResults(methodName, 'valid results', arguments, testStrings[i].replace(targetStrings[i], replacementStrings[i]));
        }
    }

    /**
     *  Test the replaceAll method
     */
    static testMethod void testReplaceAll() {
        String methodName = 'replaceAll';
        List<Object> arguments;
        String [] testStrings = new String []{
                testLongString, testLongString, testLongString, testShortString6, testShortString6
        };
        String [] targetStrings = new String []{
                testLongRegexRepeat, testLongRegexString, testBadRegexString, testShortSubString, testShortRegexString
        };
        String [] replacementStrings = new String []{
                'zz1zz', 'zz2zz', 'zz3zz', 'zz4zz', 'zz5zz'
        };

        for (Integer i = 0; i < testStrings.size(); i++) {
            arguments = new List<Object>();
            arguments.add(testStrings[i]);
            arguments.add(targetStrings[i]);
            arguments.add(replacementStrings[i]);

            testCorrectResults(methodName, 'valid results', arguments, testStrings[i].replaceAll(targetStrings[i], replacementStrings[i]));
        }
    }

    /**
     *  Test the replaceFirst method
     */
    static testMethod void testReplaceFirst() {
        String methodName = 'replaceFirst';
        List<Object> arguments;
        String [] testStrings = new String []{
                testLongString, testLongString, testLongString, testShortString6, testShortString6
        };
        String [] targetStrings = new String []{
                testLongRegexRepeat, testLongRegexString, testBadRegexString, testShortSubString, testShortRegexString
        };
        String [] replacementStrings = new String []{
                'zz1zz', 'zz2zz', 'zz3zz', 'zz4zz', 'zz5zz'
        };

        for (Integer i = 0; i < testStrings.size(); i++) {
            arguments = new List<Object>();
            arguments.add(testStrings[i]);
            arguments.add(targetStrings[i]);
            arguments.add(replacementStrings[i]);

            testCorrectResults(methodName, 'valid results', arguments, testStrings[i].replaceFirst(targetStrings[i], replacementStrings[i]));
        }
    }

    /**
     *  Test the reverse method
     */
    static testMethod void testReverse() {
        String methodName = 'reverse';
        List<Object> arguments;
        String [] testStrings = new String []{
                testLongString, testShortString6
        };

        for (Integer i = 0; i < testStrings.size(); i++) {
            arguments = new List<Object>();
            arguments.add(testStrings[i]);

            testCorrectResults(methodName, 'valid results', arguments, testStrings[i].reverse());
        }
    }

    /**
     *  Test the right method
     */
    static testMethod void testRight() {
        String methodName = 'right';
        List<Object> arguments;
        String [] testStrings = new String []{
                testLongString, testShortString6
        };
        Integer [] testLens = new Integer [] { 0, 2, 4, 10, 50, 100};

        for (Integer i = 0; i < testStrings.size(); i++) {
            for (Integer j = 0; j < testLens.size(); j++) {
                arguments = new List<Object>();
                arguments.add(testStrings[i]);
                arguments.add(testLens[j]);
                testCorrectResults(methodName, 'valid results', arguments, testStrings[i].right(testLens[j]));
            }
        }
    }

    /**
     *  Test the rightPad method
     */
    static testMethod void testRightPad() {
        String methodName = 'rightPad';
        List<Object> arguments;
        String [] testStrings = new String []{
                testLongString, testShortString6
        };
        Integer [] testLens = new Integer [] { 0, 2, 4, 10, 50, 100};

        for (Integer i = 0; i < testStrings.size(); i++) {
            for (Integer j = 0; j < testLens.size(); j++) {
                arguments = new List<Object>();
                arguments.add(testStrings[i]);
                arguments.add(testLens[j]);
                testCorrectResults(methodName, 'valid results', arguments, testStrings[i].rightPad(testLens[j]));
            }
        }
    }

    /**
     *  Test the startsWith method
     */
    static testMethod void testStartsWith() {
        String methodName = 'startsWith';
        List<Object> arguments;
        String [] testString1 = new String [] { testLongString, testLongString, testLongString};
        String [] testString2  = new String [] { testLongStart, testLongStartCase, testBadSubString};

        for (Integer i=0;i<testString1.size();i++) {
            arguments = new List<Object>();
            arguments.add(testString1[i]);
            arguments.add(testString2[i]);
            testCorrectResults(methodName, 'string 1 ends with string 2', arguments, testString1[i].startsWith(testString2[i]));

        }
    }

    /**
     *  Test the startsWithIgnoreCase method
     */
    static testMethod void testStartsWithIgnoreCase() {
        String methodName = 'startsWithIgnoreCase';
        List<Object> arguments;
        String [] testString1 = new String [] { testLongString, testLongString, testLongString};
        String [] testString2  = new String [] { testLongStart, testLongStartCase, testBadSubString};

        for (Integer i=0;i<testString1.size();i++) {
            arguments = new List<Object>();
            arguments.add(testString1[i]);
            arguments.add(testString2[i]);
            testCorrectResults(methodName, 'string 1 ends with string 2', arguments, testString1[i].startsWithIgnoreCase(testString2[i]));

        }
    }

    /**
     *  Test the testStripHtmlTags method
     */
    static testMethod void testStripHtmlTags() {
        String methodName = 'stripHtmlTags';
        List<Object> arguments;
        String [] testString1 = new String [] {
                '<b>hello world</b>',
                '<html><head><title>Test 2</title></head><body><p>This is the body</p></body></html>',
                '<open><but></no></close>'
        };

        for (Integer i=0;i<testString1.size();i++) {
            arguments = new List<Object>();
            arguments.add(testString1[i]);
            testCorrectResults(methodName, 'string 1 ends with string 2', arguments, testString1[i].stripHtmlTags());

        }
    }


    /**
     *  Test the substring method
     */
    static testMethod void testSubstring() {
        String methodName = 'substring';
        List<Object> arguments;
        String [] testString1   = new String [] { testLongString, testShortString6 };
        Integer [] testStart    = new Integer [] {  0,  5, 10, 20, 50,  0, 5, 10, 20, 50};
        Integer [] testEnd      = new Integer [] { -1, -1, -1, -1, -1, 10, 4, 99, 22, 55};

        for (Integer i=0;i<testString1.size();i++) {
            for (Integer j=0;j<testStart.size();j++) {
                arguments = new List<Object>();
                arguments.add(testString1[i]);
                arguments.add(testStart[j]);
                if (testEnd[j] != -1) {
                    arguments.add(testEnd[j]);
                }

                try {
                    if (testEnd[j] != -1) {
                        testCorrectResults(methodName, 'valid results', arguments, testString1[i].substring(testStart[j], testEnd[j]));
                    } else {
                        testCorrectResults(methodName, 'valid results', arguments, testString1[i].substring(testStart[j]));
                    }
                } catch (StringException s) {
                    // If we throw a string exception, then it's an invalid set of arguments and we won't test.
                    continue;
                }
            }
        }
    }

    /**
     *  Test the substringAfter method
     */
    static testMethod void testSubstringAfter() {
        String methodName = 'substringAfter';
        List<Object> arguments;
        String [] testString1 = new String [] { testLongString, testLongString, testLongString};
        String [] testString2  = new String [] { testLongStart, testLongMiddle, testBadSubString};

        for (Integer i=0;i<testString1.size();i++) {
            arguments = new List<Object>();
            arguments.add(testString1[i]);
            arguments.add(testString2[i]);
            testCorrectResults(methodName, 'string 1 ends with string 2', arguments, testString1[i].substringAfter(testString2[i]));

        }
    }

    /**
     *  Test the substringAfterLast method
     */
    static testMethod void testSubstringAfterLast() {
        String methodName = 'substringAfterLast';
        List<Object> arguments;
        String [] testString1 = new String [] { testLongString, testLongString, testLongString};
        String [] testString2  = new String [] { testLongStart, testLongMiddle, testBadSubString};

        for (Integer i=0;i<testString1.size();i++) {
            arguments = new List<Object>();
            arguments.add(testString1[i]);
            arguments.add(testString2[i]);
            testCorrectResults(methodName, 'string 1 ends with string 2', arguments, testString1[i].substringAfterLast(testString2[i]));

        }
    }

    /**
     *  Test the substringBefore method
     */
    static testMethod void testSubstringBefore() {
        String methodName = 'substringBefore';
        List<Object> arguments;
        String [] testString1 = new String [] { testLongString, testLongString, testLongString};
        String [] testString2  = new String [] { testLongStart, testLongMiddle, testBadSubString};

        for (Integer i=0;i<testString1.size();i++) {
            arguments = new List<Object>();
            arguments.add(testString1[i]);
            arguments.add(testString2[i]);
            testCorrectResults(methodName, 'string 1 ends with string 2', arguments, testString1[i].substringBefore(testString2[i]));

        }
    }

    /**
     *  Test the substringBeforeLast method
     */
    static testMethod void testSubstringBeforeLast() {
        String methodName = 'substringBeforeLast';
        List<Object> arguments;
        String [] testString1 = new String [] { testLongString, testLongString, testLongString};
        String [] testString2  = new String [] { testLongStart, testLongMiddle, testBadSubString};

        for (Integer i=0;i<testString1.size();i++) {
            arguments = new List<Object>();
            arguments.add(testString1[i]);
            arguments.add(testString2[i]);
            testCorrectResults(methodName, 'valid results', arguments, testString1[i].substringBeforeLast(testString2[i]));

        }
    }

    /**
     *  Test the substringBetween method
     */
    static testMethod void testSubstringBetween() {
        String methodName = 'substringBetween';
        List<Object> arguments;
        String [] testString1 = new String [] { testLongString, testLongString, testLongString};
        String [] testString2  = new String [] { testLongStart, testLongMiddle, testBadSubString};

        for (Integer i=0;i<testString1.size();i++) {
            arguments = new List<Object>();
            arguments.add(testString1[i]);
            arguments.add(testString2[i]);
            testCorrectResults(methodName, 'valid results', arguments, testString1[i].substringBetween(testString2[i]));

        }
    }

    /**
     *  Test the substringBetween method
     */
    static testMethod void testSubstringBetween2() {
        String methodName = 'substringBetween';
        List<Object> arguments;
        String [] testStrings = new String []{
                testLongString, testLongString, testLongString, testLongString
        };
        String [] openStrings = new String []{
                testLongStart, testLongStart, testLongMiddle, testLongEnd
        };
        String [] closeStrings = new String []{
                testLongEnd, testLongMiddle, testLongEnd, testLongStart
        };

        for (Integer i = 0; i < testStrings.size(); i++) {
            arguments = new List<Object>();
            arguments.add(testStrings[i]);
            arguments.add(openStrings[i]);
            arguments.add(closeStrings[i]);

            testCorrectResults(methodName, 'valid results', arguments, testStrings[i].substringBetween(openStrings[i], closeStrings[i]));
        }
    }

    /**
     *  Test the swapCase method
     */
    static testMethod void testSwapCase() {
        String methodName = 'swapCase';
        List<Object> arguments;
        String [] testString1 = new String [] {
                testLongString, testGerman, testShortString6
        };

        for (Integer i=0;i<testString1.size();i++) {
            arguments = new List<Object>();
            arguments.add(testString1[i]);
            testCorrectResults(methodName, 'valid result', arguments, testString1[i].swapCase());

        }
    }

    /**
     *  Test the toLowerCase method
     */
    static testMethod void testToLowerCase() {
        String methodName = 'toLowerCase';
        List<Object> arguments;
        String [] testString1 = new String [] {
                testLongString, testGerman, testShortString6
        };

        for (Integer i=0;i<testString1.size();i++) {
            arguments = new List<Object>();
            arguments.add(testString1[i]);
            testCorrectResults(methodName, 'valid result', arguments, testString1[i].toLowerCase());

        }
    }

    /**
     *  Test the toLowerCase(locale) method
     */
    static testMethod void testToLowerCaseLocale() {
        String methodName = 'toLowerCase';
        List<Object> arguments;
        String [] testString1 = new String [] {
                testLongString, testGerman, testShortString6
        };

        for (Integer i=0;i<testString1.size();i++) {
            arguments = new List<Object>();
            arguments.add(testString1[i]);
            testCorrectResults(methodName, 'valid result', arguments, testString1[i].toLowerCase('en_US'));
            testCorrectResults(methodName, 'valid result', arguments, testString1[i].toLowerCase('de_DE'));

        }
    }

    /**
     *  Test the toUpperCase method
     */
    static testMethod void testToUpperCase() {
        String methodName = 'toUpperCase';
        List<Object> arguments;
        String [] testString1 = new String [] {
                testLongString, testGerman, testShortString6
        };

        for (Integer i=0;i<testString1.size();i++) {
            arguments = new List<Object>();
            arguments.add(testString1[i]);
            testCorrectResults(methodName, 'valid result', arguments, testString1[i].toUpperCase());

        }
    }

    /**
     *  Test the toUpperCase(locale) method
     */
    static testMethod void testToUpperCaseLocale() {
        String methodName = 'toUpperCase';
        List<Object> arguments;
        String [] testString1 = new String [] {
                testLongString, testGerman, testShortString6
        };

        for (Integer i=0;i<testString1.size();i++) {
            arguments = new List<Object>();
            arguments.add(testString1[i]);
            testCorrectResults(methodName, 'valid result', arguments, testString1[i].toUpperCase('en_US'));
            testCorrectResults(methodName, 'valid result', arguments, testString1[i].toUpperCase('de_DE'));

        }
    }


    /**
     *  Test the trim method
     */
    static testMethod void testTrim() {
        String methodName = 'trim';
        List<Object> arguments;
        String [] testString1 = new String [] {
                testLongString, testGerman, testShortString6, testTrimString
        };

        for (Integer i=0;i<testString1.size();i++) {
            arguments = new List<Object>();
            arguments.add(testString1[i]);
            testCorrectResults(methodName, 'valid result', arguments, testString1[i].trim());

        }
    }

    /**
     *  Test the uncapitalize method
     */
    static testMethod void testUncapitalize() {
        String methodName = 'uncapitalize';
        List<Object> arguments;
        String [] testString1 = new String [] {
                testLongString, testGerman, testShortString6, testTrimString
        };

        for (Integer i=0;i<testString1.size();i++) {
            arguments = new List<Object>();
            arguments.add(testString1[i]);
            testCorrectResults(methodName, 'valid result', arguments, testString1[i].uncapitalize());

        }
    }

    /**
     *  Test the unescapeEcmaScript method
     */
    static testMethod void testUnescapeEcmaScript() {
        String methodName = 'unescapeEcmaScript';
        List<Object> arguments;
        String [] testString1 = new String [] {};
        String t;

        t = 'stuff \\ to \' escape & <html> things \n too';
        testString1.add(t.escapeEcmaScript());
        testString1.add(testLongString.escapeEcmaScript());

        for (Integer i=0;i<testString1.size();i++) {
            arguments = new List<Object>();
            arguments.add(testString1[i]);
            testCorrectResults(methodName, 'valid result', arguments, testString1[i].unescapeEcmaScript());

        }
    }

    /**
     *  Test the unescapeHtml4 method
     */
    static testMethod void testUnescapeHtml4() {
        String methodName = 'unescapeHtml4';
        List<Object> arguments;
        String [] testString1 = new String [] {};
        String t;

        t = 'stuff \\ to \' escape & <html> things \n too';
        testString1.add(t.escapeHtml4());
        testString1.add(testLongString.escapeHtml4());

        for (Integer i=0;i<testString1.size();i++) {
            arguments = new List<Object>();
            arguments.add(testString1[i]);
            testCorrectResults(methodName, 'valid result', arguments, testString1[i].unescapeHtml4());

        }
    }

    /**
     *  Test the unescapeUnicode method
     */
    static testMethod void testUnescapeUnicode() {
        String methodName = 'unescapeUnicode';
        List<Object> arguments;
        String [] testString1 = new String [] {
                testLongString.escapeUnicode(), testGerman.escapeUnicode(), testShortString6.escapeUnicode()
        };

        for (Integer i=0;i<testString1.size();i++) {
            arguments = new List<Object>();
            arguments.add(testString1[i]);
            testCorrectResults(methodName, 'valid result', arguments, testString1[i].unescapeUnicode());

        }
    }

    /**
     *  Test the unescapeXml method
     */
    static testMethod void testUnescapeXml() {
        String methodName = 'unescapeXml';
        List<Object> arguments;
        String [] testString1 = new String [] {};
        String t;

        t = 'stuff \\ to \' escape & <html> things \n too';
        testString1.add(t.escapeXml());
        testString1.add(testLongString.escapeXml());

        for (Integer i=0;i<testString1.size();i++) {
            arguments = new List<Object>();
            arguments.add(testString1[i]);
            testCorrectResults(methodName, 'valid result', arguments, testString1[i].unescapeXml());

        }
    }


}