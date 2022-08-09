@IsTest
public with sharing class HP_StaticResourceTestUtils_TEST {

	public static String extractStaticResourceBody(final String staticResourceName) {
		return extractStaticResourceBodyByName(new Set<String>{staticResourceName}).get(staticResourceName);
	}

	public static Map<String, String> extractStaticResourceBodyByName(final Set<String> staticResourceNameSet) {
		final Map<String, String> staticResourceBodyByName = new Map<String, String>();
		final List<StaticResource> staticResourceList = HP_SLCT_StaticResource.selectInNameSet(staticResourceNameSet);
		for (StaticResource staticResource : staticResourceList) {
			staticResourceBodyByName.put(staticResource.Name, staticResource.Body.toString());
		}
		return staticResourceBodyByName;
	}
}