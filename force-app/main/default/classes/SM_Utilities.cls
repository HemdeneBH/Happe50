/**
 * @Author <Amar Kaillo>
 * @name <SM_Utilities>
 * @CreatedDate <25/11/2019>
 * @Description <Class used to declare dynamic methods used in the projet>
 * @Version <1.0>
 * @reference <Referenced program names>
 * @ModifiedBy <Omar MOHAMAD>
 */


 

global class SM_Utilities implements vlocity_cmt.VlocityOpenInterface{
      
    
    

    global static Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
      boolean returnValue = true;
        /*if (methodName.equals('traceLog')) {
            String data  = 'Trame input \n'+String.valueOf(inputMap.get('input'))+ '\n \n' +'Trame output : \n'+ String.valueOf(inputMap.get('output'))  ;
            String severity = String.valueOf(inputMap.get('severity'))  ;
            String operationType = String.valueOf(inputMap.get('operationType'))  ;
            data=  SM_Utilities.buildLog(data,severity,operationType) ;
                SM_Utilities.traceLog(data) ;
    }else */
    if(methodName.equals('getTokenAPIHour')){
                    try {
                System.debug('inputss: '+inputMap);
                SM_Utilities.getTokenAPIHour(inputMap, outMap);
                System.debug('outputMap: '+outMap);
            } 
            catch (Exception e) {
                system.debug('## error occured during calling getTokenAPIHour ##');
                system.debug(e);
                system.debug(e.getStackTraceString());
                returnValue =  false;
            }

        }else if(methodName.equals('getEEKOAPIHourAuthData')){
            try {
                System.debug('inputss: '+inputMap);
                SM_Utilities.getEEKOAPIHourAuthData(inputMap, outMap);
                System.debug('outputMap: '+outMap);
            } 
            catch (Exception e) {
                system.debug('## error occured during calling getEEKOAPIHourAuthData ##');
                system.debug(e);
                system.debug(e.getStackTraceString());
                returnValue =  false;
            }
        }
        else if(methodName.equals('getcustomMetadataRecordsForVlocity')){
            try {
                System.debug('inputss: '+inputMap);
                SM_Utilities.getcustomMetadataRecordsForVlocity(String.valueOf(inputMap.get('sObjName')), String.valueOf(inputMap.get('sObjFields')), outMap);
                System.debug('outputMap: '+outMap);
            } 
            catch (Exception e) {
                system.debug('## error occured during calling getcustomMetadataRecordsForVlocity ##');
                system.debug(e);
                system.debug(e.getStackTraceString());
                returnValue =  false;
            }
        }
        else if(methodName.equals('getOmniscriptParameters')){
            try {
                System.debug('inputMap: '+inputMap);
                SM_Utilities.getOmniscriptParameters(inputMap, outMap);
                System.debug('outputMap: '+outMap);
            } 
            catch (Exception e) {
                system.debug('## error occured during calling getOmniscriptParameters ##');
                system.debug(e);
                system.debug(e.getStackTraceString());
                returnValue =  false;
            }
        }      
        return false;
    }
    
    
    
    /**
     * @author Omar MOHAMAD
     * @date Creation 26/02/2019 
     * @description define a boolean for trigger to fire once
     */
    public static boolean runOnce = true;
    
    
    /**
     * @author Amar KAILLO
     * @date Creation 25/11/2019 
     * @param name Name the record Type
     * @param objectName Name of the object containing the recordTypes
     * @description Retrieve the Id of the recordType identified by his name and the corresponding object
     * @return Id the Id of the recordType identified by his name and the corresponding object
     */
    public static Id getRecordTypeIdByName(String objectName, String name){
        Id resultId = null;
        if (!String.isBlank(name) && !String.isBlank(objectName)){
            resultId =  Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByName().get(name).getRecordTypeId();
        }
        return resultId;
    }

 

    public static String getUserProfileName() {
        String profileName = '';
        Id profileId = userinfo.getProfileId();

 

        System.debug('profileId = '+profileId);

 

        List<Profile> listProfile = [SELECT Id, Name 
                                     FROM Profile 
                                     WHERE Id =: profileId];
        
        if (listProfile.size() != 0) {
            profileName = listProfile.get(0).Name;
        }
        
        System.debug('ProfileName'+profileName);

 

        return profileName;
    }

    


 


    /*@future
    public static void traceLog(String data){

 

     if(System.Label.logActivated.equalsIgnoreCase('true')){
     String userName =  SM_Utils_TokenOctopus.getOctopusUsername() ;
     Map<String,Object> wrapper = (Map<String,Object>) SYSTEM.JSON.deserializeUntyped(data);
     String severity = (String) wrapper.get('severity') ;
     String dataPayload = (String) wrapper.get('data') ;
     String operationType = (String) wrapper.get('OperationType') ;
     
     SM_LogDataBase__c log = new SM_LogDataBase__c () ;
     log.Flux__c = dataPayload ;
     log.Severite__c = severity ;
     log.Utilisateur__c = userName ;
     log.TypeOperation__c =operationType ;
     database.insert(log,true) ;
    }
    }




    public static String buildLog(String  data,String severity,String operationType){
        try{
        Map<String,String> logData = new Map<String,String>() ;
        logData.put('severity', severity)  ;
        logData.put('data', data) ;
        logData.put('OperationType', OperationType)    ;    
        return  JSON.serializePretty(logData);   
        }catch(Exception e){
            System.debug(e);
            return 'Error when building log ' ;
        }
    } 
    */

 

    public static void getTokenAPIHour(Map < String, Object > inputMap, Map < String, Object > outputMap){
           outputMap.put('APIHourToken',SM_MP_AP04_GetTokenService.getTokenFromSmile());
        outputMap.put('X-Correlation-Id',MP_AP13_GuidUtil.NewGuid());
    } 


   public static void getEEKOAPIHourAuthData(Map < String, Object > inputMap, Map < String, Object > outputMap){
        SM_EEKO_credentials__mdt eekoAPIHourAuthData = [select api_key__c,client_id__c,client_secret__c,Content_Type__c,grant_type__c,password__c,username__c from SM_EEKO_credentials__mdt where Label ='EEKO_CREDENTIALS'];
        outputMap.put('X-Correlation-Id',MP_AP13_GuidUtil.NewGuid());
        outputMap.put('api_key',eekoAPIHourAuthData.api_key__c);
        outputMap.put('client_id',eekoAPIHourAuthData.client_id__c);
        outputMap.put('client_secret',eekoAPIHourAuthData.client_secret__c);
        outputMap.put('Content-Type',eekoAPIHourAuthData.Content_Type__c);
        outputMap.put('grant_type',eekoAPIHourAuthData.grant_type__c);
        outputMap.put('password',eekoAPIHourAuthData.password__c);
        outputMap.put('username',eekoAPIHourAuthData.username__c);
   
    } 
   


    @InvocableMethod
    public static List<String> getRecordObjectName(List<String> recordIdStrings) {
        // object Names to return
        List<string> objectNames = new List<string>();
        
        for(string recordId : recordIdStrings) {
            if(!String.isBlank(recordId)) {
               objectNames.add(Id.valueOf(recordId).getSobjectType().getDescribe().getName());
            }else {
               objectNames.add('');
            }
        }
         system.debug('i am inside = '+objectNames);
        return objectNames;
    }
    /**
     * @author Alaeddine El assad
     * @date Creation 05/08/2021 
     * @param sObjName Name of the object retrieved
     * @param sObjFields list of developer name of the fields separated by , 
     * @return List of records retrieved with the query
     */
    @AuraEnabled(cacheable=true)    
    public static List<SObject> getcustomMetadataRecords(String sObjName,String sObjFields) {
        String query = 'select ' + sObjFields + 'id FROM '+ sObjName+ ' ';
        List<SObject> customMetadataRecords = Database.query(query);
        return customMetadataRecords;
    }
    /**
     * @author Alaeddine El assad
     * @date Creation 11/08/2021 
     * @param sObjName Name of the object retrieved
     * @param sObjFields list of developer name of the fields separated by , 
     * @param outputMap map of records retrieved with the query
     */
    public static void getcustomMetadataRecordsForVlocity(String sObjName,String sObjFields, Map < String, Object > outputMap) {
        String query = 'select ' + sObjFields + 'id FROM '+ sObjName+ ' ';
        List<SObject> customMetadataRecords = Database.query(query);
        outputMap.put('customMetadataRecords', customMetadataRecords );
    }
        
    /**
     * @author Riadh DALLEL
     * @date Creation 20/09/2021 
     * @Description Fonction permet de récupérer les paramètres statiques d'un parcours stockés dans SM_Omniscript_Parameters__mdt 
     */
    public static void getOmniscriptParameters(Map < String, Object > inputMap, Map < String, Object > outputMap){
        String OmniscriptParcours = (String) inputMap.get('parcours');
        List<SM_Omniscript_Parameters__mdt> params;
        // retrieve Omniscript params from SM_Omniscript_Parameters__mdt
        params = (!Test.isRunningTest())? 
            [SELECT Id,Label,Value__c FROM SM_Omniscript_Parameters__mdt WHERE parcours__c=:OmniscriptParcours]
            :new List<SM_Omniscript_Parameters__mdt>{
                new SM_Omniscript_Parameters__mdt(parcours__c='testParcours',Label='testLabel',value__c='testValue')};
        // organise the output params by label
        Map<String,Object> paramsByLabel=new Map<String,Object>();

        for(SM_Omniscript_Parameters__mdt param : params){
            paramsByLabel.put(param.Label, param.value__c);
        }

        outputMap.put('omniscriptParams',paramsByLabel);
    }
        
}