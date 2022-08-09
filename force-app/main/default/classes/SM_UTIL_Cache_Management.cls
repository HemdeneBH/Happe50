global class SM_UTIL_Cache_Management implements vlocity_cmt.VlocityOpenInterface{
    /**************************************************************************
    *@author: Alain KAMENI
    *@date: september 2018
    *@description: utility to read and set data in Salesforce Cache
    *@version: 1.0
    ****************************************************************************/   
    global Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options)
        {            
            
            if (methodName == 'getCacheInfos')
            {
                if(options.get('token_SAP')==true)
                  getOctopusToken_SAP(input, output);
                if(options.get('identifiantDistrib')==true)
                  getIdentifiantDistrib(input, output);               
                return true;                 
            }else if (methodName == 'setCacheInfos')
            {
                if(input.get('token')!=null)
                 setOctopusToken_SAP(input, output);
                if(input.get('identifiantDistrib')!=null && input.get('GetIdDistrib')=='true')
                  setIdentifiantDistrib(input, output);                
                return true; 
            }else if (methodName == 'getOctopusToken_SAP')
            {
                getOctopusToken_SAP(input, output);
                return true;
            }else if (methodName == 'setOctopusToken_SAP')
            {
                setOctopusToken_SAP(input, output);
                return true;
            }else if(methodName == 'getIdentifiantSAPToOS'){
                     
                getIdentifiantSAPToOS(input, output) ; 
                return true;
             }
            else return false;
        }
    // Read data stored in Cache   
    public void getOctopusToken_SAP (Map<String, Object> input, Map<String, Object> output)
    {           
        Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.smileToken');
        System.Debug('Token_Read:'+(String)sessionPart.get('tokenSAP'));
        output.put('token',(String)sessionPart.get('tokenSAP'));    
    } 
    public void getIdentifiantDistrib (Map<String, Object> input, Map<String, Object> output)
    {           
        Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.IdentifiantDistrib');
        output.put('IdentifiantDistrib',(String)sessionPart.get('IdentifiantDistrib'));    
    } 
    // Write data in Cache
    public void setOctopusToken_SAP (Map<String, Object> input, Map<String, Object> output)
    {   if(!String.isBlank((String)input.get('token'))){     
        Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.smileToken');
        System.Debug('Token_SAP'+input.get('token'));
        sessionPart.put('tokenSAP', input.get('token'), Integer.valueOf(Label.SM_CL40_Octopus_Token_TTL));//TTL en secondes 
        System.Debug('Token_To_Write:'+input.get('token'));
    }
     
    } 
    public void setIdentifiantDistrib (Map<String, Object> input, Map<String, Object> output)
    {        
        Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.IdentifiantDistrib');
        System.Debug('IdDistrib_To_Write:'+input.get('token'));
        sessionPart.put('IdentifiantDistrib', input.get('identifiantDistrib'));
       
    }
    
    // Apex Method
    public String getIdentifiantDistribFromApex(){
        Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.IdentifiantDistrib');
        String returnIdentifiantDistrib = '';
        String getIdentifiantDistrib = '';
        getIdentifiantDistrib = (String)sessionPart.get('IdentifiantDistrib');
        if(getIdentifiantDistrib != null && getIdentifiantDistrib != ''){
            returnIdentifiantDistrib = getIdentifiantDistrib;
        }
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
    
    
    

    /*
    * @Author: Mohamed Kchaou
    * @Date: 14/02/2019
    * @Description: methode qui renvoie l'identifiant SAP de la table USer SF ( il verifie déja si il existe dans le cache )
    */
    public String getIdentifiantSAPFromApex(){
        Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.IdentifiantDistrib');
        String getIdentifiantSap = '';
        getIdentifiantSap = (String)sessionPart.get('IdentifiantSAP');
        if(getIdentifiantSap != null && getIdentifiantSap != ''){
           return getIdentifiantSap;
        }
        else{
            String userId = UserInfo.getUserId();
            User aUser = [Select id, name, SAP_Identifier__c from user where id =: userId ];
                if(aUser.SAP_Identifier__c != null){
                   getIdentifiantSap = String.valueOf(aUser.SAP_Identifier__c);
                   sessionPart.put('IdentifiantSAP', getIdentifiantSap);
                }                           
        }
	return getIdentifiantSap;      
       
    }
    
    
    public void getIdentifiantSAPToOS(Map<String,Object> input, Map<String,Object> output){
       String indentifiantSAP =  getIdentifiantSAPFromApex() ;
        output.put('indentifiantSAP',indentifiantSAP) ;
    }
    
    
    
    
 }