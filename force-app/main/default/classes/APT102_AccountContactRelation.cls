/**
 * @author Sutharsan Pushparajah
 * @date 24/06/2022
 * @description APT102_AccountContactRelation - AccountContactRelation Trigger Handler Class using SSDEVL Framework
 */
public inherited sharing class APT102_AccountContactRelation {
    
    /**
     * @author Sutharsan Pushparajah
     * @date 24/06/2022
     * @description APT102_AccountContactRelation.BeforeInsert - Class to implement Before Insert logic
     */
    public inherited sharing class BeforeInsert extends APT001_TriggerEventManager{

        private List<AccountContactRelation> newList = Trigger.new;
        private Map<Id, Account> accDats;
        private Map<Id, Contact> ctDats;

        public override void prepare(){
            List<Id> accountids = new List<Id>();
            List<Id> contactsids = new List<Id>();
            
            for (AccountContactRelation acr : newList){
                accountids.add(acr.AccountId);
                contactsids.add(acr.ContactId);
            }

            accDats = new Map<Id, Account>(SM_EM101_Account.getByIds('Id, ID_Porte_feuille_contrat__c, No_Compte_contrat__c', accountids));
            ctDats = new Map<Id, Contact>(SM_EM100_Contact.getByIds('Id, Identifiant_Buisness_Partener__c, ID_Tiers__c', contactsids));
        }

        public override void process(){
            for (AccountContactRelation acr : newList){
                String accExtId = '';
                
                if (accDats.containsKey(acr.AccountId)){
                    Account acc1 = accDats.get(acr.AccountId);
                    if (acc1.No_Compte_contrat__c != null){
                        accExtId = 'C_' + acc1.No_Compte_contrat__c;
                    } else if (acc1.ID_Porte_feuille_contrat__c != null){
                        accExtId = 'P_' + acc1.ID_Porte_feuille_contrat__c;                
                    } else {
                        accExtId = 'I_' + acc1.Id;
                    }
                }

                String ctExtId = '_';

                if (ctDats.containsKey(acr.ContactId)){
                    Contact ct1 = ctDats.get(acr.ContactId);
                    if (ct1.Identifiant_Buisness_Partener__c != null){
                        ctExtId = 'B_' + ct1.Identifiant_Buisness_Partener__c;
                    } else if (ct1.ID_Tiers__c != null){
                        ctExtId = 'T_' + ct1.ID_Tiers__c;
                    } else {
                        ctExtId = 'I_' + ct1.Id;
                    }
                }

                acr.rolekey__c = accExtId + '_' + ctExtId;
            } 
        }
    }
}