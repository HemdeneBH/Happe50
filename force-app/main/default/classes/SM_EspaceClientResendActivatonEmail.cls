global class SM_EspaceClientResendActivatonEmail implements vlocity_cmt.VlocityOpenInterface{
    
    
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

	  try {
				resendActivationEmail(inputMap, outMap, options);
			} catch (Exception e) {
				system.debug(e);
				return false;
		}
		
		return true;
	}

    global static void  resendActivationEmail(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
		
        Map < String, Object > mailActivationMap = new Map < String, Object >();
        
        //String contextId = (String)inputMap.get('ContextId');
        
        Object idbp = inputMap.get('refClientIdBP');
        String ibBpStr = (String)idbp;
        String IbpTruncate = ibBpStr.removeStart('0');
        Map < String, Object > contactInfos = (map<String,Object>)inputMap.get('ContactInfo');
        Object contactEmail = contactInfos.get('email');
        mailActivationMap.put('numeroBP',IbpTruncate);
        mailActivationMap.put('email',contactEmail);
        String resendEmailResp = SM_AP72_EspaceClientService.renvoyerMailActivation(mailActivationMap);
        outMap.put('sendActivationEmailResp',resendEmailResp);
       
	}
}