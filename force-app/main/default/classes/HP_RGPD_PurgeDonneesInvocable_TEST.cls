/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 12-24-2021
 * @last modified by  : Hemdene Ben Hammouda
**/
@isTest
public with sharing class HP_RGPD_PurgeDonneesInvocable_TEST {
    
    @IsTest
    static void testSendNotification(){
        HP_RGPD_PurgeDonneesInvocable.Requests request = new HP_RGPD_PurgeDonneesInvocable.Requests();
        request.eventObject=new RGPD_PurgeDonneesIdentification__e( eventId__c = '604fd3af5256c175b93cd7a1-604fd3af5256c175b93cd7a1',
                                                                    eventSource__c = 'HAPPE',
                                                                    eventSubType__c = 'GestionRelationClient',
                                                                    eventTime__c = System.Datetime.now(),
                                                                    eventType__c = 'PurgeDonneesIdentification',
                                                                    idContrat__c = 123456,
                                                                    idDemande__c = 1,
                                                                    idPortefeuilleContrat__c = 456789,
                                                                    idTiers__c = 445879,
                                                                    noBp__c = '123456',
                                                                    noContrat__c = '554789',
                                                                    noPortefeuilleContrat__c = 1245786
                                                                    );
        List<HP_RGPD_PurgeDonneesInvocable.Requests> requestList = new List<HP_RGPD_PurgeDonneesInvocable.Requests>();
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                  'HP_APIHourAccessTokenResponse_MOCK',
                                                  new Map<String, String> {'Content-Type' => 'application/json'}),

           'v1/rest/emails' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                 'HP_Stream_Purge_Notification_Response_MOCK_OK',
                                                 new Map<String, String> { 'Content-Type' => 'application/json;charset=UTF-8'})
       };
        requestList.add(request);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_RGPD_PurgeDonneesInvocable.sendConfirmationPurge(requestList);
        Test.stopTest();
        
    }
}