/**
 * @File Name          : HP_EnergyContractRequest.cls
 * @Description        :
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              :
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 28/04/2020 à 11:55:52
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    13/02/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
 **/
public class HP_EnergyContractRequest {

	public static String ISO2_FRANCE_COUNTRY_CODE = 'FR';

	public String personId;
	public String salutation;
	public String customerLastName;
	public String customerFirstName;
	public String customerMainPhone;

	public Date contractStartDate;

	public Integer electricityPowerRatingKiloVoltAmpere;   //FIXME from productType?
	public String electricityPricingPlan;  //FIXME from productType?

	public String energyMeterId;  //FIXME electricityMeterId;
	public String deliveryPointStreetName;
	public String deliveryPointStreetNumber;
	public String deliveryPointCity;
	public String deliveryPointPostalCode;
	public String deliveryPointCountryISO2Code;

	public Integer electricityMeterBasePlanIndex;
	public Integer electricityMeterVariablePlanPeakPriceIndex;
	public Integer electricityMeterVariablePlanBottomPriceIndex;

	public Integer gasMeterIndex;  //FIXME gas
	public String productType;  //FIXME gas

	public Integer estimatedConsumption;  //FIXME gas

	public String productFamily;

	public HP_EnergyContractRequest() {

	}


	// private HP_EnergyContractRequest(
	// 	String personId,
	// 	String energyMeterId,
	// 	String salutation,
	// 	String customerLastName,
	// 	String customerFirstName,
	// 	String customerMainPhone,
	// 	String deliveryPointStreetName,
	// 	String deliveryPointStreetNumber,
	// 	String deliveryPointCity,
	// 	String deliveryPointPostalCode,
	// 	Integer electricityPowerRatingKiloVoltAmpere,
	// 	Integer electricityMeterBasePlanIndex,
	// 	Integer electricityMeterVariablePlanPeakPriceIndex,
	// 	Integer electricityMeterVariablePlanBottomPriceIndex,
	// 	String electricityPricingPlan,
	// 	String productFamily,
	// 	Date contractStartDate,
	// 	String deliveryPointCountryISO2Code,
	// 	Integer gasMeterIndex,  //FIXME gas
	// 	String productType,  //FIXME gas
	// 	Integer estimatedConsumption) {  //FIXME gas) {
	// 	this.customerMainPhone = customerMainPhone;
	// 	this.personId = personId;
	// 	this.energyMeterId = energyMeterId;
	// 	this.contractStartDate = contractStartDate;
	// 	this.salutation = salutation;
	// 	this.customerLastName = customerLastName;
	// 	this.customerFirstName = customerFirstName;
	// 	this.customerMainPhone = customerMainPhone;
	// 	this.deliveryPointPostalCode = deliveryPointPostalCode;
	// 	this.deliveryPointStreetName = deliveryPointStreetName;
	// 	this.deliveryPointStreetNumber = deliveryPointStreetNumber;
	// 	this.deliveryPointCity = deliveryPointCity;
	// 	this.electricityPowerRatingKiloVoltAmpere = electricityPowerRatingKiloVoltAmpere;
	// 	this.electricityPricingPlan = electricityPricingPlan;
	// 	this.productFamily = productFamily;
	// 	this.electricityMeterBasePlanIndex = electricityMeterBasePlanIndex;
	// 	this.electricityMeterVariablePlanPeakPriceIndex = electricityMeterVariablePlanPeakPriceIndex;
	// 	this.electricityMeterVariablePlanBottomPriceIndex = electricityMeterVariablePlanBottomPriceIndex;
	// 	this.deliveryPointCountryISO2Code = deliveryPointCountryISO2Code;
	// 	this.gasMeterIndex = gasMeterIndex;
	// 	this.productType = productType;
	// 	this.estimatedConsumption = estimatedConsumption;
	// }
}