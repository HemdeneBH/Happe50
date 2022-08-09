@RestResource(urlMapping ='/MailCorrespondence')
global class SM_MailCorrespondence {
    public static String errorLog;    
    /*
* @Author: Amine Deghais ~ amine.deghais@external.engie.com
* @Date: 18/09/2019
* @Description: Création Case suite à la correspondance COURRIER
*/
    @HttpPost
    global static Map<String, String>  mailCorrespondence() {
        errorLog = '';
        SM_CreateDimeloMessage createDimeloMessage =new SM_CreateDimeloMessage();
        EmailMessageWrapper emailMessageWrapper = new EmailMessageWrapper();
        emailMessageWrapper.emailMessageId = '';
        Map<String, String> outMap = new Map<String, String>(); 
        Id accountId = null;
        String requestStr = RestContext.request.requestBody.toString();  
        Map<String, String> paramsMap = (Map<String,String>) JSON.deserialize(requestStr, Map<String,String>.class);    
        System.debug('Tram:'+paramsMap);
        paramsMap.put('task_origine','Courrier');
        
         if(String.isBlank(paramsMap.get('contact_id')) && String.isBlank(paramsMap.get('contact_bp'))
            && String.isBlank(paramsMap.get('contact_email')) && String.isBlank(paramsMap.get('contact_tel'))){
               outMap.put('case_id', null);
               outMap.put('case_statut', null);
               outMap.put('case_sousstatut', null);
               outMap.put('contact_id', null);
               errorLog +=  'Veuillez renseigner un identifiant du client svp.';
               outMap.put('error', errorLog);
               outMap.put('emailMessage',null);
               return outMap;
           }
        
        if(paramsMap.get('ToCreateCase')=='true' && String.isBlank(paramsMap.get('Type_Doc'))){
            outMap.put('case_id', null);
            outMap.put('case_statut', null);
            outMap.put('case_sousstatut', null);
            outMap.put('contact_id', null);
            errorLog +=  'Impossible de créer le case, le champ type document est obligatoire.';
            outMap.put('error', errorLog);
            outMap.put('emailMessage',null);
            return outMap;
        }

        // Step 1 : on cherche le contact        
        String contactId = SM_CreateDimeloMessage.findContact(paramsMap);
        
        // Amar
        if(!String.isBlank(contactId)){
            accountId = [select AccountId from contact where id=:contactId limit 1].AccountId;    
        }else{
            outMap.put('case_id', null);
            outMap.put('case_statut', null);
            outMap.put('case_sousstatut', null);
            outMap.put('contact_id', null);
            errorLog =  'Impossible de trouver le contact. Ce contact ou son compte n\'existe pas';
            outMap.put('error', errorLog);
            outMap.put('emailMessage',null);
            return outMap; 
        }
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
            
            // Step 2 : on cherche le case, ou on le crée le cas échéant si ToCreateCase=='true'
            if(paramsMap.get('ToCreateCase')=='true'){
                Map<String, String> caseInfo = findCase(paramsMap.get('Type_Doc'), contactId);
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
            if(emailMessageWrapper.emailMessageId != null){
                // Step 4 : update la task avec l'id du contact et le lien du document      
                updateTask(paramsMap, contactId,emailMessageWrapper.activityId, accountId);
            }
           
            //lineCourrierDarkOne le mettre dans activité
        }
        outMap.put('contact_id', contactId);
        outMap.put('error', errorLog);
         outMap.put('emailMessage',emailMessageWrapper.emailMessageId);
        
        return outMap;
    }
    
    
    /* @Author: Amine Deghais ~ amine.deghais@external.engie.com
* @Date: 18/09/2019
*   @description Recherche un case non clôturé associé au contact trouvé précédemment avec les champs type et sous-type passé en paramètre
*   @param requestParams : les données passées par le WS
*   @param contactId : le contact retrouvé dans l'étape d'avant
@return l'ID&status&sous_status  du case
*/
    public static Map<String, String> findCase(String Type_Doc, String contactId){
        
        Map<String, String> outCase = new Map<String, String>();
        // recuperer le matching case
        SM_Matching_Case__mdt  matchingCase=matchingCase(Type_Doc);
        system.debug(matchingCase.Record_Type_Case__c);
        Id recordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get(matchingCase.Record_Type_Case__c).getRecordTypeId();
        
        List<Case> cases = [SELECT Id, Status, Sous_Statut__c FROM Case WHERE ContactId =: contactId AND Type =: matchingCase.Type_Case__c AND Sous_type__c =: matchingCase.Sub_Type_Case__c AND IsClosed = false  ORDER BY CreatedDate DESC];
        Case aCase = null;
        
        if(cases.size() > 0){
            aCase = cases[0];
        } else{
            aCase = new Case(ContactId = contactId,recordTypeId = recordTypeId, Type = matchingCase.Type_Case__c, Sous_type__c = matchingCase.Sub_Type_Case__c,  Status = 'En attente', Sous_statut__c= 'Affectation symphonie', Origin = 'Courrier');  
            system.debug(aCase);
            try{
                insert aCase;
            } catch(DMLException e){
                system.debug('*** Case *** '+e);
                errorLog += 'Erreur technique lors de la création du Case';
            }
        }
        
        outCase.put('id', aCase.id);
        outCase.put('statut', aCase.Status);
        outCase.put('sous_statut', aCase.Sous_statut__c);
        
        return outCase;
    }
    
    
    /* @Author: Amine Deghais ~ amine.deghais@external.engie.com
* @Date: 18/09/2019
*@description rechercher le matching entre type doc<=> (type_case,Sous_type_case)
*@param type_doc type du document 
*@return type_case,Sous_type_case
*/
    public static SM_Matching_Case__mdt matchingCase(String typeDoc){
        
        List<SM_Matching_Case__mdt> matchingCases=[select Type_Doc__c,Type_Case__c,Sub_Type_Case__c,Record_Type_Case__c  from SM_Matching_Case__mdt where Type_Doc__c LIKE :('%' + typeDoc + '%')];
        SM_Matching_Case__mdt matchingCase=null;
        for (SM_Matching_Case__mdt mcItem : matchingCases) {
            // chercher si le typedoc existe au debut
            if(mcItem.Type_Doc__c.contains(typeDoc+'&')){
                matchingCase= mcItem;
                break;
                // chercher si le typedoc existe a la fin
            }else if(mcItem.Type_Doc__c.contains('&'+typeDoc)){
                matchingCase= mcItem;
                break;
                // chercher si le typedoc existe au milieu
            }else if (mcItem.Type_Doc__c.contains('&'+typeDoc+'&')){
                matchingCase= mcItem;
                break;
                // chercher si le typedoc egal
            }else if (mcItem.Type_Doc__c.equals(typeDoc)){
                matchingCase= mcItem;   
            }
        }
        return matchingCase;
        
    }
    
       /* @Author: Amine Deghais ~ amine.deghais@external.engie.com
*@Date: 06/11/2019  
*@description Crée l'email message sans l'attacher au case
*@param requestParams : les données passées par le WS
*@param contactId : le contact retrouvé dans la première étape
*@return l'ID de l'activité
*/
    public static EmailMessageWrapper createEmailMessage(Map<String, String> requestParams, String contactId, Id accountId){
        EmailMessageWrapper emailMessageWrapper = new EmailMessageWrapper();
        String toAddresses = requestParams.get('courrier_toaddresses');
        String fromAddress = requestParams.get('courrier_fromaddresses');
        String subject = requestParams.get('courrier_sujet');
        String htmlBody = requestParams.get('courrier_content');
        /*String  = requestParams.get('');
String  = requestParams.get('');*/
        
        EmailMessage emailMessage = new EmailMessage();
        emailMessage.status = '3'; // email was sent
        emailMessage.relatedToId =[select AccountId from contact where id=:contactId limit 1].AccountId; 
        emailMessage.Tech_Contact__c = contactId;
        emailMessage.FromName = fromAddress;
      //  emailMessage.fromAddress = fromAddress;
        emailMessage.subject = requestParams.get('task_origine')+' '+requestParams.get('direction_interaction');
        //EmailMessage.WhoId=contactId;
        
        // requeter l'URL de l'environnement actuel
         docUrlPerOrg__mdt[] orgInfos = [select url__c from docUrlPerOrg__mdt where orgId__c =: UserInfo.getOrganizationId()];
        if(requestParams.get('courrier_link')!=null&&requestParams.get('courrier_link')!=''){
        // Définir un URL par défault --> Celui de de l'UAT
         String orgURL = Label.SM_CourrierLink;  
        // Si un URL pour l'environement existe, on l'utilise.
            if(orgInfos.size() > 0){
                orgURL = orgInfos[0].url__c;
            }
            htmlBody=+'<br><a href='+orgURL+requestParams.get('courrier_link')+'>Lien Courrier</a></br>';
        }
        emailMessage.htmlBody = htmlBody;
        
        String[] toIds = new String[]{contactId}; 
            emailMessage.toIds = toIds;
       // emailMessage.toAddress = toAddresses;
        // Amar
        emailMessage.Source__c = 'Courrier';
        // Amar
        
        try{
            insert emailMessage; 
              emailMessage = [SELECT Id, ActivityId FROM EmailMessage WHERE Id =: emailMessage.Id];
            emailMessageWrapper.activityId = emailMessage.ActivityId;
            emailMessageWrapper.emailMessageId = emailMessage.Id;
            system.debug('create mail success');
        } catch (DMLException e){
            System.debug(' #### aka error' + e);
            errorLog = 'Impossible de créer l\'email message';
            System.debug('error create mail'+e);
        }
       
        return emailMessageWrapper;
    }
    /* @Author: Amine Deghais ~ amine.deghais@external.engie.com
*@Date: 06/11/2019  
*   @description Update la tâche générée par l'email message
*   @param requestParams : les données passées par le WS
*   @param contactId : le contact retrouvé dans la première étape
*   @param activityId : l'id de l'activité générée
*/
    public static void updateTask(Map<String, String> requestParams, String contactId, String activityId, Id accountId){
        String origine_correspondance = requestParams.get('task_origine');
        String direction = requestParams.get('direction_interaction');
        Task aTask;
        if(!Test.isRunningTest()){
            aTask = new Task(Id = activityId,RecordTypeId=Schema.SObjectType.Task.getRecordTypeInfosByName().get('SMILE').getRecordTypeId(), WhoId = contactId, Origine_correspondance__c = origine_correspondance, Flux__c = direction);
        }          
        
        try{
            if(!Test.isRunningTest()){
            update aTask;
            }
        } catch(DMLException e){
            system.debug('*** updateTask:'+e);
            errorLog += 'Impossible de mettre à jour la tâche.';
            
        }
    }
    
     public class EmailMessageWrapper{
        public String activityId;
        public String emailMessageId;
    }
}