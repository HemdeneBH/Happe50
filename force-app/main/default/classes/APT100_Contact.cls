/**
 * @author Sutharsan Pushparajah
 * @date 24/06/2022
 * @description APT100_Contact - Contact Trigger Handler Class using SSDEVL Framework
 */
public inherited sharing class APT100_Contact {
    
    /**
     * @author Sutharsan Pushparajah
     * @date 24/06/2022
     * @description APT100_Contact.BeforeInsert - Class to implement Before Insert logic
     */
    public inherited sharing class BeforeInsert extends APT001_TriggerEventManager{

        private Map<Id, Contact> oldMap = (Map<Id, Contact>) Trigger.oldMap;
        private List<Contact> newList = Trigger.new;

        public override void process(){
            ///Protected by CustomPermission and only for XDATA IMPORT V3
            SM_SM103_XdataImportHandler.validateContactBeforeInsert(newList);

            if (SM_Utilities.getUserProfileName().startsWith('SM_') || Test.isRunningTest()) {
                SM_ContactProcess.setPrincipalValueRW(oldMap, newList);
            }
        }

    }

    /**
     * @author Sutharsan Pushparajah
     * @date 24/06/2022
     * @description APT100_Contact.BeforeUpdate - Class to implement Before Update logic
     */
    public inherited sharing class BeforeUpdate extends APT001_TriggerEventManager{
        
        private Map<Id, Contact> oldMap = (Map<Id, Contact>) Trigger.oldMap;
        private Map<Id, Contact> newMap = (Map<Id, Contact>) Trigger.newMap;
        private List<Contact> newList = Trigger.new;

        public override void process(){
            //Protected by CustomPermission and only for XDATA IMPORT V3
            SM_SM103_XdataImportHandler.validateContactBeforeUpdate(oldMap, newMap);

            if (SM_Utilities.getUserProfileName().startsWith('SM_') || Test.isRunningTest()) {
                SM_ContactProcess.setPrincipalValueRWFromUpdate(oldMap, newList);
                SM_ContactProcess.updatePreviousEmail(oldMap, newList);
            }
        }
    }
}