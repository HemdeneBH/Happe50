@isTest
public with sharing class HP_UTIL_Vue360LoadCoContractant_TEST {

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
                ),
                'personnes' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                                                    'HP_APIHourGetPersonne',
                                                    new Map<String, String> {'Content-Type' => 'application/json'})
    
            };
    
            String param = '{"data": {"_data": [ { "id": 254163,"idPersonne": 204833, "idPersonneDivergentCocontractant": 206338, "codeModeEncaissement": "6", "libelleModeEncaissement": "Carte Bancaire","libelleRythmeFacturation": "Bimensuel",  "libelleMarque": "HAPP-E" }]}}';
    
            Test.startTest();
            RestContext.response= new RestResponse();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
            HP_UTIL_Vue360LoadCoContractant.processing( (Object)System.JSON.deserializeUntyped(param),new map<Object,Object>{'agilabId' => '476290', 'xdataId' => '204833','pfcIdList' => new List<String>{'254163','260981'}} );
            Test.stopTest();  
        }
        
}


@isTest static void executeNonCoContractant(){
    System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'personnes' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                                                'HP_APIHourGetPersonne',
                                                new Map<String, String> {'Content-Type' => 'application/json'})
        
        };
    
        String param = '{"data": {"_data": [ { "id": 254163,"idPersonne": 204833, "codeModeEncaissement": "6", "libelleModeEncaissement": "Carte Bancaire","libelleRythmeFacturation": "Bimensuel",  "libelleMarque": "HAPP-E" }]}}';
    
        Test.startTest();
        RestContext.response= new RestResponse();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_UTIL_Vue360LoadCoContractant.processing( (Object)System.JSON.deserializeUntyped(param),new map<Object,Object>{'agilabId' => '476290', 'xdataId' => '204833','pfcIdList' => new List<String>{'254163','260981'}} );
        Test.stopTest();  
    }
    
}



@isTest static void executeFalseId(){
    System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'personnes' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                                                'HP_APIHourGetPersonne',
                                                new Map<String, String> {'Content-Type' => 'application/json'})
        
        };
    
        String param = '{"data": {"_data": [ { "id": 254163,"idPersonne": 204833, "idPersonneDivergentCocontractant": 206338,"codeModeEncaissement": "6", "libelleModeEncaissement": "Carte Bancaire","libelleRythmeFacturation": "Bimensuel",  "libelleMarque": "HAPP-E" }]}}';
    
        Test.startTest();
        RestContext.response= new RestResponse();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_UTIL_Vue360LoadCoContractant.processing( (Object)System.JSON.deserializeUntyped(param),new map<Object,Object>{'agilabId' => '476290', 'xdataId' => '204833','pfcIdList' => new List<String>{'25416344'}} );
        Test.stopTest();  
    }
    
}

}