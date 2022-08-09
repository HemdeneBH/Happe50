global with sharing class SM_AP50_UpdateSateSouhaiteGAz implements vlocity_cmt.VlocityOpenInterface {
    
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        
        if (methodName.equals('updateDateSOuhaite')) {
            try {
                updateDate(inputMap, outMap, options);
            } catch (Exception e) {
                system.debug(e);
                //throw e;
                
            }
            return true;
        }
        return true;
    }
    
    
    public static void updateDate(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        
        
        Map < String, Object > prestationGaz = (Map < String, Object > ) inputMap.get('PrestationGaz');
        Map < String, Object > infor = (Map < String, Object > ) prestationGaz.get('InformationsdeprestationGaz');
        
        if (inputMap.get('pdlinfo') != null && ((Map < String, Object > ) inputMap.get('pdlinfo')).get('miseHorsServiceEnCours') != null &&
            ((boolean)((Map < String, Object > ) inputMap.get('pdlinfo')).get('miseHorsServiceEnCours')) == true) {
                if(((Map < String, Object > ) inputMap.get('pdlinfo')).get('dateMiseHorsService') != null){
                    String dateMHS = (String)((Map < String, Object > ) inputMap.get('pdlinfo')).get('dateMiseHorsService');
                    infor.put('DateEffetSouhaiteGaz', dateMHS.substring(0, 10));
                    prestationGaz.put('InformationsdeprestationGaz', infor);
                }else{
                    String EffectiveDate = (String)((Map < String, Object > ) inputMap.get('ChoixElements')).get('EffectiveDate');
                    Date date1 = Date.valueOf(EffectiveDate) + 1;
                    infor.put('DateEffetSouhaiteGaz', String.valueOf(date1).subString(0, 10));
                    prestationGaz.put('InformationsdeprestationGaz', infor);
                    
                    
                }
            } else {
                String EffectiveDate = (String)((Map < String, Object > ) inputMap.get('ChoixElements')).get('EffectiveDate');
                Date date1 = Date.valueOf(EffectiveDate) + 1;
                infor.put('DateEffetSouhaiteGaz', String.valueOf(date1).subString(0, 10));
                prestationGaz.put('InformationsdeprestationGaz', infor);
            }
        //    PrestationGaz.InformationsdeprestationGaz.DateEffetSouhaiteGaz
        
        
        
        outMap.put('PrestationGaz', prestationGaz);
    }
    
}