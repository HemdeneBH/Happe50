/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-04-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   02-04-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public with sharing class HP_EM020_Contact_TEST {

    private enum StaticResource {
        HP_SM020_SouscriptionSave1_TEST,
        HP_SM020_SouscriptionSave1KO_TEST,
        HP_SM021_SouscriptionSave2_TEST,
        HP_SM021_SouscriptionSave2Case_TEST,
        HP_SM022_SouscriptionSave3_TEST,
        HP_APIHourCommercialProposition_POST_MOCK,
        HP_AGILAB_SOUSCRIPTION_MOCK,
        HP_APIHourAccessTokenResponse_MOCK,
        HP_AGILAB_CONTRACTUALISATION_MOCK,
        HP_ES_PDLGaz_v2_Mock,
        HP_ES_PDLElec_v3_Mock,
        HP_SendEmail_Mock
    }
    
    
    @isTest
    static void getContactByMail(){
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

        Test.startTest();
        HP_EM020_Contact.getContactByMail(contact.email);
        Test.stopTest();
        } 

    @isTest
    static void getContactByXdataId(){
            Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact','HP_Contact', new Map<String, Object>{
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
            },null,null, null);
            insert contact;

            Test.startTest();
            HP_EM020_Contact.getContactByXdataId(100166);
            Test.stopTest();
            } 


            @isTest
            static void loadContact(){
                Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact','HP_Contact', new Map<String, Object>{
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
                },null,null, null);
                insert contact;
    
                Test.startTest();
                HP_EM020_Contact.loadContact(contact.Id);
                Test.stopTest();
                } 
        

                @isTest
                static void loadSMContactList(){
                    Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact','HP_Contact', new Map<String, Object>{
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
                    },null,null, null);
                    insert contact;
        
                    Test.startTest();
                    HP_EM020_Contact.loadSMContactList(100166);
                    Test.stopTest();
                    } 

                    @isTest
                    static void insertContact(){
                        Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{
           
                            'Id_Tiers__c' => 100165,
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
                
                
                        HP_Offre__c offre = (HP_Offre__c)HP_UTIL_SmartFactory.createSObject('HP_Offre__c', null, new Map<String, Object>{
            
                            'offreCode__c' => 'EITR2_H',
                            'offreId__c'=> 436
                            
                        }, null, null, null);
                        insert offre;
                
                        HP_Offre__c offreGaz = (HP_Offre__c)HP_UTIL_SmartFactory.createSObject('HP_Offre__c', null, new Map<String, Object>{
                            'offreCode__c' => 'GITR2_H',
                            'offreId__c'=> 435
                            
                        }, null, null, null);
                        insert offreGaz;
                
                        HP_Souscription__c enrolment = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
                            'HP_Canal_de_vente__c'  => 'Vente Online',
                            'HP_Contact__c'=>contact.Id,
                            'HP_Classe_de_la_consommation_Gaz__c'  => 'B0',
                            'HP_Code_Gaz_Produit__c'  => 'GITR2_H',
                            'HP_Code_Electrique_Produit__c'  => 'EITR2_H',
                            'HP_Code_postal__c'  => '92160',
                            'HP_code_Postal_Insee__c'  => '92002',
                            'HP_Date_de_Contractualisation__c'  => Date.newInstance(2019, 12, 22),
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
                            'HP_Statut__c' =>'SAVE_1'
                        }, null);
                        insert enrolment;
                
                       
                        HP_Porte_Feuille_Contrat__c porteFeuille = (HP_Porte_Feuille_Contrat__c)HP_UTIL_SmartFactory.createSObject('HP_Porte_Feuille_Contrat__c', null, new Map<String, Object>{
                            'HP_Contact__c' => contact.id,
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
                            'HP_Index_de_Compteur__c'=>2323434
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
                            'HP_Type_de_Compteur__c' => 'ELEC'
                        }, null);
                        insert celec;
                        
                        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                            'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                            StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                            new Map<String, String> {'Content-Type' => 'application/json'}),
                            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                            'HP_APIHourAccessTokenResponse_MOCK',
                            new Map<String, String> {'Content-Type' => 'application/json'}),
                
                            'propositions/souscription' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                            'HP_AGILAB_SOUSCRIPTION_MOCK',
                            new Map<String, String> {'Content-Type' => 'application/json'}),
                
                            'propositions/contractualisation' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                            'HP_AGILAB_CONTRACTUALISATION_MOCK',
                            new Map<String, String> {'Content-Type' => 'application/json'}),
                
                            'portefeuilles-contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
                            null,
                            new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'}),
                            
                            'identite/v1/espaces-prives' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
                            null,
                            new Map<String, String> {'Content-Type' => 'application/json'}),
                
                            'propositions-commerciales' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
                            'HP_APIHourCommercialProposition_POST_MOCK',
                            new Map<String, String> {'Content-Type' => 'application/json'})
                            };
                
                            HP_PortailCanal__c canal = (HP_PortailCanal__c)HP_UTIL_SmartFactory.createSObject('HP_PortailCanal__c', null, new Map<String, Object>{
                                'Name'=>'Vente Online',
                                'Droit_VenteEm__c' => true,
                                'Droit_PaiementCB__c' => true,
                                'Droit_ParcoursEmDm__c'=>true,
                                'Droit_VenteChf1Ex__c' => true,
                                'Droit_VenteChf2Ex__c' => true,
                                'Droit_VenteEm1Ex__c'=>true
                            }, null, null, null);
                            insert canal;
                            HP_PortailPrestataire__c presta = (HP_PortailPrestataire__c)HP_UTIL_SmartFactory.createSObject('HP_PortailPrestataire__c', null, new Map<String, Object>{
                                'IdPrestataire__c'=>'HAPPE_TEST',
                                'Name' => 'Happe',
                                'Canal__c' => canal.Id
                            }, null, null, null);
                            insert presta;
                            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
                            Profile systemAdminProfile = [SELECT Id FROM Profile WHERE Name = 'HP_SystemAdmin'];
                            insert new ByPassSettings__c(SetupOwnerId = systemAdminProfile.Id, ValidationRule__c = true);  
                            HP_PortailUtilisateur__c utilisateur = (HP_PortailUtilisateur__c)HP_UTIL_SmartFactory.createSObject('HP_PortailUtilisateur__c', null, new Map<String, Object>{
                                'Login__c'=>'Hap001',
                                'Password__c' => 'TestPassword123!',
                                'Role__c' => 'Conseiller',
                                'Prestataire__c'=>presta.id,
                                'Nom__c' => 'Test Nom',
                                'Prenom__c' => 'Test Prenom',
                                'Civilite__c'=>'Mr'
                            }, null, null, null);
                            insert utilisateur;
                
                
                        final String enrolmentRestResourceSave2Json = HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(StaticResource.HP_SM021_SouscriptionSave2_TEST.name());
                        RestRequest reqSave2 = new RestRequest();
                        reqSave2.requestURI = '/services/apexrest/v1/enrolment';
                        reqSave2.httpMethod = 'POST';
                        reqSave2.requestBody = Blob.valueof(enrolmentRestResourceSave2Json);
                        RestContext.request = reqSave2;
                        
                        Test.startTest();
                        RestContext.response= new RestResponse();
                        HP_WS007_Souscription.post();
                        Test.stopTest();
                
                        } 


                        @istest
                        static void insertContactList(){

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
                    
                    
                            HP_Offre__c offre = (HP_Offre__c)HP_UTIL_SmartFactory.createSObject('HP_Offre__c', null, new Map<String, Object>{
                               
                                'offreCode__c' => 'EITR2_H',
                                'offreId__c'=> 436
                                
                            }, null, null, null);
                            insert offre;
                    
                            HP_Offre__c offreGaz = (HP_Offre__c)HP_UTIL_SmartFactory.createSObject('HP_Offre__c', null, new Map<String, Object>{
                                'offreCode__c' => 'GITR2_H',
                                'offreId__c'=> 435
                                
                            }, null, null, null);
                            insert offreGaz;
                    
                            HP_Souscription__c enrolment = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
                                'HP_Canal_de_vente__c'  => 'Vente Online',
                                'HP_Contact__c'=>contact.Id,
                                'HP_Classe_de_la_consommation_Gaz__c'  => 'B0',
                                'HP_Code_Gaz_Produit__c'  => 'GITR2_H',
                                'HP_Code_Electrique_Produit__c'  => 'EITR2_H',
                                'HP_Code_postal__c'  => '92160',
                                'HP_code_Postal_Insee__c'  => '92002',
                                'HP_Date_de_Contractualisation__c'  => Date.newInstance(2019, 12, 22),
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
                                'HP_Statut__c' =>'SAVE_1'
                            }, null);
                            insert enrolment;
                    
                    
                    
                           
                            HP_Porte_Feuille_Contrat__c porteFeuille = (HP_Porte_Feuille_Contrat__c)HP_UTIL_SmartFactory.createSObject('HP_Porte_Feuille_Contrat__c', null, new Map<String, Object>{
                                'HP_Contact__c' => contact.id,
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
                                'HP_Index_de_Compteur__c'=>2323434
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
                                'HP_Type_de_Compteur__c' => 'ELEC'
                            }, null);
                            insert celec;
                            
                            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                                'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                                StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                                new Map<String, String> {'Content-Type' => 'application/json'}),
                                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                                'HP_APIHourAccessTokenResponse_MOCK',
                                new Map<String, String> {'Content-Type' => 'application/json'}),
                    
                                'propositions/souscription' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                                'HP_AGILAB_SOUSCRIPTION_MOCK',
                                new Map<String, String> {'Content-Type' => 'application/json'}),
                    
                                'propositions/contractualisation' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                                'HP_AGILAB_CONTRACTUALISATION_MOCK',
                                new Map<String, String> {'Content-Type' => 'application/json'}),
                    
                                'portefeuilles-contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
                                null,
                                new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'}),
                                
                                'identite/v1/espaces-prives' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
                                null,
                                new Map<String, String> {'Content-Type' => 'application/json'}),
                    
                                'propositions-commerciales' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
                                'HP_APIHourCommercialProposition_POST_MOCK',
                                new Map<String, String> {'Content-Type' => 'application/json'})
                                };
                    
                                HP_PortailCanal__c canal = (HP_PortailCanal__c)HP_UTIL_SmartFactory.createSObject('HP_PortailCanal__c', null, new Map<String, Object>{
                                    'Name'=>'Vente Online',
                                    'Droit_VenteEm__c' => true,
                                    'Droit_PaiementCB__c' => true,
                                    'Droit_ParcoursEmDm__c'=>true,
                                    'Droit_VenteChf1Ex__c' => true,
                                    'Droit_VenteChf2Ex__c' => true,
                                    'Droit_VenteEm1Ex__c'=>true
                                }, null, null, null);
                                insert canal;
                                HP_PortailPrestataire__c presta = (HP_PortailPrestataire__c)HP_UTIL_SmartFactory.createSObject('HP_PortailPrestataire__c', null, new Map<String, Object>{
                                    'IdPrestataire__c'=>'HAPPE_TEST',
                                    'Name' => 'Happe',
                                    'Canal__c' => canal.Id
                                }, null, null, null);
                                insert presta;
                                Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
                                Profile systemAdminProfile = [SELECT Id FROM Profile WHERE Name = 'HP_SystemAdmin'];
                                insert new ByPassSettings__c(SetupOwnerId = systemAdminProfile.Id, ValidationRule__c = true);  
                                HP_PortailUtilisateur__c utilisateur = (HP_PortailUtilisateur__c)HP_UTIL_SmartFactory.createSObject('HP_PortailUtilisateur__c', null, new Map<String, Object>{
                                    'Login__c'=>'Hap001',
                                    'Password__c' => 'TestPassword123!',
                                    'Role__c' => 'Conseiller',
                                    'Prestataire__c'=>presta.id,
                                    'Nom__c' => 'Test Nom',
                                    'Prenom__c' => 'Test Prenom',
                                    'Civilite__c'=>'Mr'
                                }, null, null, null);
                                insert utilisateur;
                    
                    
                            final String enrolmentRestResourceSave2Json = HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(StaticResource.HP_SM021_SouscriptionSave2_TEST.name());
                            RestRequest reqSave2 = new RestRequest();
                            reqSave2.requestURI = '/services/apexrest/v1/enrolment';
                            reqSave2.httpMethod = 'POST';
                            reqSave2.requestBody = Blob.valueof(enrolmentRestResourceSave2Json);
                            RestContext.request = reqSave2;
                            
                            Test.startTest();
                            RestContext.response= new RestResponse();
                            HP_WS007_Souscription.post();
                            Test.stopTest();
                    
                        }

    }