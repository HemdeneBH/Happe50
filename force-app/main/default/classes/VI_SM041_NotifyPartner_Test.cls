/*@Author: Amal Chreiteh
*@Description: Classe test de VI_SM041_NotifyPartner
*@CreatedDate: 5/5/2021
*@LastModified: 5/5/2021
*/
@isTest
public class VI_SM041_NotifyPartner_Test {
 @isTest
    static void testMethod1(){
        VI_TaskTriggerHandler handler=new VI_TaskTriggerHandler();
        handler.isDisabled();
        Id caseRTId = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Acquisition_Harmonica').getRecordTypeId();
        String boRecordTypeId=Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('VI_DemandeBO').getRecordTypeId();
        User ownerUser=[SELECT id,contact.account.name from user limit 1];
        
        Case c=new case();
        c.status='En traitment';
        c.Origin='Partner Community';
        c.RecordTypeId = caseRTId;
        insert c;
        
        VI_Parcours__c parcours=VI_testDataFactory.createParcours('CHF', c.id, 'PURE PLAYERS');
        parcours.OwnerId=ownerUser.id;
        insert parcours;
        
        Task insertedTask=new Task();
        insertedTask.recordTypeId=Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('SMILE').getRecordTypeId();
        insertedTask.whatid=c.id;
        insertedTask.Description='test';
        insert insertedTask;
        
        c.status='En attente';
        c.Sous_statut__c='Retour partenaire';
        update c;
        
        List<Task> listTask=[Select id, VI_NomClient__c, VI_TelephonePrincipal__c, VI_DateDeCreationDuParcours__c,VI_StatutDuCase__c, VI_StatutDuParcours__c, VI_Site_prestataire__c
                             from task 
                             where recordTypeid=:boRecordTypeId];
        //system.assert(listTask.size()>0);
    }
}