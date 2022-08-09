/**
 * @description:to be completed
 * @projet: Smile
 *
 *
 * @Modified by : Omar Mohamad
 * @Date : 27/03/2020
 * @Description:Optimisation trigger avec le pattern 0'hara.
 */
trigger EmailMessageTrigger on EmailMessage (after update,after insert,before insert,before update) {

    if(!ByPassSettings__c.getInstance().EmailMessageTrigger__c) {

        new HP_HDL004_EmailMessage().run();

        if(Trigger.isAfter){
            if(Trigger.isInsert){
                new EmailMessageHandler().run();
            }
            
            if(Trigger.isUpdate){
                new EmailMessageHandler().run();
            }
        }

        if (Trigger.isBefore) {
            if(Trigger.isInsert){
                new EmailMessageHandler().run();
            }
        }
    }
}