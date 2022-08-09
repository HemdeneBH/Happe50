/**
 * @File Name          : HP_UTIL_Vue360Manager.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Hemdene Ben Hammouda
 * @Last Modified On   : 11-25-2021
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    09/04/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public without sharing class HP_UTIL_Vue360Manager {
    public static Object rootParam;
    public static String contactId;
    public static boolean success = true;
    private static final String PAGESIZE_PARAM = 'size=50';
    public static ConfigWrapper loadConfigVue360(String rootConfig) {
        List<HP_Vue_360_API__mdt> allCongif = [select Id, DeveloperName, HP_Object_Result_Name__c, HP_Parent_ID__c, HP_Is_List__c,
                                    HP_Path_Field_Parent__c,  HP_Precessing__c, HP_Type__c, HP_Prefix_Parameter_API__c, HP_Need_ContactId__c 
                                    from HP_Vue_360_API__mdt where HP_Desactivate_Config__c != true];
        
        Map<String, List<HP_Vue_360_API__mdt>> configMap = new Map<String, List<HP_Vue_360_API__mdt>>();
        HP_Vue_360_API__mdt rootC = null;
        for(HP_Vue_360_API__mdt item : allCongif) {
            List<HP_Vue_360_API__mdt> currentList = configMap.get(item.HP_Parent_ID__c);
            if(currentList == null) {
                currentList = new List<HP_Vue_360_API__mdt>();
                configMap.put(item.HP_Parent_ID__c, currentList);
            }
            currentList.add(item);
            if(rootConfig == item.DeveloperName) {
                rootC = item;
            }
        }
        
        if(rootC == null) {
            return null;
        }
        return new ConfigWrapper(rootC, null, configMap);
    }

    public static Map<String, Object> loadDataVue360(String metadata, Object params, String recordId) {
        rootParam = params;
        contactId = recordId;
        datetime startCall = datetime.now();
        if(params instanceof Map<Object, Object>) {
            Map<String, Object> newParam = new Map<String, Object>();
            Map<Object, Object> paramCast = (Map<Object, Object>)params;
            for(Object key : paramCast.keySet()) {
                newParam.put(String.valueOf(key), paramCast.get(key));
            }
            params = newParam;
            
        }
        ConfigWrapper  configData = loadConfigVue360(metadata);
        Map<String, Object> result = new Map<String, Object>();

        loadData(getParamListFromPath(configData.parentFieldPath, params), configData, result);
        datetime endCall = datetime.now();
        Decimal duration = endCall.getTime() - startCall.getTime();
        
        result.put('idTransaction', HP_UTIL_HTTPUtils.getTransactionId());
        result.put('duration', duration); 
        result.put('success', success);
        return result;
    }
    public static void loadData(Object param, ConfigWrapper configData, Map<String, Object> parent) {
        System.debug('##@@ Contact Id : '+contactId);
        Object currentData = null;
        String fieldName = 'data';
        Object resultParam = param;
        if(configData.type == 'SOQL') {
            if(configData.parentFieldPath != null) {
                Map<String, Object> paramMap = (Map<String, Object>)param;
                resultParam = String.valueOf(paramMap.get(configData.parentFieldPath));
            }
            currentData = loadSoqlData(configData.processing, resultParam);
            parent.put(fieldName, currentData);
        }
        try{

        
            if(configData.type == 'API') {
            
                currentData = loadAPIData(configData.processing, param, configData.prefixApi);
                Map<String, Object> currentDataMap = (Map<String, Object>)currentData;
                Integer status = (Integer)currentDataMap.get('httpStatus');
                parent.put(fieldName, currentDataMap.get('data'));
                parent.put('status', status);
                parent.put('param', param);

                if(status >= 300 && status != 422) {
                    success = false;
                    return;
                }
            }
            
            if(configData.type == 'APEX') {
                currentData = loadApexData(configData, param);
                parent.put(fieldName, currentData);
            }
        }catch(LoadDataException e) {
            success = false;
            parent.put(fieldName, e.data);
            return;
        }
        if(configData.type == 'EMPTY') {
            currentData = loadEmptyData(param);
            parent.put(fieldName, currentData);
        }

        if(configData.childrenList == null || configData.childrenList.size() == 0) {
            return;
        }

        if(currentData == null) {
            return;
        }
        for(ConfigWrapper conf : configData.childrenList) {
            Object paramresult = getParamListFromPath(conf.parentFieldPath, currentData);
            if(conf.type == 'APEX') {
                Map<String, Object> child = new Map<String, Object>();
                parent.put(conf.objectName, child);
                loadData(paramresult, conf, child);
                continue;
            }
            Map<String, Object> paramMap = (Map<String, Object>)paramresult;
            boolean paramValid = true;
            for(Object item : paramMap.values()) {
                String paramCh = item + '';
                if((paramCh == 'null' || paramCh == '0') && conf.type != 'APEX') {
                    paramValid = false;
                }
            }

            if(!paramValid) {
                continue;
            }
            
            if(conf.isList) {
                List<Object> paramList = (List<Object>)paramMap.get(conf.parentFieldPath);
                Map<String, Object> childrenList = new Map<String, Object>();
                parent.put(conf.objectName, childrenList);
                for(Integer i = 0; i < paramList.size(); i ++) {
                    Map<String, Object> child = new Map<String, Object>();
                    childrenList.put('child-' + i + '-' + conf.objectName, child);
                    loadData(new Map<String, Object>{conf.parentFieldPath =>paramList.get(i)}, conf, child);
                }
                continue;
            }
            Map<String, Object> child = new Map<String, Object>();
            parent.put(conf.objectName, child);
            loadData(paramresult, conf, child);
        }
    }
    public static Object getParamListFromPath(String path, Object obj) {
        if(path == null) {
            return obj;
        }
        Map<String, Object> result = new Map<String, Object>();

        List<String> paramIdList = path.split(';');
        for(String item : paramIdList){
            result.put(item, getFieldFromPath(item, obj));
        }

        return result;
    }
    public static Object getFieldFromPath(String path, Object obj) {
        if(path == null) {
            return obj;
        }

        if(obj instanceof SObject) {
            List<SObject> sobj = (List<SObject>)obj;
            return sobj.get(0).get(path);
        } else {
            List<String> paramList = path.split('\\.');
            Map<String, Object> resultMap = (Map<String, Object>)obj;
            for(integer i = 0; i < paramList.size() - 1; i ++) {
                resultMap = (Map<String, Object>)resultMap.get(paramList.get(i));
            }
            return resultMap.get(paramList.get(paramList.size() - 1));
        }
    }
    public static Object loadSoqlData(String query, Object p1) {
    try{
        System.debug('@@ query ' + query);
        System.debug('@@ p1 ' + p1);
        return Database.query(query);
    } catch(Exception e) {
        success = false;
        throw new LoadDataException(new Map<String, Object>{'errorMessage' =>e.getMessage(), 'stack' =>e.getStackTraceString(), 'type' => e.getTypeName()});
    }
    }
    
    public static Object loadApexData(ConfigWrapper configData, Object p1) {
        try{
            HP_UTIL_ApexVue360Interface apexClass = (HP_UTIL_ApexVue360Interface) Type.forName(configData.processing).newInstance();
            if(configData.needContactId){
                return apexClass.processing(p1, contactId);
            }else{
                return apexClass.processing(p1, rootParam);
            }
        } catch(Exception e){
            success = false;
            throw new LoadDataException(new Map<String, Object>{'errorMessage' =>e.getMessage(), 'stack' =>e.getStackTraceString(), 'type' => e.getTypeName()});
        }
        
    
    }

    public static Object loadEmptyData(Object p1) {
        return p1;
    }

    public static Object loadAPIData(String endpoint, Object p1, String prefixParam) {
        //try{
            Map<String, Object> param = (Map<String, Object>) p1;
            String endpointValue = HP_UTIL_HTTPUtils.getEndPointValueByConfigName(endpoint);

            for(String key : param.keyset()){
                prefixParam = prefixParam.replace('{' + key + '}', param.get(key) + '');
            }
            prefixParam = (endpointValue.contains('?') || prefixParam.contains('?')) ? (prefixParam+'&'+PAGESIZE_PARAM) : (prefixParam+'?'+PAGESIZE_PARAM);
            try{
                HttpResponse response = HP_UTIL_HTTPUtils.calloutGet(endpoint, prefixParam, Integer.valueOf(HP_UTIL_MetadataManager.getConfigByKey('HP_HTTP_TIMEOUT')));
                Object result = (Object)JSON.deserializeUntyped(response.getBody());
                return new Map<String, Object>{
                 'data' =>(Object)JSON.deserializeUntyped(response.getBody()),
                  'httpStatus' => response.getStatusCode()};
            }catch(HP_UTIL_HTTPUtils.TimeoutException e) {
                success = false;
                throw new LoadDataException(new Map<String, Object>{'endpoint' => e.req.getEndpoint(),
                                                                    'requestBody' => (e.req.getBodyDocument() != null ? e.req.getBodyDocument().toXmlString() : e.req.getBody()),
                                                                    'method' => e.req.getMethod(),
                                                                    'limitTimeout' => HP_UTIL_MetadataManager.getConfigByKey('HP_HTTP_TIMEOUT'),
                                                                    'errorMessage' =>e.getMessage(),
                                                                    'stack' =>e.getStackTraceString(),
                                                                    'type' => e.getTypeName()
                                                                    });
            }
             catch(Exception e) {
                throw new LoadDataException(new Map<String, Object>{ 'errorMessage' =>e.getMessage(), 'stack' =>e.getStackTraceString(), 'type' => e.getTypeName()});
            }
           
            
            
       /* }catch(Exception e){
            return null;
        }*/
    } 

    public class ConfigWrapper {
        public String type;
        public String processing;
        public String objectName;
        public ConfigWrapper parent;
        public String parentFieldPath;
        public String prefixApi;
        public String idService;
        public Boolean isList;
        public Boolean needContactId;
        public List<ConfigWrapper> childrenList;
        public ConfigWrapper(HP_Vue_360_API__mdt configMD, ConfigWrapper parent, Map<String, List<HP_Vue_360_API__mdt>> configMap) {
            this.type = configMD.HP_Type__c;
            this.processing = configMD.HP_Precessing__c;
            this.objectName = configMD.HP_Object_Result_Name__c;
            this.parentFieldPath = configMD.HP_Path_Field_Parent__c;
            this.parent = parent;
            this.prefixApi = configMD.HP_Prefix_Parameter_API__c;
            this.idService = configMD.DeveloperName;
            this.isList = configMD.HP_Is_List__c;
            this.needContactId = configMD.HP_Need_ContactId__c;
            List<HP_Vue_360_API__mdt> childrenConf = configMap.get(configMD.DeveloperName);
            if(childrenConf == null) {
                return;
            }
            this.childrenList = new List<ConfigWrapper>();
            for(HP_Vue_360_API__mdt conf : childrenConf) {
                this.childrenList.add(new ConfigWrapper(conf, this, configMap));
            }
        }
    }

    public class LoadDataException extends Exception {
        public Object data;
        public LoadDataException(Object data) {
            this.data = data;
        }
    }

}