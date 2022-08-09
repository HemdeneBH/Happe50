/*
*@Author: Georges Mardini
*@Description: Classe test de VI_parcoursOffre_Test.
*@CreatedDate: 19/03/2021
*@LastModified: 19/07/2021
*/

@isTest

public class VI_parcoursOffre_Test { 
    @testSetup
    static void testSetup(){
        List<Group> ownerQueue = [Select Id,DeveloperName from Group where Type = 'Queue'];
        
        system.debug('query queue '+ownerQueue);
        Id profileId = [Select Id From Profile Where Name ='VI_PurePlayer'].Id;
        Account acc = VI_TestUtility.createAccount('Marketshot');
        acc.RecordTypeId = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('PartenaireAccountRT').getRecordTypeId();
        insert acc;
        Contact con = VI_TestUtility.createContact('test','Contact','test@gmail.com',acc.Id);
        insert con;
        User u = VI_TestUtility.createCommunityUser(con.Id,profileId,'Test','Test');
        insert u;
    }
    
    @isTest
    static void getChoixdoffreSFTest(){
        //INSERT Choix_Offre__c
        List<Choix_Offre__c> offreListInsert = new List<Choix_Offre__c>();
        
        //CAS 1 energie = Gaz
        Choix_Offre__c offreTestGaz = new Choix_Offre__c();
        offreTestGaz.Energie__c = 'Gaz';
        offreTestGaz.OffrePousse__c = 'GBUKF3_P';
        offreTestGaz.offreRepli__c = 'GBUKF3_P';
        offreTestGaz.Contexte_de_souscription__c = 'PP-EM';
        
        offreListInsert.add(offreTestGaz);  
        
        //CAS 2 energie = Elec
        Choix_Offre__c offreTestElec = new Choix_Offre__c();
        offreTestElec.Energie__c = 'Elec';
        offreTestElec.OffrePousse__c = 'GBUKF3_P';
        offreTestElec.offreRepli__c = 'GBUKF3_P';
        offreTestElec.Contexte_de_souscription__c = 'PP-EM';
        offreListInsert.add(offreTestElec);  
        
        //CAS 3 energie = Duo
        Choix_Offre__c offreTestDuo = new Choix_Offre__c();
        offreTestDuo.Energie__c = 'Duo';
        offreTestDuo.OffrePousse__c = 'GBUKF3_P';
        offreTestDuo.offreRepli__c = 'GBUKF3_P';
        offreTestDuo.Contexte_de_souscription__c = 'PP-EM';
        offreListInsert.add(offreTestDuo);
        
        insert offreListInsert;  
        
        Account Partner =[Select id, Name from Account where Account.Name ='Marketshot'];
        List<VI_JonctionChoixOffre_Compte__c> jonctionOffreCompte = new List<VI_JonctionChoixOffre_Compte__c>();
        
        VI_JonctionChoixOffre_Compte__c Jonction1 = new VI_JonctionChoixOffre_Compte__c();
        Jonction1.Partenaire__c = Partner.id;
        Jonction1.VI_ChoixOffre__c = offreTestGaz.id;
        jonctionOffreCompte.add(Jonction1);
        
        VI_JonctionChoixOffre_Compte__c Jonction2 = new VI_JonctionChoixOffre_Compte__c();
        Jonction2.Partenaire__c = Partner.id;
        Jonction2.VI_ChoixOffre__c = offreTestElec.id;
        jonctionOffreCompte.add(Jonction2);
        
        VI_JonctionChoixOffre_Compte__c Jonction3 = new VI_JonctionChoixOffre_Compte__c();
        Jonction3.Partenaire__c = Partner.id;
        Jonction3.VI_ChoixOffre__c = offreTestDuo.id;
        jonctionOffreCompte.add(Jonction3);
        
        insert jonctionOffreCompte;
        
        //INSERT Product2
        List<Product2> product2TestInsert = new List<Product2>();
        
        //CAS 1 energie = Gaz
        Product2 product2TestGaz = new Product2();
        product2TestGaz.Family = 'GBUKF3_P';
        product2TestGaz.vlocity_cmt__Type__c = 'Gaz';
        product2TestGaz.Name = 'TESTGAZ';
        product2TestGaz.IsActive = true;
        
        product2TestInsert.add(product2TestGaz);  
        
        //CAS 2 energie = Elec
        Product2 product2TestElec = new Product2();
        product2TestElec.Family = 'GBUKF3_P';
        product2TestElec.vlocity_cmt__Type__c = 'Elec';
        product2TestElec.SM_structureMesureFournisseur__c = 'STR_MESURE_SIMPLE';
        product2TestElec.Name = 'TESTELEC';
        product2TestElec.IsActive = true;
        
        product2TestInsert.add(product2TestElec);  
        
        //CAS 3 energie = Duo
        Product2 product2TestDuo = new Product2();
        product2TestDuo.Family = 'GBUKF3_P';
        product2TestDuo.vlocity_cmt__Type__c = 'Duo';
        product2TestDuo.SM_structureMesureFournisseur__c = null;
        product2TestDuo.Name = 'TESTDUO';
        product2TestDuo.IsActive = true;
        
        product2TestInsert.add(product2TestDuo);
        
        insert product2TestInsert;  
        
        // TEST FONCTION
        //CAS 1 energie = Gaz
        User u2 =[Select id, Name from user where Account.Name ='Marketshot'];
        System.debug('Test class, u2 Name = '+ u2.Name);
        System.runAs(u2){
            Test.startTest();
            List<Product2> productResponseGaz = new List<Product2>();
            VI_parcoursOffre_Controller.getChoixdoffreSF('Gaz','SIMPLE','PP-','EM');
            System.assertEquals(VI_parcoursOffre_Controller.getChoixdoffreSF('Gaz','SIMPLE','PP-','EM').size(),1);
        }
        
        //CAS 2 energie = Elec
        System.runAs(u2){
            List<Product2> productResponseElec = new List<Product2>();
            system.assertEquals(VI_parcoursOffre_Controller.getChoixdoffreSF('Elec','SIMPLE','PP-','EM').size(),1);
        }
        
        //CAS 3 energie = Duo
        System.runAs(u2){
            List<Product2> productResponseDuo = new List<Product2>();
            system.assertEquals(VI_parcoursOffre_Controller.getChoixdoffreSF('Duo','SIMPLE','PP-','EM').size(),1);
            Test.stopTest();
        }
    }
    
    @isTest
    static void getOffersOctopusParcoursTest(){
        List<Parcours_Mapping__c>  listMapInsert = new list<Parcours_Mapping__c>();
        //INSERT ALL MAPPING
        Parcours_Mapping__c mapTest = new Parcours_Mapping__c(Name = 'TESTNAME',
                                                              Field_Name__c = 'VI_AnneeConstructionLogementSaisieConso__c',
                                                              Local_Value__c = '1989_1999',
                                                              API_Value__c = 'Entre 1975 et 1988');
        
        listMapInsert.add(mapTest);
        
        Parcours_Mapping__c mapTest2 = new Parcours_Mapping__c(Name = 'TESTNAME2',
                                                               Field_Name__c = 'VI_EnergieChauffageSaisieConso__c',
                                                               Local_Value__c = '030',
                                                               API_Value__c = 'Electricité');
        
        listMapInsert.add(mapTest2);
        Parcours_Mapping__c mapTest3 = new Parcours_Mapping__c(Name = 'TESTNAME3',
                                                               Field_Name__c = 'VI_DispositifEauChaudeSaisieConso__c',
                                                               Local_Value__c = '010',
                                                               API_Value__c = 'Collectif');
        
        listMapInsert.add(mapTest3);
        Parcours_Mapping__c mapTest4 = new Parcours_Mapping__c(Name = 'TESTNAME4',
                                                               Field_Name__c = 'VI_DispositifChauffageSaisieConso__c',
                                                               Local_Value__c = '030',
                                                               API_Value__c = 'Individuel');
        
        listMapInsert.add(mapTest4);
        Parcours_Mapping__c mapTest5 = new Parcours_Mapping__c(Name = 'TESTNAME5',
                                                               Field_Name__c = 'VI_TypeLogementSaisieConso__c',
                                                               Local_Value__c = '010',
                                                               API_Value__c = 'Individuel');
        
        listMapInsert.add(mapTest5);
        Parcours_Mapping__c mapTest6 = new Parcours_Mapping__c(Name = 'TESTNAME6',
                                                               Field_Name__c = 'VI_TypeResidenceSaisieConso__c',
                                                               Local_Value__c = '010',
                                                               API_Value__c = 'Principale');
        
        listMapInsert.add(mapTest6);
        Parcours_Mapping__c mapTest7 = new Parcours_Mapping__c(Name = 'TESTNAME7',
                                                               Field_Name__c = 'VI_EnergieCuissonSaisieConso__c',
                                                               Local_Value__c = '010',
                                                               API_Value__c = 'Fioul');
        
        listMapInsert.add(mapTest7);
        Parcours_Mapping__c mapTest8 = new Parcours_Mapping__c(Name = 'TESTNAME8',
                                                               Field_Name__c = 'VI_NombreOccupantLogementSaisieConso__c',
                                                               Local_Value__c = '3',
                                                               API_Value__c = '3');
        
        listMapInsert.add(mapTest8);
        Parcours_Mapping__c mapTest9 = new Parcours_Mapping__c(Name = 'TESTNAME9',
                                                               Field_Name__c = 'VI_SurfaceLogementSaisieConso__c',
                                                               Local_Value__c = '20',
                                                               API_Value__c = '20');
        
        listMapInsert.add(mapTest9);
        Parcours_Mapping__c mapTest10 = new Parcours_Mapping__c(Name = 'TESTNAME10',
                                                               Field_Name__c = 'VI_EnergieEauChaudeSaisieConso__c',
                                                               Local_Value__c = '20',
                                                               API_Value__c = '20');
        
        listMapInsert.add(mapTest10);
        insert listMapInsert;
        
        //INSERT Choix_Offre__c
        List<Choix_Offre__c> offreListInsert = new List<Choix_Offre__c>();
        
        //CAS 1 energie = Gaz
        Choix_Offre__c offreTestGaz = new Choix_Offre__c();
        offreTestGaz.Energie__c = 'Gaz';
        offreTestGaz.OffrePousse__c = 'GBUKF3_P';
        offreTestGaz.offreRepli__c = 'GBUKF3_P';
        offreTestGaz.Contexte_de_souscription__c = 'PP-EM';
        offreTestGaz.Actif__c = true;
        offreListInsert.add(offreTestGaz);  
        
        //CAS 2 energie = Elec
        Choix_Offre__c offreTestElec = new Choix_Offre__c();
        offreTestElec.Energie__c = 'Elec';
        offreTestElec.OffrePousse__c = 'GBUKF3_P';
        offreTestElec.offreRepli__c = 'GBUKF3_P';
        offreTestElec.Contexte_de_souscription__c = 'PP-EM';
        offreTestElec.Actif__c = true;
        offreListInsert.add(offreTestElec);  
        
        //CAS 3 energie = Gaz TRADEOFF
        Choix_Offre__c offreTestGazTradeoff = new Choix_Offre__c();
        offreTestGazTradeoff.Energie__c = 'Gaz';
        offreTestGazTradeoff.OffrePousse__c = 'GBUKF3_P';
        offreTestGazTradeoff.offreRepli__c = 'GBUKF3_P';
        offreTestGazTradeoff.Contexte_de_souscription__c = 'PP-EM';
        offreTestGazTradeoff.Actif__c = true;
        offreListInsert.add(offreTestGazTradeoff);  
        
        //CAS 4 energie = Elec TRADEOFF
        Choix_Offre__c offreTestElecTradeoff = new Choix_Offre__c();
        offreTestElecTradeoff.Energie__c = 'Elec';
        offreTestElecTradeoff.OffrePousse__c = 'GBUKF3_P';
        offreTestElecTradeoff.offreRepli__c = 'GBUKF3_P';
        offreTestElecTradeoff.Contexte_de_souscription__c = 'PP-EM';
        offreTestElecTradeoff.Actif__c = true;
        offreListInsert.add(offreTestElecTradeoff);
        
        
        //CAS 5 energie Duo Elec TRADEOFF
        Choix_Offre__c offreTestDuoTradeoff = new Choix_Offre__c();
        offreTestElecTradeoff.Energie__c = 'Duo';
        offreTestElecTradeoff.OffrePousse__c = 'GBUKF3_P';
        offreTestElecTradeoff.offreRepli__c = 'GBUKF3_P';
        offreTestElecTradeoff.Contexte_de_souscription__c = 'PP-EM';
        offreTestElecTradeoff.Actif__c = true;
        offreListInsert.add(offreTestDuoTradeoff);
        
        
        insert offreListInsert;
        
        Account Partner =[Select id, Name from Account where Account.Name ='Marketshot'];
        List<VI_JonctionChoixOffre_Compte__c> jonctionOffreCompte = new List<VI_JonctionChoixOffre_Compte__c>();
        
        VI_JonctionChoixOffre_Compte__c Jonction1 = new VI_JonctionChoixOffre_Compte__c();
        Jonction1.Partenaire__c = Partner.id;
        Jonction1.VI_ChoixOffre__c = offreTestGaz.id;
        jonctionOffreCompte.add(Jonction1);
        
        VI_JonctionChoixOffre_Compte__c Jonction2 = new VI_JonctionChoixOffre_Compte__c();
        Jonction2.Partenaire__c = Partner.id;
        Jonction2.VI_ChoixOffre__c = offreTestElec.id;
        jonctionOffreCompte.add(Jonction2);
        
        VI_JonctionChoixOffre_Compte__c Jonction3 = new VI_JonctionChoixOffre_Compte__c();
        Jonction3.Partenaire__c = Partner.id;
        Jonction3.VI_ChoixOffre__c = offreTestGazTradeoff.id;
        jonctionOffreCompte.add(Jonction3);
        
        VI_JonctionChoixOffre_Compte__c Jonction4 = new VI_JonctionChoixOffre_Compte__c();
        Jonction4.Partenaire__c = Partner.id;
        Jonction4.VI_ChoixOffre__c = offreTestElecTradeoff.id;
        jonctionOffreCompte.add(Jonction4);
        
        VI_JonctionChoixOffre_Compte__c Jonction5 = new VI_JonctionChoixOffre_Compte__c();
        Jonction5.Partenaire__c = Partner.id;
        Jonction5.VI_ChoixOffre__c = offreTestDuoTradeoff.id;
        jonctionOffreCompte.add(Jonction5);
        
        insert jonctionOffreCompte;
        
        //INSERT Product2
        List<Product2> product2TestInsert = new List<Product2>();
        
        //CAS 1 energie = Gaz
        Product2 product2TestGaz = new Product2();
        product2TestGaz.Family = 'GBUKF3_P';
        product2TestGaz.ProductCode = '1';
        product2TestGaz.vlocity_cmt__Type__c = 'Gaz';
        product2TestGaz.Name = 'TESTGAZ';
        product2TestGaz.IsActive = true;
        
        Product2TestInsert.add(product2TestGaz);  
        
        //CAS 2 energie = Elec
        Product2 product2TestElec = new Product2();
        product2TestElec.Family = 'GBUKF3_P';
        product2TestElec.ProductCode = '1';
        product2TestElec.vlocity_cmt__Type__c = 'Elec';
        product2TestElec.SM_structureMesureFournisseur__c = 'STR_MESURE_SIMPLE';
        product2TestElec.Name = 'TESTELEC';
        product2TestElec.IsActive = true;
        
        product2TestInsert.add(product2TestElec);
        
        Product2 product2TestDuo = new Product2();
        product2TestDuo.Family = 'GBUKF3_P';
        product2TestDuo.ProductCode = '1';
        product2TestDuo.vlocity_cmt__Type__c = 'Duo';
        product2TestDuo.SM_structureMesureFournisseur__c = '';
        product2TestDuo.Name = 'TESTDUO';
        product2TestDuo.IsActive = true;
        
        product2TestInsert.add(product2TestDuo);
        
        insert product2TestInsert;  
        
        //INSERT PARCOURS
        List<VI_Parcours__c> parcrousTestListInsert = new List<VI_Parcours__c>();
        
        //CAS 1 parcours.VI_ChoixEstimation__c == 'Estimer la consommation d\'énergie'
        VI_Parcours__c parcrousTest = creerParcours('EM','Estimer la consommation d\'énergie','Electricité','PARIS','75110','111111111111','111111111111',
                                                    'Entre 1975 et 1988','Electricité','Collectif','Individuel','Individuel','Principale','Fioul','3',20,
                                                    '75010','1','Fioul');
        VI_Parcours__c parcrousTest3 = creerParcours('EM','Estimer la consommation d\'énergie','Gaz','PARIS','75110','111111111111','111111111111',
                                                     'Entre 1975 et 1988','Gaz','Collectif','Individuel','Individuel','Principale','Fioul','3',20,
                                                     '75011','1','Fioul');
        VI_Parcours__c parcrousTest4 = creerParcours('EM','Estimer la consommation d\'énergie','Electricité + Gaz','PARIS','75110','111111111111','111111111111',
                                                     'Entre 1975 et 1988','	Electricité + Gaz','Collectif','Individuel','Individuel','Principale','Fioul','3',20,
                                                     '75011','1','Fioul');
        
        //CAS 2 parcours.VI_ChoixEstimation__c == 'Saisir la consommation d\'énergie'
        VI_Parcours__c parcrousTest2 = VI_TestDataFactory.createParcours('EM', null, 'PURE PLAYERS');
        parcrousTest2.VI_ChoixEstimation__c = 'VI_idDocumentCPV__c';
        parcrousTest2.VI_ChoixEnergie__c = 'Gaz';
        
        parcrousTest2.VI_CodePostalRechercheLocal__c = '75010';
        parcrousTest2.VI_CommuneRechercheLocal__c = 'PARIS';
        parcrousTest2.VI_CodeCommuneIdentificationLocal__c = '75015';
        parcrousTest2.VI_PDLRechercheLocal__c = '111111111111';
        parcrousTest2.VI_PCERechercheLocal__c = '111111111111';
        parcrousTest2.VI_AnneeConstructionLogementSaisieConso__c = 'Entre 1975 et 1988';
        parcrousTest2.VI_EnergieChauffageSaisieConso__c = 'Electricité';
        parcrousTest2.VI_DispositifEauChaudeSaisieConso__c = 'Collectif';
        parcrousTest2.VI_DispositifChauffageSaisieConso__c = 'Individuel';
        parcrousTest2.VI_TypeLogementSaisieConso__c = 'Individuel';
        parcrousTest2.VI_TypeResidenceSaisieConso__c = 'Principale';
        parcrousTest2.VI_EnergieCuissonSaisieConso__c = 'Fioul';
        parcrousTest2.VI_NombreOccupantLogementSaisieConso__c = '3';
        parcrousTest2.VI_SurfaceLogementSaisieConso__c = 20;
        parcrousTest2.VI_CodePostalRechercheLocal__c = '75020';
        parcrousTest2.VI_SaisieEstimationConsoElec_HP_HC__c = '1';
        parcrousTest2.VI_EnergieEauChaudeSaisieConso__c = 'Fioul';
        
        VI_Parcours__c parcrousTest5 = VI_TestDataFactory.createParcours('EM', null, 'PURE PLAYERS');
        parcrousTest5.VI_ChoixEstimation__c = 'Saisir la consommation d\'énergie';
        parcrousTest5.VI_ChoixEnergie__c = 'Gaz';
        parcrousTest5.VI_CodePostalRechercheLocal__c = '75010';
        parcrousTest5.VI_CommuneRechercheLocal__c = 'PARIS';
        parcrousTest5.VI_CodeCommuneIdentificationLocal__c = '75015';
        parcrousTest5.VI_PDLRechercheLocal__c = '111111111111';
        parcrousTest5.VI_PCERechercheLocal__c = '111111111111';
        parcrousTest5.VI_AnneeConstructionLogementSaisieConso__c = 'Entre 1975 et 1988';
        parcrousTest5.VI_EnergieChauffageSaisieConso__c = 'Electricité';
        parcrousTest5.VI_DispositifEauChaudeSaisieConso__c = 'Collectif';
        parcrousTest5.VI_DispositifChauffageSaisieConso__c = 'Individuel';
        parcrousTest5.VI_TypeLogementSaisieConso__c = 'Individuel';
        parcrousTest5.VI_TypeResidenceSaisieConso__c = 'Principale';
        parcrousTest5.VI_EnergieCuissonSaisieConso__c = 'Fioul';
        parcrousTest5.VI_NombreOccupantLogementSaisieConso__c = '3';
        parcrousTest5.VI_SurfaceLogementSaisieConso__c = 20;
        parcrousTest5.VI_CodePostalRechercheLocal__c = '75020';
        parcrousTest5.VI_SaisieEstimationConsoElec_HP_HC__c = '1';
        parcrousTest5.VI_EnergieEauChaudeSaisieConso__c = 'Fioul';
        parcrousTest5.VI_SaisieConsommationElec_HP_HC__c=true;
        parcrousTest5.VI_ConsommationGazKwHSaisieConso__c=5;
        parcrousTest5.VI_SaisieConsommationHeuresPleines__c=5; 
        parcrousTest5.VI_SaisieConsommationHeuresCreuses__c=5; 
        //insert parcrousTestListInsert;
        User u =[Select id, Name from user where Account.Name ='Marketshot'];
        system.debug('testeur name :' + u.Name);
        System.runAs(u){
            // TEST FONCTION
            Test.startTest();
            system.debug('Test Start');
            VI_parcoursOffre_Controller.getOffersOctopusParcours(parcrousTest3);
            VI_parcoursOffre_Controller.getOffersOctopusParcours(parcrousTest2);
            
            VI_parcoursOffre_Controller.getOffersOctopusParcours(parcrousTest4);
            VI_parcoursOffre_Controller.getOffersOctopusParcours(parcrousTest5);
            
            system.debug('Test END');
            Test.stopTest();
        }
    }
    
    @isTest
    static void getOffersOctopusParcoursTest2(){
        List<Parcours_Mapping__c>  listMapInsert = new list<Parcours_Mapping__c>();
        //INSERT ALL MAPPING
        Parcours_Mapping__c mapTest = new Parcours_Mapping__c(Name = 'TESTNAME',
                                                              Field_Name__c = 'VI_AnneeConstructionLogementSaisieConso__c',
                                                              Local_Value__c = '1989_1999',
                                                              API_Value__c = 'Entre 1975 et 1988');
        
        listMapInsert.add(mapTest);
        
        Parcours_Mapping__c mapTest2 = new Parcours_Mapping__c(Name = 'TESTNAME2',
                                                               Field_Name__c = 'VI_EnergieChauffageSaisieConso__c',
                                                               Local_Value__c = '030',
                                                               API_Value__c = 'Electricité');
        
        listMapInsert.add(mapTest2);
        Parcours_Mapping__c mapTest3 = new Parcours_Mapping__c(Name = 'TESTNAME3',
                                                               Field_Name__c = 'VI_DispositifEauChaudeSaisieConso__c',
                                                               Local_Value__c = '010',
                                                               API_Value__c = 'Collectif');
        
        listMapInsert.add(mapTest3);
        Parcours_Mapping__c mapTest4 = new Parcours_Mapping__c(Name = 'TESTNAME4',
                                                               Field_Name__c = 'VI_DispositifChauffageSaisieConso__c',
                                                               Local_Value__c = '030',
                                                               API_Value__c = 'Individuel');
        
        listMapInsert.add(mapTest4);
        Parcours_Mapping__c mapTest5 = new Parcours_Mapping__c(Name = 'TESTNAME5',
                                                               Field_Name__c = 'VI_TypeLogementSaisieConso__c',
                                                               Local_Value__c = '010',
                                                               API_Value__c = 'Individuel');
        
        listMapInsert.add(mapTest5);
        Parcours_Mapping__c mapTest6 = new Parcours_Mapping__c(Name = 'TESTNAME6',
                                                               Field_Name__c = 'VI_TypeResidenceSaisieConso__c',
                                                               Local_Value__c = '010',
                                                               API_Value__c = 'Principale');
        
        listMapInsert.add(mapTest6);
        Parcours_Mapping__c mapTest7 = new Parcours_Mapping__c(Name = 'TESTNAME7',
                                                               Field_Name__c = 'VI_EnergieCuissonSaisieConso__c',
                                                               Local_Value__c = '010',
                                                               API_Value__c = 'Fioul');
        
        listMapInsert.add(mapTest7);
        Parcours_Mapping__c mapTest8 = new Parcours_Mapping__c(Name = 'TESTNAME8',
                                                               Field_Name__c = 'VI_NombreOccupantLogementSaisieConso__c',
                                                               Local_Value__c = '3',
                                                               API_Value__c = '3');
        
        listMapInsert.add(mapTest8);
        Parcours_Mapping__c mapTest9 = new Parcours_Mapping__c(Name = 'TESTNAME9',
                                                               Field_Name__c = 'VI_SurfaceLogementSaisieConso__c',
                                                               Local_Value__c = '20',
                                                               API_Value__c = '20');
        
        listMapInsert.add(mapTest9);
        Parcours_Mapping__c mapTest10 = new Parcours_Mapping__c(Name = 'TESTNAME10',
                                                               Field_Name__c = 'VI_EnergieEauChaudeSaisieConso__c',
                                                               Local_Value__c = '20',
                                                               API_Value__c = '20');
        
        listMapInsert.add(mapTest10);
        insert listMapInsert;
        
        //INSERT Choix_Offre__c
        List<Choix_Offre__c> offreListInsert = new List<Choix_Offre__c>();
        
        //CAS 1 energie = Gaz
        Choix_Offre__c offreTestGaz = new Choix_Offre__c();
        
        offreTestGaz.Energie__c = 'Gaz';
        offreTestGaz.OffrePousse__c = 'GBUKF3_P';
        offreTestGaz.offreRepli__c = 'GBUKF3_P';
        offreTestGaz.Contexte_de_souscription__c = 'PP-EM';
        offreTestGaz.Actif__c = true;
        offreListInsert.add(offreTestGaz);  
        
        //CAS 2 energie = Elec
        Choix_Offre__c offreTestElec = new Choix_Offre__c();
        offreTestElec.Energie__c = 'Elec';
        offreTestElec.OffrePousse__c = 'GBUKF3_P';
        offreTestElec.offreRepli__c = 'GBUKF3_P';
        offreTestElec.Contexte_de_souscription__c = 'PP-EM';
        offreTestElec.Actif__c = true;
        offreListInsert.add(offreTestElec);  
        
        //CAS 3 energie = Gaz TRADEOFF
        Choix_Offre__c offreTestGazTradeoff = new Choix_Offre__c();
        offreTestGazTradeoff.Energie__c = 'Gaz';
        offreTestGazTradeoff.offreRepli__c = 'GBUKF3_P';
        offreTestGazTradeoff.Contexte_de_souscription__c = 'PP-EM';
        offreTestGazTradeoff.Actif__c = true;
        offreListInsert.add(offreTestGazTradeoff);  
        
        //CAS 4 energie = Elec TRADEOFF
        Choix_Offre__c offreTestElecTradeoff = new Choix_Offre__c();
        offreTestElecTradeoff.Energie__c = 'Elec';

        offreTestElecTradeoff.offreRepli__c = 'GBUKF3_P';
        offreTestElecTradeoff.Contexte_de_souscription__c = 'PP-EM';
        offreTestElecTradeoff.Actif__c = true;
        offreListInsert.add(offreTestElecTradeoff);  
        
        
        insert offreListInsert;
        
        Account Partner =[Select id, Name from Account where Account.Name ='Marketshot'];
        List<VI_JonctionChoixOffre_Compte__c> jonctionOffreCompte = new List<VI_JonctionChoixOffre_Compte__c>();
        
        VI_JonctionChoixOffre_Compte__c Jonction1 = new VI_JonctionChoixOffre_Compte__c();
        Jonction1.Partenaire__c = Partner.id;
        Jonction1.VI_ChoixOffre__c = offreTestGaz.id;
        jonctionOffreCompte.add(Jonction1);
        
        VI_JonctionChoixOffre_Compte__c Jonction2 = new VI_JonctionChoixOffre_Compte__c();
        Jonction2.Partenaire__c = Partner.id;
        Jonction2.VI_ChoixOffre__c = offreTestElec.id;
        jonctionOffreCompte.add(Jonction2);
        
        VI_JonctionChoixOffre_Compte__c Jonction3 = new VI_JonctionChoixOffre_Compte__c();
        Jonction3.Partenaire__c = Partner.id;
        Jonction3.VI_ChoixOffre__c = offreTestGazTradeoff.id;
        jonctionOffreCompte.add(Jonction3);
        
        VI_JonctionChoixOffre_Compte__c Jonction4 = new VI_JonctionChoixOffre_Compte__c();
        Jonction4.Partenaire__c = Partner.id;
        Jonction4.VI_ChoixOffre__c = offreTestElecTradeoff.id;
        jonctionOffreCompte.add(Jonction4);
        
        
        insert jonctionOffreCompte;
        
        //INSERT Product2
        List<Product2> product2TestInsert = new List<Product2>();
        
        //CAS 1 energie = Gaz
        Product2 product2TestGaz = new Product2();
        product2TestGaz.Family = 'GBUKF3_P';
        product2TestGaz.ProductCode = '1';
        product2TestGaz.vlocity_cmt__Type__c = 'Gaz';
        product2TestGaz.Name = 'TESTGAZ';
        product2TestGaz.IsActive = true;
        
        // Product2TestInsert.add(product2TestGaz);  
        
        //CAS 2 energie = Elec
        Product2 product2TestElec = new Product2();
        product2TestElec.Family = 'GBUKF3_P';
        product2TestElec.ProductCode = '1';
        product2TestElec.vlocity_cmt__Type__c = 'Elec';
        product2TestElec.SM_structureMesureFournisseur__c = 'STR_MESURE_SIMPLE';
        product2TestElec.Name = 'TESTELEC';
        product2TestElec.IsActive = true;
        product2TestElec.TypeOffre__c='TradeOFF';
        
        //CAS 1 energie = Gaz Tradeoff
        Product2 product2TestGazTradeoff = new Product2();
        product2TestGazTradeoff.Family = 'GBUKF3_P';
        product2TestGazTradeoff.ProductCode = '2';
        product2TestGazTradeoff.vlocity_cmt__Type__c = 'Gaz';
        product2TestGazTradeoff.Name = 'TESTGAZTRADEOFF';
        product2TestGazTradeoff.IsActive = true;
        product2TestGazTradeoff.TypeOffre__c='TradeOFF';
        
        product2TestInsert.add(product2TestElec);  
        product2TestInsert.add(product2TestGazTradeoff);  
        
        insert product2TestInsert;  
        
        //INSERT PARCOURS
        List<VI_Parcours__c> parcrousTestListInsert = new List<VI_Parcours__c>();
        
        VI_Parcours__c parcrousTest4 = creerParcours('EM','Estimer la consommation d\'énergie','Gaz','PARIS','75110','111111111111','111111111111',
                                                     'Entre 1975 et 1988','Gaz','Collectif','Individuel','Individuel','Principale','Fioul','3',20,
                                                     '75012','1','Fioul');
        VI_Parcours__c parcrousTest5 = creerParcours('EM','Estimer la consommation d\'énergie','Gaz','PARIS','75110','111111111111','111111111111',
                                                     'Entre 1975 et 1988','Gaz','Collectif','Individuel','Individuel','Principale','Fioul','3',20,
                                                     '75013','1','Fioul');
        VI_Parcours__c parcrousTest6 = creerParcours('EM','Estimer la consommation d\'énergie','Gaz','PARIS','75110','111111111111','111111111111',
                                                     'Entre 1975 et 1988','Gaz','Collectif','Individuel','Individuel','Principale','Fioul','3',20,
                                                     '75014','1','Fioul');
        VI_Parcours__c parcrousTest7 = creerParcours('EM','Estimer la consommation d\'énergie','Gaz','PARIS','75110','111111111111','111111111111',
                                                     'Entre 1975 et 1988','Gaz','Collectif','Individuel','Individuel','Principale','Fioul','3',20,
                                                     '75015','1','Fioul');
        VI_Parcours__c parcrousTest8 = creerParcours('EM','Estimer la consommation d\'énergie','Gaz','PARIS','75110','111111111111','111111111111',
                                                     'Entre 1975 et 1988','Gaz','Collectif','Individuel','Individuel','Principale','Fioul','3',20,
                                                     '75016','1','Fioul');
        VI_Parcours__c parcrousTest9 = creerParcours('EM','Estimer la consommation d\'énergie','Gaz','PARIS','75110','111111111111','111111111111',
                                                     'Entre 1975 et 1988','Gaz','Collectif','Individuel','Individuel','Principale','Fioul','3',20,
                                                     '75017','1','Fioul');
        VI_Parcours__c parcrousTest10 = creerParcours('EM','Estimer la consommation d\'énergie','Gaz',null,'75110','111111111111','111111111111',
                                                     'Entre 1975 et 1988','Gaz','Collectif','Individuel','Individuel','Principale','Fioul','3',20,
                                                     '75017','1','Fioul');
        VI_Parcours__c parcrousElecTest = creerParcours('EM','Estimer la consommation d\'énergie','Electricité','PARIS','75110','111111111111','111111111111',
                                                        'Entre 1975 et 1988','Electricité','Collectif','Individuel','Individuel','Principale','Fioul','3',20,
                                                        '75020','1','Fioul');
        VI_Parcours__c parcrousElecTest1 = creerParcours('EM','Estimer la consommation d\'énergie','Electricité','PARIS','75110','111111111111','111111111111',
                                                         'Entre 1975 et 1988','Electricité','Collectif','Individuel','Individuel','Principale','Fioul','3',20,
                                                         '75021','1','Fioul');
        VI_Parcours__c parcrousElecTest2 = creerParcours('EM','Estimer la consommation d\'énergie','Electricité','PARIS','75110','111111111111','111111111111',
                                                         'Entre 1975 et 1988','Electricité','Collectif','Individuel','Individuel','Principale','Fioul','3',20,
                                                         '75022','1','Fioul');
        VI_Parcours__c parcrousElecTest3 = creerParcours('EM','Estimer la consommation d\'énergie','Electricité','PARIS','75110','111111111111','111111111111',
                                                         'Entre 1975 et 1988','Electricité','Collectif','Individuel','Individuel','Principale','Fioul','3',20,
                                                         '75023','1','Fioul');
        VI_Parcours__c parcrousElecTest4 = creerParcours('EM','Estimer la consommation d\'énergie','Electricité','PARIS','75110','111111111111','111111111111',
                                                         'Entre 1975 et 1988','Electricité','Collectif','Individuel','Individuel','Principale','Fioul','3',20,
                                                         '75024','1','Fioul');
        VI_Parcours__c parcrousElecTest5 = creerParcours('EM','Estimer la consommation d\'énergie','Electricité','PARIS','75110','111111111111','111111111111',
                                                         'Entre 1975 et 1988','Electricité','Collectif','Individuel','Individuel','Principale','Fioul','3',20,
                                                         '75025','1','Fioul');
        
        User u =[Select id, Name from user where Account.Name ='Marketshot'];
        system.debug('testeur name :' + u.Name);
        System.runAs(u){
            // TEST FONCTION
            Test.startTest();
            system.debug('Test Start');
            List<Product2> Products=[SELECT id,Family,SM_structureMesureFournisseur__c,ArticleURL__c, ProductCode,offreVerte__c, TypeOffre__c, FamilyLabel__c,Name,vlocity_cmt__Type__c from product2];
            system.debug('Products2 '+Products);
            VI_parcoursOffre_Controller.getOffersOctopusParcours(parcrousTest4);
            //VI_parcoursOffre_Controller.getOffersOctopusParcours(parcrousTest5);
            VI_parcoursOffre_Controller.getOffersOctopusParcours(parcrousTest6);
            VI_parcoursOffre_Controller.getOffersOctopusParcours(parcrousTest7);
            VI_parcoursOffre_Controller.getOffersOctopusParcours(parcrousTest8);
            VI_parcoursOffre_Controller.getOffersOctopusParcours(parcrousTest9);
            VI_parcoursOffre_Controller.getOffersOctopusParcours(parcrousTest10);
            VI_parcoursOffre_Controller.getOffersOctopusParcours(parcrousElecTest);
            VI_parcoursOffre_Controller.getOffersOctopusParcours(parcrousElecTest1);
            VI_parcoursOffre_Controller.getOffersOctopusParcours(parcrousElecTest2);
            VI_parcoursOffre_Controller.getOffersOctopusParcours(parcrousElecTest3);
            VI_parcoursOffre_Controller.getOffersOctopusParcours(parcrousElecTest4);
            VI_parcoursOffre_Controller.getOffersOctopusParcours(parcrousElecTest5);
            
            
            
            system.debug('Test END');
            Test.stopTest();
        }
    }
    
    
    
    @isTest
    static void testMethodCalculate(){
        User u =[Select id from user where firstname='Test' and lastname='Test' and isActive=true limit 1];
        System.runAs(u){
            TEST.startTest();
            VI_parcoursOffre_Controller.calculatePrixMensuel(1,1,1);
            VI_parcoursOffre_Controller.calculatePrixMensuel(1,1,1,1,1);
            VI_parcoursOffre_Controller.calculatePrixMensuel(1,1,1,1,null);
            TEST.StopTest();
        }
    }
    
    @isTest
    static void createContactX(){
        Contact con=new Contact(firstname='abc',lastname='def');
        con.RecordTypeId = Contact.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Contact_Smile').getRecordTypeId();

        VI_parcoursOffre_Controller.ContactX c=new  VI_parcoursOffre_Controller.ContactX(con);
        VI_Parcours__c parcrousTest = creerParcours('EM','Estimer la consommation d\'énergie','Electricité','PARIS','75110','111111111111','111111111111',
                                                    'Entre 1975 et 1988','Electricité','Collectif','Individuel','Individuel','Principale','Fioul','3',20,
                                                    '75010','1','Fioul');
        insert con;
        parcrousTest.VI_Contact__c=con.Id;
        VI_parcoursOffre_Controller.getInfoSelectedContact(parcrousTest);
        
    }
    
    public static VI_Parcours__c creerParcours(String choixParcours,String choixEstimation,String choixEnergie,String commune,
                                               String codeCommune,String PDL,String PCE,String annee,String chauffagesaisie,
                                               String eauchaude,String dispochauffage,string logement,String residence,String cuisson,
                                               String occupant,Double surface,String codeRecherche,String saisieEst,String EauChaudeSaisie)
    {
        VI_Parcours__c parcrousTest2 = VI_TestDataFactory.createParcours(choixParcours, null, 'PURE PLAYERS');
        parcrousTest2.VI_ChoixParcours__c = choixParcours;
        parcrousTest2.VI_ChoixEstimation__c = choixEstimation;
        parcrousTest2.VI_ChoixEnergie__c = choixEnergie;
        parcrousTest2.VI_CommuneRechercheLocal__c = commune;
        parcrousTest2.VI_CodeCommuneIdentificationLocal__c = codeCommune;
        parcrousTest2.VI_PDLRechercheLocal__c = PDL;
        parcrousTest2.VI_PCERechercheLocal__c = PCE;
        parcrousTest2.VI_AnneeConstructionLogementSaisieConso__c = annee;
        parcrousTest2.VI_EnergieChauffageSaisieConso__c = chauffagesaisie;
        parcrousTest2.VI_DispositifEauChaudeSaisieConso__c = eauchaude;
        parcrousTest2.VI_DispositifChauffageSaisieConso__c = dispochauffage;
        parcrousTest2.VI_TypeLogementSaisieConso__c = logement;
        parcrousTest2.VI_TypeResidenceSaisieConso__c = residence;
        parcrousTest2.VI_EnergieCuissonSaisieConso__c = cuisson;
        parcrousTest2.VI_NombreOccupantLogementSaisieConso__c = occupant; 
        parcrousTest2.VI_SurfaceLogementSaisieConso__c =surface;
        
        parcrousTest2.VI_CodePostalRechercheLocal__c = codeRecherche;
        parcrousTest2.VI_SaisieEstimationConsoElec_HP_HC__c = saisieEst;
        parcrousTest2.VI_EnergieEauChaudeSaisieConso__c = EauChaudeSaisie;
        
        return parcrousTest2;
    }
    
    public static Choix_Offre__c createChoixOffre (String energie,String offrepousse,String offrerepli,String contexte,Boolean actif){
        Choix_Offre__c co=new Choix_Offre__c();
        co.Energie__c = 'Gaz';
        co.OffrePousse__c = 'GBUKF3_P';
        co.offreRepli__c = 'GBUKF3_P';
        co.Contexte_de_souscription__c = 'PP-EM';
        co.Actif__c = true;
        return co;
    }
}