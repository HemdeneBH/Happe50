/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-10-2022
 * @last modified by  : Hemdene Ben Hammouda
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   11-03-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public with sharing class HP_CALL008_Mediatech_TEST {
   
    private enum StaticResource {
        HP_APIHourAccessTokenResponse_MOCK
    }

    @TestSetUp 
	private static void insertTestData() {
        List<Case> casesList = new List<Case>(); 
        Case case1 = (Case)HP_UTIL_SmartFactory.createSObject('Case','HP_Mail', new Map<String, Object>{
            'Status' => 'NEW_CASE',
            'HP_Type__c' => 'Service',   
            'Subject' => 'Mail'
            }, null, null, null);
        casesList.add(case1);
        
         Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object> {
				'LastName' => 'Contact Test',
				'Email' => 'test@gmail.com',
                'MobilePhone' => '0000000000',
				'Id_Tiers__c' => 1313
			}, null, null,null);
		insert contact;
        // create case
        Case case2 = (Case)HP_UTIL_SmartFactory.createSObject('Case','HP_Telephone', new Map<String, Object>{
            'Status' => 'NEW_CASE',
            'HP_Type__c' => 'Service',
            'ContactId' => contact.Id,
            'Subject' => 'Telephone'
            }, null, null, null);
		casesList.add(case2);
        
        // create case
        Case case3 = (Case)HP_UTIL_SmartFactory.createSObject('Case','HP_Telephone', new Map<String, Object>{
            'Status' => 'NEW_CASE',
            'HP_Type__c' => 'Service',
            'ContactId' => contact.Id,
            'Subject' => 'Telephone No Task'
            }, null, null, null);
		casesList.add(case3);
        
        insert casesList;
        
        Task tsk = (Task)HP_UTIL_SmartFactory.createSObject('Task', 'HP_Task', new Map<String, Object> {
                'whatId' => case2.Id,
                'CallType' => 'Inbound',
                'CallDisposition' => 'Test (404)'
        }, null, null,null);
        insert tsk;
    }

    @isTest
    static void callMediatechActionMail(){

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
			StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
            new Map<String, String> {'Content-Type' => 'application/json'}),
            'survey/event/5de9254237bf6cc63d7b/c279c6bb6ebb61e1bf09' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
            null,
            new Map<String, String> {'Content-Type' => 'application/json'})
        };
        List<HP_CALL008_Mediatech.ObjectToSend> senderList = new List<HP_CALL008_Mediatech.ObjectToSend>(); 
        HP_CALL008_Mediatech.ObjectToSend sender = new HP_CALL008_Mediatech.ObjectToSend();
        sender.emailContact = 'emailContact@gmail.com'; 
        sender.caseOwnerId = '0051X000002Hd2kQAC'; 
        sender.source = 'post_contact_email'; 
        sender.origin = 'email' ;
        //sender.caseStatus = 'CLOSED'; 

        sender.emailSubject = 'Email Subject';

        // create case
		List<Case> aCaseList = [SELECT Id FROM Case WHERE Subject='Mail'];
        sender.caseId = aCaseList[0].Id;
        sender.caseSousType = 'DRP';

        senderList.add(sender);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_CALL008_Mediatech.callMediatechAction(senderList);
        Integer callouts =Limits.getAsyncCalls();
        Test.stopTest();
        System.System.assertEquals(1, callouts, 'A callout should be made');
       

    }
    @isTest
    static void callMediatechActionTel(){

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
			StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
            new Map<String, String> {'Content-Type' => 'application/json'}),
            'survey/event/5de9254237bf6cc63d7b/c279c6bb6ebb61e1bf09' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
            null,
            new Map<String, String> {'Content-Type' => 'application/json'})
        };
        List<HP_CALL008_Mediatech.ObjectToSend> senderList = new List<HP_CALL008_Mediatech.ObjectToSend>(); 
        HP_CALL008_Mediatech.ObjectToSend sender = new HP_CALL008_Mediatech.ObjectToSend();
        sender.caseOwnerId = '0051X000002Hd2kQAC'; 
        sender.source = 'post_contact_tel'; 
        sender.origin = 'tel' ;
        //sender.caseStatus = 'CLOSED'; 

        sender.emailSubject = 'Email Subject';

        List<Case> aCaseList = [SELECT Id FROM Case WHERE Subject='Telephone'];
        sender.caseId = aCaseList[0].Id;
        sender.caseSousType = 'Occupé';

        senderList.add(sender);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_CALL008_Mediatech.callMediatechAction(senderList);
        Integer callouts =Limits.getAsyncCalls();
        Test.stopTest();
        System.System.assertEquals(1, callouts, 'One callout should be made');
    }
    
    @isTest
    static void callMediatechActionTelNoTask(){

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
			StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
            new Map<String, String> {'Content-Type' => 'application/json'}),
            'survey/event/5de9254237bf6cc63d7b/c279c6bb6ebb61e1bf09' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
            null,
            new Map<String, String> {'Content-Type' => 'application/json'})
        };
        List<HP_CALL008_Mediatech.ObjectToSend> senderList = new List<HP_CALL008_Mediatech.ObjectToSend>(); 
        HP_CALL008_Mediatech.ObjectToSend sender = new HP_CALL008_Mediatech.ObjectToSend();
        sender.caseOwnerId = '0051X000002Hd2kQAC'; 
        sender.source = 'post_contact_tel'; 
        sender.origin = 'tel' ;
        //sender.caseStatus = 'CLOSED'; 

        sender.emailSubject = 'Email Subject';

        List<Case> aCaseList = [SELECT Id FROM Case WHERE Subject='Telephone No Task'];
        sender.caseId = aCaseList[0].Id;
        sender.caseSousType = 'Occupé';

        senderList.add(sender);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_CALL008_Mediatech.callMediatechAction(senderList);
        Integer callouts =Limits.getAsyncCalls();
        Test.stopTest();
        System.System.assertEquals(0, callouts, 'No callout should be made');
    }
}