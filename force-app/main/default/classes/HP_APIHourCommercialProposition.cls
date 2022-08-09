/**
 * @File Name          : HP_APIHourCommercialProposition.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 08-23-2021
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    27/01/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class HP_APIHourCommercialProposition  {//FIXME rename HP_APIHourOpportunity
	private static final String XDATA_HAPPE_PACK_CODE = 'HAPPE_P';
	public static final String XDATA_CONTRACT_PORTFOLIO_ID_FIELD_NAME = 'idPortefeuilleContrat';
	public static final String XDATA_PERSON_ID_FIELD_NAME = 'idPersonne';
	public static final String XDATA_CREATED_DATE = 'dateCreation';

	private static final Map<String, String> OPPORTUNITY_STATUS_BY_XDATA_OPPORTUNITY_STATUS = new Map<String, String>();
	public final static Map<String, String> XDATA_STATUS_BY_STATUS = new Map<String, String> {
		'OpportunitySent' => 'H0001',
		'GeneralTermsAndConditionOfSalesSent' => 'E0005',
		'GeneralTermsAndConditionOfSalesCancelled' => 'H0002',
		'E0010' => 'E0010',
		'AnnulationContrat' => 'H0104',
		'AnnulationPropositionCommerciale' => 'E0002',
		'AwaitingEnergyDistributor' => 'H0101',
		'EnergyDistributorError' => 'H0102'
	};

	static {
		for (String opportunityStatus : XDATA_STATUS_BY_STATUS.keySet()) {
			OPPORTUNITY_STATUS_BY_XDATA_OPPORTUNITY_STATUS.put(XDATA_STATUS_BY_STATUS.get(opportunityStatus), opportunityStatus);
		}
	}

	public Integer id;
	public Integer idPortefeuilleContrat;
	public Integer idPersonne;
	public String codePack;
	public String codeStatutPropositionCommercialeHeader;
	public String libelleStatutPropositionCommercialeHeader;
	public String libellePack;
		public String codeStatutPropositionCommercialePoste;
	public String libelleStatutPropositionCommercialePoste;
	public Integer idProduitOffreService;//HP_SLCT_OpportunityLineItem.EngieProductCode
	public List<Poste> postes;

	public class Poste {
		public Integer idProduitOffreEtService;
		public String codeStatutPropositionCommercialePoste;

		public Poste(final Integer idProduitOffreEtService) {
			this.idProduitOffreEtService = idProduitOffreEtService;
		}
	}

	public HP_APIHourCommercialProposition(final HP_CommercialProposition commercialProposition){
		this.id = commercialProposition.xdataId;
		this.idPortefeuilleContrat = commercialProposition.portfolioContractId;
		this.idPersonne = commercialProposition.personId;
		this.codePack = XDATA_HAPPE_PACK_CODE;
		this.codeStatutPropositionCommercialeHeader = XDATA_STATUS_BY_STATUS.get(commercialProposition.status);
		//verify code offre
		if(!String.isBlank(commercialProposition.productCode)){
			this.postes = new List<Poste> {new Poste( Integer.valueOf(HP_UTIL_CustomSetting.getOffrebyCodeOffre(commercialProposition.productCode).offreId__c))};
		}
		
		this.libelleStatutPropositionCommercialeHeader=commercialProposition.libelleStatutPropositionCommercialeHeader;
		this.libellePack=commercialProposition.libellePack;
		this.codeStatutPropositionCommercialePoste=commercialProposition.codeStatutPropositionCommercialePoste;
		this.libelleStatutPropositionCommercialePoste=commercialProposition.libelleStatutPropositionCommercialePoste;
		this.idProduitOffreService=commercialProposition.productCodeId;
	}


	// Methode non utilisée

/*	public HP_CommercialProposition toCoreType() {
		return new HP_CommercialProposition(
			this.id,
			this.idPortefeuilleContrat,
			this.idPersonne,
			HP_UTIL_CustomSetting.getCodeOffre(this.idProduitOffreService),
			this.idProduitOffreService,
			OPPORTUNITY_STATUS_BY_XDATA_OPPORTUNITY_STATUS.get(this.codeStatutPropositionCommercialeHeader),
			null,
			null,
			this.libelleStatutPropositionCommercialeHeader,
			this.libellePack,
			this.codeStatutPropositionCommercialePoste,
			this.libelleStatutPropositionCommercialePoste

		);
	}*/
}