/**
 * @File Name          : HP_UTIL_Vue360Manager_TEST.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Hemdene Ben Hammouda
 * @Last Modified On   : 11-09-2021
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    23/04/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
@IsTest
public with sharing class HP_UTIL_Vue360Manager_TEST {

    @testSetup static void dataSetup(){




        System.runAs(HP_UTIL_SmartFactory.insertUserHP()){  
        }
    }




    @isTest
	static void vue360Test(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){

        Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact','HP_Contact', new Map<String, Object>{'HP_IsHappe__c' => true,  'Id_Tiers__c' => 100166,'lastName' => 'testnicot'}, null,null, null);
        insert contact;

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_APIHourAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            '' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_CONTRAT_XDATA_BY_PERSONNE_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            )
        };
       

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_UTIL_Vue360Manager.loadDataVue360('V1_SOQL_LOAD_CONTACT_FROM_SF_BY_ID', contact.Id, contact.Id);
        HP_UTIL_Vue360Manager.loadDataVue360('V1_EMPTY_SECONDARY_DATA', new Map<String, String> {'xdataId' => '5656', 'agilabId' => '950481486'}, contact.Id );
        HP_UTIL_Vue360Manager.loadDataVue360('V1_EMPTY_PFC_DATA', new map<String,Object>{'pfcId' => '261422', 'contratIdList' => new List<String>{'308060','308062'}}, contact.Id);
        Test.stopTest();
    }

    }



     @isTest
	static void vue360ClassTest(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_APIHourAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            '' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                null,
                new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'}
            )
        };
        HP_UTIL_Vue360LoadCoContractant coContractant = new HP_UTIL_Vue360LoadCoContractant();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        Test.stopTest();
            //coContractant.processing(new Map<String, Object>{'data' => ''}, null);
        }



    }

    
    @isTest static void getContryCode_TEST(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
        Test.startTest();
        String str = HP_SM003_MetadataManager.getContryCode('+33');
        Test.stopTest();
        System.assert(str == 'FRA' , 'ISO France');
    }


    }


}