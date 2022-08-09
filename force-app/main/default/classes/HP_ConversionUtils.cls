public with sharing class HP_ConversionUtils {
	public interface ExternalType {
		Object toCoreType();
	}

/* 	public static Object toCoreType(final ExternalType externalType) {
		return externalType.toCoreType();
	}

	public static List<Object> toCoreType(final List<Object> listInstance, final List<ExternalType> externalTypeList) {
		for (ExternalType externalType : externalTypeList) {
			listInstance.add(externalType.toCoreType()); 
		}
		return listInstance;
	} */

	public static String toString(Object anObject) {
		return ((anObject == null)? (null) : (String.valueOf(anObject)));
	}
}