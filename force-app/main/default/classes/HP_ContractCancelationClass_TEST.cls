/**
 * @File Name          : HP_ContractCancelationClass_TEST.cls
 * @Description        : 
 * @Author             : Mohamed Aamer
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 01/04/2020 à 14:08:07
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    06/01/2020   Mohamed Aamer     Initial Version
**/
@IsTest
public with sharing class HP_ContractCancelationClass_TEST {

    private enum StaticResource {
		HP_APIHourAccessTokenResponse_MOCK,
        HP_SendEmail_Mock
    }
	
    @TestSetUp 
	private static void insertTestData() {
            String caseRecorTypeId = HP_UTIL_SmartFactory.getDefaultRecordTypeId('Case');

            Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact','HP_Contact', new Map<String, Object>{
                'HP_IsHappe__c' => true,
                'Email'=>'test@email.com',
                'LastName' => 'LastName Test',
                'Id_Tiers__c' => 195464
            }, null, null, new List<String>{'AccountId'});
            insert contact;
    
            HP_Contrat__c contrat = (HP_Contrat__c)HP_UTIL_SmartFactory.createSObject('HP_Contrat__c', null, new Map<String, Object>{
                'HP_Compteur_Variable_Plan_prix_Index__c' => 123,
                'HP_Compteur_Plan_Bottom_Price_Index__c' => 12,
                'HP_Contrat_XdataId__c' => 282535
                }, null, null, null);
            insert contrat;
    
            // HP_Contrat__c contrat2 = (HP_Contrat__c)HP_UTIL_SmartFactory.createSObject('HP_Contrat__c', null, new Map<String, Object>{
            //     'HP_Compteur_Variable_Plan_prix_Index__c' => 123,
            //     'HP_Compteur_Plan_Bottom_Price_Index__c' => 12,
            //     'HP_Contrat_XdataId__c' => 282536
            //     }, null, null, null);
            // insert contrat2;
    
            Case caseA = (Case)HP_UTIL_SmartFactory.createSObject('Case', new Map<String, Object>{
                'HP_EffectiveDate__c' => Date.newInstance(2019, 12, 27),
                'HP_Source__c' => 'HP_CLIENT',
                'HP_Contrat__c' => contrat.id,
                'RecordTypeId' => caseRecorTypeId,
                'Status' => 'NEW_CASE',
                'ContactId' => contact.id,
                'Subject' => 'Case Test'
            }, null);
            insert caseA;
    }

    @IsTest
	static void getCancelationCase(){
            Object result = null;
            Test.startTest();
            Decimal idContrat = 12345;
            Object resultTest = HP_ContractCancelationClass.getCancelationCase(idContrat);
            Test.stopTest();
            System.assertEquals(result,resultTest,'no cases');
    }

    @IsTest
    static void createPrestationWithCase() {
            Integer result = 1;
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                null,
                new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'}
            ),
            'ES-Correspondance_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                StaticResource.HP_SendEmail_Mock.name(),
                new Map<String, String> {'Content-Type' => 'application/json'}
            )
        };

        Test.startTest();
        RestContext.response= new RestResponse();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        Decimal idContract = [SELECT HP_Contrat_XdataId__c FROM HP_Contrat__c WHERE HP_Contrat_XdataId__c = 282535 LIMIT 1].HP_Contrat_XdataId__c;
        Decimal contactId = [SELECT Id_Tiers__c FROM Contact WHERE LastName='LastName Test' LIMIT 1].Id_Tiers__c;
        String caseId = String.valueOf([SELECT Id FROM Case WHERE Subject='Case Test' LIMIT 1].Id);
        Date prestationDate = Date.newInstance(2019, 12, 27);
        String businessNumber = 'ZEJDD322';
        String caseSourceStr = 'HP_CLIENT';
        String pdlPce = '24309261797984';
        String energy = 'elec';
        String codeStatutContratCRM = 'E0011';
        String statutContrat = 'Actif';
        
        Integer resultTest = HP_ContractCancelationClass.createPrestation(prestationDate,businessNumber,caseId,caseSourceStr,
        pdlPce,idContract,contactId,energy,null,null,null,null,codeStatutContratCRM,statutContrat);
        Test.stopTest();
        System.assertEquals(result,resultTest,'ALL_IS_OK');
    }

    @IsTest
    static void createPrestationWithoutCase() {
            Integer result = 1;
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                    new Map<String, String> {'Content-Type' => 'application/json'}
                ),
                'contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    null,
                    new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'}
                ),
                'ES-Correspondance_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    StaticResource.HP_SendEmail_Mock.name(),
                    new Map<String, String> {'Content-Type' => 'application/json'}
                )
            };
    
            Test.startTest();
            RestContext.response= new RestResponse();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
            Date prestationDate = Date.newInstance(2019, 12, 27);
            String businessNumber = 'ZEJDD322';
            String caseSourceStr = 'HP_CLIENT';
            String pdlPce = '24309261797984';
            Decimal idContract = 282535;
            Decimal contactId = 195464;
            String energy = 'elec';
            String codeStatutContratCRM = 'E0011';
            String statutContrat = 'Actif';
            Integer resultTest = HP_ContractCancelationClass.createPrestation(prestationDate,businessNumber,null,caseSourceStr,
            pdlPce,idContract,contactId,energy,null,null,null,null,codeStatutContratCRM,statutContrat);
            Test.stopTest();
            System.assertEquals(result,resultTest,'ALL_IS_OK');
    }

    @IsTest
    static void createPrestationWithoutAsset() {
            Integer result = 1;
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                    new Map<String, String> {'Content-Type' => 'application/json'}
                ),
                'contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    null,
                    new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'}
                ),
                'ES-Correspondance_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    StaticResource.HP_SendEmail_Mock.name(),
                    new Map<String, String> {'Content-Type' => 'application/json'}
                )
            };
    
            Test.startTest();
            RestContext.response= new RestResponse();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
            Date prestationDate = Date.newInstance(2019, 12, 27);
            String businessNumber = 'ZEJDD322';
            String caseSourceStr = 'HP_CLIENT';
            String pdlPce = '24309261797984';
            Decimal idContract2 = 282535;
            Decimal contactId = 195464;
            String energy = 'elec';
            String codeStatutContratCRM = 'E0011';
            String statutContrat = 'Actif';
            Integer resultTest = HP_ContractCancelationClass.createPrestation(prestationDate,businessNumber,null,caseSourceStr,
            pdlPce,idContract2,contactId,energy,null,null,null,null,codeStatutContratCRM,statutContrat);
            Test.stopTest();
            System.assertEquals(result,resultTest,'ALL_IS_OK');
    }

    @IsTest
    static void scheduleCancelationCase() {
            Integer result = 1;
            Test.startTest();
            Decimal contactId = 195464;
            String caseId = String.valueOf([SELECT Id FROM Case WHERE Subject='Case Test' LIMIT 1].Id);
            Date threatmentDate = Date.newInstance(2019, 12, 27);
            String caseSourceStr = 'HP_CLIENT';
            String energy = 'elec';
            Decimal idContract = 282535;
            String assetId = null;
            Date resilDate = Date.newInstance(2020, 5, 27);
            Integer resultTest = HP_ContractCancelationClass.scheduleCancelationCase(contactId, caseId, threatmentDate, null, null, null, caseSourceStr, energy, null, idContract, assetId, resilDate);
            Test.stopTest();
            System.assertEquals(result,resultTest,'ALL_IS_OK');
    }
}