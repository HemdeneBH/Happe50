/*
* @Author: Paul Ghoussoub
*@Description: Classe de test de VI_parcoursConso_Controller
*@CreatedDate: 28/1/2021
*/
@isTest
public class VI_parcoursConso_Test {
    @testSetup
    static void testSetup(){
        List<Group> ownerQueue = [Select Id,DeveloperName from Group where Type = 'Queue'];
        
        system.debug('query queue '+ownerQueue);
        Id profileId = [Select Id From Profile Where Name ='VI_PurePlayer'].Id;
        Account acc = VI_TestUtility.createAccount('Marketshot');
        insert acc;
        Contact con = VI_TestUtility.createContact('test','Contact','test@gmail.com',acc.Id);
        insert con;
        User u = VI_TestUtility.createCommunityUser(con.Id,profileId,'Test','Test');
        u.isActive=true;
        insert u;
    }
    @isTest
    static void getEstimationGazTest(){
        User u =[Select id from user where firstname='Test' and lastname='Test' and isActive=true limit 1];
        System.runAs(u){
            Test.startTest();
            System.assertEquals(VI_parcoursConso_Controller.getEstimationGaz('1989_1999','75015','010','010',3,11,'030','030','010','010','010'),1000);
            Test.stopTest();
        }
    }
    
    @isTest
    static void getEstimationElecTest(){
        User u =[Select id from user where firstname='Test' and lastname='Test' and isActive=true limit 1];
        System.runAs(u){
            Test.startTest();
            System.assertEquals(VI_parcoursConso_Controller.getEstimationElec('1989_1999','75015','010','030',3,11,'010','030','010','010','010', true, true, true, true),4415);
            Test.stopTest();
        }
    }
    
    @isTest
    static void getEstimationElecHPHCTest(){
        User u =[Select id from user where firstname='Test' and lastname='Test' and isActive=true limit 1];
        System.runAs(u){
            Test.startTest();
            VI_SM017_PreconiserRepartitionHPHCConso.EstimationHPHC responsTest = VI_parcoursConso_Controller.getEstimationElecHPHC('010','030','010','030');
            System.assertNotEquals(responsTest.cleRepartitionHC,null);
            System.assertNotEquals(responsTest.cleRepartitionHP,null);
            Test.stopTest();
        }
    }
    
    @isTest
    static void getEstimationElecHPHCWETest(){
        User u =[Select id from user where firstname='Test' and lastname='Test' and isActive=true limit 1];
        System.runAs(u){
            Test.startTest();
            VI_SM018_Preconiser3cadransConso.Estimation3Cadrans responsTest = VI_parcoursConso_Controller.getEstimationElecHPHCWE('010','030','010','030');
            
            System.assertNotEquals(responsTest.cleHC,null);
            System.assertNotEquals(responsTest.cleHP,null);
            System.assertNotEquals(responsTest.cleWE,null);
            Test.stopTest();
        }
    }
    
    @isTest
    static void getCustomSettingsTest(){
        Parcours_Mapping__c mapTest = new Parcours_Mapping__c();
        mapTest.Name = 'TESTNAME';
        mapTest.Field_Name__c = 'testName';
        mapTest.Local_Value__c = '10';
        mapTest.API_Value__c = '50';
        
        insert mapTest;
        
        Map<String, String> keyValue = new Map<String, String>();
        keyValue.put('50', '10');
        Map<String, Map<String, String>> parcoursMappings = new Map<String, Map<String, String>>();
        parcoursMappings.put('testName', keyValue);
        User u =[Select id from user where firstname='Test' and lastname='Test' and isActive=true limit 1];
        System.runAs(u){
            Test.startTest();
            System.assertEquals(VI_parcoursConso_Controller.getCustomSettings(), parcoursMappings);
            Test.stopTest();
        }
    }
    
    @isTest
    static void getEstimationLWCTest(){
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
                                                               Local_Value__c = '020',
                                                               API_Value__c = 'Electricité');
        
        listMapInsert.add(mapTest10);
        insert listMapInsert;
        
        VI_Parcours__c parcrousTest2 = VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
        parcrousTest2.VI_AnneeConstructionLogementSaisieConso__c = 'Entre 1975 et 1988';
        parcrousTest2.VI_EnergieChauffageSaisieConso__c = 'Electricité';
        parcrousTest2.VI_EnergieEauChaudeSaisieConso__c = 'Electricité';
        parcrousTest2.VI_DispositifEauChaudeSaisieConso__c = 'Collectif';
        parcrousTest2.VI_DispositifChauffageSaisieConso__c = 'Individuel';
        parcrousTest2.VI_TypeLogementSaisieConso__c = 'Individuel';
        parcrousTest2.VI_TypeResidenceSaisieConso__c = 'Principale';
        parcrousTest2.VI_EnergieCuissonSaisieConso__c = 'Fioul';
        parcrousTest2.VI_NombreOccupantLogementSaisieConso__c = '3';
        parcrousTest2.VI_SurfaceLogementSaisieConso__c = 20;
        parcrousTest2.VI_SaisieConsommationElec_HP_HC__c = true;
        parcrousTest2.VI_CodePostalRechercheLocal__c = '75015';
        
        insert parcrousTest2;   
        User u =[Select id from user where firstname='Test' and lastname='Test' and isActive=true limit 1];
        System.runAs(u){
            TEST.startTest();
            
            VI_parcoursConso_Controller.ConsoResponse responsTest = VI_parcoursConso_Controller.getEstimationLWC(parcrousTest2);
            
            System.assertNotEquals(responsTest.parcours.VI_Estimation_conso_gaz__c,null);
            System.assertNotEquals(responsTest.parcours.VI_Estimation_conso_elec_HP__c,null);
            System.assertNotEquals(responsTest.parcours.VI_Estimation_conso_elec_HC__c,null);
            
            TEST.StopTest();
        }
    }   
}