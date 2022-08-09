/**
 * @File Name          : HP_BAT001_Emailing.cls
 * @Description        : Batch récupération dans Salesforce des mails envoyés par Agilab au client
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 08-21-2020
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    07/04/2020   Sara El-Hannaoui     Initial Version
**/
global with sharing class HP_BAT001_Emailing implements Database.Batchable<HP_WRP025_PilotageEmails.ListeEmails>, Database.Stateful, Database.AllowsCallouts, Schedulable, Database.RaisesPlatformEvents, HP_UTIL_BatchInterface {

	public static final String SEPARATOR ='\n';
	public static final Integer BATCH_CHUNK_SIZE = 100;
	public Integer numberOfpage = 1;
	public Boolean chainAnotherbatch = true;

	public Datetime overrideStartDate = null;
	public Datetime overrideEndDate = null;

	global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT001_Emailing());
	}

	//constructeur normal
	global HP_BAT001_Emailing(){
	}

	//constructeur de rattrapage en cas d'ano
	global HP_BAT001_Emailing(Datetime startDate, Datetime endDate){
		this.overrideStartDate = startDate;	
		this.overrideEndDate = endDate;	
	}

	//constructeur appelé dans le finish pour chainer les batchs
	global HP_BAT001_Emailing(Integer numOfpage, Datetime startDate, Datetime endDate){
		this.numberOfpage = numOfpage;	
		this.overrideStartDate = startDate;	
		this.overrideEndDate = endDate;
	}

	//execute normal
	global static void execute(SchedulableContext sc){
		execute(1, null, null);
	}

	//execute de rattrapage en cas d'ano
	global static void execute(Datetime startDate, Datetime endDate){
		HP_BAT001_Emailing emailingBatch = new HP_BAT001_Emailing(startDate, endDate);
		Database.executeBatch(emailingBatch,BATCH_CHUNK_SIZE);
	}

	//execute appelé dans le finish pour chainer les batchs
	global static void execute(Integer numberOfpage, Datetime startDate, Datetime endDate){
		HP_BAT001_Emailing emailingBatch = new HP_BAT001_Emailing(numberOfpage, startDate, endDate);
		Database.executeBatch(emailingBatch,BATCH_CHUNK_SIZE);
	}

	public HP_WRP025_PilotageEmails.ListeEmails[] start(Database.BatchableContext batchableContext){
		
		List<HP_WRP025_PilotageEmails.ListeEmails> listEmails= new List<HP_WRP025_PilotageEmails.ListeEmails>();
		HP_WRP025_PilotageEmails emails;
		HP_Parameters__c param = HP_Parameters__c.getInstance();
		if(this.overrideStartDate != null && this.overrideEndDate != null){
			emails = HP_EM026_Pilotage.getEmails(String.valueOf(this.overrideStartDate),  String.valueOf(this.overrideEndDate), (String)param.get(HP_Constantes.AGILAB_ID_BATCH), (String)param.get(HP_Constantes.CONSUMER_BATCH), String.valueOf(this.numberOfpage));
		}
		else{
			emails = HP_EM026_Pilotage.getEmails(String.valueOf((Datetime) param.get(HP_Constantes.DATE_BATCH)),  String.valueOf(Datetime.now()), (String)param.get(HP_Constantes.AGILAB_ID_BATCH), (String)param.get(HP_Constantes.CONSUMER_BATCH), String.valueOf(this.numberOfpage));
		}
		if(emails != null && emails.data != null){
			listEmails.addAll(emails.data.listeEmails);
			System.debug('listEmails size '+listEmails.size());
			if(this.numberOfpage >= emails.data.totalPages){
				chainAnotherbatch = false;
			}
		}
		else{
			chainAnotherbatch = false;
		}		
		return listEmails;
	}


	public void execute(Database.BatchableContext batchableContext,List<HP_WRP025_PilotageEmails.ListeEmails> listEmails){
		if (listEmails.size() > 0) {
			saveEmailMessage(listEmails);
		}
	}

	private static void saveEmailMessage(List<HP_WRP025_PilotageEmails.ListeEmails> emails){

		List<EmailMessage> lstEmailMessageInsert = new List<EmailMessage>();
		Set<Integer> idClientSet = new Set<Integer>();
		Map<Contact, List<EmailMessage>> emailContactRelationship =  new Map<Contact, List<EmailMessage>>();
		for (HP_WRP025_PilotageEmails.ListeEmails email: emails) {
			idClientSet.add(email.idClient);
		}
		List<Contact> contactList = HP_SLCT_Contact.havingXdataId(idClientSet);
		for (Contact c : contactList) {
			List<EmailMessage> lstEmailMessage = new List<EmailMessage>();
			for (HP_WRP025_PilotageEmails.ListeEmails email : emails) {
				if (email.idClient == c.Id_Tiers__c) {
					EmailMessage emailMsg = createEmailMessage(lstEmailMessageInsert,email);
					lstEmailMessage.add(emailMsg);
				}
			}
			emailContactRelationship.put(c,lstEmailMessage);
		}
		System.debug('** EmailMessage to Insert size = ' + lstEmailMessageInsert.size());
		if (lstEmailMessageInsert.size()>0) {
			Database.UpsertResult[] srEmailList = Database.upsert(lstEmailMessageInsert,false);
			HP_BAT001_Emailing.catchError(srEmailList);
		}

		List<EmailMessageRelation> lstEmailMessageRelation = createEmailMessageRelation(emailContactRelationship);
		System.debug('** EmailMessageRelation to Insert size = ' + lstEmailMessageInsert.size());
		if (lstEmailMessageRelation.size()>0) {
			Database.UpsertResult[] srEmailRelationList = Database.upsert(lstEmailMessageRelation,false);
			HP_BAT001_Emailing.catchError(srEmailRelationList);
		}
	}

	private static void catchError(Database.UpsertResult[] listUpsert){
		for (Database.UpsertResult sr : listUpsert) {
			if (!sr.isSuccess()) {
				// Operation failed, so get all errors                
				for(Database.Error err : sr.getErrors()) {
					System.debug('The following error has occurred.');                    
					System.debug(err.getStatusCode() + ': ' + err.getMessage());
					System.debug('Fields that affected this error: ' + err.getFields());
				}
			}
		}
	}

	private static void updateDateOfLastExcution(Datetime lastExecutionDT) {
		String query = 'SELECT id ,'+ HP_Constantes.DATE_BATCH +' FROM HP_Parameters__c';
		HP_Parameters__c param = (HP_Parameters__c)Database.query(query);
		param.date_Emailing_Batch__c = lastExecutionDT;
		Database.update(param);
	}

	private static EmailMessage  createEmailMessage(List<EmailMessage> lstEmailMessageInsert, HP_WRP025_PilotageEmails.ListeEmails email){
		String[] contentList = splitString(email.content,SEPARATOR);
		String toaddress = contentList[1].substringAfter(' ');
		String subject = contentList[4].substringAfter(' ');
		String fromAddress = contentList[2].subStringBetween('"');
		String d = email.date_x;
		Datetime dt = DateTime.newInstance(Integer.valueOf(d.substring(0,4)), Integer.valueOf(d.substring(5,7)), Integer.valueOf(d.substring(8,10)), Integer.valueOf(d.substring(11,13)), Integer.valueOf(d.substring(14,16)), Integer.valueOf(d.substring(17,19)));
		EmailMessage emailMsgObj = new EmailMessage(
			HtmlBody = ( EncodingUtil.base64Decode((String)email.body).toString().length() > 131072 ?  EncodingUtil.base64Decode((String)email.body).toString().substring(0,131072) : EncodingUtil.base64Decode((String)email.body).toString()),
			FromAddress =  fromAddress,
			toAddress  = toaddress,
			Source__c = 'HP Agilab',
			Subject = subject.contains('UTF-8?Q?') ?  EncodingUtil.urlDecode( emailSubjectEncode(subject), 'UTF-8') : subject,
			Status = '3',
			MessageDate = dt,
			HP_FK_Pilotage__c = String.valueOf(email.id),
			Incoming = true
			);
		lstEmailMessageInsert.add(emailMsgObj);
		return emailMsgObj;
	}

	private static List<EmailMessageRelation> createEmailMessageRelation( Map<Contact,  List<EmailMessage>> emailContactRelationship){
		List<EmailMessageRelation> lstEmailMessageRelation = new List<EmailMessageRelation>();
		for(Contact c : emailContactRelationship.keySet()) {
			System.debug(c);
			for (EmailMessage emailMsg : emailContactRelationship.get(c)){
				EmailMessageRelation emr = new EmailMessageRelation(
				emailMessageId = emailMsg.id,
				relationId = c.Id,
				relationType = 'ToAddress'
				);
				lstEmailMessageRelation.add(emr);
			}	
		}
		return lstEmailMessageRelation;
	}

	private static String emailSubjectEncode(String str){
			String strEncoded = str.replace('=?UTF-8?Q?', '').substringBefore('?=');
			return  strEncoded.replaceAll('=', '%').replaceAll('_', '+');	
	}

	private static String[] splitString(String str, String separator) {
		return str.split(separator);
	}

	global void finish(Database.BatchableContext bc) {
	 	if(chainAnotherbatch){
			this.numberOfpage++;
			HP_BAT001_Emailing.execute(this.numberOfpage, this.overrideStartDate, this.overrideEndDate);
        }else{
			updateDateOfLastExcution(this.overrideEndDate == null ? datetime.now() : this.overrideEndDate);
            System.debug('Start method signalled that no need to chain another batch another batch job.');
        }
	}
}