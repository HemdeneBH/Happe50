/* 
 * @description:Process Contact trigger
 * @projet:Mypower, Smile
 *
 *
 * @Modified by : Omar Mohamad
 * @Date : 27/03/2020
 * @Description:Optimisation trigger avec le pattern 0'hara.
 */
public with sharing class SM_ContactProcess {

    public static void updatePreviousEmail(Map<Id, Contact> oldMapContact , List<Contact> newContact){
        System.debug('previous value '+oldMapContact);
        for(Contact contSM : newContact ){
            system.debug('old value '+oldMapContact.get(contSM.Id).EmailPrincipalValueRW__c);
            contSM.put('Previous_email_principal__c', oldMapContact.get(contSM.Id).EmailPrincipalValueRW__c);
        }
        //update newContact;
        System.debug('new contact value '+ newContact);
    }

    public static void setPrincipalValueRW(Map<Id, Contact> oldMapContact , List<Contact> newContact){    
        setPrincipalValueEmailRW(oldMapContact,newContact);
        setPrincipalValuePhoneRW(oldMapContact,newContact);
        setPrincipalValueMobileRW(oldMapContact,newContact);
    }
    
    public static void setPrincipalValueRWFromUpdate(Map<Id, Contact> oldMapContact , List<Contact> newContact){  
        for(Contact cont :newContact ){
            if(cont.Id!=null &&
               ((cont.Adresse_Mail_Principale__c != oldMapContact.get(cont.Id).Adresse_Mail_Principale__c)||
                (cont.Email != oldMapContact.get(cont.Id).Email)||
                (cont.Adresse_Mail_2__c != oldMapContact.get(cont.Id).Adresse_Mail_2__c)||
                (cont.Adresse_Mail_3__c != oldMapContact.get(cont.Id).Adresse_Mail_3__c))){
                    setPrincipalValueEmailRW(oldMapContact,newContact);
            }
            if(
                (cont.Id!=null &&
                ((cont.Tel_Fixe_Principal__c != oldMapContact.get(cont.Id).Tel_Fixe_Principal__c)||
                    (cont.Phone != oldMapContact.get(cont.Id).Phone)||
                    (cont.Tel_Fixe_2__c != oldMapContact.get(cont.Id).Tel_Fixe_2__c)||
                    (cont.Tel_Fixe_3__c != oldMapContact.get(cont.Id).Tel_Fixe_3__c)))){
                    setPrincipalValuePhoneRW(oldMapContact,newContact);
            }       
            if(
                (cont.Id!=null&&
                ((cont.Mobile_Principal__c != oldMapContact.get(cont.Id).Mobile_Principal__c)||
                    (cont.MobilePhone != oldMapContact.get(cont.Id).MobilePhone)||
                    (cont.Mobile_2__c != oldMapContact.get(cont.Id).Mobile_2__c)||
                    (cont.Mobile_3__c != oldMapContact.get(cont.Id).Mobile_3__c))
                )){
                    setPrincipalValueMobileRW(oldMapContact,newContact);
            }        
        }       
    }
    
    /*
     * @Author: Amine Deghais ~ amine.deghais@external.engie.com
     * @Date: 10/14/2019 SMIL-3417
     * @Description: remplir EmailPrincipalValueRW__c par l'email principal
     */
    public static void setPrincipalValueEmailRW(Map<Id, Contact> oldMapContact , List<Contact> newContact){     
        for(Contact cont : newContact ){
            switch on cont.Adresse_Mail_Principale__c {
                when 'Adresse Mail 1'{cont.EmailPrincipalValueRW__c=cont.Email;}
                when 'Adresse Mail 2'{cont.EmailPrincipalValueRW__c=cont.Adresse_Mail_2__c;}
                when 'Adresse Mail 3'{cont.EmailPrincipalValueRW__c=cont.Adresse_Mail_3__c;}
                when else{cont.EmailPrincipalValueRW__c=Null;}
            }
        }
    }
    
    public static void setPrincipalValuePhoneRW(Map<Id, Contact> oldMapContact , List<Contact> newContact){     
        for(Contact cont : newContact ){
            switch on cont.Tel_Fixe_Principal__c {
                when 'Tel Fixe 1' {cont.TelFixePrincipalValueRW__c=cont.Phone;}
                when 'Tel Fixe 2' {cont.TelFixePrincipalValueRW__c=cont.Tel_Fixe_2__c;}
                when 'Tel Fixe 3' {cont.TelFixePrincipalValueRW__c=cont.Tel_Fixe_3__c;}
                when else{cont.TelFixePrincipalValueRW__c=Null;}
            }
        }
    }
    
    public static void setPrincipalValueMobileRW(Map<Id, Contact> oldMapContact , List<Contact> newContact){     
        for(Contact cont : newContact ){
            switch on cont.Mobile_Principal__c {
                when 'Mobile 1' {cont.MobilePrincipalValueRW__c=cont.MobilePhone;}
                when 'Mobile 2' {cont.MobilePrincipalValueRW__c=cont.Mobile_2__c;}
                when 'Mobile 3' {cont.MobilePrincipalValueRW__c=cont.Mobile_3__c;}
                when else{cont.MobilePrincipalValueRW__c=Null;}
            }
        }
    }

    public static void changeEmailOpp(set<id> oppids) {
        map<id, opportunity> opps = new map<id, opportunity>();
        List<opportunitycontactrole> records = [select ContactId,contact.Email,OpportunityID from opportunitycontactrole where ContactId in :oppids];
        for(opportunitycontactrole record : records) {
            opps.put(record.OpportunityID, new opportunity(id=record.OpportunityID, vlocity_cmt__Email__c=record.contact.Email));
        }  
        update opps.values();
    }

}