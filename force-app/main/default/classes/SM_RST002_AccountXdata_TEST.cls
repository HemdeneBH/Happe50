/**
 * @author Sutharsan Pushparajah
 * @date 28/06/2022
 * @description Test class for SM_RST002_AccountXdata
 */
@isTest
private class SM_RST002_AccountXdata_TEST {
    
    /**
     * @author Sutharsan Pushparajah
     * @date 28/06/2022
     * @description testing resource input/output
     */
    @isTest
    private static void testImportAccounts(){

        Boolean isError = false;

        Test.startTest();

        try {
            String result = SM_RST002_AccountXdata.importAccounts(null);
        } catch (Exception exp){
            isError = true;
        }
        
        System.assertEquals(true, isError);

        Test.stopTest();
    }
}