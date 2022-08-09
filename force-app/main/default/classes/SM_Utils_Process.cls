global class SM_Utils_Process implements vlocity_cmt.VlocityOpenInterface {
    
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
  
    if (methodName.equals('getParams')) {
        getEndPoint(inputMap, outMap, options);
        if((String)inputMap.get('IdDistribCached') ==null ||(String)inputMap.get('IdDistribCached')=='' ){
          getIdDistrib(inputMap, outMap, options);  
        }
        return true;
    }
  return false;
 }
    public void getIdDistrib (Map<String, Object> input, Map<String, Object> output, Map<String, Object> options){
        User sUser = [SELECT distributor_login__c FROM User WHERE id=:userinfo.getuserid()];
        
        output.put('IdDistrib',sUser!=null?sUser.distributor_login__c:null);
    }
    // Add_PERF - AKA
    public void getEndPoint (Map<String, Object> input, Map<String, Object> output, Map<String, Object> options){
        Set<String> listinp = new Set<String>();
        Map<String,String> mapSuffix = new Map<String,String>();
        Map<String,String> mapInp = new Map<String,String>();
        Integer i=1;
        if((String)input.get('ServiceName') !=null){
           listinp.add((String)input.get('ServiceName'));
           mapInp.put((String)input.get('ServiceName'),'ServiceName');  
        }
        String ServiceN=(String)input.get('ServiceName'+i);
        while(ServiceN !=null){
            System.debug('ServiceN: '+ ServiceN);
           listinp.add(ServiceN);
           mapInp.put(ServiceN,'ServiceName'+i);
           i++;
           ServiceN=(String)input.get('ServiceName'+i);
           
        }
        System.debug('listinp: '+ listinp);
        if(listinp.size()>0){
          List<SM_WS_Suffix__mdt> SuffixURL = [SELECT developername,suffix__c,version__c FROM SM_WS_Suffix__mdt WHERE (DeveloperName in :listinp)];
            System.debug('SuffixURL: '+SuffixURL);
            for (SM_WS_Suffix__mdt Suff : SuffixURL){
                mapSuffix.put(Suff.developername, Suff.suffix__c);
                mapSuffix.put(mapInp.get(Suff.developername)+'_URL', Suff.suffix__c);
                mapSuffix.put(Suff.developername+'_version', Suff.version__c);
                mapSuffix.put(mapInp.get(Suff.developername)+'_version', Suff.version__c);
            }
            System.debug('mapSuffix: '+mapSuffix);
            output.putAll(mapSuffix);  
        }
        
    }
}