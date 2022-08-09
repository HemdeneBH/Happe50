/**
 * @File Name          : HP_SM025_CaseAPI_TEST.cls
 * @Description        : 
 * @Author             : Antoine Latour
 * @Group              : 
 * @Last Modified By   : Hemdene Ben Hammouda
 * @Last Modified On   : 05-30-2022
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    21/08/2020   Antoine Latour     Initial Version
**/
@isTest
public with sharing class HP_EM005_Souscription_TEST {


	private enum StaticResource {
        HP_SM020_SouscriptionSave1_TEST
	}
	

        @testSetup static void dataSetup() {

			HP_PortailCanal__c canal = (HP_PortailCanal__c)HP_UTIL_SmartFactory.createSObject('HP_PortailCanal__c', null, new Map<String, Object>{
				'Name' => 'CRC-ENGIE',
				'Droit_VenteEm__c' => true,
				'Droit_PaiementCB__c' => true,
				'Droit_ParcoursEmDm__c' => true,
				'Droit_VenteChf1Ex__c' => true,
				'Droit_VenteChf2Ex__c' => true,
				'HP_Paiement_prlvt__c' => true,
				'HP_Visu_docs__c' => true,
				'HP_Modif_ventes__c' => true,
				'Droit_VenteEm1Ex__c' => true
			}, null, null, null);
			insert canal;
	
			HP_PortailPrestataire__c presta = (HP_PortailPrestataire__c)HP_UTIL_SmartFactory.createSObject('HP_PortailPrestataire__c', null, new Map<String, Object>{
				'IdPrestataire__c' => 'Happe',
				'Name' => 'Happe',
				'Canal__c' => canal.Id
			}, null, null, null);
	
			insert presta;
			
			HP_PortailUtilisateur__c utilisateur = (HP_PortailUtilisateur__c)HP_UTIL_SmartFactory.createSObject('HP_PortailUtilisateur__c', null, new Map<String, Object>{
				'Login__c'        => 'Hap001@gmail.com',
				'Password__c'     => 'Happ1179!',
				'Role__c'         => 'Conseiller',
				'Prestataire__c'  => presta.Id,
				'Nom__c'			=> 'Test Nom',
				'Prenom__c'		=> 'Test Prénom',
				'Civilite__c'		=> 'Mr'
			}, null, null, null);
			insert utilisateur;

   	 		Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', null, new Map<String, Object> {
            	'FirstName' => 'Contact FirstName',
            	'LastName' => 'Contact Test',
            	'Email' => 'test@gmail.com',
            	'Id_Tiers__c' => 1313}, null, null,null);
        	insert contact;
            
            Contact cocontact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', null, new Map<String, Object> {
            	'FirstName' => 'Contact FirstName',
            	'LastName' => 'Contact Test1',
            	'Email' => 'test1@gmail.com',
            	'Id_Tiers__c' => 1314}, null, null,null);
        	insert cocontact;
            
			HP_Porte_Feuille_Contrat__c porteFeuille = (HP_Porte_Feuille_Contrat__c)HP_UTIL_SmartFactory.createSObject('HP_Porte_Feuille_Contrat__c', null, new Map<String, Object>{
                'HP_Contact__c' => contact.id,
                'Xdata_Id__c' => '1222',
                'HP_Souscription_Digital_Id__c'=>'testGazElec-01',
                'OwnerId' => UserInfo.getUserId()
            }, null, null, null);
            insert porteFeuille;
            
        	HP_Souscription__c enrolment = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
            	'HP_Canal_de_vente__c'  => 'Vente Online',
                'HP_CoContractant__c' => cocontact.Id,
            	'HP_Contact__c'=> contact.Id,
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
            	'HP_Souscription_Digital_Id__c' =>'test-em-souscription',
            	'HP_Type_Energie__c' =>'COMBINED_GAS_AND_ELECTRICITY',
            	'HP_type_Souscription__c' =>'MOVING_IN',
            	'HP_NumberPCE__c' =>'31431211214068',
            	'HP_NumPDL__c' =>'31431211214170',
				'HP_Statut__c' =>'SAVE_2',
				'HP_DigitalLogin__c' => utilisateur.Id,
				'HP_DigitalDateSave2__c' => Datetime.newInstance(2020, 2, 17),
                'HP_Porte_Feuille_Contrat__c' => porteFeuille.Id,
            	'OwnerId' => UserInfo.getUserId()}, null);
			insert enrolment;
			
            
            HP_Contrat__c contract =(HP_Contrat__c) HP_UTIL_SmartFactory.createSObject('HP_Contrat__c', 
            new Map<String, Object>{ 
                'HP_Numero_reference_du_Compteur__c' => '423',
                'HP_Id_Compteur__c' => '31431211214068',
                'HP_Porte_Feuille_Contrat__c' => porteFeuille.Id,
                'HP_Contrat_XdataId__c' => 100148,
                'HP_Souscription_Digital_Id__c' => enrolment.HP_Souscription_Digital_Id__c+'GAS',
                'HP_Proposition_Commerciale_XdataId__c'=>'775949',
                'HP_Souscription__c'=> enrolment.id,
                'HP_Type_de_Compteur__c' => 'GAS',
                'OwnerId' => UserInfo.getUserId()
            }, null);
            insert contract;
        }
    
    @istest static void changeStatus() {
        HP_Souscription__c enrolment = [SELECT Id, HP_Statut__c FROM HP_Souscription__c WHERE HP_Souscription_Digital_Id__c='test-em-souscription'];
        
        System.assertEquals('SAVE_2', enrolment.HP_Statut__c);
        Test.startTest();
        HP_EM005_Souscription.changeStatus(enrolment.Id, 'SAVE_1');
        Test.stopTest();
        
        HP_Souscription__c enrolmentResult = [SELECT Id, HP_Statut__c FROM HP_Souscription__c WHERE HP_Souscription_Digital_Id__c='test-em-souscription'];
        System.assertEquals(enrolment.Id, enrolmentResult.Id);
        System.assertEquals('SAVE_1', enrolmentResult.HP_Statut__c);
    }
    
    @istest static void loadSouscription() {
        HP_Souscription__c enrolment = [SELECT Id FROM HP_Souscription__c WHERE HP_Souscription_Digital_Id__c='test-em-souscription'];
        
        Test.startTest();
        HP_Souscription__c souscription = HP_EM005_Souscription.loadSouscription('test-em-souscription');
        Test.stopTest();
        
        System.assertEquals(enrolment.Id, souscription.Id);
    }
    
    @istest static void loadSouscriptionList() {
        Test.startTest();
        List<HP_Souscription__c> souscriptionList = HP_EM005_Souscription.loadSouscriptionList('test-em-souscription');
        Test.stopTest();
        
        System.assert(souscriptionList.size() > 0);
	}
	
	@istest static void getSouscriptionsForPortailAdmin() {
		HP_PortailUtilisateur__c utilisateur = [SELECT Id,Role__c, Prestataire__r.Canal__r.Name FROM HP_PortailUtilisateur__c WHERE Login__c =:'Hap001@gmail.com' LIMIT 1];
		String contexte = 'lead';
		Datetime startDate = Datetime.newInstance(2020, 2, 16);
		Datetime endDate = Datetime.newInstance(2020, 2, 18);
		
		Test.startTest();
		List<HP_Souscription__c> souscriptionList = HP_EM005_Souscription.getSouscriptionsForPortailAdmin(utilisateur, contexte, startDate, endDate);
		Test.stopTest();

		System.assert(souscriptionList.size() == 1);

	}
    @istest static void loadDataCocontractant() {
        

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'contracts' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                 null,'{"libelleStatutCrm" : "Activé"}',
                 new Map<String, String> {'Content-Type' => 'application/json'}),
                 'solde' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                 null,'{"output" :{"soldes" : {"1222" : 0}}}',
                new Map<String, String> {'Content-Type' => 'application/json'}),
                
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                'HP_APIHourAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'})
                };
		HP_Souscription__c enrolment = [SELECT Id, HP_CoContractant__c FROM HP_Souscription__c WHERE HP_Souscription_Digital_Id__c='test-em-souscription'];
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
		HP_SM012_Souscription.loadDataCocontractant(enrolment.HP_CoContractant__c);
		Test.stopTest();
	}


	@istest static void saveSouscription() {
		final String enrolmentRestResourceSave1Json = HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(StaticResource.HP_SM020_SouscriptionSave1_TEST.name());
		HP_EnrolmentRestResourceModel enrolmentReq = (HP_EnrolmentRestResourceModel) JSON.deserialize(enrolmentRestResourceSave1Json, HP_EnrolmentRestResourceModel.class);		
	
		Test.startTest();
		String result = HP_EM005_Souscription.saveSouscription(enrolmentReq.selfcareLead.firstSave_v0_1);
		Test.stopTest();

		System.assert(result != null, 'Error');
	}

	
	@istest static void getSouscriptionsInfos() {
		List<String> souscriptionList = new List<String>{'test-em-souscription'};

		Test.startTest();
		List<HP_Souscription__c> result = HP_EM005_Souscription.getSouscriptionsInfos(souscriptionList);
		Test.stopTest();

		System.assert(result.size() == 1, 'Echec de récupération de la liste de souscription');
	}
	@istest static void soucriptionWithSamePdlPce() {
		Contact cc = [select Id from Contact limit 1];
		Test.startTest();
		List<HP_Souscription__c> result = HP_EM005_Souscription.soucriptionWithSamePdlPce(cc.Id, '31431211214170','HP_NumPDL__c');
		Test.stopTest();
	}
}