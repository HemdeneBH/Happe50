/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-25-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public without sharing class HP_SM074_CheckWithinBusinessHours {
    
    @InvocableMethod(label = 'Within Business Hours Check')
    public static List<Boolean> CheckWithinBusinessHours(List<String> Name) {

        String BHName= String.valueOf(+Name[0]);
        // Get Business hours based on name, input from bot
        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE name= :BHName];
        // Create Datetime with current date/time in local time zone
        Datetime targetTime = Datetime.now();
        Date targetDate = Date.today();
        // Find whether the time is within business hours
        Boolean isBH= BusinessHours.isWithin(bh.id, targetTime);
        // Find whether today is a Holiday
        List<Holiday> hdList = [Select Id From Holiday where ActivityDate = :targetDate];
        Boolean isHoliday = hdList.size() > 0;

        Boolean isWithin = (isBH || !isHoliday) ;
        return new List<Boolean>{isWithin};

    }
}