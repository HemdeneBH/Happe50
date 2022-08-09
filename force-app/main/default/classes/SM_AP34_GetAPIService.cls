global class SM_AP34_GetAPIService implements vlocity_cmt.VlocityOpenInterface {
/****************************************************
* @US: SMIL-1191: Offre - services
* @date: 23/10/2018
* @Project: Smile
* @Created by: Alain Kameni
* @Description: Utility to manage API Call
****************************************************/

global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
  
    if (methodName.equals('getAuth')) {
        getAuth(inputMap, outMap, options);
    }
  return false;
 }
 
 public Boolean getAuth (Map<String, Object> input, Map<String, Object> output, Map<String, Object> options){           
        String token;
        if(Test.isRunningTest()){
          token ='1234';
        }else{
          token = SM_MP_AP04_GetTokenService.getTokenFromSmile();  //token Smile  
        }

        Map <String,String> sHeader = new Map <String,String> ();
        
        output.put('token',token);
        sHeader.put('X-Correlation-Id',MP_AP13_GuidUtil.NewGuid());
        sHeader.put('api_key', MP_Xdata_credentials__c.getInstance('sm_api_key').Value__c);
        sHeader.put('Authorization','Bearer ' + token);
        sHeader.put('Content-Type', 'application/json');
        output.put('header',sHeader);
        //getURLSuffix(input, output, options); // Add_PERF - AKA
        SM_Utils_Process SM_Utils = new SM_Utils_Process();
        SM_Utils.getEndPoint(input, output, options);
        // End_PERF - AKA
        return true;           
    }
}