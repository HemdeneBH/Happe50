/*author: MHA
*description: recherhce des informations de la zone de distribution
*CreatedDate: 14/12/2018
*LastModified MHA 14/12/2018
*/
@isTest
private class SM_AP44_ZoneDistributionApiService_TEST {
    /*author: MHA
    *description: recherhce des informations de la zone de distribution
    *CreatedDate: 14/12/2018
    *LastModified MHA 14/12/2018
    */
    @isTest static void callZoneDistributionWithCodeInsee() {
        // Implement test code
        Map < String, Object > inputMap = new Map < String, Object >();
        Map < String, Object > outputMap = new Map < String, Object >();
        inputMap.put('codeINSEE','01001');
        inputMap.put('postcode','01400');

        /*prepareApiCallResource();*/
        SM_AP44_ZoneDistributionApiService service = new SM_AP44_ZoneDistributionApiService();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SM_MockTestZoneDistributeur');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);

        service.invokeMethod('callZoneDistribitionByCodeInsee',inputMap,outputMap,null);
        SM_AP44_ZoneDistributionApiService.zoneDistributionModel elec = (SM_AP44_ZoneDistributionApiService.zoneDistributionModel)outputMap.get('elec');
        SM_AP44_ZoneDistributionApiService.zoneDistributionModel gaz = (SM_AP44_ZoneDistributionApiService.zoneDistributionModel)outputMap.get('gaz');
        //System.assertEquals('non',elec.appartientRegie);
        //System.assertEquals('non',gaz.appartientRegie);
        //System.assertEquals('elec',elec.libelleTypeEnergie);
        //System.assertEquals('gaz',gaz.libelleTypeEnergie);
    }

}