/**
 * @author Sutharsan Pushparajah
 * @date 24/06/2022
 * @description APT101_Account - Account Trigger Handler Class using SSDEVL Framework
 */
public inherited sharing class APT101_Account {
    
    /**
     * @author Sutharsan Pushparajah
     * @date 24/06/2022
     * @description APT101_Account.BeforeInsert - Class to implement Before Insert logic
     */
    public inherited sharing class BeforeInsert extends APT001_TriggerEventManager{

        private List<Account> newList = Trigger.new;

        public override void process(){
            ///Protected by CustomPermission and only for XDATA IMPORT V3
            SM_SM103_XdataImportHandler.validateAccountBeforeInsert(newList);
        }

    }

    /**
     * @author Sutharsan Pushparajah
     * @date 24/06/2022
     * @description APT101_Account.BeforeUpdate - Class to implement Before Update logic
     */
    public inherited sharing class BeforeUpdate extends APT001_TriggerEventManager{
        
        private Map<Id, Account> oldMap = (Map<Id, Account>) Trigger.oldMap;
        private Map<Id, Account> newMap = (Map<Id, Account>) Trigger.newMap;

        public override void process(){
            //Protected by CustomPermission and only for XDATA IMPORT V3
            SM_SM103_XdataImportHandler.validateAccountBeforeUpdate(oldMap, newMap);
        }
    }
}