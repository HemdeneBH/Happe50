/*
*@author:MHA
*@Description: Appel du WS PropopositionCommerciale_v4
*@CreatedDate:05/09/2018
*/
global class SM_AP18_CreateCommercialProposal_Ref implements vlocity_cmt.VlocityOpenInterface {
    
    /*
*@author:MHA
*@Description: Appel du WS PropopositionCommerciale_v4
*@CreatedDate:05/09/2018
*@LastModified: 19/12/2018
*/
    

private static SM_WS_Suffix__mdt suffix_PropositionCommerciale_v5 = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'PropositionCommerciale_v5' limit 1];


    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        boolean returnValue = true;
        if (methodName.equals('createCommercialProposal')) {
            try {
                System.debug('inputss: '+inputMap);
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
                 system.debug('##error getStackTraceString ' +e.getStackTraceString());
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

        port.endpoint_x = octopusCS.endpoint__c + suffix_PropositionCommerciale_v5.suffix__c;

        port.inputHttpHeaders_x = new Map<String, String> {'Content-Type' => 'text/xml;charset=utf-8'};
            port.timeout_x = 120000;
        return port;
    }
    
    /*
*@author:MHA
*@Description: Appel du WS PropopositionCommerciale_v4
*@CreatedDate:05/09/2018
*@LastModified: OMH 03/09/2019
*/
    public static void createCommercialProposal(Map < String, Object > inputMap, Map < String, Object > outputMap, Map < String, Object > options) {
        String idBP = (String) inputMap.get('vRefClientIdBP');
        if (String.isBlank(idBP)) {
            outputMap.put('errorLibelle', 'Absence de la référence client');
            system.debug('outputMap:' + outputMap);
            if(!Test.isRunningTest()){
                throw new IOException('Absence de la référence client');
            }
            else{
                return;
            }
        }
        System.debug('@@ vChoixElement '+inputMap.get('vChoixElement'));
        System.debug('@@ inputMap '+inputMap.get('inputMap'));
        Datetime datePC = Datetime.now();
        String sellingOption;
        String effectiveDate;
        String effectiveDateGMT;
        String pcStatus;
        
        sellingOption = (String) inputMap.get('vChooseSellingOption');
        pcStatus =String.valueOf(inputMap.get('vNewPCStatus'));
        system.debug('pcStatus '+pcStatus );
        if (String.isBlank(sellingOption)) {                
            outputMap.put('errorLibelle', 'Absence du choix de l\'option de vente');
            if(!Test.isRunningTest()){
                throw new IOException('Absence du choix de l\'option de vente');
            }
            else{
                return;
            }
        }
        
        if (String.isBlank(pcStatus)) {                
            outputMap.put('errorLibelle', 'Absence du statut de la Proposition Commercial');
            if(!Test.isRunningTest()){
                throw new IOException('Absence du statut de la Proposition Commercial');
            }
            else{
                return;
            }
        }
        effectiveDateGMT = String.valueOf(inputMap.get('vEffectiveDate')); 
        if (String.isBlank(effectiveDateGMT)) {               
            outputMap.put('errorLibelle', 'Absence de la date effective de vente');
            if(!Test.isRunningTest()){
                throw new IOException('Absence de la date effective de vente');
            }
            else{
                return;
            }
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
            if(pcStatus == 'dejaAccept'){
                nbrExemplaire = '0';
            }else if(pcStatus == 'Accept'){
                nbrExemplaire = '1';
            }else if(pcStatus == 'Reflechis'){
                nbrExemplaire = '2';
            }
        }
        
        else if (sellingOption == 'Changement de fournisseur') {
            
            //Cas Changement de fournisseur - voir US624 Contexte=CHF
            
            if(pcStatus == 'dejaAccept'){
                nbrExemplaire = '0'; 
            } else {
                nbrExemplaire = '2'; 
            }
            
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
        
        
        String idLocal=String.valueOf(inputMap.get('vNumeroLocal'));
        //  String idLocal = '0707498179';
        system.debug('@@ idLocal ' +idLocal);
        if(String.isBlank(idLocal)) {
            outputMap.put('errorLibelle', 'Le numéro local SAP est absent');
            if(!Test.isRunningTest()){
                throw new IOException('Le numéro local SAP est absent');
            }
            else{
                return;
            }
        }
        
        String vIdCompteClient=String.valueOf(inputMap.get('vIdCompteClientNvxLogement'));
        if(String.isBlank(vIdCompteClient)){
            vIdCompteClient=String.valueOf(inputMap.get('vIdCompteClientSouscrire'));
        }
        String idCompteClient=vIdCompteClient;
        system.debug('@@ idCompteClient ' +idCompteClient);
        if(String.isBlank(idCompteClient)){
            outputMap.put('errorLibelle', 'pas d\'id compte client');
            if(!Test.isRunningTest()){
                throw new IOException('pas d\'id compte client');
            }
            else{
                return;
            }
        }    
        
        String codeCampagne;
        
        String canaEnvoiCPV;
        String codePromo; /*OMH: SMIL-2900 */
        
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
            outputMap.put('errorLibelle', 'Le canal d\'envoi pour la CPV n\'a pas été choisi');
            if(!Test.isRunningTest()){
                throw new IOException('Le canal d\'envoi pour la CPV n\'a pas été choisi');
            }
            else{
                return;
            }
        }
        codePromo = (String) inputMap.get('vCodePromo');
        if (String.isBlank(codePromo)) {
            system.debug('@@ SM_AP18_CreateCommercialProposal.createCommercialProposal:Pas de codePromo:');
        }     
        
        
        Map<String, Object> prelevementBlock;
        Map<String, Object> mensualisationBlock;
        Map<String, Object> factureEnLigneBlock;
        String responsePrelevement;//prelevementBlock
        String mensualisation;//mensualisationBlock
        String valueMensualisation = '12';
        String libelleMensualisation = 'Annuel';
        String factureEnLigne;
        String eDocument;
        String mensualisationValue;
        String factureEnLigneValue;
        String drpInputValue;
        String jourSouhaiteInputValue;
        String drpValue;
        String jourSouhaite;
        
        // récupérer le statut de l'edocument --> FT1-3922  : IBRAHIM MERABTI modified 04/08/2020
        eDocument = (String)inputMap.get('vEdocument');
            
        Map<String, Object> drpBlock;
        Map<String, Object> servicesGestion = (Map<String, Object>)inputMap.get('vServicesGestion');
        //   if (servicesGestion != null) {
        //  if (servicesGestion.get('PrelevementBlock') !=  null) {
        //    prelevementBlock = (Map<String, Object>)servicesGestion.get('PrelevementBlock');
        Boolean isNonPreleve = inputMap.get('vIsNonPrelevee') != null ? Boolean.valueOf(inputMap.get('vIsNonPrelevee')) : false;
        Boolean isPreleve = inputMap.get('visPrelevee') != null ? Boolean.valueOf(inputMap.get('visPrelevee')) : false;
        if(sellingOption == 'Changement d\'Offre'){
            if(isNonPreleve){
                responsePrelevement = String.valueOf(inputMap.get('Prelevement'));
            }
            if(isPreleve){
                responsePrelevement = 'Oui';
            }

        }else{
        
System.debug('Prelevement :'+ inputMap.get('Prelevement'));        
        if (inputMap.get('Prelevement') != null) {
            responsePrelevement = String.valueOf(inputMap.get('Prelevement'));
        }
        else {
            outputMap.put('errorLibelle', 'Veuillez remplir par Oui ou Non dans le choix de prélèvement');
            if(!Test.isRunningTest()){
                throw new IOException('Veuillez remplir par Oui ou Non dans le choix de prélèvement');
            }
            else{
                return;
            }
            
        }
        }   
        //  }
        
        //  mensualisationBlock = (Map<String, Object>)servicesGestion.get('MensualisationBlock');
        mensualisationValue = String.valueOf(inputMap.get('vMens'));
        Boolean isMensualise = inputMap.get('vIsMensualise') != null ? Boolean.valueOf(inputMap.get('vIsMensualise')) : false;
        
         if (String.isBlank(mensualisationValue)) {
            mensualisation = 'non';
        } 
        else {
            mensualisation = mensualisationValue.toLowerCase();
        }
        
        if (sellingOption == 'Changement d\'Offre') {
           if(isMensualise){
                mensualisation = 'oui';
               responsePrelevement = 'Oui';
            }
            
           
        }
        


        if (mensualisation != 'oui') {
            valueMensualisation = '6';
            libelleMensualisation  = 'Bi Annuel';
        }
        
        // factureEnLigneBlock = (Map<String, Object>)servicesGestion.get('FactureEnLigneBlock');
        factureEnLigneValue = String.valueOf(inputMap.get('vFEL'));
        if (String.isBlank(factureEnLigneValue)) {              
            factureEnLigne = 'non';
        }
        else {
            factureEnLigne = factureEnLigneValue;               
        }
        
        /*   drpBlock = (Map<String, Object>)inputMap.get('DRP');
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
}*/
        drpInputValue = String.ValueOf(inputMap.get('RadioDRP'));
        jourSouhaiteInputValue = String.ValueOf(inputMap.get('SelectJourSouhaite'));
        
        if (sellingOption == 'Changement d\'Offre') {

            if(jourSouhaiteInputValue != null && jourSouhaiteInputValue != ''){
                drpValue = 'Oui';
                jourSouhaite = jourSouhaiteInputValue;
            }
            else{
                drpValue = 'non'; 
            }


        }
        else{   
        
        if(String.isBlank(drpInputValue)){
           // system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposal:Pas de drpBlock:' + drpBlock);
            drpValue = 'non';
        }
        else{
            drpValue = drpInputValue; 
            jourSouhaite = jourSouhaiteInputValue;
        }
        }
        
        
        System.debug('### aka drpValue ' + drpValue);
         System.debug('### aka jourSouhaite ' + jourSouhaite);
        //  }
        
        //Map<String, Object> offre = (Map<String, Object>)inputMap.get('OffreChoisis');
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
        
        
        if (String.isBlank(mensGlobal) || sellingOption == 'Changement d\'Offre') {          
            mensGlobal = String.valueOf(inputMap.get('vMensTotal'));
        }
        
        List<String> idOffreList = new List<String>();
        if(!String.isBlank(String.valueof(inputMap.get('vIdOffreList')))){
        for (Object idOffer : (List<Object>)inputMap.get('vIdOffreList')) {
            idOffreList.add(String.valueOf(idOffer));
        }
    }
    String CAE=String.valueOf(inputMap.get('vCAE'));

        if(idOffreList.isEmpty()){
        // pour harmonica , on charge la liste des offre depuis les informations de moveIn data transmises
        String context =  String.valueof(inputMap.get('vContext'));
        String codeOffreElec =  String.valueof(inputMap.get('vCodeOffreElec'));
        String codeOffreGaz =   String.valueof(inputMap.get('vCodeOffreGaz'));
        String energyType = String.valueof(inputMap.get('vEnergyTypeOptions'));

        if(context == 'harmonica' && energyType == 'Duo') {
            idOffreList.add(codeOffreGaz);
            idOffreList.add(codeOffreElec);
        }else if(context == 'harmonica' && energyType == 'Elec'){
            idOffreList.add(codeOffreElec);
        }else if(context == 'harmonica' && energyType == 'Gaz'){
            idOffreList.add(codeOffreGaz);
        }
        system.debug('### idoffrelist '+idOffreList);

            if(CAE == null || CAE == ''){
                CAE = '1000';
            }
        }
        String typeComptage=String.valueOf(inputMap.get('vCodeTypeComptage'));
        
        String puissanceSouscrite=String.valueOf(inputMap.get('vPuissanceSouscriteValeur')) ;
        if(puissanceSouscrite.contains('KVA')){
            puissanceSouscrite = puissanceSouscrite.substring(0, puissanceSouscrite.indexOf('KVA'));
        }
        String CAR=String.valueOf(inputMap.get('vCAR'));
       
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
        // Modifié dans le cadr de l'US FT1-1022 Par MERABTI IBRAHIM --> Modifié le 12/03/2020
        String typeEnseigne = String.valueOf(inputMap.get('vTypeEnseigne'));
        String typeEnseigneLibelle =  String.valueOf(inputMap.get('vLibelleTypeEnseigne'));
        String enseigne = String.valueOf(inputMap.get('vEnseigne'));        
        
        if (sellingOption == 'Changement d\'Offre') {
            //Cas Changement d'Offre - voir US624 Contexte=CHO
            
            motifSouscriptionValue = 'Z008';
            motifSouscriptionLibelle = 'Changement d\'offre de marché';
            
           
            CTXT_SSCRPTN = 'CHGT_OFFR';
            nbrExemplaire = '2';


        }
        outputMap.put('nbrExemplaire',nbrExemplaire);
        system.debug('@@ nb exemplaire setté dans le output ' + nbrExemplaire);
        
        
        gdfsuezComBefChpPivotPC.contextDt octx = initContext('Smile', '5');
        gdfsuezBefCalypsoPropositioncommerc.Dependency port= initPort();
        
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
        //canal envoi
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
        if (valueMensualisation == '12') {
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
        // retrait condition prelevement FT1-4049
        if (factureEnLigne == 'Oui' /*&& responsePrelevement == 'Oui'*/) {
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
        // retrait condition prelevement FT1-4049
        if (factureEnLigne == 'Oui' /*&& responsePrelevement == 'Oui'*/) {
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
        
        // Créer une composante commerciale pour l'acivation de l'E-Document  --> FT1-3922  : IBRAHIM MERABTI modified 04/08/2020
        if (eDocument == 'Oui') {
            gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element offreValue6 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element();
            offreValue6.offre = new gdfsuezComBefCalypsoPropositioncomm.offreDt();
            offreValue6.offre.idOffre = 'DOC_CONTRACT';
            
            offreValue6.dates = new gdfsuezComBefCalypsoPropositioncomm.datesDt[] {};
            gdfsuezComBefCalypsoPropositioncomm.datesDt debut6 =  new gdfsuezComBefCalypsoPropositioncomm.datesDt();
            debut6.valeurDate = formattedDateValueNow;
            debut6.motifDate = new gdfsuezComBefChpPivotPC.listeValeursDt();
            debut6.motifDate.categorie = 'motifDateComposantePropal';
            debut6.motifDate.code = 'dateRendezVousDu';
            offreValue6.dates.add(debut6);
            
            gdfsuezComBefCalypsoPropositioncomm.datesDt fin6 =  new gdfsuezComBefCalypsoPropositioncomm.datesDt();
            fin6.valeurDate =formattedDateValueNow;
            fin6.motifDate = new gdfsuezComBefChpPivotPC.listeValeursDt();
            fin6.motifDate.categorie = 'motifDateComposantePropal';
            fin6.motifDate.code = 'dateRendezVousAu';
            offreValue6.dates.add(fin6);
            
            propositionCommerciale.composantePropositionCommerciale.add(offreValue6);
        }
        
        // Composantes pour les options vertes
        if (sellingOption == 'Emménagement' || sellingOption == 'Changement de fournisseur') {
            
            // Récupération du paramètre indiquant un KO ou non sur la création PDLS
            Boolean koCreationPDLSOpvt = inputMap.get('koCreationPDLSOpvt') != null && inputMap.get('koCreationPDLSOpvt') != '' && inputMap.get('koCreationPDLSOpvt') != ' ' ? Boolean.valueOf(inputMap.get('koCreationPDLSOpvt')) : null;
            
            // Composante de la proposition commerciale : Option Verte Elec Vert+
            String elecOptionChoice = inputMap.get('elecOptionChoice') != null && inputMap.get('elecOptionChoice') != '' && inputMap.get('elecOptionChoice') != ' ' ? String.valueOf(inputMap.get('elecOptionChoice')) : null;
            if (elecOptionChoice == 'Y' && koCreationPDLSOpvt == false) {
                
                gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element offreValue7 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element();
                offreValue7.offre = new gdfsuezComBefCalypsoPropositioncomm.offreDt();
                offreValue7.offre.idOffre = 'EFOPT_VERT';
                
                offreValue7.caracteristiquePME = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element[] {};
                    gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element caracteristiquePME_element = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element();
                caracteristiquePME_element.valeur = '100'; // à tester en integer
                caracteristiquePME_element.code = 'POURCENT_VERT';
                offreValue7.caracteristiquePME.add(caracteristiquePME_element);
                
                propositionCommerciale.composantePropositionCommerciale.add(offreValue7);
            }
            
            // Composante de la proposition commerciale : Option Verte Gaz Vert+
            String gasOptionChoice = inputMap.get('gasOptionChoice') != null && inputMap.get('gasOptionChoice') != '' && inputMap.get('gasOptionChoice') != ' ' ? String.valueOf(inputMap.get('gasOptionChoice')) : null;
            Integer gasOptionRange = inputMap.get('gasOptionRange') != null && inputMap.get('gasOptionRange') != '' && inputMap.get('gasOptionRange') != ' ' ? Integer.valueOf(inputMap.get('gasOptionRange')) : null;
            if (gasOptionChoice == 'Y' && koCreationPDLSOpvt == false) {
                
                gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element offreValue8 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element();
                offreValue8.offre = new gdfsuezComBefCalypsoPropositioncomm.offreDt();
                offreValue8.offre.idOffre = 'GOPT_VERT';
                
                offreValue8.caracteristiquePME = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element[] {};
                    gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element caracteristiquePME_element = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element();
                caracteristiquePME_element.valeur = String.valueOf(gasOptionRange);
                caracteristiquePME_element.code = 'POURCENT_VERT';
                offreValue8.caracteristiquePME.add(caracteristiquePME_element);
                
                propositionCommerciale.composantePropositionCommerciale.add(offreValue8);
            }
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
        if (!String.isBlank(codePromo)) {
            propositionCommerciale.codePromo = codePromo;
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
                // throw new IOException(e);
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
            if (sellingOption == 'Changement d\'Offre' && pcStatus == 'Refuse'){
                String reponseCode = majStatusCommercialProposal(response.creerPropositionCommercialeOutput.propositionCommerciale.idPropositionCommerciale,'E0007','Refusée');
                if ('OCTOPUS_MAJPropositionCommerciale_01'.equals(reponseCode) || 'OCTOPUS_creerPropositionCommerciale_16'.equals(reponseCode)) {
                    outputMap.put('retourMAJPC', 'OK');
                }
                else{
                    outputMap.put('retourMAJPC', 'KO');
                }
            
            }
        
        } 
        
        else {
            outputMap.put('errorCode', response.messageRetours.retourTraitementMessage[0].code);
            outputMap.put('errorLibelle', response.messageRetours.retourTraitementMessage[0].libelle);
            throw new IOException(response.messageRetours.retourTraitementMessage[0].libelle);
        }
        //System.debug('outputMap:' + outputMap);
        
    }
    
    
    
    
    /*
*@author:MHA
*@Description: transformation de la PC dans le cas où le nombre d'exemplaire est égal à 1 et que l'order est créée
*@CreatedDate:05/09/2018
*@LastModified:14/03/2018
*/
    
    public static void transformCommercialProposal(Map < String, Object > inputMap, Map < String, Object > outputMap, Map < String, Object > options) {
        
        String vIdPropositionCommerciale = String.valueOf(inputMap.get('vIdPropositionCommerciale'));
        if (String.isBlank(vIdPropositionCommerciale)) {
            system.debug('inputs' + inputMap);
            outputMap.put('errorLibelle', 'l\'idPropositionCommerciale est manquant');
            throw new IOException('L\'id de la proposition Commerciale est manquant');
            
        }
        
        gdfsuezComBefChpPivotPC.contextDt octx = initContext('Smile', '5');
        gdfsuezBefCalypsoPropositioncommerc.Dependency port= initPort();
        
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
                }
            }
            
        }
        if(response!=null 
           &&  response.transformerPropositionCommercialeOutput!=null 
           &&  response.transformerPropositionCommercialeOutput.objetsCrees!=null ){
               if(response.transformerPropositionCommercialeOutput.objetsCrees.contrat!=null 
                  && !response.transformerPropositionCommercialeOutput.objetsCrees.contrat.isEmpty()){
                      
                      // Récupération de l'identifiant contrat dans le cas d'un type de contrat Energie
                      for(gdfsuezBefCalypsoPropositioncommerc.ContratTransformeDt contrat : response.transformerPropositionCommercialeOutput.objetsCrees.contrat){
                          
                          if(contrat.typeContrat == 'Energie'){
                              outputMap.put( 'idContrat', contrat.idContrat); 
                          }
                          
                          System.debug('idContrat : ' + contrat.idContrat);
                          System.debug('typeContrat : ' + contrat.typeContrat);
                      }
                      
                      outputMap.put( 'errorLibelleTransform', 'OK');   
                      
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

        
        gdfsuezComBefChpPivotPC.contextDt octx = initContext('Smile', '5');
        gdfsuezBefCalypsoPropositioncommerc.Dependency port = initPort();

        
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
*@LastModified:01/09/2020 by RJM
*/
    public static void transformerPCDeuxExemplaires(Map < String, Object > inputMap, Map < String, Object > outputMap, Map < String, Object > options) {
        
        String idPropositionCommerciale = (String)inputMap.get('vIdPropositionCommerciale');
        if (idPropositionCommerciale == null) {
            system.debug('No idPropositionCommerciale found');
            system.debug('inputs' + inputMap);
            return;
        }
        
        //
        String pcTransfoStatus = (String)inputMap.get('vPCTransfoStatus');
        System.debug('pcTransfoStatus :'+ pcTransfoStatus);
        String codeStatus = '';
        String labelStatus = '';
        if(pcTransfoStatus != null && pcTransfoStatus != ''){
            if (pcTransfoStatus == 'Accept'){
            codeStatus = System.Label.SM_CL32_PC_Status_Code_AcceptedWithSignature;
            labelStatus = System.Label.SM_CL33_PC_Status_Label_AcceptedWithSignature;
            }
            else if(pcTransfoStatus == 'Refuse'){
            codeStatus = System.Label.SM_CL42_PC_Status_Code_Refused;  
            labelStatus = System.Label.SM_CL43_PC_Status_Label_Refused;
            }
            
        //Mettre à jour la PC en mettant le bon statut dans SAP
        String reponseCode = majStatusCommercialProposal(idPropositionCommerciale, codeStatus, labelStatus);
        
        //Appel du service TransformerPC si la MAJ ets réussie
            if ('OCTOPUS_MAJPropositionCommerciale_01'.equals(reponseCode) && pcTransfoStatus == 'Accept') {
            transformCommercialProposal(inputMap, outputMap, options);
            
            // Si la Transformation PC est réussie, on modifie le statut de l'Order
            if (!String.isBlank(String.valueOf(outputMap.get('idContrat')))) {
                majOrderStatus(inputMap);
            }
        }

        outputMap.put('retourMAJPCTransf' , reponseCode);
            outputMap.put('pcTransfoStatus' , pcTransfoStatus);
            System.debug('retourMAJPCTransf :' + reponseCode);
            System.debug('pcTransfoStatus :' + pcTransfoStatus);
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
*@Description: Appel du WS PropopositionCommerciale_v4 pour les services affinitaires
*@CreatedDate: 18/04/2018
*/
public static void createCommercialProposalSA(Map < String, Object > inputMap, Map < String, Object > outputMap, Map < String, Object > options) {
    string jsonstring = JSON.serialize(inputMap);        
    String idBP = (String) inputMap.get('vRefClientIdBP');
    
      CaracteristiquesOffreModel caracteristiquesOffreModel = determineCaracteristiquesOffreModel(inputMap,outputMap);
    String codeCampagne = caracteristiquesOffreModel.codeCampagne;
    String nbrExemplaire = caracteristiquesOffreModel.nbrExemplaire;
    String canaEnvoiCPV = caracteristiquesOffreModel.canalEnvoiCPV;
    
     outputMap.put('nbrExemplaire', nbrExemplaire);
    
    // ADD CONDITION %typeOffreASouscrire% = "GAZ" && (%clientChoice%="Accept" ||  %clientChoice%="Reflechis")
    if (String.isBlank(idBP)) {
        //idBP est null
        system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposalSA: refClientIdBP est null:'+ inputMap);
        outputMap.put('errorLibelle', 'Absence de la référence client');
        system.debug('outputMap:' + outputMap);
        throw new IOException('Absence de la référence client');
    }
    
    Datetime datePC = Datetime.now();
    
    String sellingOption;
    String effectiveDate;
    String effectiveDateGMT;
    sellingOption = (String) inputMap.get('vChooseSellingOption');
    if (String.isBlank(sellingOption)) {
        system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposalSA:pas de chooseSellingOption:' + sellingOption);
        outputMap.put('errorLibelle', 'Absence du choix de l\'option de vente');
        throw new IOException('Absence du choix de l\'option de vente');
    }
    
    effectiveDateGMT = String.valueOf(inputMap.get('vEffectiveDate'));
    System.debug(effectiveDateGMT);
    if (String.isBlank(effectiveDateGMT)) {
        system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposalSA:pas de effectiveDate;vEffectiveDate:' + effectiveDateGMT);
        outputMap.put('errorLibelle', 'Absence de la date effective de vente');
        throw new IOException('Absence de la date effective de vente');
    }
    effectiveDate = determineDateInUserTimeZone(effectiveDateGMT);
    
    
    ContextModel contextModel = determineContextModel(inputMap,sellingOption);
    String motifSouscriptionValue = contextModel.motifSouscriptionValue;
    String motifSouscriptionLibelle = contextModel.motifSouscriptionLibelle;
    String CTXT_SSCRPTN = contextModel.CTXT_SSCRPTN;
    
    
    String idLocal = determineIdLocal(inputMap,outputMap);
    
    
    String idCompteClient = determineIdCompteClient(inputMap,outputMap);
    
    
  
    
    Map<String, Object> mensualisationBlock;
    
    String mensualisation;
    String valueMensualisation = '12';
    String libelleMensualisation = 'Annuel';
    
    /*  mensualisationBlock = (Map<String, Object>)inputMap.get('vMens');
if (mensualisationBlock == null) {
system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposal:Pas de MensualisationBlock:' + mensualisationBlock);
mensualisation = 'non';
} 
else {*/
    
    mensualisation = String.valueOf(inputMap.get('Mensualisation'));
    // mensualisation = mensualisation.;
    if (String.isBlank(mensualisation)) {
        system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposal:Pas de MensualisationBlock:' + mensualisationBlock);
        //Traitement à confirmer
    }
    //   }
    else if ('non'.equalsIgnoreCase(mensualisation)) {
        valueMensualisation = '6';
        libelleMensualisation  = 'Bi Annuel';
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
    // Modifié dans le cadre de l'US FT1-1022 par MERABTI  IBRAHIM --> Modifié le 13/03/2020
    String typeEnseigne = String.valueOf(inputMap.get('vTypeEnseigne'));
    String typeEnseigneLibelle =  String.valueOf(inputMap.get('vLibelleTypeEnseigne'));
    String enseigne = String.valueOf(inputMap.get('vEnseigne'));
    
    String civiliteAssureSimple = (String)inputMap.get('vAssuranceSimpleCivilite');
    String prenomAssureSimple = (String)inputMap.get('vAssuranceSimplePrenom');
    String nomAssureSimple = (String)inputMap.get('vAssuranceSimpleNom');
    String dateNaissanceAssureSimple = (String)inputMap.get('vAssuranceSimpleDateN');
    String day = dateNaissanceAssureSimple.substring(8, 10);
    String month = dateNaissanceAssureSimple.substring(5, 7);
    String year = dateNaissanceAssureSimple.substring(0, 4);
    dateNaissanceAssureSimple = day + '/' + month + '/' + year;
    String cspAssureSimple = (String)inputMap.get('vAssuranceSimpleCSP');
    
    if(String.isBlank(civiliteAssureSimple) || String.isBlank(prenomAssureSimple) || String.isBlank(nomAssureSimple) || String.isBlank(dateNaissanceAssureSimple) || String.isBlank(cspAssureSimple)){
        system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposalSA :  Abscence des inforamtions de l\'assure ');
        outputMap.put('errorLibelle', 'Abscence des informations de l\'assure');
        throw new IOException('Creation PC Service Affinitaire KO : Abscence des inforamtions de l\'assure');
    }
    

    gdfsuezComBefChpPivotPC.contextDt octx = initContext('Smile', '5');
    gdfsuezBefCalypsoPropositioncommerc.Dependency port = initPort();

    
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
    //canal envoi
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
            
            String civiliteAssureCouple = (String)inputMap.get('vAssuranceCoupleCivilite');
        String prenomAssureCouple = (String)inputMap.get('vAssuranceCouplePrenom');
        String nomAssureCouple = (String)inputMap.get('vAssuranceCoupleNom');
        String dateNaissanceAssureCouple = (String)inputMap.get('vAssuranceCoupleDateN');
        String cspAssureCouple = (String)inputMap.get('vAssuranceCoupleCSP');
        
        if(String.isBlank(civiliteAssureCouple) || String.isBlank(prenomAssureCouple) || String.isBlank(nomAssureCouple) || String.isBlank(dateNaissanceAssureCouple) || String.isBlank(cspAssureCouple)){
            system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposalSA :  Abscence des inforamtions de l\'assure ');
            outputMap.put('errorLibelle', 'Abscence des informations de des assures');
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
    personne1.personne.idPersonne = '';
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
            outputMap.put('errorLibelle', e.getMessage());
            throw new IOException(e);
        }
        
    } else {
        Test.setMock(HttpCalloutMock.class, new SM_AP18_CreateCommercialProposalMock());
        gdfsuezBefCalypsoPropositioncommerc.Dependency porttest = new gdfsuezBefCalypsoPropositioncommerc.Dependency();
        system.debug('@@ start of mock');
        response = porttest.CreerPropositionCommerciale_Http(input, octx);
        
        system.debug('@@ end of mock ');
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
        String nbrExemplaire;
        String codeCampagne = String.valueOf(inputMap.get('vCodeCampagne'));
        String canaEnvoiCPV = String.valueOF(inputMap.get('vCanaEnvoiCPV'));
        String choixAssuranceFacture = String.valueOf(inputMap.get('vChoixAssuranceFacture'));
        String chooseSellingOption = String.valueOf(inputMap.get('vChooseSellingOption'));
        String contratActif = String.valueOf(inputMap.get('vcontratActif'));
        String clientChoice = String.valueOf(inputMap.get('vClientChoice'));
        
        if (String.isBlank(codeCampagne)) {
            system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposal:Pas de CodeCampagne:' + codeCampagne);
        }
        
        if (String.isBlank(canaEnvoiCPV)) {
            system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposal:Pas de nbrExemplaire:' + canaEnvoiCPV);
            outputMap.put('errorLibelle', 'Le canal d\'envoi pour la CPV n\'a pas été choisi');
            throw new IOException('Le canal d\'envoi pour la CPV n\'a pas été choisi');
        }
        
        /*if (String.isBlank(clientChoice) && chooseSellingOption != 'Changement d\'Offre' ) {
            system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposal:Pas de nbrExemplaire:' + clientChoice);
            outputMap.put('errorLibelle', 'Nombre d\'exemplaire non sélectionné');
            throw new IOException('Nombre d\'exemplaire non sélectionné');
        }*/
        else{
            // FT1-3583
            // FT1-3623
            if(!String.isBlank(choixAssuranceFacture)){
               // Si pour AF : Accepte et Energie : Accepte --> 1 ex
                // Si pour AF : Accepte et Energie : Souhaite Réfléchir --> vérifier contrat actif : si oui --> 1ex sinon --> 2ex
                if(chooseSellingOption == 'Changement d\'Offre'){
                    if(choixAssuranceFacture == 'Y'){
                        nbrExemplaire = '1';
                    }
                    else{
                        nbrExemplaire = '2';
                    }
                }
                else{
                if(choixAssuranceFacture == 'Y'
                   && (clientChoice == 'Accept'
                   || (contratActif == 'Y' && clientChoice == 'Reflechis'))){
                       nbrExemplaire = '1';
                   }
                else{
                    nbrExemplaire = '2';
                }
            }
        }
            // FT1-3583
            // FT1-3623
            else {
                if(clientChoice == 'Accepte'){
                    nbrExemplaire = '1';
                }
                else{
                    nbrExemplaire = '2';
                }
            }
        }
        
        
        return new CaracteristiquesOffreModel(codeCampagne,nbrExemplaire,canaEnvoiCPV);
        
    }
    
        public static ContextModel determineContextModel(Map<String, Object> inputMap,String sellingOption){
            
            String motifSouscriptionValue;
            String motifSouscriptionLibelle;
            String CTXT_SSCRPTN;
            if (sellingOption == 'Emménagement' || sellingOption == 'Services Payants') {
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
                
                System.debug('SM_AP18_CreateCommercialProposal.createCommercialProposal:selectedPDLValFormula:' + inputMap.get('vSelectedPDLValFormula'));
                if ((inputMap.get('vSelectedPDLValFormula') == null || String.valueOf(inputMap.get('vSelectedPDLValFormula')).length() == 0) && (inputMap.get('vSelectedPCEValFormula') == null || String.valueOf(inputMap.get('selectedPCEValFormula')).length() == 0)) {
                    system.debug('SM_AP18_CreateCommercialProposal.createCommercialProposal:Pas de NumeroPointDeLivraison');
                }
                if (String.isNotBlank(String.valueOf(inputMap.get('vSelectedPDLValFormula'))) && String.isBlank(String.valueOf(inputMap.get('vSelectedPCEValFormula')))) {
                    motifSouscriptionValue = 'Z003';
                }
                else if (String.isBlank(String.valueOf(inputMap.get('vSelectedPDLValFormula'))) && String.isNotBlank(String.valueOf(inputMap.get('vSelectedPCEValFormula')))) {
                    motifSouscriptionValue = 'Z004';
                }
                else if (String.isNotBlank(String.valueOf(inputMap.get('vSelectedPDLValFormula'))) && String.isNotBlank(String.valueOf(inputMap.get('vSelectedPCEValFormula')))) {
                    motifSouscriptionValue = 'Z005';
                }
            }
            return new ContextModel(motifSouscriptionValue,motifSouscriptionLibelle,CTXT_SSCRPTN);
            
        }
        
        public static String determineIdLocal(Map<String,Object> inputMap, Map<String,Object> outputMap){
            String idLocal;
            if(inputMap.get('vNumeroLocal') != null) {
                idLocal = String.valueOf(inputMap.get('vNumeroLocal'));
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
            else if (String.valueOf(inputMap.get('vIdCompteClientSouscrire')) != null) {
                idCompteClient = String.valueOf(inputMap.get('vIdCompteClientSouscrire'));
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