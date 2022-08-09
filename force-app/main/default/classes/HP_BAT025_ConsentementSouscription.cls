/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-21-2021
 * @last modified by  : Hemdene Ben Hammouda
**/
global class HP_BAT025_ConsentementSouscription implements Database.Batchable<sObject>, Database.AllowsCallouts, System.Schedulable, Database.RaisesPlatformEvents, HP_UTIL_BatchInterface {
    public static final Integer BATCH_CHUNK_SIZE = 1;

    final String fields = 'Id, HP_Contact__c,HP_Souscription__c.HP_Contact__r.ID_Tiers__c,HP_TECH_ConsentementIncrement__c, Hp_consentementQ1_1__c,Hp_consentementQ1_2__c,Hp_consentementQ1_3__c,Hp_consentementXdata__c';


    final String whereCondition = 'Hp_consentementXdata__c=false AND HP_Statut__c=\'SAVE_3\'' ;

    global String query = 'select ' + fields + ' from HP_Souscription__c where ' + whereCondition;  

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug(query);
        return Database.getQueryLocator(query);
    }

    global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT025_ConsentementSouscription());
    }

    global static void execute(SchedulableContext sc){
        execute();
    }

    global static void execute(){
        HP_BAT025_ConsentementSouscription batchCaseDedup = new HP_BAT025_ConsentementSouscription();
        Database.executeBatch(batchCaseDedup, BATCH_CHUNK_SIZE);
    }

    global void execute(Database.BatchableContext bc, List<HP_Souscription__c> souscriptionList) { 
        if(souscriptionList.isEmpty()){
            return;
        }

        List<Case> casestoInsert = new List<Case>(); 
        for(HP_Souscription__c souscription : souscriptionList){

            Decimal idXdataPersonne = souscription.HP_Contact__r.ID_Tiers__c;
            Boolean consent1 = souscription.Hp_consentementQ1_1__c;
            Boolean consent2 = souscription.Hp_consentementQ1_2__c;
            Boolean consent3 = souscription.Hp_consentementQ1_3__c;

            try{
                List<HP_WRP031_APIHourConsentements> listReponse = HP_CALL001_XDATA.getReponsesConsentement(Integer.valueOf(idXdataPersonne));
                if(listReponse == null){
                    listReponse = new List<HP_WRP031_APIHourConsentements>();
                }

                if(souscription.HP_TECH_ConsentementIncrement__c<6){
                    System.debug('****tech increment < 5: '+ listReponse);
                    if(!listReponse.isEmpty()){
                    System.debug('**** ListReponse isnt empty: '+ listReponse);

                        Boolean q11Sent = false;
                        Boolean q12Sent = false;
                        Boolean q13Sent = false;
                        
                        for ( HP_WRP031_APIHourConsentements item : listReponse ){
                            System.debug('### Item : '+item);
                            System.debug('****test inside loop!!');
                            System.debug('****item.idQuestionnaire == 1'+ (item.idQuestionnaire == 1));
                            System.debug('****item.idQuestion == 1'+ (item.idQuestion == 1));
                            System.debug('****item.idQuestion == 2'+ (item.idQuestion == 2));
                            System.debug('****item.idQuestion == 3'+ (item.idQuestion == 3));

                            if(item.idQuestionnaire == 1){
                                if(item.idQuestion == 1){
                                    System.debug('****q11putBefore');
                                    String q11 = createQuestionPut(idXdataPersonne,1,consent1,item.id);
                                    HP_CALL001_XDATA.sendConsentResponses(q11);
                                    q11Sent = true;
                                    System.debug('****q11putAfter');
                                }

                                if(item.idQuestion == 2){
                                    System.debug('****q12putBefore');
                                    String q12 = createQuestionPut(idXdataPersonne,2,consent2,item.id);
                                    HP_CALL001_XDATA.sendConsentResponses(q12);
                                    q12Sent = true;
                                    System.debug('****q12putAfter');
                                }

                                if(item.idQuestion == 3){
                                    System.debug('****q13putBefore');
                                    String q13 = createQuestionPut(idXdataPersonne,3,consent3,item.id);
                                    HP_CALL001_XDATA.sendConsentResponses(q13);
                                    q13Sent = true;
                                    System.debug('****q13putAfter');
                                } 
                            }
                            
                        }

                        if(q11Sent == false){
                            System.debug('****q11postBefore');
                            String q11 = createQuestionPost(idXdataPersonne,1,consent1);
                            HP_CALL001_XDATA.creerConsentement(q11);
                            System.debug('****q11postAfter');
                        }

                        if(q12Sent == false){
                            System.debug('****q12postBefore');
                            String q12 = createQuestionPost(idXdataPersonne,2,consent2);
                            HP_CALL001_XDATA.creerConsentement(q12);
                            System.debug('****q12postAfter');
                        }

                        if(q13Sent == false){
                            System.debug('****q13postBefore');
                            String q13 = createQuestionPost(idXdataPersonne,3,consent3);
                            HP_CALL001_XDATA.creerConsentement(q13);
                            System.debug('****q13postAfter');

                        }
                        souscription.Hp_consentementXdata__c = true;
                        System.debug('****consentement XData: '+ souscription.Hp_consentementXdata__c);


                    }else{
                        String q11 = createQuestionPost(idXdataPersonne,1,consent1);
                        String q12 = createQuestionPost(idXdataPersonne,2,consent2);
                        String q13 = createQuestionPost(idXdataPersonne,3,consent3);
                        System.debug('****Listresponse is empty : '+ listReponse);
                        HP_CALL001_XDATA.creerConsentement(q11);
                        System.debug('****q11ListPost : ');
                        HP_CALL001_XDATA.creerConsentement(q12);
                        System.debug('****q12ListPost : ');
                        HP_CALL001_XDATA.creerConsentement(q13);
                        System.debug('****q13ListPost : ');
                        souscription.Hp_consentementXdata__c = true;
                        System.debug('****consentement XData: '+ souscription.Hp_consentementXdata__c);
                    }
                }else{
                    Case consentementCase = new Case();
                    consentementCase.RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case','HP_ContractErrorSave3');
                    consentementCase.Subject = 'Enregistrements consentements Xdata KO';
                    consentementCase.Priority ='Low';
                    consentementCase.OwnerId = HP_UTIL_QueueManager.getQueueIdByName('HP_Niveau_1');
                    consentementCase.Status ='NEW_CASE';
                    consentementCase.HP_Type__c ='HP_ConsentementsDigital';
                    consentementCase.Reason ='HP_EnrolmentError';
                    consentementCase.HP_Souscription__c =souscription.Id;
                    consentementCase.Origin ='HP_CRM';
                    consentementCase.ContactId = souscription.HP_Contact__c;
                    casestoInsert.add(consentementCase);
                    souscription.Hp_consentementXdata__c= true;
                }
            }catch(CalloutException e){
                System.debug('****exception catched :'+ e.getMessage());
                souscription.HP_TECH_ConsentementIncrement__c = souscription.HP_TECH_ConsentementIncrement__c + 1;
            }
        }
        if (!casestoInsert.isEmpty()) {
            insert casestoInsert;
        }
        update souscriptionList;       
    }

    global void finish(Database.BatchableContext bc){
        
    }

    global static string createQuestionPut (Decimal idXdata, Integer idquestion, Boolean consent,String id){

        Map<String, Object> q = new Map<String, Object>(); 
        q.put('idPersonne' , Integer.valueOf(idXdata));
        q.put('idQuestionnaire' , 1);
        q.put('idQuestion' , idquestion );
        q.put('consent' , consent);
        q.put('canal' , 'Web');
        q.put('application' , 'HAPPE');
        q.put('id' , id);
        String cons = JSON.serialize(q);
        cons='['+cons+']';
        System.debug('****question created: '+idquestion);
        return cons;
    }

    global static string createQuestionPost (Decimal idXdata, Integer idquestion, Boolean consent){

        Map<String, Object> q = new Map<String, Object>(); 
        q.put('idPersonne' , Integer.valueOf(idXdata));
        q.put('idQuestionnaire' , 1);
        q.put('idQuestion' , idquestion );
        q.put('consent' , consent);
        q.put('canal' , 'Web');
        q.put('application' , 'HAPPE');
        String cons = JSON.serialize(q);
        cons='['+cons+']';
        System.debug('****question created: '+idquestion);
        return cons;
    }
}