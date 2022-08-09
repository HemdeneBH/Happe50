/**
 * @author Sutharsan Pushparajah
 * @date 28/06/2022
 * @description Test class for SM_RST001_ContactXdata
 */
@isTest
private class SM_RST001_ContactXdata_TEST {
    
    /**
     * @author Sutharsan Pushparajah
     * @date 28/06/2022
     * @description testing resource input/output
     */
    @isTest
    private static void testImportContacts(){

        Boolean isError = false;

        Test.startTest();

        try {
            String result = SM_RST001_ContactXdata.importContacts(null);
        } catch (Exception exp){
            isError = true;
        }
        
        System.assertEquals(true, isError);

        Test.stopTest();
    }
}