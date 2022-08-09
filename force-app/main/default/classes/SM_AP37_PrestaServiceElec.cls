/*
* @Author: 
* @Date: 11/02/2019
* @Description: Vlocity class for prestation Service Elec
*/
global with sharing class SM_AP37_PrestaServiceElec implements vlocity_cmt.VlocityOpenInterface{
    
    public static SM_UTIL_Cache_Management service = new SM_UTIL_Cache_Management();
 	
    
    /*
    * @Author: 
    * @Date: 11/02/2019
    * @Description: invoke method for vlocity
    */
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

     if (methodName.equals('lirePrestationElecOnline')) {
            try {
                lirePrestationElecOnline(inputMap, outMap, options);
              } catch (Exception e) {
                system.debug(e.getStackTraceString());
                return false;
            }
        } 
        else if (methodName.equals('modifierPrestationElec')) {
            try {
                modifierPrestationElec(inputMap, outMap, options);
              } catch (Exception e) {
                system.debug(e.getStackTraceString());
                return false;
            }
        } 
        else if(methodName.equals('lirePrestationElec')){
            try{
                // à appeler pour recuprer les details de la pretation après la creation 
                lirePrestationElec(inputMap, outMap, options);
            }catch(Exception e ){
                
                if( ! (e instanceof IOexception)){
                    // exception non géré
                    system.debug(e.getStackTraceString());
                    system.debug(e.getMessage());
                    e.setMessage('Erreur technique est survenue !') ;
                }
                throw e ;  
            }
        } 
        else if (methodName.equals('lirePrestationElecList')) {
            try {
                lirePrestationElecList(inputMap, outMap, options);
              } catch (Exception e) {
                system.debug(e.getStackTraceString());
                return false;
            }
        } 
        else if (methodName.equals('rechercherPrestationElec')) {
            try {
                rechercherPrestationElec(inputMap, outMap, options);
              } catch (Exception e) {
                system.debug(e.getStackTraceString());
                return false;
            }
        }
        else if (methodName.equals('lirePrestationElecOffline')) {
            try {
                lirePrestationElecOffline(inputMap, outMap, options);
              } catch (Exception e) {
                system.debug(e.getStackTraceString());
                return false;
            }
        }
        return true;
    }

    /*
    * @Author: 
    * @Date: 11/02/2019
    * @Description: init context
    */
    public static gdfsuezComBefChpPSEPivot.contextDt initContext(String application, String version){
         // Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
        gdfsuezComBefChpPSEPivot.contextDt_systemPath_system_element osource = new gdfsuezComBefChpPSEPivot.contextDt_systemPath_system_element();
        osource.systemId=application;
        gdfsuezComBefChpPSEPivot.contextDt octx = new gdfsuezComBefChpPSEPivot.contextDt();
        octx.version=version;
        //  octx.allowCache = false ;
        octx.systemPath = new gdfsuezComBefChpPSEPivot.contextDt_systemPath_element();
        octx.systemPath.system_x = new gdfsuezComBefChpPSEPivot.contextDt_systemPath_system_element[]{osource};
        return octx;
    }

    /*
    * @Author: OMH
    * @Date: 19/02/2019
    * @Description: lire PrestationElec online method called by omniscript
    */ 
    public void lirePrestationElecOnline(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options){      
        System.debug('**** IN lirePrestationElec');

        // A récupérer depuis vue 360
        
        String idPrestationDistributeur = String.valueOf(inputMap.get('idPrestationDistributeur'));
        String idPrestationFournisseur = String.valueOf(inputMap.get('idPrestationFournisseur'));
        //idPrestationDistributeur = 'A02W3JUG'; //'A03QHW6P';
        String typeCard =String.valueOf(inputMap.get('TypeCard'));
        String typeUser =String.valueOf(inputMap.get('TypeUser'));
        
        system.debug('@SM AP37 : idPrestationDistributeur : '+idPrestationDistributeur);      
        system.debug('@SM AP37 : TypeCard : '+typeCard);
        system.debug('@SM AP37 : TypeUser : '+typeUser);

        if(String.isBlank(idPrestationDistributeur) || typeCard != 'ELEC'){
            System.debug('*** 1 or more fields required empty');
            return ;
        }

        gdfsuezComBefChpPSEPivot.contextDt octx = initContext('Smile', '2.0'); 

        gdfsuezBefCalypsoPrestationServiceElec.Dependency port = new gdfsuezBefCalypsoPrestationServiceElec.Dependency() ;  
        SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();   
        port.clientCertName_x = octopusCS.certName__c;
        port.endpoint_x =  octopusCS.endpoint__c+'ES-PrestationServiceElec_v3';
        //port.endpoint_x =  'callout:AuthOctopus/ES-PrestationServiceElec_v3';
        System.debug('*** endpoint : ' + port.endpoint_x);
        port.inputHttpHeaders_x = new Map<String, String>{'Content-Type' => 'text/xml;charset=utf-8'}; 

        gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteInputDt input = new gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteInputDt();
        
        // Donnees générales
        input.prestationServiceElectricite = new gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteInputDt_prestationServiceElectricite_element[1];
        input.prestationServiceElectricite[0] = new gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteInputDt_prestationServiceElectricite_element();
        input.prestationServiceElectricite[0].idPrestationServiceDistributeur = idPrestationDistributeur;
        
        input.online = true;
        if(typeUser == 'Client'){
            input.loginUtilisateur = 'part@engie.com';
            //OMH 19/02 SMIL-1985
            input.typeOffre = new gdfsuezComBefChpPSEPivot.listeValeursDt();
            input.typeOffre.code = 'INDUSTRIELLE';
            input.prestationServiceElectricite[0].idPrestationServiceFournisseur = idPrestationFournisseur;
            
            System.debug('param Client OK');
        }
        else{
            if(!Test.isRunningTest())
            input.loginUtilisateur = service.getIdentifiantDistribFromApex();
        }
        
        system.debug('loginUtilisateur : '+input.loginUtilisateur);

   

        gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteResponse_element response ; 
        
        if(!Test.isRunningTest()){
            response  = port.LirePrestationServiceElectricite_Http(input,octx);
        }
        else {
            Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPSEcHttpMock());
            gdfsuezBefCalypsoPrestationServiceElec.Dependency porttest = new gdfsuezBefCalypsoPrestationServiceElec.Dependency();
            system.debug('@@ start of mock');
            response = porttest.LirePrestationServiceElectricite_Http(input, octx);
            system.debug('@@ end of mock');
        }
        
        System.debug('**** response : ' + response);
        System.debug('**** response code : ' + response.messageRetours.retourTraitementMessage[0].code);
        
        outMap.put('code_retour_ops', response.messageRetours.retourTraitementMessage[0].code);
        
        if (response != null && response.lirePrestationServiceElectriciteOutput != null && response.lirePrestationServiceElectriciteOutput.prestationServiceLire.size() > 0) {
            
           outMap.putAll(transformData(inputMap, response.lirePrestationServiceElectriciteOutput.prestationServiceLire[0]));
        }
        outMap.putAll(inputMap);

        System.debug('**** OUT lirePrestationElec');
    }

    /*
    * @Author: 
    * @Date: 11/02/2019
    * @Description: transformData
    */ 
    public Map<String, Object> transformData(Map<String, Object> input, gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteOutputDt_prestationServiceLire_element response){
        Map<String, Object> newOutputMap = new Map<String, Object>();
        
        String typeUser =String.valueOf(input.get('TypeUser'));
         
        if(response.interventions != null && response.interventions != null && response.interventions.intervention != null  && response.interventions.intervention.planifications != null && response.interventions.intervention.planifications.planification != null){
            gdfsuezBefCalypsoPrestationServiceElec.planificationDt node = response.interventions.intervention.planifications.planification[response.interventions.intervention.planifications.nbPlanif - 1];
            Datetime datetimePrevue = node.datePrevue;
           
         /*   System.debug('surSite'+ node.surSite);
            system.debug('heureDebutPrevue' + node.surSite.heureDebutPrevue);*/
            
            if(node.surSite != null && node.surSite.creneauHorairePrevu != null){
                
                newOutputMap.put('heureDebut', node.surSite.heureDebutPrevue);
                newOutputMap.put('heureFin', node.surSite.heureFinPrevue);
                newOutputMap.put('creneauRetenu', node.surSite.creneauHorairePrevu.libelleCourt);
                
                String creneauRetenuCode = node.surSite.creneauHorairePrevu.code;
                
                if(typeUser == 'Client'){
                     newOutputMap.put('creneauRetenuCode', creneauRetenuCode );
                }
                else{
                     newOutputMap.put('creneauRetenuCode', creneauRetenuCode.toLowerCase() );
                }
               
            }
            
            if(dateTimePrevue != null && Date.today().addDays(2) >= dateTimePrevue && dateTimePrevue >= Date.today()){
                newOutputMap.put('moins48h', '1');
            }
            else{
                 newOutputMap.put('moins48h', '0');
            }
            
            //newOutputMap.put('datePrevue', String.valueOf(datetimePrevue));
            newOutputMap.put('datePrevue',String.valueOf(datetimePrevue.year()+'/'+datetimePrevue.month()+'/'+datetimePrevue.day()));
            system.debug('datePrevue'+ String.valueOf(datetimePrevue.year()+'/'+datetimePrevue.month()+'/'+datetimePrevue.day()));
            newOutputMap.put('noIntervention',false);
        }
        else{
            newOutputMap.put('noIntervention',true);
        }
        
        //modif Om 19/02
        if(response.donneesGenerales != null && response.donneesGenerales.donneesPDL != null){
            newOutputMap.put('pdl', response.donneesGenerales.donneesPDL.idPDLElectricite);
        }
        
       
        if(response.demande != null && response.demande.interlocuteurIntervention != null){
            if(response.demande.interlocuteurIntervention.personnePhysique != null){
                newOutputMap.put('nom', response.demande.interlocuteurIntervention.personnePhysique.nom);
                newOutputMap.put('prenom', response.demande.interlocuteurIntervention.personnePhysique.prenom);
                
                if(response.demande.interlocuteurIntervention.personnePhysique.civilite != null){
                    newOutputMap.put('civilite', response.demande.interlocuteurIntervention.personnePhysique.civilite.code);
                }
            }
            
            if(response.demande.interlocuteurIntervention.coordonneesContact!= null && response.demande.interlocuteurIntervention.coordonneesContact.telephone != null && response.demande.interlocuteurIntervention.coordonneesContact.telephone.size() > 0){ //coordonneesContactDt 
                newOutputMap.put('tel', response.demande.interlocuteurIntervention.coordonneesContact.telephone[0]);
            }

        }
        
        if(response.demande != null && response.demande.disponibilite != null){
            
            
            if(response.demande.disponibilite.dateInterventionSouhaitee != null){
                Datetime dateDispo = response.demande.disponibilite.dateInterventionSouhaitee;
                String day = String.valueOf(dateDispo.day());
                String month = String.valueOf(dateDispo.month());
                String year = String.valueOf(dateDispo.year());
                
                if(dateDispo.day() < 10){
                    day = '0' + day;
                }
                if(dateDispo.month() < 10){
                    month = '0' + month;
                }
                newOutputMap.put('disponibilite', day + '/' + month + '/' + year); 
                 system.debug('disponibilite' + day + '/' + month + '/' + year); 
            }
        }        
        
        
        //Modif OM 20/02
        //Get comment in  prestationServiceLire / demande / donneesGeneralesDemande / commentaire for client 
        String comments = '';
        String commentsClient = '';
        String codeLibelle = '';
        system.debug('response.demande.donneesGeneralesDemande ' + response.demande.donneesGeneralesDemande);
        if(response.demande.donneesGeneralesDemande != null){   
            commentsClient = response.demande.donneesGeneralesDemande.commentaire;
            system.debug('commentaire' + comments);
            if(response.demande.donneesGeneralesDemande.typePrestationService != null 
               && response.demande.donneesGeneralesDemande.typePrestationService.fiche != null
               && response.demande.donneesGeneralesDemande.typePrestationService.fiche.code != null){
                   codeLibelle = response.demande.donneesGeneralesDemande.typePrestationService.fiche.code;
                   system.debug('codeLibelle' + codeLibelle);      
            }
        }
        
        //Set the comment by user type
        if(typeUser == 'Client'){
            if(codeLibelle =='F100A' || codeLibelle =='F100B' || codeLibelle =='F120A' || codeLibelle =='F120B'  ){
                newOutputMap.put('libelle', 'Mise en service dans votre nouveau logement');
            }
            else if(codeLibelle =='F140' || codeLibelle =='F140A'){
                newOutputMap.put('libelle', 'Coupure dans votre ancien logement');
            }
            else{
                newOutputMap.put('libelle', '');
            }
            
            comments = commentsClient;
        }
        else{
            comments = (String) input.get('commentaires');
        }
        
        newOutputMap.put('commentaires', comments);
     
         
         
         String commentaireOffline =  (String) input.get('commentaires');
         system.debug('commentaireOffline' + commentaireOffline );
        if(!String.isBlank(commentaireOffline ) && commentaireOffline.contains('PO')){
            newOutputMap.put('presence', '1');
        } 
        else if (!String.isBlank(commentaireOffline ) && commentaireOffline.contains('PNO')){
            newOutputMap.put('presence', '2');
        }
        else if (!String.isBlank(commentaireOffline ) && commentaireOffline.contains('WSKO')){
            newOutputMap.put('presence', '0');
        }
        
        newOutputMap.put('refExterne', response.idPrestationServiceDistributeur);
        newOutputMap.put('refInterne', response.idPrestationServiceFournisseur);
        newOutputMap.put('idContrat' , response.donneesGenerales.idContrat);

        
        /*String g1g2 = (String) input.get('G1G2');
        if(!String.isBlank(g1g2) && g1g2 == 'O'){
            newOutputMap.put('fraisPrestation', (String) input.get('montantPrevisionnel'));
        } else if(!String.isBlank(g1g2) && g1g2 == 'N'){
            newOutputMap.put('fraisPrestation', (String) input.get('fraisPrestation'));
        }*/
        //newOutputMap.put('montant', (String) input.get('montantPrevisionnel'));
        
      
        System.debug('*** Return map : ' + newOutputMap);
        return newOutputMap;
    }

    /*
    * @Author: 
    * @Date: 11/02/2019
    * @Description: Modifier PrestationElec method called by omniscript
    */ 
    public void modifierPrestationElec(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options){
        System.debug('*** IN modifierPrestationElec');
        System.debug('*** Params');
        
        outMap.put('updOpsElec_code', '');

       /* for(String aKey : inputMap.keyset()){
            System.debug(aKey + ' : ' + inputMap.get(aKey));
        }   */
        
        String typeUser= String.valueOf(inputMap.get('TypeUser'));
        
        Map<String, Object> opsUpdate = (Map<String, Object>) inputMap.get('OPSUpdate');
        System.debug('@AP37 : opsUpdate : '+opsUpdate);
        String nom = (String) opsUpdate.get('LastName');
        String prenom = (String) opsUpdate.get('FirstName');
        String civilite = (String) opsUpdate.get('Civility');
        String tel = (String) opsUpdate.get('PhoneNumber');
        String creneau = (String) opsUpdate.get('Creneau');
        String datePrevue = (String) opsUpdate.get('DateEffetSouhaite');
        String comments = (String) opsUpdate.get('EGDComment');
        
        if(String.isBlank(comments)){
            comments = '-';
        }
        
        String idPrestationF = '';
        String idPrestationD = '';
        if(typeUser == 'Client'){
            
            idPrestationF= (String) opsUpdate.get('idF');
            idPrestationD = (String) opsUpdate.get('idD');   
        }
        else{
            idPrestationF = (String) inputMap.get('idF');
            idPrestationD = (String) inputMap.get('idD'); 
        }
        
        if(String.isBlank(nom) || String.isBlank(civilite)){
            outMap.put('updOpsElec_code', 'ERR_CIVNAME');
            return;
        }
        
        gdfsuezComBefChpPSEPivot.contextDt octx = initContext('Smile', '2.0'); 

        gdfsuezBefCalypsoPrestationServiceElec.Dependency port = new gdfsuezBefCalypsoPrestationServiceElec.Dependency() ;  
        SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();   
        port.clientCertName_x = octopusCS.certName__c;
        port.endpoint_x =  octopusCS.endpoint__c+'ES-PrestationServiceElec_v3';
        System.debug('*** endpoint : ' + port.endpoint_x);
        port.inputHttpHeaders_x = new Map<String, String>{'Content-Type' => 'text/xml;charset=utf-8'}; 

        gdfsuezBefCalypsoPrestationServiceElec.replanifierRDVPrestationServiceElectriciteInputDt input = new gdfsuezBefCalypsoPrestationServiceElec.replanifierRDVPrestationServiceElectriciteInputDt ();
        
        input.online = true;
        input.loginUtilisateur = '';
        if(typeUser == 'Client'){
          input.loginUtilisateur = 'part@engie.com';
        }
        else {
          input.loginUtilisateur = service.getIdentifiantDistribFromApex();
        }        
    
        input.commentaireIntervention = comments;
        input.idPrestationServiceDistributeur = idPrestationD;
        input.idPrestationServiceFournisseur = idPrestationF;
        
        // Donnees générales
        input.typeOffre = new gdfsuezComBefChpPSEPivot.listeValeursDt();
        input.typeOffre.code = 'INDUSTRIELLE';
        
        system.debug('creneau '+creneau);
        input.disponibilite = new gdfsuezBefCalypsoPrestationServiceElec.disponibiliteDt();
        input.disponibilite.creneauHoraire = new gdfsuezComBefChpPSEPivot.listeValeursDt();
        input.disponibilite.creneauHoraire.code = !String.isBlank(creneau) ? creneau.toLowerCase() : '';
        
        //TO Fix
       /* if(typeUser == 'Client'){
            if(!String.isBlank(datePrevue)){
                //Get date from vlocity component need to set time to 23:00:00 to match vlocity format ex: for 29/03/2019 Vlocity -> 2019-03-28T23:00:00Z
               Integer TimeZoneValue = Integer.valueOf(datePrevue.substringBetween('T', ':'));
               input.dateEffetSouhaitee = Datetime.newInstanceGmt(Integer.valueOf(datePrevue.substring(0,4)), Integer.valueOf(datePrevue.substring(5,7)), Integer.valueOf(datePrevue.substring(8,10)),TimeZoneValue,0,0);    
               input.disponibilite.dateInterventionSouhaitee = input.dateEffetSouhaitee;
            }
        }
        else if(!String.isBlank(datePrevue)){
            input.dateEffetSouhaitee = Datetime.newInstanceGmt(Integer.valueOf(datePrevue.substring(6,10)), Integer.valueOf(datePrevue.substring(3,5)), Integer.valueOf(datePrevue.substring(0,2)));
            input.disponibilite.dateInterventionSouhaitee = input.dateEffetSouhaitee;
        } */ 

          system.debug('dateEffetSouhaitee '+ input.dateEffetSouhaitee );
        if(!String.isBlank(datePrevue)){            
            Integer TimeZoneValue = Integer.valueOf(datePrevue.substringBetween('T', ':'));
            input.dateEffetSouhaitee = Datetime.newInstanceGmt(Integer.valueOf(datePrevue.substring(0,4)), Integer.valueOf(datePrevue.substring(5,7)), Integer.valueOf(datePrevue.substring(8,10)),TimeZoneValue,0,0);    
            input.disponibilite.dateInterventionSouhaitee = input.dateEffetSouhaitee;
        }
        
        input.interlocuteurIntervention = new gdfsuezBefCalypsoPrestationServiceElec.interlocuteurInterventionDt();
        input.interlocuteurIntervention.personnePhysique= new gdfsuezBefCalypsoPrestationServiceElec.identiteDt();
        input.interlocuteurIntervention.personnePhysique.nom = nom;

        input.interlocuteurIntervention.personnePhysique.prenom = prenom;
        input.interlocuteurIntervention.personnePhysique.civilite = new gdfsuezComBefChpPSEPivot.listeValeursDt();
        input.interlocuteurIntervention.personnePhysique.civilite.code = civilite;               
        input.interlocuteurIntervention.coordonneesContact = new gdfsuezBefCalypsoPrestationServiceElec.coordonneesContactDt();
        input.interlocuteurIntervention.coordonneesContact.telephone = new String[]{tel}; 
        
        system.debug('all data set');
                   
        gdfsuezBefCalypsoPrestationServiceElec.replanifierRDVPrestationServiceElectriciteResponse_element response; 
        
       
        if(!Test.isRunningTest()){
            response  = port.ReplanifierRDVPrestationServiceElectricite_Http(input,octx);            
        }else {
            Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPSEcHttpMock());
            gdfsuezBefCalypsoPrestationServiceElec.Dependency porttest = new gdfsuezBefCalypsoPrestationServiceElec.Dependency();
            system.debug('@@ start of mock');
            response = porttest.ReplanifierRDVPrestationServiceElectricite_Http(input, octx);
            system.debug('@@ end of mock');
        }
         
         //system.debug('response'+response);
        system.debug('tableau de charge '+ response.replanifierRDVPrestationServiceElectriciteOutput.tableauDeCharge);
        system.debug('code' + response.messageRetours.retourTraitementMessage[0].code ) ;
        if(response.replanifierRDVPrestationServiceElectriciteOutput.tableauDeCharge != null){
            outMap.put('tableauDeCharge',getTableauDeCharge(response.replanifierRDVPrestationServiceElectriciteOutput.tableauDeCharge));
        }
       
        system.debug('tableauDeCharge' + getTableauDeCharge(response.replanifierRDVPrestationServiceElectriciteOutput.tableauDeCharge));
        outMap.put('code_retour_ops', response.messageRetours.retourTraitementMessage[0].code);

        if( response.replanifierRDVPrestationServiceElectriciteOutput.planificationIntervention != null){
            outMap.put('datePrevueModif', response.replanifierRDVPrestationServiceElectriciteOutput.planificationIntervention.datePrevue);
           

            if(response.replanifierRDVPrestationServiceElectriciteOutput.planificationIntervention.surSite != null){
                
                String heureDebutModif = response.replanifierRDVPrestationServiceElectriciteOutput.planificationIntervention.surSite.heureDebutPrevue;
                String heureFinModif = response.replanifierRDVPrestationServiceElectriciteOutput.planificationIntervention.surSite.heureFinPrevue;
                    
                outMap.put('heureDebutModif', (String) heureDebutModif.substring(0,2));
                outMap.put('heureFinModif', (String) heureFinModif.substring(0,2));
            }        
        }
        
        if(response.messageRetours.retourTraitementMessage[0].causedBy != null){
            outMap.put('info_distrib', response.messageRetours.retourTraitementMessage[0].causedBy.libelle);
            //system.debug('causedBy'+  response.messageRetours.retourTraitementMessage[0].causedBy.libelle );
        }
    
        System.debug('*** OUT modifierPrestationElec');
    }
    
    
    public static Object getTableauDeCharge(gdfsuezBefCalypsoPrestationServiceElec.replanifierRDVPrestationServiceElectriciteOutputDt_tableauDeCharge_element tableauDecharge){
        
        if(tableauDecharge == null ){
            return null ;
        }
        Map<String,List<Map<String,String>>> creneauxByDate = new  Map<String,List<Map<String,String>>>() ;
        List<Object> ListOfCreneau = new List<Object>();
        
        for(gdfsuezBefCalypsoPrestationServiceElec.replanifierRDVPrestationServiceElectriciteOutputDt_tableauDeCharge_creneau_element creneau :  
            tableauDecharge.creneau){
                DateTime dateTDCElec = creneau.date_x;
                List<Map<String,String>> listCreneau = creneauxByDate.get(String.ValueOf(dateTDCElec.year()+'/'+dateTDCElec.month()+'/'+dateTDCElec.day()));
                if(listCreneau == null){
                    listCreneau = new List<Map<String,String>>() ;
                    
                }
                Map<String,String> creneauLibelleCourtCode = new Map<String,String>() ;
                creneauLibelleCourtCode.put('code',creneau.creneauHoraire.code) ;
                creneauLibelleCourtCode.put('libelle',creneau.creneauHoraire.libelleCourt);
                listCreneau.add(creneauLibelleCourtCode);
                creneauxByDate.put(String.ValueOf(dateTDCElec.year()+'/'+dateTDCElec.month()+'/'+dateTDCElec.day()), listCreneau);
                
            }
            
         //
       ListOfCreneau.add(creneauxByDate);
       system.debug('ListOfCreneau'+ListOfCreneau);
        return ListOfCreneau;
    }
    
    
    /*
    * @Author: 
    * @Date: 11/02/2019
    * @Description: Lire PrestationElec offline method called by omniscript
    */ 
    void lirePrestationElec(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
      // A récupérer depuis vue 360
      // String idPrestationDistributeur = 'A03QHEIV';      
      String idPrestationDistributeur = String.valueOf(inputMap.get('idPrestationDistributeur'));
      //idPrestationDistributeur = 'A02W3JUG'; //'A03QHW6P';

      system.debug('@SM AP37 : idPrestationDistributeur : '+idPrestationDistributeur);      

      gdfsuezComBefChpPSEPivot.contextDt octx = initContext('Smile', '2.0'); 

      gdfsuezBefCalypsoPrestationServiceElec.Dependency port = new gdfsuezBefCalypsoPrestationServiceElec.Dependency() ;  
      SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();   
      port.clientCertName_x = octopusCS.certName__c;
      port.endpoint_x =  octopusCS.endpoint__c+'ES-PrestationServiceElec_v3';
      System.debug('*** endpoint : ' + port.endpoint_x);
      port.inputHttpHeaders_x = new Map<String, String>{'Content-Type' => 'text/xml;charset=utf-8'}; 

      gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteInputDt input = new gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteInputDt();

      input.online = true;
      if(!Test.isRunningTest())
      input.loginUtilisateur = service.getIdentifiantDistribFromApex();
 

      // Donnees générales
      input.prestationServiceElectricite = new gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteInputDt_prestationServiceElectricite_element[1];
      input.prestationServiceElectricite[0] = new gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteInputDt_prestationServiceElectricite_element();
      input.prestationServiceElectricite[0].idPrestationServiceDistributeur = idPrestationDistributeur;

      gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteResponse_element response ; 

      if(!Test.isRunningTest()){
        response  = port.LirePrestationServiceElectricite_Http(input,octx);
      }
      else{
        Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPSEcHttpMock());
        gdfsuezBefCalypsoPrestationServiceElec.Dependency porttest = new gdfsuezBefCalypsoPrestationServiceElec.Dependency();
        system.debug('@@ start of mock');
        response = porttest.LirePrestationServiceElectricite_Http(input, octx);
        system.debug('@@ end of mock');
      }

      System.debug('**** response : ' + response);
      System.debug('**** response code : ' + response.messageRetours.retourTraitementMessage[0].code);

      getDetailsFromResponseAndExposeItToOS(response,outMap);
    }

    /*
    * @Author: 
    * @Date: 11/02/2019
    * @Description: Lire PrestationElec list method called by omniscript
    */ 
    public void lirePrestationElecList(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        System.debug('**** IN lirePrestationElecList');

        Map<String, Object> elecOps = (Map<String, Object>) inputMap.get('RechercherPrestaElec');
        Map<String, Object> opsList = (Map<String, Object>) elecOps.get('ops');

        Map<String, Object> opsOut = new Map<String, Object>();

        // Il faut appeler l'IP existante pour chaque PDL présent en entrée
        map<string, object> inputElec = new map<string, object>();
        inputElec.put('TypeCard', 'ELEC');
        
        String typeUser= String.valueOf(inputMap.get('TypeUser'));
        inputElec.put('TypeUser',typeUser);

        System.debug('*** ' + (Set<String>) opsList.keyset());
         System.debug('*** elecOps' +  elecOps);
        System.debug('*** opsList' +  opsList);

        for(String elecPdl : (Set<String>) opsList.keySet()){
            Map<String, Object> ops = (Map<String, Object>) opsList.get(elecPdl);
            system.debug('ops'+ops);
            system.debug('elecPdl'+elecPdl);
            inputElec.put('idPrestationDistributeur', String.valueOf(ops.get('idPrestationServiceDistrib')));
            inputElec.put('idPrestationFournisseur', String.valueOf(ops.get('idPrestationServiceFournisseur')));
            inputElec.put('libellePrestation', String.valueOf(ops.get('libellePrestation')));
            
            
            Map<String, Object> elecOutput = new Map<String, Object>();
            
            lirePrestationElecOffline(inputElec, elecOutput, options);
            inputElec.put('commentaires', elecOutput.get('commentaires'));
            lirePrestationElecOnline(inputElec, elecOutput, options);
            
            opsOut.put(elecPdl, elecOutput);
            
            System.debug('*** elecOutput : ' + elecOutput);
        }

        outMap.put('ops', opsOut);

        System.debug('**** OUT lirePrestationElecList');
    }

    /*
* @Author: 
* @Date: 11/02/2019
* @Description: Rechercher PrestationElec method called by omniscript
*/ 
    public void lirePrestationElecOffline(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        System.debug('**** IN lirePrestationElecOffline');
        System.debug('*** Params : ' + inputMap);
        String idFournisseurElec= String.valueOf(inputMap.get('idPrestationFournisseur'));
        
        
        // Il faut appeler l'IP existante pour chaque PDL présent en entrée
        map<string, object> inputElec = new map<string, object>();
        Map<String, Object> ipOutput =new map<string, object>();
        Map<String, Object> fieldsOutput =new map<string, object>();
        
        
        inputElec.put('idFournisseurElec', idFournisseurElec);
        if(!Test.isRunningTest()){
            ipOutput = (Map<String,Object>)vlocity_cmt.IntegrationProcedureService.runIntegrationService('IP_SM_LirePrestationElec_SOAP', inputElec, options);  
        }
        else{
            ipOutput = (Map<String, Object>) inputMap.get('LirePrestationElec');
        }
        
        try{
            
            fieldsOutput = (Map<String, Object>) ipOutput.get('LirePrestationElecResult');
            
        } catch(Exception e){
            
        }
        
        if( fieldsOutput != null && fieldsOutput.containsKey('commentaires')){
            outMap.put('commentaires', fieldsOutput.get('commentaires'));
            
        }
        else{
            outMap.put('commentaires', 'WSKO');
            
        }
       // system.debug('commentaires'+fieldsOutput.get('commentaires'));
        System.debug('**** OUT lirePrestationElecOffline');
    }
    

    /*
    * @Author: 
    * @Date: 11/02/2019
    * @Description: Rechercher PrestationElec method called by omniscript
    */ 
    public void rechercherPrestationElec(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        System.debug('**** IN rechercherPrestationElec');
        System.debug('*** Params : ' + inputMap);
        
        String idBp = String.valueOf(inputMap.get('idBp'));
        Map<String, Object> contratIn = (Map<String, Object>) inputMap.get('WSContrat');
        Set<String> elec = (Set<String>) contratIn.get('elec');
        System.debug('*** elec : ' + elec);
        Map<String, Object> opsOut = new Map<String, Object>();
        // Il faut appeler l'IP existante pour chaque PDL présent en entrée
        map<string, object> inputElec = new map<string, object>();
        Map<String, Object> ipOutput =new map<string, object>();
            
        Boolean fromSelfcare = (Boolean) inputMap.get('origineSelfcare');
        
        if(elec != null){
            for(String elecPdl : elec){
                
                inputElec.put('PDLELECIdentifier', elecPdl);
                inputElec.put('PersonneELECIdentifier',idBp);
                inputElec.put('origineSelfcare', fromSelfcare);
                if(!Test.isRunningTest()){
                    ipOutput = (Map<String,Object>)vlocity_cmt.IntegrationProcedureService.runIntegrationService('IP_SM_RecherchePrestationElectricite_SOAP', inputElec, options);  
                }
                else{
                    ipOutput = (Map<String, Object>) inputMap.get('RecherchePrestationElec');
                }
                
                try{
                    
                    Map<String, Object> fieldsOutput = (Map<String, Object>) ipOutput.get('RecherchePrestationElecResult');
                    
                    
                    	opsOut.put(elecPdl, fieldsOutput);
                   
                } catch(Exception e){
                    
                }
            }
        }
        
        outMap.put('ops', opsOut);
        
        System.debug('**** OUT rechercherPrestationElec');
    }

    /*
    * @Author: 
    * @Date: 11/02/2019
    * @Description: getDetailsFromResponseAndExposeItToOS method called by omniscript
    */     
    public static  void getDetailsFromResponseAndExposeItToOS(gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteResponse_element  responseElement, Map<String,Object>  outMap ){
      PrestationDetails prestationDetails = new PrestationDetails() ;

      if(responseElement != null   &&  responseElement.lirePrestationServiceElectriciteOutput != null &&  responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire != null && responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0] != null && responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].donneesGenerales != null){ 
        if(responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].donneesGenerales.typePrestationService != null){
          prestationDetails.typePrestationService = responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].donneesGenerales.typePrestationService.code ;
        }
        if(responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].donneesGenerales.statutPrestationService != null){
          prestationDetails.statutPrestationService = responseElement.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].donneesGenerales.statutPrestationService.code;
        }            
      }
      else{
        system.debug('## no data ##');
        throw new IOException('Ne peut recupérer les information de la prestation !');
      }

      outMap.put('lirePrestationElecDetails',prestationDetails);
    }

    public class PrestationDetails{
        public String typePrestationService ; 
        public String statutPrestationService ;
        public String presenceObligatoire ;
        public String prixOps ;
        public String reference;  // GRDF ERDF selon le cas 
        public String index ; // TODO base hp hc

    }    

    public class IOException extends Exception {
    }    
}