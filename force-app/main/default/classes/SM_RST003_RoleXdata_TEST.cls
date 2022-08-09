/**
 * @author Sutharsan Pushparajah
 * @date 28/06/2022
 * @description Test class for SM_RST003_RoleXdata
 */
@isTest
private class SM_RST003_RoleXdata_TEST {
    
    /**
     * @author Sutharsan Pushparajah
     * @date 28/06/2022
     * @description testing resource input/output
     */
    @isTest
    private static void testImportRoles(){

        Boolean isError = false;

        Test.startTest();

        try {
            String result = SM_RST003_RoleXdata.importRoles(null);
        } catch (Exception exp){
            isError = true;
        }
        
        System.assertEquals(true, isError);

        Test.stopTest();
    }
}