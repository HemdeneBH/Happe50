/**
 * @File Name          : HP_SM028_Vue360Service.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Hemdene Ben Hammouda
 * @Last Modified On   : 11-04-2021
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    31/03/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public without sharing class HP_SM028_Vue360Service {
    @AuraEnabled(cacheable=true)
    public static Object loadData(String rootMetadata, Object params, Decimal randomNumber, String contactId) {
        System.debug('****rootMetadata**'+ rootMetadata);
        System.debug('****params**'+ params);
        System.debug('****randomNumber**'+ randomNumber);
        return HP_UTIL_Vue360Manager.loadDataVue360(rootMetadata, params, contactId);
    }
}