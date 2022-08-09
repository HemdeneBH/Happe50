/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 06-27-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
@isTest
public with sharing class HP_EC_UpdateCustomerData_TEST {
   
    @TestSetup
    static void setupData(){
        HP_Community_User__c commUser = new HP_Community_User__c(   Username__c = 'email@email.com', 
                                                                    Crypted_Password__c = '',
                                                                    Activation_Key__c = 'av75d4cac9d69404a47a4b05333bbe09e427jhbgd',
                                                                    Reset_Password_Key__c = 'bhy8855d4cac9d69404a47a4b05333bbe0927gd',
                                                                    Salt__c = '123SLT',
                                                                    Name = 'Test Contact',
                                                                    Id_Tiers__c = '100166',
                                                                    Avatar__c = 'Fox');
        insert commUser;

        Account ac = new Account(name = 'HP Portal Account');
        insert ac;

        Contact con = new Contact(LastName = 'Portal Account', AccountId = ac.Id, ID_Tiers__c = 100166, RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Contact','HP_Contact'), HP_IsHappe__c= true);
        insert con;

        Contact cont = new Contact(LastName = 'Portal Account', AccountId = ac.Id, ID_Tiers__c = 100167, RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Contact','HP_Contact'), HP_IsHappe__c= true);
        insert cont;

        List<HP_MajConsentements__c> myConsentmentList = new List<HP_MajConsentements__c>();
        for(Integer i= 1; i<4; i++){
            myConsentmentList.add(new HP_MajConsentements__c(HP_Contact__c = con.Id,
                                                            HP_IdQuestionnaireConsentement__c = 1, 
                                                            HP_IdQuestionConsentement__c = i, 
                                                            HP_Canal__c = 'Web', 
                                                            HP_Consentement__c = false, 
                                                            HP_IdXDATA__c = con.Id_Tiers__c,
                                                            HP_Source__c = 'Happe'));
        }
        insert myConsentmentList;
         
    }

    @isTest
    public static void createCaseDonneesTest(){
        Id p = [SELECT id FROM profile where name = 'HP_Community_User'].id;
        Contact con = [SELECT id FROM Contact WHERE lastname = 'Portal Account' LIMIT 1];
        User portalUser = new User(alias = 'hpPortal', email = 'portaluser@noemail.com', EmailEncodingKey = 'UTF-8', lastname = 'Portal', 
        LanguageLocaleKey = 'en_US', LocaleSidKey ='en_US', ProfileId = p, country = 'United States', IsActive = true, contactId = con.Id, TimeZoneSidKey = 'Europe/Paris', UserName = 'portaluser@noemail.com');
        insert portalUser;
        Id pset = [SELECT id FROM PermissionSet where name = 'HP_EC_permissions' LIMIT 1].id;
        PermissionSetAssignment psa =  new PermissionSetAssignment(PermissionSetId = pset, AssigneeId = portalUser.id);
        insert psa;
        system.runAs(portalUser) {
            Test.startTest();
            HP_EC_UpdateCustomerData.createCaseDonnees(con.Id);
            Test.stopTest();
        }
    }

    @isTest
    public static void updateEnergieVertTest(){
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
                ),'propositions/modifier' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_ResponseHPSM006FactureManagermodifiermodedenvoiFactures',
                new Map<String, String> {'Content-Type' => 'application/json'})};
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
            HP_EC_UpdateCustomerData.updateEnergieVert('123456', '1');
            Test.stopTest();
        } 
    }

    @isTest
    public static void updateJourDrpTest(){
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
                'propositions/modifier?' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                'HP_AGILAB_PROPOSITION_MODIFIER_DRP_MOCK',
                                        new Map<String, String> {'Content-Type' => 'application/json'})};
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
            HP_EC_UpdateCustomerData.updateJourDrp('123456', '24');
            Test.stopTest();
        }
    }

    @isTest
    public static void updateMensualiteTest(){
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
                'propositions/maj_de_mensualite?' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
							'HP_AGILAB_MAJ_MENSUALITE_MOCK',
							new Map<String, String> { 'Content-Type' => 'application/json'})};
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
            HP_EC_UpdateCustomerData.updateMensualite('123456', '60');
            Test.stopTest();
        }
    }

    @isTest
    public static void createCaseMensualiteTest(){
        Id p = [SELECT id FROM profile where name = 'HP_Community_User'].id;
        Contact con = [SELECT id FROM Contact WHERE lastname = 'Portal Account' LIMIT 1];
        User portalUser = new User(alias = 'hpPortal', email = 'portaluser@noemail.com', EmailEncodingKey = 'UTF-8', lastname = 'Portal', 
        LanguageLocaleKey = 'en_US', LocaleSidKey ='en_US', ProfileId = p, country = 'United States', IsActive = true, contactId = con.Id, TimeZoneSidKey = 'Europe/Paris', UserName = 'portaluser@noemail.com');
        insert portalUser;
        Id pset = [SELECT id FROM PermissionSet where name = 'HP_EC_permissions' LIMIT 1].id;
        PermissionSetAssignment psa =  new PermissionSetAssignment(PermissionSetId = pset, AssigneeId = portalUser.id);
        insert psa;
        Map<String,Object> objectInformation = new Map<String,Object>{'contactId'=>con.Id, 'type' => 'Mensualite', 'oldAmount' => '25', 'newAmount' => '35'};
        system.runAs(portalUser) {
            Test.startTest();
            HP_EC_UpdateCustomerData.createCaseMensualite(objectInformation);
            Test.stopTest();
        }
    }

    @IsTest
    static void updateEmailTest(){
        HP_Community_User__c myCommunityUser = [SELECT Id, Username__c FROM HP_Community_User__c LIMIT 1];
        myCommunityUser.Username__c = 'jdd.espace.test@yopmail.com';
        update myCommunityUser;
        Test.startTest();
        HP_EC_UpdateCustomerData.updateEmail('100166', 'jdd.espace.younes@yopmail.com');
        Test.stopTest();
        Contact contactUpdate = [select id,email,ID_Tiers__c from Contact LIMIT 1];
        System.assert(contactUpdate.email != 'jdd.espace.test@yopmail.com','Email mis à jour avec succès');
        HP_Community_User__c myCommunityUserUpdated = [SELECT Id, Username__c FROM HP_Community_User__c LIMIT 1];
        System.assert(myCommunityUserUpdated.Username__c != 'jdd.espace.test@yopmail.com','Email mis à jour avec succès');
    }

    @IsTest
    static void updateEmailTestKo(){
        HP_Community_User__c myCommunityUser = [SELECT Id, Username__c FROM HP_Community_User__c LIMIT 1];
        myCommunityUser.Username__c = 'jdd.espace.test@yopmail.com';
        update myCommunityUser;
        Test.startTest();
        Map<String,Object> resultObject = HP_EC_UpdateCustomerData.updateEmail('112233', 'jdd.espace.test@yopmail.com');
        Test.stopTest();
        system.debug('resultObject++++'+resultObject.get('success'));
        System.assert(resultObject.get('success') == false,'Exception catchée');
    }

    @IsTest
    static void hpSaveClientTest(){
        Contact contactUpdate = [select id, email, MobilePhone, phone, No_Voie__c, MailingPostalCode, MailingCity, MailingStreet from Contact LIMIT 1];
        contactUpdate.email = 'jdd.espace.test@gmail.com';
        contactUpdate.MobilePhone = '+33673625302';
        contactUpdate.phone = '+33145454646';
        contactUpdate.No_Voie__c = '102';
        contactUpdate.MailingPostalCode = '75011';
        contactUpdate.MailingCity = 'PARIS';
        contactUpdate.MailingStreet ='AVENUE LEDRU ROLLIN';
        update contactUpdate;
        Test.startTest();
        Map<String, Object> client = new Map<String, Object>();
        client.put('id','0037a00001h5ZsKAAU');
        client.put('ref','100166');
        client.put('email','test.jdd@gmail.com');
        client.put('numeroMobile','+33673620303');
        client.put('numeroFixe','+33145454645');
        client.put('numVoie','103');
        client.put('codePostal','75020');
        client.put('ville','Nice');
        client.put('voie','AVENUE HENRI MARTIN');
        String result = HP_EC_UpdateCustomerData.hpSaveClient(client);
        system.debug('contactUpdate.id '+contactUpdate.id+ ' result '+result);
        Test.stopTest();
        //System.assertEquals(contactUpdate.id, result);
    }

    // @IsTest
    // static void hpSaveClientTestKo(){
    //     Contact contactUser = [select id, email, MobilePhone, phone, No_Voie__c, MailingPostalCode, MailingCity, MailingStreet from Contact WHERE ID_Tiers__c = :idRef LIMIT 1];
    //     contactUpdate.email = 'jdd.espace.test@gmail.com';
    //     contactUpdate.MobilePhone = '+33673625302';
    //     contactUpdate.phone = '+33145454646';
    //     contactUser.No_Voie__c = '102';
    //     contactUser.MailingPostalCode = '75011';
    //     contactUser.MailingCity = 'PARIS';
    //     contactUser.MailingStreet ='AVENUE LEDRU ROLLIN';
    //     update contactUser;
    //     Test.startTest();
    //     Map<String, Object> client = new Map<String, Object>();
    //     client.put('email','test.jdd@gmail.com');
    //     client.put('numeroMobile','+33673620303');
    //     client.put('numeroFixe','+33145454645');
    //     client.put('numVoie','103');
    //     client.put('codePostal','75020');
    //     client.put('ville','Nice');
    //     client.put('voie','AVENUE HENRI MARTIN');
    //     String result = HP_EC_UpdateCustomerData.hpSaveClient(client);
    //     Test.stopTest();
    //     Contact contactUpdate = [select id, No_Voie__c, MailingPostalCode, MailingStreet, MailingCity from contact LIMIT 1];
    //     System.assert(result == null,'Exception catchée');
    // }

    @IsTest
    static void getAvatarTest(){
        Test.startTest();
        HP_Community_User__c myCommunityUser = HP_EC_UpdateCustomerData.getAvatar('100166');
        Test.stopTest();
        System.assertEquals(myCommunityUser.Avatar__c ,'Fox');
    }

    @IsTest
    static void updateAvatarTest(){
        Test.startTest();
        HP_EC_UpdateCustomerData.updateAvatar('100166','dog');
        HP_Community_User__c myCommunityUser = [select id, Avatar__c from HP_Community_User__c LIMIT 1];
        Test.stopTest();
        System.assert(myCommunityUser.Avatar__c != 'Fox','Avatar mis à jour avec succès');
    }

    @IsTest
    static void updateAvatarTestKo(){

        Test.startTest();
        Map<String,Object> resultObject = HP_EC_UpdateCustomerData.updateAvatar('112233','dog');
        Test.stopTest();
        System.assert(resultObject.get('success') == false,'Exception catchée');
    }

    @isTest
    public static void updateOptinMarketingTest(){
        Id p = [SELECT id FROM profile where name = 'HP_Community_User'].id;
        Contact con = [SELECT id FROM Contact WHERE lastname = 'Portal Account' LIMIT 1];
        User portalUser = new User(alias = 'hpPortal', email = 'portaluser@noemail.com', EmailEncodingKey = 'UTF-8', lastname = 'Portal', 
        LanguageLocaleKey = 'en_US', LocaleSidKey ='en_US', ProfileId = p, country = 'United States', IsActive = true, contactId = con.Id, TimeZoneSidKey = 'Europe/Paris', UserName = 'portaluser@noemail.com');
        insert portalUser;
        Id pset = [SELECT id FROM PermissionSet where name = 'HP_EC_permissions' LIMIT 1].id;
        PermissionSetAssignment psa =  new PermissionSetAssignment(PermissionSetId = pset, AssigneeId = portalUser.id);
        insert psa;
        system.runAs(portalUser) {
            Test.startTest();
            HP_EC_UpdateCustomerData.updateOptinMarketing('100166', false);
            Test.stopTest();
            Contact myContact = [SELECT id, HP_OptinMarketing__c FROM Contact WHERE lastname = 'Portal Account' LIMIT 1];
            System.assert(myContact.HP_OptinMarketing__c == false, 'Test OK');
        }
    }

    @isTest
    public static void updateConsentementInfosTest(){
        Id p = [SELECT id FROM profile where name = 'HP_Community_User'].id;
        Contact con = [SELECT id FROM Contact WHERE lastname = 'Portal Account' LIMIT 1];
        User portalUser = new User(alias = 'hpPortal', email = 'portaluser@noemail.com', EmailEncodingKey = 'UTF-8', lastname = 'Portal', 
        LanguageLocaleKey = 'en_US', LocaleSidKey ='en_US', ProfileId = p, country = 'United States', IsActive = true, contactId = con.Id, TimeZoneSidKey = 'Europe/Paris', UserName = 'portaluser@noemail.com');
        insert portalUser;
        Id pset = [SELECT id FROM PermissionSet where name = 'HP_EC_permissions' LIMIT 1].id;
        PermissionSetAssignment psa =  new PermissionSetAssignment(PermissionSetId = pset, AssigneeId = portalUser.id);
        insert psa;
        String consentements = '[{"idPersonne":0,"libelleQuestion":"J\'accepte de recevoir des communications par voie électronique sur des offres de produits ou services de la société ENGIE similaires à la vente d\'énergie.","idQuestion":1,"idQuestionnaire":1,"consent":true,"canal":"Telephone","application":"HAPPE","name":"consent0","response":"oui"},{"idPersonne":0,"libelleQuestion":"J\'accepte de recevoir des communications par voie électronique sur des offres de produits ou services des sociétés du groupe ENGIE non similaires à la vente d\'énergie.","idQuestion":2,"idQuestionnaire":1,"consent":false,"canal":"Telephone","application":"HAPPE","name":"consent1","response":"non"},{"idPersonne":0,"libelleQuestion":"J\'accepte de recevoir des communications par voie électronique sur des offres de partenaires du groupe ENGIE.","idQuestion":3,"idQuestionnaire":1,"consent":false,"canal":"Telephone","application":"HAPPE","name":"consent2","response":"non"}]';
        List<Object> myList= (List<Object>) JSON.deserializeUntyped(consentements);
        List<Map<String, Object>> concentementList = new List<Map<String, Object>>();
        for(Object item : myList){
            concentementList.add((Map<String, Object>)item);
        }
        system.runAs(portalUser) {
            Test.startTest();
            HP_EC_UpdateCustomerData.updateConsentementInfos('100166', concentementList);
            Test.stopTest();
        }
    }

    @isTest
    public static void updateConsentementInfosTestInsert(){
        Id p = [SELECT id FROM profile where name = 'HP_Community_User'].id;
        Contact con = [SELECT id FROM Contact WHERE lastname = 'Portal Account' LIMIT 1];
        User portalUser = new User(alias = 'hpPortal', email = 'portaluser@noemail.com', EmailEncodingKey = 'UTF-8', lastname = 'Portal', 
        LanguageLocaleKey = 'en_US', LocaleSidKey ='en_US', ProfileId = p, country = 'United States', IsActive = true, contactId = con.Id, TimeZoneSidKey = 'Europe/Paris', UserName = 'portaluser@noemail.com');
        insert portalUser;
        Id pset = [SELECT id FROM PermissionSet where name = 'HP_EC_permissions' LIMIT 1].id;
        PermissionSetAssignment psa =  new PermissionSetAssignment(PermissionSetId = pset, AssigneeId = portalUser.id);
        insert psa;
        String consentements = '[{"idPersonne":0,"libelleQuestion":"J\'accepte de recevoir des communications par voie électronique sur des offres de produits ou services de la société ENGIE similaires à la vente d\'énergie.","idQuestion":1,"idQuestionnaire":1,"consent":true,"canal":"Telephone","application":"HAPPE","name":"consent0","response":"oui"},{"idPersonne":0,"libelleQuestion":"J\'accepte de recevoir des communications par voie électronique sur des offres de produits ou services des sociétés du groupe ENGIE non similaires à la vente d\'énergie.","idQuestion":2,"idQuestionnaire":1,"consent":false,"canal":"Telephone","application":"HAPPE","name":"consent1","response":"non"},{"idPersonne":0,"libelleQuestion":"J\'accepte de recevoir des communications par voie électronique sur des offres de partenaires du groupe ENGIE.","idQuestion":3,"idQuestionnaire":1,"consent":false,"canal":"Telephone","application":"HAPPE","name":"consent2","response":"non"}]';
        List<Object> myList= (List<Object>) JSON.deserializeUntyped(consentements);
        List<Map<String, Object>> concentementList = new List<Map<String, Object>>();
        for(Object item : myList){
            concentementList.add((Map<String, Object>)item);
        }
        system.runAs(portalUser) {
            Test.startTest();
            HP_EC_UpdateCustomerData.updateConsentementInfos('100167', concentementList);
            Test.stopTest();
        }
    }

    @isTest
    public static void updateConsentementXdataTest(){
        Id p = [SELECT id FROM profile where name = 'HP_Community_User'].id;
        Contact con = [SELECT id FROM Contact WHERE lastname = 'Portal Account' LIMIT 1];
        User portalUser = new User(alias = 'hpPortal', email = 'portaluser@noemail.com', EmailEncodingKey = 'UTF-8', lastname = 'Portal', 
        LanguageLocaleKey = 'en_US', LocaleSidKey ='en_US', ProfileId = p, country = 'United States', IsActive = true, contactId = con.Id, TimeZoneSidKey = 'Europe/Paris', UserName = 'portaluser@noemail.com');
        insert portalUser;
        Id pset = [SELECT id FROM PermissionSet where name = 'HP_EC_permissions' LIMIT 1].id;
        PermissionSetAssignment psa =  new PermissionSetAssignment(PermissionSetId = pset, AssigneeId = portalUser.id);
        insert psa;
        String consentements = '[{"idPersonne":0,"libelleQuestion":"J\'accepte de recevoir des communications par voie électronique sur des offres de produits ou services de la société ENGIE similaires à la vente d\'énergie.","idQuestion":1,"idQuestionnaire":1,"consent":true,"canal":"Telephone","application":"HAPPE","name":"consent0","response":"oui"},{"idPersonne":0,"libelleQuestion":"J\'accepte de recevoir des communications par voie électronique sur des offres de produits ou services des sociétés du groupe ENGIE non similaires à la vente d\'énergie.","idQuestion":2,"idQuestionnaire":1,"consent":false,"canal":"Telephone","application":"HAPPE","name":"consent1","response":"non"},{"idPersonne":0,"libelleQuestion":"J\'accepte de recevoir des communications par voie électronique sur des offres de partenaires du groupe ENGIE.","idQuestion":3,"idQuestionnaire":1,"consent":false,"canal":"Telephone","application":"HAPPE","name":"consent2","response":"non"}]';
        List<Object> myList= (List<Object>) JSON.deserializeUntyped(consentements);
        List<Map<String, Object>> concentementList = new List<Map<String, Object>>();
        for(Object item : myList){
            concentementList.add((Map<String, Object>)item);
        }
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                   'HP_APIHourAccessTokenResponse_MOCK',
                                                   new Map<String, String> {'Content-Type' => 'application/json'}),
    
            'consentements' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(204,
                                                  null,
                                                  new Map<String, String> { 'Content-Type' => 'application/json'})
        };
    
        
        system.runAs(portalUser) {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
            HP_EC_UpdateCustomerData.updateConsentementXdata('100166', concentementList);
            Test.stopTest();
        }
    }
}