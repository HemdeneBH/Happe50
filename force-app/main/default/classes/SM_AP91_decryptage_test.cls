@isTest(SeeAllData=true)
public class SM_AP91_decryptage_test {
    @isTest static void testCallout(){
        Test.setMock(HttpCalloutMock.class, new SM_decryptage_mock());
        string decrypt = SM_AP91_decryptage.callapidecryptage('decryptemoi');
        System.assertEquals('ibandecrypte', decrypt);
    }
}