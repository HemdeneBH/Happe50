/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-08-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public without sharing class HP_SM070_HolidayWeekend {

    @InvocableMethod
    public static void checkTreatmentDay(List<Id> casId) {
        Case cas = [Select Id,HP_TreatmentDate__c From Case where Id IN :casId LIMIT 1];
        List<Holiday> hdList = [Select Id,ActivityDate From Holiday];
        for(Holiday hd : hdList){
            if (hd.ActivityDate == cas.HP_TreatmentDate__c){
                cas.HP_TreatmentDate__c = cas.HP_TreatmentDate__c+1;
                Date d = cas.HP_TreatmentDate__c ;
                DateTime dt = (DateTime)d ;
                String dayOfWeek = dt.format('E');
                if(dayOfWeek == 'Sun'){
                    cas.HP_TreatmentDate__c = cas.HP_TreatmentDate__c+1;
                }
            }
        }
        update cas;
    }


}