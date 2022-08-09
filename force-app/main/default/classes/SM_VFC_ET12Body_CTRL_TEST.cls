/**
 * @Author: Amar KAILLO
 * @CreatedDate: 29/04/2021
 * @ClassName: SM_VFC_ET12Body_CTRL_TEST
**/
@isTest
public class SM_VFC_ET12Body_CTRL_TEST {
    /**
	 * @Author: Amar KAILLO
 	 * @CreatedDate: 29/04/2021
     * @Description: Test Method verify parsing Omniscript Json stored in Case Field
    **/
	static testMethod void getResultTest_mailJsonOK() {
        Test.startTest();
        Case testCase = new Case();
        testCase.RecordTypeId	= Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service').getRecordTypeId();
        testCase.Subject 		= 'Communication de relevé d\'index';
        testCase.Type 			= 'Vie du contrat';
        testCase.Sous_type__c 	= 'Suivi consommation Transmission index/Contestation index';
        
        Map<String, Object> jsonValue = new Map<String, Object>();
        jsonValue.put('DernierIndex', '56789');
        jsonValue.put('NouvelIndex','76543');
        testCase.Vlocity_SendMailJson_Resil__c = JSON.serialize(jsonValue);
            //JSON.serialize(jsonValue);
        insert(testCase);

        system.debug('testcase'+testCase);
        SM_VFC_ET12Body_CTRL controller = new SM_VFC_ET12Body_CTRL();
        Map<String, String> resultValue = new Map<String, String>();
        controller.caseId = testCase.Id;
        controller.result = resultValue;
        
        Map<String, Object> result = controller.getResult();
      	//System.assertEquals(result.get('DernierIndex'), '56789');
        //System.assertEquals(result.get('NouvelIndex'), '76543');
        Test.stopTest();
    }
    
    static testMethod void getResultTest_mailJsonKO() {
        Test.startTest();
        Case testCase = new Case();
        testCase.RecordTypeId	= Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service').getRecordTypeId();
        testCase.Subject 		= 'Communication de relevé d\'index';
        testCase.Type 			= 'Vie du contrat';
        testCase.Sous_type__c 	= 'Suivi consommation Transmission index/Contestation index';
        
        insert(testCase);

        system.debug('testcase'+testCase);
        SM_VFC_ET12Body_CTRL controller = new SM_VFC_ET12Body_CTRL();
        Map<String, String> resultValue = new Map<String, String>();
        controller.caseId = testCase.Id;
        controller.result = resultValue;
        
        Map<String, Object> result = controller.getResult();
        System.assertEquals(result.size(), 0);

        Test.stopTest();
    }
}