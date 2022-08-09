/**
 * @File Name          : HP_HttpUtils.cls
 * @Description        : 
 * @Author             : Mohamed Aamer
 * @Group              : 
 * @Last Modified By   : Hemdene Ben Hammouda
 * @Last Modified On   : 11-22-2021
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    24/12/2019   Mohamed Aamer     Initial Version
**/
public with sharing class HP_HttpUtils {
	public static final String URI_SEP = '/'; // TODO move
	public static final String URI_QUERY_DELIMITOR = '&';
	public static final String URI_QUERY_PREFIX = '?';
	public static final String URI_QUERY_PARAMETER_ASSIGNMENT = '=';
	// ENCODING
	public static final String ENCODING_UTF8 = 'UTF-8'; // TODO move
	private static final Boolean DEFAULT_URL_ENCODE_BEHAVIOUR = true; // SF
	public static final String SF_CALLOUT_KWD = 'callout';
	public static final String SF_CALLOUT_PREFIX = SF_CALLOUT_KWD + ':';

	// public static final String HTTP_ACCESS_CONTROL_REQUEST_HEADERS = 'Access-Control-Request-Headers';
	public static final String HTTP_CONTENT_TYPE = 'Content-Type';
	public static final String HTTP_AUTHORIZATION = 'Authorization';
	public static final String HTTP_APPLICATION_XFORM = 'application/x-www-form-urlencoded';
	public static final String HTTP_APPLICATION_JSON = 'application/json';
	public static final String HTTP_X_CORRELATION_ID = 'X-Correlation-Id';
	public static final String HTTP_ACCEPT = 'Accept';
	public static final String HTTP_LOCATION = 'Location';// @see https://tools.ietf.org/html/rfc7231#section-7.1.2
	public static final String HTTP_LOCATION_APIGEE = 'location';
	private static final Integer HTTP_REQUEST_TIMEOUT_DEFAULT = 120000;


	public static Boolean requestIsValid(Map<Integer, String> dataMap){
		Boolean isValid = false;
		if(dataMap != null) {
			Set<Integer> httpCodeSet = dataMap.keySet();
			if(!httpCodeSet.isEmpty()) {
				List<Integer> httpCodeList = new List<Integer>(httpCodeSet);
				Integer httpCode = httpCodeList.get(0);
				isValid = (httpCode == HP_HttpStatus.OK || httpCode == HP_HttpStatus.CREATED);
			}
		}
		return isValid;
	}

	public static String requestGetOutput(Map<Integer, String> dataMap){
		String output = null;
		if(requestIsValid(dataMap)) {
			if(dataMap.containsKey(HP_HttpStatus.OK)){
				output = dataMap.get(HP_HttpStatus.OK);
			}
			else if(dataMap.containsKey(HP_HttpStatus.CREATED)){
				output = dataMap.get(HP_HttpStatus.CREATED);
			}
		}
		return output;
	}
}