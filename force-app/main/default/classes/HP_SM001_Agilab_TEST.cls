/**
 * @File Name          : HP_SM001_Agilab_TEST.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Hemdene Ben Hammouda
 * @Last Modified On   : 12-09-2021
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    14/02/2020   Mouhamadoune Coulibaly     Initial Version
**/
@IsTest
public with sharing class HP_SM001_Agilab_TEST {

    @testSetup static void dataSetup(){
        HP_UTIL_SmartFactory.insertUserHP();
    }

    @IsTest 
	  static void getGrilleTarifaire(){

        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'grille_pricings/getGrille' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_SM001_Agilab_GetGrilleTarifaire_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}),
                
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_APIHourAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'})
                };

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
        Object result =  HP_SM001_Agilab.getGrilleTarifaire('282644', '06/11/2019');
        Map<String,Object> mapResult=(Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(result));
        System.debug(mapResult);
        Test.stopTest();
        System.System.assertEquals('203.88', mapResult.get('aboHt'));
        }    
    }

     @IsTest 
	  static void getContratInfo(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'propositions/afficher_informations_contrat' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_SM001_Agilab_GetContratInfo_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}),
                
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_APIHourAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'})
                };

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
        Object  result = HP_SM001_Agilab.getContratInfo('282644');
        Map<String,Object> mapResult=(Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(result));
        System.debug(mapResult);
        Test.stopTest();
        System.System.assertEquals('SUCCESS', mapResult.get('status'));
        }
    }

     @IsTest 
	  static void getClientInfo(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                '/aides/afficher_informations_aide' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_SM001_Agilab_GetClientInfo_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}),
                
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_APIHourAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'})
                };

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
            Object  result = HP_SM001_Agilab.getClientInfo('195464');
            Map<String,Object> mapResult=(Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(result));
            System.debug(mapResult);
            Test.stopTest();
            System.System.assertEquals('SUCCESS', mapResult.get('status'));
        }
    }

    @IsTest 
	  static void setClientInfoTest(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                '/aides/modifier_informations_aide' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_SM001_Agilab_SetClientInfo_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}),
                
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_APIHourAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'})
                };

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
            String informationAide = '{"idClientXdata":1858282,"idContratXdata":377508,"dateDebutAide":"2021-12-01","dateFinAide":"2022-11-30"}';
            Boolean  result = HP_SM001_Agilab.setClientInfo(informationAide);
            Test.stopTest();
            System.System.assertEquals(true, result);
        }
    }

    @IsTest 
	  static void getRelatedCasesTest(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{ 
                'Id_Tiers__c' => 100166,
                'Salutation'=>'MR',
                'lastName' => 'testnicot',
                'firstName' => 'lenfant',
                'email' => 'user@example.com',
                'mobilePhone' => '0756543434',
                'Phone' => '0145454545',
                'No_Voie__c' => '22',
                'MailingStreet' => 'rue des bois',
                'MailingPostalCode' => '92160',
                'Complement_adresse__c' => 'REZID',
                'MailingCity' =>'ANTONY'
            }, null, null, null);
            insert contact;
            List<Case> caseList = new List<Case>();
            caseList.add( (Case)HP_UTIL_SmartFactory.createSObject('Case','HP_Mail', new Map<String, Object>{
                'Status' => 'NEW_CASE',
                'HP_Type__c' => 'Dossier_Aide',   
                'Subject' => 'Mail',
                'SuppliedName' => contact.Name,
                'HP_Aide_Contact__c' => contact.Id
                }, null, null, null));
            caseList.add( (Case)HP_UTIL_SmartFactory.createSObject('Case','HP_Mail', new Map<String, Object>{
                'Status' => 'TO_DO',
                'HP_Type__c' => 'INVALID_DATA',   
                'Subject' => 'Mail',
                'SuppliedName' => contact.Name,
                'HP_Aide_Contact__c' => contact.Id
                }, null, null, null));
            insert caseList;
            Test.startTest();
            List<HP_WRP047_InformationsAideRelatedCases> resultList = HP_SM001_Agilab.getRelatedCases(contact.Id);
            Test.stopTest();
            System.System.assertEquals(true, resultList.size()>0);
        }
    }
    
     @IsTest 
	  static void getPersonne(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'personnes/show' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_SM001_Agilab_GetPersonne_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}),
                
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_APIHourAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'})
                };

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
        Object  result = HP_SM001_Agilab.getPersonne(1111);
        Map<String,Object> mapResult=(Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(result));
        System.debug(mapResult);
        Test.stopTest();
        System.System.assertEquals('SUCCESS', mapResult.get('status'));
        }
    }

      @IsTest 
	  static void getRemboursement(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'portefeuille_contrats/voir_remboursements' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_SM001_Agilab_Remboursement_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}),
                
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_APIHourAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'})
                };

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
        Object  result = HP_SM001_Agilab.getRemboursement('247418');
        Map<String,Object> mapResult=(Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(result));
        System.debug(mapResult);
        Test.stopTest();
        System.System.assertEquals('SUCCESS', mapResult.get('status'));
        }
    }

    @IsTest 
    static void getEcheance(){

        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'propositions/afficher_echeances_contrat' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_SM001_Agilab_GetEcheance_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}),
                
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_APIHourAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'})
                };

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
        Object  result = HP_SM001_Agilab.getEcheance(305937);
        System.debug('++++++++++++'+ result);
        Map<String,Object> mapResult=(Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(result));
        System.debug(mapResult);
        Test.stopTest();
        System.System.assertEquals('SUCCESS', mapResult.get('status'));
        }
  }

  @IsTest 
  static void getSolde(){
    System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'personnes/solde_effectif' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
            'HP_SM001_Agilab_GetSolde_MOCK',
            new Map<String, String> {'Content-Type' => 'application/json'}),
            
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
            'HP_APIHourAccessTokenResponse_MOCK',
            new Map<String, String> {'Content-Type' => 'application/json'})
            };

    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
    Object  result = HP_SM001_Agilab.getSolde(1111);
    Map<String,Object> mapResult=(Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(result));
    System.debug(mapResult);
    Test.stopTest();
    System.System.assertEquals('SUCCESS', mapResult.get('status'));
    }
}

@IsTest 
static void getFacture(){
    System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'portefeuille_contrats/factures' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
            'HP_SM001_Agilab_GetFacture_MOCK',
            new Map<String, String> {'Content-Type' => 'application/json'}),
            
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
            'HP_APIHourAccessTokenResponse_MOCK',
            new Map<String, String> {'Content-Type' => 'application/json'})
            };

    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
    Object  result = HP_SM001_Agilab.getFacture(246522);
    Map<String,Object> mapResult=(Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(result));
    System.debug(mapResult);
    Test.stopTest();
    System.System.assertEquals('SUCCESS', mapResult.get('status'));
    }
}

@IsTest 
static void getClienOffline(){
    System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'personnes/client_offline' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
            'HP_SM001_Agilab_GetClienOffline_MOCK',
            new Map<String, String> {'Content-Type' => 'application/json'}),
            
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
            'HP_APIHourAccessTokenResponse_MOCK',
            new Map<String, String> {'Content-Type' => 'application/json'})
            };

    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
    Object  result = HP_SM001_Agilab.getClienOffline(196489);
    Map<String,Object> mapResult=(Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(result));
    System.debug(mapResult);
    Test.stopTest();
    System.System.assertEquals('SUCCESS', mapResult.get('status'));
    }
}

    @IsTest 
    static void getPaiement(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'propositions/paiements' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_SM001_Agilab_GetPaiement_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}),
                
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_APIHourAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'})
                };

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
        Object  result = HP_SM001_Agilab.getPaiement(972732173);
        Map<String,Object> mapResult=(Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(result));
        System.debug(mapResult);
        Test.stopTest();
        System.System.assertEquals('SUCCESS', mapResult.get('status'));
        }
    }
   
}