@isTest
private class SM_AP_CPVupdate_TEST {
	
	@isTest static void updateCPVEnergieOK() {
		Account newAcc = new Account(name='EngieTest');
		insert newAcc;
		Contact newContact = new Contact(LastName = 'Test', Email = 'test1@test.com',Identifiant_Buisness_Partener__c='121212',RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Smile').getRecordTypeId());
		insert newContact;
        Case newCase = new Case(ContactId = newContact.Id,RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Acquisition').getRecordTypeId());
        insert newCase;
        Case newCase1 = new Case(ContactId = newContact.Id,RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Acquisition Harmonica').getRecordTypeId());
        insert newCase1;
        Order newOrder = new Order(AccountId=newAcc.Id,Case__c = newCase.Id, Numero_PC__c='01234',type__c = 'Gaz',EffectiveDate = Date.today(), Status = 'Draft',RecordTypeId=Schema.SObjectType.Order.getRecordTypeInfosByName().get('SMILE').getRecordTypeId());
		insert newOrder;
        Order newOrder1 = new Order(AccountId=newAcc.Id,Case__c = newCase1.Id, Numero_PC__c='01235',type__c = 'Gaz',EffectiveDate = Date.today(), Status = 'Draft',RecordTypeId=Schema.SObjectType.Order.getRecordTypeInfosByName().get('SMILE').getRecordTypeId());
		insert newOrder1;
        Case newCase2 = new Case(ContactId = newContact.Id,RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Détection de projet C').getRecordTypeId());
        insert newCase2;
        Order newOrder2 = new Order(AccountId=newAcc.Id,Case__c = newCase2.Id, Numero_PC__c='01236',type__c = 'Gaz',EffectiveDate = Date.today(), Status = 'Draft',RecordTypeId=Schema.SObjectType.Order.getRecordTypeInfosByName().get('SMILE').getRecordTypeId());
		insert newOrder2;
        
       
        SM_AP_CPVupdate.CPVinfo cpv = new SM_AP_CPVupdate.CPVinfo();
        cpv.pcId='01234';
        cpv.bpId='121212';
        cpv.dateSignature='17/02/2022';
        cpv.urlPdf='http://test.com';
        cpv.canal='email';
        
        SM_AP_CPVupdate.CPVinfo cpv1 = new SM_AP_CPVupdate.CPVinfo();
        cpv1.pcId='01235';
        cpv1.bpId='121212';
        cpv1.dateSignature='17/02/2022';
        cpv1.urlPdf='http://test.com';
        cpv1.canal='email';
        
		String response = SM_AP_CPVupdate.updateTheCPVs(new List<SM_AP_CPVupdate.CPVinfo>{cpv,cpv1});
        
        System.assertEquals(response,'ok');
        
	}
	


    @isTest static void updateCPVServiceKONoOrder() {
		Account newAcc = new Account(name='EngieTest');
		insert newAcc;
		Contact newContact = new Contact(LastName = 'Test', Email = 'test1@test.com',Identifiant_Buisness_Partener__c='121212',RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Smile').getRecordTypeId());
		insert newContact;
        Case newCase = new Case(ContactId = newContact.Id,RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Acquisition').getRecordTypeId());
        insert newCase;
        Order newOrder = new Order(AccountId=newAcc.Id,Numero_PC__c='01234',Case__c = newCase.Id, type__c = 'SA',EffectiveDate = Date.today(), Status = 'Draft',RecordTypeId=Schema.SObjectType.Order.getRecordTypeInfosByName().get('SMILE').getRecordTypeId());
		insert newOrder;
        
        
       
        SM_AP_CPVupdate.CPVinfo cpv = new SM_AP_CPVupdate.CPVinfo();
        cpv.pcId='000000';
        cpv.bpId='121212';
        cpv.dateSignature='16/02/2022';
        cpv.urlPdf='http://test.com';
        cpv.canal='email';
		String response = SM_AP_CPVupdate.updateTheCPVs(new List<SM_AP_CPVupdate.CPVinfo>{cpv});
        System.debug('### aka json input ' + JSON.serialize(new List<SM_AP_CPVupdate.CPVinfo>{cpv}));
        System.assertEquals(response,'ok');
	}
	
}