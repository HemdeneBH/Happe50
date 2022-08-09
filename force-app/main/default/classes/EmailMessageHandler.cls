/**
 * @Author <Amar Kaillo>
 * @name <EmailMessageHandler>
 * @CreatedDate <21/11/2019>
 * @Description <Handler Trigger for EmailMessageTrigger>
 * @Version <1.0>
 * @reference <Referenced program names>
 *
 *
 * @Modified by : Omar Mohamad
 * @Date : 27/03/2020
 * @Description:Optimisation trigger avec le pattern 0'hara.
 */
public with sharing class EmailMessageHandler extends TriggerHandler {
    
    private Map<Id, EmailMessage> oldMap;
    private Map<Id, EmailMessage> newMap;
    private List<EmailMessage> oldList;
    private List<EmailMessage> newList;
    Set<Id> emailsChanged = new Set<Id>();
    
    public EmailMessageHandler() {
        this.oldMap = (Map<Id, EmailMessage>) Trigger.oldMap;
        this.newMap = (Map<Id, EmailMessage>) Trigger.newMap;
        this.oldList = (List<EmailMessage>) Trigger.Old;
        this.newList = (List<EmailMessage>) Trigger.New;

    }
    
    public override void afterInsert(){
        if (SM_Utilities.getUserProfileName().startsWith('SM_') || Test.isRunningTest()) {
           SM_EmailMessageProcess.updateCaseOnTask(newList,null);
        }
    }
    
    public override void afterUpdate(){
        if (SM_Utilities.getUserProfileName().startsWith('SM_') || Test.isRunningTest()) {
           SM_EmailMessageProcess.updateCaseOnTask(newList,oldMap);
        }
    }

    public override void beforeInsert(){
        if (SM_Utilities.getUserProfileName().startsWith('SM_') || Test.isRunningTest()) {
            SM_EmailMessageProcess.checkEmailsHeaders(newList);
        }
    }


}