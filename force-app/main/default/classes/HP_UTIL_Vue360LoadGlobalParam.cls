/**
 * @File Name          : HP_UTIL_Vue360LoadGlobalParam.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Slimene Belhaj Ali
 * @Last Modified On   : 05-18-2021
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    20/04/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class HP_UTIL_Vue360LoadGlobalParam  implements HP_UTIL_ApexVue360Interface{
    public Object processing(Object param, Object rootParam) {
        Map<String, Object> result = new Map<String, Object>();
        result.put('permissionViewLog', FeatureManagement.checkPermission('HP_VIEW_LOG_VUE360'));
        result.put('TAD', FeatureManagement.checkPermission('HP_TAD'));
        result.put('urlAgilab', HP_SM003_MetadataManager.getAgilabEspaceClientURL());
        result.put('codeOffre', HP_SM003_MetadataManager.getCodeOffre());
        result.put('energieVert', HP_UTIL_MetadataManager.getConfigByKey('HP_ENERGIE_VERT_ACTIVATION'));
        return result;
    }
}