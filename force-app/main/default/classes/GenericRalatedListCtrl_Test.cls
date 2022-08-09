/**
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Name			GenericRalatedListDisplayCtr_Test	
* @Author		Slimene BELHAJ ALI
* @Version		v1.0
* @CreatedDate	19/04/2018
* @UsedBy		
* @TestClass	
* ---------------------------------------------------------------------------------------------------------------------------------------------------	
* @Description
* Testing GenericRalatedListDisplayCtr
* ---------------------------------------------------------------------------------------------------------------------------------------------------	
**/
@isTest
private class GenericRalatedListCtrl_Test {
    
    static testMethod void testLoadDataFromConfig() {
        Account acc = new account(Name = 'Test');
        insert acc;
        




        Contact cont = new Contact(lastName = 'Test', email ='test@test.com');




        cont.AccountId = acc.Id;
        insert cont;
        
        
        Test.startTest();
            Map<String, Object> result = GenericRalatedListCtrl.loadDataFromConfig('LastName','Fields', '', 'Contact', 'AccountId' , acc.Id, null, null,null,'10','1');
    
            System.assertEquals(1, ((List<Object>)result.get('data')).size());
            System.assertEquals(1, ((List<Object>)result.get('columns')).size());

        Test.stopTest();
        
    }
    
    static testMethod void testdeleteRecord() {
         Account acc = new account(Name = 'Test');
        insert acc;
        Id accountId = acc.Id;
        Test.startTest();
        GenericRalatedListCtrl.deleteRecord(accountId, 'Account');
        Integer count = [select count() from Account where Id = :accountId];
        

        System.assertEquals(0 , count);

        Test.stopTest();
    }

    static testMethod void testsouscription() {
        Account acc = new account(Name = 'Test1');
        insert acc;
        

        Contact cont = new Contact(lastName = 'Test1');

        cont.AccountId = acc.Id;
        insert cont;

       HP_Souscription__c enrolment = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
        'HP_Canal_de_vente__c'  => 'Vente Online',
        'HP_Contact__c'=> cont.Id,
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
    HP_Souscription__c enrolment2 = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
        'HP_Canal_de_vente__c'  => 'Vente Online',
        'HP_Contact__c'=> cont.Id,
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
        'HP_Souscription_Digital_Id__c' =>'testGazElec-02',
        'HP_Type_Energie__c' =>'COMBINED_GAS_AND_ELECTRICITY',
        'HP_type_Souscription__c' =>'MOVING_IN',
        'HP_NumberPCE__c' =>'31431211214068',
        'HP_NumPDL__c' =>'31431211214170',
        'HP_Statut__c' =>'SAVE_1',
        'OwnerId' => UserInfo.getUserId()
    }, null);
    insert enrolment2;
    String fieldSetName = 'Name,HP_NumPDL__c,HP_NumberPCE__c,HP_Contact__c,toLabel(HP_Statut__c)';
    String whereClause = 'HP_Statut__c  !=\'CANCEL\' AND HP_Statut__c   !=\'RETRACT\'';
    String searchFilds = 'HP_NumPDL__c,  HP_NumberPCE__c';
       Test.startTest();
       Map<String, Object> result = GenericRalatedListCtrl.loadDataFromConfig(fieldSetName,null, whereClause, 'HP_Souscription__c', 'ID' , enrolment.Id, null, searchFilds,'OR','10','1');
       System.assertEquals(1, ((List<Object>)result.get('data')).size());
            System.assertEquals(5, ((List<Object>)result.get('columns')).size());
       Test.stopTest();
   }
}