/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   06-04-2021   Antoine Latour   Initial Version
**/
@IsTest
public with sharing class HP_SM059_SouscriptionRappel_TEST {
      
    @testSetup static void dataSetup(){
        Account acc = (Account)HP_UTIL_SmartFactory.createSObject('Account','HP_Account' ,new Map<String, Object>{
            'HP_XDataExternalId__c' => 100166,
            'Name' => 'UnitTest',
            'OwnerId' => UserInfo.getUserId()
        },null,null, null);
        insert acc;




        Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact','HP_Contact', new Map<String, Object>{
            'HP_IsHappe__c' => true,
            'Email'=>'test@email.com',
            'LastName' => 'LastName Test',
            'Id_Tiers__c' => 195464
        }, null, null, new List<String>{'AccountId'});
        insert contact;




        Case mailCase = (Case) HP_UTIL_SmartFactory.createSObject('Case', new Map<String, Object> {
            'Description' => 'Description Test',
            'Subject' => 'TEST',
            'HP_Type__c' => 'HP_RappelLeadNonSigne',
            'RecordTypeId' => HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone'),
            'OwnerId' => UserInfo.getUserId(),
            'Status' => 'TO_DO'}, null);
        insert mailCase;

        HP_AppelsSortants__c appelSortant = (HP_AppelsSortants__c) HP_UTIL_SmartFactory.createSObject('HP_AppelsSortants__c', new Map<String, Object> {
            'HP_CaseRappel__c' => mailCase.Id,
            'HP_CommentaireRappel__c' => 'Test Comm',
            'HP_ReponseRappel__c' => 'HP_ReceptionOffreIgnore', 
            'HP_ResultatRappel__c' => 'HP_DemandeRappel'}, null);
        insert appelSortant;

        EmailMessage originMessage = (EmailMessage) HP_UTIL_SmartFactory.createSObject('EmailMessage', new Map<String, Object> {
            'Status' => '3',
            'RelatedToId' => acc.Id,
            'FromAddress' => 'sender@clients.happ-e.fr', 
            'FromName' => 'Dan Perkins', 
            'Subject' =>'This is the Subject!', 
            'HtmlBody' => '<html><body><b>Hello</b></body></html>',
            'ToAddress' => 'emailnotinsalesforce@toexample.com, anotherone@toexample.com',
            'ParentId' => mailCase.Id}, null);
        insert originMessage;
    }

    @isTest
    public static void createRappelCase() {
        List<HP_Souscription__c> souscriptions = new List<HP_Souscription__c>();
        Contact contactTest = [SELECT Id FROM Contact WHERE Id_Tiers__c = 195464];
        
        HP_Souscription__c souscription1 = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
            'HP_Canal_de_vente__c'  => 'Vente Online',
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
            'HP_Souscription_Digital_Id__c' =>'test-rappel-01',
            'HP_Type_Energie__c' =>'COMBINED_GAS_AND_ELECTRICITY',
            'HP_type_Souscription__c' =>'MOVING_IN',
            'HP_NumberPCE__c' =>'31431211214068',
            'HP_NumPDL__c' =>'31431211214170',
            'HP_Statut__c' => 'SAVE_2_CONFIRMED',


            'HP_Contact__c' => contactTest.Id,


            'HP_DigitalDateSave2__c' => Date.today().addDays(-1),
            'OwnerId' => UserInfo.getUserId()}, null);    
    
        souscriptions.add(souscription1);
           
        Test.startTest();
        insert souscriptions;
        HP_SM059_SouscriptionRappel.createRappelCase(souscriptions);
        Test.stopTest();

        Case testCase = [SELECT Id FROM Case WHERE HP_Souscription__c = :souscription1.Id];
    }

    @isTest
    public static void closeOdlCases() {
        List<Case> casesList = [SELECT Id, Status FROM Case WHERE HP_Type__c = 'HP_RappelLeadNonSigne'];
        Test.startTest();
        HP_SM059_SouscriptionRappel.closeOdlCases(casesList);
        Test.stopTest();
        List<Case> resultCases = [SELECT Id, Status FROM Case WHERE HP_Type__c = 'HP_RappelLeadNonSigne'];
        for(Case acase : resultCases) {
            System.assert(acase.Status == 'CLOSED');
        }

    }
}