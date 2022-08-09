/*
*@Author: Paul Ghousoub
*@Description: Récupération du token dans le cache s'il y est stocké, via les API sinon.
*@CreatedDate: 26/10/2020
*@LastModified: 05/11/2020
*/
public class VI_SM013_GetTokenService { 
    /**
* @authorPaul Ghousoub
* @date 26/10/2020
* @description Appel webservice pour recuperer le token pour se connecter
* @param contexte (HP,SM,VI), partitionName (local.VIToken,local.smileToken)
* @return Si l'email est vérfié ou pas
*/
    public static String getToken(String contexte, String partitionName) {
        Cache.OrgPartition part = Cache.Org.getPartition(partitionName);
        system.debug('part '+part); 
        String token = (String) part.get('token');
        system.debug('token '+token);
        if (token != null) {
            return token;
        }
        httpResponse res;
        if(Label.VI_useAPIGEE=='true'){
            res = VI_UTIL001_HttpUtilities.getTokenResponseApigee(contexte); 
        }
        else{
            res = VI_UTIL001_HttpUtilities.getTokenResponse(contexte); 
        }
        system.debug('res'+ res);
        if (res!= null && res.getStatusCode() == 200) {
            token = VI_UTIL002_Utilities.getJsonFieldAsString('access_token', res.getBody());
            part.put('token', token, 3600 * 1 - 30);
            system.debug('token '+token);
            return token; 
        }
        return null;
    }
    
    public static String getTokenB2C(String contexte, String partitionName) {
        Cache.OrgPartition part = Cache.Org.getPartition(partitionName);
        system.debug('part '+part); 
        String token = (String) part.get('token');
        system.debug('token '+token);
        if (token != null) {
            return token;
        }
        httpResponse res;
        res = VI_UTIL001_HttpUtilities.getTokenResponseApigeeB2C(contexte); 
        system.debug('res'+ res);
        if (res!= null && res.getStatusCode() == 200) {
            token = VI_UTIL002_Utilities.getJsonFieldAsString('access_token', res.getBody());
            part.put('token', token, 3600 * 1 - 30);
            system.debug('token '+token);
            return token; 
        }
        return null;
    }
    
}