@IsTest
public with sharing class HP_UTIL_Vue360ProTranContrat_TEST {

    private enum StaticResource {
        HP_APIHourAccessTokenResponse_MOCK,
        HP_SM003_Tranquility_Contrat_TEST
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
                
                'v2/rest/tranquillity/Contracts/getContrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                StaticResource.HP_SM003_Tranquility_Contrat_TEST.name(),
                new Map<String, String> { 'Content-Type' => 'application/json'})
            
            };
    
            String param = '{"data":{"status":"SUCCESS","message": "","output":{"id": 477361}}}';
        
            Test.startTest();
            RestContext.response= new RestResponse();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
            String res = JSON.serialize(HP_UTIL_Vue360ProcessTranquilityContrat.processing( (Object)System.JSON.deserializeUntyped(param),null));
            HP_WRP0015_TranquilityContractInfo response = (HP_WRP0015_TranquilityContractInfo) JSON.deserialize(res,HP_WRP0015_TranquilityContractInfo.class);
            Test.stopTest();  
            System.assert (response.messageRetour.code == 'SUCCESS', 'code SUCCESS');
        }
      
}
}