/** 
* @author            : Ahlam BENABBOU
* @group             : SMILE FT4
* @description       : SM_BAT05_RelaunchEspaceClientSchedule batch Test class 
**/
@isTest
public class SM_Bat05_RelaunchECSchedule_Test {
    public static User testUserBAT05 = SM_TestDataFactory.createUser('BAT05', 'userBAT05@email.com', 'userBAT05lastName', 'userBAT05@username.com', 'SM_Utilisateur admin métier');
    static testMethod void testScheduleBAT05() {        
        System.runAs(testUserBAT05){ 
            Test.startTest();
            SM_BAT05_RelaunchEspaceClientSchedule batchSchedule=new SM_BAT05_RelaunchEspaceClientSchedule();   
            String chron = '0 0 23 * * ?';        
            system.schedule('Test Sched BAT05', chron, batchSchedule);
            Test.stopTest();
            //check batch result
            List<AsyncApexJob> batchJob = [SELECT Id FROM AsyncApexJob];
            System.assertEquals(2, batchJob.size());
        }    
    } 
}