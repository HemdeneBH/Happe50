/**
 * @File Name          : HP_EM021_CaseEmail.cls
 * @Description        :
 * @Author             : Colince FOTSO
 * @Group              :
 * @Last Modified By   : Badr Eddine Belkarchi
 * @Last Modified On   : 12-29-2021
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    28/01/2020   Colince FOTSO     Initial Version
**/
global class HP_EM021_CaseEmail {

	/**
	* @description créer le case, un mail avec fichiers joints
	* @author Colince FOTSO | 28/01/2020
	* @param Messaging.inboundEmail email
	* @return Messaging.InboundEmailResult
	**/
	global static Messaging.InboundEmailResult createCaseEmailWithAttachements(Messaging.inboundEmail email){

	Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
	List<String> toAddresses = email.toAddresses;
	System.debug('toAddresses: ' + toAddresses.size());

		try{
			if(toAddresses.size()>0){
				System.debug('In loop: ');
				Contact cont = getContactByEmail(email.fromAddress);
				ID idContact = (cont==null)?null:cont.id;
				List<Case> caseList = new List<Case>();
				//ZZZZCase newCase = new Case();
				Case newCase =(Case) HP_UTIL_SmartFactory.createSObject('Case',new Map<String, Object>{
            	'RecordtypeId' => (String) HP_UTIL_RecordType.getRecordTypeId('Case','HP_Mail'),
				'Description'=>email.plainTextBody,
				'SuppliedEmail'=>email.fromAddress,
				'SuppliedName'=> email.fromName,
				'Subject'=>email.subject,
				'HP_StreetNumber__c'=>email.replyTo,
				'HP_PostalCode__c'=>email.messageId,
				'HP_Town__c'=> email.inReplyTo,
				'HP_StreetLabel__c'=> email.references.get(0), //email.htmlBody,
				'Origin'=>'Email',
				'status'=>HP_SLCT_Case.Status.TO_DO.name(),
				'ContactId'=> idContact,
				'Reason'=>HP_SLCT_Case.Reason.HP_Recontact_Customer.name(),
				'HP_Type__c'=>HP_SLCT_Case.Type.HP_Form_Site.name()
				//'Ownerid' = '<assign OwnerId>';
        		},null);
				caseList.add(newCase);
				System.debug('caseList: ' + caseList);
			//perform case record insert operation.
			Database.SaveResult[] srList = Database.insert(caseList, true);
                 System.debug('OwnerId '+caseList[0].OwnerId);
			List<EmailMessage> lstEmailMessage = new List<EmailMessage>();
 			System.debug('srList: ' + srList.size());
			// Iterate through each returned result and create Email object for attaching to Case.
		 	for (Database.SaveResult sr : srList) {
				System.debug('srList: ' + srList.size());
				if (sr.isSuccess()){
					// Operation was successful, so get the ID of the record that was processed
					System.debug('sr.isSuccess(): ' + sr.isSuccess());
					EmailMessage emailMsgObj =(EmailMessage) HP_UTIL_SmartFactory.createSObject('EmailMessage',new Map<String, Object>{
						'HtmlBody'=>email.htmlBody,
						'TextBody'=>email.plainTextBody,
						'FromAddress'=> email.fromAddress,
						'FromName'=>email.fromName,
						'Subject'=>email.subject,
						'Incoming'=>true,
						'ParentId'=>sr.getId()
						},null);
					lstEmailMessage.add(emailMsgObj);
				}
			}
			Database.SaveResult[] srEmailList = Database.insert(lstEmailMessage, true);
			List<Attachment> lstAttachment = new List<Attachment>();

			//if attachment exists in inbound email those to be attached into Email record.
			for (Database.SaveResult sr : srEmailList) {
				if (sr.isSuccess()){
					if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
						for (integer i = 0 ; i < email.binaryAttachments.size() ; i++) {
							Attachment attachment =(Attachment) HP_UTIL_SmartFactory.createSObject('Attachment',new Map<String, Object>{
							'Name'=>email.binaryAttachments.get(i).fileName,
							'Body'=>email.binaryAttachments.get(i).body,
							'ParentId'=>sr.getId()
						},null);
							lstAttachment.add(attachment);
						}
					}
				}
			}
			Database.insert(lstAttachment, true);
			}
		}catch (Exception e) {
		//handle it properly.
		System.debug('Exeception catch Cause: ' + e.getCause());
		System.debug('Exeception catch message: ' + e.getMessage());
			result.success = false;
			result.message = e.getMessage();

			return result;
		}

	result.success = true;
	result.message = 'The recontact case is created with success';
	return result;
	}

	/**
	* @description
	* @author Colince FOTSO | 28/01/2020
	* @param String email
	* @return Contact
	**/
	private static Contact getContactByEmail(String email){
	 List<Contact> contactList = [SELECT id, Email, firstname,  lastname, salutation FROM Contact WHERE Email =:email];
	 if(!contactList.isEmpty()){
		 return contactList.get(0);
	 }
	 else {
		 return null;
	 }
	}

}