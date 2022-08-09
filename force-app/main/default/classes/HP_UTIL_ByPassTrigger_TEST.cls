/**
 * @File Name          : HP_UTIL_ByPassTrigger_TEST.cls
 * @Description        : Classe utility 
 * @Author             : Sara El-Hannaoui
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 22/04/2020 à 04:21:51
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    27/01/2020   Sara El-Hannaoui     Initial Version
**/
@isTest
public with sharing class HP_UTIL_ByPassTrigger_TEST {

	@TestSetup
	static void makeData(){
		ByPassSettings__c oTriggerByPass = (ByPassSettings__c)HP_UTIL_SmartFactory.createSObject('ByPassSettings__c',new Map<String, Object> {
			'HP_ContactTrigger__c' => false
		},null);
		insert oTriggerByPass;
	}

	@isTest
	static void isByPassTrigger(){
		Test.startTest();
		Boolean bool = HP_UTIL_ByPassTrigger.isByPassTrigger('HP_ContactTrigger__c');
		Test.stopTest();
		System.assert (bool == false, 'ByPassrule on Contact');
	}
}