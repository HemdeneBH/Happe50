/**
 * @description       : 
 * @author            : Ali AJELLAL
 * @group             : 
 * @last modified on  : 03-01-2022
 * @last modified by  : Hemdene Ben Hammouda
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   11-12-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/

@IsTest
public with sharing class HP_UTIL_MetadataManager_TEST {

    @TestSetup
    static void setupData(){
        HP_Okta_Token_Parameter__c settings = HP_Okta_Token_Parameter__c.getOrgDefaults();
        settings.Encryption_Key__c = '8cPkWGCoHv9a3D7K';
        settings.Encryption_Code__c = 'AES128';
        upsert settings HP_Okta_Token_Parameter__c.Id;
    }

    @isTest static void updateSouscription_Test() {
        
        List<HP_Codification__mdt> allCodificationWithChild = [select ID,DeveloperName,keyType__c,valueType__c from HP_Codification__mdt limit 1];

        List<String> keys = new List<String>();
        for (HP_Codification__mdt item   : allCodificationWithChild) {
            keys.add(item.developername);
            System.debug('********item test ******* '+ item);

        }
            Test.startTest();
            HP_UTIL_MetadataManager.getCodification(keys);
            Test.stopTest(); 
            
        }    
    


    @istest static void getConfigByKeyTest() {
        Test.startTest();
        String cleConfiguration = 'HP_AGILAB_PROD_URL';
        String expectedResult = 'https://agilab-site.particuliers.engie.fr/';
		String result = HP_UTIL_MetadataManager.getConfigByKey(cleConfiguration);        
        Test.stopTest();
        
        System.assertEquals(expectedResult, result);
    }

    @istest static void getConfigByKeyTest2() {
        Test.startTest();
        String cleConfiguration = 'HP_OKTA_TOKEN';
		String result = HP_UTIL_MetadataManager.getConfigByKey(cleConfiguration);        
        Test.stopTest();
        
    }
    
    @IsTest 
	static void getContryCodeTest(){
        Test.startTest();
		String indicatif = '+33';
        String result = HP_UTIL_MetadataManager.getContryCode(indicatif);
        String expectedResult = 'FRA';
        Test.stopTest();
        System.assertEquals(expectedResult, result);
    }
    
    @IsTEst
    static void getOmniChannelRoutingMtd() {
        
        Test.startTest();
        List<HP_OmniChannelRouting__mdt> mapResult = HP_UTIL_MetadataManager.getOmniChannelRoutingMtd();
        Test.stopTest();
        
        System.assert(mapResult != null);
    }



}