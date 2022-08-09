/**
 * @author Sutharsan Pushparajah
 * @date 11/05/2022
 * @description Test class for SM_SM004_Tranquility
 */
@isTest
private class SM_SM004_Tranquility_TEST {

    /**
     * @author Sutharsan Pushparajah
     * @date 11/05/2022
     * @description Testing the mock of Contracts Add API
     */
	@isTest
	private static void testAddContrat(){

        Test.setMock(HttpCalloutMock.class, SM_MCK001_Tranquility.getAddContractMocks());

        Test.startTest();

        SM_WRP001_AddContrat input = new SM_WRP001_AddContrat();
        input.canal = 'Web';
        input.IdBusinessPartner = '452371';
        input.refClientIdBP = '1234';
        input.numeroVoie = '10';
        input.libelleVoie = 'test voie';
        input.codePostal = '92100';
        input.ville = 'test ville';
        input.complementAdresse = 'test complement';
        SM_WRP001_AddContrat.ClientIdentity clientIdentity =  new SM_WRP001_AddContrat.ClientIdentity();
        clientIdentity.nom = 'nom';
        clientIdentity.prenom = 'prenom';
        clientIdentity.civilite = 'M.';
        input.contactinfo = clientIdentity;
        
        SM_WRP001_AddContrat.cls_clientInfos cls_clientInfos = new SM_WRP001_AddContrat.cls_clientInfos();
        cls_clientInfos.nom = 'nom';
        cls_clientInfos.prenom = 'prenom';
        cls_clientInfos.canal = 'appentrant';
        cls_clientInfos.modeDePaiement = 'prelevement';
        cls_clientInfos.dateEffet = '2021-04-02T22:00:00.000Z';
        
        SM_WRP001_AddContrat.cls_iban iban = new SM_WRP001_AddContrat.cls_iban();        
        iban.IbanNumber = 'FR7616006380110000601811010';
        iban.bic = 'CRCAMTTTT';
        iban.TitulaireCompte = 'Francesca TTT';
        cls_clientInfos.iban = iban;
        //localAssure        
        cls_clientInfos.numeroVoie = '10';
        cls_clientInfos.libelleVoie = 'test voie';
        cls_clientInfos.codePostal = '92100';
        cls_clientInfos.ville = 'test ville';
        cls_clientInfos.complementAdresse = 'test complement';
        
        SM_WRP001_AddContrat.cls_services serviceAccepte = new SM_WRP001_AddContrat.cls_services();
        
        serviceAccepte.idOffre ='DES0';
        serviceAccepte.clientInfos = cls_clientInfos;

        input.servicesAcceptes = serviceAccepte;

        Map<String, Object> inputMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(input));

        Map<String, Object> outMap = SM_SM004_Tranquility.addContrat(inputMap);

        System.assertNotEquals(null, outMap);

        Map<String, Object> res = (Map<String, Object>) outMap.get('return');
        Map<String, Object> resContrat = (Map<String, Object>) res.get('retour');
        List<Object> contracts = (List<Object>) resContrat.get('contratList');

        System.assertNotEquals(null, contracts);
        System.assertEquals(1, contracts.size());
        System.assertEquals(3834230, ((Map<String, Object>) contracts.get(0)).get('idContrat'));

        Test.stopTest();
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 11/05/2022
     * @description Testing the mock of Contracts Add Detection Projet API
     */
	@isTest
	private static void testAddContratDetectionProjet(){

        Test.setMock(HttpCalloutMock.class, SM_MCK001_Tranquility.getAddContractMocks());

        Test.startTest();

        Map<String, Object> inputMap = new Map<String, Object>();

        inputMap.put('civilite','MR');
        inputMap.put('prenom','PrenomClient');
        inputMap.put('nom','NomClient');
        inputMap.put('email','EmailClient');
        inputMap.put('bpClient','1234');
        inputMap.put('numRue','NumRueClient');
        inputMap.put('rue','RueClient');
        inputMap.put('codePostal','CodePostalClient');
        inputMap.put('commune','CommuneClient');
        
        //Local Assure
        inputMap.put('numRue','4');
        inputMap.put('rue','street');
        inputMap.put('codePostal','postcode');
        inputMap.put('commune','city');
        inputMap.put('pays','FR');
        
        //Prelevement
        inputMap.put('sendingMode','Phone');
        inputMap.put('libellePaiement','CH');
    
        //Trame Appel Contrat
        inputMap.put('Projet','Projet Isolation');
        inputMap.put('TypeDeProjet','Projet Isolation des combles');
        
        inputMap.put('Commentaire','Commentaires');
        inputMap.put('etat','3');
        inputMap.put('bpConseiller','123456789');
        inputMap.put('EcheanceDeProjet','projet <3');
        inputMap.put('RappelClient','2025-01-14T00:00:00.000Z');
        inputMap.put('HeureRappelPreferee','9h-14h');
        inputMap.put('ContactSalutation','MRS');

        Map<String, Object> outMap = SM_SM004_Tranquility.addContratDetectionProjet(inputMap);

        System.assertNotEquals(null, outMap);

        Map<String, Object> res = (Map<String, Object>) outMap.get('return');
        Map<String, Object> resContrat = (Map<String, Object>) res.get('retour');
        List<Object> contracts = (List<Object>) resContrat.get('contratList');

        System.assertNotEquals(null, contracts);
        System.assertEquals(1, contracts.size());
        System.assertEquals(3834230, ((Map<String, Object>) contracts.get(0)).get('idContrat'));

        Test.stopTest();
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 11/05/2022
     * @description Testing the mock of Contracts Get By Adresse API
     */
	@isTest
	private static void testGetByAdresse(){

        Test.setMock(HttpCalloutMock.class, SM_MCK001_Tranquility.getContractsByAdresseMocks());

        Test.startTest();

        SM_WRP001_AddContrat.RequestOffre inputRequest;
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();	

        inputMap.put('bpClient','1234');
        inputMap.put('rue','test rue');
        inputMap.put('codePostal','92100');
        inputMap.put('commune','92');
        
        inputRequest = SM_SM004_Tranquility.buildContratBody(inputMap);

        outMap = SM_SM004_Tranquility.getContractsByAdress(inputMap);

        System.assertNotEquals(null, outMap);

        Map<String, Object> res = (Map<String, Object>) outMap.get('return');
        Map<String, Object> resContrat = (Map<String, Object>) res.get('retour');
        List<Object> contracts = (List<Object>) resContrat.get('contratList');

        System.assertEquals(null, contracts);
        
        Test.stopTest();
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 11/05/2022
     * @description Testing the mock of Get Available Offers API
     */
	@isTest
	private static void testGetAvailableOffers(){

        Test.setMock(HttpCalloutMock.class, SM_MCK001_Tranquility.getOffersAvailableMocks());

        Test.startTest();

        Map<String, Object> outMap = SM_SM004_Tranquility.getOffresAvailables('2', 'libelleVoie', 'codepostal', 'commune', 'complement', 'batiment', 'bpclient', 'canal');

        System.assertNotEquals(null, outMap);

        Map<String, Object> res = (Map<String, Object>) outMap.get('return');
        Map<String, Object> resOffers = (Map<String, Object>) res.get('retour');
        List<Object> offers = (List<Object>) resOffers.get('offreList');

        System.assertNotEquals(null, offers);
        System.assertEquals(1, offers.size());
        System.assertEquals('ACP', ((Map<String, Object>) offers.get(0)).get('idOffre'));

        Test.stopTest();
    }
}