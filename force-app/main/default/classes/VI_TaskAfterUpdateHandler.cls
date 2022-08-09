/*
* @Author: Paul Ghoussoub
*@Description: Handler after update de la tache
*@CreatedDate: 1/4/2021
*/
public class VI_TaskAfterUpdateHandler {
    public static void taskAfterUpdate(List<Task> updatedTasks,Map<Id,Task> oldMap){
        List<Case> casesToUpdate=new List<Case>();
        List<CaseComment> caseCommentsToInsert=new List<CaseComment>();
        
        Set<Id> parcoursIds=new Set<Id>();
        for(Task updatedTask:updatedTasks){
            system.debug('updatedTask.WhatId '+updatedTask.WhatId);
            parcoursIds.add(updatedTask.WhatId);
        }
        system.debug('parcoursIds '+parcoursIds);
        Map<id,VI_Parcours__c> mapParcours=new Map<id,VI_Parcours__c>([SELECT id,VI_Case__c,VI_Case__r.Status,VI_Case__r.Sous_statut__c,VI_Case__r.Origin
                                           From VI_Parcours__c
                                           Where id in:parcoursIds]);
        
        String BORecordTypeId=VI_ObjectUtils.getRecordTypeId('Task','VI_DemandeBO');
        if(mapParcours!=null && mapParcours.size()>0){
            for (Task updatedTask:updatedTasks){
                VI_Parcours__c parcoursToCheck=mapParcours.get(updatedTask.WhatId);
                if(parcoursToCheck!=null && updatedTask.RecordTypeId==BORecordTypeId && String.isNotBlank(updatedTask.VI_ReponsePP__c) 
                   && String.isNotEmpty(updatedTask.VI_ReponsePP__c)
                   && updatedTask.Status.equals('Completed') && !oldMap.get(updatedTask.id).Status.equals('Completed'))
                {
                    //ADD fields in constructor
                    Case caseToUpdate=new case();
                    caseToUpdate.id=parcoursToCheck.VI_Case__c;
                    caseToUpdate.Status='A traiter';
                    caseToUpdate.Sous_statut__c='Retour Partenaire';
                    casesToUpdate.add(caseToUpdate);
                    
                    CaseComment caseCommentToInsert=new CaseComment();
                    caseCommentToInsert.CommentBody='Question BO: '+updatedTask.Description +'\nRéponse PP: '+updatedTask.VI_ReponsePP__c;
                    caseCommentToInsert.ParentId=parcoursToCheck.VI_Case__c;
                    caseCommentsToInsert.add(caseCommentToInsert);
                }
            }
            insert caseCommentsToInsert;
            update casesToUpdate;
        }
    }
}