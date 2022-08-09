@isTest
public class SM_ByPassProcessBuilder_Test {
    @isTest
    static void testDoNothing() {
        Test.startTest();
        SM_ByPassProcessBuilder.exitPB();
        Test.stopTest();
    }
}