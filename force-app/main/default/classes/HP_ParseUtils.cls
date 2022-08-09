public with sharing class HP_ParseUtils {
	private static final String DEFAULT_SERIALIZATION_SEPARATOR = ',';

	public static Object parse(final String json, final System.Type aClass) {
		System.debug(json);
		return System.JSON.deserialize(json, aClass);
	}

	public static List<Map<String, Object> > parse(final String json) { // FIXME or remove
		System.debug(json);
		final List<Map<String, Object> > mapList = new List<Map<String, Object> >();
		final List<Object> objectList = (List<Object>)System.JSON.deserializeUntyped(json);
		for (Object o : objectList) {
			mapList.add((Map<String, Object>)o);
		}
		return mapList;
	}

	public static String serialize(final Object o) {
		return System.JSON.serializePretty(o);
	}

	public static String serializeStringSet(final Object o, Set<String> stringSet){
		String aString = serialize(o);
		Map<String,Object> aMap = (Map<String, Object>) JSON.deserializeUntyped(aString);
		for (String fieldName : stringSet) {
			aMap.remove(fieldName);
		}
		return serialize(aMap); 
	}

	public static Object convert(Object toConvert, System.Type aClass) {
		return parse(serialize(toConvert), aClass);
	}
}