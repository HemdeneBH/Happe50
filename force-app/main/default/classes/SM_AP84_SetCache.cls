/*@Author: MBA
*@Description: Récupération des valeurs du WS prix et remise et calcul des mens
*@CreatedDate:
*@LastModified: MBA 13/03/2020
*/
global class SM_AP84_SetCache {
    
    /*@Author: MBA 13/03/2020
    *@Description: Récupération des valeurs du WS prix et remise et calcul des mens
    *@CreatedDate:
    *@LastModified: MBA 13/03/2020
    */
    @AuraEnabled(cacheable=false)
    public static Boolean setCache() {

        // Get partition
        Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.smileToken');
        System.debug('*******' + sessionPart);
        // Add cache value to the partition. Usually, the value is obtained from a 
        // callout, but hardcoding it in this example for simplicity.
        sessionPart.put('createCase', '1');
        // Retrieve cache value from the partition
        String cachedRate = (String)sessionPart.get('createCase');
        System.debug('cachedRate--->' + cachedRate);
        return true;
    }
    
}