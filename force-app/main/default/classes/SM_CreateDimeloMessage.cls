@RestResource(urlMapping = '/CreateDimeloMessageSmile')
global class SM_CreateDimeloMessage {

    public static String errorLog;

    @HttpPost
    global static Map<String, String> createMessage(){
        System.debug('*** IN SM_CreateDimeloMessage:createMessage');
        Id accountId = null;
        errorLog = '';
        EmailMessageWrapper emailMessageWrapper = new EmailMessageWrapper();
        emailMessageWrapper.emailMessageId = '';
        Map<String, String> outMap = new Map<String, String>();
        String requestStr = RestContext.request.requestBody.toString(); 
        System.debug(requestStr);     
        Map<String, String> paramsMap = (Map<String,String>) JSON.deserialize(requestStr, Map<String,String>.class);
        
        System.debug('*** Params : ' + paramsMap);
        //verifier qu'on a renseigner ou moin un identifiant Contact
        if(String.isBlank(paramsMap.get('contact_id')) && String.isBlank(paramsMap.get('contact_bp'))
            && String.isBlank(paramsMap.get('contact_email')) && String.isBlank(paramsMap.get('contact_tel'))){
               outMap.put('case_id', null);
               outMap.put('case_statut', null);
               outMap.put('case_sousstatut', null);
               outMap.put('contact_id', null);
               errorLog +=  'veuillez renseigner un identifiant du client svp.';
               outMap.put('error', errorLog);
               outMap.put('emailMessage',null);
               return outMap;
           }
        System.debug('*** Params : ' + paramsMap);
        System.debug('*** paramsMap.get ToCreateCase ' + paramsMap.get('ToCreateCase'));
          System.debug('*** paramsMap.get Case Type ' + paramsMap.get('case_type'));
        if(paramsMap.get('ToCreateCase')=='true' && String.isBlank(paramsMap.get('case_type'))){
            outMap.put('case_id', null);
            outMap.put('case_statut', null);
            outMap.put('case_sousstatut', null);
            outMap.put('contact_id', null);
            errorLog +=  'Impossible de créer le case,le champ type est obligatoire.';
            outMap.put('error', errorLog);
            outMap.put('emailMessage',null);
            return outMap;
        }

        // Step 1 : on cherche le contact
        String contactId = findContact(paramsMap);
        System.debug('#### aka contactId' + contactId);
        // Amar
        if(!String.isBlank(contactId)){
            accountId = [select AccountId from contact where id=:contactId limit 1].AccountId;  
        }else{
            outMap.put('case_id', null);
            outMap.put('case_statut', null);
            outMap.put('case_sousstatut', null);
            outMap.put('contact_id', null);
            errorLog += 'Impossible de trouver le contact. Ce contact ou son compte n\'existe pas';
            outMap.put('error', errorLog);
            outMap.put('emailMessage',null);
            return outMap; 
        }
        System.debug('#### aka accountId' + accountId);
         System.debug('#### aka  paramsMap.get ' +  paramsMap.get('ToCreateCase'));
       
        // Amar
        if(String.isBlank(accountId)){

            outMap.put('case_id', null);
            outMap.put('case_statut', null);
            outMap.put('case_sousstatut', null);
            outMap.put('contact_id', contactId);
            errorLog +=  'Impossible de trouver le contact. Ce contact ou son compte n\'existe pas';
            outMap.put('error', errorLog);
            outMap.put('emailMessage',null);
            return outMap; 
        }
        else{
            //contact & account sont renseignés
            // Step 2 : on cherche le case, ou on le crée le cas échéant si ToCreateCase=true
            if(paramsMap.get('ToCreateCase')=='true'){
                Map<String, String> caseInfo = findCase(paramsMap, contactId);
                outMap.put('case_id', caseInfo.get('id'));
                outMap.put('case_statut', caseInfo.get('statut'));
                outMap.put('case_sousstatut', caseInfo.get('sous_statut'));
            }else{
                outMap.put('case_id', null);
                outMap.put('case_statut', null);
                outMap.put('case_sousstatut', null);
            }
            // Step 3 : on crée l'email message
            emailMessageWrapper = createEmailMessage(paramsMap, contactId, accountId);

            // Step 4 : update la task avec l'id du contact et le lien du document
            updateTask(paramsMap, contactId, emailMessageWrapper.activityId, accountId);
        }
        
        outMap.put('contact_id', contactId);
        outMap.put('error', errorLog);
        outMap.put('emailMessage',emailMessageWrapper.emailMessageId);

        return outMap;
    }

    /*
    *   @description : on recherche le contact à partir de son id, de son bp, de son email ou de son tel (dans cet ordre)
    *   @param requestParams : les données passées par le WS
    *   @return l'id du contact retrouvé
    */
    public static String findContact(Map<String, String> requestParams){
        String idContactOut = null;

        // Step 1.1 : on le cherche par l'ID s'il est fourni
        String idContact = requestParams.get('contact_id');

        if(!String.isBlank(idContact) && (idContact.length() == 15 || idContact.length() == 18)){
            idContactOut = ContactHandler.doesContactExist('Id', idContact);
        }

        if(!String.isBlank(idContactOut)){
            System.debug('IdContact found : ' + idContactOut);
            return idContactOut;
        }

        // Step 1.2 : on le cherche via son numéro BP
        String bp = requestParams.get('contact_bp');

        if(!String.isBlank(bp)){
            idContactOut = ContactHandler.doesContactExist('Identifiant_Buisness_Partener__c', bp);
        }

        if(!String.isBlank(idContactOut)){
            System.debug('IdContact found : ' + idContactOut);
            return idContactOut;
        }

        // Step 1.3 : on le cherche via son email
        String email = requestParams.get('contact_email');

        if(!String.isBlank(email)){
            idContactOut = ContactHandler.doesContactExistByEmail(email);
        }

        if(!String.isBlank(idContactOut)){
            System.debug('IdContact found : ' + idContactOut);
            return idContactOut;
        }

        // Step 1.4 : on le cherche via son tel
        String tel = requestParams.get('contact_tel');

        if(!String.isBlank(tel)){
            idContactOut = ContactHandler.doesContactExistByPhone(tel);
        }

        if(!String.isBlank(idContactOut)){
            System.debug('IdContact found : ' + idContactOut);
            return idContactOut;
        }

        if(String.isBlank(idContactOut)){
            errorLog += 'Impossible de trouver le contact. Ce contact ou son compte n\'existe pas';
        }

        return idContactOut;
    }

    /*
    *   @description Recherche un case non clôturé associé au contact trouvé précédemment avec les champs type et sous-type passé en paramètre
    *   @param requestParams : les données passées par le WS
    *   @param contactId : le contact retrouvé dans l'étape d'avant
    */
    public static Map<String, String> findCase(Map<String, String> requestParams, String contactId){
        Map<String, String> outCase = new Map<String, String>();

        String type = requestParams.get('case_type');
        String sousType = requestParams.get('case_soustype');
        String statut = requestParams.get('case_statut');
        String sous_statut = requestParams.get('case_sousstatut');
        String origineCase = requestParams.get('case_origine');
        String sujet = requestParams.get('email_sujet');
        String recordtype = requestParams.get('case_recordtypeId');

        List<Case> cases = [SELECT Id, Status, Sous_Statut__c FROM Case WHERE ContactId =: contactId AND Type =: type AND Sous_type__c =: sousType AND IsClosed = false ORDER BY CreatedDate DESC];
        Case aCase = null;

        if(cases.size() > 0){
            aCase = cases[0];
        } else{
            aCase = new Case(ContactId = contactId,recordTypeId = recordtype, Subject = sujet, Status = statut, Sous_statut__c = sous_statut, Type = type, Sous_type__c = sousType, Origin = origineCase);
            
            try{
                insert aCase;
            } catch(DMLException e){
                system.debug('*** Case *** '+e);
                errorLog += 'Erreur technique lors de la création du case';
            }
        }

        outCase.put('id', aCase.id);
        outCase.put('statut', aCase.Status);
        outCase.put('sous_statut', aCase.Sous_statut__c);

        return outCase;
    }

    /*
    *   @description Crée l'email message à attacher au case
    *   @param requestParams : les données passées par le WS
    *   @param contactId : le contact retrouvé dans la première étape
    *   @param caseId : le case retrouvé dans l'étape d'avant
    *   @return l'ID de l'activité
    */
    public static EmailMessageWrapper createEmailMessage(Map<String, String> requestParams, String contactId, Id accountId){    
        EmailMessageWrapper emailMessageWrapper = new EmailMessageWrapper();
        String toAddresses = requestParams.get('email_toaddresses');
        String fromAddress = requestParams.get('email_fromaddresses');
        String subject = requestParams.get('email_sujet');
        String htmlBody = requestParams.get('email_content');
        /*String  = requestParams.get('');
        String  = requestParams.get('');*/
        
        EmailMessage emailMessage = new EmailMessage();
        emailMessage.status = '3'; // email was sent
        emailMessage.relatedToId = accountId; 
        emailMessage.Tech_Contact__c = contactId;
        emailMessage.fromAddress = fromAddress;
        emailMessage.subject =  subject;
        emailMessage.htmlBody = htmlBody;

        String[] toIds = new String[]{contactId}; 
        emailMessage.toIds = toIds;
        emailMessage.toAddress = toAddresses;
        // Amar
        emailMessage.Source__c = 'Dimelo';
        // Amar
        
        try{
            insert emailMessage; 
        } catch (DMLException e){
            errorLog = 'Erreur technique lors de la création de l\'Email';
        }

        emailMessage = [SELECT Id, ActivityId FROM EmailMessage WHERE Id =: emailMessage.Id];
        emailMessageWrapper.activityId = emailMessage.ActivityId;
        emailMessageWrapper.emailMessageId = emailMessage.Id;
        return emailMessageWrapper;
    }

    /*
    *   @description Update la tâche générée par l'email message
    *   @param requestParams : les données passées par le WS
    *   @param contactId : le contact retrouvé dans la première étape
    *   @param activityId : l'id de l'activité générée
    */
    public static void updateTask(Map<String, String> requestParams, String contactId, String activityId, Id accountId){
        String link = requestParams.get('email_link');
        String origine_correspondance = requestParams.get('task_origine');
        String direction = requestParams.get('direction_interaction');        
        

        Task aTask = new Task(Id = activityId, Description = link, WhoId = contactId, Origine_correspondance__c = origine_correspondance, Flux__c = direction);

        try{
            update aTask;
        } catch(DMLException e){
            system.debug('*** aka '+e);        
                errorLog += 'Impossible de mettre à jour la tâche.';

        }
    }
    
    public class EmailMessageWrapper{
        public String activityId;
        public String emailMessageId;
    }
}