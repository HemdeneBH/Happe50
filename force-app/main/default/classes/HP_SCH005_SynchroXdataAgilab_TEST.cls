@isTest
public with sharing class HP_SCH005_SynchroXdataAgilab_TEST {

    @isTest static void launchNewScheduler_TEST(){
        Test.startTest();
        HP_SCH005_SynchroXdataAgilab.launchNewScheduler();
        Test.stopTest();
        System.assertEquals(2, [Select count() from AsyncApexJob],'job executed');
    }
    
}