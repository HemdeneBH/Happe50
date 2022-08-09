/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   12-11-2020   Antoine Latour   Initial Version
**/
@IsTest
public class HP_SM040_CaseHandler_TEST {
@testSetup static void dataSetup(){
        Account acc = (Account)HP_UTIL_SmartFactory.createSObject('Account','HP_Account' ,new Map<String, Object>{
            'HP_XDataExternalId__c' => 100166,
            'Name' => 'UnitTest',
            'OwnerId' => UserInfo.getUserId()
        },null,null, null);
        insert acc;
        
            Contact acontact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{
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
            insert acontact;

        HP_Souscription__c enrolment = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
                'HP_Canal_de_vente__c'  => 'Vente Online',
                'HP_Contact__c'=> acontact.Id,
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
            
    
    
            HP_Contrat__c cgaz =(HP_Contrat__c) HP_UTIL_SmartFactory.createSObject('HP_Contrat__c', 
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
            insert cgaz;
    
            HP_Contrat__c celec =(HP_Contrat__c) HP_UTIL_SmartFactory.createSObject('HP_Contrat__c', 
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
            insert celec;
    }
    
    @isTest 
    public static void testCaseHandler() {
        Contact cont = [select Id from Contact limit 1]; 
        Case acase = (Case) HP_UTIL_SmartFactory.createSObject('Case',new  Map<String, Object> {'Status' =>  HP_SLCT_Case.Status.NEW_CASE.name(),
			'ContactId' => cont.Id,
			'HP_Energy__c' => 'Electricity',
            'HP_Type__c' => 'HP_Souscription',
            'HP_Sous_type__c' => 'Déménagement',
			'RecordTypeId'  => HP_UTIL_RecordType.getRecordTypeId('Case','HP_Telephone')
			}, null
			);
         HP_Souscription__c sous = [select Id from HP_Souscription__c limit 1]; 
         Case acase1 = (Case) HP_UTIL_SmartFactory.createSObject('Case',new  Map<String, Object> {'Status' =>  HP_SLCT_Case.Status.NEW_CASE.name(),
			'ContactId' => cont.Id,
			'HP_Energy__c' => 'Electricity',
            'HP_Type__c' => 'HP_Souscription',
            'HP_Sous_type__c' => 'Déménagement',
			'RecordTypeId'  => HP_UTIL_RecordType.getRecordTypeId('Case','HP_PrestationDistributeur'),
             'HP_Souscription__c' => sous.id
			}, null
			);


        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_APIHourAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'reclamation' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                null, '',
                new Map<String, String> {'Content-Type' => 'application/json'}
            )
        };

        // start the tests
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        insert acase;
        
        acase.Status = 'CLOSED';
        update acase;
        insert acase1;
        
        Id queueId = HP_Util_QueueManager.getQueueIdByName('HP_Niveau_1');
        acase1.OwnerId = queueId;
        update acase;
        acase1.OwnerId = UserInfo.getUserId();
        update acase;
        Test.stopTest();
    }
   
    @isTest 
    public static void testCaseHandler1() {
       
        Case c1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_Mail', new Map<String, Object> {
            'Status' => 'NEW_CASE',
            'Priority' => 'High',
            'OwnerId' => UserInfo.getUserId()
            }, null,null,null);
            insert c1;

            HP_CaseHistory__c caseHistory = (HP_CaseHistory__c) HP_UTIL_SmartFactory.createSObject('HP_CaseHistory__c', new Map<String, Object> {
                'Case__c'  => c1.Id,
                'HP_dateAttribution__c'=> DateTime.newInstance(2020, 10, 01, 13, 0, 0) ,
                'HP_type__c' =>'DMT',
                'user__c' => UserInfo.getUserId()}, null);
            insert caseHistory;

            c1.Status = 'TO_DO';
            update c1;
    }
   
    @isTest
    public static void insertCaseChat() {
        Case c1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_Chat', new Map<String, Object> {
            'Status' => 'NEW_CASE',
            'Priority' => 'High',
            'OwnerId' => UserInfo.getUserId()
            }, null,null,null);

        Test.startTest();
        insert c1;
        Test.stopTest();

        Case resultCase = [SELECT Status, Priority, Origin, Reason FROM Case WHERE Id = : c1.Id];

        System.assert(resultCase.Priority == 'Medium', 'Bad Priority');
        System.assert(resultCase.Status == 'TO_DO', 'Bad Status');
        System.assert(resultCase.Origin == 'Chat', 'Bad Origin');
        System.assert(resultCase.Reason == 'Demande Client', 'Bad Reason');
    }

    @isTest
    public static void escalade() {
        Case c1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_Chat', new Map<String, Object> {
            'Status' => 'NEW_CASE',
            'Priority' => 'High',
            'OwnerId' => UserInfo.getUserId()
            }, null,null,null);

        Test.startTest();
        insert c1;
        c1.HP_QueueCible__c = 'Niveau 3';
        update c1;
        Test.stopTest();

        Case resultCase = [SELECT Status, Priority, Origin, Reason FROM Case WHERE Id = : c1.Id];

        System.assert(resultCase.Status == 'Escaladé (happe)', 'Bad Status');
    }


    @isTest
    public static void checkDuplication() {
        Contact caseContact = [SELECT Id FROM Contact LIMIT 1];
        Case c1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_Mail', new Map<String, Object> {
            'Status' => 'NEW_CASE',
            'Priority' => 'High',
            'Subject' => 'Test Dup 1',
            'Description' => 'Test Dup 1 Descr',
            'ContactId' => caseContact.Id
            }, null,null,null);
        insert c1;

        Case c2 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_Mail', new Map<String, Object> {
            'Status' => 'NEW_CASE',
            'Priority' => 'Medium',
            'Subject' => 'Test Dup 1',
            'Description' => 'Test Dup 1 Descr',
            'ContactId' => caseContact.Id
            }, null,null,null);
        Test.startTest();
        insert c2;
        Test.stopTest();

        Case resultCase = [SELECT Status, HP_Comment__c FROM Case WHERE Id = : c2.Id];
        System.assert(resultCase.Status == 'CANCELED', 'Bad Status');
        System.assert(resultCase.HP_Comment__c == 'Annulé pour cause de duplication avec la requête : ' + c1.Id, 'Bad Comment');
    }



    @isTest
    public static void updateStatusCaseQueue() {
        Case c1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_Mail', new Map<String, Object> {
            'Status' => 'CANCELED',
            'Priority' => 'High',
            'Subject' => 'Test Update Status',
            'OwnerId' => UserInfo.getUserId()
            }, null,null,null);
        insert c1;

        Case c2 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_Mail', new Map<String, Object> {
            'Status' => 'CANCELED',
            'Priority' => 'Medium',
            'Subject' => 'Test Update Status 2',
            'OwnerId' => UserInfo.getUserId()
            }, null,null,null);
        Test.startTest();
        insert c2;
        Test.stopTest();
    }
    
    @isTest 
    public static void testProcessCoupureReductionClientAide() {
        Contact cont = [select Id, ID_Tiers__c from Contact limit 1]; 
        HP_Souscription__c sous = [select Id from HP_Souscription__c limit 1]; 
        HP_Contrat__c aContrat = [SELECT Id FROM HP_Contrat__c WHERE HP_Type_de_Compteur__c = 'ELEC' LIMIT 1];
        Case aCase = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_Facturation',new  Map<String, Object> {'Status' =>  HP_SLCT_Case.Status.NEW_CASE.name(),
			'ContactId' => cont.Id,
			'HP_Energy__c' => 'Electricity',
            'HP_Type__c' =>'HP_Coupure_ReductionPuissance',
            'Status' => 'NEW_CASE',
            'HP_Client_Aide__c' => true,
            'HP_Souscription__c' => sous.Id,
            'HP_Contrat__c' => aContrat.Id
			}, null,null,null);
         
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    'HP_ApigeeAccessTokenResponse_MOCK',
                    new Map<String, String> {'Content-Type' => 'application/json'}
                ),
                'protected-agilab/oauth2s/access_token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    'HP_Agilab_Token_MOCK',
                    new Map<String, String> {'Content-Type' => 'application/json'}
                ),
                'elec-points-de-livraison' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    'HP_XDATA_ELEC_PDL_Response_MOCK',
                    new Map<String, String> {'Content-Type' => 'application/json'}
                ),
                'contrats?idPointDeLivraison' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    'HP_XDATA_CONTRATS_Response_MOCK',
                    new Map<String, String> {'Content-Type' => 'application/json'}
                )
            };
            
            // start the tests
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        insert aCase;
        Test.stopTest();
        Case aCas = [Select Id, Status, Description from Case limit 1];
    }

    @isTest 
    public static void testProcessCoupureReductionHasDGPContracts() {
        Contact cont = [select Id, ID_Tiers__c from Contact limit 1]; 
        HP_Souscription__c sous = [select Id from HP_Souscription__c limit 1]; 
        HP_Contrat__c aContrat = [SELECT Id FROM HP_Contrat__c WHERE HP_Type_de_Compteur__c = 'ELEC' LIMIT 1];
        Case aCase = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_Facturation',new  Map<String, Object> {'Status' =>  HP_SLCT_Case.Status.NEW_CASE.name(),
			'ContactId' => cont.Id,
			'HP_Energy__c' => 'Electricity',
            'HP_Type__c' =>'HP_Coupure_ReductionPuissance',
            'Status' => 'NEW_CASE',
            'HP_Client_Aide__c' => false,
            'HP_Souscription__c' => sous.Id,
            'HP_Contrat__c' => aContrat.Id,
            'HP_PDL_PCE__c' => '25461794460830'
			}, null,null,null);

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'oauth2/v1/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_ApigeeAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'elec-points-de-livraison' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_XDATA_ELEC_PDL_Response_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'contrats?idPointDeLivraison' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_XDATA_CONTRATS_Response_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            )
        };
        
        // start the tests
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        insert aCase;
        Test.stopTest();
        Case aCas = [Select Id, Status,HP_Sous_type__c from Case limit 1];
        // System.assertEquals(true, aCas.Status== 'TO_DO', 'Cas Elec en periode de trève avec un contrat DGP actif');
        // System.assertEquals(true, aCas.HP_Sous_type__c== 'Suspicion Inversion de PDL', 'Cas Elec en periode de trève avec un contrat DGP actif');
    }

    @isTest 
    public static void testProcessCoupureReductionHasApurement() {
        Contact cont = [select Id, ID_Tiers__c from Contact limit 1]; 
        HP_Souscription__c sous = [select Id from HP_Souscription__c limit 1]; 
        HP_Contrat__c aContrat = [SELECT Id FROM HP_Contrat__c WHERE HP_Type_de_Compteur__c = 'ELEC' LIMIT 1];
        Case aCase = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_Facturation',new  Map<String, Object> {'Status' =>  HP_SLCT_Case.Status.NEW_CASE.name(),
			'ContactId' => cont.Id,
			'HP_Energy__c' => 'Electricity',
            'HP_Type__c' =>'HP_Coupure_ReductionPuissance',
            'Status' => 'NEW_CASE',
            'HP_Client_Aide__c' => false,
            'HP_Souscription__c' => sous.Id,
            'HP_Contrat__c' => aContrat.Id,
            'HP_PDL_PCE__c' => '25461794460830'
			}, null,null,null);

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_ApigeeAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'protected-agilab/oauth2s/access_token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_Agilab_Token_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'elec-points-de-livraison' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_XDATA_ELEC_PDL_Response_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'contrats?idPointDeLivraison' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_XDATA_CONTRATS_KO_Response_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'portefeuille_contrats/voir_plans_apurement' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_AGILAB_VOIR_PLANS_APUREMENT_Response_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            )
        };
        
        // start the tests
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        insert aCase;
        Test.stopTest();
        Case aCas = [Select Id, Status,Description from Case limit 1];
        System.assertEquals(true, aCas.Status== 'CANCELED', 'Cas Elec en periode de trève avec un plan apurement en cours');
        System.assertEquals(true, aCas.Description.contains('- Annulé car plan d’apurement'), 'Cas Elec en periode de trève avec un plan apurement en cours');
    }

    @isTest 
    public static void testProcessCoupureReductionHasBlocage() {
        Contact cont = [select Id, ID_Tiers__c from Contact limit 1]; 
        HP_Souscription__c sous = [select Id from HP_Souscription__c limit 1]; 
        HP_Contrat__c aContrat = [SELECT Id FROM HP_Contrat__c WHERE HP_Type_de_Compteur__c = 'ELEC' LIMIT 1];
        Case aCase = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_Facturation',new  Map<String, Object> {'Status' =>  HP_SLCT_Case.Status.NEW_CASE.name(),
			'ContactId' => cont.Id,
			'HP_Energy__c' => 'Electricity',
            'HP_Type__c' =>'HP_Coupure_ReductionPuissance',
            'Status' => 'NEW_CASE',
            'HP_Client_Aide__c' => false,
            'HP_Souscription__c' => sous.Id,
            'HP_Contrat__c' => aContrat.Id,
            'HP_PDL_PCE__c' => '25461794460830'
			}, null,null,null);

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_ApigeeAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'protected-agilab/oauth2s/access_token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_Agilab_Token_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'elec-points-de-livraison' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_XDATA_ELEC_PDL_Response_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'contrats?idPointDeLivraison' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_XDATA_CONTRATS_KO_Response_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'portefeuille_contrats/voir_plans_apurement' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_AGILAB_VOIR_PLANS_APUREMENT_KO_Response_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            )
            ,
            'aides/afficher_informations_aide' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_AGILAB_AFFICHIER_INFORMATION_AIDE_Response_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            )
        };
        
        // start the tests   
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        insert aCase;
        Test.stopTest();
        Case aCas = [Select Id, Status,Description from Case limit 1];
        System.assertEquals(true, aCas.Status== 'DELAYED_PROCESS', 'Cas Elec en periode de trève avec blocage');
        System.assertEquals(true, aCas.Description.contains('Différé car blocage à la relance en cours sur le client'), 'Cas Elec en periode de trève avec avec blocage');
    }

    @isTest 
    public static void testProcessCoupureReductionHasSoldeInf() {
        Contact cont = [select Id, ID_Tiers__c from Contact limit 1]; 
        HP_Souscription__c sous = [select Id from HP_Souscription__c limit 1]; 
        HP_Contrat__c aContrat = [SELECT Id FROM HP_Contrat__c WHERE HP_Type_de_Compteur__c = 'ELEC' LIMIT 1];
        Case aCase = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_Facturation',new  Map<String, Object> {'Status' =>  HP_SLCT_Case.Status.NEW_CASE.name(),
			'ContactId' => cont.Id,
			'HP_Energy__c' => 'Electricity',
            'HP_Type__c' =>'HP_Coupure_ReductionPuissance',
            'Status' => 'NEW_CASE',
            'HP_Client_Aide__c' => false,
            'HP_Souscription__c' => sous.Id,
            'HP_Contrat__c' => aContrat.Id,
            'HP_PDL_PCE__c' => '25461794460830'
			}, null,null,null);

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_ApigeeAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'protected-agilab/oauth2s/access_token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_Agilab_Token_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'elec-points-de-livraison' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_XDATA_ELEC_PDL_Response_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'contrats?idPointDeLivraison' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_XDATA_CONTRATS_KO_Response_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'portefeuille_contrats/voir_plans_apurement' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_AGILAB_VOIR_PLANS_APUREMENT_KO_Response_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'aides/afficher_informations_aide' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_AGILAB_AFFICHIER_INFORMATION_AIDE_KO_Response_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'personnes/solde_effectif' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_AGILAB_SOLDE_EFFECTIF_Response_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            )
        };
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        insert aCase;
        Test.stopTest();
        Case aCas = [Select Id, Status,Description from Case limit 1];
        System.assertEquals(true, aCas.Status== 'CANCELED', 'Cas Elec avec un solde inférieur à 100€');
        System.assertEquals(true, aCas.Description.contains('Annulé car dette du client inférieure à 100€ strictement'), 'Cas Elec avec un solde inférieur à 100€');
    }

    @isTest 
    public static void testProcessCoupureReductionHasSoldeSuperieur() {
        Contact cont = [select Id, ID_Tiers__c from Contact limit 1]; 
        HP_Souscription__c sous = [select Id from HP_Souscription__c limit 1]; 
        HP_Contrat__c aContrat = [SELECT Id FROM HP_Contrat__c WHERE HP_Type_de_Compteur__c = 'ELEC' LIMIT 1];
        Case aCase = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_Facturation',new  Map<String, Object> {'Status' =>  HP_SLCT_Case.Status.NEW_CASE.name(),
			'ContactId' => cont.Id,
			'HP_Energy__c' => 'Electricity',
            'HP_Type__c' =>'HP_Coupure_ReductionPuissance',
            'Status' => 'NEW_CASE',
            'HP_Client_Aide__c' => false,
            'HP_Souscription__c' => sous.Id,
            'HP_Contrat__c' => aContrat.Id,
            'HP_PDL_PCE__c' => '25461794460830'
			}, null,null,null);

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_ApigeeAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'protected-agilab/oauth2s/access_token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_Agilab_Token_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'elec-points-de-livraison' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_XDATA_ELEC_PDL_Response_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'contrats?idPointDeLivraison' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_XDATA_CONTRATS_KO_Response_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'portefeuille_contrats/voir_plans_apurement' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_AGILAB_VOIR_PLANS_APUREMENT_KO_Response_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'aides/afficher_informations_aide' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_AGILAB_AFFICHIER_INFORMATION_AIDE_KO_Response_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'personnes/solde_effectif' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_AGILAB_SOLDE_EFFECTIF_KO_Response_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            )
        };
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        insert aCase;
        Test.stopTest();
        Case aCas = [Select Id, Status,Description from Case limit 1];
        System.assertEquals(true, aCas.Status== 'TO_DO', 'Cas Elec avec un solde supérieur à 100€');
    }
}