/**
* @author        :  Nourelimane SMOUNI
* @date          :  01/04/2022
* @description   :  [Habilitation] - Désactivation des users automatisés
* @us            :  SMILE PI#04 , FT3-1622
**/
public without sharing class SM_BAT06_UserTimerSchedule implements Schedulable {
    public void execute(SchedulableContext sc) {
        if(!Test.isRunningTest()){
            database.executebatch(new SM_BAT06_UserTimer(),200);
        }else{
               database.executebatch(new SM_BAT06_UserTimer(),1) ; 
       }
        
    }
}