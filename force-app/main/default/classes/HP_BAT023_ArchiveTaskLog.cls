/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 

 * @last modified on  : 05-20-2021

 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   05-10-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/

global class HP_BAT023_ArchiveTaskLog implements Database.Batchable<sObject>{
    public static final Integer BATCH_CHUNK_SIZE = 200;
    private Id  contactId;


    public HP_BAT023_ArchiveTaskLog() {} 

    public HP_BAT023_ArchiveTaskLog(Id contId) {
        contactId = contId;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        List<Contact> cont = [select id,AccountId, name from contact where name ='Tel Sans Contact Diabolocom'];
        return Database.getQueryLocator(
            [SELECT Id, WhatId, WhoId FROM Task WHERE WhoId =:cont[0].Id]
        );
    }

    

    global static void execute(){
        HP_BAT023_ArchiveTaskLog archiveContact = new HP_BAT023_ArchiveTaskLog();
        Database.executeBatch(archiveContact, BATCH_CHUNK_SIZE);
    }
    global static void execute(Id idContcat) {
        HP_BAT023_ArchiveTaskLog archiveTask = new HP_BAT023_ArchiveTaskLog(idContcat);
        Database.executeBatch(archiveTask, BATCH_CHUNK_SIZE);
    }

    public void execute(Database.BatchableContext bc, List<Task> tasks) { 
        System.debug('tasks  size'+ tasks.size());
        List<Task> taskToUpsert = new List<Task>();
        for (Task tsk : tasks) {
            tsk.WhoId = contactId;
            taskToUpsert.add(tsk);
            System.debug('tsk:'+ tsk);
        }
    
        if(taskToUpsert.size() > 0) Database.update(taskToUpsert, true);
    }

    global void finish(Database.BatchableContext bc){

        System.debug('finish task:');
        System.debug('contactId task  :' + contactId);



    }   
}