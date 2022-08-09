@isTest
private class SM_AP58_Bptousr_TEST
{
	@isTest
	static void testUserCreation_NoContactCreation()
	{

		// Un user community va être créé - le owner du contact doit avoir un rôle
		UserRole[] roles = [SELECT Id FROM UserRole WHERE ParentRoleId = null];

		User currentUser = new User(Id = UserInfo.getUserId(), UserRoleId = roles[0].Id);
		update currentUser;

		System.runAs(currentUser){

			Test.startTest();

			Account anAccount = new Account(Name = 'My test account');
			insert anAccount;

			Contact aContact = new Contact(AccountId = anAccount.Id, Lastname = 'Test', Identifiant_Buisness_Partener__c = '1234');
			insert aContact;

			SM_Digsvc__c ds = new SM_Digsvc__c();
	        ds.orgurl__c = 'https://test.my.salesforce.com';
	        ds.striss__c = 'ClientSecret';
	        ds.usrnamepostfix__c = '@digital.engie.com';
	        ds.xdusr__c = UserInfo.getUserName();  
	        ds.communityUrl__c = 'https://randomurl.my.salesforce.com';  
	        ds.instanceType__c = 'test';   
	        ds.communityName__c = 'digital';
	        insert ds;
			
	        RestRequest request = new RestRequest();
	        request.addParameter('bp', aContact.Identifiant_Buisness_Partener__c);
	        request.requestUri ='/services/apexrest/bptousr';
	        request.httpMethod = 'GET';
			
	        RestContext.request = request;
			String username = SM_AP58_Bptousr.getusrid();

			User[] users = [SELECT Id FROM User WHERE ContactId =: aContact.Id];
			System.assertEquals(1, users.size());

			Test.stopTest();
		}
	}

	@isTest
	static void testUserCreation_ContactCreation()
	{
		// Un user community va être créé - le owner du contact doit avoir un rôle
		UserRole[] roles = [SELECT Id FROM UserRole WHERE ParentRoleId = null];

		User currentUser = new User(Id = UserInfo.getUserId(), UserRoleId = roles[0].Id);
		update currentUser;

		System.runAs(currentUser){

			Test.startTest();

			SM_Digsvc__c ds = new SM_Digsvc__c();
	        ds.orgurl__c = 'https://test.my.salesforce.com';
	        ds.striss__c = 'ClientSecret';
	        ds.usrnamepostfix__c = '@digital.engie.com';
	        ds.xdusr__c = UserInfo.getUserName();  
	        ds.communityUrl__c = 'https://randomurl.my.salesforce.com';  
	        ds.instanceType__c = 'test';   
	        ds.communityName__c = 'digital';
	        insert ds;
			
	        RestRequest request = new RestRequest();
	        request.addParameter('bp', '12345678');
	        request.requestUri ='/services/apexrest/bptousr';
	        request.httpMethod = 'GET';
			
	        RestContext.request = request;
			String username = SM_AP58_Bptousr.getusrid();

			Contact[] contacts = [SELECT Id FROM Contact WHERE Identifiant_Buisness_Partener__c = '12345678'];
			System.assertEquals(1, contacts.size());

			Test.stopTest();
		}
	}
}