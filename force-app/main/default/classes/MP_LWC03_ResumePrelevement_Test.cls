@isTest
public with sharing class MP_LWC03_ResumePrelevement_Test {

    @TestSetup
    static void makeData() {
        MP_Generics_Endpoints__c api_endpoint_myp = new MP_Generics_Endpoints__c(
            EndPoint__c = 'callout:MPMyPowerApihour/api/apiset',
            Name = 'api_endpoint_myp_xdata'
        );
        insert api_endpoint_myp;
        MP_Generics_Endpoints__c api_endpoint_myp_p = new MP_Generics_Endpoints__c(
            EndPoint__c = 'callout:MPMyPowerApihour/api/mypower/',
            Name = 'api_endpoint_myp_protected'
        );
        insert api_endpoint_myp_p;
        
        MP_Generics_Endpoints__c api_endpoint = new MP_Generics_Endpoints__c(
            EndPoint__c = 'https://auth.ext.rec.api.engie.fr',
            Name = 'api_endpoint'
        );
        insert api_endpoint;
        MP_Xdata_credentials__c mpoc_api_version = new MP_Xdata_credentials__c(
            Value__c = '0.1',
            Name = 'mpoc_api_version'
        );
        insert mpoc_api_version;
        MP_Xdata_credentials__c sm_api_version = new MP_Xdata_credentials__c(
            Value__c = '0.1',
            Name = 'sm_api_version'
        );
        insert sm_api_version;
        MP_Xdata_credentials__c mpoc_api_key = new MP_Xdata_credentials__c(
            Value__c = '1',
            Name = 'mpoc_api_key'
        );
        insert mpoc_api_key;
        MP_Xdata_credentials__c mpoc_x_authorization = new MP_Xdata_credentials__c(
            Value__c = '1',
            Name = 'mpoc_x_authorization'
        );
        insert mpoc_x_authorization;
        MP_Xdata_credentials__c mpoc_client_id = new MP_Xdata_credentials__c(
            Value__c = 'clientId',
            Name = 'mpoc_client_id'
        );
        insert mpoc_client_id;
        MP_Xdata_credentials__c mpoc_client_secret = new MP_Xdata_credentials__c(
            Value__c = 'clientSecret',
            Name = 'mpoc_client_secret'
        );
        insert mpoc_client_secret;
        MP_Xdata_credentials__c mpoc_scope = new MP_Xdata_credentials__c(
            Value__c = 'mypower-secured',
            Name = 'mpoc_scope'
        );
        insert mpoc_scope;

        Account acc = new Account(Name = 'AccTest@test.com');
        insert acc;

        Contact c = new Contact(
            AccountId = acc.Id,
            LastName = 'LastNameTest',
            FirstName = 'FirstNameTest',
            ID_Tiers__c = 1,
            Email = 'test@gmail.fr',
            MobilePhone = '0612345678'
        );
        insert c;

        Opportunity opp = new Opportunity(
            Name = 'opp test',
            StageName = 'Devis',
            AccountId = acc.Id,
            CloseDate = Date.today(),
            MP_ID_Tiers__c = 123,
            ID_Processus__c = 1,
            vlocity_cmt__Email__c = 'test@yopmail.com'
        );
        insert opp;   
    }

    private class MP_LWC01_Paiement_Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            System.debug('httpReq test : '+req.getEndpoint());
            if (req.getEndpoint() == 'callout:MPAuthApihour/auth/oauth/v2/token') {
                res.setBody('{"access_token": "852f9dd0-19d1-486d-ad65-c19600bd6388","token_type": "Bearer","expires_in": 3600,"scope": "mypower-protected"}');
                res.setStatusCode(200);
            } else if (req.getEndpoint().startsWith(MP_Generics_Endpoints__c.getInstance('api_endpoint_myp_xdata').EndPoint__c + '/0.2/mandats?idPersonne=')) {
                string vdata = '{"_data":[]}';
                res.setBody(vdata);
                res.setStatusCode(201);
            } else if (req.getEndpoint() == MP_Generics_Endpoints__c.getInstance('api_endpoint_myp_protected').EndPoint__c + MP_Xdata_credentials__c.getInstance('mpoc_api_version').Value__c +'/protected/payment/paymentScheduleInstance/list') {
                string vdata = '{"code":"200", "message":"OK"}';
                res.setBody(vdata);
                res.setStatusCode(200);
            }
            else if (req.getEndpoint() == MP_Generics_Endpoints__c.getInstance('api_endpoint_myp_protected').EndPoint__c + MP_Xdata_credentials__c.getInstance('mpoc_api_version').Value__c +'/protected/inbound/ENGIE/directDebitPayment/list') {
                string vdata = '{"_data":[]}';
                res.setBody(vdata);
                res.setStatusCode(200);
            }
            return res;
        }
    }

    @isTest
    public static void testFunc() {
        Map<String,String> data = new Map<String,String>();
        Contact c = [SELECT Id, Name FROM Contact LIMIT 1];

        Test.setMock(HttpCalloutMock.class, new MP_LWC01_Paiement_Mock());  
        Test.startTest();   
        MP_LWC03_ResumePrelevement.getIDTiers(c.Id);
        MP_LWC03_ResumePrelevement.getMandat(c.Id);
        MP_LWC03_ResumePrelevement.getAllPrelevements('0');
        MP_LWC03_ResumePrelevement.getRefusPrelevements(c.Id);
        Test.stopTest();        
    }
}