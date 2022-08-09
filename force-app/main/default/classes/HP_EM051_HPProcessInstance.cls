/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-13-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-09-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public without sharing class HP_EM051_HPProcessInstance {
    @InvocableMethod
    public static void approvalResponse(List<Id> caseIds) {
        System.debug('******Begin approvalResponse caseIDs: '+ caseIds);

        List<Case> cases = [SELECT Id,HP_reponseApprobation__c
                            FROM Case 
                            WHERE Id IN :caseIds
                            ];

        //Map Case Ids to the newCase List
        Map<Id,Case> caseMap = new Map<Id,Case>();
        for(Case c:cases){
            caseMap.put(c.id,c);
        } 

        List<ProcessInstance> instances = [SELECT Id,TargetObjectId,CompletedDate,(SELECT Id, StepStatus, Comments FROM Steps ORDER BY CreatedDate  DESC LIMIT 1 )
                                            FROM ProcessInstance 
                                            WHERE ProcessDefinition.Name = 'HP_APR001_EmailCaseApproval' AND TargetObjectId IN :caseMap.keySet()
                                            ORDER BY CreatedDate DESC LIMIT 1
                                            ];


        Set<String> objectIds = new Set<String>();

        //Create a set of object Ids which has process instance
        for(ProcessInstance pi:instances){
            objectIds.add(pi.TargetobjectId);
        }

        //populate object's comment field from approval comments
        if(instances != null){
            for(ProcessInstance pi:instances){
                if(pi.steps != null){
                    for (ProcessInstanceStep step : pi.Steps) {  
                        caseMap.get(pi.TargetObjectId).HP_reponseApprobation__c = step.Comments;
                    }
                }else{
                    System.debug('steps is null');
                }
            }
        }else{
            System.debug('instances is null');
        }
        update cases;
    }
}