@isTest 
public with sharing class HP_EM022_SMSMessage_TEST {

    private enum StaticResource {
        HP_APIHourAccessTokenResponse_MOCK
    }

    
    @isTest static void execute(){

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                new Map<String, String> {'Content-Type' => 'application/json'}
            )
        
        };

        
        Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{
           
            'Id_Tiers__c' => 100166,
            'Salutation'=>'MR',
            'lastName' => 'testnicot',
            'firstName' => 'lenfant',
            'email' => 'user@example.com',
            'mobilePhone' => '0756543434',
            'Phone' => '0145454545',
            'No_Voie__c' => '22',
            'MailingStreet' => 'rue des bois',
            'MailingPostalCode' => '92160',
            'Complement_adresse__c' => 'REZID',
            'MailingCity' =>'ANTONY'
        }, null, null, null);
        insert contact;

    
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_EM022_SMSMessage.createSMSMessage( contact.Id);
        Test.stopTest();  
}

}