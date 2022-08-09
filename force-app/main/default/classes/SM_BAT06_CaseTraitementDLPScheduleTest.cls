/**
 * @description       : Test class for the batch SM_BAT06_CaseTraitementDLPSchedule
 * @author            : FT2-AE
 * @group             : SMILE FT2
 * @last modified on  : 03-02-2022
 * @last modified by  : FT2-AE
**/
@IsTest
public with sharing class SM_BAT06_CaseTraitementDLPScheduleTest {
    @isTest 
    static void testBatchSchedulable() {
        Test.startTest();
        SchedulableContext sc = null;
        SM_BAT06_CaseTraitementDLPSchedule tsc = new SM_BAT06_CaseTraitementDLPSchedule();
        tsc.execute(sc);
        Test.stopTest();
    }
}