/**
 * @description       : 
 * @author            : Slimene Belhaj Ali
 * @group             : 
 * @last modified on  : 03-09-2021
 * @last modified by  : Slimene Belhaj Ali
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   03-02-2021   Slimene Belhaj Ali   Initial Version
**/
public inherited sharing class HP_EM048_Task {
    
    public static Task getLastTaskFromCaseId(String caseId){
        List<String> fields = new List<String>(Schema.getGlobalDescribe().get('Task').getDescribe().fields.getMap().keySet());
        List<Task> taskList = Database.query('SELECT '+String.join(fields, ',')+' FROM Task where WhatId = :caseId order by createdDate desc limit 1');
        if(taskList.size() > 0) {
            return taskList.get(0);
        }
        return null;
    }
}