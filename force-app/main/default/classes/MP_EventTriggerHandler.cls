public class MP_EventTriggerHandler extends TriggerHandler {
    public override void beforeInsert() {
        MP_AP17_EventHandler.onBeforeInsert(Trigger.new);
    }

    public override void afterInsert() {
        MP_AP17_EventHandler.onAfterInsert(Trigger.new);
    }

    public override void beforeUpdate() {
        MP_AP17_EventHandler.onBeforeUpdate((Map<Id, Event>)Trigger.newMap, (Map<Id, Event>)Trigger.oldMap);
    }

    public override void afterUpdate() {
        MP_AP17_EventHandler.onAfterUpdate((Map<Id, Event>)Trigger.newMap, (Map<Id, Event>)Trigger.oldMap);
    }
}