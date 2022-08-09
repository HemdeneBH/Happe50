/**
 * @author Sutharsan Pushparajah
 * @date 19/04/2022
 * @description Test class for SM_EM104_CodeProduitProjet
 */
@isTest
private class SM_EM104_CodeProduitProjet_TEST {

    /**
     * @author Sutharsan Pushparajah
     * @date 19/04/2022
     * @description Testing get active SM_CodeProduitProjet__mdt records sorted by OrderId__c
     */
    @isTest
    private static void testGetActivesSortedByOrderId(){

        Test.startTest();

        List<SM_CodeProduitProjet__mdt> results = SM_EM104_CodeProduitProjet.allActivesSortedByOrderId;
        System.assertNotEquals(null, results);
        System.assertEquals(false, results.isEmpty());

        for (SM_CodeProduitProjet__mdt cpp : results){
            System.assertEquals(true, cpp.IsActive__c);
        }

        Test.stopTest();
    }
    
}