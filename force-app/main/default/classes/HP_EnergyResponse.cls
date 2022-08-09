public with sharing class HP_EnergyResponse {

	public final Boolean isOnsiteIntervention;
	public final Boolean isSmartMeter;
	// public String formuleTarifaireAcheminementcode; //FIXME use? (merge HAPP-840)
	// Message retours
	// public String code;
	// public String libelle;

	public String contractID;
	public String contractualState;    //etat Alimentation
	public String serviceOpeningLevel;   //niveauOuvertureServicesLibelle
	public String serviceOpeningLevelCode; //niveauOuvertureServicesCode
	public Integer electricityPowerRatingKiloVoltAmpere;  //puissanceSouscriteValeur
	public String electricityPowerRatingKiloVoltAmpereUnit;   //puissanceSouscriteUnite
	public Integer gazAnnualConsumption;   //CONSOMMATION ANNUELLE DE RÉFÉRENCE (CAR)
	public Integer numberOfDials;  //nbCadrans
	public String meterType;   //type compteur
	public HP_EnergyResponse(Boolean isOnsiteIntervention, Boolean isSmartMeter /* , String code, String libelle */){
		this.isOnsiteIntervention = isOnsiteIntervention;
		this.isSmartMeter = isSmartMeter;
		// this.code = code;
		// this.libelle = libelle;
	}
	public HP_EnergyResponse(Boolean isOnsiteIntervention, Boolean isSmartMeter,String contractID, String contractualState, Integer electricityPowerRatingKiloVoltAmpere, String electricityPowerRatingKiloVoltAmpereUnit, Integer numberOfDials, String meterType, String serviceOpeningLevelCode, String serviceOpeningLevel){
		this.isOnsiteIntervention = isOnsiteIntervention;
		this.isSmartMeter = isSmartMeter;
		this.contractID = contractID;
		this.contractualState = contractualState;
		this.electricityPowerRatingKiloVoltAmpere = electricityPowerRatingKiloVoltAmpere;
		this.electricityPowerRatingKiloVoltAmpereUnit = electricityPowerRatingKiloVoltAmpereUnit;
		this.numberOfDials = numberOfDials;
		this.meterType = meterType;
        this.serviceOpeningLevelCode = serviceOpeningLevelCode;
		this.serviceOpeningLevel = serviceOpeningLevel;
	}

	public HP_EnergyResponse(Boolean isOnsiteIntervention, Boolean isSmartMeter, String contractualState, Integer gazAnnualConsumption, String meterType){
		this.isOnsiteIntervention = isOnsiteIntervention;
		this.isSmartMeter = isSmartMeter;
		this.contractualState = contractualState;
		this.gazAnnualConsumption = gazAnnualConsumption;
		this.meterType = meterType;
	}
}