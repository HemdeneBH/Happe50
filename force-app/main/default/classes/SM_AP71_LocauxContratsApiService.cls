/**
 * @author Unknown
 * @date 12/04/2022 - Refactoring by Sutharsan Pushparajah
 * @description SM_AP71_LocauxContratsApiService - Controller class to access the LocauxContrats API
 */
global with sharing class SM_AP71_LocauxContratsApiService implements vlocity_cmt.VlocityOpenInterface {
    
    /**
     * @author Sutharsan Pushparajah
     * @date 12/04/2022
     * @description LocauxContratsException - Custom Exception to fire message for LocauxContrats API
     */
	public class LocauxContratsException extends Exception{}

    /**
     * @author Unknown
     * @date 12/04/2022
     * @description Expose LocauxContrats API to IP
     * @param methodName the name of the method to call
     * @param inputMap Input parameters
	 * @param outMap results from API call
	 * @param options options parameters from IP
     * @return Boolean true if the call succeeds
     */
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outputMap, Map<String,Object> options) {
        
        try{
            if (methodName.equals('callLocauxContrats_IP')) {
                callLocauxContrats_IP(inputMap, outputMap, options);
            }
        } catch (Exception exp) {
            APU000_Logger.log(LoggingLevel.ERROR, 'SM_AP71_LocauxContratsApiService', 'invokeMethod', exp.getMessage());
            return false;
        }

        return true;
    }

    /**
     * @author Unknown
     * @date 12/04/2022
     * @description Search LocauxContrats API from IP
     * @param inputMap Input parameters
     * @param outputMap results from API call
	 * @param options options parameters from IP
     * @return N/A
     */
    public static void callLocauxContrats_IP(Map<String,Object> inputMap, Map<String,Object> outputMap, Map<String,Object> options) {
        
        try{
            String idsPortefeuilleContrat = String.valueOf(inputMap.get('idsPortefeuilleContrat'));

            if (String.isNotEmpty(idsPortefeuilleContrat)){
                List<String> idPortfeuilles = idsPortefeuilleContrat.replaceAll('[() ]','').split(',');
                inputMap.put('idsPortefeuilleContrat',String.join(idPortfeuilles,','));
                outputMap.putAll(callLocauxContrats(inputMap));
            } else {
                throw new LocauxContratsException('idsPortefeuilleContrat is empty : '+inputMap);
            }
        } catch(Exception exp){
            APU000_Logger.log(LoggingLevel.ERROR, 'SM_AP71_LocauxContratsApiService', 'callLocauxContrats_IP', exp.getMessage());
            outputMap.put('resultdata', new  List<Object>());
        }
    }
    
    /**
     * @author Unknown
     * @date 12/04/2022
     * @description Search LocauxContrats API
     * @param inputMap Input parameters
     * @return Map<String, Object> results from the LocauxContrats API call
     */
    @AuraEnabled(cacheable=false)
    public static Map <String, Object> callLocauxContrats(Map<String,Object> inputMap) {
        Map<String, Object> outMap = new Map<String, Object>();
        
        try{
            String idsPortefeuilleContrat = String.valueOf(inputMap.get('idsPortefeuilleContrat'));

            if (String.isEmpty(idsPortefeuilleContrat)){
                throw new LocauxContratsException('idsPortefeuilleContrat is empty : '+inputMap);
            }

            List<Object> locauxContrats = SM_WS104_LocauxContrats.getLocauxContrats(idsPortefeuilleContrat, null);

            if (locauxContrats.size() == 0){
                throw new LocauxContratsException('No data to get the idsPortefeuilleContrat : '+idsPortefeuilleContrat);
            }
          
            outMap.put('resultdata', locauxContrats);
        } catch(Exception exp){
            APU000_Logger.log(LoggingLevel.ERROR, 'SM_AP71_LocauxContratsApiService', 'callLocauxContrats', exp.getMessage());
            outMap.put('resultdata', new  List<Object>());
        }

        return outMap;
    }
}