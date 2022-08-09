/**
 * @File Name          : HP_SM003_MetadataManager_TEST.cls
 * @Description        : 
 * @Author             : Antoine Latour
 * @Group              : 
 * @Last Modified By   : Badr Eddine Belkarchi
 * @Last Modified On   : 09-21-2021
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    08/07/2020   Antoine Latour     Initial Version
**/
@isTest
public with sharing class HP_SM003_MetadataManager_TEST {
    
    @testSetup static void dataSetup(){
        insert new HP_Offre__c(
            offreCode__c='HP_TEST_OFFRE',
            offreId__c=123456,
            marqueCode__c='HP_MARQ',
            packId__c=123456,
            offreLibelle__c='Offre de test',
            Name='TEST'
        );
    }

    @IsTest 
	static void getContryCode(){
        Test.startTest();
		String indicatif = '+33';
        String result = HP_SM003_MetadataManager.getContryCode(indicatif);
        String expectedResult = 'FRA';
        Test.stopTest();
        System.assertEquals(expectedResult, result);
    }

    @IsTest 
	static void getConfigurationGenerique(){
        Test.startTest();
        String cleConfiguration = 'HP_AGILAB_PROD_URL';
        String expectedResult = 'https://agilab-site.particuliers.engie.fr/';
		String result = HP_SM003_MetadataManager.getConfigurationGenerique(cleConfiguration);
        Test.stopTest();
        System.assertEquals(expectedResult, result);
    }
    
    @IsTest
    static void getAgilabEspaceClientURL() {
        Test.startTest();
        Organization org = [select IsSandbox from Organization where Id =:UserInfo.getOrganizationId()];
        String expectedResult;
        if(org.IsSandbox) {
            expectedResult = 'https://agilab-recette.myengie.com/';
        }
        else {
            expectedResult = 'https://agilab-site.particuliers.engie.fr/';
        }
        String result = HP_SM003_MetadataManager.getAgilabEspaceClientURL();
        Test.stopTest();
        System.assert(String.isNotBlank(result));
    }
    
    @IsTest
    static void getCodeOffre() {
        Test.startTest();
        Map<String, HP_Offre__c> result = (Map<String, HP_Offre__c>) HP_SM003_MetadataManager.getCodeOffre();
        Test.stopTest();
        System.assert(result.get('HP_TEST_OFFRE') != null);
    }

    @IsTest
    static void getURLPortailAdmin() {
        Test.startTest();
        String keyPortailAdmin = 'HP_URL_PORTAIL_ADMIN';
        String result = HP_SM003_MetadataManager.getURLPortailAdmin(keyPortailAdmin);
        Test.stopTest();
        System.assert(String.isNotBlank(result));
    }
    
}