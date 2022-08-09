public class MP_AccountTriggerHandler extends TriggerHandler {
    public override void afterInsert() {
        MP_AP09_AccountHandler.onAfterInsert(MP_AP09_AccountHandler.getPartners(Trigger.new));
    }

    public override void afterUpdate() {
        MP_AP09_AccountHandler.onAfterInsert(MP_AP09_AccountHandler.getModifiedPartners(Trigger.new, (Map<Id, Account>)Trigger.oldMap));
        MP_AP09_AccountHandler.updateNoCoverLeads(Trigger.new, (Map<Id, Account>)Trigger.oldMap);
    }
}