/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-10-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class SM_Utilities_Test {

    @isTest
    public static void getRecordTypeIdbyName(){
        String checkRecordType = '';
        Id recordtypeId = SM_Utilities.getRecordTypeIdByName('Contact', 'Contact Smile');
        system.debug(recordtypeId);
        system.assert(String.isNotBlank(recordtypeId));
    }

    /*@isTest
    public static void getUserProfileName(){
        String profileName = SM_Utilities.getUserProfileName();        
        system.assert(String.isNotBlank(profileName));
    }






    @isTest
    public static void traceLog(){
        SM_Utilities.traceLog(buildLog()) ;       
    }

   


    @isTest
    public static String buildLog(){
        String result = SM_Utilities.buildLog('Data','LOG','CreerPrestationGAZ') ;
        system.assert(String.isNotBlank(result));
        return result ;
    }


    @isTest
    public static void  invokeMethodVlocity(){
        Map<String, Object> inputMap = new   Map<String, Object>() ;
        inputMap.put('input', 'input') ;
        inputMap.put('output', 'output') ;
        inputMap.put('severity', 'severity') ;
        inputMap.put('operationType', 'operationType') ;
         SM_Utilities.invokeMethod('traceLog',inputMap,null, null) ;

    }*/

    @isTest
    public static void getRecordObjectName(){
        // List with items
        Account acc = SM_TestDataFactory.createAccount('Service');
        Insert acc;
        List<String> inputs= new List<String>();
        inputs.add(acc.id);
        List<String> objectNames = SM_Utilities.getRecordObjectName(inputs);
        
        System.assertEquals('Account', objectNames.get(0));

        // Empty List
        List<String> inputsEmpty = new List<String>{null};
        System.assertEquals('', SM_Utilities.getRecordObjectName(inputsEmpty).get(0));

    }

        @isTest
    public static void getTokenAPIHour(){
        Map<String, Object> inputMap = new   Map<String, Object>() ;
         SM_Utilities.invokeMethod('getTokenAPIHour',inputMap,null, null) ;
    }

            @isTest
    public static void getEEKOAPIHourAuthData(){
        Map<String, Object> maps = new   Map<String, Object>() ;
         SM_Utilities.invokeMethod('getEEKOAPIHourAuthData',maps,maps, null) ;
    }
    @isTest
    public static void getcustomMetadataRecords(){
        List<SObject> customMetadataRecords = SM_Utilities.getcustomMetadataRecords('SM_PlageBlocageParMotif__mdt','MasterLabel,');
        System.assertEquals(11, customMetadataRecords.size());
        Map<String, Object> inputMap = new   Map<String, Object>() ;
        SM_Utilities.invokeMethod('getcustomMetadataRecordsForVlocity',inputMap,null, null) ;
    }

    @isTest
    public static void getOmniscriptParameters(){
        Map<String, Object> inputMap = new Map<String, Object>() ;
        inputMap.put('parcours','testparcours');
        Map<String, Object> outputMap = new Map<String, Object>() ;
        Test.startTest();
        SM_Utilities.invokeMethod('getOmniscriptParameters',inputMap,outputMap,null) ;
        Test.stopTest();
        Map<String,Object> omniscriptParams= (Map<String, Object>) outputMap.get('omniscriptParams');
        System.assertEquals('testValue', omniscriptParams.get('testLabel'));
    }
    
    @isTest
    public static void getUserProfileNameTest(){
        Test.startTest();
        String profileName = SM_Utilities.getUserProfileName();
        Test.stopTest();

        System.assertNotEquals(profileName, '');
    }
}