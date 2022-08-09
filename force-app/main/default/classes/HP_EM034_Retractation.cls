/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-15-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-29-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class HP_EM034_Retractation {
    private final static String HP_RETRACTION = 'HP_Retractation';
    public static String loadContractFromXdata(String xdataId) {
		return HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.XDATA_CONTRATS, '/' + xdataId).getBody();
    }

    public static Case createCaseRetractation(String souscriptionId, String description, String status, String contratId, String energie) {
		HP_Souscription__c souscription = [select Id, HP_Contact__c,Name, HP_Contact__r.HomePhone, HP_Contact__r.Phone
		 from HP_Souscription__c where id = :souscriptionId];
		return new Case(
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HP_PrestationDistributeur').getRecordTypeId(),
			HP_Type__c = 'HP_Gestion_Contrat',
			HP_Souscription__c = souscriptionId,
			ContactId = souscription.HP_Contact__c,
			Origin = 'HP_CRM',
			Status = status,
            Description = description,
            HP_Is_Retractation_Case__c = true,
            HP_TECH_ExternalId__c = HP_RETRACTION+'/'+energie+'/'+souscription.Name,
            HP_Energy__c = energie,
			HP_Contrat__c = contratId
		);
    } 

    public static String cancelXdataPC(String pcId) {
        HTTPResponse res = HP_UTIL_HTTPUtils.calloutPut(HP_Constantes.XDATA_PROPOSITIONS_COMMERCIALES, '{"codeStatutPropositionCommercialeHeader": "H0002", "codeStatutPropositionCommercialePoste": "H0104"}', '/' + pcId);
        if(res.getStatusCode() == 200 || res.getStatusCode() == 201|| res.getStatusCode() == 204) {
            return null;
        }
        return res.getBody();
    }  
    public Static String cancelXdataContrat(String xdataId) {
        String todayFomat = System.now().format('yyyy-MM-dd');
        HTTPResponse res = HP_UTIL_HTTPUtils.calloutPut(HP_Constantes.XDATA_CONTRATS,
         '{"statut": "INACT",   "codeStatutCrm": "H0104",  "dateFinValidite": "'+todayFomat+'"}', '/' + xdataId);
        if(res.getStatusCode() == 200 || res.getStatusCode() == 201| res.getStatusCode() == 204) {
            return null;
        }
        return res.getBody();
    }
    public static String cancelAgilabContrat(String xdataId) {
        Map<String, String> paramMap = new Map<String, String>{'id_contrat_xdata' => xdataId, 'statut_contrat' => '5'};
        HTTPResponse res = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.AGILAB_PROPOSITION_MODIFIER, paramMap);
        if(res.getStatusCode() == 200 || res.getStatusCode() == 201|| res.getStatusCode() == 204) {
            return null;
        }
        return res.getBody();
    }

    public static String loadPropositionCommecrialeXdata(String pcId) {
		return HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.XDATA_PROPOSITIONS_COMMERCIALES, '/' + pcId).getBody();
	}
}