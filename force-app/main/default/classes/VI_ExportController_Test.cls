/*
*@Auhtor: Paul Ghoussoub
*@Description: Controller du LWC VI_ExportController qui permet d'exporter des taches
*@CreatedDate: 16/11/2021
*/
@isTest
public class VI_ExportController_Test { 
    @testSetup
    static void testSetup(){
        VI_parcours__c parcours = VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
        insert parcours;
        List<Task> listTasks=new List<Task>();
        Task insertedTask=new Task();
        insertedTask.recordTypeId=Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('VI_DemandeBO').getRecordTypeId();
        insertedTask.whatid=parcours.id;
        listTasks.add(insertedTask);
        Task insertedTask2=new Task();
        insertedTask2.recordTypeId=Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('PurePlayerTask').getRecordTypeId();
        insertedTask2.whatid=parcours.id;
        listTasks.add(insertedTask2);
        insert listTasks;
    }
	@isTest
    static void testMethodfetchRecs(){
        List<Task> listTasksBO=VI_ExportController.fetchRecs('VI_DemandeBO',true);
        system.assert(listTasksBO.size()>0);
        List<Task> listTasksPP=VI_ExportController.fetchRecs('PurePlayerTask',false);
        system.assert(listTasksBO.size()>0);
    }
    @isTest
    static void testMethodexportTasksPP(){
        String BORecordTypeId=VI_ObjectUtils.getRecordTypeId('Task','PurePlayerTask');
		List<Task> listTask=[Select Id,Subject,VI_Site_prestataire__c,VI_DateDeCreationDuParcours__c,VI_OwnerIdURL__c,VI_OwnerName__c,VI_WhatName__c,VI_WhatIdUrl__c,VI_TaskId__c,WhatId,what.name,ActivityDate,OwnerId,owner.name,VI_NomClient__c,VI_TelephonePrincipal__c,VI_StatutDuParcours__c,VI_StatutDuCase__c,VI_ApercuDuCommentaire__c
                             from task 
                             where recordTypeid=:BORecordTypeId];  
        VI_ExportController.exportTasks(listTask,'PurePlayerTask');
    }
    @isTest
    static void testMethodexportTasksBO(){
        String BORecordTypeId=VI_ObjectUtils.getRecordTypeId('Task','VI_DemandeBO');
		List<Task> listTask=[Select Id,Subject,VI_Site_prestataire__c,VI_DateDeCreationDuParcours__c,VI_OwnerIdURL__c,VI_OwnerName__c,VI_WhatName__c,VI_WhatIdUrl__c,VI_TaskId__c,WhatId,what.name,ActivityDate,OwnerId,owner.name,VI_NomClient__c,VI_TelephonePrincipal__c,VI_StatutDuParcours__c,VI_StatutDuCase__c,VI_ApercuDuCommentaire__c
                             from task 
                             where recordTypeid=:BORecordTypeId];  
        VI_ExportController.exportTasks(listTask,'VI_DemandeBO');
    }
}