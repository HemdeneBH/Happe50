@isTest 
public with sharing class HP_EM027_Mediatech_TEST {

    private enum StaticResource {
        HP_APIHourAccessTokenResponse_MOCK
    }

    @TestSetUp 
	private static void insertTestData() {

    }

    @isTest
    static void callMediatechAction(){

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
			StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
            new Map<String, String> {'Content-Type' => 'application/json'}),
            'survey/event/5de9254237bf6cc63d7b/c279c6bb6ebb61e1bf09' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
            null,
            new Map<String, String> {'Content-Type' => 'application/json'})
        };
        List<HP_EM027_Mediatech.ObjectToSend> senderList = new List<HP_EM027_Mediatech.ObjectToSend>(); 
        HP_EM027_Mediatech.ObjectToSend sender = new HP_EM027_Mediatech.ObjectToSend();
        sender.emailContact = 'emailContact@gmail.com'; 
        sender.caseOwnerId = '0051X000002Hd2kQAC'; 
        sender.source = 'post_contact_email'; 
        sender.origin = 'email' ;
        //sender.caseStatus = 'CLOSED'; 
        sender.emailSubject = 'Email Subject';

        // create case
        Case aCase = (Case)HP_UTIL_SmartFactory.createSObject('Case','HP_Mail', new Map<String, Object>{
            'Status' => 'NEW_CASE',
            'HP_Type__c' => 'Service'
            //'HP_Sous_type__c' =>'DRP'
            }, null, null, null);
        insert aCase;

        sender.caseId = aCase.Id;
        sender.caseSousType = 'DRP';
        senderList.add(sender);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_EM027_Mediatech.callMediatechAction(senderList);
        Integer callouts =Limits.getAsyncCalls();
        Test.stopTest();
        System.System.assertEquals(1, callouts, 'A callout should be made');
    }
}