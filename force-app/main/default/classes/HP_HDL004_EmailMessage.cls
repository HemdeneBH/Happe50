/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 

 * @last modified on  : 07-27-2021

 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   09-02-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class HP_HDL004_EmailMessage  extends TriggerHandler {


    private List<EmailMessage> newList = null;
    private Map<Id,EmailMessage> newMap = null;
    private Map<Id,EmailMessage> oldMap = null;
    
    public HP_HDL004_EmailMessage() {


        if(!HP_UTIL_ProfileManager.isHappeProfile() && !Test.isRunningTest())
            return;

            //Filtrer sur le nouveau champ tech
        this.newList = HP_EM019_EmailMessage.filterListByIsHappe((List<EmailMessage>) Trigger.New);
        this.newMap = HP_EM019_EmailMessage.filterMapByIsHappe((Map<Id,EmailMessage>) Trigger.newMap);
        this.oldMap = HP_EM019_EmailMessage.filterMapByIsHappe((Map<Id,EmailMessage>) Trigger.oldMap);
    }

    public override void beforeInsert() {
        HP_SM041_EmailMessageHandler.populateTechAccount(newList);
        HP_SM041_EmailMessageHandler.createCaseClosedEmailSent(newList);

        

    }
    
    public override void afterInsert() {
        HP_SM041_EmailMessageHandler.updateEmailMessageRelation(newList);
        HP_SM041_EmailMessageHandler.createCaseClosedEmailSent(newList);
    }
}