/*
* @Author: Paul Ghoussoub
*@Description: Trigger handler de la tache
*@CreatedDate: 1/4/2021
*/
public class VI_TaskTriggerHandler extends TriggerHandler{
//Use this variable to disable this trigger from transaction
    public static Boolean TriggerDisabled = false;
    
    //check if the trigger is disabled from transaction
    public Boolean isDisabled(){
        return TriggerDisabled;
    }
    public override void afterInsert() {
        //VI_TaskAfterInsertHandler.taskAfterInsert(trigger.new);
    }
    public override void afterUpdate() {
        VI_TaskAfterUpdateHandler.taskAfterUpdate(trigger.new,(Map<Id,Task>)trigger.oldMap);
    }
}