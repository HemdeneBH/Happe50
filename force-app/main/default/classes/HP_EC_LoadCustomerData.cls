/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 07-11-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
public with sharing class HP_EC_LoadCustomerData {

    private class CustomerDataConfig {
        Map<String, HP_Vue_360_API__mdt> config;
        Id  userId;
        Id  contactId;
        Decimal idTiers;
        
        private CustomerDataConfig() {
            this.config = loadConfig();
            this.userId = UserInfo.getUserId();
            User currentUser = [SELECT contactId FROM USER WHERE Id = :this.userId];
            this.contactId = currentUser.contactId;
        }

        private Map<String, HP_Vue_360_API__mdt> loadConfig() {
            Map<String, HP_Vue_360_API__mdt> mapMdtConfig = new Map<String, HP_Vue_360_API__mdt>();
            List<HP_Vue_360_API__mdt> listMdtConfig = [SELECT DeveloperName, HP_Type__c, HP_Precessing__c, HP_Prefix_Parameter_API__c, HP_Path_Field_Parent__c 
                                                            FROM HP_Vue_360_API__mdt WHERE HP_Desactivate_Config__c = false WITH SECURITY_ENFORCED];
            
            for(HP_Vue_360_API__mdt mdt : listMdtConfig) {
                mapMdtConfig.put(mdt.DeveloperName, mdt);
            }
            return mapMdtConfig;
        }
    }
    
    private static CustomerDataConfig configData;
    static {
        if (HP_EC_UTL_CacheManager.cacheContains('CustomerDataConfig'+String.valueOf(new CustomerDataConfig().contactId))) {
            configData = (CustomerDataConfig)HP_EC_UTL_CacheManager.getCacheData('CustomerDataConfig'+String.valueOf(new CustomerDataConfig().contactId));
        }
        else {
            configData = new CustomerDataConfig();
             Map<string, object> contactUntyped= (Map<string, object>)JSON.deserializeUntyped((String)getContactData()); //Get Contact from SF user
            configData.idTiers = Integer.valueOf(contactUntyped.get('ID_Tiers__c'));
            getContractData(); //Get Contract data from Agilab
            getContractPortfolioData(); //Get Contracts portfolio ID
            getContractsAddresses(); //Get contracts addresses from portfolio ID
            getCoordonneesBancaires(); //Get Coordonnées Bancaires
            HP_EC_UTL_CacheManager.putCacheData('CustomerDataConfig'+String.valueOf(configData.contactId), (object)configData);
        }
    }

    //Renvoyer la clé utiliser dans le cache
    //Etude wrapper vs parsing Json
    private HP_EC_LoadCustomerData() {
        HP_UTIL_Vue360Manager.rootParam = configData.contactId;
    }

    @AuraEnabled(cacheable=true)
    public static String init(){
        return 'Initiated';
    }

    @AuraEnabled(cacheable=true)
    public static Object getContactData() {
        Object data = null;
        String exceptionMessage;
        try {
            if (HP_EC_UTL_CacheManager.cacheContains('ContactData'+String.valueOf(configData.contactId))) {
                data = HP_EC_UTL_CacheManager.getCacheData('ContactData'+String.valueOf(configData.contactId));
                return data;
            }
            else {
                HP_Vue_360_API__mdt contactConfig = configData.config.get('V1_SOQL_LOAD_CONTACT_FROM_SF_BY_ID');
                List<Contact> contacts = (List<Contact>)HP_UTIL_Vue360Manager.loadSoqlData(contactConfig.HP_Precessing__c, configData.contactId);
                if (contacts.size() > 0) {
                    data = contacts.get(0);
                }
                System.debug(data);
            }
        }
        catch (Exception e) {
            System.debug('ERROR HP EC : ' + e.getMessage());
            exceptionMessage = Label.HP_EC_InternalError; //Client side message
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.CUSTOM, exceptionMessage);
        }
        if (data != null) {
            data = buildJson('ContactData', JSON.serialize(data));
            HP_EC_UTL_CacheManager.putCacheData('ContactData'+String.valueOf(configData.contactId), data);
        }
        return data;
    }

    @AuraEnabled(cacheable=true)
    public static Object getContractData() {
        Object data;
        String exceptionMessage;
        try {
            if (HP_EC_UTL_CacheManager.cacheContains('ContractData'+String.valueOf(configData.contactId))) {
                data = HP_EC_UTL_CacheManager.getCacheData('ContractData'+String.valueOf(configData.contactId));
                return data;
            }
            else {
                HP_Vue_360_API__mdt contractConfig = configData.config.get('V1_API_LOAD_CONTRAT_LIST');
                System.debug('EC Controller : Load V1_API_LOAD_CONTRAT_LIST');
                Map<string, object> params = new Map<string, object>();
                params.put(contractConfig.HP_Path_Field_Parent__c, configData.idTiers);
                data = HP_UTIL_Vue360Manager.loadAPIData(contractConfig.HP_Precessing__c, params, contractConfig.HP_Prefix_Parameter_API__c);
            }
        }
        catch (Exception e) {
            System.debug('ERROR HP EC : ' + e.getMessage() + ' ' + e.getStackTraceString());
            exceptionMessage = Label.HP_EC_InternalError; //Client side message
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.CUSTOM, exceptionMessage);
        }
        if (data != null) {
            System.debug(((Map<string, object>)data).get('data'));
            data = buildJson('ContractData', JSON.serialize(((Map<string, object>)data).get('data')));
            HP_EC_UTL_CacheManager.putCacheData('ContractData'+String.valueOf(configData.contactId), data);
        }
        return data;
    }

    @AuraEnabled(cacheable=true)
    public static Object getContractPortfolioData() {
        Object data;
        String exceptionMessage;
        try {
            if (HP_EC_UTL_CacheManager.cacheContains('ContractPortfolioData'+String.valueOf(configData.contactId))) {
                data = HP_EC_UTL_CacheManager.getCacheData('ContractPortfolioData'+String.valueOf(configData.contactId));
                return data;
            }
            else {
                HP_Vue_360_API__mdt contractConfig = configData.config.get('V1_API_LOAD_PFC_LIST');
                System.debug('EC Controller : Load V1_API_LOAD_PFC_LIST');
                Map<string, object> params = new Map<string, object>();
                params.put(contractConfig.HP_Path_Field_Parent__c, configData.idTiers);
                data = HP_UTIL_Vue360Manager.loadAPIData(contractConfig.HP_Precessing__c, params, contractConfig.HP_Prefix_Parameter_API__c);
                //idPortfolio = getPortfolioId(data);
            }
            
        } catch (Exception e) {
            System.debug('ERROR HP EC : ' + e.getMessage());
            exceptionMessage = Label.HP_EC_InternalError; //Client side message
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.CUSTOM, exceptionMessage);
        }
        if (data != null) {
            data = buildJson('ContractPortfolioData', JSON.serialize(((Map<string, object>)data).get('data')));
            HP_EC_UTL_CacheManager.putCacheData('ContractPortfolioData'+String.valueOf(configData.contactId), data);
        }
        return data;
    }

    @AuraEnabled(cacheable=true)
    public static Object getContractsAddresses() {
        Object data;
        String exceptionMessage;
        try {
            if (HP_EC_UTL_CacheManager.cacheContains('ContractsAddresses'+String.valueOf(configData.contactId))) {
                data = HP_EC_UTL_CacheManager.getCacheData('ContractsAddresses'+String.valueOf(configData.contactId));
                return data;
            }
            else {
                Object contracts = getContractData();
                List<String> activeContractStatus = new List<String>{'E0011', 'H0101', 'E0004', 'E0007', 'H0105'};
                Map<String,Object> mapJson = (Map<String,Object>)JSON.deserializeUntyped((string)contracts) ;
                List<Integer> pftcList = new List<Integer>();
                List<Object> myList = (List<Object>)mapJson.get('_data');
                for(Object obj : myList){
                    // filter sur les contrats dans un état actif ou résilié de moins d'un an
                    Boolean firstCondition = activeContractStatus.contains((String)((Map<String,Object>)obj).get('codeStatutCrm'));
                    Boolean secondCondition = (String)((Map<String,Object>)obj).get('codeStatutCrm') == 'E0009' || (String)((Map<String,Object>)obj).get('codeStatutCrm') == 'H0103' ;
                    Boolean thirdContition = Date.valueOf((String)((Map<String,Object>)obj).get('dateFinValidite')).daysBetween(Date.today())<365 ;

                    if( firstCondition || (secondCondition && thirdContition)){
                        pftcList.add((Integer)((Map<String,Object>)obj).get('idPortefeuilleContrat'));
                    }
                }
                HP_Vue_360_API__mdt contractConfig = configData.config.get('V1_API_LOAD_LOCAUX_CONTRAT_LIST');
                Map<string, string> params = new Map<string, string>();
                string ids = '';
                if(!pftcList.isEmpty()){
                    for(Integer pfctId : pftcList){
                        if(!ids.contains(String.valueOf(pfctId))){
                            if (!String.isBlank(ids)) {
                                ids += ',';
                            }
                            ids += String.valueOf(pfctId);  
                        }
                    }
                }
                params.put(contractConfig.HP_Path_Field_Parent__c, ids);
                System.debug('EC Controller : V1_API_LOAD_LOCAUX_CONTRAT_LIST');
                data = HP_UTIL_Vue360Manager.loadAPIData(contractConfig.HP_Precessing__c, params, contractConfig.HP_Prefix_Parameter_API__c);
                System.debug(data);
            }
        } catch (Exception e) {
            System.debug('ERROR HP EC : ' + e.getMessage() + '  '+ e.getStackTraceString()+ '  '+e.getLineNumber());
            exceptionMessage = Label.HP_EC_InternalError; //Client side message
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.CUSTOM, exceptionMessage);
        }
        if (data != null) {
            data = buildJson('ContractsAddresses', JSON.serialize(((Map<string, object>)data).get('data')));
            HP_EC_UTL_CacheManager.putCacheData('ContractsAddresses'+String.valueOf(configData.contactId), data);
        }
        return data;
    }

    @AuraEnabled(cacheable=true)
    public static Object getSoldeEffectifData() {
        Object data;
        String exceptionMessage;
        try {
            if (HP_EC_UTL_CacheManager.cacheContains('SoldeEffectif'+String.valueOf(configData.contactId))) {
                data = HP_EC_UTL_CacheManager.getCacheData('SoldeEffectif'+String.valueOf(configData.contactId));
                return data;
            }
            else {
                HP_Vue_360_API__mdt contractConfig = configData.config.get('V1_API_LOAD_SOLDE_BY_AGILAB');
                Map<string, object> params = new Map<string, object>();
                params.put(contractConfig.HP_Path_Field_Parent__c, configData.idTiers);
                data = HP_UTIL_Vue360Manager.loadAPIData(contractConfig.HP_Precessing__c, params, contractConfig.HP_Prefix_Parameter_API__c);
            }
        }
        catch (Exception e) {
            System.debug('ERROR HP EC : ' + e.getMessage() + ' ' + e.getStackTraceString());
                exceptionMessage = Label.HP_EC_InternalError; //Client side message
                HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.CUSTOM, exceptionMessage);
        }
        if (data != null) {
            System.debug(((Map<string, object>)data).get('data'));
            data = buildJson('SoldeEffectif', JSON.serialize(((Map<string, object>)data).get('data')));
            HP_EC_UTL_CacheManager.putCacheData('SoldeEffectif'+String.valueOf(configData.contactId), data);
        }
        return data; 
    }
    
    @AuraEnabled(cacheable=true)
    public static Object getPorteFeuilleContratXdata(String contractPortfolioXdataId){
        Object data;
        String exceptionMessage;
        try {
            if (HP_EC_UTL_CacheManager.cacheContains('PorteFeuilleContat'+contractPortfolioXdataId)) {
                data = HP_EC_UTL_CacheManager.getCacheData('PorteFeuilleContat'+contractPortfolioXdataId);
                return data;
            }
            else {
                data = HP_SM008_APIHour.getPorteFeuilleContratXdata(contractPortfolioXdataId);
            }
        } catch (Exception e) {
            System.debug('ERROR HP EC getPorteFeuilleContratXdata : ' + e.getMessage() + ' ' + e.getStackTraceString());
            exceptionMessage = Label.HP_EC_InternalError; //Client side message
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.CUSTOM, exceptionMessage);
        }
        if (data != null) {
            System.debug(data);
            data = buildJson('PorteFeuilleContat', JSON.serialize(data));
            HP_EC_UTL_CacheManager.putCacheData('PorteFeuilleContat'+contractPortfolioXdataId, data);
        }
        return data;
    }

    @AuraEnabled(cacheable=true)
    public static Object getFactureAgilabData(String id_portefeuille_contrat_xdata) {
        Object data;
        String exceptionMessage;
        try {
            if (HP_EC_UTL_CacheManager.cacheContains('FactureAgilab'+id_portefeuille_contrat_xdata)) {
                data = HP_EC_UTL_CacheManager.getCacheData('FactureAgilab'+id_portefeuille_contrat_xdata);
                return data;
            }
            else {
                HP_Vue_360_API__mdt contractConfig = configData.config.get('V1_API_LOAD_FACTURE_AGILAB');
                Map<string, object> params = new Map<string, object>();
                params.put(contractConfig.HP_Path_Field_Parent__c, id_portefeuille_contrat_xdata);
                data = HP_UTIL_Vue360Manager.loadAPIData(contractConfig.HP_Precessing__c, params, contractConfig.HP_Prefix_Parameter_API__c);
            }
        }
        catch (Exception e) {
            System.debug('ERROR HP EC : ' + e.getMessage() + ' ' + e.getStackTraceString());
            exceptionMessage = Label.HP_EC_InternalError; //Client side message
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.CUSTOM, exceptionMessage);
        }
        if (data != null) {
            System.debug(((Map<string, object>)data).get('data'));
            data = buildJson('FactureAgilab', JSON.serialize(((Map<string, object>)data).get('data')));
            HP_EC_UTL_CacheManager.putCacheData('FactureAgilab'+id_portefeuille_contrat_xdata, data);
        }
        return data;
    }

    @AuraEnabled(cacheable=true)
    public static Object getEcheanceContractData(String id_contrat_xdata) {
        Object data;
        String exceptionMessage;
        try {
            if (HP_EC_UTL_CacheManager.cacheContains('EcheanceContract'+id_contrat_xdata)) {
                data = HP_EC_UTL_CacheManager.getCacheData('EcheanceContract'+id_contrat_xdata);
                return data;
            }
            else {
                HP_Vue_360_API__mdt contractConfig = configData.config.get('V1_API_LOAD_ECHEANCE_CONTACT_BY_AGILAB');
                Map<string, object> params = new Map<string, object>();
                params.put(contractConfig.HP_Path_Field_Parent__c, id_contrat_xdata);
                data = HP_UTIL_Vue360Manager.loadAPIData(contractConfig.HP_Precessing__c, params, contractConfig.HP_Prefix_Parameter_API__c);
            }
        }
        catch (Exception e) {
            System.debug('ERROR HP EC : ' + e.getMessage() + ' ' + e.getStackTraceString());
                exceptionMessage = Label.HP_EC_InternalError; //Client side message
                HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.CUSTOM, exceptionMessage);
        }
        if (data != null) {
            System.debug(((Map<string, object>)data).get('data'));
            data = buildJson('EcheanceContract', JSON.serialize(((Map<string, object>)data).get('data')));
            HP_EC_UTL_CacheManager.putCacheData('EcheanceContract'+id_contrat_xdata, data);
        }
        return data;
    }

    @AuraEnabled(cacheable=true)
    public static Object getInfoContractData(String id_contrat_xdata) {
        Object data;
        String exceptionMessage;
        try {
            if (HP_EC_UTL_CacheManager.cacheContains('InfoContract'+ id_contrat_xdata)) {
                data = HP_EC_UTL_CacheManager.getCacheData('InfoContract'+id_contrat_xdata);
                return data;
            }
            else {
                HP_Vue_360_API__mdt contractConfig = configData.config.get('V1_API_LOAD_INFO_CONTACT_BY_AGILAB');
                System.debug('EC Controller : Load V1_API_LOAD_INFO_CONTACT_BY_AGILAB');
                System.debug('EC Controller : id_contrat_xdata	= ' + id_contrat_xdata);
                Map<string, object> params = new Map<string, object>();
                params.put(contractConfig.HP_Path_Field_Parent__c, id_contrat_xdata);
                data = HP_UTIL_Vue360Manager.loadAPIData(contractConfig.HP_Precessing__c, params, contractConfig.HP_Prefix_Parameter_API__c);
            }
        }
        catch (Exception e) {
            System.debug('ERROR HP EC : ' + e.getMessage() + ' ' + e.getStackTraceString());
            exceptionMessage = Label.HP_EC_InternalError; //Client side message
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.CUSTOM, exceptionMessage);
        }
        if (data != null) {
            System.debug(((Map<string, object>)data).get('data'));
            data = buildJson('InfoContract', JSON.serialize(((Map<string, object>)data).get('data')));
            HP_EC_UTL_CacheManager.putCacheData('InfoContract'+ id_contrat_xdata, data);
        }
        return data;
    }

    private static string buildJson(string key, string value) {
        //Build json to key, _data format with key similar to cache key
        System.debug('Build Json : key - ' + key + ' , value - ' + value);
        Map<string, Object> untyped = (Map<string, Object>)JSON.deserializeUntyped(value);
        untyped.put('key', key);
        
        return JSON.serialize(untyped);
    }

    @AuraEnabled
    public static Object loadEnergieVerOption(String contractId) {
        Object data;
        String exceptionMessage;
        try {
            data = (Object) JSON.deserializeUntyped(JSON.serialize(HP_SM006_FactureManager.loadEnergieVerOption(contractId)));
        }
        catch (Exception e) {
            System.debug('loadEnergieVerOption ERROR HP EC : ' + e.getMessage() + ' ' + e.getStackTraceString());
            exceptionMessage = Label.HP_EC_InternalError; 
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.CUSTOM, exceptionMessage);
        }
        return data;
    }

    @AuraEnabled(cacheable=true)
    public static Object getGrilleTarifaire(String idContrat, String dateContrat){
        Object data;
        String exceptionMessage;
        try {
            if (HP_EC_UTL_CacheManager.cacheContains('GrilleTarifaire'+idContrat)) {
                data = HP_EC_UTL_CacheManager.getCacheData('GrilleTarifaire'+idContrat);
                return data;
            }
            else {
                data = HP_SM001_Agilab.getGrilleTarifaire(idContrat, dateContrat);
            }
        }
        catch (Exception e) {
            System.debug('ERROR HP EC : ' + e.getMessage() + ' ' + e.getStackTraceString());
            exceptionMessage = Label.HP_EC_InternalError; //Client side message
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.CUSTOM, exceptionMessage);
        }
        if (data != null) {
            data = buildJson('GrilleTarifaire', JSON.serialize(data));
            HP_EC_UTL_CacheManager.putCacheData('GrilleTarifaire'+idContrat, data);
        }
        return data;
    }

    @AuraEnabled(cacheable=true)
    public static Object getContratInfo(String idContrat){
        Object data;
        String exceptionMessage;
        try {
            if (HP_EC_UTL_CacheManager.cacheContains('getContratInfo'+idContrat)) {
                data = HP_EC_UTL_CacheManager.getCacheData('getContratInfo'+idContrat);
                return data;
            }
            else {
                data = HP_SM001_Agilab.getContratInfo(idContrat);
            }
        }
        catch (Exception e) {
            System.debug('ERROR HP EC : ' + e.getMessage() + ' ' + e.getStackTraceString());
            exceptionMessage = Label.HP_EC_InternalError; //Client side message
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.CUSTOM, exceptionMessage);
        }
        if (data != null) {
            data = buildJson('getContratInfo', JSON.serialize(data));
            HP_EC_UTL_CacheManager.putCacheData('getContratInfo'+idContrat, data);
        }
        return data;
    }

    @AuraEnabled(cacheable=true)
    public static Object getQuestionsConsentement(){
        Object data;
        try {
            data = (Object) JSON.deserializeUntyped(JSON.serialize(HP_CALL001_XDATA.getQuestionsConsentement()));
        } catch (Exception e) {
            System.debug('ERROR HP EC getQuestionsConsentement : ' + e.getMessage() + ' ' + e.getStackTraceString());
        }
        return data;
    }

    @AuraEnabled(cacheable=true)
    public static Object getReponsesConsentement(Integer idPersonne){
        Object data;
        try {
            data = (Object) JSON.deserializeUntyped(JSON.serialize(HP_CALL001_XDATA.getReponsesConsentement(idPersonne)));
        } catch (Exception e) {
            System.debug('ERROR HP EC getReponsesConsentement : ' + e.getMessage() + ' ' + e.getStackTraceString());
        }
        return data;
    }

    @AuraEnabled(cacheable=true)
    public static Object getCoordonneesBancaires(){
        Object data;
        String exceptionMessage;
        try {
            if (HP_EC_UTL_CacheManager.cacheContains('CoordonneesBancaires')) {
                data = HP_EC_UTL_CacheManager.getCacheData('CoordonneesBancaires');
                return data;
            }
            else {
                HP_Vue_360_API__mdt contractConfig = configData.config.get('V1_API_LOAD_COORDONNE_BANCAIRE_XDATA');
                System.debug('EC Controller : Load V1_API_LOAD_COORDONNE_BANCAIRE_XDATA');
                Map<string, object> params = new Map<string, object>();
                params.put(contractConfig.HP_Path_Field_Parent__c, configData.idTiers);
                data = HP_UTIL_Vue360Manager.loadAPIData(contractConfig.HP_Precessing__c, params, contractConfig.HP_Prefix_Parameter_API__c);
            }
            
        } catch (Exception e) {
            System.debug('ERROR HP EC : ' + e.getMessage());
            exceptionMessage = Label.HP_EC_InternalError; //Client side message
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.CUSTOM, exceptionMessage);
        }
        if (data != null) {
            //data = buildJson('CoordonneesBancaires', JSON.serialize(data));
            data = buildJson('CoordonneesBancaires', JSON.serialize(((Map<string, object>)data).get('data')));
            HP_EC_UTL_CacheManager.putCacheData('CoordonneesBancaires', data);
        }
        return data;
    }

//Get les paiements
@AuraEnabled(cacheable=true)
public static Object getPaiement(Integer idContratXdata){
    Object data;
    String exceptionMessage;
    try {
            if (HP_EC_UTL_CacheManager.cacheContains('Paiement'+idContratXdata)) {
                data = HP_EC_UTL_CacheManager.getCacheData('Paiement'+idContratXdata);
                return data;
            }
            else {
                data = HP_SM001_Agilab.getPaiement(idContratXdata);
                System.debug('getPaiement, data : '+data);
            }
    }
    catch (Exception e) {
        System.debug('ERROR HP EC : ' + e.getMessage() + ' ' + e.getStackTraceString());
        exceptionMessage = Label.HP_EC_InternalError; //Client side message
        HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.CUSTOM, exceptionMessage);
    }
        if (data != null) {
            // System.debug(data);
            data = buildJson('Paiement', JSON.serialize(data));
            HP_EC_UTL_CacheManager.putCacheData('Paiement'+idContratXdata, data);
        }
        return data;
    }

// Get les Plans d'Apurement  
@AuraEnabled(cacheable=true)
public static Object getPlansApurement(Integer idPorteFueilleContrat){
    Object data;
    String exceptionMessage;
    try {
            if (HP_EC_UTL_CacheManager.cacheContains('PlansApurement'+idPorteFueilleContrat)) {
                data = HP_EC_UTL_CacheManager.getCacheData('PlansApurement'+idPorteFueilleContrat);
                return data;
            }
            else {
                data = HP_SM001_Agilab.getPlansApurement(idPorteFueilleContrat);
                System.debug('getPlansApurement, data : '+data);
            }            
    }
    catch (Exception e) {
        System.debug('ERROR HP EC : ' + e.getMessage() + ' ' + e.getStackTraceString());
        exceptionMessage = Label.HP_EC_InternalError; //Client side message
        HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.CUSTOM, exceptionMessage);
    }
        if (data != null) {
            System.debug(data);
            data = buildJson('PlansApurement', JSON.serialize(data));
            HP_EC_UTL_CacheManager.putCacheData('PlansApurement'+idPorteFueilleContrat, data);
        }
        return data;
    }

    @AuraEnabled(cacheable=true)
    public static Object getContractTranquility(String idPersonne){
        Object data;
        String exceptionMessage;
        try {
            if (HP_EC_UTL_CacheManager.cacheContains('ContractTranquility'+idPersonne)) {
                data = HP_EC_UTL_CacheManager.getCacheData('ContractTranquility'+idPersonne);
                return data;
            }
            else {
                HP_WRP004_AgilabPersonne personne = HP_EM001_Agilab.getPersonne(idPersonne);
                data = (Object) JSON.deserializeUntyped(JSON.serialize(HP_EM0016_Tranquility.getContrat(String.valueOf(personne.functionalId))));
                System.debug('getContractTranquility, data : '+data);
            } 
        } catch (Exception e) {
            System.debug('ERROR HP EC getContractTranquility : ' + e.getMessage() + ' ' + e.getStackTraceString());
            exceptionMessage = Label.HP_EC_InternalError; //No data exception
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.NODATA, exceptionMessage);
        }
        if (data != null) {
            data = buildJson('ContractTranquility', JSON.serialize(data));
            HP_EC_UTL_CacheManager.putCacheData('ContractTranquility'+idPersonne, data);
        }
        return data;
    }

    @AuraEnabled(cacheable=true)
    public static Object getAutoReleveData(Integer id_contrat_xdata){
        Object data;
        String exceptionMessage;
        try {
            if (HP_EC_UTL_CacheManager.cacheContains('AutoReleveData'+id_contrat_xdata)) {
                data = HP_EC_UTL_CacheManager.getCacheData('AutoReleveData'+id_contrat_xdata);
                return data;
            }
            else {
                data = HP_SM001_Agilab.getAutoReleve(id_contrat_xdata);
                System.debug('getAutoReleveData, data : '+data);
            } 
        } catch (Exception e) {
            System.debug('ERROR HP EC getAutoReleveData : ' + e.getMessage() + ' ' + e.getStackTraceString());
            exceptionMessage = Label.HP_EC_InternalError; //No data exception
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.NODATA, exceptionMessage);
        }
        if (data != null) {
            data = buildJson('AutoReleveData', JSON.serialize(data));
            HP_EC_UTL_CacheManager.putCacheData('AutoReleveData'+id_contrat_xdata, data);
        }
        return data;
    }

    @AuraEnabled(cacheable=true)
    public static Object agilabEnvoiIndexBase(Integer idContratXdata, Integer type_releve, Integer indexhc) {
        Object data;
        try {
            data = HP_SM001_Agilab.agilabEnvoiIndexBase(idContratXdata, type_releve,indexhc);
            System.debug('*** agilabEnvoiIndexBase result @data : ' + data);
        } catch (Exception e) {
            System.debug('ERROR HP EC agilabEnvoiIndexBase : ' + e.getMessage() + ' ' + e.getStackTraceString());
        }
        return data;
    }

    @AuraEnabled(cacheable=true)
    public static Object agilabEnvoiIndexHPHC(Integer idContratXdata, Integer type_releve, Integer indexhc, Integer indexhp) {
        Object data;
        try {
            data = HP_SM001_Agilab.agilabEnvoiIndexHPHC(idContratXdata, type_releve,indexhc, indexhp);
        } catch (Exception e) {
            System.debug('ERROR HP EC agilabEnvoiIndexHPHC : ' + e.getMessage() + ' ' + e.getStackTraceString());
        }
        return data;
    }

    @AuraEnabled(cacheable=true)
    public static Object getConsoElec(Integer idClientXdata,String pdl) {
        Object data;
        String exceptionMessage;
        try {
            if (HP_EC_UTL_CacheManager.cacheContains('ConsommationELEC'+pdl)) {
                data = HP_EC_UTL_CacheManager.getCacheData('ConsommationELEC'+pdl);
                return data;
            }
            else {
                data = JSON.deserializeUntyped(HP_SM062_ConsommationManager.getConsommationELEC_VersionEC(idClientXdata, pdl));
                System.debug('getConsoElec, data : '+data);
            }
        } catch (Exception e) {
            System.debug('ERROR HP EC getConsoElec : ' + e.getMessage() + ' ' + e.getStackTraceString());
            exceptionMessage = Label.HP_EC_InternalError; //No data exception
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.NODATA, exceptionMessage);
        }
        if (data != null) {
            data = buildJson('ConsommationELEC', JSON.serialize(data));
            HP_EC_UTL_CacheManager.putCacheData('ConsommationELEC'+pdl, data);
        }
        return data;
    }

    @AuraEnabled(cacheable=true)
    public static Object getConsoGaz(Integer idClientXdata, String pce) {
        Object data;
        String exceptionMessage;
        try {
            if (HP_EC_UTL_CacheManager.cacheContains('ConsommationGAZ'+pce)) {
                data = HP_EC_UTL_CacheManager.getCacheData('ConsommationGAZ'+pce);
                return data;
            }
            else {
                data = JSON.deserializeUntyped(HP_SM062_ConsommationManager.getConsommationGAZ_VersionEC(idClientXdata, pce));
                System.debug('getConsoGaz, data : '+data);
            }
        } catch (Exception e) {
            System.debug('ERROR HP EC getConsoGaz : ' + e.getMessage() + ' ' + e.getStackTraceString());
            exceptionMessage = Label.HP_EC_InternalError; //No data exception
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.NODATA, exceptionMessage);
        }
        if (data != null) {
            data = buildJson('ConsommationGAZ', JSON.serialize(data));
            HP_EC_UTL_CacheManager.putCacheData('ConsommationGAZ'+pce, data);
        }
        return data;
    }

    @AuraEnabled(cacheable=true)
    public static Object createOrderPaiementAPlusieurs(String echeance_reference, String montant_restant_du, String email, String prenom, String nom) {
        Object data;
        try {
            data = HP_SM076_ShareGroopController.createOrderPaiementAPlusieurs(echeance_reference, montant_restant_du,email,prenom,nom);
        } catch (Exception e) {
            System.debug('ERROR HP EC getPorteFeuilleContratXdata : ' + e.getMessage() + ' ' + e.getStackTraceString());
        }
        return data;
    }

    @AuraEnabled(cacheable=true)
    public static Object isCompteurCommunicantElec(String pdl, Integer index) {
        Object data;
        String exceptionMessage;
        try {
            if (HP_EC_UTL_CacheManager.cacheContains('isCompteurCommunicantElec'+pdl)) {
                data = HP_EC_UTL_CacheManager.getCacheData('isCompteurCommunicantElec'+pdl);
                return data;
            }
            else {
                HP_EnergyRequest energyrequest = new HP_EnergyRequest('SWITCH_SUPLIER',pdl,index);
                HP_SM028_DistGetPdlElec  distGetPdlElec = new HP_SM028_DistGetPdlElec();
                HP_EnergyResponse energyResponse = distGetPdlElec.retrieveEnergyMeterInformations(energyrequest);
                data = new Map<string, Object> { 'data' => energyResponse.isSmartMeter};
                System.debug('isCompteurCommunicantElec, data : '+data);
            }
            
        } catch (Exception e) {
            System.debug('ERROR HP EC isCompteurCommunicantElec : ' + e.getMessage() + ' ' + e.getStackTraceString());
            exceptionMessage = Label.HP_EC_InternalError; //No data exception
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.NODATA, exceptionMessage);
        }
        if (data != null) {
            // System.debug(((Map<string, object>)data).get('data'));
            data = buildJson('isCompteurCommunicantElec', JSON.serialize(data));
            HP_EC_UTL_CacheManager.putCacheData('isCompteurCommunicantElec'+pdl, data);
        }
        return data;
    }

    @AuraEnabled(cacheable=true)
    public static Object isCompteurCommunicantGaz(String pce, Integer index) {
        Object data;
        String exceptionMessage;
        try {
            if (HP_EC_UTL_CacheManager.cacheContains('isCompteurCommunicantGaz'+pce)) {
                data = HP_EC_UTL_CacheManager.getCacheData('isCompteurCommunicantGaz'+pce);
                return data;
            }
            else {
                HP_EnergyRequest energyrequest = new HP_EnergyRequest('SWITCH_SUPLIER',pce,index);
                HP_SM029_DistGetPdlGaz  distGetPdlGaz = new HP_SM029_DistGetPdlGaz();
                HP_EnergyResponse energyResponse = distGetPdlGaz.retrieveEnergyMeterInformations(energyrequest);
                data = new Map<string, Object> { 'data' => energyResponse.isSmartMeter};
                System.debug('isCompteurCommunicantGaz, data : '+data);
            }
        } catch (Exception e) {
            System.debug('ERROR HP EC isCompteurCommunicantGaz : ' + e.getMessage() + ' ' + e.getStackTraceString());
            exceptionMessage = Label.HP_EC_InternalError; //No data exception
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.NODATA, exceptionMessage);
        }
        if (data != null) {
            // System.debug(((Map<string, object>)data).get('data'));
            data = buildJson('isCompteurCommunicantGaz', JSON.serialize(data));
            HP_EC_UTL_CacheManager.putCacheData('isCompteurCommunicantGaz'+pce, data);
        }
        return data;
    }

    // Get email validation DQE  
@AuraEnabled(cacheable=true)
public static Object getEmailValidation(String email){
    Object data;
    String exceptionMessage;
    try {
        data = HP_SM0017_DQE.getEmailValidation(email);
            System.debug('getEmailValidation, data : '+data);
        }
        catch (Exception e) {
            System.debug('ERROR HP EC getEmailValidation : ' + e.getMessage() + ' ' + e.getStackTraceString());
        exceptionMessage = Label.HP_EC_InternalError; //Client side message
        HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.CUSTOM, exceptionMessage);
    }
    return data;
}

    // Get Téléphone validation DQE  
@AuraEnabled(cacheable=true)
public static Object getTelephoneValidation(String telephone,String pays){
    Object data;
    String exceptionMessage;
    try {
            if (HP_EC_UTL_CacheManager.cacheContains('TelephoneValidation'+telephone+pays)) {
                data = HP_EC_UTL_CacheManager.getCacheData('TelephoneValidation'+telephone+pays);
                return data;
            }
            else {
                data = HP_SM0017_DQE.getTelephoneValidation(telephone,pays);
                System.debug('getTelephoneValidation, data : '+data);
            }
        }
        catch (Exception e) {
            System.debug('ERROR HP EC getTelephoneValidation : ' + e.getMessage() + ' ' + e.getStackTraceString());
            exceptionMessage = Label.HP_EC_InternalError; //Client side message
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.CUSTOM, exceptionMessage);
        }
        if (data != null) {
            data = buildJson('TelephoneValidation', JSON.serialize(data));
            HP_EC_UTL_CacheManager.putCacheData('TelephoneValidation'+telephone+pays, data);
        }
    return data;
}

//Adrsse de facturation GET SuggzstionDQE
@AuraEnabled(cacheable=true)
public static List<Map<String, Object>> getSuggestionsDQE(String input) {
    List<Map<String, Object>> data;
    String exceptionMessage;
    try {
        data = HP_CALL007_DQE.getSuggestionsDQE(input);
            System.debug('getSuggestionsDQE, data : '+data);
        }
        catch (Exception e) {
            System.debug('ERROR HP EC getSuggestionsDQE  : ' + e.getMessage() + ' ' + e.getStackTraceString());
            exceptionMessage = Label.HP_EC_InternalError; //Client side message
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.CUSTOM, exceptionMessage);
        }
    return data;
}

//Adresse de facturation GET ComplémentDQE
@AuraEnabled(cacheable=true)
public static List<Map<String, Object>> getComplementsDQE(String input) {
    List<Map<String, Object>> data;
    String exceptionMessage;
    try {
        data = HP_CALL007_DQE.getComplementsDQE(input);
            System.debug('getComplementsDQE, data : '+data);
        }
        catch (Exception e) {
            System.debug('ERROR HP EC getComplementsDQE  : ' + e.getMessage() + ' ' + e.getStackTraceString());
            exceptionMessage = Label.HP_EC_InternalError; //Client side message
            HP_EC_UTL_PortalExceptionManager.throwPortalException(HP_EC_UTL_PortalExceptionManager.ExceptionType.CUSTOM, exceptionMessage);
        }
    return data;
}
}