/**
 * @File Name          : HP_PrestationController_TEST.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 11-16-2020
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    24/04/2020   Mouhamadoune Coulibaly     Initial Version
**/
@isTEST
public with sharing class HP_SM033_PrestationFluxUpdate_TEST {


    @TestSetUp 
	private static void insertTestData(){

        Case aCase = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_PrestationDistributeur', new Map<String, Object> {
            'Status' => 'NEW_CASE',
            'HP_Energy__c' => 'Electricity',
            'HP_Type__c' => 'HP_AUTOMATED_PROCESS',
            'HP_index_elec_hc__c' => 12345,
            'HP_index_elec_hp__c' =>  67890,
            'HP_index_gaz__c'=> 10,
            'HP_EffectiveDate__c' => date.today().addDays(1),
            'HP_ResiliationModifierStatutAgilab__c' => false
            }, null,null,null);
        insert aCase;

        Prestation_distributeur__c testpresta = (Prestation_distributeur__c)HP_UTIL_SmartFactory.createSObject('Prestation_distributeur__c', 'HP_PrestationDistributeur', new Map<String, Object>{
            'Numero_PDL_PCE__c' => '230492038433',
            'Statut__c' => 'Terminé',
            'Secteur_activite__c' => 'Elec',
            'Situation_de_vente__c'=>'Changement de fournisseur',
            'Numero_affaire_distributeur__c' => 'QL30DPC4',
            'Statut_dernier_jalon__c'=>'CPE',
            'HP_TECH_toNotify__c' => false,
            'Case__c' => aCase.Id
        }, null, null, null);
        insert testpresta;

        Prestation_distributeur__c testpresta1 = (Prestation_distributeur__c)HP_UTIL_SmartFactory.createSObject('Prestation_distributeur__c', 'HP_PrestationDistributeur', new Map<String, Object>{
            'Numero_PDL_PCE__c' => '3993028736467',
            'Statut__c' => 'Terminé',
            'Secteur_activite__c' => 'Gaz',
            'Situation_de_vente__c'=>'Emménagement',
            'Numero_affaire_distributeur__c' => 'QL30DPC5',
            'Statut_dernier_jalon__c'=>'022',
            'HP_TECH_toNotify__c' => false,
            'Case__c' => aCase.Id
        }, null, null, null);
        insert testpresta1;
    }


    @istest
    static void handleUpdatedOPS() {
		
        List <Prestation_distributeur__c> hpUpdatedOps = [Select Id,Situation_de_vente__c,Secteur_activite__c ,Statut__c ,Statut_dernier_jalon__c From Prestation_distributeur__c limit 2];
        Test.startTest();
        List<CMN_OPSinfo> OPSinfosList = new List<CMN_OPSinfo>();
        CMN_OPSinfo OPSinfos_Elec = new CMN_OPSinfo(); 
        OPSinfos_Elec.civiliteIntervenant ='MR';
        OPSinfos_Elec.creneau = 'Matin'; 
        OPSinfos_Elec.datePrestation = '2019-09-10';
        OPSinfos_Elec.idAffaire = 'QL30DPC4'; 
        OPSinfos_Elec.nomIntervenant = 'LENFANT';
        OPSinfos_Elec.numDernierJalon = 4;
        OPSinfos_Elec.prenomIntervenant = 'Nicolas'; 
        OPSinfos_Elec.statutDernierJalon = 'CPNR'; 
        OPSinfos_Elec.statutPrestation ='TERMN' ;
        OPSinfos_Elec.telephoneIntervenant = '0671023504';
        OPSinfos_Elec.typeEnergie = 'Elec';

        OPSinfosList.add(OPSinfos_Elec);

        CMN_OPSinfo OPSinfos_Gaz = new CMN_OPSinfo(); 
        OPSinfos_Gaz.civiliteIntervenant ='1';
        OPSinfos_Gaz.creneau = 'Matin'; 
        OPSinfos_Gaz.datePrestation = '2019-09-10';
        OPSinfos_Gaz.idAffaire = 'QL30DPC5'; 
        OPSinfos_Gaz.nomIntervenant = 'LENFANT';
        OPSinfos_Gaz.numDernierJalon = 2;
        OPSinfos_Gaz.prenomIntervenant = 'Nicolas'; 
        OPSinfos_Gaz.statutDernierJalon = '022'; 
        OPSinfos_Gaz.statutPrestation ='TERMN' ;
        OPSinfos_Gaz.telephoneIntervenant = '0671023504';
        OPSinfos_Gaz.typeEnergie = 'Gaz';

        OPSinfosList.add(OPSinfos_Gaz);

        RestRequest req = new RestRequest(); 	 
		req.requestURI = '/updateOPS';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueof(JSON.serializePretty(new Map<String, Object>{'OPSinfos' => OPSinfosList}));
        RestContext.request = req;

        CMN_OPSUpdate.handleOpsInfos();
        Test.stopTest();
        //System.assert([SELECT count() FROM Case ] == 3, 'Case ELEC and Gas created successfully.');
    }
}