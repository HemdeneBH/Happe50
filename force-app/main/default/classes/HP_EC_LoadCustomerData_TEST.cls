/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 06-28-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
@isTest
private class HP_EC_LoadCustomerData_TEST {

    private enum StaticResource {
        HP_PrestaElecMock,
        HP_ES_PDLElec_v3_Mock
    }

    @TestSetup
    static void setup(){

        Account ac = new Account(name = 'HP Portal Account');
        insert ac;

        Contact con = new Contact(LastName = 'Portal Account', AccountId = ac.Id, ID_Tiers__c = 100166);
        insert con;
       
    }

    @isTest
    static void getAllPortalData(){
            Id p = [SELECT id FROM profile where name = 'HP_Community_User'].id;
            Contact con = [SELECT id FROM Contact WHERE lastname = 'Portal Account' LIMIT 1];
            User portalUser = new User(alias = 'hpPortal', email = 'portaluser@noemail.com', EmailEncodingKey = 'UTF-8', lastname = 'Portal', 
            LanguageLocaleKey = 'en_US', LocaleSidKey ='en_US', ProfileId = p, country = 'United States', IsActive = true, contactId = con.Id, TimeZoneSidKey = 'Europe/Paris', UserName = 'portaluser@noemail.com');
            insert portalUser;
            Id pset = [SELECT id FROM PermissionSet where name = 'HP_EC_permissions' LIMIT 1].id;
            PermissionSetAssignment psa =  new PermissionSetAssignment(PermissionSetId = pset, AssigneeId = portalUser.id);
            insert psa;

            system.runAs(portalUser) {

                Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                    'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                        200,
                        'HP_APIHourAccessTokenResponse_MOCK',
                        new Map<String, String> {'Content-Type' => 'application/json'}
                    ),

                    'apiset/0.2/contrats?idPersonne' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    'HP_CONTRAT_XDATA_BY_PERSONNE_MOCK',
                    new Map<String, String> {'Content-Type' => 'application/json'}
                    ),
                
      
                    'apiset/0.3/portefeuilles-contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    null, '{"idPortefeuilleContrat":"123"}',
                    new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'}),

                    '/api/happe/1.0/locaux-contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    null, '{"idPortefeuilleContrat":"123"}',
                    new Map<String, String> {'Content-Type' => 'application/json'}),

                    '/api/v1/personnes/solde_effectif' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    null, '{"key":"SoldeEffectif","status":"SUCCESS"}',
                    new Map<String, String> {'Content-Type' => 'application/json'}),


                    '/api/v1/portefeuille_contrats/factures' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    null, '{"key":"FactureAgilab","status":"SUCCESS"}',
                    new Map<String, String> {'Content-Type' => 'application/json'}),

                    '/api/v1/propositions/afficher_echeances_contrat' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    null, '{"key":"EcheanceContract","status":"SUCCESS"}',
                    new Map<String, String> {'Content-Type' => 'application/json'}),

                    '/api/v1/propositions/afficher_informations_contrat' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    null, '{"key":"InfoContract","status":"SUCCESS"}',
                    new Map<String, String> {'Content-Type' => 'application/json'}),
                    'propositions/get_options' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_ResponseHPSM006FactureManagermodifiermodedenvoiFactures',
                new Map<String, String> {'Content-Type' => 'application/json'}),
                'grille_pricings/getGrille' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_SM001_Agilab_GetGrilleTarifaire_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}),
                'propositions/afficher_informations_contrat' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_SM001_Agilab_GetContratInfo_MOCK',
                    new Map<String, String> {'Content-Type' => 'application/json'}),
                    'api/v1/personnes/afficher_consommation' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                    'HP_HisotiqueConsommationELEC_OK',
                    new Map<String, String> { 'Content-Type' => 'application/json'}
                    ),
                    'elec-points-de-livraison' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                    null,'{"numeroPointDeLivraison":"1231546"}',
                    new Map<String, String> {'Location' => 'http/123456', 'Content-Type' => 'application/json'}),
            'gaz-points-de-livraison' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                    null,'{"numeroPointDeLivraison":"9789232"}',
                    new Map<String, String> {'Location' => 'http/987654', 'Content-Type' => 'application/json'}),
                    
                'consentements' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												  'HP_SM008_APIHour_ReponsesConsentement',
												  new Map<String, String> { 'Content-Type' => 'application/json'}),
                'questions-consentement' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												  'HP_SM008_APIHour_QuestionsConsentement',
												  new Map<String, String> { 'Content-Type' => 'application/json'}),
                'personnes' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                  Null,
                                                  new Map<String, String> { 'Content-Type' => 'application/json',
                                                  'Location' => ' https://qa-rec-dmzint-gtw.api.engie.fr:8500/api/happe/0.1/personnes/220647'
                                                  }),
              'consentement' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                  Null,
                                                    new Map<String, String>()),
                'coordonnees-bancaires' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                null, '{"_data":[]}',
                                                  new Map<String, String>()),
                'propositions/modifier' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                                                  'HP_ResponseHPSM006FactureManagermodifiermodedenvoiFactures',
                                                  new Map<String, String> {'Content-Type' => 'application/json'}),
                'v2/rest/tranquillity/Contracts/getContrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
																  'HP_SM003_Tranquility_Contrat_TEST',
																  new Map<String, String> { 'Content-Type' => 'application/json'}),
                'propositions/maj_de_mensualite?' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
							'HP_AGILAB_MAJ_MENSUALITE_MOCK',
							new Map<String, String> { 'Content-Type' => 'application/json'}),
                'propositions/modifier?' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
							'HP_AGILAB_PROPOSITION_MODIFIER_DRP_MOCK',
                                                    new Map<String, String> {'Content-Type' => 'application/json'}),
                                                    '/api/v1/propositions/paiements' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                                                    null, '{"key":"paiement","status":"SUCCESS"}',
                                                    new Map<String, String> {'Content-Type' => 'application/json'}),
                                
                '/api/v1/portefeuille_contrats/voir_plans_apurement' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                                                    null, '{"key":"plans Apurement","status":"SUCCESS"}',
																  new Map<String, String> { 'Content-Type' => 'application/json'}),

                'propositions/afficher_auto_releve' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                            'HP_SM001_Agilab_GetAutoReleve_MOCK',
                            new Map<String, String> {'Content-Type' => 'application/json'}),
                'propositions/envoi_indexes' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
                            'HP_SM001_Agilab_EnvoiIndexBase_MOCK',
							new Map<String, String> { 'Content-Type' => 'application/json'}),
                'personnes/show' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_SM001_Agilab_GetPersonne_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}),

                'ES-PDLElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 'HP_ES_PDLElec_v3_Mock',
                            new Map<String, String> {'Content-Type' => 'application/xml'}),
                'ES-PrestationServiceElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 'HP_PrestaElecMock',
                            new Map<String, String> {'Content-Type' => 'application/xml'}),
                
                'protected-dqe' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 'HP_SM0017_DQE_Email_MOCK',
                                                    new Map<String, String> { 'Content-Type' => 'APPLICATION/JSON'}),
                'protected-dqe' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
																  'HP_SM0017_DQE_Telephone_MOCK',
																  new Map<String, String> { 'Content-Type' => 'APPLICATION/JSON'}),
                                                                  
                'V2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                null,'{"24": {"Instance": "", "CodePostal": "75116", "Localite": "PARIS", "CodeVoie": "1456950", "NbNumero": 1, "Complement": "", "Voie": "BOULEVARD FLANDRIN", "Numero": "12", "label": "12 BOULEVARD FLANDRIN|75116 PARIS", "ListeNumero": "12", "Nbnumero": 1, "LieuDit": "", "TypeVoie": "", "SousLocalite": "*", "valid_num": 1, "IDLocalite": "75116", "Pays": "FRA", "IDVoie": "1456950", "Saisie": "12 boulevar", "Num": "12", "Entreprise": "", "NumSeul": "12"}}',
                new Map<String, String> { 'Content-Type' => 'application/json'}),
                
                'V2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                      null,'{"1" : {"Batiment":"BATIMENTA"},"3" :{"Batiment":"BATIMENT C"},"iris":"5101"}',
                                                      new Map<String, String> { 'Content-Type' => 'application/json'}),

                '/v1/orders' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                                                        200,'HP_Sharegroop_CreateOrder_MOCK',
                                                      new Map<String, String> { 'Content-Type' => 'application/json'})
                    
                };

                Map<String, Object> client = new Map<String, Object>{'civilite'=>'MR', 'nom'=>'MR', 'prenom'=>'MR', 'numeroFixe'=>'06555', 'numeroMobile'=>'01111', 'email'=>'portaluser@noemail.com'
            , 'prospect'=>false, 'client'=>true, 'numVoie'=>'14', 'voie'=>'MR', 'complementAdresse'=>'MR', 'codePostal'=>'92000', 'ville'=>'MR', 'pays'=>'FR','stopEmail'=>false, 'stopSms'=>false,'optinMarketing'=>false};
            List<Map<String, Object>> concentementList = new  List<Map<String, Object>>();
            concentementList.add(new Map<String, Object>());
            
            

                Test.startTest();
                Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
                String status = HP_EC_LoadCustomerData.init();
                System.assertEquals('Initiated', status, 'Error while loading the data controller');
                //2nd call to call cached data
                HP_EC_LoadCustomerData.getContactData();
                HP_EC_LoadCustomerData.getContractData();
                HP_EC_LoadCustomerData.getContractPortfolioData();
                HP_EC_LoadCustomerData.getSoldeEffectifData();
                HP_EC_LoadCustomerData.getCoordonneesBancaires();
                HP_EC_LoadCustomerData.getContractsAddresses();

                // Methodes with parameters : 1st call
                HP_EC_LoadCustomerData.getPorteFeuilleContratXdata('123');
                HP_EC_LoadCustomerData.getFactureAgilabData('123');
                HP_EC_LoadCustomerData.getEcheanceContractData('111');
                HP_EC_LoadCustomerData.getInfoContractData('111');
                HP_EC_LoadCustomerData.loadEnergieVerOption('123');
                HP_EC_LoadCustomerData.getPlansApurement(1111);
                HP_EC_LoadCustomerData.getPaiement(1111);
                HP_EC_LoadCustomerData.getGrilleTarifaire('123', '21-01-2020');
                HP_EC_LoadCustomerData.getContratInfo('123');
                HP_EC_LoadCustomerData.getConsoElec(987303297,'123456789');
                HP_EC_LoadCustomerData.getConsoGaz(987303298,'123456788');
                HP_EC_LoadCustomerData.getAutoReleveData(972732173);
                HP_EC_LoadCustomerData.getEmailValidation('testmail@hotmail.com');
                HP_EC_LoadCustomerData.getTelephoneValidation('0613035600','FRA');
                HP_EC_LoadCustomerData.getSuggestionsDQE('46+boulevard+de+la+libération+67500+Haguenau');
                HP_EC_LoadCustomerData.getComplementsDQE('8+rue+de+l+universite+26500+BOURG+LES+VALENCE');
                HP_EC_LoadCustomerData.createOrderPaiementAPlusieurs('FACT379527', '838.91', 'jdd.espace.test@yopmail.com', 'JDD', 'Espace CLient');
                // Methodes with parameters : 2nd call to call cached data
                HP_EC_LoadCustomerData.getPorteFeuilleContratXdata('123');
                HP_EC_LoadCustomerData.getFactureAgilabData('123');
                HP_EC_LoadCustomerData.getEcheanceContractData('111');
                HP_EC_LoadCustomerData.getInfoContractData('111');
                HP_EC_LoadCustomerData.loadEnergieVerOption('123');
                HP_EC_LoadCustomerData.getPlansApurement(1111);
                HP_EC_LoadCustomerData.getPaiement(1111);
                HP_EC_LoadCustomerData.getGrilleTarifaire('123', '21-01-2020');
                HP_EC_LoadCustomerData.getContratInfo('123');
                HP_EC_LoadCustomerData.getConsoElec(987303297,'123456789');
                HP_EC_LoadCustomerData.getConsoGaz(987303298,'123456788');
                HP_EC_LoadCustomerData.getAutoReleveData(972732173);
                HP_EC_LoadCustomerData.getTelephoneValidation('0613035600','FRA');
                HP_EC_LoadCustomerData.getQuestionsConsentement();
                HP_EC_LoadCustomerData.getReponsesConsentement(123);
                try{
                    HP_EC_LoadCustomerData.getContractTranquility('1111');
                }catch(Exception ex){
                    System.debug(ex.getMessage());
                }
                
                try{
                    HP_EC_LoadCustomerData.agilabEnvoiIndexBase(972732173,1,1600);
                }catch(Exception ex){
                    System.debug(ex.getMessage());
                }
                try{
                    HP_EC_LoadCustomerData.agilabEnvoiIndexHPHC(972732173,1,720,940);
                }catch(Exception ex){
                    System.debug(ex.getMessage());
                }
                try{
                    HP_EC_LoadCustomerData.isCompteurCommunicantElec('31431211214170', 34251);
                }catch(Exception ex){
                    System.debug(ex.getMessage());
                }
                try{
                    HP_EC_LoadCustomerData.isCompteurCommunicantGaz('31431211214170', 34251);
                }catch(Exception ex){
                    System.debug(ex.getMessage());
                }
                
                System.assertEquals('Initiated', status, 'Error while loading the cached data');
                Test.stopTest();
        }
    }

    @isTest
    static void getAllPortalData_NULLDATA(){
            Id p = [SELECT id FROM profile where name = 'HP_Community_User'].id;
            Contact con = [SELECT id FROM Contact WHERE lastname = 'Portal Account' LIMIT 1];
            User portalUser = new User(alias = 'hpPortal', email = 'portaluser@noemail.com', EmailEncodingKey = 'UTF-8', lastname = 'Portal', 
            LanguageLocaleKey = 'en_US', LocaleSidKey ='en_US', ProfileId = p, country = 'United States', IsActive = true, contactId = con.Id, TimeZoneSidKey = 'Europe/Paris', UserName = 'portaluser@noemail.com');
            insert portalUser;
            Id pset = [SELECT id FROM PermissionSet where name = 'HP_EC_permissions' LIMIT 1].id;
            PermissionSetAssignment psa =  new PermissionSetAssignment(PermissionSetId = pset, AssigneeId = portalUser.id);
            insert psa;


            //User portalUser = [SELECT id FROM User WHERE username = 'portaluser@noemail.com' LIMIT 1];
            system.runAs(portalUser) {

                Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                    'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                        200,
                        'HP_APIHourAccessTokenResponse_MOCK',
                        new Map<String, String> {'Content-Type' => 'application/json'}
                    ),

                    'apiset/0.2/contrats?idPersonne' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    null,'{"_data": []}',
                    new Map<String, String> {'Content-Type' => 'application/json'}
                    ),
                
      
                    'apiset/0.3/portefeuilles-contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    null, '{"_data": []}',
                    new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'}),

                    '/api/happe/1.0/locaux-contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    null, '{"_data": []}',
                    new Map<String, String> {'Content-Type' => 'application/json'}),

                    '/api/v1/personnes/solde_effectif' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    null, '{"_data": []}',
                    new Map<String, String> {'Content-Type' => 'application/json'}),


                    '/api/v1/portefeuille_contrats/factures' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    null, '{"_data": []}',
                    new Map<String, String> {'Content-Type' => 'application/json'}),

                    '/api/v1/propositions/afficher_echeances_contrat' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    null, '{"_data": []}',
                    new Map<String, String> {'Content-Type' => 'application/json'}),

                    '/api/v1/propositions/afficher_informations_contrat' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    null, '{"_data": []}',
                    new Map<String, String> {'Content-Type' => 'application/json'}),

                    'coordonnees-bancaires' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                    null, '{"_data":[]}',
                                                    new Map<String, String>()),
                    '/api/v1/propositions/paiements' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                                                                                    null, '{"key":"paiement","status":"SUCCESS"}',
                                                                                    new Map<String, String> {'Content-Type' => 'application/json'}),
                                                                
                    '/api/v1/portefeuille_contrats/voir_plans_apurement' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                                                                                    null, '{"key":"plans Apurement","status":"SUCCESS"}',
                                                                                    new Map<String, String> {'Content-Type' => 'application/json'}),
                                                                                    

                    'protected-dqe' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                                                        'HP_SM0017_DQE_Email_MOCK',
                                                                                        new Map<String, String> { 'Content-Type' => 'APPLICATION/JSON'}),
                    'protected-dqe' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                                                        'HP_SM0017_DQE_Telephone_MOCK',
                                                                                        new Map<String, String> { 'Content-Type' => 'APPLICATION/JSON'}),
                                                                
                    'V2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                    null,'{"24": {"Instance": "", "CodePostal": "75116", "Localite": "PARIS", "CodeVoie": "1456950", "NbNumero": 1, "Complement": "", "Voie": "BOULEVARD FLANDRIN", "Numero": "12", "label": "12 BOULEVARD FLANDRIN|75116 PARIS", "ListeNumero": "12", "Nbnumero": 1, "LieuDit": "", "TypeVoie": "", "SousLocalite": "*", "valid_num": 1, "IDLocalite": "75116", "Pays": "FRA", "IDVoie": "1456950", "Saisie": "12 boulevar", "Num": "12", "Entreprise": "", "NumSeul": "12"}}',
                    new Map<String, String> { 'Content-Type' => 'application/json'})
                    
                };

                Test.startTest();
                Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
                String status = HP_EC_LoadCustomerData.init();
                System.assertEquals('Initiated', status, 'Error while loading the data controller');

                // Methodes with parameters : 1st call
                HP_EC_LoadCustomerData.getPorteFeuilleContratXdata('123');
                HP_EC_LoadCustomerData.getFactureAgilabData('123');
                HP_EC_LoadCustomerData.getEcheanceContractData('111');
                HP_EC_LoadCustomerData.getInfoContractData('111');
                HP_EC_LoadCustomerData.getPlansApurement(1111);
                HP_EC_LoadCustomerData.getPaiement(1111);
                HP_EC_LoadCustomerData.getEmailValidation('testmail@hotmail.com');
                HP_EC_LoadCustomerData.getTelephoneValidation('0613035600','FRA');
                HP_EC_LoadCustomerData.getSuggestionsDQE('46+boulevard+de+la+libération+67500+Haguenau');
                HP_EC_LoadCustomerData.getComplementsDQE('8+rue+de+l+universite+26500+BOURG+LES+VALENCE');
                


                System.assertEquals('Initiated', status, 'Error while loading the cached data');
                Test.stopTest();
        }
    }

    @isTest 
    public static void testCache(){
        Id p = [SELECT id FROM profile where name = 'HP_Community_User'].id;
            Contact con = [SELECT id FROM Contact WHERE lastname = 'Portal Account' LIMIT 1];
            User portalUser = new User(alias = 'hpPortal', email = 'portaluser@noemail.com', EmailEncodingKey = 'UTF-8', lastname = 'Portal', 
            LanguageLocaleKey = 'en_US', LocaleSidKey ='en_US', ProfileId = p, country = 'United States', IsActive = true, contactId = con.Id, TimeZoneSidKey = 'Europe/Paris', UserName = 'portaluser@noemail.com');
            insert portalUser;
            Id pset = [SELECT id FROM PermissionSet where name = 'HP_EC_permissions' LIMIT 1].id;
            PermissionSetAssignment psa =  new PermissionSetAssignment(PermissionSetId = pset, AssigneeId = portalUser.id);
            insert psa;

            HP_EC_UTL_CacheManager.putCacheData('InfoContract', '{"_data": []}');
            HP_EC_UTL_CacheManager.putCacheData('EcheanceContract', '{"_data": []}');
            HP_EC_UTL_CacheManager.putCacheData('FactureAgilab', '{"_data": []}');
            HP_EC_UTL_CacheManager.putCacheData('SoldeEffectif', '{"_data": []}');
            HP_EC_UTL_CacheManager.putCacheData('ContractsAddresses', '{"_data": []}');
            HP_EC_UTL_CacheManager.putCacheData('ContractPortfolioData', '{"_data": []}');
            HP_EC_UTL_CacheManager.putCacheData('ContractData', '{"_data": []}');
            HP_EC_UTL_CacheManager.putCacheData('ContactData', '{"_data": []}');
            HP_EC_UTL_CacheManager.putCacheData('EnergieVertOption', '{"_data": []}');
            HP_EC_UTL_CacheManager.putCacheData('getContratInfo', '{"_data": []}');
            HP_EC_UTL_CacheManager.putCacheData('GrilleTarifaire', '{"_data": []}');
            HP_EC_UTL_CacheManager.putCacheData('CoordonneesBancaires', '{"_data": []}');
            //User portalUser = [SELECT id FROM User WHERE username = 'portaluser@noemail.com' LIMIT 1];
            system.runAs(portalUser) {

                Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                    'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                        200,
                        'HP_APIHourAccessTokenResponse_MOCK',
                        new Map<String, String> {'Content-Type' => 'application/json'}
                    ),

                    'apiset/0.2/contrats?idPersonne' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    'HP_CONTRAT_XDATA_BY_PERSONNE_MOCK',
                    new Map<String, String> {'Content-Type' => 'application/json'}
                    ),
                
      
                    'apiset/0.3/portefeuilles-contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    null, '{"idPortefeuilleContrat":"123"}',
                    new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'}),

                    '/api/happe/1.0/locaux-contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    null, '{"idPortefeuilleContrat":"123"}',
                    new Map<String, String> {'Content-Type' => 'application/json'}),

                    '/api/v1/personnes/solde_effectif' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    null, '{"key":"SoldeEffectif","status":"SUCCESS"}',
                    new Map<String, String> {'Content-Type' => 'application/json'}),


                    '/api/v1/portefeuille_contrats/factures' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    null, '{"key":"FactureAgilab","status":"SUCCESS"}',
                    new Map<String, String> {'Content-Type' => 'application/json'}),

                    '/api/v1/propositions/afficher_echeances_contrat' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    null, '{"key":"EcheanceContract","status":"SUCCESS"}',
                    new Map<String, String> {'Content-Type' => 'application/json'}),

                    '/api/v1/propositions/afficher_informations_contrat' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    null, '{"key":"InfoContract","status":"SUCCESS"}',
                    new Map<String, String> {'Content-Type' => 'application/json'}),
                    'propositions/get_options' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_ResponseHPSM006FactureManagermodifiermodedenvoiFactures',
                new Map<String, String> {'Content-Type' => 'application/json'}),
                'grille_pricings/getGrille' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_SM001_Agilab_GetGrilleTarifaire_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}),
                'propositions/afficher_informations_contrat' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_SM001_Agilab_GetContratInfo_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}),

                'coordonnees-bancaires' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                    null, '{"_data":[]}',
                                                    new Map<String, String>()),

                '/api/v1/propositions/paiements' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                                                    null, '{"key":"paiement","status":"SUCCESS"}',
                                                    new Map<String, String> {'Content-Type' => 'application/json'}),
                                
                '/api/v1/portefeuille_contrats/voir_plans_apurement' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                                                    null, '{"key":"plans Apurement","status":"SUCCESS"}',
                                                    new Map<String, String> {'Content-Type' => 'application/json'}),
                                                    
                'protected-dqe' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                                            'HP_SM0017_DQE_Email_MOCK',
                                                                            new Map<String, String> { 'Content-Type' => 'APPLICATION/JSON'}),
                'protected-dqe' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                                            'HP_SM0017_DQE_Telephone_MOCK',
                                                                            new Map<String, String> { 'Content-Type' => 'APPLICATION/JSON'}),
                                                                            
                'V2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                null,'{"24": {"Instance": "", "CodePostal": "75116", "Localite": "PARIS", "CodeVoie": "1456950", "NbNumero": 1, "Complement": "", "Voie": "BOULEVARD FLANDRIN", "Numero": "12", "label": "12 BOULEVARD FLANDRIN|75116 PARIS", "ListeNumero": "12", "Nbnumero": 1, "LieuDit": "", "TypeVoie": "", "SousLocalite": "*", "valid_num": 1, "IDLocalite": "75116", "Pays": "FRA", "IDVoie": "1456950", "Saisie": "12 boulevar", "Num": "12", "Entreprise": "", "NumSeul": "12"}}',
                new Map<String, String> { 'Content-Type' => 'application/json'}),
                
                'V2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                      null,'{"1" : {"Batiment":"BATIMENTA"},"3" :{"Batiment":"BATIMENT C"},"iris":"5101"}',
                                                      new Map<String, String> { 'Content-Type' => 'application/json'}),
                                                      
                'V2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                null,'{"1" : {"Batiment":"BATIMENTA"},"3" :{"Batiment":"BATIMENT C"},"iris":"5101"}',
                new Map<String, String> { 'Content-Type' => 'application/json'})

                    
                };

                Test.startTest();
                Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
                String status = HP_EC_LoadCustomerData.init();
                System.assertEquals('Initiated', status, 'Error while loading the data controller');
                //2nd call to call cached data
                HP_EC_LoadCustomerData.getContactData();
                HP_EC_LoadCustomerData.getContractData();
                HP_EC_LoadCustomerData.getContractPortfolioData();
                HP_EC_LoadCustomerData.getSoldeEffectifData();
                HP_EC_LoadCustomerData.getCoordonneesBancaires();
                // Methodes with parameters : 1st call
                HP_EC_LoadCustomerData.getSoldeEffectifData();
                HP_EC_LoadCustomerData.getPorteFeuilleContratXdata('123');
                HP_EC_LoadCustomerData.getFactureAgilabData('123');
                HP_EC_LoadCustomerData.getEcheanceContractData('111');
                HP_EC_LoadCustomerData.getInfoContractData('111');
                HP_EC_LoadCustomerData.getPlansApurement(1111);
                HP_EC_LoadCustomerData.getPaiement(1111);
                HP_EC_LoadCustomerData.getEmailValidation('testmail@hotmail.com');
                HP_EC_LoadCustomerData.getTelephoneValidation('0613035600','FRA');
                HP_EC_LoadCustomerData.getSuggestionsDQE('46+boulevard+de+la+libération+67500+Haguenau');
                HP_EC_LoadCustomerData.getComplementsDQE('8+rue+de+l+universite+26500+BOURG+LES+VALENCE');
                // Methodes with parameters : 2nd call to call cached data
                HP_EC_LoadCustomerData.getPorteFeuilleContratXdata('123');
                HP_EC_LoadCustomerData.getFactureAgilabData('123');
                HP_EC_LoadCustomerData.getEcheanceContractData('111');
                HP_EC_LoadCustomerData.getInfoContractData('111');
                HP_EC_LoadCustomerData.loadEnergieVerOption('123');

                System.assertEquals('Initiated', status, 'Error while loading the cached data');
                Test.stopTest();
        }
    }

    @isTest
    public static void getTranquilityTest(){
        Id p = [SELECT id FROM profile where name = 'HP_Community_User'].id;
            Contact con = [SELECT id FROM Contact WHERE lastname = 'Portal Account' LIMIT 1];
            User portalUser = new User(alias = 'hpPortal', email = 'portaluser@noemail.com', EmailEncodingKey = 'UTF-8', lastname = 'Portal', 
            LanguageLocaleKey = 'en_US', LocaleSidKey ='en_US', ProfileId = p, country = 'United States', IsActive = true, contactId = con.Id, TimeZoneSidKey = 'Europe/Paris', UserName = 'portaluser@noemail.com');
            insert portalUser;
            Id pset = [SELECT id FROM PermissionSet where name = 'HP_EC_permissions' LIMIT 1].id;
            PermissionSetAssignment psa =  new PermissionSetAssignment(PermissionSetId = pset, AssigneeId = portalUser.id);
            insert psa;

            system.runAs(portalUser) {
                Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                    'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                        200,
                        'HP_APIHourAccessTokenResponse_MOCK',
                        new Map<String, String> {'Content-Type' => 'application/json'}
                    ),
                    'v2/rest/tranquillity/Contracts/getContrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                    'HP_SM003_Tranquility_Contrat_TEST',
                    new Map<String, String> { 'Content-Type' => 'application/json'}),
                    'personnes/show' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_SM001_Agilab_GetPersonne_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}),
                'apiset/0.2/contrats?idPersonne' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    'HP_CONTRAT_XDATA_BY_PERSONNE_MOCK',
                    new Map<String, String> {'Content-Type' => 'application/json'}
                    ),
                
      
                    'apiset/0.3/portefeuilles-contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    null, '{"idPortefeuilleContrat":"123"}',
                    new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'}),

                    '/api/happe/1.0/locaux-contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    null, '{"idPortefeuilleContrat":"123"}',
                    new Map<String, String> {'Content-Type' => 'application/json'}),
                    'coordonnees-bancaires' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                null, '{"_data":[]}',
                                                  new Map<String, String>())
                };
                Test.startTest();
                Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
                HP_EC_LoadCustomerData.getContractTranquility('1111');
                Test.stopTest();
            }
    }

}