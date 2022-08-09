global class SM_AP90_BPMfelmodifstatut implements vlocity_cmt.VlocityOpenInterface {
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        try{
            modifstatusfel(inputMap,outMap,options);
            return true;
        }catch(exception ex){
            system.debug('Exception Message = '+ex.getMessage()+' Trace = '+ex.getStackTraceString());
            return false;
        }
        
    }

    public static void modifstatusfel(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options){
        String email;
        //system.debug('### inputMap '+inputMap);
        String email1 = (String) inputMap.get('emailprincipalsel');// email principal à sélectionner lorsque l'espace client n'est pas actif
        String email2 = (String) inputMap.get('emailsaisie'); // email saisie si pas d'email sur la fiche 
        String email3 = (String) inputMap.get('emailprincipal');// email fiche client
        String idcompteclient = (String) inputMap.get('idcompteclient');
        String idpersonne = (String) inputMap.get('idpersonne');
        String idPropositionCommerciale = (String) inputMap.get('idPropositionCommerciale') != null ? (String) inputMap.get('idPropositionCommerciale') : '';
       //FT2-1126 (formater le type de 'idContrat')
        String idContrat = String.valueOf(inputMap.get('idContrat'));
        if(!String.isBlank(email1)) {
            email = email1;
        }else if(!String.isBlank(email2)){
            email = email2;
        }else{
            email = email3;
        }
        system.debug('## email '+email);
      
        SM_AP89_GestionSouscriptionService.demanderSouscriptionService(email,idcompteclient,idpersonne,idPropositionCommerciale,outMap);
        system.debug('codeRetourFEL'+outMap.get('code'));
    }
}