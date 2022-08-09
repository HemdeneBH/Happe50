/**
 * @description  : 
 * @author       : Vincent Albiser
 * Modifications Log 
 * Ver   Date         Author            Modification
 * 1.0   26-02-2021   Vincent Albiser   Initial Version
**/
public with sharing class HP_HttpStatus {
	// HTTP status code @see https://www.ietf.org/assignments/http-status-codes/http-status-codes.xml
	// Salesforce limitations @see https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_restresponse.htm#apex_methods_system_restresponse
	public static final Integer OK = 200;
	public static final Integer CREATED = 201;
	public static final Integer NO_CONTENT = 204;			//  No Content	[RFC7231, Section 6.3.5]
	public static final Integer PARTIAL_CONTENT = 206;		//	Partial Content	[RFC7233, Section 4.1]
	public static final Integer MISCELLANEOUS_PERSISTENT_WARNING = 299;// @see https://tools.ietf.org/html/rfc7234#section-5.5.7
	public static final Integer BAD_REQUEST = 400;			//	Bad Request	[RFC7231, Section 6.5.1]
	public static final Integer UNAUTHTORIZED = 401;		//	Unauthorized	[RFC7235, Section 3.1]
	public static final Integer FORBIDDEN = 403;			//	Forbidden	[RFC7231, Section 6.5.3]
	public static final Integer NOT_FOUND = 404;			//	Not Found	[RFC7231, Section 6.5.4]
	public static final Integer METHOD_NOT_ALLOWED = 405;	//	Method Not Allowed	[RFC7231, Section 6.5.5]
	public static final Integer NOT_ACCEPTABLE = 406;		//	Not Acceptable	[RFC7231, Section 6.5.6]
	public static final Integer CONFLICT = 409;				//	Conflict	[RFC7231, Section 6.5.8]
	public static final Integer GONE = 410;					//	Gone	[RFC7231, Section 6.5.9]
	public static final Integer PRECONDITION_FAILED = 412;	//  Precondition Failed (RFC 7232)
	public static final Integer UNPROCESSABLE = 422; 		//  Unprocessable Entity (RFC 4918)
	public static final Integer TOO_MANY_REQUESTS = 429;	//	Too Many Requests	[RFC6585]
	public static final Integer SERVER_ERROR = 500;			//	Internal Server Error	[RFC7231, Section 6.6.1]
	public static final Integer NOT_IMPLEMENTED = 501;
	public static final Integer SERVICE_UNAVAILABLE = 503;	//	Service Unavailable	[RFC7231, Section 6.6.4]
}