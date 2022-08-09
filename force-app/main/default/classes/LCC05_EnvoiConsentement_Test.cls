@isTest
private class LCC05_EnvoiConsentement_Test {

	@TestSetup
    static void makeData(){
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
        Profile p = [SELECT Id FROM Profile WHERE Name = 'MP_Admin' Limit 1];
        User u = new User(Alias = 'mp27test',
            Email = 'mp27test@gmail.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey='en_US',
            ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', 
            Username = 'mp27test@gmail.com'
        );
        insert u;
        Id rtId = [SELECT Id FROM RecordType WHERE SObjectType = 'Lead' AND DeveloperName = 'MyPower'].Id;
        Lead l = new Lead(
            Salutation = 'MR',
            FirstName = 'Lead',
            LastName = 'Test',
            Company = 'test s_Company@test.fr',
            ID_Tiers__c = 123,
            Phone = '0123456789',
            LeadSource = 'Sonnen',
            RecordTypeId = rtId
        );
        insert l;

    }

	@isTest static void testConsentement() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('MPConsentement'));
		Lead myLead = [SELECT Id,RecordTypeId FROM Lead WHERE LastName='Test'];
		Database.LeadConvert lc = new database.LeadConvert();
		lc.setLeadId(myLead.id);

		LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
		lc.setConvertedStatus(convertStatus.MasterLabel);
		Database.LeadConvertResult lcr = Database.convertLead(lc);
		Id contactId = lcr.getContactId();
        Test.startTest();
		String wrString=LCC05_EnvoiConsentement.initDatas(contactId);
        LCC05_EnvoiConsentement.ComponentDataWrapper wr =(LCC05_EnvoiConsentement.ComponentDataWrapper) JSON.deserialize(wrString, LCC05_EnvoiConsentement.ComponentDataWrapper.class);
		LCC05_EnvoiConsentement.sendXDataConsent(JSON.serialize(wr.lead));
        Test.stopTest();
	}
	
}