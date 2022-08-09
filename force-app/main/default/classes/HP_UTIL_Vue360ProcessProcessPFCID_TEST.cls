@IsTest
public with sharing class HP_UTIL_Vue360ProcessProcessPFCID_TEST {

    private enum StaticResource {
        HP_APIHourAccessTokenResponse_MOCK
    }


    @testSetup static void dataSetup(){
        HP_UTIL_SmartFactory.insertUserHP();
    }
      
    @isTest static void execute(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                    new Map<String, String> {'Content-Type' => 'application/json'}
                )
            
            };
    
            String param = '{"data": {"_data": [{"idPortefeuilleContrat": 254163},{"idPortefeuilleContrat": 254164}]}}';
            Test.startTest();
    
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
            HP_UTIL_Vue360ProcessProcessPFCID.processing( (Object)System.JSON.deserializeUntyped(param),null);
            Test.stopTest();  
        }  
    }


@isTest static void executeEmptyData(){
    System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                new Map<String, String> {'Content-Type' => 'application/json'}
            )
        
        };
    
        String param = '{"data": {"_data": []}}';
        Test.startTest();
    
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_UTIL_Vue360ProcessProcessPFCID.processing( (Object)System.JSON.deserializeUntyped(param),null);
        Test.stopTest(); 
    }   
}
   
}