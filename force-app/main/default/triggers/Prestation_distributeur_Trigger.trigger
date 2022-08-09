trigger Prestation_distributeur_Trigger on Prestation_distributeur__c (after update) {
    if(ByPassSettings__c.getInstance().PrestationDistributeurTrigger__c)
        return;
    // FT3-218 : on modifie le statut et sous-statut de Case si toutes les OPS sont terminées
    Prestation_distributeur__c myOPS = Trigger.new[0];
    Id hpRecordTypeId = Schema.SObjectType.Prestation_distributeur__c.getRecordTypeInfosByDeveloperName().get('HP_PrestationDistributeur').getRecordTypeId();
    if(myOPS.RecordTypeId == hpRecordTypeId) return;
    Prestation_distributeur__c[] listOPS = [select id, statut__c from Prestation_distributeur__c where Case__c=:myOPS.Case__c];
    if((listOPs.size() == 1 &&  listOPs[0].statut__c == 'Terminé') || (listOPs.size() == 2 &&  listOPs[0].statut__c == 'Terminé' &&  listOPs[1].statut__c == 'Terminé')){
        Case myCase = new Case();
        myCase.Id = myOPS.Case__c;
        myCase.Status = System.Label.SM_CL21_Case_status_PreCloturee;
        myCase.Sous_statut__c = 'Conforme';
        update myCase;
    }

}