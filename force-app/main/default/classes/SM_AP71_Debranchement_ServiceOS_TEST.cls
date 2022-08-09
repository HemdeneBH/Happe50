/*******************************************************************************************************
* @description: Appeler le service crypter Param pour le debranchement ( Developpement fait dans le  cadre de l'us SMIL-1734 )
* @date: 2019-04-02
* @author: Mickaël
********************************************************************************************************/
@isTest
private class SM_AP71_Debranchement_ServiceOS_TEST{
	
	 static testMethod void crypterParam(){
        
		Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
		
        inputMap.put('ContextId', '0039E00000rTl6DQAS');
         inputMap.put('statusCode', '200');
        
        SM_AP71_Debranchement_ServiceOS chaineCryptee = new SM_AP71_Debranchement_ServiceOS();
        chaineCryptee.invokeMethod('getChaineCryptee',inputMap,outMap,null);
        
         inputMap.put('statusCode', '503');
         chaineCryptee.invokeMethod('getChaineCryptee',inputMap,outMap,null);
	}
    
    static testMethod void crypterParamKO(){
        
		Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
		
        inputMap.put('ContextId', '');
        SM_AP71_Debranchement_ServiceOS chaineCryptee = new SM_AP71_Debranchement_ServiceOS();
        chaineCryptee.invokeMethod('getChaineCryptee',inputMap,outMap,null);
        
	}
}