@isTest//(SeeAllData=true)
public class SM_AP72_WAVECaseHandler_TEST {

    
    @testSetup
    public static void init(){
        contact contactTest = new contact(LastName ='test',FirstName='test') ;
        Account accountTest = new Account(Name ='AccountTest') ;
        insert accountTest ;
        Case caseTest = new Case(Account = accountTest,AccountId =accountTest.Id  ,Contact = contactTest );
        insert contactTest ;
        insert caseTest ;
    }
    
    
	public static testMethod void doTest_1() {

		// Test the constructor
		SM_AP72_WAVECaseHandler swa = new SM_AP72_WAVECaseHandler();

	}

	public static testMethod void doTest_2() {
		List<String> caseNumbers = new List<String>();
		List<Case> myCases = [SELECT AccountId,Account.Name,CaseNumber,ContactId,Contact.Name,Contact.Email,CreatedDate,Id,IsEscalated,Origin,OwnerId,Owner.Name,Owner.Email,ParentId,Priority,RecordTypeId,Status,Subject,SuppliedEmail,SuppliedName,SuppliedPhone,Type FROM Case LIMIT 20];
		for(Case ca : myCases) {
			caseNumbers.add(ca.CaseNumber);
		}
		SM_AP72_WAVECaseHandler.getMyCases(caseNumbers);

	}
    
    public static testMethod void doTest_8() {
		List<String> casesId = new List<String>();
		List<Case> myCases = [SELECT AccountId,Account.Name,CaseNumber,ContactId,Contact.Name,Contact.Email,CreatedDate,Id,IsEscalated,Origin,OwnerId,Owner.Name,Owner.Email,ParentId,Priority,RecordTypeId,Status,Subject,SuppliedEmail,SuppliedName,SuppliedPhone,Type FROM Case LIMIT 20];
		for(Case ca : myCases) {
			casesId.add(ca.Id);
		}
		SM_AP72_WAVECaseHandler.getMyCases(casesId);

	}
    

	public static testMethod void doTest_3() {
		List<Case> myCases = [SELECT AccountId,Account.Name,CaseNumber,ContactId,Contact.Name,Contact.Email,CreatedDate,Id,IsEscalated,Origin,OwnerId,Owner.Name,Owner.Email,ParentId,Priority,RecordTypeId,Status,Subject,SuppliedEmail,SuppliedName,SuppliedPhone,Type FROM Case LIMIT 20];
		SM_AP72_WAVECaseHandler.sendEmails('Testing', 'Tester', myCases);
	}

	public static testMethod void doTest_4() {
		List<Case> myCases = [SELECT AccountId,Account.Name,CaseNumber,ContactId,Contact.Name,Contact.Email,CreatedDate,Id,IsEscalated,Origin,OwnerId,Owner.Name,Owner.Email,ParentId,Priority,RecordTypeId,Status,Subject,SuppliedEmail,SuppliedName,SuppliedPhone,Type FROM Case LIMIT 20];
		User myUser = [SELECT Name, Id FROM User LIMIT 1];
		SM_AP72_WAVECaseHandler.reAssign(myUser.Id, myCases);
	}

	public static testMethod void doTest_5() {
		SM_AP72_WAVECaseHandler.getStandardUsers();
		SM_AP72_WAVECaseHandler.getAllQueues();
		SM_AP72_WAVECaseHandler.getPartnerUsers();
		SM_AP72_WAVECaseHandler.getCustomerUsers();
	}

	public static testMethod void doTest_6() {
		// Calling this test gives an error about calling webservices...
		//SWA_ApexController.passTheTest();

		List<Case> myCases = [SELECT AccountId,Account.Name,CaseNumber,ContactId,Contact.Name,Contact.Email,CreatedDate,Id,IsEscalated,Origin,OwnerId,Owner.Name,Owner.Email,ParentId,Priority,RecordTypeId,Status,Subject,SuppliedEmail,SuppliedName,SuppliedPhone,Type FROM Case LIMIT 20];
		//RecordType rt = [SELECT Id,IsActive,Name,SobjectType FROM RecordType WHERE IsActive=true AND SobjectType='Opportunity' LIMIT 1];
		SM_AP72_WAVECaseHandler.createMyOpps(myCases, 'testing', 'Qualification', '10/10/2010', 'Services', 1000, 'MyPower');
	}

	public static testMethod void doTest_7() {
		List<Case> myCases = [SELECT AccountId,Account.Name,CaseNumber,ContactId,Contact.Name,Contact.Email,CreatedDate,Id,IsEscalated,Origin,OwnerId,Owner.Name,Owner.Email,ParentId,Priority,RecordTypeId,Status,Subject,SuppliedEmail,SuppliedName,SuppliedPhone,Type FROM Case LIMIT 20];
		SM_AP72_WAVECaseHandler.updateEscalateCase('Escalate Cases', myCases);
		SM_AP72_WAVECaseHandler.updateEscalateCase('Remove from Escalated', myCases);
		SM_AP72_WAVECaseHandler.updatePriorityCase('High', myCases);
		SM_AP72_WAVECaseHandler.updateStatusCase('New', myCases);
		SM_AP72_WAVECaseHandler.updateTypeCase('General', myCases);
		SM_AP72_WAVECaseHandler.updateRecordTypeCase('Acquisition', myCases);
	}
    


}