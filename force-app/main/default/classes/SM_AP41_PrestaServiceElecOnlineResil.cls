global  class SM_AP41_PrestaServiceElecOnlineResil extends SM_AP41_PrestaServiceElecCommon implements vlocity_cmt.VlocityOpenInterface     {
    
    
    
    
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        
        if (methodName.equals('creerPrestationElecOnline')) {
            try {   // creation de la prestation en mode online 
                creerPrestationElecOnline(inputMap, outMap, options);
                
            } 
            catch (Exception e) {
                //String error = e.getStackTraceString() + '\n' + e.getMessage() ;
				//String data=  SM_Utilities.buildLog(error,'Error','creerPrestationElecOnlineResil') ;
				//SM_Utilities.traceLog(data) ;

                if(!Test.isRunningTest()) {
                    system.debug('error '+e);
                    system.debug('error '+e.getStackTraceString());
                    if(!(e instanceof SM_AP41_PrestaServiceElecCommon.IOException)) {
                        // exception non generée
                        e.setMessage('Erreur technique !');
                    }
                    // remonter l'erreur à l'IP
                    // outMap.put('raisedExceptionElec',e.getMessage());
                    throw e;
                }
                // return false;
            }
        } 
        return true;
    }
    
    /*
* @Author: Mohamed Kchaou
* @Date: 13/02/2019
* @Description: vlocity apel à la méthode creerPrestationElec
*/
    public  void creerPrestationElecOnline(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        
        
        
        String  LINKYlv1 = String.valueOf(inputMap.get('LINKYlv1')) ;
        system.debug('LINKYlv1'+LINKYlv1) ;
        String  LINKYlv2 = String.valueOf(inputMap.get('LINKYlv2')) ;
        system.debug('LINKYlv2'+LINKYlv2) ;
        String creneau = (String) inputMap.get('CreaneauElec') ; 
        system.debug('creneau'+creneau) ;
        String getPrenom = (String) inputMap.get('getPrenom') ; 
        system.debug('getPrenom'+getPrenom) ;
        String getFix = (String) inputMap.get('getFix') ; 
        system.debug('getFix'+getFix) ;
        String getCodePostal = (String) inputMap.get('getCodePostal') ; 
        system.debug('getCodePostal'+getCodePostal) ;
        String getNoVoie = (String) inputMap.get('getNoVoie') ; 
        system.debug('getNoVoie'+getNoVoie) ;
        String getStreet = (String) inputMap.get('getStreet') ; 
        system.debug('getStreet'+getStreet) ;
        String getVille = (String) inputMap.get('getVille') ; 
        system.debug('getVille'+getVille) ;
        String Complement = (String) inputMap.get('Complement') ; 
        system.debug('Complement'+Complement) ;
        
        String getNom = (String) inputMap.get('getNom') ; 
        system.debug('getNom'+getNom) ;
        String getCivilite = (String) inputMap.get('getCivilite') ; 
        system.debug('getCivilite'+getCivilite) ;
        String DateOpsElecForm =(String) inputMap.get('DateOpsElecForm') ;
        system.debug('DateOpsElecForm'+DateOpsElecForm) ;
        String idBp = inputMap != null ? (String) inputMap.get('getIdBP') : null;
        system.debug('idBp'+idBp) ;
        String idContrat = String.valueof(inputMap.get('idContrat'));
        system.debug('idContrat'+idContrat) ;
        Map<String,Object > blocIntervention   =  ( Map<String,Object > )inputMap.get('InterventionElec') ;   
        system.debug('blocIntervention'+blocIntervention) ;
        Map<String,Object > autoreleveElec   =  ( Map<String,Object > )inputMap.get('autoreleveElec') ;
        system.debug('autoreleveElec'+autoreleveElec) ;
        Map<String,Object > PrestationDistrib   =  ( Map<String,Object > )inputMap.get('PrestationDistrib') ;   
        system.debug('PrestationDistrib'+PrestationDistrib) ;
        String ChoixProcedureAutoItv = (String) inputMap.get('ChoixProcedureAutoItv') ; 
        system.debug('ChoixProcedureAutoItv'+ChoixProcedureAutoItv) ;
        String idPdl = (String) inputMap.get('idPdl') ;            
        system.debug('idPdl'+idPdl) ;
        boolean interventionObligatoire = (Boolean) PrestationDistrib.get('ElecInterventionObligatoire')  || ChoixProcedureAutoItv.equals('Intervention') ;
        system.debug('interventionObligatoire'+interventionObligatoire) ;
        
        
        //if(true)return ;
        
        gdfsuezComBefChpPSEPivot.contextDt octx = initContext('Smile', '2.0');
        
        gdfsuezBefCalypsoPrestationServiceElec.Dependency port = new gdfsuezBefCalypsoPrestationServiceElec.Dependency();
        SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();
        port.clientCertName_x = octopusCS.certName__c;
        SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'PrestationServiceElec' limit 1];
        port.endpoint_x = octopusCS.endpoint__c + suffixs.suffix__c;
        System.debug('*** endpoint : ' + port.endpoint_x);
        port.inputHttpHeaders_x = new Map < String, String > {
            'Content-Type' => 'text/xml;charset=utf-8'
                };
                    
                    gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt input = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt();
        
        //##### Type offre#####
        input.typeoffre = new gdfsuezComBefChpPSEPivot.listeValeursDt();
        input.typeoffre.code = 'INDUSTRIELLE';
        
        //##### Donnees générales #####
        input.donneesGenerales = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_donneesGenerales_element();
        input.donneesGenerales.typePrestationService = new gdfsuezComBefChpPSEPivot.listeValeursDt();
        input.donneesGenerales.typePrestationService.code = 'Z002';
        input.donneesGenerales.idPersonne = idBp;
        input.donneesGenerales.idPDLElectricite = idPdl ;
        String idContract = (String) idContrat ;
        if(String.isBlank(idContract)){
            If(!Test.isRunningTest())
                throw new SM_AP41_PrestaServiceElecCommon.IOException('l id contrat n est pas trouvé !') ;
        }
        input.donneesGenerales.idContrat = idContract; // transformer pc en dur pour l'instant comme demandé par Fatimatou  US 1086
        String idSap =      service.getIdentifiantSAPFromApex() ;
        if(String.isBlank(idSap)){
            If(!Test.isRunningTest())
                throw new SM_AP41_PrestaServiceElecCommon.IOException('l identifiant SAP n est pas trouvé !') ;
        }
        input.donneesGenerales.idPersonneResponsable = idSap ;
        input.donneesGenerales.natureDemande   = new  gdfsuezComBefChpPSEPivot.listeValeursDt();
        input.donneesGenerales.natureDemande.code = 'RIC' ;
        input.donneesGenerales.loginUtilisateur = service.getIdentifiantDistribFromApex();
        input.donneesGenerales.dateEffetSouhaitee =(String) inputMap.get('DateOpsElecForm') ;
        input.donneesGenerales.origineDemande  =  'CLIENT' ;
        //##### données client final  #####
        input.clientFinal = new   gdfsuezBefCalypsoPrestationServiceElec.clientFinalDt();
        input.clientFinal.personnePhysique = new   gdfsuezBefCalypsoPrestationServiceElec.identiteDt();
        input.clientFinal.personnePhysique.civilite = new  gdfsuezComBefChpPSEPivot.listeValeursDt();
        input.clientFinal.personnePhysique.civilite.code = (String) getCivilite ;
        input.clientFinal.personnePhysique.nom = (String) getNom ;
        input.clientFinal.personnePhysique.prenom = (String) getPrenom ;
        if(!String.isBlank(getFix)){
        input.clientFinal.coordonneesContact = new gdfsuezBefCalypsoPrestationServiceElec.coordonneesContactDt();
        input.clientFinal.coordonneesContact.telephone =   new List < String > {getFix.replace(' ', '')} ;
        }
            //input.clientFinal.coordonneesContact.adresseEmail = (String) ((Map<String,Object>)((Map<String,Object>) inputMap.get(ServicesGestion)).get(PrelevementBlock)).get(getEmailPrincipale);
            input.clientFinal.adressePostale = new  gdfsuezComBefChpPSECommunadresse.adresseCommunDt();
        input.clientFinal.adressePostale.cp = getCodePostal ; // (string) adressContact.get('CodePostal');
        input.clientFinal.adressePostale.libelleVoie =  getStreet ; //(string) adressContact.get('Adresse');
        input.clientFinal.adressePostale.nVoie =  getNoVoie ; // (string) adressContact.get('NoVoie');
        input.clientFinal.adressePostale.pays = new gdfsuezComBefChpPSEPivot.listeValeursDt();
        input.clientFinal.adressePostale.pays.code = 'FR';
        input.clientFinal.adressePostale.ville =  getVille ;//(String) adressContact.get('Ville');
        input.clientFinal.adressePostale.batiment = Complement ; //(String) adressContact.get(ComplementAdresse);
        input.clientFinal.adressePostale.lieuDit = Complement ; //(String) adressContact.get(ComplementAdresse);
        input.clientFinal.residencePrincipale = true ;//((String) elements.get('residenceOption')).equals('010') ?  true: false ;
        
        
        Boolean linky =  LINKYlv1.equalsIgnoreCase('true')  || LINKYlv2.equalsIgnoreCase('true') ;
        system.debug('is linky'+linky);
        
        if (interventionObligatoire) {
            
            
            
            //##### interlocuteurIntervention #####
            input.interlocuteurIntervention =  new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_interlocuteurIntervention_element();
            input.interlocuteurIntervention.personnePhysique =  new gdfsuezBefCalypsoPrestationServiceElec.identiteDt();
            input.interlocuteurIntervention.personnePhysique.civilite =  new gdfsuezComBefChpPSEPivot.listeValeursDt();
            // contexte US SMIL-1823   valeur  civilite-nom-prenon sont maintenant dynamiques 
            input.interlocuteurIntervention.personnePhysique.civilite.code = (String) blocIntervention.get('CiviliteOpsElec');
            input.interlocuteurIntervention.personnePhysique.nom = (String) blocIntervention.get('NomOpsElec');
            input.interlocuteurIntervention.personnePhysique.prenom = (String) blocIntervention.get('PrenomOpsElec');
            // contexte US SMIL-1823
            input.interlocuteurIntervention.coordonneesContact =  new gdfsuezBefCalypsoPrestationServiceElec.coordonneesContactDt();
            input.interlocuteurIntervention.coordonneesContact.telephone = new List < String > {
                ((String) blocIntervention.get('TelephoneOpsElec')).replace(' ','')
                    };
                        
                        //##### disponibilité #####
                        input.disponibilite =  new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_disponibilite_element();
            input.disponibilite.dateInterventionSouhaitee =  (String) inputMap.get('DateOpsElecForm') ;//Datetime.valueOf(DateOpsElecForm).addDays(1).formatGMT('yyyy-MM-dd\'T\'HH:mm:ss');
            
            
            input.disponibilite.creneauHoraire =  new gdfsuezComBefChpPSEPivot.listeValeursDt();
            input.disponibilite.creneauHoraire.code = creneau ;
            input.commentaireIntervention = (String) blocIntervention.get('CommentairesOpsElec');  
        } 
        else{
            // autoreleve
            if(!linky) { 
            // ajout du bloc autoreleve dans la requete si c'est n'est pas le cas d'une intervention
            input.autoReleve = handleAutoreleve(autoreleveElec);
             }
        }
        
        
        
        
        
        
        
        
        gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteResponse_element response;
        
        if (!Test.isRunningTest()) {
            response = port.CreerPrestationServiceElectricite_Http(input, octx);
        } else {
            Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPSEcHttpMock());
            gdfsuezBefCalypsoPrestationServiceElec.Dependency porttest = new gdfsuezBefCalypsoPrestationServiceElec.Dependency();
            system.debug('@@ start of mock');
            response = porttest.CreerPrestationServiceElectricite_Http(input, octx);
            system.debug('@@ end of mock');
        }
        
        System.debug('**** response : ' + response);
        System.debug('**** response code : ' + response.messageRetours.retourTraitementMessage[0].code);
        if(response.messageRetours.retourTraitementMessage[0].code.equals('OCTOPUS_CreerPrestationServiceElectricite_01')) {
            // dans le cas OK faut mettre à jour l'OPS ..
            //
            
            if(response.creerPrestationServiceElectriciteOutput.sequence  != null && response.creerPrestationServiceElectriciteOutput.sequence.idPrestationServiceDistributeur != null) {
                DateTime dT = Datetime.valueOf(DateOpsElecForm.replace('T', ' '));
                Date dateSouhaite = date.newinstance(dT.year(), dT.month(), dT.day()+1);
                
                Map<String,Object> ElementsToSerialize = new Map<String,Object>() ;
                ElementsToSerialize.put( 'id',(String) ((Map<String,Object>) inputMap.get('PrestationDistrib')).get('id')) ;		
                ElementsToSerialize.put( 'idPrestationServiceFournisseur', response.creerPrestationServiceElectriciteOutput.idPrestationServiceFournisseur ) ;		
                ElementsToSerialize.put( 'idPrestationServiceDistributeur', response.creerPrestationServiceElectriciteOutput.sequence.idPrestationServiceDistributeur) ;		
                ElementsToSerialize.put( 'dateSouhaite', dateSouhaite) ;
                ElementsToSerialize.put( 'typeOPS', 'Online') ;
                ElementsToSerialize.put( 'creaneau', creneau) ;
                if(response.creerPrestationServiceElectriciteOutput.prestationsService != null && response.creerPrestationServiceElectriciteOutput.prestationsService.prestationService != null && response.creerPrestationServiceElectriciteOutput.prestationsService.prestationService.typePrestationService != null && 
                   response.creerPrestationServiceElectriciteOutput.prestationsService.prestationService.typePrestationService.fiche != null && response.creerPrestationServiceElectriciteOutput.prestationsService.prestationService.typePrestationService.fiche.libelleCourt != null){
                       ElementsToSerialize.put('Name',response.creerPrestationServiceElectriciteOutput.prestationsService.prestationService.typePrestationService.fiche.libelleCourt );
                   }else{
                      ElementsToSerialize.put('Name', 'OPS Elec');
                   }
                if(interventionObligatoire && blocIntervention != null){
                    ElementsToSerialize.put('NomContactIntervention', (String) blocIntervention.get('NomOpsElec')) ;
                    ElementsToSerialize.put('PrenomContactIntervention',  (String) blocIntervention.get('PrenomOpsElec'));
                    ElementsToSerialize.put('TelephoneContactIntervention', ((String) blocIntervention.get('TelephoneOpsElec')).replace(' ',''));
                    ElementsToSerialize.put('CiviliteContactIntervention', (String) blocIntervention.get('CiviliteOpsElec'));
                    
                }
                if(autoreleveElec != null){ 
                    if (autoreleveElec.get(Base) != null)
                        ElementsToSerialize.put('indexBase',(Integer)  autoreleveElec.get(Base)) ;
                    if (autoreleveElec.get(HP) != null)
                        ElementsToSerialize.put('indexHP',  (Integer) autoreleveElec.get(HP)) ;
                    if (autoreleveElec.get(HC) != null)
                        ElementsToSerialize.put('indexHC', (Integer) autoreleveElec.get(HC)) ;
                }
                string jsonString = JSON.serializePretty(ElementsToSerialize);	
                updateOPS(jsonString);
                // id prestation distributeur transmit a l'omniscript car on en a besoin aprés dans l'etape recap
                try {                 
                    outMap.put(idPrestationDistributeurElec,response.creerPrestationServiceElectriciteOutput.sequence.idPrestationServiceDistributeur);
                    outMap.put( 'addresseConcernee', getNoVoie +' '+ getStreet +' '+ getVille+' '+getCodePostal );
                    Datetime dateSouhaiteDateTime =  Datetime.valueOf(DateOpsElecForm.replace('T', ' '))+1;// provisoire
                    outMap.put('dateinteventionSouhaiteElec',frenchDays.get(dateSouhaiteDateTime.format('EEEE'))+' ' +dateSouhaiteDateTime.day()+' '+frenchDates.get(dateSouhaiteDateTime.month())+' '+dateSouhaiteDateTime.year());
                    
                    if(response.creerPrestationServiceElectriciteOutput.sequence != null && 
                       response.creerPrestationServiceElectriciteOutput.sequence.planificationIntervention != null&&
                       response.creerPrestationServiceElectriciteOutput.sequence.planificationIntervention.surSite != null &&
                       response.creerPrestationServiceElectriciteOutput.sequence.planificationIntervention.surSite.heureDebutPrevue != null &&
                       response.creerPrestationServiceElectriciteOutput.sequence.planificationIntervention.surSite.heureFinPrevue != null ){
                           outMap.put('creneauHoraireElecCode', '('+response.creerPrestationServiceElectriciteOutput.sequence.planificationIntervention.surSite.heureDebutPrevue 
                                      +'-'+response.creerPrestationServiceElectriciteOutput.sequence.planificationIntervention.surSite.heureFinPrevue+')');
                       }
                }catch(Exception e){
                    system.debug('Erreur survenue lors de la mise a jour des elements du recap Elec'+e);
                    system.debug(e.getStackTraceString());
                }
            }
            String messageToshow = null;
            
            // =>rectificaton SMIL-579 
            if(response.creerPrestationServiceElectriciteOutput.prestationServiceDistributeurCree !=null &&  response.creerPrestationServiceElectriciteOutput.prestationServiceDistributeurCree 
               &&  response.creerPrestationServiceElectriciteOutput.sequence  != null && response.creerPrestationServiceElectriciteOutput.sequence.idPrestationServiceDistributeur != null && response.creerPrestationServiceElectriciteOutput.PrestationsService == null ) {
                   // <=rectificaton SMIL-579 
                   messageToshow ='En attente retour distributeur. le client sera directement contacté par Enedis. \n';
                   // demande est transmise
                   outMap.put('demandeElecTransmise',true);
                   
               }
            else if(response.creerPrestationServiceElectriciteOutput.prestationServiceDistributeurCree !=null &&  response.creerPrestationServiceElectriciteOutput.prestationServiceDistributeurCree && response.creerPrestationServiceElectriciteOutput.donneesOperations != null && response.creerPrestationServiceElectriciteOutput.donneesOperations.teleOperables != null &&  response.creerPrestationServiceElectriciteOutput.donneesOperations.teleOperables  ) {
                messageToshow = 'OPS téléopérable. La demande de prestation a bien été créée chez le distributeur.\n';
                outMap.put('teleoperableElec',  true );
            }
            
            else if(response.creerPrestationServiceElectriciteOutput.prestationServiceDistributeurCree !=null &&  response.creerPrestationServiceElectriciteOutput.prestationServiceDistributeurCree ){
                messageToshow = 'OPS créée \n';
            }
            
            outMap.put(PSE_CODE_retour,response.messageRetours.retourTraitementMessage[0].code);
            outMap.put('messageToshow',  messageToshow );
            outMap.put('tableauDeCharge', getTableauDeCharge(response.creerPrestationServiceElectriciteOutput.tableauDeCharge));
            return;
            
        }else {
            // cas d'erreur Octopus 
            outMap.put(PSE_CODE_retour,response.messageRetours.retourTraitementMessage[0].code);
            // défigé le passage au mode recollement (US-2509)
            //setChoixProcedureSelectable(outMap) ;
            
            if(response.messageRetours.retourTraitementMessage[0].code.equals('OCTOPUS_CreerPrestationServiceElectricite_05')) {
                outMap.put('messageToshow', causedByCodeMap.get(response.messageRetours.retourTraitementMessage[0].causedBy.code));
                
                // switch to recollement 
                //switchToRecollement(inputMap,outMap) ;
                
            }else{
                // comme demandé dans l'us  SMIL-580 faut afficher la balise caused by en cas d'erreur			
                outMap.put('messageToshow', response.messageRetours.retourTraitementMessage[0].causedBy.libelle); // dans le cadre de l'us SMIL-2155 15-03-2019				
            }
        }
        System.debug('**** OUT creerPrestationElec');
        
    }
    
    
    
    /*
* @Author: Mohamed Kchaou
* @Date: 13/02/2019
* @Description:
*/  @future
    public static void updateOPS(String elements){
        try{
            
            
            
            Map<String,Object> wrapper = (Map<String,Object>) SYSTEM.JSON.deserializeUntyped(elements);
            String id = (String) wrapper.get('id') ;
            String  idPrestationServiceDistributeur = (String) wrapper.get( 'idPrestationServiceDistributeur');
            String  idPrestationServiceFournisseur = (String) wrapper.get( 'idPrestationServiceFournisseur');
            String  creaneau = (String) wrapper.get( 'creaneau');
            String  typeOPS = (String) wrapper.get( 'typeOPS');
            Date  dateEffet = wrapper.get( 'dateSouhaite') == null ? null : Date.valueOf((String)wrapper.get( 'dateSouhaite'));      
            String  Name = (String) wrapper.get( 'Name');
            String  NomContactIntervention = (String) wrapper.get( 'NomContactIntervention');
            String  PrenomContactIntervention = (String) wrapper.get( 'PrenomContactIntervention');
            String  TelephoneContactIntervention = (String) wrapper.get( 'TelephoneContactIntervention');
            String  CiviliteContactIntervention = (String) wrapper.get( 'CiviliteContactIntervention');
            Integer  indexBase = (Integer)  wrapper.get( 'indexBase');      
            Integer  indexHP = (Integer)  wrapper.get( 'indexHP');  
            Integer  indexHC = (Integer)  wrapper.get( 'indexHC'); 
            
            
            
            if(id== null) {
                system.debug('## could not found id OPS ## ');
                return;
            }
            
            
            system.debug('id'+id);
            
            Prestation_distributeur__c acc = [SELECT Id, Name,Numero_affaire_distributeur__c,Statut__c,Date_de_prestation__c,Identifiant_ENGIE__c FROM Prestation_distributeur__c WHERE Id =: id  ];
            acc.Numero_affaire_distributeur__c   =idPrestationServiceDistributeur;
            acc.Statut__c = 'En cours';
            acc.Date_de_prestation__c   = dateEffet;
            acc.Identifiant_ENGIE__c = idPrestationServiceFournisseur;
            acc.Type_OPS__c = typeOPS ;
            acc.Creneau__c = creaneau != null ?  (String) creneaux.get(creaneau) : null ; // dans le cadre de l'us SMIL-2115
            acc.Index__c = indexBase ;
            acc.Index_HC__c =indexHC;
            acc.Index_HP__c =indexHP ;
            acc.Telephone_intervention__c =TelephoneContactIntervention ;
            acc.Prenom_contact_d_intervention__c =PrenomContactIntervention ;
            acc.Nom_contact_d_intervention__c =NomContactIntervention ;
            acc.Civilite_interlocuteur_intervention__c =  CiviliteContactIntervention ;
            acc.Name = Name ;
            update acc;
        }catch(Exception e) {
            system.debug('##catched##'+e);
            system.debug('##catched##'+e.getStackTraceString());
        }
        
        
    }
    
    
    
    public static final Map < String, Object > creneaux = new Map < String, String > {
        'jou' => 'Journée',
            'dma' => 'Début de matinée',
            'fma' => 'Fin de matinée',
            'ma' => 'Matin',
            'dap' => 'Début d’après midi',
            'fap' => 'Fin d’après midi',
            'apm' => 'Après midi',
            'fjo' => 'Fin de journée',
            'dso' => 'Début de soirée',
            'mjo' => 'Milieu de soirée',
            'soi' => 'Soir',
            'fso' => 'Fin de soirée'
            };
                
                
                }