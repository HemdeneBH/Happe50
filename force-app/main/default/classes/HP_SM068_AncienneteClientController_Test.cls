/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 10-14-2021
 * @last modified by  : Badr Eddine Belkarchi
**/
@isTest
public class HP_SM068_AncienneteClientController_Test {

    @IsTest
    static void getAllContractsOfClient() {
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {

            'apiset/0.2/contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                'HP_SM068_XDATA_ClientContrats_MOCK',
                                                new Map<String, String> { 'Content-Type' => 'application/json'})
        };

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        List<Object> contracts = HP_SM068_AncienneteClientController.getAllContractsOfClient('0031l00000b5gzLAAQ');
        Test.stopTest();
        System.assertEquals(contracts.size() > 0, true);
    }

    @IsTest
    static void getAllCodeOffres() {
        Test.startTest();
        HP_SM068_AncienneteClientController.getAllCodeOffres();
        Test.stopTest();
    }
}