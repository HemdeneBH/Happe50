/**
 * @description       : 
 * @author            : Slimene Belhaj Ali
 * @group             : 
 * @last modified on  : 04-20-2021
 * @last modified by  : Slimene Belhaj Ali
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   04-19-2021   Slimene Belhaj Ali   Initial Version
**/
public with sharing class HP_UTIL_Vue360EnergieVert implements HP_UTIL_ApexVue360Interface {
    public static Object processing(Object param, Object rootParam) {
        Map<String, Object> mapParam = (Map<String, Object>)param;
        if(mapParam.get('data') == null) {
            return null;
        }
        mapParam = (Map<String, Object>)mapParam.get('data');
        List<Object> contratList = (List<Object>)mapParam.get('_data');
        Map<String, Object> result = new Map<String, Object>();
    
        for(Object item : contratList) {
           try{
            Map<String, Object> cont = (Map<String, Object>) item;
               if(!String.valueOf(cont.get('energie')).contains('Electricité')) {
                   continue;
               }
           
            String status = String.valueOf(cont.get('codeStatutCrm'));
            if(status != 'H0105' && status != 'H0101' && status != 'H0102' && status != 'E0004' && status != 'E0007') {
                continue;
            }
            HTTPResponse response = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.AGILAB_HAPPE_ENEGIE_VERT, 'id_contrat_xdata=' + String.valueOf(cont.get('id')));   
            Map<String, Object> resultVert = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            resultVert.put('id', cont.get('id'));
            result.put(String.valueOf(cont.get('idPortefeuilleContrat')), resultVert);
           }catch(Exception e) {}
           
        
        }
       
        return result;
    }
}