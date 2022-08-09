public class LCC05_EnvoiConsentement {

	public class ComponentDataWrapper{
		public Lead lead;
		public Boolean xdataConsent;
		public Boolean xdataConsentPartenaire;
		public String error;
		public String xdataConsentId;
		public String xdataConsentPartenaireId;
		public String xdataConsentPartenaire2Id;
	}

	@auraEnabled
	public static String initDatas(String contactId) {
		
		ComponentDataWrapper wr = new ComponentDataWrapper();
		List<Lead> parentLead = [SELECT Id, ID_Tiers__c, Consent_prospection_engie_analogue__c, RecordTypeId, IsConverted,
									Consent_prospection_engie_non_analogue__c, Consent_prospection_partenaire__c, LeadSource
								FROM Lead 
								WHERE convertedContactId = :contactId];

		if(parentLead.size() > 0) {
			wr.lead = parentLead.get(0);
			Map<Integer, MP_AP27_Consentements.ConsentWrapper> consents = MP_AP27_Consentements.getConsentFromXdata((Integer)parentLead.get(0).Id_Tiers__c);
			if (consents.containsKey(1)) {
				wr.xdataConsent = consents.get(1).consent;
			 	wr.xdataConsentId = consents.get(1).id;
			}
			if (consents.containsKey(2)) {
				wr.xdataConsentPartenaire = consents.get(2).consent;
			 	wr.xdataConsentPartenaireId = consents.get(2).id;
			}
			if (consents.containsKey(3)) {
				wr.xdataConsentPartenaire = consents.get(3).consent;
			 	wr.xdataConsentPartenaire2Id = consents.get(3).id;
			}
		}
		return JSON.serialize(wr);
	}

	@auraEnabled
	public static String sendXDataConsent(String leadConsent) {
		Lead lead = (Lead)JSON.deserialize(leadConsent, Lead.class);
		Map<String,Object> mapResponse = MP_AP27_Consentements.manageFromSendConsentButton(lead);
		ComponentDataWrapper wr = new ComponentDataWrapper();
		if (mapResponse.containsKey('code') && (String)mapResponse.get('code') != '200') {
			wr.error = 'ERREUR ' + (String)mapResponse.get('code') + ' - ' + (String)mapResponse.get('name') + ' : ' + (String) mapResponse.get('message');
			return JSON.serialize(wr);
		}
		update lead;
		return JSON.serialize(wr);
	}
}