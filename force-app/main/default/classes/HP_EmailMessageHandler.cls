/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 




 * @last modified on  : 02-18-2021

 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc

 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   09-02-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class HP_EmailMessageHandler  extends TriggerHandler {
   /* private List<EmailMessage> newList;
    private String rtAccountId;

    private Map<Id,EmailMessage> newMap;
    private Map<Id,EmailMessage> oldMap;
    public HP_EmailMessageHandler() {
        this.newList = (List<EmailMessage>) Trigger.New;
        this.newMap = (Map<Id,EmailMessage>) Trigger.newMap;
        this.oldMap = (Map<Id,EmailMessage>) Trigger.oldMap;


















    }

    public override void beforeInsert() {

        String ProfileId = UserInfo.getProfileId();
        if(String.isBlank(ProfileId))
            return;
        List<Profile> profileList = [select Name from Profile where Id = :ProfileId];
        if(profileList.isEmpty())
            return;
        Profile prof = profileList[0];
        if(!prof.Name.startsWith('HP_')) {
            return;
        }
        Set<String> AccountIdList = new Set<String>();
        for(EmailMessage item : newList) {
            String rtId = item.RelatedToId;
            if(rtId != null && rtId.startsWith('001')) {

                AccountIdList.add(item.RelatedToId);
            } 
        }
        if(AccountIdList.size() == 0) {
            return;
        }














        for(EmailMessage item : newList) {
            if(AccountIdList.contains(item.RelatedToId)) {






                item.HP_TECH_Account_Id__c = item.RelatedToId;
                item.RelatedToId = null;
            } 
        }
    }
    public override void afterInsert() {

        String ProfileId = UserInfo.getProfileId();
        if(String.isBlank(ProfileId))
            return;
        List<Profile> profileList = [select Name from Profile where Id = :ProfileId];
        if(profileList.isEmpty())
            return;
        Profile prof = profileList[0];
        if(!prof.Name.startsWith('HP_')) {
            return;
        }






        






        // MAJ de la date du case lors de la premiere réponse.
        List<Case>  caseList = HP_EM010_Case.loadCase(newList[0].ParentId);
        System.debug('caseList: '+caseList);
        List<Case>  caseListToPersiste = new List<Case>();
        for(Case cas : caseList){
            case c = new Case();
            c.Id = cas.Id;
            if(cas.HP_DateReponseEmailConseiller__c == null){
                c.HP_DateReponseEmailConseiller__c = DateTime.now();
                caseListToPersiste.add(c);
            }
        }
        



         if(caseListToPersiste.size() > 0) Database.update(caseListToPersiste);
         // ALIMENTER le CaseHistory lors de la réponse à un mail.



         if(caseList.size() > 0){






            BusinessHours bh = [SELECT Id FROM BusinessHours WHERE name ='HP'];
            
            List<HP_CaseHistory__c> listHistories = HP_EM036_CaseHistory.getCaseHistory(caseList[0].OwnerId, caseList[0].Id);
            List<HP_CaseHistory__c> listHistoriesTopersiste = new List<HP_CaseHistory__c>();
            boolean isQqueue =  string.valueOf(caseList[0].OwnerId).startsWith('00G');
            for(HP_CaseHistory__c caseHistory : listHistories){
                
                if( caseList[0].HP_isHappe__c && caseList[0].IsClosed == false && !isQqueue && caseHistory.HP_DateReponse__c == null) {
                    
                    caseHistory.HP_DateReponse__c = DateTime.now();
                    
                    if (bh != null && caseHistory.HP_DateAttribution__c != null){
                        Decimal result = BusinessHours.diff(bh.Id, caseHistory.HP_DateAttribution__c,caseHistory.HP_DateReponse__c );
                        // milliseconds au minute
                        Decimal resultingHours = result/(60*1000);
                        caseHistory.HP_DureeTraitement__c = resultingHours;
                    }
                    
                    listHistoriesTopersiste.add(caseHistory);
                }
            }



        if(listHistoriesTopersiste.size() > 0) Database.update(listHistoriesTopersiste);



        }





        List<String> accountIdList = new List<String>();
        List<String> activityIdList = new List<String>();
        Map<String, String> activityMap = new Map<String, String>();

        List<EmailMessage> emailMessageList = new List<EmailMessage>();
        for(EmailMessage item : newList) {





            if(item.HP_TECH_Account_Id__c == null) {
                continue;
            }
            activityMap.put(item.HP_TECH_Account_Id__c, item.ActivityId);
            accountIdList.add(item.HP_TECH_Account_Id__c);
















        }
        if(accountIdList.size() == 0) {
            return;
        }
        List<Contact> contList = [select Id, AccountId from Contact where AccountId in :accountIdList];
        if(contList.size() == 0) {
            return;
        }
        Map<String, String> contactAccountMap = new  Map<String, String>();
        for(Contact cont : contList) {
            contactAccountMap.put(cont.AccountId, cont.Id);
        }
        List<EmailMessageRelation> emailMessageRelationList = new List<EmailMessageRelation>();
        List<Task> tsk = new List<Task>();
        for(EmailMessage item : newList) {
            if(contactAccountMap.get(item.HP_TECH_Account_Id__c) == null) {
                continue;
            }
            EmailMessageRelation emr = new EmailMessageRelation();
            emr.emailMessageId = item.id;
            emr.relationId = contactAccountMap.get(item.HP_TECH_Account_Id__c); 
            emr.relationType = 'OtherAddress';
            emailMessageRelationList.add(emr);
            if(item.ActivityId != null) {
                tsk.add(new Task(Id = item.ActivityId, WhoId = contactAccountMap.get(item.HP_TECH_Account_Id__c)));
            }


















        }

        System.debug('@@@ emailMessageRelationList ' + emailMessageRelationList);
        if(emailMessageRelationList.size() > 0) {
            insert emailMessageRelationList;
        }













        System.debug('@@@ emailMessageList ' + emailMessageList);
        if(emailMessageList.size() > 0) {
            update emailMessageList;

        }










        if(tsk.size() > 0) {
            update tsk;
        }
        






    }
    */
}