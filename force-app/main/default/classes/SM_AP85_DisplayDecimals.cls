/*@Author: RJM
*@Description: Calcul Min Max de la mensualité
*@CreatedDate: 17/04/2020
*/
global class SM_AP85_DisplayDecimals implements vlocity_cmt.VlocityOpenInterface {

    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        if (methodName.equals('calculMaxMin')) {
            try {
                calculMaxMin(inputMap, outMap);
           } catch (Exception e) {
               system.debug('Exception Message = '+e.getMessage()+' Trace = '+e.getStackTraceString());
               return false;
           }
        }
        return true;
    }
    
     public static void calculMaxMin(Map < String, Object > inputMap, Map < String, Object > outMap) {
         Decimal offrePrix = (Decimal) inputMap.get('offrePrix');

         String minPrixFormatted = String.valueOf((offrePrix * 0.9).setScale(2)).replace('.',',');
         String maxPrixFormatted = String.valueOf((offrePrix * 1.1).setScale(2)).replace('.',',');
         String minPrix= String.valueOf((offrePrix * 0.9).setScale(2));
         String maxPrix = String.valueOf((offrePrix * 1.1).setScale(2));
         
         outMap.put('minPrixFormatted', minPrixFormatted);
         outMap.put('maxPrixFormatted', maxPrixFormatted);
         outMap.put('minPrix', minPrix);
         outMap.put('maxPrix', maxPrix);
     }
}