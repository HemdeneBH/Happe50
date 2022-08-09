global with sharing class HP_CancelationCaseRestResourceModel {


	global SelfcareCase selfcareCase;

	global class SelfcareCase {
		global final CancelationCase_v0_1 cancelationCase_v0_1;
		global final List<CancelationCase_v0_1> cancelationCaseList_v0_1;
		global final Integer personXdataId;
		public final Date effectiveDate;
	}




	public HP_CancelationCaseRestResourceModel(final CancelationCase_v0_1 cancelationCase_v0_1, final Integer personXdataId){
		//TODO build or remove
	}

	//TODO refactor to allow one case per contract type (salesforce asset/Product/family)
	global class CancelationCase_v0_1 {
		public final HP_EnrolmentRestResourceModel.EnergyType energyType;
		public final Boolean isSmartEnergyMeter;
		public final Integer energyContractXdataId;
		public final Integer energyMeterIndex;
		public final Integer electricityMeterVariablePlanBottomPriceIndex;

		global CancelationCase_v0_1(final Case aCase){
			//TODO build cancelationCase or remove
		}

		public CancelationCase_v0_1(final HP_EnrolmentRestResourceModel.EnergyType energyType, final Integer energyContractXdataId, final Integer energyMeterIndex, final Integer electricityMeterVariablePlanBottomPriceIndex, final Boolean isSmartEnergyMeter) {
			this.energyType = energyType;
			this.energyContractXdataId = energyContractXdataId;
			this.energyMeterIndex = energyMeterIndex;
			this.electricityMeterVariablePlanBottomPriceIndex = electricityMeterVariablePlanBottomPriceIndex;
			this.isSmartEnergyMeter = isSmartEnergyMeter;
		}

		public CancelationCase_v0_1(final HP_EnrolmentRestResourceModel.EnergyType energyType, final Integer energyContractXdataId, final Integer energyMeterIndex, final Integer electricityMeterVariablePlanBottomPriceIndex) {
			this(energyType, energyContractXdataId, energyMeterIndex, electricityMeterVariablePlanBottomPriceIndex, false);
		}

	}
}