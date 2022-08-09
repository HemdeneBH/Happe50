@isTest
public with sharing class HP_SCH002_Contractualisation_TEST {




    @isTest static void launchNewScheduler_TEST(){
        Test.startTest();
        HP_SCH002_Contractualisation.launchNewScheduler();
        Test.stopTest();
        System.assertEquals(2, [Select count() from AsyncApexJob],'job executed');
    }
    
}