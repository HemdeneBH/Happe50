/**
 * @File Name          : HP_APIHourContractPortfolio.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 27/02/2020 à 16:50:37
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/02/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class HP_APIHourContractPortfolio  {
	public static final String XDATA_IDPERSONNE_FIELD = 'idPersonne';
	private static final String XDATA_HAPPE_BRAND_CODE = 'HAP';
	private static final String XDATA_DEFAULT_BILL_CODE = '0002';//Ma facture en ligne + sms

	private static final Map<String, String> XDATA_BILLING_METHOD_BY_BILLING_METHOD = new Map<String, String>{
		'TRANSFER' => '5',
		'BANK_CARD' => '6'
	};
	private static final Map<String, String> XDATA_BILLING_PERIODICITY_BY_BILLING_PERIODICITY = new Map<String, String>{
		'MONTHLY' => 'A',
		'BIMONTHLY' => 'B'
	};

	public Integer id;
	public Integer idPersonne;
	// public Integer idLocal; // not available in v 0.3
	public Integer idPersonneDivergentPayeur;
	public Integer idPersonneDivergentRelance;
	public Integer idPersonneDivergentPaiement;
	public Integer idCoordonneeBancaireEncaissement;
	public Integer idCoordonneeBancaireDecaissement;
	public String libelle;
	public String codeFactureEnLigne;
	public String codeModeEncaissement;
	public String codeRythmeFacturation;
	public String codeMarque;

	/*public HP_ContractPortfolio toCoreType() {
		return new HP_ContractPortfolio(
			this.id,
			this.idPersonne,
			//this.idLocal,
			this.idCoordonneeBancaireEncaissement,
			this.libelle,
			this.codeModeEncaissement,
			this.codeRythmeFacturation
		);
	}*/

	//HAPP-371 idCoordonneeBancaireEncaissement = 0 et idCoordonneeBancaireDecaissement = 0 (solution temporaire par APIHour car l'ID coordonneesBancaire est obligatoire à renseigner)
	public HP_APIHourContractPortfolio(final HP_ContractPortfolio contractPortfolio) {
		this.id = contractPortfolio.xdataId;
		this.idPersonne = contractPortfolio.xdataPersonId;
		this.libelle = contractPortfolio.label;
		this.codeModeEncaissement = XDATA_BILLING_METHOD_BY_BILLING_METHOD.get(contractPortfolio.billingMethod);
		this.codeRythmeFacturation = XDATA_BILLING_PERIODICITY_BY_BILLING_PERIODICITY.get(contractPortfolio.billingPeriodicity);
		this.idCoordonneeBancaireEncaissement = ((contractPortfolio.xdataIncommingBankDetailsId == null)? (0) : (contractPortfolio.xdataIncommingBankDetailsId));
		//DEFAULT values
		this.codeFactureEnLigne = XDATA_DEFAULT_BILL_CODE;//Mandatory, should be removed
		this.idPersonneDivergentPayeur = this.idPersonne;
		this.idPersonneDivergentRelance = this.idPersonne;
		this.idPersonneDivergentPaiement = this.idPersonne;
		this.idCoordonneeBancaireDecaissement = 0;
		this.codeMarque = XDATA_HAPPE_BRAND_CODE;
	}
}