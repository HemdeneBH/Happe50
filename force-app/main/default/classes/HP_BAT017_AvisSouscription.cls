/**
 * @description       : 

 * @author            : Ali AJELLAL 
 * @group             : 
 * @last modified on  : 10-21-2021

 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   02-11-2021   Ali AJELLAL   Initial Version




**/


global  with sharing class HP_BAT017_AvisSouscription implements Database.batchable<Object>, Schedulable, Database.RaisesPlatformEvents,Database.AllowsCallouts,Database.stateful,  HP_UTIL_BatchInterface {

    
    List<Object> listToAdd = null;
    Map<String,Id> idMap = new Map<String,Id>();
    Map<String,Id> souscriptionContactMap = new Map<String,Id>();
    public static final Integer BATCH_CHUNK_SIZE = 2000;

    global HP_BAT017_AvisSouscription() {}

    public List<Object> start(Database.batchableContext info){
         
        String body = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.AVIS_VERIFIES, '').getBody();
        listToAdd = (List<Object>)JSON.deserializeUntyped(body);
        List<String> idDigitalSouscription = new List<String>();
        System.debug('body************: '+ listToAdd);

        for (Object item : listToAdd) {
            Map<String,Object> data = (Map<String,Object>)item;
            idDigitalSouscription.add(String.valueOf(data.get('order_ref')));
        }

        for (HP_Souscription__c souscription : HP_EM005_Souscription.getSouscriptionsInfos(idDigitalSouscription)) {
            idMap.put(souscription.HP_Souscription_Digital_Id__c, souscription.Id);
            souscriptionContactMap.put( souscription.HP_Souscription_Digital_Id__c, souscription.HP_Contact__c);
       } 
        return  listToAdd;
    }    

    global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT017_AvisSouscription());
    }
    global static void execute(SchedulableContext sc){
        execute();
    }

    global static void execute(){
        HP_BAT017_AvisSouscription batchavis = new HP_BAT017_AvisSouscription();
        Database.executeBatch(batchavis, BATCH_CHUNK_SIZE);
    }

    public void execute(Database.batchableContext info, List<Object> scope){

        List<HP_NoteDeSatisfaction__c>  listNoteSatisfaction = new List<HP_NoteDeSatisfaction__c>();

        Set<String> idsDigital = new Set<String>();
        set<String> ids=new Set<String>();
        for (Object item : scope) {
            Map<String,Object> data = (Map<String,Object>)item;
            String idReview = String.valueOf(data.get('id_review'));
            String orderRef = String.valueOf(data.get('order_ref'));
            ids.add(idReview);
            ids.add(orderRef);
        }
        
        List<HP_NoteDeSatisfaction__c> noteSatisfactions = HP_EM041_NoteSatisfaction.getNoteSatisfaction(ids,idsDigital);
        Set<String> idReviewSet = new Set<String>();
        Set<String> orderRefSet = new Set<String>();
        for (HP_NoteDeSatisfaction__c fieldName : noteSatisfactions){
            idReviewSet.add(fieldName.HP_IdAvisVerifie__c);
            orderRefSet.add(fieldName.HP_ID_Souscription_Digital__c);
        }

       for (Object item : scope) {

        Map<String,Object> data = (Map<String,Object>)item;
        String idReview = String.valueOf(data.get('id_review'));      
            String orderRef = String.valueOf(data.get('order_ref'));

        //si la note existe déja => pas d'insertion 
            Boolean alreadyExiste = idReviewSet.contains(idReview) || orderRefSet.contains(orderRef) ;

            if( alreadyExiste == false){
            System.debug('im in************: ');
            HP_NoteDeSatisfaction__c noteSatisfaction = new HP_NoteDeSatisfaction__c();

            // prepare data





        String reviewDdate = String.valueOf(data.get('review_date'));
        String orderDate = String.valueOf(data.get('order_date'));
        Datetime dt = Datetime.valueOf(orderDate);
        String rate =  String.valueOf(data.get('rate'));
        String nps = String.valueOf(data.get('nps'));






        String review = String.valueOf( data.get('review'));
        String lastName = String.valueOf(data.get('lastname'));
        String firstName = String.valueOf(data.get('firstname'));
        String moderation = String.valueOf(data.get('moderation'));
                Id contactId = souscriptionContactMap.get(orderRef);
                Id souscriptionId =  idMap.get(orderRef);
            noteSatisfaction = HP_EM041_NoteSatisfaction.noteSatisfactionFromAvis( rate,nps,idReview,orderRef,souscriptionId,contactId,reviewDdate,dt,review,lastname,firstname,moderation );
            listNoteSatisfaction.add(noteSatisfaction);
        }
        System.debug('listNoteSatisfaction.size()************: '+listNoteSatisfaction.size());
    }

    if(listNoteSatisfaction.size()> 0) {
        Database.SaveResult[] srList = Database.insert(listNoteSatisfaction,false);
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted account. Account ID: ' + sr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());
                }
            }
        }
    }
   
}    
    
    global void finish(Database.batchableContext info){  
      
    }
}