public class VI_UTIL006_Cache_Management {
    public String getIdentifiantDistribFromApex(){
        Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.IdentifiantDistrib');
        String returnIdentifiantDistrib = '';
        String getIdentifiantDistrib = '';
        getIdentifiantDistrib = (String)sessionPart.get('IdentifiantDistrib');
        if(getIdentifiantDistrib != null && getIdentifiantDistrib != ''){
            returnIdentifiantDistrib = getIdentifiantDistrib;
        }
        ////A verifier cette partie
        else{
            String userId = UserInfo.getUserId();
            User aUser = [Select id, name, distributor_login__c from user where id =: userId ];
            if(aUser.distributor_login__c != null && aUser.distributor_login__c != ''){
                returnIdentifiantDistrib = aUser.distributor_login__c;
                sessionPart.put('IdentifiantDistrib', returnIdentifiantDistrib);
            }                           
        }
        return returnIdentifiantDistrib;      
        
    }
}