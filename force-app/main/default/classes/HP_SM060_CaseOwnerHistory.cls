/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   03-05-2021   Antoine Latour   Initial Version
**/

public with sharing class HP_SM060_CaseOwnerHistory {
    class CaseOwnerHistory {
        public boolean actualOwner;
        public Decimal elapsedTime;
        public String profile;
        public Datetime lastAssignment;    
    }

    public static void upsertCaseOwnerHistory(List<Case> caseList) {
        Set<Id> caseIds = (new Map<Id,SObject>(caseList)).keySet();

        List<CaseHistory> caseHistoryList = HP_EM036_CaseHistory.getCaseHistoryByCasesIds(caseIds);
        Map<Id, List<CaseHistory>> mapCaseHistoryByCase = new Map<Id, List<CaseHistory>>();
        Set<Id> userIds = updateMapCaseHistory(caseHistoryList, mapCaseHistoryByCase);
       
        Map<Id, List<HP_CaseOwner__c>> mapCaseOwnerByCase = HP_EM050_HPCaseOwner.getCaseOwnerMap(caseIds);

        Map<Id, User> mapUserByUserId = HP_UTIL_ProfileManager.getUsersProfiles(userIds);
        Map<Id, Group> mapQueueById = HP_UTIL_QueueManager.getQueueMapById();

        upsertCaseOwner(caseList, mapCaseHistoryByCase, mapCaseOwnerByCase, mapQueueById, mapUserByUserId);
        updateClosedCase(caseList);
    }

   
    public static String getUserProfile(Id userId, Map<Id, User> mapUserByUserId, Map<Id, Group> mapQueueById) {
        if (mapUserByUserId.get(userId) != null) {
            String profileName = mapUserByUserId.get(userId).Profile.Name;
            if(String.isBlank(profileName)) {
                profileName = mapUserByUserId.get(userId).Name;
            }
            return profileName;
        } else if(mapQueueById.get(userId) != null) {

            final String queueDeveloperName = mapQueueById.get(userId).DeveloperName;
            return mapQueueTouserProfiles(queueDeveloperName);
        } else {
            return 'Indéfini';
        }
    }

    public static String mapQueueTouserProfiles(String queueName) {
        if(queueName == 'HP_Niveau_1') {
            return 'HP_Conseiller Niveau 1';
        }
        else if(queueName == 'HP_Niveau_2') {
            return 'HP_Conseiller Niveau 2';
        }
        else if(queueName == 'HP_Niveau_3') {
            return 'HP_Conseiller Niveau 3';
        }
        else {

            return 'Queue indéfinie';

        }
    }

    public static Decimal getTimeElapsed(CaseHistory currentCH, CaseHistory lastCH, Datetime caseCreatedDate) {
        if(currentCH != null) {
            final Datetime currentChCreatedDate = currentCH.CreatedDate;
        
            if (lastCH != null) {
                final Datetime lastChCreatedDate = lastCH.CreatedDate;
                return Decimal.valueOf(currentChCreatedDate.getTime() - lastChCreatedDate.getTime())/1000;
            }
            else {
                return Decimal.valueOf(currentCH.CreatedDate.getTime() - caseCreatedDate.getTime())/1000;
            }
        } else if(lastCH != null) {
            final Datetime lastChCreatedDate = lastCH.CreatedDate;
            return Decimal.valueOf(Datetime.now().getTime() - lastChCreatedDate.getTime())/1000;
        }       
        return 0; 
    }

    public static void updateMapProfileTime(Map<String, CaseOwnerHistory> mapProfileTime, String userProfile, Decimal timeElapsed, Datetime assignmentDate, Boolean actualOwner) {
        if (mapProfileTime.containsKey(userProfile)) {
            CaseOwnerHistory coh = mapProfileTime.get(userProfile);
            coh.actualOwner = actualOwner;
            coh.elapsedTime = coh.elapsedTime + timeElapsed;
            coh.lastAssignment = assignmentDate;
            mapProfileTime.put(userProfile, coh);
        }
        else {
            CaseOwnerHistory coh = new CaseOwnerHistory();
            coh.actualOwner = actualOwner;
            coh.elapsedTime = timeElapsed;
            coh.lastAssignment = assignmentDate;
            coh.profile = userProfile;
            mapProfileTime.put(userProfile, coh);
        }
    }

    public static Set<Id> updateMapCaseHistory(List<CaseHistory> caseHistoryList, Map<Id, List<CaseHistory>> mapCaseHistoryByCase) {
        Set<Id> userNames = new Set<Id>();
        for(CaseHistory ch : caseHistoryList) {



            final Boolean oldValueId = ch.oldValue != null && String.valueOf(ch.oldValue).startsWith('005');
            final Boolean newValueId = ch.newValue != null && String.valueOf(ch.newValue).startsWith('005');

            if(ch.Field.equals('Owner')){
                if(oldValueId) userNames.add(Id.valueOf(String.valueOf(ch.OldValue)));
                if(newValueId) userNames.add(Id.valueOf(String.valueOf(ch.NewValue)));



            }
            
            List<CaseHistory> tempList;
            if(mapCaseHistoryByCase.containsKey(ch.CaseId)) {
                tempList = mapCaseHistoryByCase.get(ch.CaseId);
            }
            else {
                tempList = new List<CaseHistory>();
            }
            tempList.add(ch);
            mapCaseHistoryByCase.put(ch.CaseId, tempList);
        }

        return userNames;
    }

    public static void upsertCaseOwner(List<Case> caseList,  Map<Id, List<CaseHistory>> mapCaseHistoryByCase,  Map<Id, List<HP_CaseOwner__c>> mapCaseOwnerByCase, Map<Id, Group> mapQueueById, Map<Id, User> mapUserByUserId) {
        List<HP_CaseOwner__c> caseOwnerToUpsert = new List<HP_CaseOwner__c>();

        for(Case toUpdateCase: caseList) {
            Datetime caseCreatedDate = toUpdateCase.CreatedDate;
            Id caseId = toUpdateCase.Id;
            List<HP_CaseOwner__c> actualCaseOwnerList = mapCaseOwnerByCase.get(caseId);
            List<CaseHistory> actualCaseHistoryList = mapCaseHistoryByCase.get(caseId);
            CaseHistory lastOwnerCaseHistory;
            Map<String, CaseOwnerHistory> mapProfileTime = new Map<String, CaseOwnerHistory>();
            if(actualCaseHistoryList == null) {
                continue;
            }
            for(CaseHistory currentCH : actualCaseHistoryList) {
                final Boolean oldValueNotNull = currentCH.oldValue != null;
                final Boolean oldValueId = oldValueNotNull && (String.valueOf(currentCH.oldValue).startsWith('005') || String.valueOf(currentCH.oldValue).startsWith('00G'));

                if (currentCH.Field.equals('Owner') && oldValueId) {
                    final String userProfile = getUserProfile(Id.valueOf(String.valueOf(currentCH.oldValue)), mapUserByUserId, mapQueueById);
                    final Decimal timeElapsed = getTimeElapsed(currentCH, lastOwnerCaseHistory, caseCreatedDate);
                    updateMapProfileTime(mapProfileTime, userProfile, timeElapsed, currentCH.CreatedDate, false);                   
                    lastOwnerCaseHistory = currentCH;
                } else {
                    continue;
                }               
            }
            if(lastOwnerCaseHistory != null) {
                final Datetime chCreatedDate = lastOwnerCaseHistory.CreatedDate;
                final String actualProfile = getUserProfile(Id.valueOf(String.valueOf(lastOwnerCaseHistory.newValue)), mapUserByUserId, mapQueueById);
                updateMapProfileTime(mapProfileTime, actualProfile, 0, chCreatedDate, true);                 
            }

            if(actualCaseOwnerList != null) {
                for(HP_CaseOwner__c currentHPCaseOwner : actualCaseOwnerList) {
                    final String profileName = currentHPCaseOwner.ProfileName__c;
                    final Decimal recordedTimeElapsed =  currentHPCaseOwner.HP_ElapsedTime__c;
                    final Boolean actualOwner = currentHPCaseOwner.HP_ActualOwner__c;
                    final Datetime lastAssignment = currentHPCaseOwner.HP_LastAssignment__c;
                    
                    if (mapProfileTime.containsKey(profileName)) {
                        CaseOwnerHistory coh = mapProfileTime.get(profileName);    
                        final Decimal calculatedTimeElapsed = coh.elapsedTime;
                        final Boolean calculatedActualOwner = coh.actualOwner;
                        final Datetime calculatedLastAssignment = coh.lastAssignment;

                        final Boolean hasChanged = recordedTimeElapsed != calculatedTimeElapsed
                                                    || actualOwner != calculatedActualOwner
                                                    || lastAssignment != calculatedLastAssignment;
                        if(hasChanged) {
                            currentHPCaseOwner.HP_ElapsedTime__c = calculatedTimeElapsed;
                            currentHPCaseOwner.HP_ActualOwner__c = calculatedActualOwner;
                            currentHPCaseOwner.HP_LastAssignment__c = calculatedLastAssignment;
                            caseOwnerToUpsert.add(currentHPCaseOwner);
                        }
                        mapProfileTime.remove(profileName);
                    }
                }
            }
            
            if(mapProfileTime.values().size() > 0) {
                for(String profile : mapProfileTime.keySet()) {
                    CaseOwnerHistory coh = mapProfileTime.get(profile);
                    HP_CaseOwner__c newCaseOwner = new HP_CaseOwner__c();
                    newCaseOwner.ProfileName__c = profile;
                    newCaseOwner.HP_ElapsedTime__c = coh.elapsedTime;
                    newCaseOwner.HP_ActualOwner__c = coh.actualOwner;
                    newCaseOwner.HP_LastAssignment__c = coh.lastAssignment;
                    newCaseOwner.Case__c = toUpdateCase.Id;
                    caseOwnerToUpsert.add(newCaseOwner);
                }
            }
        }

        if(caseOwnerToUpsert.size() > 0) Database.upsert(caseOwnerToUpsert);
    }

    public static void updateClosedCase(List<Case> caseList) {
        List<Case> casesToUpdate = new List<Case>();
        for(Case acase : caseList) {
            if(acase.IsClosed) {
                acase.HP_TECH_CaseOwnerHistoryCheck__c = true;
                casesToUpdate.add(acase);
            }
        }

        if(casesToUpdate.size() > 0) Database.upsert(casesToUpdate);
    }
}