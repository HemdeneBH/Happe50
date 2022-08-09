/**
 * @author Sutharsan Pushparajah
 * @date 24/06/2022
 * @description Test class for SM_EM105_ProcessSettings
 */
@isTest
private class SM_EM105_ProcessSettings_TEST {

    /**
     * @author Sutharsan Pushparajah
     * @date 24/06/2022
     * @description Testing retrieving attributes from ProcessSettings__mdt
     */
    @isTest
    private static void testGetProcessSettings(){
        Test.startTest();

        Map<String, Object> settings = SM_EM105_ProcessSettings.getProcessSettings('XDATA_IMPORT');

        System.assertNotEquals(null, settings);
        System.assertNotEquals(0, settings.size());
        System.assertEquals(true, settings.containsKey('QueueableThreshold'));
        System.assertEquals(true, settings.get('QueueableThreshold') instanceof Integer);

        Test.stopTest();
    }
}