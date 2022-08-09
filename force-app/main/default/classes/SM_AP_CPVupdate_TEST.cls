@isTest
private class SM_AP_CPVupdate_TEST {
	
	@isTest static void updateCPVEnergieOK() {
		Account newAcc = new Account(name='EngieTest');
		insert newAcc;
		Contact newContact = new Contact(LastName = 'Test', Email = 'test1@test.com',Identifiant_Buisness_Partener__c='121212');
		insert newContact;
		Order newOrder = new Order(AccountId=newAcc.Id,Numero_PC__c='01234',type__c = 'Gaz',EffectiveDate = Date.today(), Status = 'Draft');
		insert newOrder;
        List<Order> orders = [SELECT ID,OrderNumber FROM Order WHERE ID = :newOrder.ID];
        newOrder = orders.get(0);
        Case newCase = new Case(ContactId = newContact.Id,Order_Number__C=newOrder.OrderNumber);
        insert newCase;
        
        
        
       
        SM_AP_CPVupdate.CPVinfo cpv = new SM_AP_CPVupdate.CPVinfo();
        cpv.pcId='01234';
        cpv.bpId='121212';
        cpv.dateSignature='16/08/2018';
        cpv.urlPdf='http://test.com';
        cpv.canal='email';
		String response = SM_AP_CPVupdate.updateTheCPVs(new List<SM_AP_CPVupdate.CPVinfo>{cpv});
        
        System.assertEquals(response,'ok');
        
	}
	
	@isTest static void updateCPVServiceAffinitaireOK() {
		Account newAcc = new Account(name='EngieTest');
		insert newAcc;
		Contact newContact = new Contact(LastName = 'Test', Email = 'test1@test.com',Identifiant_Buisness_Partener__c='121212');
		insert newContact;
		Order newOrder = new Order(AccountId=newAcc.Id,Numero_PC__c='01234',type__c = 'SA',EffectiveDate = Date.today(), Status = 'Draft');
		insert newOrder;
        List<Order> orders = [SELECT ID,OrderNumber FROM Order WHERE ID = :newOrder.ID];
        newOrder = orders.get(0);
        Case newCase = new Case(ContactId = newContact.Id,Order_Number__C=newOrder.OrderNumber);
        insert newCase;
        
        
        
       
        SM_AP_CPVupdate.CPVinfo cpv = new SM_AP_CPVupdate.CPVinfo();
        cpv.pcId='01234';
        cpv.bpId='121212';
        cpv.dateSignature='16/08/2018';
        cpv.urlPdf='http://test.com';
        cpv.canal='email';
		String response = SM_AP_CPVupdate.updateTheCPVs(new List<SM_AP_CPVupdate.CPVinfo>{cpv});
        
        System.assertEquals(response,'ok');
	}
    
    @isTest static void updateCPVServiceKONoOrder() {
		Account newAcc = new Account(name='EngieTest');
		insert newAcc;
		Contact newContact = new Contact(LastName = 'Test', Email = 'test1@test.com',Identifiant_Buisness_Partener__c='121212');
		insert newContact;
		Order newOrder = new Order(AccountId=newAcc.Id,Numero_PC__c='01234',type__c = 'SA',EffectiveDate = Date.today(), Status = 'Draft');
		insert newOrder;
        List<Order> orders = [SELECT ID,OrderNumber FROM Order WHERE ID = :newOrder.ID];
        newOrder = orders.get(0);
        Case newCase = new Case(ContactId = newContact.Id,Order_Number__C=newOrder.OrderNumber);
        insert newCase;
        
        
        
       
        SM_AP_CPVupdate.CPVinfo cpv = new SM_AP_CPVupdate.CPVinfo();
        cpv.pcId='000000';
        cpv.bpId='121212';
        cpv.dateSignature='16/08/2018';
        cpv.urlPdf='http://test.com';
        cpv.canal='email';
		String response = SM_AP_CPVupdate.updateTheCPVs(new List<SM_AP_CPVupdate.CPVinfo>{cpv});
        
        System.assertEquals(response,'ok');
	}
    
    @isTest static void updateCPVServiceKONoCase() {
		Account newAcc = new Account(name='EngieTest');
		insert newAcc;
		Contact newContact = new Contact(LastName = 'Test', Email = 'test1@test.com',Identifiant_Buisness_Partener__c='121212');
		insert newContact;
		Order newOrder = new Order(AccountId=newAcc.Id,Numero_PC__c='01234',type__c = 'SA',EffectiveDate = Date.today(), Status = 'Draft');
		insert newOrder;
        List<Order> orders = [SELECT ID,OrderNumber FROM Order WHERE ID = :newOrder.ID];
        newOrder = orders.get(0);
        Case newCase = new Case(ContactId = newContact.Id,Order_Number__C='0000000');
        insert newCase;
        
        
        
       
        SM_AP_CPVupdate.CPVinfo cpv = new SM_AP_CPVupdate.CPVinfo();
        cpv.pcId='01234';
        cpv.bpId='00000';
        cpv.dateSignature='16/08/2018';
        cpv.urlPdf='http://test.com';
        cpv.canal='email';
		String response = SM_AP_CPVupdate.updateTheCPVs(new List<SM_AP_CPVupdate.CPVinfo>{cpv});
        
        System.assertEquals(response,'Unexcpected exception : No case found for a given pcID');
	}
	
}