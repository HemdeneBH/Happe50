/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 


 * @last modified on  : 05-18-2021


 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   05-10-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/

public with sharing class HP_SM61_ArchiveContactLog {



    public   static void archiveContact(List<case> cases, Id contactId) {
        List<Contact> cont = [select id,AccountId, name from contact where name ='Tel Sans Contact Diabolocom'];
        if(cases == null || cases.size() == 0 || cont.size() == 0) return ;
        System.debug('cases size sm61 :'+ cases.size());
       
        List<Case> caseToUpsert = new List<Case>();
        //Contact con = new Contact( firstName = 'Tel Sans Contact', LastName = 'Diabolocom'+ Datetime.now(), HP_IsHappe__c = true, AccountId=cont[0].AccountId);
        //insert con;
        System.debug('contactId******* :'+ contactId);
            for (Case cas : cases) {
                cas.ContactId = contactId;


                caseToUpsert.add(cas);
                System.debug('cas******* :'+ cas);

            }
            System.debug('caseToUpsert size'+ caseToUpsert.size());

        if(caseToUpsert.size() > 0) Database.update(caseToUpsert, true);


        //return con.Id;

}
}