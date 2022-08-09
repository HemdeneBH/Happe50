/**
 * @File Name          : HP_APIHourContractService.cls
 * @Description        : 
 * @Author             : mouhamadoune.coulybaly@external.engie.com
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 01-12-2022
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    13/12/2019   mouhamadoune.coulybaly@external.engie.com     Initial Version
**/ 
public with sharing class HP_APIHourContractService  {

	public static final String API_KEY = 'api_key';
	public static final String ID_PORTEFEUILLE_CONTRAT = 'idPortefeuilleContrat';
	public static final String ID_PERSONNE = 'idPersonne';
	public static final String ENDPOINT = 'callout:HP_AuthAPIHour_INT/api/apiset/0.2/contrats';
	public static final String ACTIF = 'ACTIF';
	
	public final static Map<HP_Contract.Status,String> APIHOUR_STATUS_BY_STATUS = new  Map<HP_Contract.Status,String>{
		HP_Contract.Status.AwaitingEnergyDistributor=>'H0101',// En att,ente distributeur	H0101 // HAPP-283
		HP_Contract.Status.EnergyDistributorError=>'H0102',// KO Distributeur	H0102 //HAPP-387
		// Contrat Actif	E0004
		HP_Contract.Status.InCancellation=>'E0007',// En résiliation	E0007
		HP_Contract.Status.Terminated=>'E0009', // Résilié E0009
		HP_Contract.Status.CANCELLATION_NOT_DONE=>'H0102'
	};

	public HP_APIHourContractService(Boolean dummyParamForUpdate) {}

	public HP_APIHourContractService() {}



	@InvocableMethod(label='Update xData contract Status' description='Trigger update contract in xData Status: AwaitingEnergyDistributor.' )
	public static void updateContractStatusAwaitingDistributor(final List<Integer> xDataId){
		if (System.IsBatch() == false  && System.isFuture() == false) {
			if(!xDataId.isEmpty()){
				Date dateFinValidite = [SELECT HP_Effective_Date__c from Prestation_distributeur__c WHERE HP_Contrat__r.HP_Contrat_XdataId__c = :xDataId[0] ORDER BY createdDate DESC LIMIT 1].HP_Effective_Date__c;
				updateContractAsync(String.valueOf(xDataId[0]), APIHOUR_STATUS_BY_STATUS.get(HP_Contract.Status.AwaitingEnergyDistributor), ACTIF, String.valueOf(dateFinValidite));
			}
		}
	}
    
	@future(callout=true)
    public static void updateContractAsync(final String id, final String codeStatutCRM, final String statut, final String dateFinValidite) {
		updateContractSync(id, codeStatutCRM, statut, dateFinValidite);
    }

    public static void updateContractSync(final String id, final String codeStatutCRM, final String statut, final String dateFinValidite) {
        HP_APIHourContractService contractService = new HP_APIHourContractService();//DUMMY
		if(dateFinValidite != null){
			Date endDate = dateFinValidite != null ? date.valueOf(dateFinValidite).toStartOfMonth().addYears(2).addMonths(1).addDays(-1) : null;
			contractService.updateContract(id, codeStatutCRM, statut, String.valueOf(endDate),dateFinValidite,dateFinValidite);
		}else{
			contractService.updateContract(id, codeStatutCRM, statut, dateFinValidite,null,null);
		}
		
        
	}

	//US HAPP-283 
	public void updateContract (String id, String codeStatutCRM, String statut, String dateFinValidite, String dateDebutContrat, String dateDebutValidite) {
		String bodyString = System.JSON.serialize(new HP_ContractToUpdate(codeStatutCRM, statut, dateFinValidite, dateDebutContrat, dateDebutValidite), true);
		HP_UTIL_HTTPUtils.calloutPut(HP_Constantes.XDATA_CONTRATS, bodyString, '/' + id);
	}



	//US HAPP-2072
	@future(callout=true)
	public static void cancelContractAsync(final String id, final String codeStatutCRM, final String statut, final String dateFinValidite) {
		cancelContractSync(id, codeStatutCRM, statut, dateFinValidite);
    }

    public static void cancelContractSync(final String id, final String codeStatutCRM, final String statut, final String dateFinValidite) {
        HP_APIHourContractService contractService = new HP_APIHourContractService();//DUMMY
		if(dateFinValidite != null){
			Date endDate = dateFinValidite != null ? date.valueOf(dateFinValidite) : null;
			contractService.cancelContract(id, codeStatutCRM, statut, String.valueOf(endDate));
		}else{
			contractService.cancelContract(id, codeStatutCRM, statut, dateFinValidite);
		}
		
        
	}

	public void cancelContract (String id, String codeStatutCRM, String statut, String dateFinValidite) {
		String bodyString = System.JSON.serialize(new HP_ContractToUpdate(codeStatutCRM, statut, dateFinValidite), true);
		HP_UTIL_HTTPUtils.calloutPut(HP_Constantes.XDATA_CONTRATS, bodyString, '/' + id);
	}

}