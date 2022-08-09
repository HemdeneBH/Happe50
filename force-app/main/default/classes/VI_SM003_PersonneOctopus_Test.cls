/*
*@Author: Eloi Dereeper
*@Description: Classe test de VI_SM003_PersonneOctopus.
*@CreatedDate: 04/11/2020
*@LastModified: 05/11/2020
*/ 
@isTest
public class VI_SM003_PersonneOctopus_Test { 
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
        insert u;
    } 
    
    @isTest
    public static void TEST_CreerPersonne()
    {
        User u =[Select id from user where firstname='Test' and lastname='Test' limit 1];
        System.runAs(u){
            Test.startTest();
            gdfsuezBefCalypsoPersonneV8.PersonnePort port = VI_SM003_PersonneOctopus.buildPortWSPersonne();
            gdfsuezComBefCalypsoPersonneV8.adresseDt adresse = VI_SM003_PersonneOctopus.prepareAdresse('12', 'test', '92140', 'test', 'test', 'test');
            gdfsuezComBefChpPivotV8.contextDt context = VI_SM003_PersonneOctopus.initContext('VI', '2.0');
            List<gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element> canaux = new List<gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element>();
            canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail('test@test.com', true, 1));
            canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommSimple('TEST', 'TEST'));
            canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommPhone('0128949234', 'TEST', 'TEST', true, 2));
            canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommAdresse('12', 'TEST', '92140', 'TEST', 'TEST', 'TEST', true, 3));
            List<gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element> ProfileMarketing = new List<gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element>();
            ProfileMarketing.add(VI_SM003_PersonneOctopus.prepareProfileMarketing('Designation', 'valeurDesignation'));
            gdfsuezComBefCalypsoPersonneV8.Personne personne = VI_SM003_PersonneOctopus.PreparePersonne('1234567890', adresse, 'test', 'test', 'Mr.', canaux, ProfileMarketing);
            gdfsuezBefCalypsoPersonneV8.creerPersonneInputDt creerPersonneInput = new gdfsuezBefCalypsoPersonneV8.creerPersonneInputDt();
            creerPersonneInput.personne = personne;
            
            gdfsuezBefCalypsoPersonneV8.creerPersonneResponse_element resp=VI_SM003_PersonneOctopus.CreerPersonne(creerPersonneInput,context, port, 'local.VIToken', 'AuthOctopus');   
            system.debug('resp '+resp);
            system.assert(resp.creerPersonneOutput.personne.idPersonne=='1');
            Test.stopTest();
        }
    }
    
    @isTest
    public static void TEST_MajPersonne()
    {
        User u =[Select id from user where firstname='Test' and lastname='Test' limit 1];
        System.runAs(u){
            Test.startTest();
            gdfsuezBefCalypsoPersonneV8.PersonnePort port = VI_SM003_PersonneOctopus.buildPortWSPersonne();
            gdfsuezComBefCalypsoPersonneV8.adresseDt adresse = VI_SM003_PersonneOctopus.prepareAdresse('12', 'test', '92140', 'test', 'test', 'test');
            gdfsuezComBefChpPivotV8.contextDt context = VI_SM003_PersonneOctopus.initContext('VI', '2.0');
            List<gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element> canaux = new List<gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element>();
            canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail('test@test.com', true, 1));
            canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommSimple('TEST', 'TEST'));
            canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommPhone('0128949234', 'TEST', 'TEST', true, 2));
            canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommAdresse('12', 'TEST', '92140', 'TEST', 'TEST', 'TEST', true, 3));
            List<gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element> ProfileMarketing = new List<gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element>();
            ProfileMarketing.add(VI_SM003_PersonneOctopus.prepareProfileMarketing('Designation', 'valeurDesignation'));
            gdfsuezComBefCalypsoPersonneV8.Personne personne = VI_SM003_PersonneOctopus.PreparePersonne( '1234567890','test', 'test', 'Mr.',canaux, ProfileMarketing);
            gdfsuezBefCalypsoPersonneV8.majPersonneInputDt majPersonneInput = new gdfsuezBefCalypsoPersonneV8.majPersonneInputDt();
            majPersonneInput.personne = personne;
            gdfsuezComBefChpPivotV8.retourTraitementMessagesDt retour=VI_SM003_PersonneOctopus.MajPersonne(majPersonneInput,context, port, 'local.VIToken', 'AuthOctopus');
            system.debug('retour '+retour.retourTraitementMessage[0].id);
            system.assert(retour.retourTraitementMessage[0].id=='bf236619-0fa7-4e42-9c9a-62c9e19dcd56');
            system.debug('retour '+retour);
            Test.stopTest();
        }
    }
}