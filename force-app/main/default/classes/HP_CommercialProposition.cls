/**
 * @File Name          : HP_CommercialProposition.cls
 * @Description        : 
 * @Author             : mouhamadoune.coulybaly@external.engie.com
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 11-02-2021
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    16/12/2019   mouhamadoune.coulybaly@external.engie.com     Initial Version
**/
public with sharing class HP_CommercialProposition {

	public enum Status { //TODO add to opportunity stage ?
		OpportunitySent,// Proposition à envoyer	H0001 // HAPP-371
		GeneralTermsAndConditionOfSalesSent,// CPV Envoyées	E0005 // HAPP-371, HAPP-805, HAPP-372
		GeneralTermsAndConditionOfSalesCancelled,// CPV rétractées	H0002 //HAPP-456
		AnnulationContrat,
		AwaitingEnergyDistributor,
		EnergyDistributorError,
		InCancellation,
        Terminated
	}

	public static Map<String, Status> STATUS_BY_NAME = new Map<String, Status>();
	static {
		for (Status status : Status.values()) {
			STATUS_BY_NAME.put(status.name(), status);
		}
	}


	@AuraEnabled
	public final Integer xdataId {get;set;}
	@AuraEnabled
	public final Integer portfolioContractId {get;set;}
	@AuraEnabled
	public final Integer personId {get;set;}
	@AuraEnabled
	public final String libelleStatutPropositionCommercialeHeader {get;set;}
	@AuraEnabled
	public final String libellePack {get;set;}
	@AuraEnabled
	public final String codeStatutPropositionCommercialePoste {get;set;}
	@AuraEnabled
	public final String libelleStatutPropositionCommercialePoste {get;set;}
	public final String status;
	//public final String statusPosteCode;
	public final String productCode;
	@AuraEnabled
	public final Integer productCodeId {get;set;}
	@AuraEnabled
	public final String auraStatus {get;set;}
	@AuraEnabled
	public final String auraProductCode {get;set;}

	public HP_CommercialProposition(Integer xdataId, Integer portfolioContractId, Integer personId, final String productCode, final String status, String libelleStatutPropositionCommercialeHeader,String libellePack) {
		this(xdataId, portfolioContractId, personId, productCode,null, status, null, null,libelleStatutPropositionCommercialeHeader,libellePack,null,null);
	}

	public HP_CommercialProposition(Integer xdataId, Integer portfolioContractId, Integer personId, final String productCode,Integer productCodeId, final String status, final String auraStatus, final String auraProductCode,String libelleStatutPropositionCommercialeHeader,String libellePack,String codeStatutPropositionCommercialePoste,String libelleStatutPropositionCommercialePoste) {
		System.debug('CONSTRUCTEUR');
		this.xdataId = xdataId;
		this.portfolioContractId = portfolioContractId;
		this.personId = personId;
		this.auraProductCode = productCode;
		this.status =status;
		this.auraStatus = status;
		this.libelleStatutPropositionCommercialeHeader=libelleStatutPropositionCommercialeHeader;
		this.libellePack=libellePack;
		this.codeStatutPropositionCommercialePoste=codeStatutPropositionCommercialePoste;
		this.libelleStatutPropositionCommercialePoste=libelleStatutPropositionCommercialePoste;
		this.productCode=productCode;
	}

	public HP_CommercialProposition(Integer portfolioContractId, Integer personId, final String productCode, final String status) {
		this(null, portfolioContractId, personId, productCode,null, status,null,null,null,null,null,null);
	}

	public HP_CommercialProposition(final Integer xdataId, final String status, final String codeStatutPropositionCommercialePoste) {
		this(xdataId, null, null, null,null, status,null,null,null,null,codeStatutPropositionCommercialePoste,null);
	}


	public HP_CommercialProposition(final Integer xdataId, final String status) {
		this(xdataId, null, null, null,null, status,null,null,null,null,null,null);
		// this.statusPosteCode = statusPosteCode;
		//CHECK add productCode?
	}


}