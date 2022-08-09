global with sharing class HP_CaseRestResourceModel {

	global SelfcareCase selfcareCase;

	global class SelfcareCase {
		global final EnrolmentCase_v0_1 enrolmentCase_v0_1;
	}

	/*public HP_CaseRestResourceModel(final EnrolmentCase_v0_1 enrolmentCase_v0_1) {
		this.selfcareCase.enrolmentCase_v0_1 = enrolmentCase_v0_1;
	}*/

	global class EnrolmentCase_v0_1 {
		public final String surname;
		public final String lastName;
		public final String email;
		public final String phoneNumber;
		public final String caseName;
		public final HP_SLCT_Case.Status backOfficeProcessing;
		public final HP_SLCT_Case.Type type;

		global EnrolmentCase_v0_1(final Case aCase){
			//FIXME this.surname+''+this.Name=case.SuppliedName,
			this.email = aCase.SuppliedEmail;
			this.phoneNumber = aCase.SuppliedPhone;
			this.caseName = aCase.Subject;
			//FIXME this.backOfficeProcessing = case.status;
		}
	}
}