global class SM_ProcessContrat implements vlocity_cmt.VlocityOpenInterface {
/****************************************************
* @PERF: Remplacement Contrat de WS vers API
* @date: 02/05/2018
* @Project: Smile
****************************************************/

global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
  
    if (methodName.equals('Process')) {
        process(inputMap, outMap, options);
    }
  return false;
 }
 
 public Boolean process(Map<String, Object> input, Map<String, Object> output, Map<String, Object> options){           
    
     if(((List <Object>) input.get('_data')).size()>0){
         Map <String,Object> obj1 = (Map<String,Object>)(((List <Object>) input.get('_data')).get(0));
         String uniteReleve = (String) obj1.get('uniteReleve');
         if(uniteReleve != null){
             Output.put('uniteReleve',uniteReleve.subString(uniteReleve.length() - 1, uniteReleve.length()));
         }else Output.put('uniteReleve','');
     }
     /**Switch to WS
     Integer j=0;
     Map <String,Object> GazActif = new Map <String,Object>();
     Map <String,Object> ElecActif = new Map <String,Object>();
     
     Integer nbElecInactif = 0;
     Integer nbGazInactif = 0;
     //INIT
    GazActif.put('ActiveGaz','N');
    ElecActif.put('ActiveElec','N');
     
     // MoreFlag
     GazActif.put('MoreGazFlag',false);
    ElecActif.put('MoreElecFlag',false);
     
     Map <String,Object> obj3 = new Map <String,Object>();
     Map <String,Object> obj4 = new Map <String,Object>();
     
     // s.subString(s.length() - i, s.length())
     for (Object obj: (List <Object>) input.get('_data')){
         Map <String,Object> obj2 = (Map<String,Object>)obj;          
         
         //Contrat Actif Gaz
         If((obj2.get('typeContrat')=='GN' || obj2.get('typeContrat')=='GP')
            &&(obj2.get('codeStatutContratCRM')=='E0001' ||obj2.get('codeStatutContratCRM')=='E0003' ||obj2.get('codeStatutContratCRM')=='E0004' 
            ||obj2.get('codeStatutContratCRM')=='E0005' ||obj2.get('codeStatutContratCRM')=='E0006'||obj2.get('codeStatutContratCRM')=='E0007'||obj2.get('codeStatutContratCRM')=='E0008')
           ){
              obj2.remove('_links');
              GazActif = obj2;
              GazActif.put('ActiveGaz','O');
              GazActif.put('statut','Activé');
              //GazActif.put('dateDebutContrat',((String)GazActif.get('dateDebutContrat')).substring(8,10)+'/'+((String)GazActif.get('dateDebutContrat')).substring(5,7)+'/'+((String)GazActif.get('dateDebutContrat')).substring(0,4));
              GazActif.put('dateDebutContrat',transnformDateFR ((String)GazActif.get('dateDebutContrat')));
           }
         //Contrat Actif Elec
         If((obj2.get('typeContrat')=='E' || obj2.get('typeContrat')=='EV')
            &&(obj2.get('codeStatutContratCRM')=='E0001' ||obj2.get('codeStatutContratCRM')=='E0003' ||obj2.get('codeStatutContratCRM')=='E0004' 
            ||obj2.get('codeStatutContratCRM')=='E0005' ||obj2.get('codeStatutContratCRM')=='E0006'||obj2.get('codeStatutContratCRM')=='E0007'||obj2.get('codeStatutContratCRM')=='E0008')
           ){
              obj2.remove('_links');
              ElecActif = obj2;
              ElecActif.put('ActiveElec','O');
              ElecActif.put('statut','Activé');
              ElecActif.put('dateDebutContrat',transnformDateFR ((String)ElecActif.get('dateDebutContrat')));
             
           }
         //Elec Inactif
         If((obj2.get('typeContrat')=='E' || obj2.get('typeContrat')=='EV')
            &&(obj2.get('codeStatutContratCRM')=='E0009')
           ){  
               
               nbElecInactif++;
               if(nbElecInactif ==1){
                 obj3=obj2;
               }else{
                   obj3=compareDate((String)obj3.get('dateFinContrat'),(String)obj2.get('dateFinContrat'))?obj3:obj2;
               }    
               
           }
         //Gaz Inactif
       If((obj2.get('typeContrat')=='GN' || obj2.get('typeContrat')=='GP')
            &&(obj2.get('codeStatutContratCRM')=='E0009')
           ){
            nbGazInactif++;
               if(nbGazInactif ==1){
                 obj4=obj2;
               }else{
                   obj4=compareDate((String)obj4.get('dateFinContrat'),(String)obj2.get('dateFinContrat'))?obj4:obj2;
               }  
           }
     }
     if( nbElecInactif>0){
          obj3.remove('_links');
          ElecActif.put('Inactive',new Map <String,Object> {'dateDebutContrat' => transnformDateFR((String)obj3.get('dateDebutContrat')),'dateFinContrat' => transnformDateFR((String)obj3.get('dateFinContrat')), 'libelleOffre' => obj3.get('libelleOffre')});
          if(nbElecInactif>1) 
              ElecActif.put('MoreElecFlag',true);
     }
     if( nbGazInactif>0){
         obj4.remove('_links');
         GazActif.put('Inactive',new Map <String,Object> {'dateDebutContrat' => transnformDateFR((String)obj4.get('dateDebutContrat')),'dateFinContrat' => transnformDateFR((String)obj4.get('dateFinContrat')), 'libelleOffre' => obj4.get('libelleOffre')});
         if( nbGazInactif>1)
         	GazActif.put('MoreGazFlag',true);
     }
     output.put('ElecActif',ElecActif);
     output.put('GazActif',GazActif);
      *///Switch to WS
     return true; 
     
    } 
    /*Switch to WS
      private String transnformDateFR (String sdate){
          if(sdate!=null)
          	return (sdate.substring(8,10)+'/'+sdate.substring(5,7)+'/'+sdate.substring(0,4));
          else return null;
     }
    
    
    public Boolean compareDate(String s1,String s2){
    Date convertedDate = Date.valueOf(s1);
    Date convertedDate2 = Date.valueOf(s2);
        // s2 est plus recent 
        if(convertedDate.daysBetween(convertedDate2) < 0){
            return true;        
        }
        return false;
}
*/   
}