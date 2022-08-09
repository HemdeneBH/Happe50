@isTest
/*
*@author:MHA
*@Description: Mise à jour de la PC quand la PC est refusé et que le nb d'exemplaire est égal à 1
*@CreatedDate:05/09/2018
*@LastModified:06/12/2018
*/
global class SM_AP18_CreateCommercialProposalRef_TEST {
    @testSetup static void setup() {
        SM_AP08_TestLib.insertCS_SMOCTOPUS();
    }
    @isTest static void createCommercialProposalWithOutIdBp_test(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        SM_AP18_CreateCommercialProposal_Ref testPC = new SM_AP18_CreateCommercialProposal_Ref();
        
        testPC.invokeMethod('createCommercialProposal', inputMap, outputMap, options);
        System.assertEquals('Absence de la référence client',outputMap.get('errorLibelle'));
    }
    
    @isTest static void createCommercialProposalWithOutChoixElement_test(){
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('vRefClientIdBP', '0309033659');
        inputMap.put('vChooseSellingOption','');
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        SM_AP18_CreateCommercialProposal_Ref testPC = new SM_AP18_CreateCommercialProposal_Ref();
        
        testPC.invokeMethod('createCommercialProposal', inputMap, outputMap, options);
        System.assertEquals('Absence du choix de l\'option de vente',outputMap.get('errorLibelle'));
    }
    
    @isTest static void createCommercialProposalWithOutChoixElementValue_test(){
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('vRefClientIdBP', '0309033659');		
        inputMap.put('vChooseSellingOption', 'Emménagement');
        inputMap.put('vEffectiveDate', (DateTime.now()).formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''));
        inputMap.put('vNewPCStatus', 'Accept');
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        SM_AP18_CreateCommercialProposal_Ref testPC = new SM_AP18_CreateCommercialProposal_Ref();
        
        testPC.invokeMethod('createCommercialProposal', inputMap, outputMap, options);
        System.assertEquals('Le numéro local SAP est absent',outputMap.get('errorLibelle'));
    }
    
    @isTest static void createCommercialProposalWithOutCompteClient_test(){
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('vRefClientIdBP', '0309033659');		
        inputMap.put('vChooseSellingOption', 'Emménagement');
        inputMap.put('vEffectiveDate', (DateTime.now()).formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''));
        inputMap.put('vNumeroLocal', '0123456789');
        inputMap.put('vNewPCStatus', 'Accept');
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        SM_AP18_CreateCommercialProposal_Ref testPC = new SM_AP18_CreateCommercialProposal_Ref();
        
        testPC.invokeMethod('createCommercialProposal', inputMap, outputMap, options);
        System.assertEquals('pas d\'id compte client',outputMap.get('errorLibelle'));
    }
    
    @isTest static void createCommercialProposalWithOutCaracteristiqueCPV1_test(){
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('vRefClientIdBP', '0309033659');		
        inputMap.put('vChooseSellingOption', 'Emménagement');
        inputMap.put('vEffectiveDate', (DateTime.now()).formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''));
        inputMap.put('vNumeroLocal', '0123456789');
        inputMap.put('vIdCompteClientNvxLogement','000512478157');
        inputMap.put('vNewPCStatus', 'Accept');
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        SM_AP18_CreateCommercialProposal_Ref testPC = new SM_AP18_CreateCommercialProposal_Ref();
        
        testPC.invokeMethod('createCommercialProposal', inputMap, outputMap, options);
        System.assertEquals('Le canal d\'envoi pour la CPV n\'a pas été choisi',outputMap.get('errorLibelle'));
        
    }
    
    @isTest static void createCommercialProposalWithOutCaracteristiqueCPV2_test(){
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('vRefClientIdBP', '0309033659');		
        inputMap.put('vChooseSellingOption', 'Emménagement');
        inputMap.put('vEffectiveDate', (DateTime.now()).formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''));
        inputMap.put('vNumeroLocal', '0123456789');
        inputMap.put('vIdCompteClientNvxLogement','000512478157');
        inputMap.put('vCodeCampagne', '20180912');
        inputMap.put('vNbrExemplaire', '1');
        inputMap.put('vNewPCStatus', 'Accept');
        inputMap.put('vCodePromo', '12345');
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        SM_AP18_CreateCommercialProposal_Ref testPC = new SM_AP18_CreateCommercialProposal_Ref();
        
        testPC.invokeMethod('createCommercialProposal', inputMap, outputMap, options);
        System.assertEquals('Le canal d\'envoi pour la CPV n\'a pas été choisi',outputMap.get('errorLibelle'));
    }
    @isTest static void createCommercialProposalWithOutPrevelement_test(){
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('vRefClientIdBP', '0309033659');		
        inputMap.put('vChooseSellingOption', 'Emménagement');
        inputMap.put('vEffectiveDate', (DateTime.now()).formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''));
        inputMap.put('vNumeroLocal', '0123456789');
        inputMap.put('vIdCompteClientNvxLogement','000512478157');
        inputMap.put('vCodeCampagne', '20180912');
        inputMap.put('vCodePromo', '12345');
        inputMap.put('vNbrExemplaire', '1');
        inputMap.put('vCanaEnvoiCPV', 'Courrier');
        inputMap.put('vNewPCStatus', 'Accept');
        Map<String, Object> blockPrel = new Map<String, object>();
        Map<String, Object> blockMens = new Map<String, object>();
        blockMens.put('PrelevementBlock',blockPrel);
        inputMap.put('vServicesGestion', blockMens);
        //inputMap.put('Prelevement', null);
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        SM_AP18_CreateCommercialProposal_Ref testPC = new SM_AP18_CreateCommercialProposal_Ref();
        
        testPC.invokeMethod('createCommercialProposal', inputMap, outputMap, options);
        System.assertEquals('Veuillez remplir par Oui ou Non dans le choix de prélèvement',outputMap.get('errorLibelle'));
    }
    
    @isTest static void createCommercialProposal_test() {
        
        Test.startTest();
        Map<String, Object> inputMap=initData('Emménagement','16246164935306','16246309653164');
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        SM_AP18_CreateCommercialProposal_Ref testPC = new SM_AP18_CreateCommercialProposal_Ref();
        testPC.invokeMethod('createCommercialProposal', inputMap, outputMap, options);
        System.debug('Test MHA' + testPC.invokeMethod('createCommercialProposal', inputMap, outputMap, options));
        System.debug('@result' + outputMap);
        
        Test.stopTest();
    }
    
    @isTest static void createCommercialProposalChangementFournisseur_test() {
        
        Test.startTest();
        Map<String, Object> inputMap=initData('Changement de fournisseur','16246164935306','16246309653164');
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        SM_AP18_CreateCommercialProposal_Ref testPC = new SM_AP18_CreateCommercialProposal_Ref();
        testPC.invokeMethod('createCommercialProposal', inputMap, outputMap, options);
        System.debug('Test MHA' + testPC.invokeMethod('createCommercialProposal', inputMap, outputMap, options));
        System.debug('@result' + outputMap);
        
        Test.stopTest();
    }
    
    @isTest static void createCommercialProposalElec_test() {
        
        Test.startTest();
        Map<String, Object> inputMap=initData('Emménagement','16246164935306','');
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        SM_AP18_CreateCommercialProposal_Ref testPC = new SM_AP18_CreateCommercialProposal_Ref();
        testPC.invokeMethod('createCommercialProposal', inputMap, outputMap, options);
        System.debug('Test MHA' + testPC.invokeMethod('createCommercialProposal', inputMap, outputMap, options));
        System.debug('@result' + outputMap);
        
        Test.stopTest();
    }
    
    @isTest static void createCommercialProposalGaz_test() {
        
        Test.startTest();
        Map<String, Object> inputMap=initData('Emménagement','','16246309653164');
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        SM_AP18_CreateCommercialProposal_Ref testPC = new SM_AP18_CreateCommercialProposal_Ref();
        testPC.invokeMethod('createCommercialProposal', inputMap, outputMap, options);
        System.debug('Test MHA' + testPC.invokeMethod('createCommercialProposal', inputMap, outputMap, options));
        System.debug('@result' + outputMap);
        
        Test.stopTest();
    }
    @isTest static void createCommercialProposalCHO() {
        
        Test.startTest();
        Map<String, Object> inputMap = initData('Changement d\'Offre','','16246309653164');
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        SM_AP18_CreateCommercialProposal_Ref testPC = new SM_AP18_CreateCommercialProposal_Ref();
        testPC.invokeMethod('createCommercialProposal', inputMap, outputMap, options);
        System.debug('Test MHA' + testPC.invokeMethod('createCommercialProposal', inputMap, outputMap, options));
        System.debug('@result' + outputMap);
        
        Test.stopTest();
    }
    
    static Map<String, Object> initData(String vChooseSellingOption,String PDL,String PCE){
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('vCAR', '5500');
        inputMap.put('vCAE', '8000');
        inputMap.put('vCAE_HP', '6000');
        inputMap.put('vCAE_HC', '2000');
        inputMap.put('vCanaEnvoiCPV', 'Courrier');
        inputMap.put('vChooseSellingOption', vChooseSellingOption);
        inputMap.put('vCodeCampagne', '20180912');	
        inputMap.put('vCodePromo', '12345');
        inputMap.put('vCodeTypeComptage','HPHC');	
        inputMap.put('vEffectiveDate', (DateTime.now()).formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''));
        inputMap.put('vIdCompteClientNvxLogement','000512478157');
        inputMap.put('vIdCompteClientSouscrire','');
        List<String> idOffreList = new List<String>();
        idOffreList.add('EBUAK3');
        idOffreList.add('GBUAK3');
        inputMap.put('vIdOffreList', idOffreList);
        inputMap.put('vMensTotal', '100');
        inputMap.put('vNbrExemplaire', '1');
        inputMap.put('vNumeroLocal',0713909602);
        inputMap.put('vPuissanceSouscriteValeur', '6kVA');
        inputMap.put('vRefClientIdBP', '0309033659');
        if(!String.isBlank(PDL)){
            inputMap.put('vSelectedPDLValFormula', PDL);
            //'16246164935306');
        }		
        if(!String.isBlank(PCE)){
            inputMap.put('vSelectedPCEValFormula', PCE);
            //'16246309653164');	
        }	
        Map<String, Object> Mens = new Map<String, Object>();
        Map<String, Object> FEL = new Map<String, Object>();
        Map<String, Object> drp = new Map<String, Object>();
        Map<String, Object> blockMens = new Map<String, object>();
        Map<String, Object> montant = new Map<String, object>();
        Map<String, Object> blockPrel = new Map<String, object>();
        montant.put('MontantAjustable', 50);
        Mens.put('MontantBlock', montant);
        Mens.put('Mensualisation', 'oui');
        blockMens.put('MensualisationBlock', Mens);
        drp.put('RadioDRP', 'Oui');
        drp.put('SelectJourSouhaite', '10');
        blockMens.put('DRP', drp);
        FEL.put('FactureEnLigne', 'oui');
        blockMens.put('FactureEnLigneBlock', FEL);
        inputMap.put('Prelevement', 'Oui');
        blockMens.put('PrelevementBlock',blockPrel);
        inputMap.put('vServicesGestion', blockMens);
        inputMap.put('vidPack', 'DGBUEBUF3AK_P');
        inputMap.put('vNewPCStatus', 'Accept');
        inputMap.put('vIsMensualise', true);
        inputMap.put('vFEL', 'Oui');
        inputMap.put('vEdocument', 'Oui');
        inputMap.put('RadioDRP', 'Oui');
         inputMap.put('SelectJourSouhaite' , '10');
        return inputMap;
        
    }
    /*********************************TRANSFO PC  ********************************************************/
    @isTest static void transformCommercialProposal_test() {
        Test.startTest();
        Map<String, Object>inputMap = new Map<String, Object>();
        inputMap.put('vIdPropositionCommerciale', '7022910472');
        
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        SM_AP18_CreateCommercialProposal_Ref testPC = new SM_AP18_CreateCommercialProposal_Ref();
        testPC.invokeMethod('transformCommercialProposal', inputMap, outputMap, options);
        System.assertEquals('0123456789',outputMap.get('idContrat'));
        Test.stopTest();
        
    }
    
    @isTest static void transformCommercialProposalWithOutIdPC_test() {
        Test.startTest();
        Map<String, Object>inputMap = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        SM_AP18_CreateCommercialProposal_Ref testPC = new SM_AP18_CreateCommercialProposal_Ref();
        testPC.invokeMethod('transformCommercialProposal', inputMap, outputMap, options);
        System.assertEquals('l\'idPropositionCommerciale est manquant',outputMap.get('errorLibelle'));
        Test.stopTest();
        
    }
    
    @isTest static void transformerPCDeuxExemplaires_test() {
        Test.startTest();
        Map<String, Object>inputMap = new Map<String, Object>();
        inputMap.put('vIdPropositionCommerciale', '7022910472');
         inputMap.put('vPCTransfoStatus', 'Accept');
        
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        SM_AP18_CreateCommercialProposal_Ref testPC = new SM_AP18_CreateCommercialProposal_Ref();
        /*Test.setMock(WebServiceMock.class, new SM_AP18_CreateCommercialProposal_RefMock());*/
        testPC.invokeMethod('transformerPCDeuxExemplaires', inputMap, outputMap, options);
        
        System.assertEquals('0123456789', outputMap.get('idContrat') );
        //System.assertEquals(String.valueOf(outputMap.get('messageRetours')),'Traitement effectué sans erreur');
        Test.stopTest();
        
    }
    /***********************************************CREERPC SA *********************************************************/
    @isTest static void createCommercialProposalSA_test() {
        Test.startTest();
        
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('vRefClientIdBP', '0309033659');
        /*  inputMap.put('Acouple', 'Oui');

inputMap.put('AssuranceCouplePrenom', 'Leo');
inputMap.put('AssuranceCoupleNom', 'DAVID');
inputMap.put('AssuranceCoupleDateN', '16/08/1990');
inputMap.put('AssuranceCoupleCSP', '001');*/
        
        Map<String, Object> offreMap = new Map<String, Object>();
        offreMap.put('idPack', 'DGBUEBUF3AK_P');
        List<String> idOffreList = new List<String>();
        idOffreList.add('EBUAK3');
        idOffreList.add('GBUAK3');
        Map<String, Object> pdlElecInfo = new Map<String, Object>();
        pdlElecInfo.put('puissanceSouscriteValeur', '6kVA');
        offreMap.put('idOffreList', idOffreList);
        inputMap.put('OffrePoussee', offreMap);
        inputMap.put('pdlElecInfo',pdlElecInfo);
        inputMap.put('vNumeroLocal', '0701827166');
        inputMap.put('vEffectiveDate', (DateTime.now()).formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''));
        inputMap.put('vChooseSellingOption', 'Emménagement');
        inputMap.put('vChoixAssuranceFacture', 'Y');
        inputMap.put('vcontratActif', 'Y');
        inputMap.put('selectedPDLValFormula', '16246164935306');
        inputMap.put('selectedPCEValFormula', '16246309653164');
        inputMap.put('CAR', '5500');
        inputMap.put('CAE', '8000');
        inputMap.put('CAE_HP', '6000');
        inputMap.put('CAE_HC', '2000');
        

        inputMap.put('vAssuranceSimpleCivilite', 'Mme');
        inputMap.put('vAssuranceSimplePrenom', 'Marie');
        inputMap.put('vAssuranceSimpleNom', 'DAVID');
        inputMap.put('vAssuranceSimpleDateN', '16/06/1990');
        inputMap.put('vAssuranceSimpleCSP', '001');
        
        
                
        /*Map<String, Object>caracteristiquesOffre = new Map<String, Object>();
caracteristiquesOffre.put('CodeCampagne', '20180912');
caracteristiquesOffre.put('NbrExemplaire', '1');
caracteristiquesOffre.put('CanaEnvoiCPV', 'Courrier');
inputMap.put('CaracteristiquesOffre', caracteristiquesOffre);*/
        
        inputMap.put('Asimple', 'Oui');
        inputMap.put('Acouple', 'Non');
        inputMap.put('vCodeCampagne', '20180912');
        inputMap.put('vCanaEnvoiCPV', '1');
        
        inputMap.put('vClientChoice','Accepte');
        
        Map<String, Object>offreChoisis = new Map<String, Object>();
        offreChoisis.put('idPack', 'GBUA3_P');
        List<String> listOffre = new List<String>();
        listOffre.add('GBUA3');
        listOffre.add('EBUA3');
        offreChoisis.put('idOffreList', listOffre);
        offreChoisis.put('MensGlobale', '30');
        inputMap.put('OffreChoisis', offreChoisis);
        
        Map<String, Object> Mens = new Map<String, Object>();
        Map<String, Object> FEL = new Map<String, Object>();
        Map<String, Object> drp = new Map<String, Object>();
        Map<String, Object> blockMens = new Map<String, object>();
        Map<String, Object> montant = new Map<String, object>();
        Map<String, Object> blockPrel = new Map<String, object>();
        montant.put('MontantAjustable', 50);
        Mens.put('MontantBlock', montant);
        Mens.put('Mensualisation', 'oui');
        blockMens.put('MensualisationBlock', Mens);
        drp.put('RadioDRP', 'Oui');
        drp.put('SelectJourSouhaite', '10');
        blockMens.put('DRP', drp);
        FEL.put('FactureEnLigne', 'oui');
        blockMens.put('FactureEnLigneBlock', FEL);
        blockPrel.put('Prelevement', 'Oui');
        blockMens.put('PrelevementBlock',blockPrel);
        inputMap.put('ServicesGestion', blockMens);
        inputMap.put('idCompteClient','000512478157');
        inputMap.put('idLocal',225230);
        
        
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        SM_AP18_CreateCommercialProposal_Ref testPC = new SM_AP18_CreateCommercialProposal_Ref();
        
        testPC.invokeMethod('createCommercialProposalSA', inputMap, outputMap, options);
        System.debug('Test MHA' + testPC.invokeMethod('createCommercialProposalSA', inputMap, outputMap, options));
        System.debug('@result' + outputMap);
        System.assertEquals('0123456789',String.valueOf(outputMap.get('idPCSA')));
        
        Test.stopTest();
    }
    
    @isTest     
    static void createCommercialProposalSA_Harmonica() {
        Test.startTest();
        
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('vRefClientIdBP', '0309033659');
        
        Map<String, Object> offreMap = new Map<String, Object>();
        offreMap.put('idPack', 'DGBUEBUF3AK_P');
        List<String> idOffreList = new List<String>();
        Map<String, Object> pdlElecInfo = new Map<String, Object>();
        pdlElecInfo.put('puissanceSouscriteValeur', '6kVA');
        offreMap.put('idOffreList', idOffreList);
        inputMap.put('OffrePoussee', offreMap);
        inputMap.put('pdlElecInfo',pdlElecInfo);
        inputMap.put('vNumeroLocal', '0701827166');
        inputMap.put('vEffectiveDate', (DateTime.now()).formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''));
        inputMap.put('vChooseSellingOption', 'Emménagement');
        inputMap.put('vChoixAssuranceFacture', 'Y');
        inputMap.put('vcontratActif', 'Y');
        inputMap.put('selectedPDLValFormula', '16246164935306');
        inputMap.put('selectedPCEValFormula', '16246309653164');
        inputMap.put('CAR', '5500');
        inputMap.put('CAE', '8000');
        inputMap.put('CAE_HP', '6000');
        inputMap.put('CAE_HC', '2000');
        

        inputMap.put('vAssuranceSimpleCivilite', 'Mme');
        inputMap.put('vAssuranceSimplePrenom', 'Marie');
        inputMap.put('vAssuranceSimpleNom', 'DAVID');
        inputMap.put('vAssuranceSimpleDateN', '16/06/1990');
        inputMap.put('vAssuranceSimpleCSP', '001');
        
        inputMap.put('Asimple', 'Oui');
        inputMap.put('Acouple', 'Non');
        inputMap.put('vCodeCampagne', '20180912');
        inputMap.put('vCanaEnvoiCPV', '1');
        
        inputMap.put('vClientChoice','Accepte');       
        Map<String, Object> Mens = new Map<String, Object>();
        Map<String, Object> FEL = new Map<String, Object>();
        Map<String, Object> drp = new Map<String, Object>();
        Map<String, Object> blockMens = new Map<String, object>();
        Map<String, Object> montant = new Map<String, object>();
        Map<String, Object> blockPrel = new Map<String, object>();
        montant.put('MontantAjustable', 50);
        Mens.put('MontantBlock', montant);
        Mens.put('Mensualisation', 'oui');
        blockMens.put('MensualisationBlock', Mens);
        drp.put('RadioDRP', 'Oui');
        drp.put('SelectJourSouhaite', '10');
        blockMens.put('DRP', drp);
        FEL.put('FactureEnLigne', 'oui');
        blockMens.put('FactureEnLigneBlock', FEL);
        blockPrel.put('Prelevement', 'Oui');
        blockMens.put('PrelevementBlock',blockPrel);
        inputMap.put('ServicesGestion', blockMens);
        inputMap.put('idCompteClient','000512478157');
        inputMap.put('idLocal',225230);
        inputMap.put('vContext','harmonica');
        inputMap.put('vCodeOffreElec','EBUAK3');
        inputMap.put('vCodeOffreGaz','GBUAK3');
        inputMap.put('vEnergyTypeOptions','Duo');
        inputMap.put('vNewPCStatus','Reflechis');
        inputMap.put('vIdCompteClientNvxLogement','000516687819');
        inputMap.put('Prelevement','Oui');
        
        
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        SM_AP18_CreateCommercialProposal_Ref testPC = new SM_AP18_CreateCommercialProposal_Ref();
        
        testPC.invokeMethod('createCommercialProposal', inputMap, outputMap, options);
        
        Test.stopTest();
    }
    
    @isTest static void testCreateCommercialProposal_Elec_OptionVerte() {
        
        Test.startTest();
        
        Map<String, Object> inputMap = initData('Emménagement','16246164935306','16246309653164');
        
        // Cas Elec Vert+
        inputMap.put('koCreationPDLSOpvt', false);
        inputMap.put('elecOptionChoice', 'Y');
        
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        SM_AP18_CreateCommercialProposal_Ref testPC = new SM_AP18_CreateCommercialProposal_Ref();
        testPC.invokeMethod('createCommercialProposal', inputMap, outputMap, options);
        System.debug('Test : testCreateCommercialProposal_Elec_OptionVerte' + testPC.invokeMethod('createCommercialProposal', inputMap, outputMap, options));
        System.debug('Result : testCreateCommercialProposal_Elec_OptionVerte' + outputMap);
        
        Test.stopTest();
    }
    
    @isTest static void testCreateCommercialProposal_Gaz_OptionVerte() {
        
        Test.startTest();
        
        Map<String, Object> inputMap = initData('Emménagement','16246164935306','16246309653164');
        
        // Cas Gaz Vert+
        inputMap.put('koCreationPDLSOpvt', false);
        inputMap.put('gasOptionChoice', 'Y');
        inputMap.put('gasOptionRange', 10);
        
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        SM_AP18_CreateCommercialProposal_Ref testPC = new SM_AP18_CreateCommercialProposal_Ref();
        testPC.invokeMethod('createCommercialProposal', inputMap, outputMap, options);
        System.debug('Test : testCreateCommercialProposal_Gaz_OptionVerte' + testPC.invokeMethod('createCommercialProposal', inputMap, outputMap, options));
        System.debug('Result : testCreateCommercialProposal_Gaz_OptionVerte' + outputMap);
        
        Test.stopTest();
    }
    
    @isTest static void testCreateCommercialProposal_Dual_OptionVerte() {
        
        Test.startTest();
        
        Map<String, Object> inputMap = initData('Emménagement','16246164935306','16246309653164');
        
        // Cas Elet Vert+ et Gaz Vert+ en Dual
        inputMap.put('koCreationPDLSOpvt', false);
        inputMap.put('elecOptionChoice', 'Y');
        inputMap.put('gasOptionChoice', 'Y');
        inputMap.put('gasOptionRange', 10);
        
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        SM_AP18_CreateCommercialProposal_Ref testPC = new SM_AP18_CreateCommercialProposal_Ref();
        testPC.invokeMethod('createCommercialProposal', inputMap, outputMap, options);
        System.debug('Test : testCreateCommercialProposal_Dual_OptionVerte' + testPC.invokeMethod('createCommercialProposal', inputMap, outputMap, options));
        System.debug('Result : testCreateCommercialProposal_Dual_OptionVerte' + outputMap);
        
        Test.stopTest();
    }
}