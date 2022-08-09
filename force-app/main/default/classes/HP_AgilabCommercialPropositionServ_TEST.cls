@isTest
public with sharing class HP_AgilabCommercialPropositionServ_TEST {

    private enum StaticResource {
		HP_APIHourAccessTokenResponse_MOCK
	}

    @isTest
    static void updateContractStatusAwaitingDistributor_TEST(){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                       'HP_APIHourAccessTokenResponse_MOCK',
                                                       new Map<String, String> {'Content-Type' => 'application/json'}),
    
                'contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(204,
                                                      null,
                                                      new Map<String, String> { 'Content-Type' => 'application/json'})
            };
    
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
            final List<Integer> xDataId = new List<Integer>{100166};
            HP_AgilabCommercialPropositionService.updateContractStatusAwaitingDistributor(xDataId);
            Integer callouts =Limits.getAsyncCalls();
            Test.stopTest();
            System.System.assertEquals(1, callouts, 'A callout should be made');
    }

}