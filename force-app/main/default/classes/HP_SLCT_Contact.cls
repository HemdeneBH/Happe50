public with sharing class HP_SLCT_Contact {
	public static List<Contact> havingXdataId(final Set<Integer> xdataIdSet) {
		return [SELECT Id, Id_Tiers__c FROM Contact WHERE Id_Tiers__c IN: xdataIdSet];
	}
}