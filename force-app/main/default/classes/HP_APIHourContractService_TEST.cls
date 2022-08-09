/**
 * @File Name          : HP_APIHourContractService_TEST.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Hemdene Ben Hammouda
 * @Last Modified On   : 08-30-2021
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    14/02/2020   Mouhamadoune Coulibaly     Initial Version
**/
@isTest
public with sharing class HP_APIHourContractService_TEST {
	

	@testSetup static void dataSetup(){
		
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
           
            // offreCode__c,offreId__c,marqueCode__c,packId__c,offreLibelle__c
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
            //'Xdata_Id__c' => '1222',
            'HP_Souscription_Digital_Id__c'=>'testGazElec-01'
        }, null, null, null);
        insert porteFeuille;

        HP_Contrat__c celec =(HP_Contrat__c) HP_UTIL_SmartFactory.createSObject('HP_Contrat__c', 
        new Map<String, Object>{ 
            'HP_Numero_reference_du_Compteur__c' => '423',
            'HP_Id_Compteur__c' => '31431211214170',
            'HP_Compteur_Base_Plan_Index__c' => 56726,
            'HP_Compteur_Variable_Plan_prix_Index__c' => 34251,
            'HP_Compteur_Plan_Bottom_Price_Index__c' => 78098,
            'HP_Contrat_XdataId__c' => 282713,
            'HP_Souscription_Digital_Id__c' => enrolment.HP_Souscription_Digital_Id__c+'ELEC',
            'HP_Proposition_Commerciale_XdataId__c'=>'775949',
            'HP_Souscription__c'=> enrolment.id,
            'HP_Type_de_Compteur__c' => 'ELEC'
        }, null);
        insert celec;
		Prestation_distributeur__c pres = (Prestation_distributeur__c) HP_UTIL_SmartFactory.createSObject('Prestation_distributeur__c','HP_PrestationDistributeur', 
		new Map<String, Object>{
			'Statut__c' => 'En cours',
			'Numero_affaire_distributeur__c' => 'A1234567',
			'Numero_PDL_PCE__c' => '12',
			'Contact__c' => contact.Id,
			'HP_Contrat__c' => celec.Id,
			'HP_Effective_Date__c' => Date.newInstance(2021, 09, 22)}, null, null, null);
		insert pres;
	}
	

     @isTest
	 static void updateContractAsync(){
        HP_UTIL_SmartFactory.insertUserHP();
		System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                       'HP_APIHourAccessTokenResponse_MOCK',
                                                       new Map<String, String> {'Content-Type' => 'application/json'}),
    
                'contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(204,
                                                      null,
                                                      new Map<String, String> { 'Content-Type' => 'application/json'})
            };
    
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
            HP_APIHourContractService.updateContractAsync('282713','E0004','Actif', null);
            Integer callouts =Limits.getAsyncCalls();
            Test.stopTest();
            System.System.assertEquals(1, callouts, 'A callout should be made');
            } 
	}

	@isTest
	 static void updateContractInvokable(){
        HP_UTIL_SmartFactory.insertUserHP();
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                    'HP_APIHourAccessTokenResponse_MOCK',
                                                    new Map<String, String> {'Content-Type' => 'application/json'}),

                'contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(204,
                                                    null,
                                                    new Map<String, String> { 'Content-Type' => 'application/json'})
            };

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
            List<Integer> listIds = new List<Integer>();
            listIds.add(282713);
            HP_APIHourContractService.updateContractStatusAwaitingDistributor(listIds);
            Integer callouts =Limits.getAsyncCalls();
            Test.stopTest();
            System.System.assertEquals(1, callouts, 'A callout should be made'); 
        }
		 
	}

}