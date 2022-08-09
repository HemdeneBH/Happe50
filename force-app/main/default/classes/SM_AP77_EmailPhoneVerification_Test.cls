@isTest
global class SM_AP77_EmailPhoneVerification_Test {
    public static Id contactRecordTypeId = SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact_Smile').getRecordTypeId();
    @TestSetup
    static void setup(){
        MP_Xdata_credentials__c sm_api_key_digital_INT = new MP_Xdata_credentials__c();
        sm_api_key_digital_INT.Value__c = 'test';
        sm_api_key_digital_INT.Name = 'sm_api_key_digital_INT';
        insert sm_api_key_digital_INT;
        MP_Xdata_credentials__c sm_digital_id_client = new MP_Xdata_credentials__c();
        sm_digital_id_client.Value__c = 'test';
        sm_digital_id_client.Name = 'sm_digital_id_client';
        insert sm_digital_id_client;
        MP_Xdata_credentials__c sm_digital_secret_client = new MP_Xdata_credentials__c();
        sm_digital_secret_client.Value__c = 'test';
        sm_digital_secret_client.Name = 'sm_digital_secret_client';
        insert sm_digital_secret_client;
    }

    @isTest
    global static void testVerificationEmail(){
        SM_AP77_EmailPhoneVerificationService.coverageCode('test1@test.com');
        
        //GIVEN
        Account newAcc = new Account(name='EngieTest');
        insert newAcc;
        Contact newContact = new Contact(LastName = 'Test', Email = 'test1@test.com',Identifiant_Buisness_Partener__c='121212',Adresse_Mail_2__c='test2@test.com',RecordTypeId=contactRecordTypeId);
        insert newContact;
        Map<String,Object> input = new Map<String,Object>{
            'email1' => 'test111@test.com',
            'email2' => 'test222@test.com',
            'email3' => 'email3@test.com',
            'contactId'=> newContact.Id,
            'service' => 'updateContact'
        };
        Map<String,Object> output = new Map<String,Object>();
        
        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SM_MockResponseApiLookUpEmail');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        	
        HttpRequest request = new HttpRequest();
        HttpResponse response = new Http().send(request);
        system.debug(response.getBody());
        //WHEN 
        SM_AP77_EmailPhoneVerificationService service = new SM_AP77_EmailPhoneVerificationService();
        service.invokeMethod('verifyEmails',input,output,null);

        //THEN
        System.assertEquals('OK', (String)output.get('email1'));
        System.assertEquals('OK', (String)output.get('email2'));
        System.assertEquals('OK', (String)output.get('email3'));
        
        //TEST LWC 
        output = SM_AP77_EmailPhoneVerificationService.invokeMethodLWC('verifyEmails',input,null); 
        System.assertEquals('OK', (String)output.get('email1'));
        System.assertEquals('OK', (String)output.get('email2'));
        System.assertEquals('OK', (String)output.get('email3'));

        Test.stopTest();
    }

     @isTest
    global static void testVerificationPhoneNumbers(){
        //GIVEN
        Account newAcc = new Account(name='EngieTest');
        insert newAcc;
        Contact newContact = new Contact(LastName = 'Test', MobilePhone = '+33734321232',Identifiant_Buisness_Partener__c='121212',Phone='+33976343212',RecordTypeId=contactRecordTypeId);
        insert newContact;
        Map<String,Object> input = new Map<String,Object>{
            'mobile1' => '0734321221',
            'phone1' => '0976312212',
            'mobile2' => '0634321221',
            'phone2' => '0834321221',
            'contactId'=> newContact.Id,
            'service' => 'updateContact'
        };
         Map<String,Object> output = new Map<String,Object>();
        
        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SM_MockResponseApiLookUpPhone');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);

        //WHEN 
        SM_AP77_EmailPhoneVerificationService service = new SM_AP77_EmailPhoneVerificationService();
        service.invokeMethod('verifyPhoneNumbers',input,output,null);


        //THEN
        /*
        System.assertEquals('OK', (String)output.get('mobile1'));
        System.assertEquals('OK', (String)output.get('mobile2'));
        System.assertEquals('OK', (String)output.get('phone1'));
        System.assertEquals('OK', (String)output.get('phone2'));

        //TEST LWC 
        output = SM_AP77_EmailPhoneVerificationService.invokeMethodLWC('verifyPhoneNumbers',input,null); 
        System.assertEquals('OK', (String)output.get('mobile1'));
        System.assertEquals('OK', (String)output.get('mobile2'));
        System.assertEquals('OK', (String)output.get('phone1'));
        System.assertEquals('OK', (String)output.get('phone2'));
        */
        Test.stopTest();
    }

}