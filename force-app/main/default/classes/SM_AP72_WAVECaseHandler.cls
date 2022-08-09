public with sharing class SM_AP72_WAVECaseHandler {
	public String query { get; set; }

	public List<String> myOppStatus { get; set; }
	public List<String> myOppTypes { get; set; }
	public List<String> myOppRecordTypes { get; set; }

	public List<String> caseRecordTypes { get; set; }
	public List<String> casePriorityPL { get; set; }
	public List<String> caseStatusPL { get; set; }
	public List<String> caseTypePL { get; set; }

	// CONTROLLER
	// *****************************************************************************************************

	public SM_AP72_WAVECaseHandler() {
		// Get the Opportunity Stage Names
		List<String> pickListValuesList = new List<String>();
 		Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
 		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
 		for( Schema.PicklistEntry pickListVal : ple){
 			pickListValuesList.add(pickListVal.getLabel());
 		}
 		myOppStatus = pickListValuesList;

		// Case Priority Picklist
		List<String> pickListValuesList2 = new List<String>();
 		Schema.DescribeFieldResult fieldResult2 = Case.Priority.getDescribe();
 		List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
 		for( Schema.PicklistEntry pickListVal2 : ple2) {
 			pickListValuesList2.add(pickListVal2.getLabel());
 		}
 		casePriorityPL = pickListValuesList2;

		// Case Status Picklist
		List<String> pickListValuesList3 = new List<String>();
		Schema.DescribeFieldResult fieldResult3 = Case.Status.getDescribe();
		List<Schema.PicklistEntry> ple3 = fieldResult3.getPicklistValues();
		for( Schema.PicklistEntry pickListVal3 : ple3) {
			pickListValuesList3.add(pickListVal3.getLabel());
		}
		caseStatusPL = pickListValuesList3;

		// Case Type Picklist
		List<String> pickListValuesList4 = new List<String>();
		Schema.DescribeFieldResult fieldResult4 = Case.Type.getDescribe();
		List<Schema.PicklistEntry> ple4 = fieldResult4.getPicklistValues();
		for( Schema.PicklistEntry pickListVal4 : ple4) {
			pickListValuesList4.add(pickListVal4.getLabel());
		}
		caseTypePL = pickListValuesList4;

		// Opportunity Type Picklist
		List<String> pickListValuesList5 = new List<String>();
		Schema.DescribeFieldResult fieldResult5 = Opportunity.Type.getDescribe();
		List<Schema.PicklistEntry> ple5 = fieldResult5.getPicklistValues();
		for( Schema.PicklistEntry pickListVal5 : ple5) {
			pickListValuesList5.add(pickListVal5.getLabel());
		}
		myOppTypes = pickListValuesList5;

		caseRecordTypes = new List<String>();
		List<RecordType> tempRecordTypes = [SELECT Id,IsActive,Name,SobjectType FROM RecordType WHERE IsActive=true AND SobjectType='Case'];
		for(RecordType rt : tempRecordTypes) {
			caseRecordTypes.add(rt.Name);
		}

		myOppRecordTypes = new List<String>();
		List<RecordType> tempRecordTypes2 = [SELECT Id,IsActive,Name,SobjectType FROM RecordType WHERE IsActive=true AND SobjectType='Opportunity'];
		for(RecordType rt : tempRecordTypes2) {
			myOppRecordTypes.add(rt.Name);
		}
	}

	// INIT - Get the Query
	// *****************************************************************************************************

	public PageReference init() {
        query = ApexPages.currentPage().getParameters().get('query');
		System.debug('coshea : query : ' + query);
        return null;
    }

	// CASES - Get the cases from the query
	// *****************************************************************************************************

	@remoteAction
	public Static List<Case> getMyCases(List<String> caseNumbers) {
        System.debug('input cases==> '+caseNumbers);
		List<Case> myCases = new List<Case>();
		for(Case ca : [SELECT AccountId,Account.Name,CaseNumber,ContactId,Contact.Name,Contact.Email,CreatedDate,Id,IsEscalated,Origin,OwnerId,Owner.Name,Owner.Email,ParentId,Priority,RecordTypeId,Status,Subject,SuppliedEmail,SuppliedName,SuppliedPhone,Type FROM Case WHERE CaseNumber IN: caseNumbers ORDER BY CaseNumber DESC]) {
			myCases.add(ca);
		}
        System.debug('input myCases==> '+myCases);
		return myCases;
	}
    
    
    // CASES - Get the cases from the query ; input : CaseId
	// *****************************************************************************************************

	@remoteAction
	public Static List<Case> getMyCasesfromIds(List<String> CasesId) {
        System.debug('input cases==> '+CasesId);
		List<Case> myCases = new List<Case>();
		for(Case ca : [SELECT AccountId,Account.Name,CaseNumber,ContactId,Contact.Name,Contact.Email,CreatedDate,Id,IsEscalated,Origin,OwnerId,Owner.Name,Owner.Email,ParentId,Priority,RecordTypeId,Status,Subject,SuppliedEmail,SuppliedName,SuppliedPhone,Type FROM Case WHERE Id IN: CasesId ORDER BY CaseNumber DESC]) {
			myCases.add(ca);
		}
        System.debug('input myCases==> '+myCases);
		return myCases;
	}

	// SEND EMAILS
	// ****************************************************************************************************

	@remoteAction
	public Static String sendEmails(String emailSubject, String emailBody, List<Case> myCases) {
		Organization myOrg = [SELECT Id,InstanceName,Name,OrganizationType FROM Organization LIMIT 1];
		List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
		List<Task> emailTasks = new List<Task>();

		for(Case cs : myCases) {
			if(cs.ContactId != null) {
				String tempSubject = fixMyEmails(emailSubject, cs);
				String tempBody = fixMyEmails(emailBody, cs);

				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

				// Step 2: Set list of people who should get the email
				List<String> sendTo = new List<String>();
				sendTo.add(cs.ContactId);
				mail.setToAddresses(sendTo);
				mail.setReplyTo(cs.Owner.Email);
				// this should be the company name
				mail.setSenderDisplayName(myOrg.Name);
				mail.setSubject(tempSubject);
				mail.setHtmlBody('<p>' + tempBody + '</p>');
				mails.add(mail);

				// Come back to this

				// Task tsk = new Task();
				// tsk.WhoId = cs.ContactId;
				// tsk.Subject = 'Email: ' + tempSubject;
			}
		}
		try {
			Messaging.sendEmail(mails);
			return 'worked!';
		} catch(Exception excep) {
			System.debug(excep.getMessage());
			return excep.getMessage();
		}
	}

	public Static String fixMyEmails(String str, Case myCase) {
		if(str.contains('[Account]')) {
			str = str.replace('[Account]', myCase.Account.Name);
		}
		if(str.contains('[CaseNumber]')) {
			str = str.replace('[CaseNumber]', myCase.CaseNumber);
		}
		if(str.contains('[CaseOwner]')) {
			str = str.replace('[CaseOwner]', myCase.Owner.Name);
		}
		if(str.contains('[ContactName]')) {
			str = str.replace('[ContactName]', myCase.Contact.Name);
		}
		if(str.contains('[Subject]')) {
			str = str.replace('[Subject]', myCase.Subject);
		}
		if(str.contains('[Status]')) {
			str = str.replace('[Status]', myCase.Status);
		}
		return str;
	}

	// REASSIGN
	// *****************************************************************************************************

	@remoteAction
	public Static String reAssign(String userId, List<Case> myCases) {
		for(Case ca : myCases) {
			ca.OwnerId = userId;
		}
		// update myCases;
		Database.update(myCases, false);
		return 'worked!';
	}


	@remoteAction
	public Static List<User> getStandardUsers() {
		return [SELECT Id,Name,UserType FROM User WHERE UserType='Standard' ORDER BY NAME ASC];
	}

	@remoteAction
	public Static List<Group> getAllQueues() {
		return [SELECT Id,Name,Type FROM Group WHERE Type='Queue' ORDER BY NAME ASC];
	}

	@remoteAction
	public Static List<User> getPartnerUsers() {
		return [SELECT Id,Name,UserType FROM User WHERE UserType='PowerPartner' ORDER BY NAME ASC];
	}

	@remoteAction
	public Static List<User> getCustomerUsers() {
		return [SELECT Id,Name,UserType FROM User WHERE UserType='CSPLitePortal' OR  UserType='CustomerSuccess' OR  UserType='PowerCustomerSuccess' ORDER BY NAME ASC];
	}

	// CREATE OPPORTUNITIES
	// *****************************************************************************************************

	@remoteAction
	public Static List<Opportunity> createMyOpps(List<Case> myCases, String oppName, String oppStageName, String oppCloseDate, String oppType, Decimal oppAmount, String oppRecordType) {
		List<Opportunity> returnList = new List<Opportunity>();
		RecordType rt = [SELECT Id,IsActive,Name,SobjectType FROM RecordType WHERE IsActive=true AND SobjectType='Opportunity' AND Name=:oppRecordType];

		// List <String> dateParts = oppCloseDate.split('/');
		// Date tempDate = date.parse(dateParts[1]+'/'+dateParts[0]+'/'+dateParts[2]);
		// Date closeDate = date.newInstance(tempDate.year(), tempDate.month(),tempDate.day());

		Date closeDate;
        try {
            List <String> dateParts = oppCloseDate.split('/');
			Date tempDate = date.parse(dateParts[1]+'/'+dateParts[0]+'/'+dateParts[2]);
			closeDate = date.newInstance(tempDate.year(), tempDate.month(),tempDate.day());
        }catch(Exception excep) {
            System.debug('coshea : ' + excep.getMessage());
            List <String> dateParts = oppCloseDate.split('/');
			Date tempDate = date.parse(dateParts[0]+'/'+dateParts[1]+'/'+dateParts[2]);
			closeDate = date.newInstance(tempDate.year(), tempDate.month(),tempDate.day());
        }


		for(Case ca : myCases) {
			if(ca.AccountId != null) {
				Opportunity opp = new Opportunity();
				opp.AccountId = ca.AccountId;
				opp.Name = ca.Account.Name + ' - ' + oppName;
				opp.CloseDate = closeDate;
				opp.StageName = oppStageName;
				opp.Type = oppType;
				opp.Amount = oppAmount;
				opp.RecordTypeId = rt.Id;
				returnList.add(opp);
			}
		}

		Database.SaveResult[] srList = Database.insert(returnList, false);
		for (Database.SaveResult sr : srList) {
    		if (sr.isSuccess()) {
        		System.debug('Successfully inserted Opportunity. Opportunity ID: ' + sr.getId());
    		}
    		else {
        		for(Database.Error err : sr.getErrors()) {
            		System.debug('The following error has occurred.');
            		System.debug(err.getStatusCode() + ': ' + err.getMessage());
            		System.debug('Account fields that affected this error: ' + err.getFields());
        		}
    		}
		}
		return returnList;
	}


	// UPDATE METHODS
	// *****************************************************************************************************

	@remoteAction
	public Static String updateEscalateCase(String str, List<Case> myCases) {
		String retVal = 'Nothing happened';
		if(str == 'Escalate Cases') {
			for(Case cs : myCases) {
				cs.IsEscalated = true;
			}
			Database.SaveResult[] srList = Database.update(myCases, false);
			retVal = 'Cases Escalated';
		}
		if(str == 'Remove from Escalated') {
			for(Case cs : myCases) {
				cs.IsEscalated = false;
			}
			Database.SaveResult[] srList = Database.update(myCases, false);
			retVal = 'Cases Escalated';
		}
		return retVal;
	}

	@remoteAction
	public Static String updatePriorityCase(String str, List<Case> myCases) {
		for(Case cs : myCases) {
			cs.Priority = str;
		}
		Database.SaveResult[] srList = Database.update(myCases, false);
		return 'worked';
	}

	@remoteAction
	public Static String updateStatusCase(String str, List<Case> myCases) {
		for(Case cs : myCases) {
			cs.Status = str;
		}
		Database.SaveResult[] srList = Database.update(myCases, false);
		return 'worked';
	}

	@remoteAction
	public Static String updateTypeCase(String str, List<Case> myCases) {
		for(Case cs : myCases) {
			cs.Type = str;
		}
		Database.SaveResult[] srList = Database.update(myCases, false);
		return 'worked';
	}

	@remoteAction
	public Static String updateRecordTypeCase(String str, List<Case> myCases) {
		RecordType rt = [SELECT Id,IsActive,Name,SobjectType FROM RecordType WHERE IsActive=true AND SobjectType='Case' AND Name=:str LIMIT 1];
		for(Case cs : myCases) {
			cs.RecordTypeId = rt.Id;
		}
		Database.SaveResult[] srList = Database.update(myCases, false);
		return 'worked';
	}

	// POST TO CHATTER
	// *****************************************************************************************************

	// @remoteAction
	// public Static List<String> postToChatter(Boolean mentionContact, Boolean mentionAccount, Boolean mentionOwner, String myChatterPost, List<Case> myCases) {
	// 	List<String> retList = new List<String>();
	// 	String usrId = UserInfo.getUserId();
	// 	for(Case ca : myCases) {
	// 		try {
	// 			ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
	// 			ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
	// 			ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
	// 			ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
	//
	// 			messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
	//
	// 			mentionSegmentInput.id = usrId;
	// 			messageBodyInput.messageSegments.add(mentionSegmentInput);
	//
	// 			textSegmentInput.text = myChatterPost;
	// 			messageBodyInput.messageSegments.add(textSegmentInput);
	//
	// 			feedItemInput.body = messageBodyInput;
	// 			feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
	// 			feedItemInput.subjectId = ca.Id;
	// 			// feedItemInput.subjectId = 'SOME RECORD ID';
	//
	// 			ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
	//
	// 		} catch(Exception excep) {
	// 			retList.add(excep.getMessage());
	// 		}
	// 	}
	// 	return retList;
	//
	//
	// 		List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
	// 		for(Case a : myCases) {
	// 			System.debug('Coshea : Case : ' + a);
	// 			ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
	// 			input.subjectId = a.Id;
	//
	// 			ConnectApi.MessageBodyInput body = new ConnectApi.MessageBodyInput();
	// 			body.messageSegments = new List<ConnectApi.MessageSegmentInput>();
	//
	// 			ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
	// 			textSegment.text = myChatterPost;
	// 			body.messageSegments.add(textSegment);
	//
	// 			if(mentionContact == true) {
	// 				ConnectApi.MentionSegmentInput mentionSegmentInput1 = new ConnectApi.MentionSegmentInput();
	// 				mentionSegmentInput1.id = a.ContactId;
	// 				body.messageSegments.add(mentionSegmentInput1);
	// 			}
	// 			if(mentionOwner == true) {
	// 				ConnectApi.MentionSegmentInput mentionSegmentInput1 = new ConnectApi.MentionSegmentInput();
	// 				mentionSegmentInput1.id = a.OwnerId;
	// 				body.messageSegments.add(mentionSegmentInput1);
	// 			}
	//
	// 			input.body = body;
	// 			ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(input);
	// 			batchInputs.add(batchInput);
	// 		}
	// 		ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchInputs);
	// 		return 'worked';
	//
	//
	// }




}