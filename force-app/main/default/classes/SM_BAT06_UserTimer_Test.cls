/**
* @author        :  Nourelimane SMOUNI
* @date          :  05/04/2022
* @description   :  Classe test pour le batch SM_BAT06_UserTimer 
* @us            :  SMILE PI#04 , FT3-1622
**/
@IsTest (seeAllData=true) 
public class SM_BAT06_UserTimer_Test {
    //Tester le Batch    
    @isTest static void smBAT06UserTimerTest(){
        Test.startTest();
        SM_BAT06_UserTimerSchedule batchSch=new SM_BAT06_UserTimerSchedule();
        batchSch.execute(null);
        Test.stopTest();
        
    }
    
    
}