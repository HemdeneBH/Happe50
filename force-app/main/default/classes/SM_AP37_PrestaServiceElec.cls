/*
* @Author: 
* @Date: 11/02/2019
* @Description: Vlocity class for prestation Service Elec
*/
global with sharing class SM_AP37_PrestaServiceElec implements vlocity_cmt.VlocityOpenInterface{
    
    public static SM_UTIL_Cache_Management service = new SM_UTIL_Cache_Management();
 	
    private static Map<String, String> frenchDays = new Map<String, String>();
    private static Map<Integer, String> frenchDates = new Map<Integer, String>();

    static {
        initialiseFrenchDates();
		initialiseFrenchDays();
    }


    public static void initialiseFrenchDates(){
		
		frenchDates.put(1, 'Janvier');
		frenchDates.put(2, 'Février');
		frenchDates.put(3, 'Mars');
		frenchDates.put(4, 'Avril');
		frenchDates.put(5, 'Mai');
		frenchDates.put(6, 'Juin');
		frenchDates.put(7, 'Juillet');
		frenchDates.put(8, 'Aout');
		frenchDates.put(9, 'Septembre');
		frenchDates.put(10, 'Octobre');
		frenchDates.put(11, 'Novembre');
		frenchDates.put(12, 'Décembre');
		
	}
    
    public static void initialiseFrenchDays(){
		frenchDays.put('Monday', 'Lundi');
		frenchDays.put('Tuesday', 'Mardi');
		frenchDays.put('Wednesday', 'Mercredi');
		frenchDays.put('Thursday', 'Jeudi');
		frenchDays.put('Friday', 'Vendredi');
		frenchDays.put('Saturday', 'Samedi');
		frenchDays.put('Sunday', 'Dimanche');
	}
 	
    
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
        else if (methodName.equals('lirePrestationElecOfflineList')) {
            try {
                lirePrestationElecOfflineList(inputMap, outMap, options);
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
        SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'PrestationServiceElec' limit 1];
        port.endpoint_x =  octopusCS.endpoint__c+suffixs.suffix__c;
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
            }
        }        
        
        
        //Modif OM 20/02
        //Get comment in  prestationServiceLire / demande / donneesGeneralesDemande / commentaire for client 
        String comments = '';
        String commentsClient = '';
        String codeLibelle = '';
        system.debug('response.demande.donneesGeneralesDemande' + response.demande.donneesGeneralesDemande);
        if(response.demande.donneesGeneralesDemande != null){   
            commentsClient = response.demande.donneesGeneralesDemande.commentaire;
            system.debug('commentaire' + comments);
            if(response.demande.donneesGeneralesDemande.typePrestationService.fiche != null){
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
        SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'PrestationServiceElec' limit 1];
        port.endpoint_x =  octopusCS.endpoint__c+suffixs.suffix__c;
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

         // system.debug('dateEffetSouhaitee '+ input.dateEffetSouhaitee );
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
        input.interlocuteurIntervention.coordonneesContact.telephone = new String[]{tel.replace(' ','')}; 
        
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
        //system.debug('tableau de charge '+ response.replanifierRDVPrestationServiceElectriciteOutput.tableauDeCharge);
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
      SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'PrestationServiceElec' limit 1];
      port.endpoint_x =  octopusCS.endpoint__c+suffixs.suffix__c;
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
            String idDistrib = (String) ops.get('idPrestationServiceDistrib');
            inputElec.put('idPrestationDistributeur', idDistrib);
            String idFournisseur= (String) ops.get('idPrestationServiceFournisseur');
            inputElec.put('idPrestationFournisseur', idFournisseur);
            String libelle= (String) ops.get('libellePrestation');
            inputElec.put('libellePrestation', libelle);
          
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
        


        Map<String, Object> contratIn = (Map<String, Object>) inputMap.get('WSContrat');
        System.debug('contratIn :'+contratIn );
       /* Object value = contratIn.get('elec') ;

        System.debug('value :'+ value + '>>>>>');        
        if(value != null ){
            if( value instanceof String) System.debug( 'String :' + ((String) value));
            

        }*/

        Set<String> elec = (Set<String>) contratIn.get('elec');

    
        
      /*  for(Object i : (List<Object>) contratIn.get('elec')){
            elec.add((String) i);
        }
        
        
        /*try{
			 elec = (List<String>) contratIn.get('elec');
		}
		catch(System.TypeException te){

			String message = te.getMessage().substringAfter('Invalid conversion from runtime type ');
            String result = message.substringBefore(' to List<String>');
            System.debug(message);
            System.debug(result);
		}*/
        
        
        
        
        Map<String, Object> opsOut = new Map<String, Object>();
        // Il faut appeler l'IP existante pour chaque PDL présent en entrée
        map<string, object> inputElec = new map<string, object>();
        Map<String, Object> ipOutput =new map<string, object>();
            
        Boolean fromSelfcare = (Boolean) inputMap.get('origineSelfcare');
        
        if(elec != null){
            for(String elecPdl : elec){
                
                inputElec.put('PDLELECIdentifier', elecPdl);
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
* @Author: RJM
* @Date: 03/07/2020
* @Description: vlocity invoking method lirePrestationElecOfflineList
*/

public void lirePrestationElecOfflineList(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
    System.debug('**** IN lirePrestationElecOfflineList');
    
    System.debug('*** Params');
    
    for (String aKey: inputMap.keyset()) {
        System.debug(aKey + ' : ' + inputMap.get(aKey));
    }
    
    //String idPrestationDistributeurEnCoursList = String.valueOf(inputMap.get('idPrestationDistributeurEnCours'));
    String idPrestationFournisseurEnCoursList = String.valueOf(inputMap.get('idPrestationServiceFournisseurEnCours'));
    //String idPrestationDistributeurTermineesList = String.valueOf(inputMap.get('idPrestationDistributeurTerminees'));
    //String idPrestationFournisseurTermineesList = String.valueOf(inputMap.get('idPrestationServiceFournisseurTerminees'));
    //idPrestationDistributeur = 'W00005B7';
    String typeCard = String.valueOf(inputMap.get('TypeCard'));
    String typeUser= String.valueOf(inputMap.get('TypeUser'));
    
    
   
    //system.debug('@SM AP30 : idPrestationDistributeurTermineesList : ' + idPrestationDistributeurTermineesList);
    system.debug('@SM AP30 : TypeCard : ' + typeCard);
    
    if (String.isBlank(idPrestationFournisseurEnCoursList) || typeCard != 'ELEC' ) {
        System.debug('*** 1 or more fields required empty');
        return;
    }
    
    gdfsuezComBefChpPSEPivot.contextDt octx = initContext('Smile', '2.0');
    
    gdfsuezBefCalypsoPrestationServiceElec.Dependency port = new gdfsuezBefCalypsoPrestationServiceElec.Dependency();
    SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();
    port.clientCertName_x = octopusCS.certName__c;
    SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'PrestationServiceElec' limit 1];
    port.endpoint_x = octopusCS.endpoint__c + suffixs.suffix__c;
    //port.endpoint_x = 'callout:AuthOctopus/ES-PrestationServiceGaz_v2';
    System.debug('*** endpoint : ' + port.endpoint_x);
    port.inputHttpHeaders_x = new Map < String, String > {
        'Content-Type' => 'text/xml;charset=utf-8'
            };
                
            gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteInputDt input = new  gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteInputDt();
    
    input.online = false;
    
    List<String> idPrestationFournisseurListEnCoursElements = idPrestationFournisseurEnCoursList.split(',');
    //List<String> idPrestationFournisseurListTermineesElements = idPrestationFournisseurTermineesList.split(',');
    // Donnees générales
    input.prestationServiceElectricite  = new gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteInputDt_prestationServiceElectricite_element[idPrestationFournisseurListEnCoursElements.size()];
    //input.prestationServiceGaz[0] = new gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazInputDt_prestationServiceGaz_element();
    //input.prestationServiceGaz[1] = new gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazInputDt_prestationServiceGaz_element();
    input.loginUtilisateur = service.getIdentifiantDistribFromApex();
    system.debug('input'+input);
    

    
    
    
    
    input.typeOffre = new gdfsuezComBefChpPSEPivot.listeValeursDt();
        input.typeOffre.code = 'INDUSTRIELLE';

    for(integer i=0 ; i< idPrestationFournisseurListEnCoursElements.size() ; i++){
        input.prestationServiceElectricite[i] = new gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteInputDt_prestationServiceElectricite_element();
        input.prestationServiceElectricite[i].idPrestationServiceFournisseur = idPrestationFournisseurListEnCoursElements[i].replace('(','').replace(')','').replace(' ','');
        System.debug('En cours :'+ input.prestationServiceElectricite[i].idPrestationServiceFournisseur);
    }

    /*for(integer i=idPrestationFournisseurListEnCoursElements.size() ; i< idPrestationFournisseurListTermineesElements.size() ; i++){
        input.prestationServiceGaz[i] = new gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazInputDt_prestationServiceGaz_element();
        input.prestationServiceGaz[i].idPrestationServiceFournisseur = idPrestationFournisseurListTermineesElements[i].replace('(','').replace(')','').replace(' ','');
        System.debug('Terminé :' +input.prestationServiceGaz[i].idPrestationServiceFournisseur);
    }*/

    System.debug(input.prestationServiceElectricite.size());

    //input.prestationServiceGaz[0].idPrestationServiceFournisseur = idPrestationFournisseurListElements[0];
    //input.prestationServiceGaz[1].idPrestationServiceFournisseur = idPrestationFournisseurListElements[1];
        
    
    system.debug('input'+input);

    gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteResponse_element response;
    
    if (!Test.isRunningTest()) {
        response = port.LirePrestationServiceElectricite_Http(input, octx);
    } 
    else {
        Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPSEcHttpMock());
        gdfsuezBefCalypsoPrestationServiceElec.Dependency porttest = new gdfsuezBefCalypsoPrestationServiceElec.Dependency();
        system.debug('@@ start of mock');
        response = porttest.LirePrestationServiceElectricite_Http(input, octx);
        system.debug('@@ end of mock');
    }
    
    System.debug('**** response : ' + response);
    //System.debug('**** response code : ' + response.messageRetours.retourTraitementMessage[0].code);
    
    //outMap.put('code_retour_ops1', response.messageRetours.retourTraitementMessage[0].code);
    //outMap.put('code_retour_ops2', response.messageRetours.retourTraitementMessage[1].code);
    
    if (response != null && response.lirePrestationServiceElectriciteOutput != null && response.lirePrestationServiceElectriciteOutput.prestationServiceLire.size() > 0) {
        outMap.putAll(transformDataFromReadOfflineDuo(response.lirePrestationServiceElectriciteOutput.prestationServiceLire));
    }
    //outMap.putAll(inputMap);
    
    System.debug('**** OUT lirePrestationElecOfflineList');
    
}

/* @Author: RJM
* @Date: 03/07/2020
* @Description: transformDataFromReadOfflineDuo
*/
public static Map < String, Object > transformDataFromReadOfflineDuo(gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteOutputDt_prestationServiceLire_element[] responseList) {
	Map < String, Object > newOutputMap = new Map < String, Object > ();
	
	
	List<OPSDetails> opsDetailsEnCoursList = new List<OPSDetails>();
	
	
	for(integer i =0 ; i<responseList.size() ; i++){
		OPSDetails ops = new OPSDetails();
		ops.Id = i;
	
		
        
		
		ops.nom = responseList[i].donneesGenerales != null && responseList[i].donneesGenerales.typePrestationService != null ?  responseList[i].donneesGenerales.typePrestationService.libelleCourt : '';
        
        if(responseList[i].demande != null && responseList[i].demande.donneesGeneralesDemande != null){
            gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteOutputDt_prestationServiceLire_demande_element demandeNode = responseList[i].demande;
            gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteOutputDt_prestationServiceLire_demande_donneesGeneralesDemande_element donneesGeneralesNode = demandeNode.donneesGeneralesDemande;
            System.debug(donneesGeneralesNode);
            ops.commentaire = donneesGeneralesNode.commentaire;
        
            System.debug('commentaire :'+ ops.commentaire);
            gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteOutputDt_prestationServiceLire_demande_donneesGeneralesDemande_solde_element soldeNode = donneesGeneralesNode.solde;
            System.debug('soldeNode :'+soldeNode);
            ops.prix = soldeNode.montantPrevisionnelPrestation;
        }
        
        
       
        System.debug('prix :'+ ops.prix);

        if (!String.isBlank(ops.commentaire ) && ops.commentaire.contains('PNO')) {
			ops.presence = 'PRESENCE NON OBLIGATOIRE';
		}
		else if (!String.isBlank(ops.commentaire ) && ops.commentaire.contains('PO')) {
			ops.presence = 'PRESENCE OBLIGATOIRE';
		}
		else if (!String.isBlank(ops.commentaire ) && ops.commentaire.contains('WSKO')) {
			ops.presence = ' ';
		}

		ops.idDistrib = responseList[i].idPrestationServiceDistributeur;
	    ops.idFournisseur = responseList[i].idPrestationServiceFournisseur;
		
		
        if(responseList[i].interventions != null && responseList[i].interventions.intervention != null && responseList[i].interventions.intervention.planifications != null  && responseList[i].interventions.intervention.planifications.planification.size()>0 && responseList[i].interventions.intervention.planifications.planification[0] != null) {
            gdfsuezBefCalypsoPrestationServiceElec.planificationDt planificationNode = responseList[i].interventions.intervention.planifications.planification[0];
            Datetime datetimePrevue1 = planificationNode.datePrevue;
            ops.dateRDV = frenchDays.get(datetimePrevue1.format('EEEE'))+' '+datetimePrevue1.day()+' '+frenchDates.get(datetimePrevue1.month())+' '+datetimePrevue1.year();
        
            gdfsuezBefCalypsoPrestationServiceElec.planificationDt_surSite_element surSiteNode =   planificationNode.surSite;      
        
            String heureDebut1  = surSiteNode.heureDebutPrevue;
            String heureFin1  = surSiteNode.heureFinPrevue;


            ops.datePrevue =  datetimePrevue1;

			ops.heureDebut = heureDebut1;

            ops.heureFin = heureFin1;
            
            if(heureFin1 != null && heureDebut1 != null){
                String heureDebutFormatted = heureDebut1.substring(0,4);
                String heureFinFormatted = heureFin1.substring(0,4);
            ops.creneau = heureDebutFormatted.substring(0,2) + ':' + heureDebutFormatted.substring(2,4) +' - ' + heureFinFormatted.substring(0,2) + ':' + heureFinFormatted.substring(2,4);
            }
            else if (heureDebut1 != null){
                String heureDebutFormatted = heureDebut1.substring(0,4);
                ops.creneau = heureDebutFormatted.substring(0,2) + ':' + heureDebutFormatted.substring(2,4);
            }

            if (Date.today().addDays(2) >= dateTimePrevue1 && dateTimePrevue1 >= Date.today()) {
				ops.moins48h = '1';
			}
			else{
				ops.moins48h = '0';
            } 
        }
        
        
			
 
            
            if(responseList[i].demande != null && responseList[i].demande.interlocuteurIntervention != null){
                if(responseList[i].demande.interlocuteurIntervention.personnePhysique != null){
                    ops.nomClient = responseList[i].demande.interlocuteurIntervention.personnePhysique.nom;
                    ops.prenomClient = responseList[i].demande.interlocuteurIntervention.personnePhysique.prenom;
                    
                    if(responseList[i].demande.interlocuteurIntervention.personnePhysique.civilite != null){
                        ops.civiliteClient = responseList[i].demande.interlocuteurIntervention.personnePhysique.civilite.code;
                    }
                }
                
                if(responseList[i].demande.interlocuteurIntervention.coordonneesContact!= null && responseList[i].demande.interlocuteurIntervention.coordonneesContact.telephone != null && responseList[i].demande.interlocuteurIntervention.coordonneesContact.telephone.size() > 0){ //coordonneesContactDt 
                    ops.telClient =responseList[i].demande.interlocuteurIntervention.coordonneesContact.telephone[0];
                }
    
            }

		
		

	
			opsDetailsEnCoursList.add(ops);
	

		



		
	}

	System.debug('opsDetailsEnCoursList : ' +opsDetailsEnCoursList);
	
	newOutputMap.put('opsDetailsEnCoursList', opsDetailsEnCoursList);



	
	return newOutputMap;
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

    public class OPSDetails {
        public Integer Id;
        public String nom;
        public Double prix;
        public String dateRDV;
        public String creneau;
        public String presence;
        public String contactName;
        public String contactNum;
        public String commentaire;
        public String idDistrib;
        public String idFournisseur;
        public String moins48h;
        public String nomClient;
        public String prenomclient;
        public String civiliteClient;
        public String telClient;
        public DateTime datePrevue;
			public String heureDebut;
			public String heureFin;
			public String creneauRetenu;
			public String creneauRetenuCode;
    
    
}

    public class IOException extends Exception {
    }    
}