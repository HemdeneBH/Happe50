/**
 * @File Name          : HP_EnergyRequest.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 28/04/2020 à 06:35:12
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    13/02/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class HP_EnergyRequest {

	public final String enrolmentType;
	public final String energyMeterId;
	public final Integer energyMeterIndex;

	public HP_EnergyRequest(String enrolmentType, final String energyMeterId, final Integer energyMeterIndex) {
		this.enrolmentType = enrolmentType;
		this.energyMeterId = energyMeterId;
		this.energyMeterIndex = energyMeterIndex;
	}


	public HP_EnergyRequest(final String energyMeterId) {
		this.energyMeterId = energyMeterId;
	}
}