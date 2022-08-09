@isTest
global class SM_AP62_Consentement_Test {   
	  
	@testSetup static void setup() {
		SM_AP08_TestLib.insertCS_GenericEndpoints();
		SM_AP08_TestLib.insertCS_XDATACredentials();
		SM_AP08_TestLib.insertCS_SMOCTOPUS();     
  }
	
	
	@isTest
	public static void testPOSTConsentement() {
		Test.startTest();     
		Map<String, Object> outputMap = new Map<String, Object>();
		Map<String, Object> inputMap = new Map<String, Object>();     
		List<Object> listConsentement= SM_AP62_MockConsentement.generateConsentement() ;
		Map<String, Object> infosDR = new Map<String, Object>();
		infosDR.put('idPersonne', '49131');        
		inputMap.put('CreerCorrespondance',infosDR); // remplace DRResponse  
		inputMap.put('answerModified',listConsentement);    
		SM_AP62_Consentement service = new SM_AP62_Consentement() ;
		service.invokeMethod('sendConsentement', inputMap,  outputMap, null) ;  
	   // System.debug('@@ testPOSTConsentement outputMap ' +outputMap);       
		system.assertNotEquals(outputMap.get('listRetourAPIPostconsentement'), null);
		Test.stopTest();
	}
	@isTest
	public static void testPUTConsentement() {
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new SM_AP62_MockConsentement());
		Map<String, Object> input=new Map<String, Object>();
		Map<String, Object> outputMap = new Map<String, Object>();
		input.put('refIdpersonne','4827');
		input.put('refClientIdBP','0309985090');       
		List<Object> existingConsentement= SM_AP62_MockConsentement.generateConsentement() ;
		List<Object> listConsentement= SM_AP62_MockConsentement.generateConsentementfalse() ;
		input.put('answerModified',listConsentement);  
		input.put('consentementResult',existingConsentement); 
		SM_AP62_Consentement service = new SM_AP62_Consentement() ;
		service.invokeMethod('updateConsentement', input,  outputMap, null) ;
		//System.debug('@@ testPUTConsentement outputMap ' +outputMap);
		List<Object> listRetourAPIPostconsentement=(List<Object>) outputMap.get('listRetourAPIPostconsentement');    
		System.HttpResponse resp =(System.HttpResponse) listRetourAPIPostconsentement[0];
		System.assertEquals(resp.getStatusCode(), 200);
	  
		Test.stopTest();
	}
}