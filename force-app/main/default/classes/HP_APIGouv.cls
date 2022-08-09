/**
 * @File Name          : HP_APIGouv.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 07-15-2020
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    08/04/2020   Mouhamadoune Coulibaly     Initial Version
**/
public with sharing class HP_APIGouv {//TODO appropriate name

    @AuraEnabled(cacheable=true)
    public static HP_WRP035_APIGouv getSuggestions(String input) {
        //utiliser urlEncode pour gerer les accents 
        input = EncodingUtil.URLENCODE(input,'UTF-8');
        HttpResponse res =    HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.API_GOUV, input);
        HP_WRP035_APIGouv wrpbody = HP_WRP035_APIGouv.parse(res.getBody());        
        return wrpbody;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getSuggestionsDQE(String input) {
        //utiliser urlEncode pour gerer les accents 
        input = '?Pays=FRA&Adresse=' + EncodingUtil.URLENCODE(input,'UTF-8');

        HttpResponse res =    HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.XDATA_PROTECTED_DQE_ADDRESS, input);
        System.debug('@@ DQE body : ' + res.getBody());
        Map<String, Object> addressMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        List<Map<String, Object>> result = new List<Map<String, Object>>();
        for(String key : addressMap.keySet()) {
            Map<String, Object> currentAdd = (Map<String, Object>)addressMap.get(key);
            result.add(new Map<String, Object>{'codePostal' => currentAdd.get('CodePostal'),
            'label' => currentAdd.get('label'),
            'numero' => currentAdd.get('Numero'),
            'voie' => currentAdd.get('Voie'),
            'complement' => currentAdd.get('Complement'),
            'pays' => currentAdd.get('Pays'),
            'idLocalite' => currentAdd.get('IDLocalite'),
            'id' => key,
            'ville' => currentAdd.get('Localite')});
        }

        //HP_WRP035_APIGouv wrpbody = HP_WRP035_APIGouv.parse(res.getBody());        
        return result;
    }
}