/**
 * @File Name          : HP_UTIL_RecordType.cls
 * @Description        :
 * @Author             : Vincent Albiser
 * @Group              :
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 25/02/2020 à 10:41:03
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    11/02/2020   Vincent Albiser     Initial Version
 **/
public with sharing class HP_UTIL_RecordType {

	private static Map<String, Map<String, Id> > recordTypesByObjectAndDeveloperName;

	static {
		loadRecordTypeMap();
	}

	/**
	 * @description Construction de la map des RecordTypes
	 * @author Vincent Albiser | 11/02/2020
	 * @return void
	 **/
	private static void loadRecordTypeMap() {
		recordTypesByObjectAndDeveloperName = new Map<String, Map<String, Id> >();

		for (RecordType rt : [SELECT sObjectType, Name, Id, DeveloperName FROM RecordType WHERE isActive = true]) {

			Map<String, Id> rtByDeveloperName = recordTypesByObjectAndDeveloperName.get(rt.sObjectType);
			if (rtByDeveloperName == null) {
				rtByDeveloperName = new Map<String, Id>();
				recordTypesByObjectAndDeveloperName.put(rt.sObjectType, rtByDeveloperName);
			}
			rtByDeveloperName.put(rt.DeveloperName, rt.Id);
		}
	}

	/**
	 * @description Récupération de l'Id d'un RecordType
	 * @example : Id rtContactId = HP_UTIL_RecordType.getRecordTypeId('Contact','HP_Contact');
	 * @author Vincent Albiser | 11/02/2020
	 * @param String objectApiName
	 * @param String RTdeveloperName
	 * @return Id
	 **/
	@AuraEnabled(cacheable=true)
	public static Id getRecordTypeId(String objectApiName, String RTdeveloperName) {
		Id resultId = null;
		if (!String.isBlank(objectApiName) && !String.isBlank(RTdeveloperName) && recordTypesByObjectAndDeveloperName.containsKey(objectApiName)) {
			if (recordTypesByObjectAndDeveloperName.get(objectApiName).containsKey(RTdeveloperName)) {
				resultId = recordTypesByObjectAndDeveloperName.get(objectApiName).get(RTdeveloperName);
			}
		}
		if(resultId == null) {
			System.debug('### RecordType inexistant : ' + objectApiName + ' ' + RTdeveloperName);
		}
		return resultId;
	}

	/**
	* @description  Récuperation  d'une picklist value
	* @author Sara El-Hannaoui | 26/02/2020 
	* @param String objectName 
	* @param String fieldName 
	* @param String fieldNameValue 
	* @return String 
	**/
	public static String getPicklistValue(String objectName, String fieldName, String fieldNameValue) {
		Schema.DescribeFieldResult F = Schema.getGlobalDescribe().get(ObjectName).getDescribe().fields.getMap().get(fieldName).getDescribe();
        List <Schema.PicklistEntry> pickVals = F.getPicklistValues();
		for (Schema.PicklistEntry pv: pickVals) {
			if (pv.getValue() == fieldNameValue) {
				return pv.getLabel();
			}
		}
		return null;
	}
}