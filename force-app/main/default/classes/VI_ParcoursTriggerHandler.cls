/*
@Author : Paul Ghoussoub
@CreatedDate : 23-02-2021
@Description : Parcours Object Trigger Handler.
*/
public class VI_ParcoursTriggerHandler extends TriggerHandler{   
    
    //Use this variable to disable this trigger from transaction
    public static Boolean TriggerDisabled = false;
    
    //check if the trigger is disabled from transaction
    public Boolean isDisabled(){
        return TriggerDisabled;
    }
    public override void beforeUpdate() {
      VI_SM046_ParcoursBeforeUpdateHandler.ParcoursBeforeUpdate((List<VI_Parcours__c>)Trigger.new,(Map<ID,VI_Parcours__c>)Trigger.oldMap);
    }
    public override void afterUpdate() {
      VI_ParcoursAfterUpdateHandler.ParcoursAfterUpdate((List<VI_Parcours__c>)Trigger.new,(Map<ID,VI_Parcours__c>)Trigger.oldMap);
    }
}