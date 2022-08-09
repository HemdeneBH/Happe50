public with sharing class HP_SLCT_StaticResource {

	public static List<StaticResource> selectInNameSet(final Set<String> staticResourceNameSet) {
		return [SELECT Body, Name FROM StaticResource WHERE Name IN : staticResourceNameSet];
	}
}