public with sharing class SM_RGPD_PurgeDonneesInvocable {
    @InvocableMethod
    public static void execute (List<Requests> requestList) {
        String operation = requestList[0].operation;
        if(operation.equals('DeleteRelatedRecords')){
            // récupérer les paramètres envoyés par le flow
            String contactId = requestList[0].contactId;
            List<Case> casesList = requestList[0].casesList;
            List<Task> tasksList = requestList[0].tasksList;

            // variables pour stocker les Ids des enregistrements
            Set<Id> casesIds = new Set<Id>();
            Set<Id> tasksIds = new Set<Id>();
            Set<Id> accountIds = new Set<Id>();

            // variables pour stocker les enregistrements à supprimer
            List<Donnees_Vente__c> donneesVenteToDelete= new  List<Donnees_Vente__c>();
            List<EmailMessage> emailMessagesToDelete = new  List<EmailMessage>();
            List<Order> ordersToDelete = new  List<Order>();
            List<Order> ordersToUpdateDraft = new  List<Order>();
            List<Account> accountsToDelete = new List<Account>();
            
            // récupérer les Ids des cases et tasks
            if(casesList != null && casesList.size() > 0){
                for(Case c: casesList)
                    casesIds.add(c.Id);
            }
            if(tasksList != null && tasksList.size() > 0){
                for(Task t: tasksList)
                    tasksIds.add(t.Id);
            }

            // récupérer les enregistrements données vente
            donneesVenteToDelete = [SELECT Id FROM Donnees_Vente__c WHERE CaseId__c IN :casesIds];
            
            // récupérer les enregistrements EmailMessage
            emailMessagesToDelete = [SELECT Id FROM EmailMessage WHERE Case__c IN :casesIds OR ActivityId IN :tasksIds];

            // récupérer les enregistrements Orders
            ordersToDelete = [SELECT Id,Status FROM Order WHERE Case__c IN :casesIds];
            
            // Mettre les orders activés à Draft avant de les supprimer
            for(Order ord:ordersToDelete){
                if(ord.Status.equals('Activated')){
                    ord.status='Draft';
                    ordersToUpdateDraft.add(ord);
                }
            }

            // récupérer les enregistrements Accounts
            List<AccountContactRelation> acrs = [SELECT id, Accountid FROM AccountContactRelation Where contactId= :contactId and isDirect=false];
            for(AccountContactRelation acr: acrs)
                accountIds.add(acr.accountId);
            accountsToDelete= [SELECT id FROM Account WHERE Id IN :accountIds];


            System.debug('donneesVenteToDelete'+donneesVenteToDelete);
            System.debug('emailMessagesToDelete'+emailMessagesToDelete);
            System.debug('ordersToDelete'+ordersToDelete);
            System.debug('accountsToDelete'+accountsToDelete);

            // suppression des enregistrements
            try{
                delete donneesVenteToDelete;
                delete emailMessagesToDelete;
                update ordersToUpdateDraft;
                delete ordersToDelete;
                delete accountsToDelete;
            }catch(DmlException e){
                System.debug('#### GDPR Error'+ e);
            }
        }else if(operation.equals('sendConfirmation')){
            // vérifier le contenu du message à envoyer
            RGPD_PurgeDonneesIdentification__e eventObject = requestList[0].eventObject;
            String messageBody =  transformApiMessageBody(eventObject);
            sendPurgeConfirmation(messageBody);
        }
        
    }
    
public static String transformApiMessageBody(RGPD_PurgeDonneesIdentification__e eventObject){
    Map<String, Object> cleObjet = new Map<String, Object>();
    cleObjet.put('idTiers', eventObject.idTiers__c);
    cleObjet.put('noPortefeuilleContrat', eventObject.noPortefeuilleContrat__c);
    cleObjet.put('noContrat', eventObject.noContrat__c);
    cleObjet.put('idPortefeuilleContrat', eventObject.idPortefeuilleContrat__c);
    cleObjet.put('noBp', eventObject.noBp__c);
    cleObjet.put('idContrat', eventObject.idContrat__c);
    Map<String, Object> dataInside = new Map<String, Object>();
    dataInside.put('idDemande', eventObject.idDemande__c);
    dataInside.put('cleObjet', cleObjet);
	Map<String, Object> data = new Map<String, Object>();
    data.put('eventVersion', '1.0');
    data.put('eventSource', 'SMILE');
    data.put('eventTime', Datetime.now().format('yyyy-MM-dd hh:mm:ss'));
    data.put('eventType', eventObject.eventType__c+'OK');
    data.put('eventSubType', eventObject.eventSubType__c);
    data.put('eventId', eventObject.id);
    data.put('parentEventId', eventObject.eventId__c);
    data.put('data', dataInside);
    Map<String, Object> bodyObj = new Map<String, Object>();
    bodyObj.put('data', data);
    bodyObj.put('partition-key', '1');
    return JSON.serialize(bodyObj);
} 
    
@future(callout = true)
public static void sendPurgeConfirmation(String messageBody){
    SM_StreampurgeApiService.callStreampurgeApi(messageBody);
} 
public class Requests {
  @InvocableVariable(label='opération' description='L\'opération à executer')
  public String operation;
  @InvocableVariable(label='contactId' description='L\'id du contact impacté par RGPD')
  public String contactId;
  @InvocableVariable(label='casesList' description='La list des cases du contact impacté par RGPD')
  public List<Case> casesList;
  @InvocableVariable(label='tasksList' description='La list des tâches du contact impacté par RGPD')
  public List<Task> tasksList;
  @InvocableVariable(label='eventObject' description='La platform event object')
  public RGPD_PurgeDonneesIdentification__e eventObject;
  }
  
}