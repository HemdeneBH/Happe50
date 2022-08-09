/**
 * @author Unknown
 * @date 19/04/2022 - Refactoring by Sutharsan Pushparajah
 * @description SM_AP78_TranquilityApiService - Controller class to access the Tranquility API
 */
global with sharing class SM_AP78_TranquilityApiService implements vlocity_cmt.VlocityOpenInterface {
    
    /**
     * @author Sutharsan Pushparajah
     * @date 19/04/2022
     * @description TranquilityException - Custom Exception to fire message for Tranquility API
     */
	public class TranquilityException extends Exception{}

    /**
     * @author Unknown
     * @date 19/04/2022
     * @description Expose Tranquility API to IP
     * @param methodName the name of the method to call
     * @param inputMap Input parameters
	 * @param outMap results from API call
	 * @param options options parameters from IP
     * @return Boolean true if the call succeeds
     */
    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        try{
            if (methodName.equals('callTranquility')) {
                outMap.putAll(callTranquility(inputMap));
            } else if(methodName.equals('callTranquilityAddContrat')){
                callTranquilityAddContrat(inputMap, outMap);              
            } else if(methodName.equals('callTranquilityAddContratDP')){
                callTranquilityAddContratDP(inputMap, outMap);              
            }
        } catch (Exception exp){
            APU000_Logger.log(LoggingLevel.ERROR, 'SM_AP78_TranquilityApiService', 'invokeMethod', exp.getMessage());
            return false;
        }

        return true;
    }
    
    /**
     * @author Unknown
     * @date 19/04/2022
     * @description Search Get Contracts By Adresse API
     * @param inputMap Input parameters
     * @return Map<String, Object> results from the Get Contracts By Adresse API call
     */
    @AuraEnabled(cacheable=false)
    public static Map <String, Object> callTranquility(Map<String, Object> inputMap) {
        Set<String> mandatoryFields = new Set<String>{'bpClient', 'rue', 'codePostal', 'commune'};

        try {
            for (String theField : mandatoryFields){
                Object theValue = inputMap.get(theField);
                if (theValue == null || String.isEmpty(String.valueOf(theValue))){
                    throw new TranquilityException('Mandatory field ' + theField + ' is empty');
                }
            }
        } catch (Exception exp){
            APU000_Logger.log(LoggingLevel.ERROR, 'SM_AP78_TranquilityApiService', 'callTranquility', exp.getMessage());
            throw new TranquilityException(exp.getMessage());
        }

        return SM_SM004_Tranquility.getContractsByAdress(inputMap);
    }
    
    /**
     * @author Unknown
     * @date 19/04/2022
     * @description Search Add Contracts API
     * @param inputMap Input parameters
     * @param outMap results from the Add Contracts API call
     * @return N/A
     */
    @AuraEnabled(cacheable=false)
    public static void callTranquilityAddContrat(Map<String, Object> inputMap, Map <String, Object> outMap) {        
        Map<String, Object> resultAsMapTranquilityTemp = SM_SM004_Tranquility.addContrat(inputMap); 
        outMap.putAll(resultAsMapTranquilityTemp);         
    }
    
    /**
     * @author Unknown
     * @date 19/04/2022
     * @description Search Add Contracts Detection Projet API
     * @param inputMap Input parameters
     * @param outMap results from the Add Contracts Detection Projet API call
     * @return N/A
     */
    @AuraEnabled(cacheable=false)
    public static void callTranquilityAddContratDP(Map<String, Object> inputMap, Map <String, Object> outMap) {
        Map<String, Object> resultAsMapTranquilityTemp = SM_SM004_Tranquility.addContratDetectionProjet(inputMap);
        outMap.putAll(resultAsMapTranquilityTemp);
    }
}