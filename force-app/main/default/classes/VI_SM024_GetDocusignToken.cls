/*
*@Author: Paul Ghousoub
*@Description: Récupération du token docusign
*@CreatedDate: 2/12/2020
*@LastModified: 29/12/2021
*/
public class VI_SM024_GetDocusignToken { 
    //Get Rest Configuration Setings from Custom Metadata provided as a part of the installation source 
    private static Map<String, VI_DocuSignRESTSetting__mdt> settingsMap { 
        //Getter Method
        get {
            //populate only if settingsMap is createSignatureLinknull
            if (settingsMap == null) {
                settingsMap = new Map<String, VI_DocuSignRESTSetting__mdt>();   
                //Query the Custom Metadata and add it to the Map
                //Query against Custom Metadata does not count against the SOQL query Limit
                for (VI_DocuSignRESTSetting__mdt setting : [Select DeveloperName,MasterLabel, Value__c from VI_DocuSignRESTSetting__mdt]) {
                    settingsMap.put(setting.MasterLabel, setting);
                }
            }
            return settingsMap;
        }
        //Blank Setter Method
        set {
        }
    }
    
    public static httpRequest constructHeader(httpRequest request){
        if(Label.VI_useAPIGEE=='true'){
            String APIGEEusernameHeader = settingsMap.get('APIGEEUsername').Value__c;
            String APIGEEpasswordHeader = settingsMap.get('APIGEEPassword').Value__c;
            Blob APIGEEheaderValuecred = Blob.valueOf(APIGEEusernameHeader + ':' + APIGEEpasswordHeader);
            String APIGEEauthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(APIGEEheaderValuecred);
            request.setHeader('Authorization', APIGEEauthorizationHeader);
        }
        else{
            String usernameHeader = settingsMap.get('APIHourUsername').Value__c;
            String passwordHeader = settingsMap.get('APIHourPassword').Value__c;
            Blob headerValuecred = Blob.valueOf(usernameHeader + ':' + passwordHeader);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValuecred);
            request.setHeader('Authorization', authorizationHeader); 
        }
        
        request.setHeader('api_key', MP_Xdata_credentials__c.getInstance('VI_api_key_INT').Value__c);
        request.setHeader('Accept', 'application/json');
        request.setHeader('X-Correlation-Id', VI_UTIL003_GuidUtil.NewGuid());
        return request;
    }
    
    
    
    //This method will call the DocuSignJWT class to obtain an access token from DocuSign
    public static String getAccessToken(String partitionName) {
        String APIGEEToken;
        /*if(Label.VI_useAPIGEE=='true'){
            APIGEEToken=VI_SM013_GetTokenService.getToken('VI','local.VIToken');
        }*/
        
        Cache.OrgPartition part = Cache.Org.getPartition(partitionName);
        system.debug('part '+part); 
        String access_token = (String) part.get('token');
        system.debug('token '+access_token);
        if (access_token != null) {
            return access_token;
        }
        //String access_token = null;
        
        //Instantiate a request object
        HttpRequest req = new HttpRequest();
        
        //set the request METHOD
        req.setMethod('POST');
        
        //set the request endpoint
        
        String authendpoint = settingsMap.get('RequestAuthEndpoint').Value__c;
        System.Debug(LoggingLevel.INFO, '**RequestAuthEndpoint' + authendpoint);
        if(Label.VI_useAPIGEE=='true'){
            authendpoint='callout:VI_AuthAPIGEE/api/partnercommunity/1.0/protected-docusign/oauth/token';
        }
        else{
            authendpoint='callout:VI_AuthAPIHour/api/partnercommunity/1.0/protected-docusign/oauth/token';
        }
        req.setEndPoint(authendpoint);
        
        //set the request headers
        //1. Content -type
        String authRequestContentType = settingsMap.get('RequestAuthContentType').Value__c; 
        System.Debug(LoggingLevel.INFO, '**authRequestContentType ' + authRequestContentType);
        req.setHeader('Content-type', authRequestContentType);
        
        //2. Host
        String authRequestDomain = settingsMap.get('RequestAuthDomain').Value__c;
        System.Debug(LoggingLevel.INFO, '**authRequestDomain ' + authRequestDomain);
        //req.setHeader('Host', authRequestDomain);
       
        /*String usernameHeader = settingsMap.get('APIHourUsername').Value__c;
        String passwordHeader = settingsMap.get('APIHourPassword').Value__c;
        Blob headerValuecred = Blob.valueOf(usernameHeader + ':' + passwordHeader);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValuecred);
        system.debug('authorizationHeader '+authorizationHeader);
        req.setHeader('Authorization', authorizationHeader); 
        if(Label.VI_useAPIGEE=='true'){
            String APIGEEusernameHeader = settingsMap.get('APIGEEUsername').Value__c;
            String APIGEEpasswordHeader = settingsMap.get('APIGEEPassword').Value__c;
            Blob APIGEEheaderValuecred = Blob.valueOf(APIGEEusernameHeader + ':' + APIGEEpasswordHeader);
            String APIGEEauthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(APIGEEheaderValuecred);
            //req.setHeader('X-Authorization', APIGEEauthorizationHeader);
            req.setHeader('Authorization', APIGEEauthorizationHeader);
            req.setHeader('Content-length', '0');
        }
        req.setHeader('api_key', MP_Xdata_credentials__c.getInstance('VI_api_key_INT').Value__c);
        req.setHeader('Accept', 'application/json');
        req.setHeader('X-Correlation-Id', VI_UTIL003_GuidUtil.NewGuid());*/
        req=constructHeader(req);
        
        //Body of the request
        String alg = 'RS256';
        String iss = settingsMap.get('RequestIntegratorKey').Value__c;
        String pkey = settingsMap.get('RequestPrivateKey').Value__c;
        String scope = settingsMap.get('RequestScope').Value__c;
        VI_DocusignJWT jwtObject = new VI_DocusignJWT(alg, settingsMap.get('DSUserName').Value__c, iss, pkey, scope, authRequestDomain);
        
        //Set the request body	
        String requestBody = settingsMap.get('RequestAuthBody').Value__c + jwtObject .issue();
        System.Debug(LoggingLevel.INFO, '**RequestAuthBody' + requestBody);
        req.setBody(requestBody);
        system.debug('request '+req);
        system.debug('request body '+req.getBody());
        system.debug('request header host '+req.getHeader('Host'));
        system.debug('request header authorization '+req.getHeader('Authorization'));
        system.debug('request header X-Correlation-Id '+req.getHeader('X-Correlation-Id'));
        system.debug('request api_key '+req.getHeader('api_key'));
        system.debug('request X-Authorization '+req.getHeader('X-Authorization'));
        system.debug('request Authorization '+req.getHeader('Authorization'));
        system.debug('endpoint '+authendpoint);
        HTTPResponse res;
        //call the service
        Http http = new Http();
        if(!Test.isRunningTest()){
            res = http.send(req);
            system.debug('res '+res);
        }
        else{
            StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
            multimock.setStaticResource('VI_TestGetDocusignToken');
            multimock.setStatusCode(200);
            multimock.setHeader('Content-Type', 'application/json');
            Test.setMock(HttpCalloutMock.class, multimock);
            res = http.send(req);
        }
        
        System.Debug(LoggingLevel.INFO, '**ResponseAuthBody' + res.getbody());
        System.Debug(LoggingLevel.INFO, '**ResponseAuth' + res);
        
        //Obtain the access token from the Response
        if (res.getStatusCode() == 200) {
            System.JSONParser parser = System.JSON.createParser(res.getBody());
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) {
                    parser.nextToken();
                    access_token = parser.getText();
                    break;
                }
            }
        }
        system.debug('acces token '+ access_token);
        part.put('token', access_token, 3600 * 1 - 30);
        return access_token;
        
    }
    
    //This method will invoke the outbound REST call to the Docusign API for creating the envelope
    public static String createEnvelope(String partitionName,Recipients recipient,List<Documents> listDocuments,List<CustomField> listCustomFieldToCreate,String typeDoc,String idMandat,String civiliteClient,String nomClient) 
    {
        //Get the access token
        String accessToken = getAccessToken(partitionName);
        System.Debug(LoggingLevel.INFO, '***accessToken ' + accessToken);
        
        //Call envelope Creation service if a non-empty access token is returned
        if (!String.isEmpty(accessToken)) {
            //instantiate an Http instance  
            Http httpProtocol = new Http();
            
            //instantiate an HttpRequest instance  
            HttpRequest request = new HttpRequest();
            
            //Set the request parameters 
            // Request endpoint for createEnvelope call
            String endpoint;
            if(Label.VI_useAPIGEE=='true'){
                endpoint ='callout:VI_AuthAPIGEE/api/partnercommunity/1.0/protected-docusign/restapi/v2/accounts/'+settingsMap.get('AccountNumber').Value__c+'/envelopes';
            }
            else{
                endpoint ='callout:VI_AuthAPIHour/api/partnercommunity/1.0/protected-docusign/restapi/v2/accounts/'+settingsMap.get('AccountNumber').Value__c+'/envelopes';
            }

            System.Debug(LoggingLevel.INFO, '***endpoint ' + endpoint);
            request.setEndPoint(endpoint);
            
            //set the POST method
            request.setMethod('POST');
            
            //set Headers
            request.setHeader('grant_type', 'Bearer');
            request.setHeader('X-Authorization', 'Bearer ' + accessToken);
            request.setHeader('Accept', 'application/json');
            request.setHeader('Content-type', 'application/json');
            //NEW
            request.setHeader('api_key', MP_Xdata_credentials__c.getInstance('VI_api_key_INT').Value__c);
            request.setHeader('X-Correlation-Id', VI_UTIL003_GuidUtil.NewGuid());
            /*String usernameHeader = settingsMap.get('APIHourUsername').Value__c;
            String passwordHeader = settingsMap.get('APIHourPassword').Value__c;
            Blob headerValuecred = Blob.valueOf(usernameHeader + ':' + passwordHeader);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValuecred);
            request.setHeader('Authorization', authorizationHeader);
            if(Label.VI_useAPIGEE=='true'){
                String APIGEEusernameHeader = settingsMap.get('APIGEEUsername').Value__c;
                String APIGEEpasswordHeader = settingsMap.get('APIGEEPassword').Value__c;
                Blob APIGEEheaderValuecred = Blob.valueOf(APIGEEusernameHeader + ':' + APIGEEpasswordHeader);
                String APIGEEauthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(APIGEEheaderValuecred);
                //req.setHeader('X-Authorization', APIGEEauthorizationHeader);
                request.setHeader('Authorization', APIGEEauthorizationHeader);
            }*/
            request=constructHeader(request);
            //create the request Body
            
            //create instance of the EnvelopeCreationRequest class
            EnvelopeCreationRequest requestObject = new EnvelopeCreationRequest();
            requestObject.status = settingsMap.get('RequestEnvelopeStatus').Value__c;
            if(typeDoc.equals('Mandat')){
                requestObject.emailSubject = 'Votre mandat de prélèvement';
                requestObject.emailBlurb='Bonjour '+civiliteClient+' ' + nomClient+', \r\n Votre mandat de prélèvement portant la Référence Unique de Mandat '+idMandat+' est à présent signé.';
            }
            else{
                requestObject.emailSubject = 'Votre contrat ENGIE';
                requestObject.emailBlurb='Bonjour '+civiliteClient+' ' + nomClient+', \r\nVotre contrat a été signé. \r\n Félicitations pour votre souscription à l’offre Engie, vous contribuez désormais au développement des énergies renouvelables.';
            }
            requestObject.recipients=recipient;
            requestObject.documents=listDocuments;
            requestObject.brandid=settingsMap.get('BrandId').Value__c;
            //DDPCM 366 Start
            Notification envelopeNotification=new Notification();
            envelopeNotification.useAccountDefaults='True';
            Expirations envelopeExpiration=new Expirations();        
            envelopeExpiration.expireAfter='15'; 
            envelopeExpiration.expireEnabled='False';
            envelopeNotification.expirations=envelopeExpiration;
            requestObject.notification=envelopeNotification;
            //DDPCM 366 End 
            List<CustomField> listCustomFields=new List<CustomField>();
            if(listCustomFieldToCreate!=null && listCustomFieldToCreate.size()>0){
                for(CustomField cf:listCustomFieldToCreate){
                    CustomField newCustomField=new CustomField();
                    newCustomField.name=cf.name;
                    newCustomField.show=cf.show;
                    newCustomField.required=cf.required;
                    newCustomField.value=cf.value;
                    newCustomField.fieldId=cf.fieldId;
                    listCustomFields.add(cf);                    
                }
            }
            
            customFieldList cflWrapper=new customFieldList();
            cflWrapper.textCustomFields=listCustomFields;
            requestObject.customFields=cflWrapper;
            requestObject.configurationType='salesforce';
            
            System.Debug(LoggingLevel.INFO, '***requestObject() ' + requestObject);
            String jsonBody = json.serialize(requestObject);
            System.Debug(LoggingLevel.INFO, '***jsonBody() ' + jsonBody);
            request.setBody(jsonBody);
            
            //Make the request and capture the response
            HttpResponse response = httpProtocol.send(request);
            System.Debug(LoggingLevel.INFO, '***response.getBody() ' + response.getBody());
            System.debug(LoggingLevel.INFO, '***response.getStatus() ' + response.getStatus());
            
            //Parse the response
            String responseStatus = response.getStatus();
            if (responseStatus.equals('Created')) {
                EnvelopeCreationResponse responseObject = new EnvelopeCreationResponse();
                responseObject = (EnvelopeCreationResponse)System.JSON.deserialize(response.getBody(), EnvelopeCreationResponse.class);
                System.Debug(LoggingLevel.INFO, '***responseObject ' + responseObject);
                return responseObject.envelopeId;
            }
            else{
                return null;
            }
        }
        return null;
    } 
    
    public static String createSignatureLink(String envelopeID,String email,String clientUserId,String recipientId,String userName, String redirectionURL) {
        String accessToken = getAccessToken('local.VIDocusignToken');
        System.Debug(LoggingLevel.INFO, '***accessToken ' + accessToken);
        
        //Call envelope Creation service if a non-empty access token is returned
        if (!String.isEmpty(accessToken)) {
            Http httpProtocol = new Http();
            
            //instantiate an HttpRequest instance  
            HttpRequest request = new HttpRequest();
            
            //Set the request parameters 
            // Request endpoint for createEnvelope call
            String endpoint;
            if(Label.VI_useAPIGEE=='true'){
                endpoint = 'callout:VI_AuthAPIGEE/api/partnercommunity/1.0/protected-docusign/restapi/v2/accounts/'+settingsMap.get('AccountNumber').Value__c+'/envelopes/'+envelopeID+'/views/recipient';
            }
            else{
                endpoint = 'callout:VI_AuthAPIHour/api/partnercommunity/1.0/protected-docusign/restapi/v2/accounts/'+settingsMap.get('AccountNumber').Value__c+'/envelopes/'+envelopeID+'/views/recipient';
            }
            System.Debug(LoggingLevel.INFO, '***endpoint ' + endpoint);
            request.setEndPoint(endpoint);
            
            //set the POST method
            request.setMethod('POST');
            
            //set Authentication Header
            request.setHeader('grant_type', 'Bearer');
            request.setHeader('X-Authorization', 'Bearer ' + accessToken);
            
            //set Accept Header
            request.setHeader('Accept', 'application/json');
            //set Content Type Header
            request.setHeader('Content-type', 'application/json');
            request.setHeader('api_key', MP_Xdata_credentials__c.getInstance('VI_api_key_INT').Value__c);
            request.setHeader('X-Correlation-Id', VI_UTIL003_GuidUtil.NewGuid());
            /*String usernameHeader = settingsMap.get('APIHourUsername').Value__c;
            String passwordHeader = settingsMap.get('APIHourPassword').Value__c;
            Blob headerValuecred = Blob.valueOf(usernameHeader + ':' + passwordHeader);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValuecred);
            system.debug('authorizationHeader '+authorizationHeader);
            request.setHeader('Authorization', authorizationHeader); 
            if(Label.VI_useAPIGEE=='true'){
                String APIGEEusernameHeader = settingsMap.get('APIGEEUsername').Value__c;
                String APIGEEpasswordHeader = settingsMap.get('APIGEEPassword').Value__c;
                Blob APIGEEheaderValuecred = Blob.valueOf(APIGEEusernameHeader + ':' + APIGEEpasswordHeader);
                String APIGEEauthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(APIGEEheaderValuecred);
                //req.setHeader('X-Authorization', APIGEEauthorizationHeader);
                request.setHeader('Authorization', APIGEEauthorizationHeader);
            }*/
             request=constructHeader(request);
            URLCreationRequest urlCreationObject=new URLCreationRequest();
            urlCreationObject.email=email;//'paul.ghoussoub@eit-mena.com';
            urlCreationObject.clientUserId='1234';
            urlCreationObject.envelopeId=envelopeID;
            urlCreationObject.authenticationMethod='email';
            urlCreationObject.recipientId='1';
            urlCreationObject.userName=userName;//'Paul Ghoussoub';
            urlCreationObject.returnUrl=system.label.VI_DocuSignRedirectionURL+'/PageConfirmation?'+redirectionURL;
            system.debug('urlCreationObject.returnUrl'+ urlCreationObject.returnUrl);
            
            System.Debug(LoggingLevel.INFO, '***requestObject() ' + urlCreationObject);
            String jsonBody = json.serialize(urlCreationObject);
            System.Debug(LoggingLevel.INFO, '***jsonBody() ' + jsonBody);
            request.setBody(jsonBody);
            
            //Make the request and capture the response
            HttpResponse response = httpProtocol.send(request);
            System.Debug(LoggingLevel.INFO, '***response.getBody() ' + response.getBody());
            System.debug(LoggingLevel.INFO, '***response.getStatus() ' + response.getStatus());
            
            //Parse the response
            String responseStatus = response.getStatus();
            if (responseStatus.equals('Created')) {
                URLCreationResponse responseObject = new URLCreationResponse();
                responseObject = (URLCreationResponse)System.JSON.deserialize(response.getBody(), URLCreationResponse.class);
                System.Debug(LoggingLevel.INFO, '***responseObject ' + responseObject);
                system.debug(responseObject.url);
                return responseObject.url;
            }
            else{
                URLCreationResponse responseObject = new URLCreationResponse();
                responseObject = (URLCreationResponse)System.JSON.deserialize(response.getBody(), URLCreationResponse.class);
                System.Debug(LoggingLevel.INFO, '***responseObject ' + responseObject);
                system.debug(LoggingLevel.INFO, '***errorCode' +responseObject.errorCode);
                return responseObject.errorCode;
            }
        }
        return '';
    }
    
    @AuraEnabled
    public static void envoyerMailCPVMandat(String url,String urlMandat,String urlIbanEnSelfcare,blob blobAttachement,VI_Parcours__c parcours,String choixSituation){
        String emailTemplateQuery='Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName =';
        // Start DDPCM - 412
        system.debug('¤ VI_IBANEnSelfCare__c : ' + parcours.VI_IBANEnSelfCare__c);
        if (parcours.VI_IBANEnSelfCare__c == false) {
            system.debug('¤ cas IBAN en selfcare === false');
            if(choixSituation=='EM' && urlMandat!=null){
                system.debug('email1bis');
                emailTemplateQuery+='\'Email1BisCpvpourinformationEtMandatSepa\'';
            }
            else if(choixSituation=='EM' && urlMandat==null){
                emailTemplateQuery+='\'Email1Cpvpourinformationvf\'';
            }
            else if(choixSituation=='CHF' && urlMandat!=null){
                emailTemplateQuery+='\'Email2BisCpvMandatpoursignaturevf\'';
            }
            else if(choixSituation=='CHF' && urlMandat==null){
                emailTemplateQuery+='\'Email2Cpvpoursignaturevf\'';
            }
        }
        else {
			system.debug('¤ cas IBAN en selfcare');
            if(choixSituation=='EM'){
                emailTemplateQuery+='\'Email1TerCpvpourinformationEtIBANEtMandatSepa\'';
            }
            else if(choixSituation=='CHF'){
                emailTemplateQuery+='\'Email2TerCpvIBANMandatpoursignaturevf\'';
            }
        }
        system.debug('¤ emailTemplateQuery : ' + emailTemplateQuery);
		// END DDPCM - 412
        
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        EmailTemplate emailTemplate = Database.query(emailTemplateQuery);
        mail.setTemplateID(emailTemplate.Id); 
        mail.setWhatId(parcours.Id);
        mail.setTargetObjectId(parcours.VI_Contact__c);
        mail.setTreatTargetObjectAsRecipient(false);
        mail.setSaveAsActivity(false);
        mail.setTreatBodiesAsTemplate(true);
        
        
        // Strings to hold the email addresses to which you are sending the email.
        String[] toAddresses = new String[] {parcours.VI_Email_CPV__c}; 
            // Assign the addresses for the To and CC lists to the mail object.
            mail.setToAddresses(toAddresses);
        
        // Specify the address used when the recipients reply to the email. 
        system.debug('parcours.VI_Email_CPV__c in send '+parcours.VI_Email_CPV__c);
        mail.setReplyTo(parcours.VI_Email_CPV__c);
        OrgWideEmailAddress emailSender=[select Id, Address, DisplayName from OrgWideEmailAddress where Address='noreply@clients-particuliers.engie.fr'];
        // Specify the name used as the display name.
       // mail.setSenderDisplayName(emailSender.DisplayName);
        mail.setOrgWideEmailAddressId(emailSender.id);
        // Specify the subject line for your email address.
        mail.setSubject(emailTemplate.subject);
        String emailBody=emailTemplate.HtmlValue; 
        //mail.setHtmlBody(emailBody);
        //system.debug('emailBody '+emailBody);
        system.debug('parcours.VI_URL_CPV__c '+url);
        if(emailBody.contains('{!VI_Parcours__c.VI_URL_CPV__c}')){
            emailBody=emailBody.replace('{!VI_Parcours__c.VI_URL_CPV__c}', url);
        }
        system.debug('parcours.VI_URL_Mandat__c '+urlMandat);
        if(emailBody.contains('{!VI_Parcours__c.VI_URL_Mandat__c}')){
            system.debug('contains URL Mandat');
            emailBody= emailBody.replace('{!VI_Parcours__c.VI_URL_Mandat__c}', urlMandat);
        }
        //Start DDPCM - 412
        system.debug('parcours.VI_URL_IBAN_Mandat__c '+parcours.VI_URL_IBAN_Mandat__c);
        system.debug('urlIbanEnSelfcare '+urlIbanEnSelfcare);
        if(urlIbanEnSelfcare != null && emailBody.contains('{!VI_Parcours__c.VI_URL_IBAN_en_selfcare__c}')){
            system.debug('contains URL IBAN et Mandat');
            
            emailBody= emailBody.replace('{!VI_Parcours__c.VI_URL_IBAN_en_selfcare__c}', urlIbanEnSelfcare);
        }
        //End DDPCM - 412
       // system.debug('emailBody '+emailBody);
        mail.setHtmlBody(emailBody);
        // Set to True if you want to BCC yourself on the email.
        mail.setBccSender(false);
        // Specify the text content of the email.
        if(blobAttachement!=null){
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setContentType('application/pdf');
            efa.setFileName('CPV.pdf');
            efa.setBody(blobAttachement);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        }
        system.debug('before send email');
        // Send the email you have created.
        if(!test.isRunningTest()){
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        parcours.VI_EmailEnvoye__c=true;
        parcours.VI_Date_envoi_email__c=System.today();
        /* Start DDPCM 1183 */
        Datetime now = Datetime.now();
        Integer offset = UserInfo.getTimezone().getOffset(now);
        Datetime local = now.addSeconds(offset/1000);
        parcours.VI_Date_Heure_envoi_email__c= local;
        /* End DDPCM 1183 */
        system.debug('after send email');
    }
    
    public static retourEnvoiDocument envoyerDocumentsfromLWC(VI_Parcours__c parcours,String caseNumber, List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> coupleCodeValeurs, String partitionName){
        retourEnvoiDocument retourEnvoi=new retourEnvoiDocument();
        
        VI_Parcours__c parcoursSelectedFromQuery=[SELECT Id,Name,CreatedDate, VI_NomClient__c, VI_CommentairesParcours__c,VI_ChoixEnergie__c,VI_ChoixParcours__c,VI_TypeRechercheLocal__c, 
                                                  VI_CommentairesAnnulerParcours__c, VI_CommentairesReprendreParcours__c, VI_CommentairesTransfertAppel__c,
                                                  VI_PlanifierTache__c, VI_DateEcheanceTache__c, VI_HeureEcheanceTache__c, VI_DescriptionTache__c, VI_Numero_de_la_rue__c,
                                                  VI_Etape_Parcours__c,VI_Email1Client__c, VI_PrenomClient__c,VI_Email2Client__c,  VI_CommuneClient__c, VI_RueCreationClient__c,
                                                  VI_CodePostalClient__c, VI_IDReferenceClient__c, VI_Contact__c, VI_TelephoneFixe1Client__c, VI_RefusMobile__c, VI_TelephoneFixe2Client__c,
                                                  VI_TelephonePrincipalCreationClient__c,VI_RefusEmailCreationClient__c, VI_EmailPrincipalCreationClient__c, VI_RefusTelephoneCreationClient__c, 
                                                  VI_Mobile1Client__c, VI_Mobile2Client__c, VI_MobilePrincipalCreationClient__c,/* Start DDPCM 1299 */ VI_ConsentProspectionEngieNonAnalogue__c , VI_ConsentProspectionPartenaire__c,/* End DDPCM 1299 */
                                                  VI_PDLRechercheLocal__c, VI_PCERechercheLocal__c,VI_NumeroRueRechercheLocal__c, VI_RueRechercheLocal__c, VI_CodePostalRechercheLocal__c, 
                                                  VI_CommuneRechercheLocal__c,VI_AccordClientRechercheLocal__c, VI_LocalNonIdentifieGenerationCase__c,VI_CommentaireGeneral_Constitutionpanier__c,
                                                  VI_CommentaireGeneral_EstimationConso__c,VI_CommentaireGeneral_idlocal__c,VI_CommentaireGeneral_idbesoin__c,VI_CommentaireGeneral_idclient__c,
                                                  VI_CommentaireGeneral_InfosCompl__c,VI_CommentaireGeneral_MoyensPaiement__c, VI_NomPredecesseurRechercheLocal__c, 
                                                  VI_TypeLogementRechercheLocal__c,VI_NumeroEtageRechercheLocal__c, VI_NumeroAppartementRechercheLocal__c, VI_EstimationFtaCode__c,
                                                  VI_IndexHPRechercheLocal__c, VI_IndexHCRechercheLocal__c, VI_IndexBaseRechercheLocal__c,VI_NumeroMatriculeRechercheLocal__c,
                                                  VI_DroiteGaucheRechercheLocal__c,Tech_IdentificationClientInitiee__c, VI_CiviliteClient__c, VI_ChoixEstimation__c, VI_SaisieConsommationHeuresPleines__c, 
                                                  VI_SaisieConsommationHeuresCreuses__c, VI_Secteur_Activit_Gaz__c,VI_Secteur_Activite_Elec__c,VI_ChoixOffreStructureMesureFournisseur__c,
                                                  VI_PuissanceCompteurElecSaisieConso__c, VI_SaisieConsommationElec_HP_HC__c,VI_InfosCompl_DateContratEffectif__c,
                                                  VI_InfosCompl_MiseEnServiceUrgente__c,VI_InfosCompl_PremiereMiseEnService__c,VI_InfosCompl_IndexElec__c,VI_InfosCompl_IndexGaz__c,
                                                  VI_InfosCompl_HP_HC__c,VI_InfosCompl_HeuresPleinesElec__c,VI_InfosCompl_HeuresCreusesElec__c,VI_InfosCompl_ChoixReleveCompteur__c, 
                                                  VI_ConsommationGazKwHSaisieConso__c, VI_TypeResidenceSaisieConso__c, VI_TypeLogementSaisieConso__c, VI_idCompteClient__c,
                                                  VI_SurfaceLogementSaisieConso__c, VI_NombreOccupantLogementSaisieConso__c, VI_AnneeConstructionLogementSaisieConso__c, 
                                                  VI_ServiceOptionVerteElecPrixAbHT__c,VI_GazPlageConso__c,VI_EstimationNiveauOuvertureServices__c,VI_DateLastModifFormTarifaireAcheminemt__c,VI_EstimationPuissance__c,
                                                  VI_DispositifChauffageSaisieConso__c, VI_Code_pack__c,VI_ChoixOffrePourcentageOffreVerte__c,VI_Id_coordonnees_bancaires__c,
                                                  VI_EnergieChauffageSaisieConso__c, VI_EnergieCuissonSaisieConso__c, VI_DispositifEauChaudeSaisieConso__c, VI_EnergieEauChaudeSaisieConso__c
                                                  , VI_CongelateurElecSaisieConso__c, VI_SecheLingeElecSaisieConso__c, VI_LaveLingeElecSaisieConso__c, VI_LaveVaisselleElecSaisieConso__c,
                                                  VI_BoutonCreerNouveauClientClique__c, VI_SaisieEstimationConsoElec_HP_HC__c , VI_ChoixOffreSurParcoursPanierClient__c, VI_AjustementMensualitesPanierClient__c, 
                                                  VI_MontantdelaMensualitePanierClient__c, VI_EleckWhHTPanierClient__c, VI_EleckWhTTCPanierClient__c, VI_GazkWhHTPanierClient__c, VI_GazkWhTTCPanierClient__c,
                                                  VI_AbonnementAnnuelGazHTPanierClient__c, VI_AbonnementAnnuelGazTTCPanierClient__c, VI_AbonnementAnnuelElecHTPanierClient__c, VI_AbonnementAnnuelElecTTCPanierClient__c, 
                                                  VI_CodePromotionnelPanierClient__c, VI_OffreChoisieElecPanierClient__c, VI_OffreChoisieGazPanierClient__c, VI_LibelleOffrePanierClient__c, VI_CodeOptionPanierClient__c,
                                                  VI_LibelleOptionPanierClient__c, VI_MontantOptionPanierClient__c, VI_CodeCommuneIdentificationLocal__c, VI_Estimation_conso_elec_HP__c, VI_Estimation_conso_elec_HC__c, 
                                                  VI_Estimation_conso_gaz__c, ScriptDescription__c,VI_Statut_reference_client__c,VI_ChoixMoyenPaiement__c,VI_FrequencePrelevementMoyendePaiement__c,VI_NomTitulaireMoyendePaiement__c, VI_IBANEnSelfCare__c,
                                                  VI_IBANMoyendePaiement__c,/* Start DDPCM - 1110 VI_FactureEnLigneMoyendePaiement__c,VI_EdocMoyendePaiement__c, End DDPCM - 1110*/ VI_Case__c,VI_CodeOptionGazPanierClient__c,VI_ServiceOptionVerteElecPrixAbTTC__c,VI_ServiceOptionVerteGazPrixAbHT__c,
                                                  VI_LibelleOptionGazPanierClient__c, VI_EleckWhTTCHCPanierClient__c, VI_EleckWhHTHCPanierClient__c,VI_StatutParcours__c,VI_ServiceOptionVerteGazPrixAbTTC__c,VI_Email_CPV_IsFavori__c,VI_Email_CPV__c, VI_Espace_client__c,
                                                  VI_EmailEnvoye__c, VI_idDocumentCPV__c, VI_idDocumentMandat__c,VI_NumeroMatriculeGAZRechercheLocal__c, VI_RechercheLocal_AdresseComplete__c, VI_AdresseDeConsoIdentique__c, VI_ParcoursDeSouscriptionAF__c,
                                                  VI_CiviliteAF__c, VI_NomAF__c, VI_PrenomAF__c, VI_DateDeNaissanceAF__c, VI_CategorieSocioprofessionnelleAF__c, VI_ArretDeTravailPourRaisonDeSanteAF__c, VI_RenteInvaliditeAF__c, VI_ModeDePaiementAF__c, VI_AssuranceFactureCocheeAF__c,
                                                  VI_MONTANT_ABO_ELEC_FOUR_TTC__c,VI_MONTANT_ABO_GAZ_FOUR_TTC__c,VI_MONTANT_ABO_ELEC_ACH_TTC__c,VI_MONTANT_ABO_GAZ_ACH_TTC__c,
                                                  VI_PRIX_KWH_ELEC_FOUR_TTC__c,VI_PRIX_KWH_ELEC_ACH_TTC__c,VI_PRIX_KWH_ELEC_FOUR_HP_TTC__c,VI_PRIX_KWH_ELEC_FOUR_HC_TTC__c,
                                                  VI_PRIX_KWH_ELEC_ACH_HP_TTC__c,VI_PRIX_KWH_ELEC_ACH_HC_TTC__c,VI_MONTANT_ABO_ELEC_FOUR_HT__c,VI_MONTANT_ABO_ELEC_ACH_HT__c,
                                                  VI_PRIX_KWH_ELEC_FOUR_HT__c,VI_PRIX_KWH_ELEC_ACH_HT__c,VI_PRIX_KWH_ELEC_OBLI__c,VI_PRIX_KWH_ELEC_OBLI_HT__c,VI_PRIX_KWH_ELEC_FOUR_HP_HT__c,
                                                  VI_PRIX_KWH_ELEC_FOUR_HC_HT__c,VI_PRIX_KWH_ELEC_ACH_HP_HT__c,VI_PRIX_KWH_ELEC_ACH_HC_HT__c,
                                                  VI_MONTANT_ABO_GAZ_FOUR_HT__c,VI_MONTANT_ABO_GAZ_ACH_HT__c,VI_PRIX_KWH_GAZ_FOUR_TTC__c,VI_PRIX_KWH_GAZ_FOUR_HT__c,
                                                  VI_PRIX_KWH_GAZ_ACH_TTC__c,VI_PRIX_KWH_GAZ_ACH_HT__c,VI_PRIX_KWH_GAZ_OBLI__c,VI_PRIX_KWH_GAZ_OBLI_HT__c,VI_PrixAssuranceFacture__c, VI_AF_Enregistre__c,VI_TechOffreReferenceChoisie__c,
                                                  VI_TOTAL_MONTANT_ABO_GAZ_HT__c, VI_TOTAL_MONTANT_CONSO_GAZ_TTC__c , VI_TOTAL_MONTANT_CONSO_GAZ_HT__c, VI_TOTAL_MONTANT_ABO_ELEC_HT__c, VI_Abonement_elec_HT__c,VI_TOTAL_MONTANT_ABO_ELEC_TTC__c,
                                                  VI_TOTAL_MONTANT_ABO_GAZ_TTC__c,VI_URL_IBAN_en_selfcare__c,/*Start DDPCM-940*/VI_MensualiteElecTTC__c, VI_MensualiteGazTTC__c,/*ENd DDPCM-940*/
                                                  VI_TOTAL_MONTANT_CONSO_ELEC_HT__c, VI_TOTAL_MONTANT_CONSO_ELEC_TTC__c,VI_Code_FTA_Offre__c, VI_URL_IBAN_Mandat__c,VI_TECH_SitePrestatairePartenaire__c,VI_TECH_TypeDuSitePrestataire__c,VI_TECH_NomDuClient__c,VI_TECH_TelephonePrincipal__c,VI_StatutCasePartnerCommunity__c,
                                                  VI_NomCompletClientCPV__c /* Start DDPCM-860 */,VI_SaisieEstimationConsoElec_GazPar__c/* Start DDPCM-860 *//* Start DDPCM-727 New Cannaux*/, VI_TypeParcours__c/*, VI_RemplissageAutomatiqueAdresseLocal__c, VI_Mensualisation__c *//*END DDPCM-727 New Cannaux*/,
                                                  VI_PRIX_KWH_ELEC_ACH_HCbasse_HTT__c, VI_PRIX_KWH_ELEC_ACH_HPbasse_HTT__c, VI_PRIX_KWH_ELEC_ACH_HChaute_HTT__c, VI_PRIX_KWH_ELEC_ACH_HPhaute_HTT__c, VI_PRIX_KWH_ELEC_ACH_HCbasse_TTC__c, VI_PRIX_KWH_ELEC_ACH_HPbasse_TTC__c, VI_PRIX_KWH_ELEC_ACH_HChaute_TTC__c, 
                                                  VI_PRIX_KWH_ELEC_ACH_HPhaute_TTC__c /* Start DDPCM-1192 */, VI_FinValidity__c, VI_DebutValidity__c, VI_CanalDeVente__c, VI_DescriptifPromotion__c, VI_NomPromotion__c, VI_LibelleSurFacture__c, VI_CodePromo__c, VI_NumPromotion__c,
                                                  VI_FinValidity2__c, VI_DebutValidity2__c, VI_CanalDeVente2__c, VI_DescriptifPromotion2__c, VI_NomPromotion2__c, VI_LibelleSurFacture2__c, VI_CodePromo2__c, VI_NumPromotion2__c, VI_CodePromoApplied__c, VI_CodePromoApplied2__c/* End DDPCM-1192 */,VI_Date_Heure_envoi_email__c
                                                  /* Start DDPCM - 1110 */, VI_FactureEnLigne__c, VI_EdocsMoyensPaiement__c, VI_ChoixMensualisation__c/* End DDPCM - 1110 */,VI_VilleNaissanceAF__c,VI_PaysNaissanceAF__c,VI_CodePostalNaissanceAF__c
                                                  FROM VI_Parcours__c

                                                  WHERE id=:parcours.id 
                                                  LIMIT 1];
        String envelopeId;
        String url;
        String envelopeIdMandat;
        String urlMandat;
        String idMandat;
        String encodedEncryptedCPV;
        String encodedEncryptedMandat;
        String encodedKeyCPV;
        String encodedKeyMandat;
        String myDateCPV;
        String myDateMandat;
        String choixSituation = parcoursSelectedFromQuery.VI_ChoixParcours__c;
        String choixPaiement = parcoursSelectedFromQuery.VI_ChoixMoyenPaiement__c;
        String sfdcBaseURL = System.URL.getSalesforceBaseUrl().toExternalForm();
        String recipientEmail;
        
        Site docusignSite=[Select Id, UrlPathPrefix, SiteType,Subdomain,Name from Site where Name = 'RedirectionDocuSign' limit 1];
        SiteDetail siteURL=[select SecureURL from SiteDetail where DurableId =:docusignSite.id limit 1];
        String baseURL=siteURL.SecureURL;

        List<Documents> listDocumentsMandat=new List<Documents>();
        List<Documents> listDocuments=new List<Documents>();
        Contact parcoursContact = [SELECT Name,FirstName, LastName, Complement_adresse__c, Adresse_Mail_Principale__c,Adresse_Mail_3__c ,Email,
                                   Adresse_Mail_2__c,MobilePhone, Mobile_2__c, Mobile_3__c,Identifiant_Buisness_Partener__c,
                                   reference_client_f__c, MailingCountry, MailingPostalCode, VI_Contact_Emails__c,
                                   MailingCity, Phone, Tel_Fixe_2__c, Tel_Fixe_3__c, No_Voie__c, MailingStreet, Salutation 
                                   FROM Contact 
                                   where Id =: parcoursSelectedFromQuery.VI_Contact__c
                                   LIMIT 1];
        if(parcoursSelectedFromQuery.VI_Email_CPV__c==null || String.isBlank(parcoursSelectedFromQuery.VI_Email_CPV__c))
        {
            parcoursSelectedFromQuery.VI_Email_CPV__c=parcoursContact.email;
        }
        system.debug('parcoursContact.email '+parcoursContact.email);
        
        List<VI_SM024_GetDocusignToken.CustomField> customFieldsList=createCustomFieldsForCPV(parcoursSelectedFromQuery);
        List<VI_SM024_GetDocusignToken.CustomField> customFieldsListMandat=createCustomFieldsForMandat(parcoursSelectedFromQuery);
        Tabs tabs=generateDocusSignTabs();
        Signers signer=createSigner(parcoursContact.Name,'1',parcoursSelectedFromQuery.VI_Email_CPV__c,'1234',tabs);
        List<Signers> listSigners=new List<Signers>();
        listSigners.add(signer);
        Recipients recipient=createRecipient(listSigners);
        
        //Creer le CPV et l'ajouter au doc
        try{
            String contenuCPV;
            if(parcoursSelectedFromQuery.VI_idDocumentCPV__c == null){
                VI_SM025_CreerCPVSansPC.retourCPV retourCPV = generateCPV(parcoursSelectedFromQuery,parcoursContact,caseNumber, coupleCodeValeurs);
                parcoursSelectedFromQuery.VI_idDocumentCPV__c = retourCPV.idDocument;
                contenuCPV = retourCPV.contenuDocument;
                if(retourCPV.message!= null && retourCPV.message.contains('Erreur')){
                    system.debug('retourCPV '+retourCPV);
                    retourEnvoi.retourMessage='Erreur lors de la génération du CPV';
                    retourEnvoi.parcours =  parcoursSelectedFromQuery;
                    return retourEnvoi;
                }
            }
            else{
                contenuCPV = VI_SM033_ServiceDocument.lireDocument(parcoursSelectedFromQuery.VI_idDocumentCPV__c,null,null,'HUBEONE',false,'VI','local.VIToken','callout:VI_AuthOctopus');
                if(contenuCPV.contains('Pas de Réponse')){
                    retourEnvoi.retourMessage='Erreur lors de l\'appel lireDocument';
                    retourEnvoi.parcours = parcoursSelectedFromQuery;
                    system.debug('retourEnvoi.retourMessage '+retourEnvoi.retourMessage);
                    return retourEnvoi;
                }
            }
            
            if(choixSituation.equals('CHF'))
            {
                Documents cpv=createDocumentFromString('1', 'CPV', contenuCPV);
                listDocuments.add(cpv);
            }   
            if(choixPaiement == 'Prélèvement automatique' && !parcoursSelectedFromQuery.VI_IBANEnSelfCare__c){ 
                system.debug('parcours.VI_Id_coordonnees_bancaires__c '+parcoursSelectedFromQuery.VI_Id_coordonnees_bancaires__c);
                system.debug('parcours.VI_IDReferenceClient__c '+parcoursSelectedFromQuery.VI_IDReferenceClient__c);
                system.debug('parcours.VI_idCompteClient__c '+parcoursSelectedFromQuery.VI_idCompteClient__c);
                VI_SM031_GestionPrelevement.mandatRetour mandatRetour = new VI_SM031_GestionPrelevement.mandatRetour();
                if(!test.isRunningTest()){
                mandatRetour=VI_SM031_GestionPrelevement.demandePrelevement(null,//'0304596236-0002',
                                                                                                                     //'0304596236','000506631943',
                                                                                                                     parcoursSelectedFromQuery.VI_Id_coordonnees_bancaires__c, parcoursSelectedFromQuery.VI_IDReferenceClient__c,
                                                                                                                     parcoursSelectedFromQuery.VI_idCompteClient__c,
                                                                                                                     'callout:VI_AuthOctopus');
                }
                else{
                    mandatRetour.messageRetour = null;
                    mandatRetour.statutMandat = 'Non-Actif';
                    mandatRetour.idMandat = '123456';
                }
                system.debug('mandatRetour.statutMandat '+mandatRetour.statutMandat);
                if(mandatRetour.messageRetour!=null)
                {
                    retourEnvoi.retourMessage=mandatRetour.messageRetour;
                    system.debug('retourEnvoi.retourMessage '+retourEnvoi.retourMessage);
                    retourEnvoi.parcours = parcoursSelectedFromQuery;
                    return retourEnvoi;
                }
                else{
                    if(mandatRetour.statutMandat!='Actif'){
                        CustomField RUM=createCustomField('RUM','True','True',mandatRetour.idMandat,null);
                        CustomField identifiant=createCustomField('identifiant','True','False','ZMDT'+mandatRetour.idMandat+'0'+parcoursSelectedFromQuery.VI_IDReferenceClient__c,null);
                        CustomField file_nameMandat=createCustomField('file_name','True','False','ZMDT'+mandatRetour.idMandat+'0'+parcoursSelectedFromQuery.VI_IDReferenceClient__c+'.pdf',null);
                        customFieldsListMandat.add(file_nameMandat);
                        customFieldsListMandat.add(RUM);
                        customFieldsListMandat.add(identifiant);
                        parcoursSelectedFromQuery.VI_ID_Mandat__c=mandatRetour.idMandat;
                        idMandat=mandatRetour.idMandat;
                        String retoutAppelDoc;
                        /*String idDocument=VI_SM032_DemanderSignature.demanderSignature( 
                            idMandat,parcours.VI_IDReferenceClient__c/*'0304596236'*//*,'EMAIL',null,
                            'PP','3','callout:VI_AuthOctopus'
                        );*/
                        if(parcoursSelectedFromQuery.VI_idDocumentMandat__c == null){
                            VI_SM037_ComposerMandat.retourMandat retourDocument = VI_SM037_ComposerMandat.composerMandat('MANDAT_POUR_SIGNATURE_ELECTRONIQUE',parcoursSelectedFromQuery ,parcoursContact,true,'PP','1.0','callout:VI_AuthOctopus');
                            String idDocument = retourDocument.idDocument;
                            system.debug('%%%%% idDocument '+idDocument);
                            if(idDocument != null){
                                parcoursSelectedFromQuery.VI_idDocumentMandat__c = idDocument;
                                if(retourDocument.message != null && (retourDocument.message.contains('OCTOPUS') || retourDocument.message.contains('Erreur lors de la composition du mandat'))){
                                    retourEnvoi.retourMessage= 'Erreur lors de l\'appel composer mandat '+idDocument ;
                                    retourEnvoi.parcours = parcoursSelectedFromQuery;
                                    system.debug('retourEnvoi.retourMessage '+retourEnvoi.retourMessage);
                                    return retourEnvoi;
                                }
                                else{
                                    
                                    String mandatDocument= retourDocument.contenuDocument;//VI_SM033_ServiceDocument.lireDocument(idDocument,null,null,'HUBEONE',false,'VI','local.VIToken','callout:VI_AuthOctopus');
                                    if(mandatDocument.contains('Pas de Réponse')){
                                        retourEnvoi.retourMessage='Erreur lors de l\'appel lireDocument';
                                        retourEnvoi.parcours = parcoursSelectedFromQuery;
                                        system.debug('retourEnvoi.retourMessage '+retourEnvoi.retourMessage);
                                        return retourEnvoi;
                                    }
                                    retoutAppelDoc=mandatDocument;
                                }
                            }
                        }
                        else{
                            String mandatDocument= VI_SM033_ServiceDocument.lireDocument(parcoursSelectedFromQuery.VI_idDocumentMandat__c,null,null,'HUBEONE',false,'VI','local.VIToken','callout:VI_AuthOctopus');
                            if(mandatDocument.contains('Pas de Réponse')){
                                retourEnvoi.retourMessage='Erreur lors de l\'appel lireDocument';
                                retourEnvoi.parcours = parcoursSelectedFromQuery;
                                system.debug('retourEnvoi.retourMessage '+retourEnvoi.retourMessage);
                                return retourEnvoi;
                            }
                            retoutAppelDoc=mandatDocument;
                            
                        }
                        if (retoutAppelDoc.contains('Erreur')){
                            retourEnvoi.retourMessage=retoutAppelDoc;
                            retourEnvoi.parcours = parcoursSelectedFromQuery;
                            system.debug('retourEnvoi.retourMessage '+retourEnvoi.retourMessage);
                            return retourEnvoi;
                        }
                        else{
                            Documents mandat=createDocumentFromString('2', 'Mandat', retoutAppelDoc);
                            if( mandat!= null){
                                listDocumentsMandat.add(mandat);
                            }
                        }
                    }
                }
            }
            if((choixPaiement == 'Prélèvement automatique' && !parcoursSelectedFromQuery.VI_IBANEnSelfCare__c) || !choixSituation.equals('EM')){
                if(listDocuments!=null && listDocuments.size()>0){
                    system.debug('HERE 1');
                    Blob key = Crypto.generateAesKey(128);
                    encodedKeyCPV=EncodingUtil.base64encode(key); 
                    system.debug('HERE 2');
                    envelopeId = createEnvelope(partitionName,recipient ,listDocuments,customFieldsList,'CPV',null,parcoursContact.Salutation,parcoursContact.LastName);
                    system.debug('HERE 3');
                    Blob data = Blob.valueOf('id='+parcoursSelectedFromQuery.id+'&Type=CPV');
                    system.debug('HERE 4');
                    Blob encrypted = Crypto.encryptWithManagedIV('AES128', key, data);
                    system.debug('HERE 5');
                    encodedEncryptedCPV = EncodingUtil.base64encode(encrypted);
                    system.debug('HERE 6');
                    Datetime timestamp=system.now();
                    myDateCPV = timestamp.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
                    system.debug('HERE 7');
                    parcoursSelectedFromQuery.VI_EnveloppeCPV__c=envelopeId;
                    system.debug('HERE 8');
                    url=baseURL+'?encrypted='+encodedEncryptedCPV+'&TimeStamp='+myDateCPV;
                    system.debug('HERE 9');
                    parcoursSelectedFromQuery.VI_URL_CPV__c=url;
                }
                if(listDocumentsMandat!=null && listDocumentsMandat.size()>0){
                    Blob key = Crypto.generateAesKey(128); 
                    encodedKeyMandat=EncodingUtil.base64encode(key);
                    envelopeIdMandat=createEnvelope(partitionName,recipient ,listDocumentsMandat,customFieldsListMandat,'Mandat',idMandat,parcoursContact.Salutation,parcoursContact.LastName);
                    Blob data = Blob.valueOf('id='+parcoursSelectedFromQuery.id+'&Type=Mandat');
                    Blob encrypted = Crypto.encryptWithManagedIV('AES128', key, data);
                    encodedEncryptedMandat = EncodingUtil.base64encode(encrypted);
                    Datetime timestamp=system.now();
                    myDateMandat = timestamp.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
                    parcoursSelectedFromQuery.VI_EnveloppeMandat__c=envelopeIdMandat;
                    urlMandat=baseURL+'?encrypted='+encodedEncryptedMandat+'&TimeStamp='+myDateMandat;
                    parcoursSelectedFromQuery.VI_URL_Mandat__c=urlMandat;
                }
            }
            
            String urlIBANAvecMandat;
            String idCompteCree;
            if(parcoursSelectedFromQuery.VI_IBANEnSelfCare__c)
            {
                system.debug('chiffrage creation compte client');
                idCompteCree = VI_SM030_CreerCompteClient.CreerCompteClient('+14B',
                                                                            parcours.VI_IDReferenceClient__c,null ,
                                                                            'Compte créé automatiquement sur un parcours'
                                                                            , 'PP', '5.0', 'callout:VI_AuthOctopus');
                system.debug('idCompteCree '+idCompteCree);
                
                system.debug('chiffrage');
                system.debug('0'+parcoursSelectedFromQuery.VI_IDReferenceClient__c+';'+
                             parcoursSelectedFromQuery.VI_Email_CPV__c+';'+
                             idCompteCree);
                urlIBANAvecMandat=Label.VI_LienIbanEnSelfcare+
                    VI_SM043_ChiffrerURL.ChiffrerChaine('0'+parcoursSelectedFromQuery.VI_IDReferenceClient__c+';'+
                                                        parcoursSelectedFromQuery.VI_Email_CPV__c+';'+
                                                        idCompteCree
                                                        ,'callout:VI_AuthOctopus','PP','1');
                parcoursSelectedFromQuery.VI_URL_IBAN_en_selfcare__c=urlIBANAvecMandat;
                parcoursSelectedFromQuery.VI_idCompteClient__c=idCompteCree;
                
            }
            
            String idLocal;
            if(parcoursSelectedFromQuery.VI_AssuranceFactureCocheeAF__c)
                
            {
                //START DDPCM-1118
                
                VI_SM050_Installation.InstallationsWrapper installations;
                if(!parcoursSelectedFromQuery.VI_LocalNonIdentifieGenerationCase__c){
                    if(parcoursSelectedFromQuery.VI_PDLRechercheLocal__c!=null){
                        installations=VI_SM050_Installation.callInstallations(parcoursSelectedFromQuery.VI_PDLRechercheLocal__c,'VI', 'local.VIToken');
                    }
                    else if(parcoursSelectedFromQuery.VI_PCERechercheLocal__c!=null){
                        installations=VI_SM050_Installation.callInstallations(parcoursSelectedFromQuery.VI_PCERechercheLocal__c,'VI', 'local.VIToken');
                    }
                    system.debug('installations '+installations);
                }
                if(installations!=null && installations.data!=null && installations.data.size()>0 && installations.data[0]!=null && installations.data[0].idLocal!=null){
                    idLocal= String.valueof(installations.data[0].idLocal);
                    parcoursSelectedFromQuery.VI_Id_Local__c=idLocal;
                    system.debug('idLocal '+idLocal);
                }
                if(idCompteCree==null){
                    idCompteCree = VI_SM030_CreerCompteClient.CreerCompteClient('+14B',
                                                                                parcours.VI_IDReferenceClient__c,null ,
                                                                                'Compte créé automatiquement sur un parcours'
                                                                                , 'PP', '5.0', 'callout:VI_AuthOctopus');
                    parcoursSelectedFromQuery.VI_idCompteClient__c=idCompteCree;
                }
                //END DDPCM-1118
            }
            
            if(choixSituation.equals('EM')){
                if(choixPaiement == 'Prélèvement automatique'){
                    envoyerMailCPVMandat(null,urlMandat,urlIBANAvecMandat,EncodingUtil.base64Decode(contenuCPV),parcoursSelectedFromQuery,choixSituation);                }
                else{
                    envoyerMailCPVMandat(null,null,urlIBANAvecMandat,EncodingUtil.base64Decode(contenuCPV),parcoursSelectedFromQuery,choixSituation);                }
            }
            else{
                if(choixPaiement == 'Prélèvement automatique'){
                    envoyerMailCPVMandat(url,urlMandat,urlIBANAvecMandat,null,parcoursSelectedFromQuery,choixSituation);                }
                else{
                    envoyerMailCPVMandat(url,null,urlIBANAvecMandat,null,parcoursSelectedFromQuery,choixSituation);                }
            }
            if(parcoursSelectedFromQuery.VI_AssuranceFactureCocheeAF__c)
            {
                system.debug('in assurancefacture');
                VI_SM042_AssuranceFacture.getResponseAddContratTranquility(parcoursSelectedFromQuery.id,'VI','local.VIToken');
                system.debug('out assurancefacture');
            }
            List<VI_DocuSignTokens__c> listUrlValues=new List<VI_DocuSignTokens__c>();
            if(encodedKeyCPV!=null){
                VI_DocuSignTokens__c urlCPVValues=new VI_DocuSignTokens__c();
                urlCPVValues.name=myDateCPV;
                urlCPVValues.VI_Value__c=encodedKeyCPV;
                system.debug('encodedEncryptedCPV '+encodedEncryptedCPV);
                listUrlValues.add(urlCPVValues);
            }            if(encodedKeyMandat!=null){
                VI_DocuSignTokens__c urlMandatValues=new VI_DocuSignTokens__c();
                urlMandatValues.name=myDateMandat;
                urlMandatValues.VI_Value__c=encodedKeyMandat;
                system.debug('encodedKeyMandat '+encodedKeyMandat);
                listUrlValues.add(urlMandatValues);
            }
            insert listUrlValues;
            
            retourEnvoi.parcours =  parcoursSelectedFromQuery;
            return retourEnvoi;
        }
        catch(exception e ){
            system.debug('emessage  '+e.getMessage());
            retourEnvoi.retourMessage='Erreur lors de la génération du CPV';
            retourEnvoi.parcours =  parcoursSelectedFromQuery;
            return retourEnvoi;
        }
    }
    
    //wrapper class for Envelope Creation Request
    public class EnvelopeCreationRequest {
        public String emailSubject { get; set; }
        public String emailBlurb {get;set;}
        public String status { get; set; }
        public Recipients recipients {get;set;}
        public List<Documents> documents;
        public customFieldList customFields{get;set;}
        public String configurationType{get;set;}
        
        //Ajouté 21/5/2021
        public String brandId{get;set;}
        //DDPCM 366 Start
        public Notification notification{get;set;}
        //DDPCM 366 End
    }
    
    //wrapper class for Envelope Creation Response
    public class EnvelopeCreationResponse {
        public String envelopeId { get; set; }
        public String uri { get; set; }
        public String status { get; set; }
        public String statusDateTime { get; set; }
    }
    
    public class URLCreationResponse {
        public String url {get;set;}
        public String errorCode {get;set;}
        public String message {get;set;}
    }
    
    public class URLCreationRequest{
        public String email;
        public String clientUserId;
        public String envelopeId;
        public String authenticationMethod;
        public String recipientId;
        public String userName;
        public String returnUrl;
    }
    
    public class Recipients {
        public List<Signers> signers;
    }
    
    public class Signers {
        public String email;
        public String name;
        public String recipientId;
        public String clientUserId;
        public Tabs tabs;
    }
    
    public class Tabs {
        public List<Tab> signHereTabs;
        public List<Tab> dateSignedTabs;
        public List<Tab> textTabs;
    }
    
    public class Tab {
        public String anchorString;
        public String tabId;
        public String tabLabel;
        public String name;
        public String required;
        public String anchorXOffset;
        public String anchorYOffset;
        public String value;
    }
    //DDPCM 366 Start
    public class Expirations {
        public String expireAfter;
        public String expireEnabled;
    }
    
    public class Notification {
        public String useAccountDefaults;
        public Expirations expirations;
    }
    //DDPCM 366 End
    public class Documents {
        public String documentId;
        public String name;
        public String documentBase64;
    }
    
    public class CustomField{
        public String name;
        public String value;
        public Object required ;
        public Object show;
        public String fieldId;
        public String CustomFieldType;
    }
    
    public class customFieldList{
        public List<CustomField> textCustomFields;
    }
    
    public static Tab createTab(String anchorString, String tabId, String tabLabel, String name,String required){
        Tab tab=new Tab();
        tab.anchorString=anchorString;
        tab.tabId= tabId;
        tab.tabLabel=tabLabel;
        tab.name=name;
        tab.required=required;
        return tab;
    }
    
    public static Signers createSigner(String name,String recipientId,String email,String clientUserId,tabs tab){
        Signers signer=new Signers();
        signer.name=name;
        signer.email=email;
        signer.recipientId=recipientId;
        signer.clientUserId=clientUserId;
        signer.tabs=tab;
        return signer;
    }
    
    public static Recipients createRecipient(List<Signers> listSigners){
        Recipients recipient=new Recipients();
        recipient.signers=listSigners;
        return recipient;
    }
    
    
    //Create document from contentDocumentId
   /* public static Documents createDocument(String documentId,String name,String ContentDocumentId){
        List<ContentVersion> content= [select VersionData  from ContentVersion where ContentDocumentId =:ContentDocumentId];
        blob blobDocument=content[0].versiondata;
        system.debug(blobDocument);
        Documents doc=new Documents();
        doc.documentId=documentId;
        doc.name=name;
        doc.documentBase64=EncodingUtil.base64Encode(blobDocument);
        system.debug(doc.documentBase64);
        return doc;
    }
    //Create document from blob
    public Static Documents createDocumentFromBlob(String documentId,String name,blob blobDocument){
        Documents doc=new Documents();
        doc.documentId=documentId;
        doc.name=name;
        doc.documentBase64=EncodingUtil.base64Encode(blobDocument);
        return doc;
    }*/
    
    //Create document from String
    public Static Documents createDocumentFromString(String documentId,String name,String contenu){
        Documents doc=new Documents();
        doc.documentId=documentId;
        doc.name=name;
        doc.documentBase64=contenu;
        return doc;
    }
    
    private class VI_DocusignJWT {
        public String alg {get;set;} //RS256 for DocuSign REST integration
        public String iss {get;set;} // Integrator key
        public String sub {get;set;} // DSFProUserName from the user record
        public String aud {get;set;} // Authentication domain
        public String scope {get;set;} // signature scope
        public String privateKey {get;set;} //Private key 
        public String exp {get;set;} 
        public String iat {get;set;}
        public Map<String,String> claims {get;set;}
        public Integer validFor {get;set;}
        public String cert {get;set;}
        public  final String HS256 = 'HS256';
        public  final String RS256 = 'RS256';
        public  final String NONE = 'none';
        private final String STRING_EMPTY = '';
        
        
        //Constructor 
        public VI_DocusignJWT(String alg,String sub,String iss, String privateKey,String scope,String aud) {
            this.alg = alg; 
            this.sub = sub; 
            this.iss = iss; 
            this.privateKey = privateKey; 
            this.scope = scope; 
            this.validFor = 300; 
            this.aud = aud; 
        }
        
        //Method which returns the JSON Web Token
        public String issue() {
            String jwt = STRING_EMPTY;
            
            //Construct the JSON Web Token Header 
            JSONGenerator header = JSON.createGenerator(false);
            header.writeStartObject();
            header.writeStringField('alg', this.alg);
            header.writeStringField('typ','JWT'); // Set as JWT
            header.writeEndObject();
            String encodedHeader = base64URLencode(Blob.valueOf(header.getAsString()));
            
            //Construct the JSON Body             
            JSONGenerator body = JSON.createGenerator(false);
            body.writeStartObject();
            body.writeStringField('iss', this.iss);
            body.writeStringField('sub', this.sub);
            body.writeStringField('aud', this.aud);
            Long rightNow = (dateTime.now().getTime()/1000)+1;
            body.writeNumberField('iat', rightNow);
            body.writeNumberField('exp', (rightNow + validFor));
            body.writeStringField('scope', this.scope);
            if (claims != null) {
                for (String claim : claims.keySet()) {
                    body.writeStringField(claim, claims.get(claim));
                }
            }
            body.writeEndObject();
            
            //JSON Web Token in this stage = encodedHeader + . + encodedBody
            jwt = encodedHeader + '.' + base64URLencode(Blob.valueOf(body.getAsString()));
            
            //Sign with Private key to create the signature 
            if (this.alg == HS256 ) {
                Blob key = EncodingUtil.base64Decode(privateKey);
                Blob signature = Crypto.generateMac('hmacSHA256',Blob.valueof(jwt),key);
                jwt += '.' + base64URLencode(signature);  
            } 
            else if (this.alg == RS256 ) {
                Blob signature = null;   
                if (cert != null) {
                    signature = Crypto.signWithCertificate('rsa-sha256', Blob.valueOf(jwt), cert);
                } else {
                    Blob privateKeyBlob = EncodingUtil.base64Decode(privateKey);
                    //construct the signature
                    signature = Crypto.sign('rsa-sha256', Blob.valueOf(jwt), privateKeyBlob);
                }
                jwt += '.' + base64URLencode(signature);  
            } else if ( this.alg == NONE ) {
                jwt += '.';
            }
            return jwt;
        }
        
        //Utility method for returning the base64URLEncoded string for the input string
        private String base64URLencode(Blob input){ 
            String output = STRING_EMPTY;
            if (input != null) {
                output = encodingUtil.base64Encode(input);
                output = output.replace('+', '-');
                output = output.replace('/', '_');
                while ( output.endsWith('=')){
                    output = output.subString(0,output.length()-1);
                }
            }    
            return output;
        }
    }
    public static List<VI_SM024_GetDocusignToken.CustomField> createCustomFieldsForMandat(VI_Parcours__c parcours)
    {
        CustomField application=createCustomField('application','True','True','HUBEONE',null);
        CustomField type_doc=createCustomField('type_doc','True','True','ZMDT',null);
        CustomField typeDocument=createCustomField('typeDocument','True','True','ZMDT',null);
        CustomField civilite=createCustomField('civilite','True','False',parcours.VI_CiviliteClient__c,null);
        CustomField nomCl=createCustomField('nomCl','True','False',parcours.VI_NomClient__c,null);
        CustomField prenom=createCustomField('prenom','True','False',parcours.VI_PrenomClient__c,null);   
        CustomField adresseElectronique=createCustomField('adresseElectronique','True','False','PASDEMAIL',null); 
        CustomField noBP=createCustomField('noBP','True','False','0'+parcours.VI_IDReferenceClient__c,null);
        CustomField Datecreation=createCustomField('dateCreation','True','False',system.now().format('MM/dd/yyyy')+'T'+system.now().format('HH:mm:ss'),null);
        CustomField typeMarche=createCustomField('typeMarche','True','False','OM',null);
        CustomField IDCase =createCustomField('IDCase','True','False',parcours.VI_Case__c,null);
        CustomField IDClient=createCustomField('IDClient','True','False','0'+parcours.VI_IDReferenceClient__c,null);
        CustomField idparcours=createCustomField('idparcours','True','False',parcours.Id,null); 
        //CustomField Datecreation=createCustomField('dateCreation','True','False','2021-03-01T05:04:32',null);

        List<VI_SM024_GetDocusignToken.CustomField> listCustomFieldToCreate=new List<VI_SM024_GetDocusignToken.CustomField>{application,type_doc,noBP,typeDocument,
            Datecreation,civilite,nomCl,prenom,adresseElectronique,typeMarche,IDCase,IDClient,idparcours
            };
                return listCustomFieldToCreate;
    }
    
    public static List<VI_SM024_GetDocusignToken.CustomField> createCustomFieldsForCPV(VI_Parcours__c parcours)
    {       
        CustomField application=createCustomField('application','True','True','PARTNER-COMMUNITY',null);
        CustomField type_doc=createCustomField('type_doc','True','True','22',null);
        //START DDPCM 426
        //CustomField identifiant=createCustomField('identifiant','True','False','ZCPV0000000000'+parcours.VI_Case__r.caseNumber,null);
        //CustomField file_name=createCustomField('file_name','True','False','ZCPV0000000000'+parcours.VI_Case__r.caseNumber+'.pdf',null);
        CustomField identifiant=createCustomField('identifiant','True','False','ZCPV'+parcours.VI_Case__c,null);
        CustomField file_name=createCustomField('file_name','True','False','ZCPV'+parcours.VI_Case__c+'.pdf',null);
        //END DDPCM 426
        CustomField IDClient=createCustomField('IDClient','True','False','0'+parcours.VI_IDReferenceClient__c,null);
        CustomField typeDocument=createCustomField('typeDocument','True','True','22',null);
        CustomField idCase=createCustomField('IDCase','True','False',parcours.VI_Case__c,null);
        CustomField referenceClient=createCustomField('referenceClient','True','False','0'+parcours.VI_IDReferenceClient__c,null);
        CustomField idparcours=createCustomField('idparcours','True','False',parcours.Id,null); 
        
        List<VI_SM024_GetDocusignToken.CustomField> listCustomFieldToCreate=new List<VI_SM024_GetDocusignToken.CustomField>{application,type_doc,identifiant,IDClient,typeDocument,
            idCase,referenceClient,file_name, idparcours};
                
                return listCustomFieldToCreate;
    }
    
    public static CustomField createCustomField(String name,String show,String required,String value,String fieldId){
        CustomField cf=new CustomField();
        cf.name=name;
        cf.show=show;
        cf.required=required;
        cf.value=value;
        cf.fieldId=fieldId;
        return cf;
    }
    
    public static Tabs generateDocusSignTabs(){
        Tabs tabs=new tabs();
        List<VI_SM024_GetDocusignToken.Tab> signHereTab=new List<VI_SM024_GetDocusignToken.Tab>();
        VI_SM024_GetDocusignToken.Tab signHere=VI_SM024_GetDocusignToken.createTab('#Signature client','1','signatureClient','signatureClient','true');
        signHereTab.add(signHere);
        VI_SM024_GetDocusignToken.Tab signHereMandat=VI_SM024_GetDocusignToken.createTab('#Signature (obligatoire)','4','signatureClientMandat','signatureClientMandat','true');
        signHereTab.add(signHereMandat);
        List<VI_SM024_GetDocusignToken.Tab> dateHereTab=new List<VI_SM024_GetDocusignToken.Tab>();
        VI_SM024_GetDocusignToken.Tab dateHere=VI_SM024_GetDocusignToken.createTab('#Le','2','dateSignatureClient','dateSignatureClient','true');
        dateHereTab.add(dateHere);
        VI_SM024_GetDocusignToken.Tab dateHereMandat=VI_SM024_GetDocusignToken.createTab('#Date (obligatoire)','5','dateSignatureClientMandat','dateSignatureClientMandat','true');
        dateHereTab.add(dateHereMandat);
        List<VI_SM024_GetDocusignToken.Tab> textHereTab=new List<VI_SM024_GetDocusignToken.Tab>();
        VI_SM024_GetDocusignToken.Tab textHere=VI_SM024_GetDocusignToken.createTab('#Fait à','3','lieuSignatureClient','lieuSignatureClient','true');
        textHereTab.add(textHere);
        VI_SM024_GetDocusignToken.Tab textHereMandat=VI_SM024_GetDocusignToken.createTab('#Lieu (obligatoire)','6','lieuSignatureClientMandat','lieuSignatureClientMandat','true');
        textHereTab.add(textHereMandat);
        tabs.signHereTabs=signHereTab;
        tabs.dateSignedTabs=dateHereTab;
        tabs.textTabs=textHereTab;
        return tabs;
    }
    
    /*public static String generateMandat(String getIdCoordonneeBancaire,String getIdPersonne,String getIdCompteClient,String idMandat ){
        /*VI_SM031_GestionPrelevement.mandatRetour mandatRetour=VI_SM031_GestionPrelevement.demandePrelevement(null,//'0304596236-0002',
//'0304596236','000506631943',
getIdCoordonneeBancaire, getIdPersonne, getIdCompteClient,
'callout:VI_AuthOctopus');
system.debug('mandatRetour.statutMandat '+mandatRetour.statutMandat);
if(mandatRetour.statutMandat=='Actif'){
return 'Le mandat est déjà actif';
}
else if(mandatRetour.messageRetour!=null)
{
return mandatRetour.messageRetour;
}
else{*//*
        String idDocument=VI_SM032_DemanderSignature.demanderSignature(
            idMandat,getIdPersonne/*'0304596236'*//*,'EMAIL',null,
            'PP','3','callout:VI_AuthOctopus'
        );
        system.debug('%%%%% idDocument '+idDocument);
        if(idDocument!=null){
            if(idDocument.contains('OCTOPUS') || idDocument.contains('Erreur lors de la demande de signature')){
                return 'Erreur lors de l\'appel Demander signature '+idDocument ;
            }
            else{
                String mandatDocument= VI_SM033_ServiceDocument.lireDocument(idDocument,null,null,'HUBEONE',false,'VI','local.VIToken','callout:VI_AuthOctopus');
                if(mandatDocument.contains('Pas de Réponse')){
                    return 'Erreur lors de l\'appel lireDocument';
                }
                return mandatDocument;
            }
        }
        return null;
    }*/
    
    
    public static VI_SM025_CreerCPVSansPC.retourCPV generateCPV(VI_Parcours__c parcours,Contact parcoursContact, String caseNumber, List<VI_gdfsuezComBefCalypsoCpvV2.listeCodeValeurDt_coupleCodeValeur_element> coupleCodeValeurs)
    {
        if(!Test.isRunningTest()){
            VI_SM025_CreerCPVSansPC.retourCPV retourCPV= VI_SM025_CreerCPVSansPC.SaveCPVTEST(parcours,parcoursContact, caseNumber,coupleCodeValeurs,  'ZCPV','test',true,true,'PP','callout:VI_AuthOctopus');
            return retourCPV;
        }
        else{
            Test.setMock(HttpCalloutMock.class, new VI_SM025_CreerCPVSansPC_Mock());
            VI_SM025_CreerCPVSansPC.retourCPV retourCPV =VI_SM025_CreerCPVSansPC.SaveCPVTEST(parcours,parcoursContact, caseNumber,coupleCodeValeurs,  'ZCPV','test',true,true,'PP','callout:VI_AuthOctopus');
            return retourCPV;
        }
    }
    
    public class retourEnvoiDocument{
        public String retourMessage;
        public VI_Parcours__c parcours;
    }
}