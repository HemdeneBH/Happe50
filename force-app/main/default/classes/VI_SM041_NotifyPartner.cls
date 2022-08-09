/*@Author: Amal Chreiteh
*@Description: Classe test de VI_SM041_NotifyPartner_Test
*@CreatedDate: 04/05/2021
*@LastModified: 04/05/2021
*/

public class VI_SM041_NotifyPartner {
    
    /**
* @author Amal Chreiteh
* @date 04/05/2021
* @description Créer une tâche côté Partenaire suite au changement du statut = En traitement et sous-statut = Retours Tiers => Recu
* @param creerPersonneInput, context, port (wrappers Définit par WSDL), NamedCredentialName (callout:VI_AuthOctopus, callout:AuthOctopus), partitionName (local.VIToken,local.smileToken)
* @return creerPersonneResponse_element wrapper defined in the wsdl
*/
    public static void NotifyPartner(Case[] newList,Map<Id, Case> oldMap){
        system.debug('NotifyPartner');
        List<Case> listcase=new List<Case>();
        List<Task> tasksToInsert=new List<Task>();
        set<Id> casesId = new Set<Id>();
        String BORecordTypeId=VI_ObjectUtils.getRecordTypeId('Task','VI_DemandeBO');
        Id CaseRTId = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Acquisition_Harmonica').getRecordTypeId();
        system.debug('newList'+ newList);
        
        for(case cas:newList){
            system.debug('cas.Origin'+ cas.Origin);
            system.debug('cas.Status'+ cas.Status);
            system.debug('cas.Sous_statut__c'+ cas.Sous_statut__c);
            system.debug(cas.RecordTypeId == CaseRTId);
            
            system.debug(cas.Status != oldMap.get(cas.Id).Status);
            system.debug(oldMap.containsKey(cas.Id));
            if(!(cas.Sous_statut__c == null || cas.Origin == null) && cas.RecordTypeId == CaseRTId){
                system.debug('here');
                system.debug(cas.Origin.equals('Partner Community') );
                system.debug(cas.Status.equals('En attente'));
                system.debug(cas.Sous_statut__c.equals('Retour partenaire'));
                system.debug(cas.Status != oldMap.get(cas.Id).Status);
                system.debug(oldMap.containsKey(cas.Id));
                if(cas.Origin.equals('Partner Community')
                   && cas.Status.equals('En attente') && cas.Sous_statut__c.equalsIgnoreCase('Retour partenaire')
                   && oldMap.containsKey(cas.Id)  
                   && cas.Status != oldMap.get(cas.Id).Status){
                       listcase.add(cas);
                       system.debug('cas'+ cas);
                   }   
            }
        }
        system.debug('listcase'+ listcase);
        if(listcase != null && listcase.size()>0){
            //Remonter les parcours relié aux cases 
            Map<Id,VI_Parcours__c> mapParcoursCase=new Map<Id,VI_Parcours__c>();
            List<VI_Parcours__c> listParcours=[SELECT id,Name,CreatedDate,VI_Case__c,VI_Case__r.Status,VI_Case__r.Sous_statut__c,VI_Case__r.Origin,Tech_Nom_Partenaire__c,
                                               VI_TECH_TypeDuSitePrestataire__c,VI_TECH_NomDuClient__c,VI_TECH_TelephonePrincipal__c,VI_StatutCasePartnerCommunity__c,
                                               VI_StatutParcours__c, VI_TECH_SitePrestatairePartenaire__c,Tech_2_Nom_Partenaire__c
                                               From VI_Parcours__c
                                               Where VI_Case__c in:listcase];
            
            for(VI_Parcours__c parcours:listParcours){
                mapParcoursCase.put(parcours.VI_Case__c,parcours);
            }
            
            
            //Remonter les queues disponibles
            List<Group> ownerQueue = [Select Id,DeveloperName from Group where Type = 'Queue' AND DeveloperName LIKE '%BO_Partenaire'];
            Map<String,Id> mapQueueIds=new Map<String,Id>();
            for(Group queue:ownerQueue){
                mapQueueIds.put(queue.DeveloperName,queue.id);
            }
            //Remonter les tâches reliées aux cases
            List<Task> taskCases = [SELECT Id, Description, Subject, WhatId, createddate
                                    FROM Task
                                    WHERE WhatId in:listcase order by WhatId, createddate desc];
            system.debug('taskCases'+ taskCases);
            for(Task t: taskCases){
                if(!casesId.contains(t.whatId)){
                    VI_Parcours__c parcoursToCheck=mapParcoursCase.get(t.WhatId);
                    casesId.add(t.whatId);
                    Task newTask=new Task();
                    newTask.recordTypeId=BORecordTypeId;
                    newTask.WhatId=parcoursToCheck.Id;
                    newTask.Description=t.Description;
                    newTask.IsVisibleInSelfService=true;
                    newTask.Subject=t.Subject;
                    newTask.VI_TypeDuSitePrestataire__c = parcoursToCheck.VI_TECH_TypeDuSitePrestataire__c;
                    newTask.VI_NomClient__c = parcoursToCheck.VI_TECH_NomDuClient__c;
                    newTask.VI_TelephonePrincipal__c = parcoursToCheck.VI_TECH_TelephonePrincipal__c;
                    newTask.VI_DateDeCreationDuParcours__c = parcoursToCheck.CreatedDate;
                    newTask.VI_StatutDuCase__c = parcoursToCheck.VI_StatutCasePartnerCommunity__c;
                    newTask.VI_StatutDuParcours__c = parcoursToCheck.VI_StatutParcours__c;
                    newTask.VI_Site_prestataire__c = parcoursToCheck.VI_TECH_SitePrestatairePartenaire__c;
                    newTask.VI_WhatName__c=parcoursToCheck.name;
                    if(t.Description!=null){
                        if (t.Description.length() > 254) {
                            newTask.VI_ApercuDuCommentaire__c = t.Description.substring(0, 254);
                        }
                        else {
                            newTask.VI_ApercuDuCommentaire__c = t.Description;
                        }
                    }
                    
                    if(!test.isRunningTest()){
                        newTask.OwnerId=mapQueueIds.get('VI_'+parcoursToCheck.Tech_2_Nom_Partenaire__c+'BO_Partenaire');
                    }
                    else{
                        Profile p = [SELECT Id FROM Profile WHERE name='System Administrator']; 
                        User u = new User(Alias = 'standaat', Email='standardueeeser@testorg.com', 
                                          EmailEncodingKey='UTF-8', LastName='Testinddddg', LanguageLocaleKey='en_US', 
                                          LocaleSidKey='en_US', ProfileId = p.Id, 
                                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduseeeer@testorg.com');
                        insert u;
                        newTask.OwnerId=u.id;
                        
                    }
                    tasksToInsert.add(newTask);
                }
                
            }
            system.debug('tasksToInsert'+ tasksToInsert);
            if(tasksToInsert!= null & tasksToInsert.size()>0){
                insert tasksToInsert;
            }
        }
    }
}