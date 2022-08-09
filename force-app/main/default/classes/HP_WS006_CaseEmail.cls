/**
 * @File Name          : HP_WS006_CaseEmail.cls
 * @Description        : HAPP-978 API Custom : intégrer une demande de recontact comme un mail dans Salesforce
 * @Author             : Colince FOTSO
 * @Group              :
 * @Last Modified By   : Badr Eddine Belkarchi
 * @Last Modified On   : 12-29-2021
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    28/01/2020   Colince FOTSO     Initial Version
 **/
@RestResource(urlMapping='/case/email/*')
global class HP_WS006_CaseEmail {

	@HttpPost
	global static void requestForRecontact() {

		Datetime startCall = Datetime.now();
		RestResponse restResponse = RestContext.response;
		HP_WRP022_SFResponse response = new HP_WRP022_SFResponse(HP_HttpStatus.OK);
		final HP_WRP019_CaseEmail.Request req;
		try {
			String body = RestContext.request.requestBody.toString();
			req = (HP_WRP019_CaseEmail.Request) JSON.deserialize(body, HP_WRP019_CaseEmail.Request.class);
			if(req != null) {
				dataValidation(req,response);
			}
			if(response.errors.isEmpty()) {
					req.civility = (req.civility == 'monsieur') ? 'Mr' : 'Mme';
					Messaging.inboundEmail email = new Messaging.InboundEmail();
					email.toAddresses = new List<String> {req.emailAddress};
					email.plainTextBody = req.message;
					email.fromAddress = req.emailAddress;
					email.fromName = req.civility+' '+req.firstName+' '+req.lastName;
					email.subject = req.reason;
					email.replyTo =  req.streetNumber;
					email.messageId = req.postalCode; 
					email.htmlBody = req.message;//req.streetLabel; 
					email.references =  new List<String> {req.streetLabel};
					email.inReplyTo = req.town;
					if(req.attachments != null) {
						email.binaryAttachments = new List<Messaging.InboundEmail.BinaryAttachment>();
						for(HP_WRP019_CaseEmail.Attachment attachmt: req.attachments) {
							Messaging.InboundEmail.BinaryAttachment binAttacht = new Messaging.InboundEmail.BinaryAttachment();
							binAttacht.fileName = attachmt.filename;
							binAttacht.body =  EncodingUtil.base64decode(attachmt.body);
							email.binaryAttachments.add(binAttacht);
						}
					}
					Messaging.InboundEmailResult resp = (new HP_SM018_CaseEmail()).handleInboundEmail(email, null);
					if(resp.success == true) {
						response.code = HP_HttpStatus.OK;
						response.addInfo('SM018-0', 'Demande de recontact est envoyée, MessageId : ' +  email.messageId);
					}else{response.code = HP_HttpStatus.PRECONDITION_FAILED;}
				}
				else{
					response.code = HP_HttpStatus.NOT_ACCEPTABLE;
				}
			restResponse.statusCode = response.code;
			restResponse.responseBody = Blob.valueOf(JSON.serializePretty(response));

			}
		catch (Exception ex) {
			response.code = HP_HttpStatus.BAD_REQUEST;
			response.addError(ex.getMessage() + ', '+  ex.getStackTraceString(), String.valueOf(response.code));
			restResponse.statusCode = response.code;
			restResponse.responseBody = Blob.valueOf(JSON.serializePretty(response));
		}finally {
			RestContext.response.statusCode = response.code;
			RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(response));
			HP_UTIL_HTTPUtils.saveLogResponse(RestContext.request, restResponse, (Datetime.now().getTime() - startCall.getTime()));
		}
	}


	public static void dataValidation(HP_WRP019_CaseEmail.Request req, HP_WRP022_SFResponse response){
		String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
		Pattern MyPattern = Pattern.compile(emailRegex);
		Matcher MyMatcher = MyPattern.matcher(req.emailAddress);

		if(req.reason == null) {
			response.addError('SM018-1', 'The reason can\'t be null');
		}
		if(req.civility == null) {
			response.addError('SM018-2', 'The civility can\'t be null');
		}
		if(req.firstName== null) {
			response.addError('SM018-3','The firstname and lastname can\'t be null');
		}
		if(req.lastName == null) {
			response.addError('SM018-3', 'The firstname and lastname can\'t be null');
		}
		if(req.emailAddress == null || !MyMatcher.matches()) {
			response.addError('SM018-4', 'The email address can\'t be null or it does not respect de format');
		}
		if(req.Message == null) {
			response.addError('SM018-5', 'The message content must not be null');
		}

	}

}