/**
 * @description       : 
 * @author            : Vincent Albiser
 * @group             : 
 * @last modified on  : 09-09-2020
 * @last modified by  : Vincent Albiser
 * Modifications Log 
 * Ver   Date         Author            Modification
 * 1.0   09-09-2020   Vincent Albiser   Initial Version
**/
@isTest
public with sharing class BatchApexErrorEventTrigger_TEST {

    private enum StaticResource {
		HP_APIHourAccessTokenResponse_MOCK,
		HP_BatchApexErrorEventTrigger_MOCK
    }

	@TestSetup
	static void makeData(){
			HP_Parameters__c param = (HP_Parameters__c)HP_UTIL_SmartFactory.createSObject('HP_Parameters__c', null, new Map<String, Object> {
				'date_Emailing_Batch__c' => Datetime.newInstance(2020, 03, 29, 0, 0, 0),
				'consumer_Emailing_Batch__c' => '545454',
				'source_Emailing_Batch__c' => '0000654321'
			}, null, null,null);
			insert param;
	
			Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', null, new Map<String, Object> {
				'LastName' => 'Contact Test',
				'Email' => 'test@gmail.com',
				'Id_Tiers__c' => 1313
			}, null, null,null);
			insert contact;
	}
    
    	@istest
	static void testBatch(){
			Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
				'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
													  StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
													  new Map<String, String> {'Content-Type' => 'application/json'}),
	
			   'v1/rest/emails' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
													 StaticResource.HP_BatchApexErrorEventTrigger_MOCK.name(),
													 new Map<String, String> { 'Content-Type' => 'application/json;charset=UTF-8'})
		   };
          
      try{
        Test.startTest();
			Test.setMock(HttpCalloutMock.class,new HP_UTIL_ResponseRestMock(bodyResponseMap));
			HP_BAT001_Emailing emailingBatch = new HP_BAT001_Emailing();
			HP_BAT001_Emailing.execute(1, null, null);
        	Test.getEventBus().deliver();
        Test.stopTest();
    	} catch(Exception e){}
      Test.getEventBus().deliver();
      System.assert ( [select id from HP_TECH_LOG__c ].size() > 0, 'log inserted.');
	}
}