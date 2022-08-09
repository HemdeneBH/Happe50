public with sharing class BatchApexErrorEventTriggerHandler extends TriggerHandler {

    private List<BatchApexErrorEvent> newList;
    
    public BatchApexErrorEventTriggerHandler() {
        this.newList = (List<BatchApexErrorEvent>) Trigger.New;
    }
    
    public override void afterInsert(){
        HP_SM035_BatchApexErrorEventLog.insertLog(newList);
    }
}