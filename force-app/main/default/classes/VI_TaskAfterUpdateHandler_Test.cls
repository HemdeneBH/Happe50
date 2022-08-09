@isTest
public class VI_TaskAfterUpdateHandler_Test {
    @isTest
    static void testMethod1(){
        VI_TaskTriggerHandler handler=new VI_TaskTriggerHandler();
        handler.isDisabled();
        String BORecordTypeId=Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('VI_DemandeBO').getRecordTypeId();
        User ownerUser=[SELECT id,contact.account.name from user limit 1];
        Id CaseRTId = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Acquisition_Harmonica').getRecordTypeId();
        system.debug('ownerUser '+ownerUser);
        Case c=new case();
        c.status='En attente';
        c.Sous_statut__c='Retour client';
        c.Origin='Partner Community';
        c.RecordTypeId = CaseRTId;
        insert c;
        VI_Parcours__c parcours=VI_TestDataFactory.createParcours('CHF', c.id, 'PURE PLAYERS');
        parcours.OwnerId=ownerUser.id;
        insert parcours;
        Task insertedTask=new Task();
        insertedTask.recordTypeId=Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('VI_DemandeBO').getRecordTypeId();
        insertedTask.whatid=parcours.id;
        insert insertedTask;
        insertedTask.VI_ReponsePP__c='test';
        insertedTask.status='Completed';
        update insertedTask;
        List<CaseComment> listCaseComments=[Select id from CaseComment];
        system.assert(listCaseComments.size()>0);
        
        
    }
}