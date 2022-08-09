/**
 * @description: Trigger related to Case object
 * @projet: Smile
 */



trigger CaseTrigger on Case (before insert,before update,after update, after insert) {













        new HP_HDL001_Case().run();
        if(Trigger.isBefore){
            if(Trigger.isInsert){



                new CaseHandler().run();
            }
        }
       
  

}