/**
 * @author Unknown
 * @date 14/04/2022 - Refactoring by Sutharsan Pushparajah
 * @description SM_AP75_FacturationsMApiService - Controller class to access the FacturationsMensualisees API
 */
public with sharing class SM_AP75_FacturationsMApiService {

    /**
     * @author Sutharsan Pushparajah
     * @date 14/04/2022
     * @description FacturationsMensualiseesException - Custom Exception to fire message for FacturationsMensualisees API
     */
	public class FacturationsMensualiseesException extends Exception{}

     /**
     * @author Unknown
     * @date 14/04/2022
     * @description Search FacturationsMensualisees API
     * @param inputMap Input parameters
     * @return Map<String, Object> results from the FacturationsMensualisees API call
     */
    @AuraEnabled(cacheable=false)
    public static Map <String, Object> callFacturationsMensualisees(Map<String, Object> inputMap) {

        Map<String, Object> outMap = new Map<String, Object>();
        
        try{
            String idsPortefeuilleContrat = String.valueOf(inputMap.get('idsPortefeuilleContrat'));

            if (String.isEmpty(idsPortefeuilleContrat)){
                throw new FacturationsMensualiseesException('idsPortefeuilleContrat is empty : '+inputMap);
            }

            List<Object> facturationsPaiements = SM_WS106_FacturationsMensualisees.getFacturationsMensualisees(idsPortefeuilleContrat, null);

            if (facturationsPaiements.size() == 0){
                throw new FacturationsMensualiseesException('No data to get the idsPortefeuilleContrat : '+idsPortefeuilleContrat);
            }
          
            outMap.put('resultdata', facturationsPaiements);
        } catch(Exception exp){
            APU000_Logger.log(LoggingLevel.ERROR, 'SM_AP75_FacturationsMApiService', 'callFacturationsMensualisees', exp.getMessage());
            outMap.put('resultdata', new  List<Object>());
        }

        return outMap;
    }
}