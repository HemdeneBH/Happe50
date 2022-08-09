/**
 * @File Name          : HP_ExternalIdUtils.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 11/02/2020 à 14:24:53
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    11/02/2020   Mouhamadoune Coulibaly     Initial Version
**/
public with sharing class HP_ExternalIdUtils {
    private static final String ITEM_EXTERNAL_ID_SEPARATOR = '/';
    public static String itemExternalIdBuilder(final String itemReference, final String externalKey) {
        return itemReference + ITEM_EXTERNAL_ID_SEPARATOR + externalKey;
    }

    //TODO merge with HP_ExternalIdUtils.itemExternalIdBuilder / case
    public static string createExternalKey(String caseKey, String caseDeveloperName){
        return (caseKey + caseDeveloperName);
    }
}