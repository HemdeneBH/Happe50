@isTest
public class VI_SM019_EstimerGazConsommation_Test {
    @isTest
    public static void test_estimerGaz(){
        Decimal estimerGazSuccess = VI_SM019_EstimerGazConsommation.estimerGaz('1994', '23', '020', '010', 2, 23, '020', '010', '020', '010','010', 'VI', '3', 'callout:AuthOctopus');
        system.assertEquals(1000, estimerGazSuccess);
    }
}