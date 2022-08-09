/*
* @Auhtor: Ayoub El Farissi
* @Date: 08/03/2022
* @Description: un batch pour l'envoie des demandes de suppression des demandes de routage Genesys
*/

public without sharing class SM_BAT08_GenesysDeleteRequest implements Database.Batchable<sObject>, Database.Stateful , Database.AllowsCallouts{
    // Nombre de cases traités par le batch
    public Integer recordsProcessed = 0;
    public Integer recordsFailed = 0;
    // tracer les cases ou il y'a des erreurs
    public list<String> casesFailed = new list <String>(); 
    // Nombre de records qui vont être traiter par le batch SM_BAT08_GenesysDeleteRequest
    public Integer queryLimit;
    
    // Récupération des cases qui ont une demandes de routage en cours chez Genesys
    public String query = 'Select Id, PureCloud_conversationId__c, SM_Tech_SupprimerGenesys__c, SM_Tech_EnvoyerGenesys__c, SM_Tech_GenesysAttributes__c FROM Case '+
        'WHERE SM_Tech_EnvoyerGenesys__c = true OR (SM_Tech_SupprimerGenesys__c = true AND PureCloud_conversationId__c != null) Order by CreatedDate desc LIMIT :queryLimit';
    
    // Récupération du suffixe du WS DemandeSuppressionGenesys
    String api = 'DemandeSuppressionGenesys';
    SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername =: api limit 1];
    
    // Constructeur avec paramètre queryLimit
    public SM_BAT08_GenesysDeleteRequest(Integer queryLimit) {
        this.queryLimit = queryLimit;
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<Case> cases){
        // List des cases à mettre à jour une fois on termine l'envoie des demandes de routage
        list <case> editedCases = new list <case>();
        
        // Liste des demandes de routage qui va etre envoyer à Genesys
        list<purecloud__PureCloud_Routing_Request__c> requests = new  list<purecloud__PureCloud_Routing_Request__c>();
        
        HttpResponse response;
        
        
        for(Case caseRecord: cases){
            try {
                // Traitement en cas de demande de suppression
                if(caseRecord.SM_Tech_SupprimerGenesys__c == true){
                    if(!Test.IsRunningTest()){
                        // Appel à l'SDK Purecloud pour supprimer une demandes de routage
                        String endpointURL = suffixs.suffix__c + caseRecord.PureCloud_conversationId__c + '/disconnect';
                        response = purecloud.SDK.Rest.post(endpointURL,'', new Map<String, String>());
                    } else {
                        // Utilisation du Mock lors des tests
                        SM_BAT08_GenesysDeleteRequest_Mock mock = new SM_BAT08_GenesysDeleteRequest_Mock();
                        HTTPRequest request = new HTTPRequest();
                        response = mock.respond(request);
                    }
                    
                    if(response.getStatusCode() == 200){
                        // Mettre à jour les champs conversationId et SM_Tech_SupprimerGenesys__c (champ technique utilisé par le batch pour identifier les demandes à supprimer)
                        caseRecord.SM_Tech_SupprimerGenesys__c = false;
                        caseRecord.PureCloud_conversationId__c = '';
                        editedCases.add(caseRecord);
                        recordsProcessed++;
                    } else {
                        // tracer les erreurs en utilisant la liste casesFailed si on a une message de retour différent de 200
                        casesFailed.add('Delete routing failed => CaseId : ' + caseRecord.Id + ' Response : ' + response.getBody());
                        recordsFailed++;
                    }
                    // Traitement en cas d'envoi de demande
                }else if(caseRecord.SM_Tech_EnvoyerGenesys__c == true){
                    purecloud__PureCloud_Routing_Request__c req = new purecloud__PureCloud_Routing_Request__c();
                    req.purecloud__Attributes__c = caseRecord.SM_Tech_GenesysAttributes__c;
                    req.purecloud__Inbound_Email_Flow__c = System.Label.purecloud_Inbound_Email_Flow;
                    req.purecloud__Salesforce_Object_ID__c = caseRecord.Id;
                    caseRecord.SM_Tech_EnvoyerGenesys__c = false;
                    caseRecord.SM_Tech_GenesysAttributes__c = '';
                    editedCases.add(caseRecord);
                    requests.add(req);
                    recordsProcessed++;
                }
                
            } catch (DMLException e){
                System.debug('Erreur technique lors de l appel du purecloud.SDK disconnect ' + e.getMessage());
            }
        }
        
        try{
            // Modification en masse des cases de demande de suppression traités pour faire un seul appel
            if(!editedCases.isEmpty() && editedCases != null)
                update editedCases;
            // Insértion des infos des cases de demande de routage traités sur l'objet purecloud__PureCloud_Routing_Request__c
            if(!requests.isEmpty() && requests != null)
                insert requests;    
        } catch (DMLException e){
            System.debug('Erreur technique : ' + e.getMessage());
        }
    }
    
    public void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records traités.');
        System.debug(recordsFailed + ' records échoués.');
        if(recordsFailed > 0 || Test.IsRunningTest())
            sendMail();
    }
    
    // Envoi compte rendu du traitement via email
    public void sendMail(){
        string errors = '';
        for (String record : casesFailed){
            errors = errors + record + '.<p>';
        }
        // Le mail qui va contenir le compte rendu du traitement de SM_BAT08_GenesysDeleteRequest
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        // La liste des personnes qui vont recevoir le mail
        List<String> sendTo = new List<String>();
        sendTo.add(System.Label.GenesysDeleteRequestErrors_SendTo);
        mail.setToAddresses(sendTo);        
        
        // Configurer le nom utiliser lors de l'envoi de mail
        mail.setSenderDisplayName('Engie Support');
        
        // Configurer l'objet du mail
        mail.setSubject('SM_BAT08_GenesysDeleteRequest - Compte rendu du traitement de demande de suppression Genesys : ' + System.now());
        
        String mailBody = 'Records traités : ' + recordsProcessed +'.<p>'+
            'Records échoués : ' + recordsFailed +'.<p>'+
            'Erreurs :<p>' + errors;
        
        mail.setHtmlBody(mailBody);
        try{
            // Envoi de compte rendu via mail
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            system.debug('Mail envoyé!');
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
}