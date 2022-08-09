/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 03-11-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
@isTest
public with sharing class HP_BAT033_CoupureAttente_TEST {
    @TestSetup
    static void dataSetup(){
        Account acc = (Account)HP_UTIL_SmartFactory.createSObject('Account','HP_Account' ,new Map<String, Object>{
            'HP_XDataExternalId__c' => 100166,
            'Name' => 'UnitTest',
            'OwnerId' => UserInfo.getUserId()
        },null,null, null);
        insert acc;
        
            Contact aContact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{
                'AccountId' => acc.Id,
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
                'MailingCity' =>'ANTONY',
                'OwnerId' => UserInfo.getUserId()
            }, null, null, null);
            insert aContact;

        HP_Souscription__c enrolment = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
                'HP_Canal_de_vente__c'  => 'Vente Online',
                'HP_Contact__c'=> aContact.Id,
                'HP_Classe_de_la_consommation_Gaz__c'  => 'B0',
                'HP_Code_Gaz_Produit__c'  => 'GITR2_H',
                'HP_Code_Electrique_Produit__c'  => 'EITR2_H',
                'HP_Code_postal__c'  => '92160',
                'HP_code_Postal_Insee__c'  => '92002',
                'HP_Date_de_Contractualisation__c'  => System.today().addDays(1),
                'HP_Date_Origine__c'  =>DateTime.newInstance(2019, 10, 9, 13, 0, 0),
                'HP_Energie_Verte__c'  => false,
                'HP_Estimation_Consommation_electrique__c'  => 6000,
                'HP_Estimation_Consommation_gaz__c'  => 13000,
                'HP_Jour_de_facturation__c' => 16,
                'HP_Lien_enregistrement__c' =>'test.fr',
                'HP_Methode_de_paiement__c' =>'BANK_CARD',
                'HP_Montant_de_la_facturation_electrique__c' =>58,
                'HP_Montant_de_la_facturation_gaz__c' =>120,
                'HP_Predecesseur__c' =>'Dupont',
                'HP_Nom_de_rue__c' =>'rue des bois',
                'HP_Nom_de_ville__c' =>'ANTONY',
                'HP_Numero_de_voie__c' =>'15 ter',
                'HP_Periode_de_facturation__c' =>'BIMONTHLY',
                'HP_Plan_de_Prix_electrique__c' =>'BASE',
                'HP_Puissance_Compteur_electrique__c' =>6,
                'HP_Souscription_Digital_Id__c' =>'testGazElec-01',
                'HP_Type_Energie__c' =>'COMBINED_GAS_AND_ELECTRICITY',
                'HP_type_Souscription__c' =>'MOVING_IN',
                'HP_NumberPCE__c' =>'31431211214068',
                'HP_NumPDL__c' =>'31431211214170',
                'HP_Statut__c' =>'SAVE_1',
                'OwnerId' => UserInfo.getUserId()
            }, null);
            insert enrolment;

            HP_Porte_Feuille_Contrat__c porteFeuille = (HP_Porte_Feuille_Contrat__c)HP_UTIL_SmartFactory.createSObject('HP_Porte_Feuille_Contrat__c', null, new Map<String, Object>{
                'HP_Contact__c' => acontact.id,
                'Xdata_Id__c' => '1222',
                'HP_Souscription_Digital_Id__c'=>'testGazElec-01'
            }, null, null, null);
            insert porteFeuille;
            
    
    
            HP_Contrat__c cGaz =(HP_Contrat__c) HP_UTIL_SmartFactory.createSObject('HP_Contrat__c', 
            new Map<String, Object>{ 
                'HP_Numero_reference_du_Compteur__c' => '423',
                'HP_Id_Compteur__c' => '31431211214068',
                'HP_Contrat_XdataId__c' => 100148,
                'HP_Souscription_Digital_Id__c' => enrolment.HP_Souscription_Digital_Id__c+'GAS',
                'HP_Proposition_Commerciale_XdataId__c'=>'775949',
                'HP_Souscription__c'=> enrolment.id,
                'HP_Type_de_Compteur__c' => 'GAS',
                'HP_Index_de_Compteur__c'=>2323434,
                'HP_Porte_Feuille_Contrat__c' => porteFeuille.Id
            }, null);
            insert cGaz;
    
            HP_Contrat__c cElec =(HP_Contrat__c) HP_UTIL_SmartFactory.createSObject('HP_Contrat__c', 
            new Map<String, Object>{ 
                'HP_Numero_reference_du_Compteur__c' => '423',
                'HP_Id_Compteur__c' => '31431211214170',
                'HP_Compteur_Base_Plan_Index__c' => 56726,
                'HP_Compteur_Variable_Plan_prix_Index__c' => 34251,
                'HP_Compteur_Plan_Bottom_Price_Index__c' => 78098,
                'HP_Contrat_XdataId__c' => 100149,
                'HP_Souscription_Digital_Id__c' => enrolment.HP_Souscription_Digital_Id__c+'ELEC',
                'HP_Proposition_Commerciale_XdataId__c'=>'775949',
                'HP_Souscription__c'=> enrolment.id,
                'HP_Type_de_Compteur__c' => 'ELEC',
                'HP_Porte_Feuille_Contrat__c' => porteFeuille.Id
            }, null);
            insert cElec;

        Case aCase = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_Facturation',new  Map<String, Object> {'Status' =>  HP_SLCT_Case.Status.NEW_CASE.name(),
			'ContactId' => aContact.Id,
			'HP_Energy__c' => 'Electricity',
            'HP_Type__c' =>'HP_Coupure_ReductionPuissance',
            'Status' => 'NEW_CASE',
            'HP_Client_Aide__c' => true,
            'HP_Souscription__c' => enrolment.Id,
            'HP_Contrat__c' => cElec.Id
			}, null,null,null);
        insert aCase;

        Case aCase2 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_Facturation',new  Map<String, Object> {'Status' =>  HP_SLCT_Case.Status.NEW_CASE.name(),
			'ContactId' => aContact.Id,
			'HP_Energy__c' => 'Gas',
            'HP_Type__c' =>'HP_Coupure_ReductionPuissance',
            'Status' => 'NEW_CASE',
            'HP_Client_Aide__c' => true,
            'HP_Souscription__c' => enrolment.Id,
            'HP_Contrat__c' => cGaz.Id
			}, null,null,null);
        insert aCase2;
    }

   

    @isTest
    public static void testExecuteReduction(){
        Case aCase = [SELECT Id, Status FROM Case WHERE HP_Energy__c = 'Electricity' LIMIT 1];
        aCase.Status = 'HP_PENDING';
        update aCase;
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'oauth2/v1/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_ApigeeAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'ES-PDLElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_ES_PDLElec_MOCK',
                new Map<String, String> {'Content-Type' => 'application/xml'}
            ),
            'ES-PrestationServiceElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_PrestationReductionElecKoMOCK',
                new Map<String, String> {'Content-Type' => 'application/xml'}
            ),
            'personnes/solde_effectif' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_AGILAB_SOLDE_EFFECTIF_Response_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            )
        };
        
        Test.startTest();
        Test.setMock(WebServiceMock.class, new HP_UTIL_ResponseSoapMock());
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_BAT033_CoupureAttente.treveHivernale = '01/'+ String.valueOf(Date.today().addMonths(-3).month()) + '-28/' + String.valueOf(Date.today().addMonths(1).month());
        HP_BAT033_CoupureAttente.execute();
        Test.stopTest();
        Case updatedCase = [SELECT Id, Status FROM Case LIMIT 1];
        System.assert(updatedCase.Status != 'HP_PENDING', 'Batch exécuté OK');
    }

    @isTest
    public static void testMethodsUnTested(){
        Case aCase = [SELECT Id, Status, HP_PDL_PCE__c FROM Case WHERE HP_Energy__c = 'Electricity' LIMIT 1];
        aCase.Status = 'HP_PENDING';
        update aCase;
        Contact con = [SELECT Id FROM Contact LIMIT 1];
        HP_Contrat__c aContrat = [SELECT Id, HP_Type_de_Compteur__c, HP_Id_Compteur__c FROM HP_Contrat__c WHERE HP_Type_de_Compteur__c  = 'ELEC' LIMIT 1];
        Test.startTest();
        Case newCase = HP_BAT033_CoupureAttente.createPrestationCase(aCase);
        HP_BAT033_CoupureAttente.closeCase(aCase, newCase, 'ReducElec');
        HP_BAT033_CoupureAttente.closeCase(aCase, null, 'CoupureElec');
        HP_BAT033_CoupureAttente.setCaseToDo(aCase, 'ReducElec', 'errorMessage');
        HP_BAT033_CoupureAttente.setCaseToDo(aCase, 'CoupureElec', 'errorMessage');
        HP_BAT033_CoupureAttente.setCaseToDo(aCase, 'CoupureGaz', 'errorMessage');
        Prestation_distributeur__c presta = HP_BAT033_CoupureAttente.createPrestation(aCase, con, aContrat, 'A05Z6J3Y', 'COUPURE');
        Test.stopTest();
        List<Case> updatedCaseList = [SELECT Id, Status FROM Case ];
        System.assert(updatedCaseList.size()>1);
    }

    @isTest
    public static void testExecuteGas(){
        Case aCase = [SELECT Id, Status FROM Case WHERE HP_Energy__c = 'Gas' LIMIT 1];
        aCase.Status = 'HP_PENDING';
        update aCase;
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'oauth2/v1/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_ApigeeAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'ES-PDLElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_ES_PDLElec_MOCK',
                new Map<String, String> {'Content-Type' => 'application/xml'}
            ),
            'ES-PrestationServiceElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_PrestationReductionElecKoMOCK',
                new Map<String, String> {'Content-Type' => 'application/xml'}
            ),
            'personnes/solde_effectif' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_AGILAB_SOLDE_EFFECTIF_Response_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            )
        };
        
        Test.startTest();
        Test.setMock(WebServiceMock.class, new HP_UTIL_ResponseSoapMock());
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_BAT033_CoupureAttente.treveHivernale = '01/'+ String.valueOf(Date.today().addMonths(-3).month()) + '-28/' + String.valueOf(Date.today().addMonths(1).month());
        HP_BAT033_CoupureAttente.execute();
        Test.stopTest();
        Case updatedCase = [SELECT Id, Status FROM Case LIMIT 1];
        System.assert(updatedCase.Status != 'HP_PENDING', 'Batch exécuté OK');
    }

    

    @isTest
    public static void testExecuteCoupureElec(){
        Case aCase = [SELECT Id, Status FROM Case WHERE HP_Energy__c = 'Electricity' LIMIT 1];
        aCase.Status = 'HP_PENDING';
        update aCase;
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'oauth2/v1/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_ApigeeAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'ES-PDLElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_ES_PDLElec_MOCK',
                new Map<String, String> {'Content-Type' => 'application/xml'}
            ),
            'ES-PrestationServiceElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_PrestationReductionElecKoMOCK',
                new Map<String, String> {'Content-Type' => 'application/xml'}
            ),
            'personnes/solde_effectif' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_AGILAB_SOLDE_EFFECTIF_Response_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            )
        };
        
        Test.startTest();
        Test.setMock(WebServiceMock.class, new HP_UTIL_ResponseSoapMock());
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_BAT033_CoupureAttente.treveHivernale = '01/'+ String.valueOf(Date.today().addMonths(-3).month()) + '-28/' + String.valueOf(Date.today().addMonths(-1).month());
        HP_BAT033_CoupureAttente.execute();
        Test.stopTest();
        Case updatedCase = [SELECT Id, Status FROM Case LIMIT 1];
        System.assert(updatedCase.Status != 'HP_PENDING', 'Batch exécuté OK');
    }

    @isTest
    public static void testExecuteCoupureGas(){
        Case aCase = [SELECT Id, Status FROM Case WHERE HP_Energy__c = 'Gas' LIMIT 1];
        aCase.Status = 'HP_PENDING';
        update aCase;
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'oauth2/v1/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_ApigeeAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'ES-PDLElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_ES_PDLElec_MOCK',
                new Map<String, String> {'Content-Type' => 'application/xml'}
            ),
            'ES-PrestationServiceElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_PrestationReductionElecKoMOCK',
                new Map<String, String> {'Content-Type' => 'application/xml'}
            ),
            'personnes/solde_effectif' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_AGILAB_SOLDE_EFFECTIF_Response_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            )
        };
        
        Test.startTest();
        Test.setMock(WebServiceMock.class, new HP_UTIL_ResponseSoapMock());
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_BAT033_CoupureAttente.treveHivernale = '01/'+ String.valueOf(Date.today().addMonths(-3).month()) + '-28/' + String.valueOf(Date.today().addMonths(-1).month());
        HP_BAT033_CoupureAttente.execute();
        Test.stopTest();
        Case updatedCase = [SELECT Id, Status FROM Case LIMIT 1];
        System.assert(updatedCase.Status != 'HP_PENDING', 'Batch exécuté OK');
    }

    @isTest 
    public static void testSchedule(){
        Test.startTest();
        final String jobName = 'HP_BAT033_CoupureAttente'+System.Math.random()*1000;
        final String cronExp = '0 0 11 ? * * *';
        HP_BAT033_CoupureAttente.launchNewScheduler(cronExp,jobName);
        Test.stopTest();
    }

}