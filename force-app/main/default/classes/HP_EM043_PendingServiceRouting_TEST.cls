/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   20-01-2021   Antoine Latour   Initial Version
**/
@isTest 

public with sharing class HP_EM043_PendingServiceRouting_TEST {

    @testSetup public static void dataSetup() {
         Id queueNiveau1Id = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'HP_Niveau_1'].Id;
	     Case c1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_PrestationDistributeur', new Map<String, Object> {
            'Status' => 'NEW_CASE',
            'Priority' => 'High',
            'OwnerId' => queueNiveau1Id,
            'HP_TreatmentDate__c' => Date.today().addDays(-2),
            'Origin' => 'Contact distributeur'
            }, null,null,null);
           
        insert c1;
    }
    
    @istest
    public static void deletePendingRoutinService() {
        Id caseId = [SELECT Id FROM Case Limit 1].Id;
        Set<Id> psrIds = (new Map<Id, PendingServiceRouting>([SELECT Id FROM PendingServiceRouting Where WorkItemId =:caseId Limit 1])).keySet();

        Test.startTest();
        HP_EM043_PendingServiceRouting.deletePendingRoutinService(psrIds);
        Test.stopTest();
    }
    
    @istest
    public static void deletePendingRoutinServiceEmpty() {
        Set<Id> psrIds = new Set<Id>();

        Test.startTest();
        HP_EM043_PendingServiceRouting.deletePendingRoutinService(psrIds);
        Test.stopTest();
    }
}