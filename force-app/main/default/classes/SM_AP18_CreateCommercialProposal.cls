/*
*@author:MHA
*@Description: Appel du WS PropopositionCommerciale_V3
*@CreatedDate:05/09/2018
*/
global class SM_AP18_CreateCommercialProposal implements vlocity_cmt.VlocityOpenInterface {

    /*
    *@author:MHA
    *@Description: Appel du WS PropopositionCommerciale_V3
    *@CreatedDate:05/09/2018
    *@LastModified: 19/12/2018
    */
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        boolean returnValue = true;
        if (methodName.equals('createCommercialProposal')) {
            try {
                createCommercialProposal(inputMap, outMap, options);
                System.debug('outputMap: '+outMap);
            } 
            catch (Exception e) {
                system.debug('## error occured during calling createCommercialProposal ##');
                system.debug(e);
                system.debug(e.getStackTraceString());
                returnValue =  false;
            }
        } 
        if (methodName.equals('createCommercialProposalSA')) {
            try {
                createCommercialProposalSA(inputMap, outMap, options);
                System.debug('outputMap: '+outMap);
            } 
            catch (Exception e) {
                system.debug('## error occured during calling createCommercialProposalSA ##');
                system.debug(e);
                system.debug(e.getStackTraceString());
                returnValue =  false;
            }
        } 
        else if (methodName.equals('transformCommercialProposal')) {
            try {
                transformCommercialProposal(inputMap, outMap, options);
            } 
            catch (Exception e) {
                system.debug('## error occured during calling transformCommercialProposal ##');
                system.debug('## error ' +e);
               // system.debug('##error getStackTraceString' +e.getStackTraceString());
               // returnValue = false;
            }
        } 
        else if (methodName.equals('transformerPCDeuxExemplaires')) {
            try {
                transformerPCDeuxExemplaires(inputMap, outMap, options);
            } 
            catch (Exception e) {
                system.debug('## error occured during calling transformerPCDeuxExemplaires ##');
                system.debug(e);
                system.debug(e.getStackTraceString());
                returnValue =  false;
            }
        }
        else{
            returnValue = false;
        }
        return returnValue;
    }

    /*
    *@author:MHA
    *@Description: Création de la PC
    *@CreatedDate:05/09/2018
    *@LastModified: 19/12/2018
    */
    public static gdfsuezComBefChpPivotPC.contextDt initContext(String application, String version) {
        // Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
        gdfsuezComBefChpPivotPC.contextDt_systemPath_system_element osource = new gdfsuezComBefChpPivotPC.contextDt_systemPath_system_element();
        osource.systemId = application;
        gdfsuezComBefChpPivotPC.contextDt octx = new gdfsuezComBefChpPivotPC.contextDt();
        octx.version = version;
        octx.allowCache = false;
        octx.systemPath = new gdfsuezComBefChpPivotPC.contextDt_systemPath_element();
        octx.systemPath.system_x = new gdfsuezComBefChpPivotPC.contextDt_systemPath_system_element[] {osource};
        return octx;
    }
/*
    *@author:RWA
    *@Description: rework service 
    *@CreatedDate:27/06/2019
    */
    public static gdfsuezBefCalypsoPropositioncommerc.Dependency initPort(){        
        SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();
        gdfsuezBefCalypsoPropositioncommerc.Dependency port = new gdfsuezBefCalypsoPropositioncommerc.Dependency();
        port.clientCertName_x = octopusCS.certName__c;
        port.endpoint_x = octopusCS.endpoint__c + 'ES-PropositionCommerciale_v3';
        port.inputHttpHeaders_x = new Map<String, String> {'Content-Type' => 'text/xml;charset=utf-8'};
        port.timeout_x = 120000;
        return port;
    }
 
   /*
    *@author:MHA
    *@Description: Appel du WS PropopositionCommerciale_V3
    *@CreatedDate:05/09/2018
    *@LastModified: MHA 14/03/2019
    */
    public static void createCommercialProposal(Map < String, Object > inputMap, Map < String, Object > outputMap, Map < String, Object > options) {
        String idBP = (String) inputMap.get('vRefClientIdBP');
        system.debug('@@ rwa inputMap ' +inputMap);
        
        if (String.isBlank(idBP)) {
             system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposal: refClientIdBP est null:'+ inputMap);
            outputMap.put('errorLibelle', 'Absence de la référence client');
            system.debug('outputMap:' + outputMap);
            throw new IOException('Absence de la référence client');
        }       
        System.debug('@@ vChoixElement '+inputMap.get('vChoixElement'));
        Datetime datePC = Datetime.now();
        String sellingOption;
        String effectiveDate;
        String effectiveDateGMT;
		String pcStatus;
       
        sellingOption = (String) inputMap.get('vChooseSellingOption');
		pcStatus =String.valueOf(inputMap.get('vNewPCStatus'));
		
        if (String.isBlank(sellingOption)) {                
            outputMap.put('errorLibelle', 'Absence du choix de l\'option de vente');
            throw new IOException('Absence du choix de l\'option de vente');
        }

		if (String.isBlank(pcStatus)) {                
            outputMap.put('errorLibelle', 'Absence du statut de la Proposition Commercial');
            throw new IOException('Absence du statut de la Proposition Commercial');
        }

        effectiveDateGMT = String.valueOf(inputMap.get('vEffectiveDate')); 
        if (String.isBlank(effectiveDateGMT)) {               
            outputMap.put('errorLibelle', 'Absence de la date effective de vente');
            throw new IOException('Absence de la date effective de vente');
        }
        effectiveDate = determineDateInUserTimeZone(effectiveDateGMT);
        String motifSouscriptionValue;
        String motifSouscriptionLibelle;
        String CTXT_SSCRPTN;
		String nbrExemplaire;

        if (sellingOption == 'Emménagement') {
            //Cas Emménagement - voir US624 Contexte=EM
            motifSouscriptionValue = 'Z002';
            motifSouscriptionLibelle = 'Emménagement';
            CTXT_SSCRPTN = 'MES_EMM';

			if(pcStatus == 'Accept'){
				nbrExemplaire = '1';
			}
			else if(pcStatus == 'Reflechis'){
				nbrExemplaire = '2';
			}
        }
        else if (sellingOption == 'Changement d\'Offre') {
            //Cas Changement d'Offre - voir US624 Contexte=CHO
            motifSouscriptionValue = 'Z008';
            motifSouscriptionLibelle = 'Changement d\'offre de marché';
            CTXT_SSCRPTN = 'CHGT_OFFR';
        }
        else if (sellingOption == 'Changement de fournisseur') {
            //Cas Changement de fournisseur - voir US624 Contexte=CHF

			nbrExemplaire = '2'; 
            CTXT_SSCRPTN = 'CHGT_FOURN';
            String vSelectedPDLValFormula = String.valueOf(inputMap.get('vSelectedPDLValFormula')) ;
            String vSelectedPCEValFormula = String.valueOf(inputMap.get('vSelectedPCEValFormula'));

            if (String.isBlank(vSelectedPDLValFormula) && String.isBlank(vSelectedPDLValFormula)) {
                system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposal:Pas de NumeroPointDeLivraison');
            }
            if (String.isNotBlank(vSelectedPDLValFormula) && String.isBlank(vSelectedPCEValFormula)) {
                motifSouscriptionValue = 'Z003';
            }
            else if (String.isBlank(vSelectedPDLValFormula) && String.isNotBlank(vSelectedPCEValFormula)) {
                motifSouscriptionValue = 'Z004';
            }
            else if (String.isNotBlank(vSelectedPDLValFormula) && String.isNotBlank(vSelectedPCEValFormula)) {
                motifSouscriptionValue = 'Z005';
            }

        }
		outputMap.put('nbrExemplaire',nbrExemplaire);
        system.debug('@@ nb exemplaire setté dans le output');
        String idLocal=String.valueOf(inputMap.get('vNumeroLocal'));
        system.debug('@@ idLocal ' +idLocal);
        if(String.isBlank(idLocal)) {
            outputMap.put('errorLibelle', 'Le numéro local SAP est absent');
            throw new IOException('Le numéro local SAP est absent');
        }

        String vIdCompteClient=String.valueOf(inputMap.get('vIdCompteClientNvxLogement'));
         system.debug('@@ vIdCompteClientNvxLogement ' +vIdCompteClient);
        if(String.isBlank(vIdCompteClient)){
            vIdCompteClient=String.valueOf(inputMap.get('vIdCompteClientSouscrire'));
            system.debug('@@ vIdCompteClientSouscrire ' +vIdCompteClient);
        }        
        /*BUG vlocity il arrive que lOS ne recupere pas le compte de contrat alors qu'il est bien dans le Json
			dans ce cas on va chercher en base SF*/
       /* if(String.isBlank(vIdCompteClient)){
            String accId=String.valueOf(inputMap.get('vDRId_Account'));
            Account porteFeuilleContrat=[select id, No_compte_contrat__c from account where id =:accId limit 1];
            if(porteFeuilleContrat!=null && String.isNotBlank(porteFeuilleContrat.No_compte_contrat__c)){
                vIdCompteClient=porteFeuilleContrat.No_compte_contrat__c;
                outputMap.put('idCompteClient', vIdCompteClient);
            }
        }*/      
        
        String idCompteClient=vIdCompteClient;
        system.debug('@@ idCompteClient ' +idCompteClient);
        if(String.isBlank(idCompteClient)){
             outputMap.put('errorLibelle', 'pas d\'id compte client');
             throw new IOException('pas d\'id compte client');
        }    
        String codeCampagne;
        String canaEnvoiCPV;
      
        codeCampagne = (String) inputMap.get('vCodeCampagne');
        if (String.isBlank(codeCampagne)) {
            system.debug('@@ SM_AP18_CreateCommercialProposal.createCommercialProposal:Pas de CodeCampagne:');
        }        
        
		/*nbrExemplaire = (String) inputMap.get('vNbrExemplaire');
        if (String.isBlank(nbrExemplaire)){
            outputMap.put('errorLibelle', 'Nombre d\'exemplaire non sélectionné');
            throw new IOException('Nombre d\'exemplaire non sélectionné');
        }*/

        canaEnvoiCPV = (String) inputMap.get('vCanaEnvoiCPV');
        if(String.isBlank(canaEnvoiCPV)){
            outputMap.put('errorLibelle', 'Le canal d\'envoie pour la CPV n\'a pas été choisi');
            throw new IOException('Le canal d\'envoie pour la CPV n\'a pas été choisi');
        }  
    
        Map<String, Object> prelevementBlock;
        Map<String, Object> mensualisationBlock;
        Map<String, Object> factureEnLigneBlock;
        String responsePrelevement;//prelevementBlock
        String mensualisation;//mensualisationBlock
        String valueMensualisation = '12';
        String libelleMensualisation = 'Annuel';
        String factureEnLigne;

        String drpValue;
        String jourSouhaite;

        Map<String, Object> drpBlock;
        Map<String, Object> servicesGestion = (Map<String, Object>)inputMap.get('vServicesGestion');
        if (servicesGestion != null) {
            if (servicesGestion.get('PrelevementBlock') !=  null) {
                prelevementBlock = (Map<String, Object>)servicesGestion.get('PrelevementBlock');
                if (prelevementBlock.get('Prelevement') != null) {
                    responsePrelevement = String.valueOf(prelevementBlock.get('Prelevement'));
                }
                else {
                    outputMap.put('errorLibelle', 'Veuillez remplir par Oui ou Non dans le choix de prélèvement');
                    throw new IOException('Veuillez remplir par Oui ou Non dans le choix de prélèvement');
                }
            }

            mensualisationBlock = (Map<String, Object>)servicesGestion.get('MensualisationBlock');
            if (mensualisationBlock == null) {
                mensualisation = 'non';
            } 
            else {
                mensualisation = (String)mensualisationBlock.get('Mensualisation');
                mensualisation = mensualisation.toLowerCase();
            }
            if (mensualisation != 'oui') {
                valueMensualisation = '6';
                libelleMensualisation  = 'Bi Annuel';
            }

            factureEnLigneBlock = (Map<String, Object>)servicesGestion.get('FactureEnLigneBlock');
            if (factureEnLigneBlock == null) {               
                factureEnLigne = 'non';
            }
            else {
                factureEnLigne = (String)factureEnLigneBlock.get('FactureEnLigne');               
            }

            drpBlock = (Map<String, Object>)servicesGestion.get('DRP');
            if (drpBlock == null) {
                system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposal:Pas de drpBlock:' + drpBlock);
                drpValue = 'non';
            } 
            else {
                drpValue = String.valueOf(drpBlock.get('RadioDRP'));
                if (String.isBlank(drpValue) ) {
                    system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposal:Pas de drpValue:' + drpBlock);
                }

                jourSouhaite = String.valueOf(drpBlock.get('SelectJourSouhaite'));
                if (String.isBlank(jourSouhaite)) {
                    system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposal:Pas de jourSouhaite:' + drpBlock);
                }
            }
        }

        Map<String, Object> offre = (Map<String, Object>)inputMap.get('OffreChoisis');
       String idPack = (String) inputMap.get('vIdPack');
       String mensGlobal;
        Map<String, Object> montantBlock;
        if (mensualisationBlock != null && 'oui'.equalsIgnoreCase(responsePrelevement) && 'oui'.equalsIgnoreCase(mensualisation)) {
            montantBlock = (Map<String, Object>)mensualisationBlock.get('MontantBlock');
            if (montantBlock != null) {                
                 mensGlobal = String.valueOf(montantBlock.get('MontantAjustable'));                
            }
        } 
        else {
            system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposal:Pas de mensualisation MontantAjustable');
        }
        if (String.isBlank(mensGlobal)) {          
                mensGlobal = String.valueOf(inputMap.get('vMensTotal'));
        }

        List<String> idOffreList = new List<String>();
        for (Object idOffer : (List<Object>)inputMap.get('vIdOffreList')) {
            idOffreList.add(String.valueOf(idOffer));
        }
       String typeComptage=String.valueOf(inputMap.get('vCodeTypeComptage'));
      
       String puissanceSouscrite=String.valueOf(inputMap.get('vPuissanceSouscriteValeur')) ;
       String CAR=String.valueOf(inputMap.get('vCAR'));
       String CAE=String.valueOf(inputMap.get('vCAE'));
       String CAE_HP=String.valueOf(inputMap.get('vCAE_HP'));
       String CAE_HC=String.valueOf(inputMap.get('vCAE_HC'));
       
       Id userID = UserInfo.getUserId();
        String identifiantCollab;
        List<User> usersList=[SELECT SAP_Identifier__c FROM USER WHERE ID = :userID ];
        if(usersList!=null && !usersList.isEmpty()){
             identifiantCollab = String.valueOf(usersList[0].SAP_Identifier__c);        
        }
        String idOrigine = '';
        String officeName = '';
        String typeEnseigne = 'DIRECTE';
        String typeEnseigneLibelle = 'Vente directe';
        String enseigne = 'EMDM';
       
        
        gdfsuezBefCalypsoPropositioncommerc.Dependency port= initPort();
        gdfsuezComBefChpPivotPC.contextDt octx = initContext('Smile', '3');
        gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale propositionCommerciale = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale();
        propositionCommerciale.motifSouscription = new gdfsuezComBefChpPivotPC.listeValeursDt();
        propositionCommerciale.motifSouscription.libelleCourt = motifSouscriptionLibelle;
        propositionCommerciale.motifSouscription.code = motifSouscriptionValue;
        //nombre exemplaire
        propositionCommerciale.nombreExemplaireCPV = nbrExemplaire;
        propositionCommerciale.rythmeFacturationSouhaite = new gdfsuezComBefChpPivotPC.listeValeursDt();
        propositionCommerciale.rythmeFacturationSouhaite.libelleCourt = libelleMensualisation;
        propositionCommerciale.rythmeFacturationSouhaite.code = valueMensualisation;

        propositionCommerciale.compteClient = new gdfsuezComBefCalypsoPropositioncomm.CompteClientAbstract();
        propositionCommerciale.compteClient.idCompteClient = idCompteClient;
        propositionCommerciale.enseigne = new gdfsuezComBefChpPivotPC.listeValeursDt();
        propositionCommerciale.enseigne.code = enseigne;
        propositionCommerciale.typeEnseigne = new gdfsuezComBefChpPivotPC.listeValeursDt();
        propositionCommerciale.typeEnseigne.libelleCourt = typeEnseigneLibelle;
        propositionCommerciale.typeEnseigne.code = typeEnseigne;
        //canal envoie
        propositionCommerciale.canalEnvoiCPV = new gdfsuezComBefChpPivotPC.listeValeursDt();
        if('Courrier'.equalsIgnoreCase(canaEnvoiCPV)){
            propositionCommerciale.canalEnvoiCPV.code = '0';
        }
        else if('Email'.equalsIgnoreCase(canaEnvoiCPV)){
            propositionCommerciale.canalEnvoiCPV.code = '1';
        }
        propositionCommerciale.canalEnvoiCPV.libelleCourt = canaEnvoiCPV;
        propositionCommerciale.composantePropositionCommerciale = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element[] {};
        //rythme facturation
        Datetime dateValueNow = Datetime.now();
        String formattedDateValueNow=dateValueNow.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        
        for (String idOffre : idOffreList) {
            gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element offreValue = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element();
            offreValue.offre = new gdfsuezComBefCalypsoPropositioncomm.offreDt();
            offreValue.offre.idOffre = idOffre;
            offreValue.dates = new gdfsuezComBefCalypsoPropositioncomm.datesDt[] {};
            gdfsuezComBefCalypsoPropositioncomm.datesDt debut =  new gdfsuezComBefCalypsoPropositioncomm.datesDt();
            debut.valeurDate = formattedDateValueNow;
            debut.motifDate = new gdfsuezComBefChpPivotPC.listeValeursDt();
            debut.motifDate.categorie = 'motifDateComposantePropal';
            debut.motifDate.code = 'dateRendezVousDu';
            offreValue.dates.add(debut);

            gdfsuezComBefCalypsoPropositioncomm.datesDt fin =  new gdfsuezComBefCalypsoPropositioncomm.datesDt();
            fin.valeurDate = formattedDateValueNow;
            fin.motifDate = new gdfsuezComBefChpPivotPC.listeValeursDt();
            fin.motifDate.categorie = 'motifDateComposantePropal';
            fin.motifDate.code = 'dateRendezVousAu';
            offreValue.dates.add(fin);
            offreValue.caracteristiquePME = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element[] {};
            gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element caracteristiquePMEV = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element();
            caracteristiquePMEV.valeur = valueMensualisation;
            caracteristiquePMEV.code = 'RYTHM_FAC';
            offreValue.caracteristiquePME.add(caracteristiquePMEV);
            gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element caracteristiquePME6 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element();
            caracteristiquePME6.valeur = CTXT_SSCRPTN;
            caracteristiquePME6.code = 'CTXT_SSCRPTN';
            offreValue.caracteristiquePME.add(caracteristiquePME6);

            if (idOffre.substring(0, 1) == 'E') {
                gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element caracteristiquePME5 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element();
                caracteristiquePME5.valeur = CAE;
                caracteristiquePME5.code = 'CAE';
                offreValue.caracteristiquePME.add(caracteristiquePME5);

                if (typeComptage == 'HPHC') {
                    gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element caracteristiqueHP = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element();
                    caracteristiqueHP.valeur = CAE_HP;
                    caracteristiqueHP.code = 'CAE_HPBIS';
                    offreValue.caracteristiquePME.add(caracteristiqueHP);

                    gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element caracteristiqueHC = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element();
                    caracteristiqueHC.valeur = CAE_HC;
                    caracteristiqueHC.code = 'CAE_HC';
                    offreValue.caracteristiquePME.add(caracteristiqueHC);
                }

                gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element caracteristiquePMETypeComptage = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element();
                caracteristiquePMETypeComptage.valeur = typeComptage;
                caracteristiquePMETypeComptage.code = 'COPIE_TYC';
                offreValue.caracteristiquePME.add(caracteristiquePMETypeComptage);

                gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element caracteristiquePMEPuissance = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element();
                caracteristiquePMEPuissance.valeur = puissanceSouscrite;
                caracteristiquePMEPuissance.code = 'COPIE_PS';
                offreValue.caracteristiquePME.add(caracteristiquePMEPuissance);
                propositionCommerciale.composantePropositionCommerciale.add(offreValue);
            }

            if (idOffre.substring(0, 1) == 'G') {
                gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element caracteristiquePME5 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element();
                caracteristiquePME5.valeur = CAR;
                caracteristiquePME5.code = 'CAE';
                offreValue.caracteristiquePME.add(caracteristiquePME5);
                propositionCommerciale.composantePropositionCommerciale.add(offreValue);
            }
        }

        //mens
        gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element offreValue1 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element();
        offreValue1.offre = new gdfsuezComBefCalypsoPropositioncomm.offreDt();
        offreValue1.offre.idOffre = 'MENS';

        offreValue1.dates = new gdfsuezComBefCalypsoPropositioncomm.datesDt[] {};
        gdfsuezComBefCalypsoPropositioncomm.datesDt debut1 =  new gdfsuezComBefCalypsoPropositioncomm.datesDt();     
        debut1.valeurDate = formattedDateValueNow;
        debut1.motifDate = new gdfsuezComBefChpPivotPC.listeValeursDt();
        debut1.motifDate.categorie = 'motifDateComposantePropal';
        debut1.motifDate.code = 'dateRendezVousDu';
        offreValue1.dates.add(debut1);

        gdfsuezComBefCalypsoPropositioncomm.datesDt fin1 =  new gdfsuezComBefCalypsoPropositioncomm.datesDt();
        fin1.valeurDate = formattedDateValueNow;
        fin1.motifDate = new gdfsuezComBefChpPivotPC.listeValeursDt();
        fin1.motifDate.categorie = 'motifDateComposantePropal';
        fin1.motifDate.code = 'dateRendezVousAu';
        offreValue1.dates.add(fin1);
        offreValue1.caracteristiquePME = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element[] {};
        gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element caracteristiquePMEV1 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element();
        if (valueMensualisation == '12' && responsePrelevement == 'Oui') {
            caracteristiquePMEV1.valeur = 'OUI';
            caracteristiquePMEV1.code = 'SOUS_MENS';
        } else {
            caracteristiquePMEV1.valeur = 'NON';
            caracteristiquePMEV1.code = 'SOUS_MENS';
        }
        offreValue1.caracteristiquePME.add(caracteristiquePMEV1);
        gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element caracteristiquePMEV2 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element();
        caracteristiquePMEV2.valeur = mensGlobal;
        caracteristiquePMEV2.code = 'OC_MNT_MENS';
        offreValue1.caracteristiquePME.add(caracteristiquePMEV2);
        propositionCommerciale.composantePropositionCommerciale.add(offreValue1);

        //CEL
        if (factureEnLigne == 'Oui' && responsePrelevement == 'Oui') {
            gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element offreValue2 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element();
            offreValue2.offre = new gdfsuezComBefCalypsoPropositioncomm.offreDt();
            offreValue2.offre.idOffre = 'CEL';

            offreValue2.dates = new gdfsuezComBefCalypsoPropositioncomm.datesDt[] {};
            gdfsuezComBefCalypsoPropositioncomm.datesDt debut2 =  new gdfsuezComBefCalypsoPropositioncomm.datesDt();
            debut2.valeurDate = formattedDateValueNow;
            debut2.motifDate = new gdfsuezComBefChpPivotPC.listeValeursDt();
            debut2.motifDate.categorie = 'motifDateComposantePropal';
            debut2.motifDate.code = 'dateRendezVousDu';
            offreValue2.dates.add(debut2);

            gdfsuezComBefCalypsoPropositioncomm.datesDt fin2 =  new gdfsuezComBefCalypsoPropositioncomm.datesDt();
            fin2.valeurDate =formattedDateValueNow;
            fin2.motifDate = new gdfsuezComBefChpPivotPC.listeValeursDt();
            fin2.motifDate.categorie = 'motifDateComposantePropal';
            fin2.motifDate.code = 'dateRendezVousAu';
            offreValue2.dates.add(fin2);
            propositionCommerciale.composantePropositionCommerciale.add(offreValue2);
        }

        //facture online
        if (factureEnLigne == 'Oui' && responsePrelevement == 'Oui') {
            gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element offreValue3 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element();
            offreValue3.offre = new gdfsuezComBefCalypsoPropositioncomm.offreDt();
            offreValue3.offre.idOffre = 'FACT_DEMAT';

            offreValue3.dates = new gdfsuezComBefCalypsoPropositioncomm.datesDt[] {};
            gdfsuezComBefCalypsoPropositioncomm.datesDt debut3 =  new gdfsuezComBefCalypsoPropositioncomm.datesDt();
            debut3.valeurDate = formattedDateValueNow;
            debut3.motifDate = new gdfsuezComBefChpPivotPC.listeValeursDt();
            debut3.motifDate.categorie = 'motifDateComposantePropal';
            debut3.motifDate.code = 'dateRendezVousDu';
            offreValue3.dates.add(debut3);

            gdfsuezComBefCalypsoPropositioncomm.datesDt fin3 =  new gdfsuezComBefCalypsoPropositioncomm.datesDt();
            fin3.valeurDate =formattedDateValueNow;
            fin3.motifDate = new gdfsuezComBefChpPivotPC.listeValeursDt();
            fin3.motifDate.categorie = 'motifDateComposantePropal';
            fin3.motifDate.code = 'dateRendezVousAu';
            offreValue3.dates.add(fin3);
            propositionCommerciale.composantePropositionCommerciale.add(offreValue3);
        }
        //DRP
        if (drpValue == 'Oui' && responsePrelevement == 'Oui') {
            gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element offreValue4 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element();
            offreValue4.offre = new gdfsuezComBefCalypsoPropositioncomm.offreDt();
            offreValue4.offre.idOffre = 'DRP';

            offreValue4.dates = new gdfsuezComBefCalypsoPropositioncomm.datesDt[] {};
            gdfsuezComBefCalypsoPropositioncomm.datesDt debut4 =  new gdfsuezComBefCalypsoPropositioncomm.datesDt();
            debut4.valeurDate = formattedDateValueNow;
            debut4.motifDate = new gdfsuezComBefChpPivotPC.listeValeursDt();
            debut4.motifDate.categorie = 'motifDateComposantePropal';
            debut4.motifDate.code = 'dateRendezVousDu';
            offreValue4.dates.add(debut4);

            offreValue4.caracteristiquePME = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element[] {};
            gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element caracteristiquePMEDRP = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element();
            caracteristiquePMEDRP.valeur = jourSouhaite;
            caracteristiquePMEDRP.code = 'DRP_JOUR';
            offreValue4.caracteristiquePME.add(caracteristiquePMEDRP);

            gdfsuezComBefCalypsoPropositioncomm.datesDt fin4 =  new gdfsuezComBefCalypsoPropositioncomm.datesDt();
            fin4.valeurDate = formattedDateValueNow;
            fin4.motifDate = new gdfsuezComBefChpPivotPC.listeValeursDt();
            fin4.motifDate.categorie = 'motifDateComposantePropal';
            fin4.motifDate.code = 'dateRendezVousAu';
            offreValue4.dates.add(fin4);
            propositionCommerciale.composantePropositionCommerciale.add(offreValue4);
        }

        if (responsePrelevement == 'Oui') {
            gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element offreValue5 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element();
            offreValue5.offre = new gdfsuezComBefCalypsoPropositioncomm.offreDt();
            offreValue5.offre.idOffre = 'PREL';
            propositionCommerciale.composantePropositionCommerciale.add(offreValue5);
        }

        propositionCommerciale.pack = new gdfsuezComBefCalypsoPropositioncomm.PackAbstract();
        propositionCommerciale.pack.idPack = idPack;
        propositionCommerciale.remiseOneShot = new gdfsuezComBefCalypsoPropositioncomm.RemiseOneShotDt[] {};
        gdfsuezComBefCalypsoPropositioncomm.RemiseOneShotDt ros = new gdfsuezComBefCalypsoPropositioncomm.RemiseOneShotDt();
        ros.montantHT = Integer.valueOf(0);
        propositionCommerciale.remiseOneShot.add(ros);
        propositionCommerciale.local = new gdfsuezComBefCalypsoPropositioncomm.LocalAbstract();
        propositionCommerciale.local.idLocal = idLocal;

        propositionCommerciale.refPersonne = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_refPersonne_element[] {};
        gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_refPersonne_element personne = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_refPersonne_element();
        personne.personne = new gdfsuezComBefCalypsoPersonne.PersonneAbstract();
        personne.personne.idPersonne = identifiantCollab;
        gdfsuezComBefChpPivotPC.listeValeursDt role = new gdfsuezComBefChpPivotPC.listeValeursDt();
        role.categorie = 'rolePersonneVente';
        role.code = 'collaborateurResponsable';
        personne.rolePersonne = role;
        propositionCommerciale.refPersonne.add(personne);
        gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_refPersonne_element personne1 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_refPersonne_element();
        personne1.personne = new gdfsuezComBefCalypsoPersonne.PersonneAbstract();
        personne1.personne.idPersonne = identifiantCollab;
        gdfsuezComBefChpPivotPC.listeValeursDt role1 = new gdfsuezComBefChpPivotPC.listeValeursDt();
        role1.categorie = 'rolePersonneVente';
        role1.code = 'conseillerOrigineCreation';
        personne1.rolePersonne = role1;
        propositionCommerciale.refPersonne.add(personne1);
        //BP à récupérer et identifiant collaborateur
        gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_refPersonne_element personne2 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_refPersonne_element();
        personne2.personne = new gdfsuezComBefCalypsoPersonne.PersonneAbstract();
        personne2.personne.idPersonne = idBP;
        gdfsuezComBefChpPivotPC.listeValeursDt role2 = new gdfsuezComBefChpPivotPC.listeValeursDt();
        role2.categorie = 'rolePersonneVente';
        role2.code = 'contractant';
        personne2.rolePersonne = role2;
        propositionCommerciale.refPersonne.add(personne2);

       
        gdfsuezComBefCalypsoPropositioncomm.datesDt datePCValue = new gdfsuezComBefCalypsoPropositioncomm.datesDt();
        datePCValue.valeurDate =  formattedDateValueNow;
        datePCValue.motifDate = new gdfsuezComBefChpPivotPC.listeValeursDt();
        datePCValue.motifDate.categorie = 'motifDate';
        datePCValue.motifDate.code = 'dateCreation';

        gdfsuezComBefCalypsoPropositioncomm.datesDt datePCValue1 = new gdfsuezComBefCalypsoPropositioncomm.datesDt();
        datePCValue1.valeurDate = effectiveDate;
        System.debug('@effectiveDate' + effectiveDate);
         datePCValue1.motifDate = new gdfsuezComBefChpPivotPC.listeValeursDt();
        datePCValue1.motifDate.categorie = 'motifDate';
        datePCValue1.motifDate.code = 'dateEffetContractuel';

        propositionCommerciale.datesPropositionCommerciale = new gdfsuezComBefCalypsoPropositioncomm.datesDt[] {};
        propositionCommerciale.datesPropositionCommerciale.add(datePCValue);
        propositionCommerciale.datesPropositionCommerciale.add(datePCValue1);
        //code campagne
        if (!String.isBlank(codeCampagne)) {
            propositionCommerciale.codeCampagne = codeCampagne;
        }
        propositionCommerciale.description = 'Creation de la PC SMILE';

        gdfsuezBefCalypsoPropositioncommerc.creerPropositionCommercialeInputDt input = new gdfsuezBefCalypsoPropositioncommerc.creerPropositionCommercialeInputDt();
        input.propositionCommerciale = propositionCommerciale;

        gdfsuezBefCalypsoPropositioncommerc.creerPropositionCommercialeResponse_element response = new gdfsuezBefCalypsoPropositioncommerc.creerPropositionCommercialeResponse_element();
   if (!Test.isRunningTest()) {
            try {
                response = port.CreerPropositionCommerciale_Http(input, octx);
            } catch (Exception e) {
                System.debug(e);
                outputMap.put('errorLibelle', e);
                throw new IOException(e);
                /*return;*/
            }

        } else {
            Test.setMock(HttpCalloutMock.class, new SM_AP18_CreateCommercialProposalMock());
            gdfsuezBefCalypsoPropositioncommerc.Dependency porttest = new gdfsuezBefCalypsoPropositioncommerc.Dependency();
            system.debug('@@ start of mock');
            response = porttest.CreerPropositionCommerciale_Http(input, octx);

            system.debug('@@ end of mock');
        }
        System.debug('@response ==>' + response);
        if (response.creerPropositionCommercialeOutput != null && response.creerPropositionCommercialeOutput.propositionCommerciale != null && !String.isBlank(String.valueOf(response.creerPropositionCommercialeOutput.propositionCommerciale.idPropositionCommerciale))) {
            outputMap.put('idPropositionCommerciale', response.creerPropositionCommercialeOutput.propositionCommerciale.idPropositionCommerciale);
            outputMap.put('errorLibelle', 'OK');
        } else {
            outputMap.put('errorCode', response.messageRetours.retourTraitementMessage[0].code);
            outputMap.put('errorLibelle', response.messageRetours.retourTraitementMessage[0].libelle);
            throw new IOException(response.messageRetours.retourTraitementMessage[0].libelle);
        }
        System.debug('outputMap:' + outputMap);

    }

        


    /*
    *@author:MHA
    *@Description: transformation de la PC dans le cas où le nombre d'exemplaire est égal à 1 et que l'order est créée
    *@CreatedDate:05/09/2018
    *@LastModified:14/03/2018
    */

    public static void transformCommercialProposal(Map < String, Object > inputMap, Map < String, Object > outputMap, Map < String, Object > options) {
             
        String vIdPropositionCommerciale = (String)inputMap.get('vIdPropositionCommerciale');
        if (String.isBlank(vIdPropositionCommerciale)) {
            system.debug('inputs' + inputMap);
            outputMap.put('errorLibelle', 'l\'idPropositionCommerciale est manquant');
            throw new IOException('L\'id de la proposition Commerciale est manquant');
        
        }
        gdfsuezBefCalypsoPropositioncommerc.Dependency port= initPort();
        gdfsuezComBefChpPivotPC.contextDt octx = initContext('Smile', '3');
        gdfsuezBefCalypsoPropositioncommerc.PropositionCommercialeAbstract propositionCommerciale = new gdfsuezBefCalypsoPropositioncommerc.PropositionCommercialeAbstract();
        propositionCommerciale.idPropositionCommerciale = vIdPropositionCommerciale;
        gdfsuezBefCalypsoPropositioncommerc.transformerPropositionCommercialeInputDt input = new gdfsuezBefCalypsoPropositioncommerc.transformerPropositionCommercialeInputDt();
        input.propositionCommerciale = propositionCommerciale;
        gdfsuezBefCalypsoPropositioncommerc.transformerPropositionCommercialeResponse_element response = new gdfsuezBefCalypsoPropositioncommerc.transformerPropositionCommercialeResponse_element();

        if (!Test.isRunningTest()) {
            try {
                response = port.TransformerPropositionCommerciale_Http(input, octx);
            } catch (Exception e) {
                System.debug(e);
                throw new IOException(e);
            }

        } else {
            Test.setMock(HttpCalloutMock.class, new SM_AP18_CreateCommercialProposalMock());
            gdfsuezBefCalypsoPropositioncommerc.Dependency porttest = new gdfsuezBefCalypsoPropositioncommerc.Dependency();
            system.debug('@@ start of mock');
            response = porttest.TransformerPropositionCommerciale_Http(input, octx);            
            system.debug('@@ end of mock');
        }
        System.debug('response ==>' + response);
        if(response!=null && response.messageRetours!=null){
            System.debug('@@ messageRetours ' +response.messageRetours);
            for(gdfsuezComBefChpPivotPC.retourTraitementMessageDt rtm :response.messageRetours.retourTraitementMessage){
                System.debug('@@ messageRetours rtm' +rtm);
                if('Erreur'.equalsIgnoreCase(rtm.type_x)){
                    outputMap.put('MsgTransfoPCKO', rtm.libelle);
                    //throw new IOException(rtm.libelle);
                }
            }

        }
        if(response!=null 
            &&  response.transformerPropositionCommercialeOutput!=null 
            &&  response.transformerPropositionCommercialeOutput.objetsCrees!=null ){
                if(response.transformerPropositionCommercialeOutput.objetsCrees.contrat!=null 
                    && !response.transformerPropositionCommercialeOutput.objetsCrees.contrat.isEmpty()){
                    outputMap.put( 'idContrat', response.transformerPropositionCommercialeOutput.objetsCrees.contrat[0].idContrat);   
                    //vOrderId %RemoteActionCreateOrder:OrderId% 
                   //vNewPCStatus %vNewPCStatus%
                    String orderId=String.valueOf(inputMap.get('vOrderId'));
                    System.debug('@@ orderId ' +orderId);
                    String pcStatus =String.valueOf(inputMap.get('vNewPCStatus'));                    
                    System.debug('@@ vNewPCStatus ' +pcStatus);
                    SM_AP42_CreationOrder.majOrderFuture(orderId, pcStatus);
                }                  
        }
      
        System.debug('@transfo PC out put idContrat:' + outputMap.get('idContrat'));   
        System.debug('@transfo PC KOmsg:' + outputMap.get('MsgTransfoPCKO'));       
       
    }

    /*
    *@author:HEL
    *@Description: Mise à jour de la PC quand la PC est refusé et que le nb d'exemplaire est égal à 1
    *@CreatedDate:05/09/2018
    *@LastModified:05/09/2018
    */
    public static String majStatusCommercialProposal(String idPropositionCommerciale, String codeStatus, String libeleStatus) {
        gdfsuezComBefChpPivotPC.contextDt octx = initContext('Smile', '3');
        SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();
        gdfsuezBefCalypsoPropositioncommerc.Dependency port = new gdfsuezBefCalypsoPropositioncommerc.Dependency();
        port.clientCertName_x = octopusCS.certName__c;
        port.endpoint_x = octopusCS.endpoint__c + 'ES-PropositionCommerciale_v3';
        port.inputHttpHeaders_x = new Map<String, String> {'Content-Type' => 'text/xml;charset=utf-8'};
        port.timeout_x = 60000;

        gdfsuezBefCalypsoPropositioncommerc.PropositionCommercialeAbstract propositionCommerciale = new gdfsuezBefCalypsoPropositioncommerc.PropositionCommercialeAbstract();
        propositionCommerciale.idPropositionCommerciale = idPropositionCommerciale;
        gdfsuezComBefChpPivotPC.listeValeursDt status = new gdfsuezComBefChpPivotPC.listeValeursDt();
        status.libelleCourt = libeleStatus;
        status.code = codeStatus;
        propositionCommerciale.statutPropositionCommerciale  = status;
        gdfsuezBefCalypsoPropositioncommerc.majPropositionCommercialeInputDt input = new gdfsuezBefCalypsoPropositioncommerc.majPropositionCommercialeInputDt();
        input.propositionCommerciale = propositionCommerciale;

        gdfsuezComBefChpPivotPC.retourTraitementMessagesDt response = new gdfsuezComBefChpPivotPC.retourTraitementMessagesDt();
        /*response = port.CreerPropositionCommerciale(input, octx);*/
        if (!Test.isRunningTest()) {
            try {
                response = port.MajPropositionCommerciale_Http(input, octx);
            } catch (Exception e) {
                System.debug(e);
            }

        } else {
            Test.setMock(HttpCalloutMock.class, new SM_AP18_CreateCommercialProposalMock());
            gdfsuezBefCalypsoPropositioncommerc.Dependency porttest = new gdfsuezBefCalypsoPropositioncommerc.Dependency();
            system.debug('@@ start of mock');
            response = porttest.MajPropositionCommerciale_Http(input, octx);
            /*gdfsuezComBefChpPivotPC.retourTraitementMessageDt retourTraitementMessage = new gdfsuezComBefChpPivotPC.retourTraitementMessageDt();
            retourTraitementMessage.libelle = 'Traitement effectué sans erreur';
            retourTraitementMessage.code = 'OCTOPUS_MAJPropositionCommerciale_01';
            gdfsuezComBefChpPivotPC.retourTraitementMessageDt[] retourTraitementMessages = new List<gdfsuezComBefChpPivotPC.retourTraitementMessageDt>();
            retourTraitementMessages.add(retourTraitementMessage);
            response.retourTraitementMessage = retourTraitementMessages;*/
            system.debug('@@ end of mock');
        }
        System.debug('response ==>' + response);

        return response.retourTraitementMessage[0].code;


        /*if(response.transformerPropositionCommercialeOutput.objetsMAJ.propositionCommerciale.idPropositionCommerciale != null){
            outputMap.put( 'idContrat',response.transformerPropositionCommercialeOutput.objetsMAJ.propositionCommerciale.idPropositionCommerciale);
        }
        System.debug('@MHA:'+outputMap);*/
    }

    public class IOException extends Exception {
    }

    /*
    *@author:HEL
    *@Description: transformation de la PC dans le cas où le nombre d'exemplaire est égal à 2 et que l'order et la PC sont préalablement créés.
     On mets à jours d'abord le statut de la PC dans SAP, ensuite on la transforme.
    *@CreatedDate:14/02/2019
    *@LastModified:14/02/2019
    */
    public static void transformerPCDeuxExemplaires(Map < String, Object > inputMap, Map < String, Object > outputMap, Map < String, Object > options) {

        String idPropositionCommerciale = (String)inputMap.get('vIdPropositionCommerciale');
        if (idPropositionCommerciale == null) {
            system.debug('No idPropositionCommerciale found');
            system.debug('inputs' + inputMap);
            return;
        }
        String codeStatus = System.Label.SM_CL32_PC_Status_Code_AcceptedWithSignature;
        String labelStatus = System.Label.SM_CL33_PC_Status_Label_AcceptedWithSignature;

        //Mettre à jour la PC en mettant le bon statut dans SAP
        String reponseCode = majStatusCommercialProposal(idPropositionCommerciale, codeStatus, labelStatus);

        //Appel du service TransformerPC si la MAJ ets réussie
        if ('OCTOPUS_MAJPropositionCommerciale_01'.equals(reponseCode)) {
            transformCommercialProposal(inputMap, outputMap, options);

            // Si la Transformation PC est réussie, on modifie le statut de l'Order
          /*  if (!String.isBlank(String.valueOf(outputMap.get('idContrat')))) {
                majOrderStatus(inputMap);
            }*/
        }
    }

    public static void majOrderStatus(Map < String, Object > inputMap) {
        String orderId = (String) inputMap.get('orderId');
        if (String.isBlank(orderId) ) {
            system.debug('No order Id found');
            system.debug('inputs' + inputMap);
            return;
        }
        Order orderToUpdate = [SELECT ID, Status FROM Order WHERE ID = :orderId];

        orderToUpdate.status = System.Label.SM_CL34_Order_Status_Activated;

        update orderToUpdate;
    }
    
        /*
            *@author:Hamza EL HARRAOUI ~ hamza.elharraoui@external.engie.com
            *@Description: Appel du WS PropopositionCommerciale_V3 pour les services affinitaires
            *@CreatedDate: 18/04/2018
            */
            public static void createCommercialProposalSA(Map < String, Object > inputMap, Map < String, Object > outputMap, Map < String, Object > options) {
                String idBP = (String) inputMap.get('refClientIdBP');
                if (String.isBlank(idBP)) {
                    //idBP est null
                    system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposalSA: refClientIdBP est null:'+ inputMap);
                    outputMap.put('errorLibelle', 'Absence de la référence client');
                    system.debug('outputMap:' + outputMap);
                    throw new IOException('Absence de la référence client');
                }

                Datetime datePC = Datetime.now();

                Map<String, Object> choixElements = (Map<String, Object>)inputMap.get('ChoixElements');

                String sellingOption;
                String effectiveDate;
                String effectiveDateGMT;
                if (choixElements != null) {
                    //Pas de choixElements
                    sellingOption = (String) choixElements.get('chooseSellingOption');
                    if (String.isBlank(sellingOption)) {
                        system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposalSA:pas de chooseSellingOption;choixElements:' + choixElements);
                        outputMap.put('errorLibelle', 'Absence du choix de l\'option de vente');
                        throw new IOException('Absence du choix de l\'option de vente');
                    }

                    effectiveDateGMT = String.valueOf(choixElements.get('EffectiveDate'));
                    System.debug(effectiveDateGMT);
                    if (String.isBlank(effectiveDateGMT)) {
                        system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposalSA:pas de effectiveDate;choixElements:' + choixElements);
                        outputMap.put('errorLibelle', 'Absence de la date effective de vente');
                        throw new IOException('Absence de la date effective de vente');
                    }
                    effectiveDate = determineDateInUserTimeZone(effectiveDateGMT);
                }

                ContextModel contextModel = determineContextModel(inputMap,sellingOption);
                String motifSouscriptionValue = contextModel.motifSouscriptionValue;
                String motifSouscriptionLibelle = contextModel.motifSouscriptionLibelle;
                String CTXT_SSCRPTN = contextModel.CTXT_SSCRPTN;
                

                String idLocal = determineIdLocal(inputMap,outputMap);
                

                String idCompteClient = determineIdCompteClient(inputMap,outputMap);
                

                CaracteristiquesOffreModel caracteristiquesOffreModel = determineCaracteristiquesOffreModel(inputMap,outputMap);
                String codeCampagne = caracteristiquesOffreModel.codeCampagne;
                String nbrExemplaire = caracteristiquesOffreModel.nbrExemplaire;
                String canaEnvoiCPV = caracteristiquesOffreModel.canalEnvoiCPV;
                

               
                Map<String, Object> mensualisationBlock;
                
                String mensualisation;
                String valueMensualisation = '12';
                String libelleMensualisation = 'Annuel';

                Map<String, Object> servicesGestion = (Map<String, Object>)inputMap.get('ServicesGestion');
                if (servicesGestion != null) {

                    mensualisationBlock = (Map<String, Object>)servicesGestion.get('MensualisationBlock');
                    if (mensualisationBlock == null) {
                        system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposal:Pas de MensualisationBlock:' + servicesGestion);
                        mensualisation = 'non';
                    } 
                    else {
                        mensualisation = (String)mensualisationBlock.get('Mensualisation');
                        mensualisation = mensualisation.toLowerCase();
                        if (mensualisation == null) {
                            system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposal:Pas de MensualisationBlock:' + mensualisationBlock);
                            //Traitement à confirmer
                        }
                    }

                    if (mensualisation != 'oui') {
                        valueMensualisation = '6';
                        libelleMensualisation  = 'Bi Annuel';
                    }
                }
                
                String idPack = determineIdPack(inputMap);
                if(String.isBlank(idPack)){
                    system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposalSA : pas de idPack ');
                    outputMap.put('errorLibelle', 'Absence de l\'identifiant du pack pour le service affinitaire à souscrire');
                    throw new IOException('Absence de l\'id du pack SA');
                }
                

                Id userID = UserInfo.getUserId();
                String identifiantCollab = String.valueOf([SELECT SAP_Identifier__c FROM USER WHERE ID = :userID limit 1].SAP_Identifier__c);
                String idOrigine = '';
                String officeName = '';
                String typeEnseigne = 'DIRECTE';
                String typeEnseigneLibelle = 'Vente directe';
                String enseigne = 'EMDM';
                
                
                String civiliteAssureSimple = (String)inputMap.get('AssuranceSimpleCivilite');
                String prenomAssureSimple = (String)inputMap.get('AssuranceSimplePrenom');
                String nomAssureSimple = (String)inputMap.get('AssuranceSimpleNom');
                String dateNaissanceAssureSimple = (String)inputMap.get('AssuranceSimpleDateN');
                String cspAssureSimple = (String)inputMap.get('AssuranceSimpleCSP');
                
                if(String.isBlank(civiliteAssureSimple) || String.isBlank(prenomAssureSimple) || String.isBlank(nomAssureSimple) || String.isBlank(dateNaissanceAssureSimple) || String.isBlank(cspAssureSimple)){
                    system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposalSA :  Abscence des inforamtions de l\'assure ');
                    outputMap.put('errorLibelle', 'Creation PC Service Affinitaire KO : Abscence des inforamtions de l\'assure');
                    throw new IOException('Creation PC Service Affinitaire KO : Abscence des inforamtions de l\'assure');
                }

                gdfsuezComBefChpPivotPC.contextDt octx = initContext('Smile', '3');
                SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();
                gdfsuezBefCalypsoPropositioncommerc.Dependency port = new gdfsuezBefCalypsoPropositioncommerc.Dependency();
                port.clientCertName_x = octopusCS.certName__c;
                port.endpoint_x = octopusCS.endpoint__c + 'ES-PropositionCommerciale_v3';
                port.inputHttpHeaders_x = new Map<String, String> {'Content-Type' => 'text/xml;charset=utf-8'};
                port.timeout_x = 120000;
                /*port.inputHttpHeaders_x.put('Username','HV1002');
                port.inputHttpHeaders_x.put('Password', token);*/


                gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale propositionCommerciale = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale();
                propositionCommerciale.motifSouscription = new gdfsuezComBefChpPivotPC.listeValeursDt();
                propositionCommerciale.motifSouscription.libelleCourt = motifSouscriptionLibelle;
                propositionCommerciale.motifSouscription.code = motifSouscriptionValue;
                //nombre exemplaire
                propositionCommerciale.nombreExemplaireCPV = nbrExemplaire;
                propositionCommerciale.rythmeFacturationSouhaite = new gdfsuezComBefChpPivotPC.listeValeursDt();
                propositionCommerciale.rythmeFacturationSouhaite.libelleCourt = libelleMensualisation;
                propositionCommerciale.rythmeFacturationSouhaite.code = valueMensualisation;

                propositionCommerciale.compteClient = new gdfsuezComBefCalypsoPropositioncomm.CompteClientAbstract();
                /*propositionCommerciale.compteClient.idCompteClient = '500039150';*/
                propositionCommerciale.compteClient.idCompteClient = idCompteClient;
                propositionCommerciale.enseigne = new gdfsuezComBefChpPivotPC.listeValeursDt();
                propositionCommerciale.enseigne.code = enseigne;
                propositionCommerciale.typeEnseigne = new gdfsuezComBefChpPivotPC.listeValeursDt();
                propositionCommerciale.typeEnseigne.libelleCourt = typeEnseigneLibelle;
                propositionCommerciale.typeEnseigne.code = typeEnseigne;
                //canal envoie
                propositionCommerciale.canalEnvoiCPV = new gdfsuezComBefChpPivotPC.listeValeursDt();
                  if('Courrier'.equalsIgnoreCase(canaEnvoiCPV)){
                    propositionCommerciale.canalEnvoiCPV.code = '0';
                }
                else if('Email'.equalsIgnoreCase(canaEnvoiCPV)){
                    propositionCommerciale.canalEnvoiCPV.code = '1';
                }
                propositionCommerciale.canalEnvoiCPV.libelleCourt = canaEnvoiCPV;
                propositionCommerciale.composantePropositionCommerciale = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element[] {};
                //rythme facturation
                Datetime dateValueNow = Datetime.now();
                
                
            // composantePropositionCommerciale
            gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element offreValue1 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element();
            offreValue1.offre = new gdfsuezComBefCalypsoPropositioncomm.offreDt();
            offreValue1.offre.idOffre = 'PREV_FACT';

            offreValue1.dates = new gdfsuezComBefCalypsoPropositioncomm.datesDt[] {};
            gdfsuezComBefCalypsoPropositioncomm.datesDt debut =  new gdfsuezComBefCalypsoPropositioncomm.datesDt();
            debut.valeurDate = dateValueNow.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
            debut.motifDate = new gdfsuezComBefChpPivotPC.listeValeursDt();
            debut.motifDate.categorie = 'motifDateComposantePropal';
            debut.motifDate.code = 'dateRendezVousDu';
            offreValue1.dates.add(debut);

            gdfsuezComBefCalypsoPropositioncomm.datesDt fin =  new gdfsuezComBefCalypsoPropositioncomm.datesDt();
            fin.valeurDate = dateValueNow.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
            fin.motifDate = new gdfsuezComBefChpPivotPC.listeValeursDt();
            fin.motifDate.categorie = 'motifDateComposantePropal';
            fin.motifDate.code = 'dateRendezVousAu';
            offreValue1.dates.add(fin);
            offreValue1.caracteristiquePME = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element[] {};
            
            
            // NOM
            gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element caracteristiquePMENom = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element();
            caracteristiquePMENom.valeur = nomAssureSimple;
            caracteristiquePMENom.code = 'ASSURE_NOM';
            offreValue1.caracteristiquePME.add(caracteristiquePMENom);
            
            // PRENOM
            gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element caracteristiquePMEPrenom = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element();
            caracteristiquePMEPrenom.valeur = prenomAssureSimple;
            caracteristiquePMEPrenom.code = 'ASSURE_PRENOM';
            offreValue1.caracteristiquePME.add(caracteristiquePMEPrenom);
            
            // DATE NAISSANCE
            gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element caracteristiquePMEDateNaissance = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element();
            caracteristiquePMEDateNaissance.valeur = dateNaissanceAssureSimple;
            caracteristiquePMEDateNaissance.code = 'ASSURE_DATE_NAIS';
            offreValue1.caracteristiquePME.add(caracteristiquePMEDateNaissance);
            
            // CATEGORIE SOCIO-PROFESSIONNELLE
            gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element caracteristiquePMECSP = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element();
            caracteristiquePMECSP.valeur = cspAssureSimple;
            caracteristiquePMECSP.code = 'ASSURE_CSP';
            offreValue1.caracteristiquePME.add(caracteristiquePMECSP);
            
            // CIVILITE
            gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element caracteristiquePMECivilite = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element();
            caracteristiquePMECivilite.valeur = civiliteAssureSimple;
            caracteristiquePMECivilite.code = 'ASSURE_CIV';
            offreValue1.caracteristiquePME.add(caracteristiquePMECivilite);
            
            propositionCommerciale.composantePropositionCommerciale.add(offreValue1);
            
            if('PREV_FACTC_P'.equals(idPack)){
                    // composantePropositionCommerciale
                gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element offreValue2 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element();
                offreValue2.offre = new gdfsuezComBefCalypsoPropositioncomm.offreDt();
                offreValue2.offre.idOffre = 'PREV_FACT2';

                offreValue2.dates = new gdfsuezComBefCalypsoPropositioncomm.datesDt[] {};
                gdfsuezComBefCalypsoPropositioncomm.datesDt debutCouple =  new gdfsuezComBefCalypsoPropositioncomm.datesDt();
                debutCouple.valeurDate = dateValueNow.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                debutCouple.motifDate = new gdfsuezComBefChpPivotPC.listeValeursDt();
                debutCouple.motifDate.categorie = 'motifDateComposantePropal';
                debutCouple.motifDate.code = 'dateRendezVousDu';
                offreValue2.dates.add(debutCouple);

                gdfsuezComBefCalypsoPropositioncomm.datesDt finCouple =  new gdfsuezComBefCalypsoPropositioncomm.datesDt();
                finCouple.valeurDate = dateValueNow.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                finCouple.motifDate = new gdfsuezComBefChpPivotPC.listeValeursDt();
                finCouple.motifDate.categorie = 'motifDateComposantePropal';
                finCouple.motifDate.code = 'dateRendezVousAu';
                offreValue2.dates.add(finCouple);
                offreValue2.caracteristiquePME = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element[] {};
                
                String civiliteAssureCouple = (String)inputMap.get('AssuranceCoupleCivilite');
                String prenomAssureCouple = (String)inputMap.get('AssuranceCouplePrenom');
                String nomAssureCouple = (String)inputMap.get('AssuranceCoupleNom');
                String dateNaissanceAssureCouple = (String)inputMap.get('AssuranceCoupleDateN');
                String cspAssureCouple = (String)inputMap.get('AssuranceCoupleCSP');
                
                if(String.isBlank(civiliteAssureCouple) || String.isBlank(prenomAssureCouple) || String.isBlank(nomAssureCouple) || String.isBlank(dateNaissanceAssureCouple) || String.isBlank(cspAssureCouple)){
                    system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposalSA :  Abscence des inforamtions de l\'assure ');
                    outputMap.put('errorLibelle', 'Creation PC Service Affinitaire KO : Abscence des inforamtions de des assures');
                    throw new IOException('Creation PC Service Affinitaire KO : Abscence des inforamtions des assures');
                }
                    
                    
                // NOM
                gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element caracteristiquePMENomCouple = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element();
                caracteristiquePMENomCouple.valeur = nomAssureCouple;
                caracteristiquePMENomCouple.code = 'ASSURE_NOM';
                offreValue2.caracteristiquePME.add(caracteristiquePMENomCouple);
                
                // PRENOM
                gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element caracteristiquePMEPrenomCouple = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element();
                caracteristiquePMEPrenomCouple.valeur = prenomAssureCouple;
                caracteristiquePMEPrenomCouple.code = 'ASSURE_PRENOM';
                offreValue2.caracteristiquePME.add(caracteristiquePMEPrenomCouple);
                
                // DATE NAISSANCE
                gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element caracteristiquePMEDateNaissanceCouple = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element();
                caracteristiquePMEDateNaissanceCouple.valeur = dateNaissanceAssureCouple;
                caracteristiquePMEDateNaissanceCouple.code = 'ASSURE_DATE_NAIS';
                offreValue2.caracteristiquePME.add(caracteristiquePMEDateNaissanceCouple);
                
                // CATEGORIE SOCIO-PROFESSIONNELLE
                gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element caracteristiquePMECSPCouple = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element();
                caracteristiquePMECSPCouple.valeur = cspAssureCouple;
                caracteristiquePMECSPCouple.code = 'ASSURE_CSP';
                offreValue2.caracteristiquePME.add(caracteristiquePMECSPCouple);
                
                // CIVILITE
                gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element caracteristiquePMECiviliteCouple = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element();
                caracteristiquePMECiviliteCouple.valeur = civiliteAssureCouple;
                caracteristiquePMECiviliteCouple.code = 'ASSURE_CIV';
                offreValue2.caracteristiquePME.add(caracteristiquePMECiviliteCouple);
                

                propositionCommerciale.composantePropositionCommerciale.add(offreValue2);
            }

            propositionCommerciale.pack = new gdfsuezComBefCalypsoPropositioncomm.PackAbstract();
            propositionCommerciale.pack.idPack = idPack;
            propositionCommerciale.remiseOneShot = new gdfsuezComBefCalypsoPropositioncomm.RemiseOneShotDt[] {};
            gdfsuezComBefCalypsoPropositioncomm.RemiseOneShotDt ros = new gdfsuezComBefCalypsoPropositioncomm.RemiseOneShotDt();
            ros.montantHT = Integer.valueOf(0);
            propositionCommerciale.remiseOneShot.add(ros);
            propositionCommerciale.local = new gdfsuezComBefCalypsoPropositioncomm.LocalAbstract();
            propositionCommerciale.local.idLocal = idLocal;

            propositionCommerciale.refPersonne = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_refPersonne_element[] {};
            gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_refPersonne_element personne = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_refPersonne_element();
            personne.personne = new gdfsuezComBefCalypsoPersonne.PersonneAbstract();
            personne.personne.idPersonne = identifiantCollab;
            gdfsuezComBefChpPivotPC.listeValeursDt role = new gdfsuezComBefChpPivotPC.listeValeursDt();
            role.categorie = 'rolePersonneVente';
            role.code = 'collaborateurResponsable';
            personne.rolePersonne = role;
            propositionCommerciale.refPersonne.add(personne);
            gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_refPersonne_element personne1 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_refPersonne_element();
            personne1.personne = new gdfsuezComBefCalypsoPersonne.PersonneAbstract();
            personne1.personne.idPersonne = identifiantCollab;
            gdfsuezComBefChpPivotPC.listeValeursDt role1 = new gdfsuezComBefChpPivotPC.listeValeursDt();
            role1.categorie = 'rolePersonneVente';
            role1.code = 'conseillerOrigineCreation';
            personne1.rolePersonne = role1;
            propositionCommerciale.refPersonne.add(personne1);
            //BP à récupérer et identifiant collaborateur
            gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_refPersonne_element personne2 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_refPersonne_element();
            personne2.personne = new gdfsuezComBefCalypsoPersonne.PersonneAbstract();
            personne2.personne.idPersonne = idBP;
            gdfsuezComBefChpPivotPC.listeValeursDt role2 = new gdfsuezComBefChpPivotPC.listeValeursDt();
            role2.categorie = 'rolePersonneVente';
            role2.code = 'contractant';
            personne2.rolePersonne = role2;
            propositionCommerciale.refPersonne.add(personne2);

            gdfsuezComBefCalypsoPropositioncomm.datesDt datePCValue = new gdfsuezComBefCalypsoPropositioncomm.datesDt();
            datePCValue.valeurDate =  datePC.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
            datePCValue.motifDate = new gdfsuezComBefChpPivotPC.listeValeursDt();
            datePCValue.motifDate.categorie = 'motifDate';
            datePCValue.motifDate.code = 'dateCreation';

            gdfsuezComBefCalypsoPropositioncomm.datesDt datePCValue1 = new gdfsuezComBefCalypsoPropositioncomm.datesDt();
            /*datePCValue1.valeurDate = effectiveDate.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');*/
            datePCValue1.valeurDate = effectiveDate;
            /*datePCValue1.valeurDate = datePC.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');*/
            datePCValue1.motifDate = new gdfsuezComBefChpPivotPC.listeValeursDt();
            datePCValue1.motifDate.categorie = 'motifDate';
            datePCValue1.motifDate.code = 'dateEffetContractuel';

            propositionCommerciale.datesPropositionCommerciale = new gdfsuezComBefCalypsoPropositioncomm.datesDt[] {};
            propositionCommerciale.datesPropositionCommerciale.add(datePCValue);
            propositionCommerciale.datesPropositionCommerciale.add(datePCValue1);
            //code campagne
            /*if (!String.isBlank(codeCampagne)) {
                propositionCommerciale.codeCampagne = codeCampagne;
            }*/
            propositionCommerciale.description = 'Creation de la PC Service Affinitaire SMILE';

            gdfsuezBefCalypsoPropositioncommerc.creerPropositionCommercialeInputDt input = new gdfsuezBefCalypsoPropositioncommerc.creerPropositionCommercialeInputDt();
            input.propositionCommerciale = propositionCommerciale;

            gdfsuezBefCalypsoPropositioncommerc.creerPropositionCommercialeResponse_element response = new gdfsuezBefCalypsoPropositioncommerc.creerPropositionCommercialeResponse_element();
        if (!Test.isRunningTest()) {
            try {
                response = port.CreerPropositionCommerciale_Http(input, octx);
            } catch (Exception e) {
                System.debug(e);
                outputMap.put('errorLibelle', e);
                throw new IOException(e);
            }

        } else {
            Test.setMock(HttpCalloutMock.class, new SM_AP18_CreateCommercialProposalMock());
            gdfsuezBefCalypsoPropositioncommerc.Dependency porttest = new gdfsuezBefCalypsoPropositioncommerc.Dependency();
            system.debug('@@ start of mock');
            response = porttest.CreerPropositionCommerciale_Http(input, octx);

            system.debug('@@ end of mock');
        }
        System.debug('@response ==>' + response);
        if (response.creerPropositionCommercialeOutput != null && response.creerPropositionCommercialeOutput.propositionCommerciale != null && !String.isBlank(String.valueOf(response.creerPropositionCommercialeOutput.propositionCommerciale.idPropositionCommerciale))) {
            outputMap.put('idPCSA', response.creerPropositionCommercialeOutput.propositionCommerciale.idPropositionCommerciale);
            outputMap.put('errorLibelle', 'OK');
        } else {
            outputMap.put('errorCode', response.messageRetours.retourTraitementMessage[0].code);
            outputMap.put('errorLibelle', response.messageRetours.retourTraitementMessage[0].libelle);
            throw new IOException(response.messageRetours.retourTraitementMessage[0].libelle);
        }
        System.debug('outputMap:' + outputMap);
    }
    
    
    
    public class ContextModel {
        public String motifSouscriptionValue;
        public String motifSouscriptionLibelle;
        public String CTXT_SSCRPTN;

        public ContextModel(String motifSouscriptionValue, String motifSouscriptionLibelle, String CTXT_SSCRPTN) {
            this.motifSouscriptionValue = motifSouscriptionValue;
            this.motifSouscriptionLibelle = motifSouscriptionLibelle;
            this.CTXT_SSCRPTN = CTXT_SSCRPTN;
        }


    }
    
    public class CaracteristiquesOffreModel{
        public String codeCampagne;
        public String nbrExemplaire;
        public String canalEnvoiCPV;
        
        public CaracteristiquesOffreModel(String codeCampagne, String nbrExemplaire, String canalEnvoiCPV){
            this.codeCampagne = codeCampagne;
            this.nbrExemplaire = nbrExemplaire;
            this.canalEnvoiCPV = canalEnvoiCPV;
        }
        
    }
    
    public static CaracteristiquesOffreModel determineCaracteristiquesOffreModel(Map<String, Object> inputMap, Map<String, Object> outputMap){
        String codeCampagne;
        String nbrExemplaire;
        String canaEnvoiCPV;
        
        Map<String, Object> caracteristiquesOffre = (Map<String, Object>)inputMap.get('Recap');
        if (caracteristiquesOffre != null) {

            codeCampagne = (String) caracteristiquesOffre.get('CodeCampagne');
            if (codeCampagne == null) {
                system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposal:Pas de CodeCampagne:' + caracteristiquesOffre);
            }

            nbrExemplaire = (String) inputMap.get('NbrExemplaire');
            if (nbrExemplaire == null) {
                system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposal:Pas de nbrExemplaire:' + caracteristiquesOffre);
                outputMap.put('errorLibelle', 'Nombre d\'exemplaire non sélectionner');
                throw new IOException('Nombre d\'exemplaire non sélectionner');
            }

            canaEnvoiCPV = (String) caracteristiquesOffre.get('CanaEnvoiCPV');
            if (canaEnvoiCPV == null) {
                system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposal:Pas de nbrExemplaire:' + caracteristiquesOffre);
                outputMap.put('errorLibelle', 'Le canal d\'envoie pour la CPV n\'a pas été choisi');
                throw new IOException('Le canal d\'envoie pour la CPV n\'a pas été choisi');
            }
        }
        
        return new CaracteristiquesOffreModel(codeCampagne,nbrExemplaire,canaEnvoiCPV);
    
    }
    
    public static ContextModel determineContextModel(Map<String, Object> inputMap,String sellingOption){
    
        String motifSouscriptionValue;
        String motifSouscriptionLibelle;
        String CTXT_SSCRPTN;
        if (sellingOption == 'Emménagement') {
            //Cas Emménagement - voir US624 Contexte=EM
            motifSouscriptionValue = 'Z002';
            motifSouscriptionLibelle = 'Emménagement';
            CTXT_SSCRPTN = 'MES_EMM';
        }
        else if (sellingOption == 'Changement d\'Offre') {
            //Cas Changement d'Offre - voir US624 Contexte=CHO
            motifSouscriptionValue = 'Z008';
            motifSouscriptionLibelle = 'Changement d\'offre de marché';
            CTXT_SSCRPTN = 'CHGT_OFFR';
        }
        else if (sellingOption == 'Changement de fournisseur') {
            //Cas Changement de fournisseur - voir US624 Contexte=CHF

            CTXT_SSCRPTN = 'CHGT_FOURN';

            Map<String, Object> insideMap = (Map<String, Object>)inputMap.get('ChoixElements1');

            System.debug('SM_AP18_CreateCommercialProposal.createCommercialProposal:selectedPDLValFormula:' + insideMap.get('selectedPDLValFormula'));
            if ((insideMap.get('selectedPDLValFormula') == null || String.valueOf(insideMap.get('selectedPDLValFormula')).length() == 0) && (insideMap.get('selectedPCEValFormula') == null || String.valueOf(insideMap.get('selectedPCEValFormula')).length() == 0)) {
                system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposal:Pas de NumeroPointDeLivraison');
            }
            if (String.isNotBlank(String.valueOf(insideMap.get('selectedPDLValFormula'))) && String.isBlank(String.valueOf(insideMap.get('selectedPCEValFormula')))) {
                motifSouscriptionValue = 'Z003';
            }
            else if (String.isBlank(String.valueOf(insideMap.get('selectedPDLValFormula'))) && String.isNotBlank(String.valueOf(insideMap.get('selectedPCEValFormula')))) {
                motifSouscriptionValue = 'Z004';
            }
            else if (String.isNotBlank(String.valueOf(insideMap.get('selectedPDLValFormula'))) && String.isNotBlank(String.valueOf(insideMap.get('selectedPCEValFormula')))) {
                motifSouscriptionValue = 'Z005';
            }
        }
        return new ContextModel(motifSouscriptionValue,motifSouscriptionLibelle,CTXT_SSCRPTN);
    
    }
    
    public static String determineIdLocal(Map<String,Object> inputMap, Map<String,Object> outputMap){
        String idLocal;
        if(inputMap.get('numeroLocal') != null) {
            idLocal = String.valueOf(inputMap.get('numeroLocal'));
        }
        else {
            outputMap.put('errorLibelle', 'Le numéro local SAP est absent');
            throw new IOException('Le numéro local SAP est absent');
        }
        return idLocal;
    }
    
    public static String determineIdCompteClient(Map<String,Object> inputMap, Map<String,Object> outputMap){
        String idCompteClient;
        if (inputMap.get('idCompteClient') != null) {
            idCompteClient = String.valueOf(inputMap.get('idCompteClient'));
        } 
        else if (((Map<String, Object>)inputMap.get('ChoixElements')).get('FormulaNumCompteClientFrom360') != null) {
            idCompteClient = (String)((Map<String, Object>) inputMap.get('ChoixElements')).get('FormulaNumCompteClientFrom360');
        } 
        else {
            outputMap.put('errorLibelle', 'pas d\'id compte client');
            throw new IOException('pas d\'id compte client');
        }
        return idCompteClient;
    }
    
    public static String determineIdPack(Map<String,Object> inputMap){
        String idPack;
        
        String factureSimple = String.valueOf(inputMap.get('Asimple'));
        String factureCouple = String.valueOf(inputMap.get('Acouple'));
        
        if('Oui'.equals(factureSimple)){
            idPack = 'PREV_FACT_P';
        }
        else if('Oui'.equals(factureCouple)){
            idPack = 'PREV_FACTC_P';
        }
        
        return idPack;
    }
    
    private static String determineDateInUserTimeZone(String dateGmt){
        DateTime dt = (DateTime) JSON.deserialize('"' + dateGmt + '"', DateTime.class);
        return dt.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'',UserInfo.getTimeZone().getID());
    }
    
    
    
}