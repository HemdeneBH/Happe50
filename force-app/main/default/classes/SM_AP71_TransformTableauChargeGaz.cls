global class SM_AP71_TransformTableauChargeGaz  implements vlocity_cmt.VlocityOpenInterface {
    
    
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        
        if (methodName.equals('transformTableauCharge')) {
            
            transformTableauCharge(inputMap, outMap, options) ;
            
        }
        return true ;
    }
    
    
    private void transformTableauCharge(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
        
        Map<String,Object>  tableau =   (  Map<String,Object>  )      inputMap.get('tableauDeChargeGaz') ;
        List<Object>  creneauDisponibleNew = new List<Object>() ;
        List<Object>  creneauDisponibleOld = ( List<Object>  ) tableau.get('creneauDisponible') ;
        system.debug('creneauDisponibleOld'+creneauDisponibleOld) ;
        for(Object creneauDisponible : creneauDisponibleOld) {
            try{
                Map<String,Object> creneau = new Map<String,Object>() ;
                Map<String,String> creneauHoraire = new Map<String,String>() ;
                creneauHoraire.put('code', (String)   ((Map<String,Object>)    ((Map<String,Object>)  ((Map<String,Object>) creneauDisponible ).get('creneauHoraire')).get('code') ).get('#text') ) ;
                creneauHoraire.put('libelleCourt',(String) ((Map<String,Object>)    ((Map<String,Object>)  ((Map<String,Object>) creneauDisponible ).get('creneauHoraire')).get('libelleCourt') ).get('#text')  ) ;
                creneau.put('creneauHoraire', creneauHoraire ) ;
                creneau.put('date', (String) ((Map<String,Object>)  ((Map<String,Object>) creneauDisponible ).get('date')).get('#text')  ) ;
                creneauDisponibleNew.add(creneau) ;
            }catch(Exception e){
                System.debug(e.getStackTraceString()) ;
            }
        }
        tableau.put('creneauDisponible', creneauDisponibleNew) ;
        outMap.put('tableauDeChargeGaz', tableau) ;
        System.debug('tableaucharge'+tableau) ;
        System.debug(json.serialize(tableau)) ;
        
    } 
}