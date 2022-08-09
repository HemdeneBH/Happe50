/**
 * @File Name          : HP_ContractPortfolio.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 10/02/2020 à 16:29:46
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/02/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class HP_ContractPortfolio {
	@AuraEnabled
	public final Integer xdataId {get; set;}
	@AuraEnabled
	public final Integer xdataPersonId {get; set;}
	@AuraEnabled
	public final Integer xdataPremiseId {get; set;}
	@AuraEnabled
	public final Integer xdataIncommingBankDetailsId {get; set;}
	@AuraEnabled
	public final String label {get; set;}
	public final String billingMethod;
	public final String billingPeriodicity;
	@AuraEnabled
	public final String auraBillingMethod {get; set;}
	@AuraEnabled
	public final String auraBillingPeriodicity {get; set;}

	public HP_ContractPortfolio(final Integer xdataId, final Integer xdataPersonId,  final Integer xdataIncommingBankDetailsId) {
		this(xdataId, xdataPersonId, xdataIncommingBankDetailsId, null, null, null);
	}

	public HP_ContractPortfolio(final Integer xdataPersonId, final String label, final String billingMethod, final String billingPeriodicity) {
		this(null, xdataPersonId, null, label, billingMethod, billingPeriodicity);
	}

	public HP_ContractPortfolio(final Integer xdataId, final Integer xdataPersonId, final Integer xdataIncommingBankDetailsId, final String label, final String billingMethod, final String billingPeriodicity) {
		this.xdataId = xdataId;
		this.xdataPersonId = xdataPersonId;
		this.xdataIncommingBankDetailsId = xdataIncommingBankDetailsId;
		this.label = label;
		this.billingMethod = billingMethod;
		this.billingPeriodicity = billingPeriodicity;
		this.auraBillingMethod = billingMethod;
		this.auraBillingPeriodicity = billingPeriodicity; 
	}
}