/**
 * @author unknown
 * @date 15/04/2022 - Refactoring by Sutharsan Pushparajah
 * @description SM_SM004_Tranquility - Implement the Tranquility remote services
 */
public inherited sharing class SM_SM004_Tranquility {

    /* Connected User */
    private static  User conseiller;	
    /* Transcodification of Civilite values */
    private static Map<String, String> transcoCivilite;
    /* Default Transcodification of Civilite values */
    private static final String DEFAULT_TRANSCO_CIVILITE = 'MR et MME';

    static {	
        conseiller = SM_EM103_User.getByIds('Id, SAP_Identifier__c', new List<Id>{UserInfo.getUserId()}).get(0);
        transcoCivilite = new Map<String, String>{'MR'=>'MR', 'MRS'=>'MR', 'MME'=>'MME', 'MLLE'=>'MME', 'MLLES'=>'MME','MMES'=>'MME'};
    }
    
    /**
     * @author Unknown
     * @date 19/04/2022
     * @description Build body payload for get Contracts by adresse API
     * @param inputMap Input parameters
     * @return SM_WRP001_AddContrat.RequestOffre Body Payload wrapper for get Contracts by adresse API
     */
    public static SM_WRP001_AddContrat.RequestOffre buildContratBody(Map<String,Object> inputMap) {
        //Local Assure
        SM_WRP001_AddContrat.localAssure localAssure = new SM_WRP001_AddContrat.localAssure();
        localAssure.numRue = String.valueof(inputMap.get('numRue'));
        localAssure.rue = String.valueof(inputMap.get('rue'));
        localAssure.codePostal = String.valueof(inputMap.get('codePostal'));
        localAssure.commune = String.valueof(inputMap.get('commune'));
        localAssure.pays = 'FR';
        //Request 
        SM_WRP001_AddContrat.RequestOffre requestOffre = new SM_WRP001_AddContrat.RequestOffre();
        requestOffre.localAssure = localAssure;
        requestOffre.idConsomateur = 'SMILE';	
        requestOffre.bpClient = String.valueof(inputMap.get('bpClient'));	
        
        return requestOffre;
    }

    /**
     * @author Unknown
     * @date 19/04/2022
     * @description Build body payload for add Contracts API
     * @param inputMap Input parameters
     * @return SM_WRP001_AddContrat.RequestAddContrat Body Payload wrapper for add Contracts API
     */
    public static SM_WRP001_AddContrat.RequestAddContrat buildAddContratBody(Map<String, Object> inputMap) {
        
        if(inputMap == null){	
            return null;
        }

        if(inputMap.get('servicesEnAttente') == ''){
            inputMap.put('servicesEnAttente', null);
        }

        if(inputMap.get('servicesAcceptes') == ''){
            inputMap.put('servicesAcceptes', null);
        }

        SM_WRP001_AddContrat services = SM_WRP001_AddContrat.parse(JSON.serialize(inputMap));

        if (services != null){
            SM_WRP001_AddContrat.cls_services subService = null;

            if (services.servicesAcceptes != null){
                subService = services.servicesAcceptes;
                subService.formattedEtat = '1';
            } else if (services.servicesEnAttente != null){
                subService = services.servicesEnAttente;
                subService.formattedEtat = '3';
            } else if (services.servicesRefuses != null){
                subService = services.servicesRefuses;
                subService.formattedEtat = '2';
            }

            subService.canal = services.canal;                   
            subService.clientInfos.refClientIdBP = services.refClientIdBP;
            subService.clientInfos.nom = services.contactinfo.nom;
            subService.clientInfos.prenom = services.contactinfo.prenom;
            subService.clientInfos.civilite = services.contactinfo.civilite;
            subService.clientInfos.email = services.contactinfo.email;
            //client info
            subService.clientInfos.clNumeroVoie = services.numeroVoie;
            subService.clientInfos.clLibelleVoie = services.libelleVoie;
            subService.clientInfos.clCodePostal = services.codePostal;
            subService.clientInfos.clVille = services.ville;
            subService.clientInfos.clComplementAdresse = services.complementAdresse;

            if(subService.clientInfos.civilite != null){

                subService.clientInfos.civilite = transcoCivilite.get(subService.clientInfos.civilite);
                
                if (subService.clientInfos.civilite == null){
                    subService.clientInfos.civilite = DEFAULT_TRANSCO_CIVILITE; 
                }            
            }

            if (subService.clientInfos.canal == 'Email'){
                subService.clientInfos.canal = 'emails';
            } else {
                subService.clientInfos.canal = 'courrier';
            }
        
            SM_WRP001_AddContrat.cls_modePaiement paiementMode = new SM_WRP001_AddContrat.cls_modePaiement(); 
            paiementMode.sendingMode = subService.clientInfos.canal;
            paiementMode.modePrelevement = new SM_WRP001_AddContrat.cls_modePrelevement();

            //Prelevement
            if(subService.clientInfos.modeDePaiement == 'prelevement' && subService.clientInfos.iban != null){
                paiementMode.libellePaiement = 'PR';
                paiementMode.modePrelevement.nomTitulaire = subService.clientInfos.iban.TitulaireCompte;
                paiementMode.modePrelevement.dPrlv = subService.clientInfos.DatePrelevement;
                paiementMode.modePrelevement.iban = subService.clientInfos.iban.IbanNumber;
                paiementMode.modePrelevement.domiciliation = subService.clientInfos.iban.bic;                
            }else if (subService.clientInfos.modeDePaiement == 'prelevement' && subService.clientInfos.iban == null){
                // Partie service affinitaire (Garantie, canal email, carte bancaire)
                paiementMode.libellePaiement = 'PR';
                paiementMode.modePrelevement.dPrlv = subService.clientInfos.DatePrelevement;
            } else if (subService.clientInfos.modeDePaiement == 'cb'){
                paiementMode.libellePaiement = 'CB';
                paiementMode.modePrelevement = null;
            } else if(subService.clientInfos.modeDePaiement == 'ce'){
                // Partie assurance facture
                paiementMode.libellePaiement = 'CE';          
                paiementMode.modePrelevement = null;	
            }	

            //Client
            SM_WRP001_AddContrat.ClientIdentity client = new SM_WRP001_AddContrat.ClientIdentity();
            client.civilite = subService.clientInfos.civilite;
            client.email = subService.clientInfos.email;
            client.prenom = subService.clientInfos.prenom;
            client.nom = subService.clientInfos.nom;
            client.bpClient = subService.clientInfos.refClientIdBP;
            client.numRue = subService.clientInfos.clNumeroVoie;
            client.rue = subService.clientInfos.clLibelleVoie;
            client.codePostal = subService.clientInfos.clCodePostal;
            client.commune = subService.clientInfos.clVille;

            //Local Assure
            SM_WRP001_AddContrat.localAssure localAssure = new SM_WRP001_AddContrat.localAssure();
            localAssure.numRue = subService.clientInfos.numeroVoie;
            localAssure.rue = subService.clientInfos.libelleVoie;
            localAssure.codePostal = subService.clientInfos.codePostal;
            localAssure.commune = subService.clientInfos.ville;
            localAssure.complement = subService.clientInfos.complementAdresse;

            //Trame Appel Contrat
            SM_WRP001_AddContrat.contrat contrat = new  SM_WRP001_AddContrat.contrat();
            contrat.client = client;
            contrat.localAssure = localAssure;
            contrat.paiementMode = paiementMode;

            // Récupération de la date d'effet
            String effectiveDateString;
            if(subService.clientInfos.dateEffet != null){
                String year = subService.clientInfos.dateEffet.substring(0, 4);
                String month = subService.clientInfos.dateEffet.substring(5, 7);
                String day = subService.clientInfos.dateEffet.substring(8, 10);
                String hour = subService.clientInfos.dateEffet.substring(11, 13);
                DateTime effectiveDateTime = DateTime.valueOfGMT(year + '-' + month + '-' + day + ' ' + hour + ':' + 0 +  ':' + 0);
                effectiveDateString = effectiveDateTime.format('yyyy-MM-dd');
                contrat.dateEffet = effectiveDateString;
            } else {
                contrat.dateEffet ='';
            }

            contrat.idOffre = subService.idOffre;
            contrat.bpConseiller = Integer.Valueof(conseiller.SAP_Identifier__c);
            contrat.canal = subService.canal;
            contrat.etat = subService.formattedEtat;
            contrat.order_id = 'test';

            SM_WRP001_AddContrat.RequestAddContrat inputRequest = new SM_WRP001_AddContrat.RequestAddContrat();
            inputRequest.contrat = contrat;
            inputRequest.idConsomateur = 'smile';	

            return inputRequest;
    }
    
            return null;
        }
    
    /**
     * @author Unknown
     * @date 19/04/2022
     * @description Build body payload for add Contracts Detection Projet API
     * @param inputMap Input parameters
     * @return SM_WRP001_AddContrat.RequestAddContrat Body Payload wrapper for add Contracts Detection Projet API
     */
    public static SM_WRP002_AddContrat.RequestAddContrat buildAddContratDetectionProjetBody(Map<String, Object> inputMap) {
       
        String civilite=String.valueof(inputMap.get('ContactSalutation'));
        String civiliteOut=String.valueof(inputMap.get('ContactSalutation')); 
        String libelleProduit = inputMap.get('Projet') + '_' + inputMap.get('TypeDeProjet');
        String codeProduit = 'N/A';
        String rappelClient = String.valueof(inputMap.get('RappelClient'));
		Datetime dt = (DateTime)JSON.deserialize('"' + RappelClient + '"', DateTime.class);
		String formattedDate = dt.format('dd/MM/YYYY');

          	if		(civilite != null){

            civilite = transcoCivilite.get(civilite);
            
            if (civilite == null){
                civilite = DEFAULT_TRANSCO_CIVILITE; 
            }            
        	}
        
        for (SM_CodeProduitProjet__mdt assld : SM_EM104_CodeProduitProjet.allActivesSortedByOrderId) {          
            boolean assignmentValid = true;
           
              if(assld == null ) {
                    continue;
                } 

            if (inputMap.get('Projet') != '' && inputMap.get('TypeDeProjet') == ''){
                if(assld.Projet__c == inputMap.get('Projet') && assld.TypedeProjet__c == null) {
                    if (assld.CodeProduit__c != null){
                        codeProduit = assld.CodeProduit__c;
                    }
                    break;
                }
            }
            else if (inputMap.get('Projet') != '' && inputMap.get('TypeDeProjet') != ''){
                if (inputMap.get('Projet') == assld.Projet__c && inputMap.get('TypeDeProjet') == assld.TypedeProjet__c) {
                    if (assld.CodeProduit__c != null){
                        codeProduit = assld.CodeProduit__c;
                    }
                    break;
                }
            }    
            }
        
        //Request Body          
        //Client
        SM_WRP002_AddContrat.ClientIdentity client = new SM_WRP002_AddContrat.ClientIdentity();
        client.civilite = civiliteOut;
       	client.prenom = String.valueof(inputMap.get('PrenomClient'));
        client.nom = String.valueof(inputMap.get('NomClient'));
        client.email = String.valueof(inputMap.get('EmailClient')); 
        client.bpClient = String.valueof(inputMap.get('refClientIdBP'));
        client.numRue = String.valueof(inputMap.get('NumRueClient'));
        client.rue = String.valueof(inputMap.get('RueClient'));
        client.codePostal =String.valueof(inputMap.get('CodePostalClient'));
        client.commune = String.valueof(inputMap.get('CommuneClient'));
        
        //Local Assure
        SM_WRP002_AddContrat.localAssure localAssure = new SM_WRP002_AddContrat.localAssure();
        localAssure.numRue = String.valueof(inputMap.get('housenumber'));
        localAssure.rue = String.valueof(inputMap.get('street'));
        localAssure.codePostal = String.valueof(inputMap.get('postcode'));
        localAssure.commune = String.valueof(inputMap.get('city'));
        localAssure.pays = 'FR';
        
        //Prelevement
        SM_WRP002_AddContrat.cls_modePaiement paiementMode = new SM_WRP002_AddContrat.cls_modePaiement(); 
        paiementMode.libellePaiement = 'CH';
       
		//Trame Appel Contrat
        SM_WRP002_AddContrat.contrat contrat = new  SM_WRP002_AddContrat.contrat();
        contrat.metaValues=new List<SM_WRP002_AddContrat.metaValues>();
       
        SM_WRP002_AddContrat.metaValues metaValues1 = new SM_WRP002_AddContrat.metaValues();
        metaValues1.fieldName = 'echeance_projet';
        metaValues1.fieldValue = String.valueof(inputMap.get('EcheanceDeProjet'));
        contrat.metaValues.add(metaValues1);
        
        SM_WRP002_AddContrat.metaValues metaValues2 = new SM_WRP002_AddContrat.metaValues();  
        metaValues2.fieldName = 'jour_rappel';
        metaValues2.fieldValue = formattedDate;
        contrat.metaValues.add(metaValues2);
        
        SM_WRP002_AddContrat.metaValues metaValues3 = new SM_WRP002_AddContrat.metaValues();
        metaValues3.fieldName = 'horaires_rappel';
      	metaValues3.fieldValue = String.valueof(inputMap.get('HeureRappelPreferee'));
        contrat.metaValues.add(metaValues3);

        contrat.client = client;
        contrat.localAssure = localAssure;
        contrat.paiementMode = paiementMode;        
        contrat.idOffre = CodeProduit;
        contrat.bpConseiller = String.Valueof(conseiller.SAP_Identifier__c);
        contrat.canal = 'appentrant';
        contrat.etat = String.valueof(inputMap.get('etat'));
        contrat.order_id = 'test';
        contrat.commentaire =String.valueof(inputMap.get('commentaire'));

        SM_WRP002_AddContrat.RequestAddContrat inputRequest = new SM_WRP002_AddContrat.RequestAddContrat();
        inputRequest.contrat = contrat;
        inputRequest.idConsomateur = 'smile';
        
        return inputRequest;
    }
    
    /**
     * @author Unknown
     * @date 19/04/2022
     * @description Build body payload for Offers Availables  API
     * @param numeroRue Input parameters for numeroRue
     * @param rue Input parameters for rue
     * @param codepostal Input parameters for codepostal
     * @param commune Input parameters for commune
     * @param complement Input parameters for complement
     * @param batiment Input parameters for batiment
     * @param bpclient parameters for bpclient
     * @param canal Input parameters for canal
     * @return SM_WRP001_AddContrat.RequestOffreAvailables Body Payload wrapper for Offers Availables API
     */
    public static SM_WRP001_AddContrat.RequestOffreAvailables buildOffresAvailablesBody(String numeroRue, String rue, String codepostal, String commune, String complement, String batiment, String bpclient, String canal) {
        
        //Request Body
        //Local Assure
        SM_WRP001_AddContrat.localAssure localAssure = new SM_WRP001_AddContrat.localAssure();
        localAssure.numRue = numeroRue;
        localAssure.rue = rue;
        localAssure.codePostal = codepostal;
        localAssure.commune = commune;
        localAssure.pays = 'FR';

        //Request 
        SM_WRP001_AddContrat.RequestOffreAvailables requestOffre = new SM_WRP001_AddContrat.RequestOffreAvailables();	
        requestOffre.localAssure = localAssure;	
        requestOffre.idConsomateur = 'smile';	
        requestOffre.bpClient = bpClient;	
        requestOffre.bpConseiller=Integer.Valueof(conseiller.SAP_Identifier__c);	
        requestOffre.canal=canal;	  

        return requestOffre;
    }
    
    /**
     * @author Unknown
     * @date 19/04/2022
     * @description Call the Contracts Get By Adresse API
     * @param inputMap Input parameters
     * @return Map<String, Object> Results from the API Call
     */
    public static Map<String, Object> getContractsByAdress(Map<String, Object> inputMap) {
        SM_WRP001_AddContrat.RequestOffre inputRequest = buildContratBody(inputMap);
        return SM_WS107_TranquilityContractsGetByAdress.getByAdresse(inputRequest);
        }

    /**
     * @author Unknown
     * @date 19/04/2022
     * @description Call the Add Contracts API
     * @param inputMap Input parameters
     * @return Map<String, Object> Results from the API Call
     */
    public static Map<String, Object> addContrat(Map<String, Object> inputMap) {                
        SM_WRP001_AddContrat.RequestAddContrat inputRequest = buildAddContratBody(inputMap);
        return SM_WS108_TranquilityContractsAdd.addContrat(inputRequest);
    }

    /**
     * @author Unknown
     * @date 19/04/2022
     * @description Call the Add Contracts Detection Projet API
     * @param inputMap Input parameters
     * @return Map<String, Object> Results from the API Call
     */
    public static Map<String, Object> addContratDetectionProjet(Map<String, Object> inputMap) {                
        SM_WRP002_AddContrat.RequestAddContrat inputRequest = buildAddContratDetectionProjetBody(inputMap);
        return SM_WS108_TranquilityContractsAdd.addContratDetectionProjet(inputRequest);
    }
    
    /**
     * @author Unknown
     * @date 19/04/2022
     * @description Call the Offers Available API
     * @param numeroRue Input parameters for numeroRue
     * @param rue Input parameters for rue
     * @param codepostal Input parameters for codepostal
     * @param commune Input parameters for commune
     * @param complement Input parameters for complement
     * @param batiment Input parameters for batiment
     * @param bpclient parameters for bpclient
     * @param canal Input parameters for canal
     * @return Map<String, Object> Results from the API Call
     */
    public static Map<String, Object> getOffresAvailables(String numeroRue, String rue, String codepostal, String commune, String complement, String batiment, String bpclient, String canal){
        SM_WRP001_AddContrat.RequestOffreAvailables inputRequest = buildOffresAvailablesBody(numeroRue, rue, codepostal, commune, complement, batiment, bpclient, canal);
        return SM_WS109_TranquilityOffersGetAvailables.getAvailableOffers(inputRequest);
    }
}