@isTest

public class COE_BAT002_ReportOsDeletion_TEST {

    public static User testUser = COE_UTIL_TestDataFactory.newUser('cb002', 'SM_SystemAdmin');

    @testSetup static void setup() {

        //actual Property Set from a basic OmniScript
        ReportOmniScript__c omniscript = COE_UTIL_TestDataFactory.newReportOs('test'); 
        insert omniscript;
       
        //OmniScript elements
        ReportOSElement__c step1 = COE_UTIL_TestDataFactory.newReportOsElement('Step1', omniscript.Id); 
        ReportOSElement__c step2 = COE_UTIL_TestDataFactory.newReportOsElement('Step2', omniscript.Id);
        insert (new  ReportOSElement__c[]{step1, step2});

    }
    
    @isTest static void executeBatch(){

        System.runAs(testUser){
            
            //run batch with default OmniScript Data
            Test.startTest();
            Database.executeBatch(new COE_BAT002_ReportOsDeletion());
            Test.stopTest();

            //check batch result
            List<ReportOmniScript__c> checkReportOS = [SELECT Id FROM ReportOmniScript__c];
            System.assertEquals(0, checkReportOS.size());
        }
    }

    @isTest static void executeSchedule(){

        System.runAs(testUser){
            
            //run batch with default OmniScript Data
            Test.startTest();
            System.schedule('Deletion scheduling', COE_UTIL_TestDataFactory.CRON_EXP, new COE_BAT002_ReportOsDeletion());
            Test.stopTest();

            //check batch result
            List<AsyncApexJob> batchJob = [SELECT Id FROM AsyncApexJob];
            System.assertEquals(2, batchJob.size()); //one job from COE_BAT002 and a second job from COE_BAT001, chained after the first 
        }
    }

}