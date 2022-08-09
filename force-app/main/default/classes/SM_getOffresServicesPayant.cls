/**
 * @author Unknown
 * @date 19/04/2022 - Refactoring by Sutharsan Pushparajah
 * @description SM_getOffresServicesPayant - Controller class to access the Tranquility API
 */
global with sharing class SM_getOffresServicesPayant implements vlocity_cmt.VlocityOpenInterface {

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
        try {
            getservicespayant(inputMap, outMap, options);
        } catch (Exception exp){
            APU000_Logger.log(LoggingLevel.ERROR, 'SM_getOffresServicesPayant', 'invokeMethod', exp.getMessage());
            return false;
        }
          
        return true; 
    }
      
    /**
     * @author Unknown
     * @date 19/04/2022
     * @description Search Get Offres Availables API
     * @param inputMap Input parameters
     * @param outMap results from API call
	 * @param options options parameters from IP
     * @return Map<String, Object> results from the Get Contracts By Adresse API call
     */
    global static void getservicespayant(Map<String, Object> inputMap, Map<String, Object> outMap, Map <String, Object> options){
        string numerovoie = (String) inputMap.get('numeroVoie');
        string libellevoie = (String) inputMap.get('libelleVoie');
        string codepostal = (String) inputMap.get('codePostal');
        string ville = (String) inputMap.get('ville');
        string idbp = (String) inputMap.get('IdBusinessPartner');
        string canal = (String) inputMap.get('canal');
        
        Map<String,Object> mapoffreavailable = SM_SM004_Tranquility.getOffresAvailables(numerovoie, libellevoie, codepostal, ville, '', '', idbp, canal);

        Map<String,Object> resoffres = (Map<String,Object>) mapoffreavailable.get('return');
        Map<String,Object> offrespaynt = (Map<String,Object>)resoffres.get('retour');
        Object offretosend = offrespaynt.get('offreList');
        outMap.put('offreList',offretosend);
    }
}