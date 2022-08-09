/* 
@Project : Pure Player
@Description : Cette classe permet de retourner les offres correspondantes
Not used for the MVP

*/

public without sharing class VI_SM015_TranquilityApiService {
    private static String VIUserTranquility;
    private static String VIPasswordTranquility;
    static {
        VIUserTranquility = MP_Xdata_credentials__c.getInstance('VI_user_tranquility').Value__c;
        VIPasswordTranquility = MP_Xdata_credentials__c.getInstance('VI_password_tranquility').Value__c;
    }
    
    @AuraEnabled(cacheable=false)
    public static Map < String, Object > callTranquility(String bpClient,String rue,String codePostal,String commune,String contexte, String partitionName) {
        Map < String, Object > outMap  = new Map<String, Object>();
        Map <String,Object> bodyMap=new Map<String,Object>();
        Map <String,Object> localAssure=new Map<String,Object>();

        localAssure.put('pays','FR');
        
        // check bp client
        if (bpClient == null || bpClient.length() == 0) {
            system.debug('bpClient is not found ...');
            return outMap;
        }
        bodyMap.put('bpClient',bpClient);
        
        // check street
        if (rue == null || rue.length() == 0) {
            system.debug('rue is not found ...');
            return outMap;
        }
        localAssure.put('numRue',rue);
        
        //check zipCode
        if (codePostal == null || codePostal.length() == 0) {
            system.debug('codePostal is not found ...');
            return outMap;
        }
        localAssure.put('codePostal',codePostal);
        
        //check City
        if (commune == null || commune.length() == 0) {
            system.debug('commune is not found ...');
            return outMap;
        }
        localAssure.put('commune',commune);
        
        bodyMap.put('localAssure',localAssure);
        bodyMap.put('idConsomateur','SMILE');
        String token =  VI_SM013_GetTokenService.getToken(contexte, partitionName);
        if (token == null) {
            system.debug('Token not found ...');
            return outMap;
        }
        system.debug('@@ tokenTranquility '+token);
        HttpResponse httpResponse = new HttpResponse(); 
        Map < String, String > values = new Map < String, String > ();
        values.put('gaia', VIUserTranquility);
        values.put('mdp', VIPasswordTranquility);   
        httpResponse = VI_UTIL001_HttpUtilities.makeHttpCall(token,'POST',contexte+'_userLoginTranquility',null,values,null,'application/x-www-form-urlencoded','application/json',null,contexte);
        //HttpResponse httpResponse = getResponse(token);
        system.debug('@@ httpResponse '+httpResponse);
        Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(httpResponse.getBody());
        system.debug('@@ resultAsMap '+resultAsMap);
        Map<String,Object> bearer = ( Map<String,Object> ) resultAsMap.get('data');
        String tokenTranquility =  (String)  bearer.get('token');
        system.debug('@@ bearer '+bearer);
        system.debug('@@ m '+tokenTranquility);
        HttpResponse getResponseTranquility =VI_UTIL001_HttpUtilities.makeHttpCall(token,'POST',contexte+'_tranquilityGetContratsByAdresse',null,bodyMap,null,'application/json','application/json',tokenTranquility, contexte);
        
         
        
        Map<String,Object> resultAsMapTranquilityTemp = (Map<String,Object>) JSON.deserializeUntyped(getResponseTranquility.getBody());
        
        String mystring = getResponseTranquility.getBody();
        Integer iterations = (Integer)Math.ceil(mystring.length()/300);
        for(Integer i=0; i<=iterations;i++){
            integer endindex = ((i+1)*300);
            if(endindex > mystring.length()){
                endindex = mystring.length();
            }
            System.debug(mystring.substring(i*300, endindex));
        }
        
        
        system.debug('@@ resultAsMapTranquility '+resultAsMapTranquilityTemp);        
        return resultAsMapTranquilityTemp;
    }
    
    public static Map<String,Object> getOffresAvailables(String numeroRue,String rue,String codepostal,String commune,String complement,String batiment,string bpclient,String contexte, String partitionName){
        Map < String, Object > outMap  = new Map<String, Object>();
        Map <String,Object> bodyMap=new Map<String,Object>();
        Map <String,Object> localAssure=new Map<String,Object>();
        localAssure.put('pays','FR');
        
        // check bp client
        if (bpClient == null || bpClient.length() == 0) {
            system.debug('bpClient is not found ...');
            return outMap;
        }
        bodyMap.put('bpClient',bpClient);
        
        // check street
        if (rue == null || rue.length() == 0) {
            system.debug('rue is not found ...');
            return outMap;
        }
        localAssure.put('numRue',rue);
        
        //check zipCode
        if (codePostal == null || codePostal.length() == 0) {
            system.debug('codePostal is not found ...');
            return outMap;
        }
        localAssure.put('codePostal',codePostal);
        
        //check City
        if (commune == null || commune.length() == 0) {
            system.debug('commune is not found ...');
            return outMap;
        }
        localAssure.put('commune',commune);
        
        bodyMap.put('localAssure',localAssure);
        bodyMap.put('idConsomateur','SMILE');
        
        String token =  VI_SM013_GetTokenService.getToken(contexte, partitionName);
        if (token == null) {
            system.debug('Token not found ...');
            return outMap;
        }
        system.debug('@@ tokenTranquility '+token);
        HttpResponse httpResponse = new HttpResponse();
        Map < String, String > values = new Map < String, String > ();
        values.put('gaia', VIUserTranquility);
        values.put('mdp', VIPasswordTranquility);   
        httpResponse = VI_UTIL001_HttpUtilities.makeHttpCall(token,'POST',contexte+'_userLoginTranquility',null,values,null,'application/x-www-form-urlencoded','application/json',null,contexte);
        //HttpResponse httpResponse = getResponse(token);
        system.debug('@@ httpResponse '+httpResponse);
        Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(httpResponse.getBody());
        system.debug('@@ resultAsMap '+resultAsMap);
        Map<String,Object> bearer = ( Map<String,Object> ) resultAsMap.get('data');
        String tokenTranquility =  (String)  bearer.get('token');
        system.debug('@@ bearer '+bearer);
        system.debug('@@ m '+tokenTranquility);
        HttpResponse getResponseTranquility =VI_UTIL001_HttpUtilities.makeHttpCall(token,'POST',contexte+'_tranquilityGetOffresAvailables',null,bodyMap,null,'application/json','application/json',tokenTranquility,contexte);
        
        
        return outMap;
    }
    
}