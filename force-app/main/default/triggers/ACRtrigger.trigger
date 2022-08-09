trigger ACRtrigger on AccountContactRelation (before insert) {

    //Map<Id,AccountContactRelation> acrs1 = new Map<Id,AccountContactRelation>([SELECT Id, AccountId, ContactId, a.ID_Porte_feuille_contrat__c, a.No_Compte_contrat__c, c.Identifiant_Buisness_Partener__c, c.ID_Tiers__c  FROM AccountContactRelation acr, acr.account a, acr.contact c WHERE Id IN :Trigger.New ]);

    // get list of all account ids and contacts ids to later get them
    Set<Id> accountids = new Set<Id>();
    Set<Id> contactsids = new Set<Id>();
    for(AccountContactRelation acr: Trigger.New){
        accountids.add(acr.AccountId);
        contactsids.add(acr.ContactId);
    }
    
    Map<Id,Account> accDats = new Map<Id,Account>([SELECT Id,  ID_Porte_feuille_contrat__c, No_Compte_contrat__c FROM Account WHERE Id IN :accountids ]);
    Map<Id,Contact> ctDats = new Map<Id,Contact>([SELECT Id, Identifiant_Buisness_Partener__c, ID_Tiers__c  FROM contact WHERE Id IN :contactsids]);


    for(AccountContactRelation acr: Trigger.New){
        String accExtId = '';
        if(accDats.containsKey(acr.AccountId)){
            Account acc1 = accDats.get(acr.AccountId);
            if(acc1.No_Compte_contrat__c != null){
                accExtId = 'C_' + acc1.No_Compte_contrat__c;
            }else if(acc1.ID_Porte_feuille_contrat__c != null){
                accExtId = 'P_' + acc1.ID_Porte_feuille_contrat__c;                
            }else{
                accExtId = 'I_' + acc1.Id;
            }
        }
        String ctExtId = '_';
        if(ctDats.containsKey(acr.ContactId)){
            Contact ct1 = ctDats.get(acr.ContactId);
            if(ct1.Identifiant_Buisness_Partener__c != null){
                ctExtId = 'B_' + ct1.Identifiant_Buisness_Partener__c;
            }else if(ct1.ID_Tiers__c != null){
                ctExtId = 'T_' + ct1.ID_Tiers__c;
            }else{
                ctExtId = 'I_' + ct1.Id;
            }
        }
        acr.rolekey__c = accExtId + '_' + ctExtId;
    } 
}