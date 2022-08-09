/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-25-2022
 * @last modified by  : Hemdene Ben Hammouda
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   09-28-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class HP_SM040_CaseHandler {

    /**
    * @description 
    * @author Antoine Latour | 12-11-2020 
    * @param List<Case> caseList 
    * @return List<Case> 
    **/
    public static List<Case> filterByHappeListCase(List<Case> caseList) {
        if(caseList == null) return null;
        
        List<Case> result = new List<Case>();
        for(Case cas : caseList) {
            if(cas.HP_isHappe__c){
                result.add(cas);
            }
        }
        return result;
    }

    /**
    * @description 
    * @author Antoine Latour | 12-11-2020 
    * @param Map<Id Case> caseMap 
    * @return Map<Id, Case> 
    **/
    public static Map<Id, Case> filterByHappeMapCase(Map<Id, Case> caseMap) {
        if(caseMap == null) return null;
    
        Map<Id, Case> result = new Map<Id, Case>();

        for(Id caseId : caseMap.keySet()) {
            if(caseMap.get(caseId).HP_isHappe__c) {
                result.put(caseId, caseMap.get(caseId));
            }
        }
        return result;
    }

    /**
    * @description 
    * @author Antoine Latour | 12-11-2020 
    * @param List<Case> newList 
    * @param String rtReclamationId 
    * @param Map<Id Case> oldMap 
    **/
    public static void removeReclamationAPIAgilab(List<Case> newList, String rtReclamationId, Map<Id,Case> oldMap) {
        if(newList == null) return;

        List<Case> caseList = new List<Case>();
        for(Case cas : newList){
            if((cas.HP_Type__c == 'HP_Reclamation' || cas.HP_Type__c == 'HP_Mediation') && cas.HP_isHappe__c && cas.RecordtypeId == rtReclamationId && cas.IsClosed == true && oldMap.get(cas.Id).isClosed == false) {
                 caseList.add(cas);
            }
        }

        Set<String> caseIdList = new Set<String>();
        Set<String> contactIdList = new Set<String>();
        for(Case cas : caseList) {
            caseIdList.add(cas.id);
            contactIdList.add(cas.contactId);
        }

        if(caseIdList.size() > 0 && !System.isBatch()){
            HP_EM035_Reclamation.notifyAgilabReclamation(caseIdList, contactIdList, '0');
        }
    }

    /**
    * @description 
    * @author Antoine Latour | 12-11-2020 
    * @param List<Case> newList 
    * @param String rtReclamationId 
    **/
    public static void setReclamationAPIAgilab(List<Case> newList, String rtReclamationId) {
        if(newList == null) return;
    
        List<Case> caseList = new List<Case>();
        for(Case cas : newList){
            if((cas.HP_Type__c == 'HP_Reclamation' || cas.HP_Type__c == 'HP_Mediation') && cas.HP_isHappe__c && cas.RecordtypeId == rtReclamationId && cas.IsClosed == false) {
                 caseList.add(cas);
            }
        }

        Set<String> caseIdList = new Set<String>();
        Set<String> contactIdList = new Set<String>();
        for(Case cas : caseList) {
            caseIdList.add(cas.id);
            contactIdList.add(cas.contactId);
        }
 
       if(caseIdList.size() > 0 && !System.isBatch()){
         HP_EM035_Reclamation.notifyAgilabReclamation(caseIdList, contactIdList, '1');
        }
    }

    public static void processCoupureReduction(List<Case> newList, String rtFactureId){
        if(newList == null){
            return;
        } 
    
        List<Id> caseIds = new List<Id>();
        for(Case aCase : newList){
            if(aCase.HP_Type__c == 'HP_Coupure_ReductionPuissance'  && aCase.HP_isHappe__c && aCase.RecordtypeId == rtFactureId && aCase.IsClosed == false) {
                caseIds.add(aCase.Id);
            }
        }
        if(!caseIds.isEmpty()){
        HP_SM075_CoupureReduction.processCoupureReduction(caseIds);
        }
    }
    /**
    * @description 
    * @author Antoine Latour | 12-11-2020 
    * @param List<Case> newList 
    * @param String rtResiliationId 
    * @param String rtPrestationId 
    **/
    public static void updateCaseContrat(List<Case> newList, String rtResiliationId, String rtPrestationId) {
        if(newList == null) return;

        Map<String, Case> souscriptionCaseMap = new Map<String, Case>();
        List<Decimal> xdataIdList = new List<Decimal>();
        for(Case acase : newList) {
            if(acase.HP_isHappe__c && acase.HP_TECH_ExternalId__c != null && acase.RecordtypeId == rtResiliationId && Pattern.matches('[0-9]+', acase.HP_TECH_ExternalId__c)) {
                xdataIdList.add(Decimal.valueOf(acase.HP_TECH_ExternalId__c));
                acase.HP_TECH_ExternalId__c = 'CONTRACT_CANCELATION/' + acase.HP_TECH_ExternalId__c;
            } else if(acase.HP_isHappe__c && acase.HP_Souscription__c != null && acase.RecordtypeId == rtPrestationId ) {
                souscriptionCaseMap.put(acase.HP_Souscription__c, acase);
            }
            
        }
        List<HP_Contrat__c> contractList = [select Id, HP_Contrat_XdataId__c from HP_Contrat__c where HP_Contrat_XdataId__c in :xdataIdList];
        Map<Decimal, Id> xdataIdMap = new Map<Decimal, Id>();
        for(HP_Contrat__c cont : contractList) {
            xdataIdMap.put(cont.HP_Contrat_XdataId__c, cont.Id);
        }

        for(Case acase : newList) {
            try {
                if(acase.HP_TECH_ExternalId__c != null && acase.RecordtypeId == rtResiliationId) {
                    Decimal xdata = Decimal.valueOf(acase.HP_TECH_ExternalId__c.replace('CONTRACT_CANCELATION/', ''));
                    acase.HP_Contrat__c = xdataIdMap.get(xdata);
                }
            }catch(Exception e){
                system.debug(e.getStackTraceString());
            }

        }
        if(souscriptionCaseMap.size() > 0) {
            if(newList == null) {
                return;
            }
            List<HP_Souscription__c> sousList = [select Id,HP_type_Souscription__c,
            (select Id, HP_Contrat_XdataId__c,HP_Type_de_Compteur__c, HP_Proposition_Commerciale_XdataId__c from HP_Contrats__r)
            from HP_Souscription__c where Id in :souscriptionCaseMap.keySet()];
            for(Case acase : newList) {
                if(acase.HP_Souscription__c != null && acase.RecordtypeId == rtPrestationId){
                    for(HP_Souscription__c sous : sousList){
                        if(acase.HP_Souscription__c == sous.Id){
                            if(sous.HP_type_Souscription__c == 'MOVING_IN'){
                                acase.HP_TypePrestation__c = 'MES';
                            }
                            if(sous.HP_type_Souscription__c == 'SWITCH_SUPLIER'){
                                acase.HP_TypePrestation__c = 'CHF';
                            }
                        }
                    }
                }
            }
            for(HP_Souscription__c sous : sousList) {
                Case acase = souscriptionCaseMap.get(sous.Id);
                if(acase == null) {
                    continue;
                }
                for(HP_Contrat__c cont : sous.HP_Contrats__r) {
                    if((cont.HP_Type_de_Compteur__c == 'GAS' && acase.HP_Energy__c == 'Gas')
                    || (cont.HP_Type_de_Compteur__c == 'ELEC' && acase.HP_Energy__c == 'Electricity')) {
                        if(acase.HP_Contrat__c == null) {
                        acase.HP_Contrat__c = cont.Id;
                        }
                        if(acase.HP_TECH_ExternalId__c == null && acase.RecordtypeId == rtResiliationId) {
                            acase.HP_TECH_ExternalId__c = 'CONTRACT_CANCELATION/' + cont.HP_Contrat_XdataId__c;
                        }
                        if(acase.RecordtypeId == rtPrestationId && acase.HP_TECH_ExternalId__c == null) {
                            acase.HP_TECH_ExternalId__c = cont.HP_Proposition_Commerciale_XdataId__c+'HP_PrestationDistributeur' + cont.HP_Type_de_Compteur__c;    
                        }
                }
            }   
            }
        }
    }

    /**
    * @description 
    * @author Antoine Latour | 12-11-2020 
    * @param List<Case> newList 
    **/
    public static void createHistoryCase(List<Case> newList) {
       if(newList == null) return;

        List<HP_CaseHistory__c> caseHistoryList = new List<HP_CaseHistory__c>();
        System.debug('newList:'+newList);
        for(Case cas : newList){
            boolean isQqueue =  string.valueOf(cas.OwnerId).startsWith('00G');
            if( cas.IsClosed == false && cas.HP_isHappe__c && !isQqueue) {
                HP_CaseHistory__c caseHistory = new HP_CaseHistory__c();
                caseHistory = HP_EM036_CaseHistory.creatCaseHistory(cas, null, true);
                caseHistoryList.add(caseHistory);
                System.debug('caseHistory******* '+caseHistory);
            }
        }
        if(caseHistoryList.size() > 0)  Database.insert(caseHistoryList);
    }

	/**
    * @description 
    * @author Antoine Latour | 12-11-2020 
    * @param List<Case> newList 
    * @param Map<Id Case> newMap 
    * @param Map<Id Case> oldMap 
    * @param Integer dureeAttribution 
    **/
    public static void populateCreateHistoryCase(List<Case> newList, Map<Id,Case> newMap, Map<Id,Case> oldMap, Integer dureeAttribution) {
        if(newList == null) return;

        List<HP_CaseHistory__c> caseHistoryList = new List<HP_CaseHistory__c>();
        List<HP_CaseHistory__c> caseHistoryResponseList = new List<HP_CaseHistory__c>();

        String userId = UserInfo.getUserId();
        
         List <AgentWork> agentWorkAssigned = HP_EM037_AgentWork.getAgentWork(userId,'Assigned');
         System.debug('**************start afterUpdate******************');
         System.debug('agentWorkAssigned size:'+agentWorkAssigned.size());
       
          for(Case cas : newList){
              HP_CaseHistory__c caseHistory = new HP_CaseHistory__c();
              boolean isQqueue =  string.valueOf(cas.OwnerId).startsWith('00G');
              System.debug('isQqueue******* : '+isQqueue);

              if( cas.IsClosed == false && cas.HP_isHappe__c && (oldMap.get(cas.id).OwnerId != cas.OwnerId) && agentWorkAssigned.size() ==0 && !isQqueue ) {
              
                  caseHistory = HP_EM036_CaseHistory.creatCaseHistory(cas, null, true);
                  caseHistoryList.add(caseHistory);
                  System.debug('caseHistory******* '+caseHistory);
              }
          }
         if(caseHistoryList.size() > 0) Database.insert(caseHistoryList);

         // si 1èr changement de statut, alors ajouter les fields au niveau de HP_CaseHistory__c
         BusinessHours bh = [SELECT Id FROM BusinessHours WHERE name ='HP'];
         Set<String> caseIds = new Set<String>();
         System.debug(' newList******* : '+newList);
         System.debug('size newList******* : '+newList.size());
         
         for(Case cas : newList){
            boolean isQqueue =  string.valueOf(cas.OwnerId).startsWith('00G');
        
            boolean  isStatusChanged = oldMap.get(cas.id).Status != cas.Status; 
            boolean isTheSameOwner = (oldMap.get(cas.id).OwnerId == cas.OwnerId);

            if( cas.HP_isHappe__c && isTheSameOwner && agentWorkAssigned.size() ==0 && !isQqueue && isStatusChanged){
                caseIds.add(cas.Id);
            }
         }
         List<String> ids=new List<String>();
         ids.addAll(caseIds);
         System.debug('caseIds ******* : '+caseIds);
         //userId:utilisateur connecté
         List<HP_CaseHistory__c> listHistoriesWithDuplication = HP_EM036_CaseHistory.getCaseHistoryByListCase( userId , ids); 
         Set<String> caswithId = new Set<String>();
         for(HP_CaseHistory__c caseHistory : listHistoriesWithDuplication){
            caswithId.add(caseHistory.Case__c);
         }

         //si plusieurs caseHistory sans duréé de traitemnt, alors récuperer le dernier record
         List<HP_CaseHistory__c> listHistories = HP_EM036_CaseHistory.getCaseHistoryByListCaseAndUser( userId , caswithId); 
         System.debug('listHistories ******* : '+listHistories);
         for(HP_CaseHistory__c caseHistory : listHistories){
               
            Decimal result = BusinessHours.diff(bh.Id, caseHistory.HP_DateAttribution__c,DateTime.now());
              // milliseconds au minute
            Decimal resultingHours = result/(60*1000);
            System.debug('resultingHours ******* : '+resultingHours);
             // modifier les attributs: si date attribution -1h et si changement de status pour la 1er fois
            if(resultingHours < dureeAttribution &&  caseHistory.HP_DateChangementStatut__c == null){

                    caseHistory.HP_DateChangementStatut__c  = DateTime.now();
                    caseHistory.HP_ChangementStatutAncien__c   = oldMap.get(caseHistory.Case__c).Status;
                    caseHistory.HP_ChangementStatutNouveau__c   = newMap.get(caseHistory.Case__c).Status;
                    caseHistory.HP_DureeTraitement__c  = resultingHours;
                    caseHistoryResponseList.add(caseHistory);
            }
            
            System.debug('caseHistoryResponseList******* '+caseHistoryResponseList);
        }
        if(caseHistoryResponseList.size() > 0) Database.update(caseHistoryResponseList);
    }

    /**
    * @description 
    * @author Antoine Latour | 12-11-2020 
    * @param List<Case> newList 
    * @param Map<Id Case> oldMap 
    **/
    public static void populateDateAttributionPersonne(List<Case> newList, Map<Id,Case> oldMap) {
        if(newList == null) return;

        for(Case cas : newList) {
            boolean isQqueue =  string.valueOf(cas.OwnerId).startsWith('00G');
            if(cas.HP_isHappe__c && cas.IsClosed == false && (oldMap.get(cas.id).OwnerId != cas.OwnerId) && !isQqueue) {
                System.debug(' cas.HP_DateAttributionPersonne__c: '+ cas.HP_DateAttributionPersonne__c);
                if( cas.HP_DateAttributionPersonne__c == null){
                    cas.HP_DateAttributionPersonne__c =  DateTime.now();
                }
           }

        }
    }

    /**
    * @description 
    * @author Antoine Latour | 12-11-2020 
    * @param List<Case> newList 
    **/
    public static void flagCaseN1Queue(List<Case> newList) {
        if(newList == null) return;
        
        Map<ID, Group> queueMap = HP_Util_QueueManager.getQueueMapById();

        for(Case cas : newList) {
            if(string.valueOf(cas.OwnerId).startsWith('005') && cas.HP_TECH_Queue_N1_Status__c != 'OTHER_QUEUE') {
                cas.HP_TECH_Queue_N1_Status__c = 'USER';
            } else if(string.valueOf(cas.OwnerId).startsWith('00G')) {

                if(queueMap.get(cas.OwnerId).DeveloperName == 'HP_Niveau_1') {
                    cas.HP_TECH_Queue_N1_Status__c = 'N1';
                } else {
                    cas.HP_TECH_Queue_N1_Status__c = 'OTHER_QUEUE';
                }
            }

        }
    } 

    /**
    * @description 
    * @author Antoine Latour | 12-11-2020 
    * @param List<Case> newList 
    * @param Map<Id Case> oldMap 
    **/
	public static void updateStatusCaseQueue(List<Case> newList, Map<Id,Case> oldMap) {

        if(newList == null) return;

        System.debug('@@@@@@@@@@@@@@@@@ newList ' + newList);
        System.debug('@@@@@@@@@@@@@@@@@ oldMap ' + oldMap);
        
        String queueNi = HP_Util_QueueManager.getQueueIdByName('HP_Niveau_1');
        for(Case cas : newList) {
            final Boolean nullCheck = cas.Id == null || cas.OwnerId == null || oldMap.get(cas.Id) == null || oldMap.get(cas.Id).OwnerId == null;
            if(nullCheck) Continue;
            
            if(cas.OwnerId == queueNi && string.valueOf(oldMap.get(cas.Id).OwnerId).startsWith('005')) {
                cas.Status = 'NEW_CASE';

            } else if(string.valueOf(cas.OwnerId).startsWith('005') && string.valueOf(oldMap.get(cas.Id).OwnerId) == queueNi && cas.Status == 'NEW_CASE') {
                cas.Status = 'TO_DO';


            }
        }
    }

	/**
    * @description 
    * @author Antoine Latour | 12-11-2020 
    * @param List<Case> newList 
    **/
    public static void changeBusinessHour(List<Case> newList){
        if(newList == null) return;

        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE name ='HP'];

        System.debug('bh:'+bh);
        for(Case item : newList) {
            if(item.HP_isHappe__c && item.IsClosed == false) {
                item.BusinessHoursId = bh.Id;
           }
        }
    }

   /**
    * @description 
    * @author Antoine Latour | 12-11-2020 
    * @param List<Case> newList 
    * @param Map<Id Case> oldMap 
    **/
	public static void modifyOwnerIfRecordChange(List<Case> newList, Map<Id,Case> oldMap) {
        if(newList == null) return;

        for(Case cas : newList) {
            System.debug('@@ newList ' + cas.OwnerId);
            if(cas.OwnerId == null) {
                Continue;
            }
            

            if(!FeatureManagement.checkPermission('HP_BUSINESS_USER') || string.valueOf(cas.OwnerId).startsWith('005')) {

                return;
            }
            List<Schema.FieldSetMember> fields = Schema.SObjectType.Case.fieldSets.HP_Field_Changed_Change_Owner.getFields();


            for(Schema.FieldSetMember f : fields) {

                if(cas.get(f.getFieldPath()) != oldMap.get(cas.Id).get(f.getFieldPath()) ) {
                   if(!System.isBatch()) cas.OwnerId = UserInfo.getUserId();
                    System.debug('@@@@ modifyOwnerIfRecordChange OwnerId  AFTER' + cas.OwnerId);
                    if(cas.Status == 'NEW_CASE')

                    cas.Status = 'TO_DO';
                    System.debug('@@@@ modifyOwnerIfRecordChange ' + cas.status);

                    break;
                }
            }
        }
    }
	
	/**
    * @description 
    * @author Antoine Latour | 12-11-2020 
    * @param List<Case> newList 
    * @param Id rtChatId 
    **/
    public static void createHPChatCase(List<Case> newList, Id rtChatId) {
        if(newList == null) return;

        for(Case acase : newList) {
            if(acase.RecordTypeId == rtChatId) {
                acase = HP_EM010_Case.caseBuilder(acase, rtChatId);

            }
        }
    }

    /**
    * @description 
    * @author Antoine Latour | 12-11-2020 
    * @param List<Case> newList 
    **/
    public static void checkEscalade(List<Case> newList, Map<Id, Case> oldMap) {
        if(newList == null) return;

        Map<String, Group> queueMapGroup = HP_Util_QueueManager.getQueueMapByName();
        Map<String, Id> queueMapId = new Map<String, Id>();

        for(Group queue : queueMapGroup.values()) {
            if(queue.DeveloperName.startsWith('HP')) {
                queueMapId.put(queue.DeveloperName, queue.Id);
            }
        }

        for(Case acase : newList) {
            boolean isSet = !String.isBlank(acase.HP_QueueCible__c);
            boolean hasChanged = isSet && (acase.HP_QueueCible__c != oldMap.get(acase.Id).HP_QueueCible__c);

            if (hasChanged) {
               acase = HP_EM010_Case.escalade(acase, queueMapId);
            }
        }
    }


    /**
    * @description 
    * @author Antoine Latour | 23-02-2021 
    * @param List<Case> newList 
    **/
    public static void checkDuplication(List<Case> newList, String rtEmailId) {
        if(newList == null) return;

        Set<String> subjectSet = new Set<String>();
        Set<String> descriptionSet = new Set<String>();
        Set<String> contactSet = new Set<String>();
        Set<String> emailSet = new Set<String>();
        for(Case newCase : newList) {
            if(newCase.RecordTypeId == rtEmailId) {
                if (newCase.Subject != null) subjectSet.add(newCase.Subject);
                if (newCase.Description != null) descriptionSet.add(newCase.Description);
                if(newCase.ContactId != null) {
                    contactSet.add(String.valueOf(newCase.ContactId));
                }
                else if(newCase.SuppliedEmail != null) {
                    emailSet.add(newCase.SuppliedEmail);
                }
            }
        }

        Map<String, Case> casesMap = new Map<String, Case>();
        List<Case> existingCase = HP_EM010_Case.loadCases(subjectSet, descriptionSet, contactSet, emailSet, rtEmailId);
        for(Case testCase : existingCase) {
            String caseContact = '';
            if(testCase.ContactId != null) {
                caseContact = String.valueOf(testCase.ContactId);
            }
            else {
                caseContact = testCase.SuppliedEmail;
            }
            final String key = caseContact + '/' + testCase.Subject + '/' + testCase.Description;
            if(!casesMap.containsKey(key)) {
                casesMap.put(key, testCase);
            }
        }
        if(casesMap.values().size() > 0) {
            for(Case newCase : newList) {
                if(newCase.RecordTypeId == rtEmailId) {
                    String caseContact = '';
                    if(newCase.ContactId != null) {
                        caseContact = String.valueOf(newCase.ContactId);
                    }
                    else {
                        caseContact = newCase.SuppliedEmail;
                    }
        
                    final String key = caseContact + '/' + newCase.Subject + '/' + newCase.Description;
                    if(casesMap.containsKey(key)) {
                        newCase.Status = 'CANCELED';
                        newCase.HP_Comment__c = 'Annulé pour cause de duplication avec la requête : ' + casesMap.get(key).Id;
                    }
                }
            }
        }
        
    }

    /**
    * @description 
    * @author Antoine Latour | 23-02-2021 
    * @param List<Case> newList 
    **/
    public static void autoAssign(List<Case> newList) {
        if(newList == null) return;
        
        Id queueN1Id = HP_UTIL_QueueManager.getQueueIdByName('HP_Niveau_1');
        for (Case aCase : newList) {
            boolean hasOwner = !String.isBlank(aCase.OwnerId);
            if(!hasOwner) {
                aCase.OwnerId = queueN1Id;
            }
            else if(((String)aCase.OwnerId).startsWith('005')){
                String profileName = HP_UTIL_ProfileManager.getOwnerProfile(aCase.OwnerId);
                if(!profileName.startsWith('HP_Cons')) {
                aCase.OwnerId = queueN1Id;
            }
        }
    }
    }

    /**
    * @description 
    * @author Antoine Latour | 12-03-2021 
    * @param List<Case> newList 
    * @param Map<Id Case> oldMap 
    **/
    public static void notifyNewOwner(List<Case> newList, Map<Id, Case> oldMap) {
        if(newList == null) return;

        List<FeedItem> notificationsList = new List<FeedItem>();        
        List<String> casesIdForPSRToDelete = new List<String>();
        List<String> queueList = new List<String>();
        queueList.add(HP_Util_QueueManager.getQueueIdByName('HP_Niveau_1'));
        queueList.add(HP_Util_QueueManager.getQueueIdByName('HP_Niveau_2'));
        queueList.add(HP_Util_QueueManager.getQueueIdByName('HP_Niveau_3'));

        for(Case cas : newList) {
            final Boolean nullCheck = cas.Id == null || cas.OwnerId == null || oldMap.get(cas.Id) == null || oldMap.get(cas.Id).OwnerId == null;
            if(nullCheck) continue;


            final Boolean ownerChanged = cas.OwnerId != oldMap.get(cas.Id).OwnerId;
            if(!ownerChanged) continue;

            final Boolean ownerIsUser = string.valueOf(cas.OwnerId).startsWith('005');
            if(!ownerIsUser) continue;
            

            Set<String> recipients = new Set<String>();
            recipients.add(cas.OwnerId);
            HP_UTIL_CustomNotificationsManager.sendNotificationCaseOwnerChange(recipients, cas.Id);

            final Boolean ownerWasQueue = queueList.contains(string.valueOf(oldMap.get(cas.Id).OwnerId));
            if(ownerWasQueue) {
                casesIdForPSRToDelete.add(cas.Id);
            }
        }
        /** Changement sur la classe. */
        if(casesIdForPSRToDelete.size() > 0) HP_SM037_OmnichannelFiltering.deletePSR(casesIdForPSRToDelete);
    }
}