@isTest 
global with sharing class HP_BAT011_NettoyageAttachment_TEST {
  
    @isTest static void launchNewScheduler_TEST(){
        
        HP_Souscription__c souscription = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
            'HP_Canal_de_vente__c'  => 'Vente Online',
            'HP_Code_Electrique_Produit__c'  => 'EITR2_H',
            'HP_Code_postal__c'  => '92160',
            'HP_code_Postal_Insee__c'  => '92002',
            'HP_Date_de_Contractualisation__c'  => Date.newInstance(2019, 12, 22),
            'HP_Date_Origine__c'  =>DateTime.newInstance(2019, 10, 9, 13, 0, 0),
            'HP_Energie_Verte__c'  => false,
            'HP_Estimation_Consommation_electrique__c'  => 6000,
			'HP_Jour_de_facturation__c' => 16,
            'HP_Lien_enregistrement__c' =>'test.fr',
            'HP_Methode_de_paiement__c' =>'BANK_CARD',
            'HP_Montant_de_la_facturation_electrique__c' =>58,
            'HP_Predecesseur__c' =>'Dupont',
            'HP_Nom_de_rue__c' =>'rue des bois',
            'HP_Nom_de_ville__c' =>'ANTONY',
            'HP_Numero_de_voie__c' =>'15 ter',
            'HP_Periode_de_facturation__c' =>'BIMONTHLY',
            'HP_Plan_de_Prix_electrique__c' =>'BASE',
            'HP_Puissance_Compteur_electrique__c' =>6,
            'HP_Souscription_Digital_Id__c' =>'testElec-01',
            'HP_Type_Energie__c' =>'ELECTRICITY',
            'HP_type_Souscription__c' =>'MOVING_IN',
            'HP_NumberPCE__c' =>'31431211214068',
            'HP_NumPDL__c' =>'31431211214170',
            'HP_Statut__c' =>'SAVE_1'
		}, null);
        insert souscription;
        
        Attachment attachmentElec =(Attachment) HP_UTIL_SmartFactory.createSObject('Attachment',new Map<String, Object>{
            'Name'=>'compteur_elec',
            'Body'=>Blob.valueOf('Unit Test Attachment Body'),
            'ContentType' =>'image/jpg',
            'ParentId'=> souscription.Id
        },null);

        System.debug('@@@ Attachment ' + attachmentElec);
        insert attachmentElec;		
        final String jobName = 'HP_SCH011_NettoyageAttachment';
        final String cronExp = '0 0 23 ? * * *';
        Test.startTest();
        HP_BAT011_NettoyageAttachment.launchNewScheduler(cronExp, jobName);
        Test.stopTest();   
    }
    
}