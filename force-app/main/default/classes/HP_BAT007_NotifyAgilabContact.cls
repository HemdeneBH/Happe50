/**
 * @File Name          : HP_BAT007_NotifyAgilabContact.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Hemdene Ben Hammouda
 * @Last Modified On   : 11-04-2021
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    27/03/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/

global without sharing class HP_BAT007_NotifyAgilabContact implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable, Database.RaisesPlatformEvents, HP_UTIL_BatchInterface{
    
    public static final Integer BATCH_CHUNK_SIZE = 1;


    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('select id, Id_Tiers__c from contact where HP_IsChanged__c = true and Id_Tiers__c != null limit 200');
    }


    global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT007_NotifyAgilabContact());
    }

    global static void execute(SchedulableContext sc){
        execute();
    }

    global static void execute(){

		HP_BAT007_NotifyAgilabContact batch = new HP_BAT007_NotifyAgilabContact();
		Database.executeBatch(batch, BATCH_CHUNK_SIZE);
	}


    global void execute(Database.BatchableContext bc, List<Contact> scope) {

        List<Contact> successCallList = new List<Contact>();
        Set<Id> contactIds = new Set<Id>();
        for(Contact cont : scope) {
            boolean result = HP_PersonneService.notifierAgilabModifContact(cont.Id_Tiers__c);
            if(result) {
                cont.HP_IsChanged__c = false;
                successCallList.add(cont);
            }
        }

        if(successCallList.size() > 0) {
            update successCallList;
        }
    }

    global void finish(Database.BatchableContext bc){

    }
}