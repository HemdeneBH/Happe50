/* 
 * @description:to be completed
 * @projet:Mypower, Smile
 *
 *
 * @Modified by : Omar Mohamad
 * @Date : 27/03/2020
 * @Description:Optimisation trigger avec le pattern 0'hara.
 */
trigger ContactTrigger on Contact (after update,after insert,before insert,before update) {

    if(!ByPassSettings__c.getInstance().ContactTrigger__c) {

        HP_HDL002_Contact.execute();

        if(Trigger.isBefore){
            if(Trigger.isInsert){
                new SM_ContactHandler().run();
            }

            if(Trigger.isUpdate){
                new SM_ContactHandler().run();
            }
        }
    }
}