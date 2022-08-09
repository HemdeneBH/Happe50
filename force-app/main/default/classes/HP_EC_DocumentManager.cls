/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 07-04-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
public without sharing class HP_EC_DocumentManager {
    
    @AuraEnabled(cacheable=true)
    public static Object getContractDocumentsInfo(String idPortfolio) {
        System.debug('HP_EC_DocumentManager.getContractDocumentsInfo | Method Start');
        Object resultObject = null;
        try {
                Map<string, object> contractUntyped= (Map<string, object>)JSON.deserializeUntyped((String)HP_EC_LoadCustomerData.getContractData());
                List<Integer> pftcList = new List<Integer>();
                List<Object> myList = (List<Object>)contractUntyped.get('_data');
                for(Object obj : myList){
                    pftcList.add((Integer)((Map<String,Object>)obj).get('idPortefeuilleContrat'));
                }
                if (pftcList.contains(Integer.valueOf(idPortfolio))) {
                    resultObject = HP_SM001_Agilab.getDocumentsAgilab(idPortfolio);
                }
        }
        catch (Exception ex) {
            System.debug('HP_EC_DocumentManager.getContractDocumentsInfo | Exception : ' + ex.getMessage());
            string exceptionMessage = Label.HP_EC_InternalError; 
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.CUSTOM, exceptionMessage);
        }
        System.debug('HP_EC_DocumentManager.getContractDocumentsInfo | Method Exit');
        return resultObject;
    }

    @AuraEnabled(cacheable=true)
    public static string getJustificatif(string portfolioId){
        System.debug('HP_EC_DocumentManager.getJustificatif | Method Start');
        String result;
        try {
            EmailTemplate emailTemplate = [SELECT Id,Subject,Description,HtmlValue,DeveloperName,Body FROM EmailTemplate WHERE name = 'HP_JustificatifDomicile'];
            String htmlBody = emailTemplate.HtmlValue;
            //Replace all merge fields
            htmlBody.replace('{header_document}', '');
            htmlBody.replace('{hp_capital_GDF_SUEZ}', '');
            htmlBody.replace('{hp_adr_gdfsuez_siege}', '');
            htmlBody.replace('{hp_numero_tva_gdf_suez}', '');
            htmlBody.replace('{hp_date_today}', '');
            htmlBody.replace('{hp_code_client}', '');
            htmlBody.replace('{hp_local_adr}', '');
            htmlBody.replace('{hp_reference_contrat}', '');
            htmlBody.replace('{hp_tel_serviceClient}', '');
            htmlBody.replace('{hp_postal_serviceClient}', '');
            htmlBody.replace('{hp_tel_urgence}', '');
            htmlBody.replace('{hp_nom_client}', '');
            htmlBody.replace('{hp_date_signature}', '');
            
            Blob bodyData = Blob.valueOf(htmlBody);
            result =  EncodingUtil.base64Encode(bodyData);


        } catch (Exception ex) {
            System.debug('HP_EC_DocumentManager.getJustificatif | Exception : ' + ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }
        System.debug('HP_EC_DocumentManager.getJustificatif | Method Exit');
        return result;
    }

}