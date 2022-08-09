/*
*@Auhtor: Paul Ghoussoub
*@Description: Classe Mock de VI_SM014_OffresEtPrix
*@CreatedDate: 12/11/2020
*/
public class VI_SM014_OffresEtPrix_Mock implements WebServiceMock{
	public void doInvoke(
			Object stub,
			Object request,
			Map<String, Object> response,
			String endpoint,
			String soapAction,
			String requestName,
			String responseNS,
			String responseName,
			String responseType) {
		System.debug(LoggingLevel.INFO, 'gdfsuezBefCalypsoPrixetremisesV1MockImpl.doInvoke() - ' +
			'\n request: ' + request +
			'\n response: ' + response +
			'\n endpoint: ' + endpoint +
			'\n soapAction: ' + soapAction +
			'\n requestName: ' + requestName +
			'\n responseNS: ' + responseNS +
			'\n responseName: ' + responseName +
			'\n responseType: ' + responseType);
		if(request instanceOf gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemises_element) {
		   gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesResponse_element response_x = new gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesResponse_element();
		   response_x.rechercherPrixEtRemisesOutput = new List<gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesOutputDt>();
             // créer cle prix
               gdfsuezComBefChpCommunV3.listeValeursDt clePrix = new gdfsuezComBefChpCommunV3.listeValeursDt();
               clePrix.code = 'EBNAUHA1DB';
               clePrix.libelleCourt ='GDF_NOF_MP_EBUA2';
               // créer type prix TOTCO
               gdfsuezComBefChpCommunV3.listeValeursDt typePrixTOTCO = new gdfsuezComBefChpCommunV3.listeValeursDt();
               typePrixTOTCO.code = 'TOTCO';
               typePrixTOTCO.libelleCourt ='Total consommation';
                // créer type prix TOTAB
               gdfsuezComBefChpCommunV3.listeValeursDt typePrixTOTAB = new gdfsuezComBefChpCommunV3.listeValeursDt();
               typePrixTOTAB.code = 'TOTAB';
               typePrixTOTAB.libelleCourt ='Total abonnement';
            // créer type prix AB
               gdfsuezComBefChpCommunV3.listeValeursDt typePrixAB = new gdfsuezComBefChpCommunV3.listeValeursDt();
               typePrixAB.code = 'AB';
               typePrixAB.libelleCourt ='Total abonnement';
            // créer type prix CO
               gdfsuezComBefChpCommunV3.listeValeursDt typePrixCO = new gdfsuezComBefChpCommunV3.listeValeursDt();
               typePrixCO.code = 'CO';
               typePrixCO.libelleCourt ='Total abonnement';
               // créer versionUtilisation
               gdfsuezComBefChpCommunV3.listeValeursDt versionUtilisation = new gdfsuezComBefChpCommunV3.listeValeursDt();
               versionUtilisation.code = 'D';
               versionUtilisation.libelleCourt ='Moyenne avec Diff. Temporelle';
               // créer puissance
               gdfsuezComBefChpCommunV3.listeValeursDt puissance = new gdfsuezComBefChpCommunV3.listeValeursDt();
               puissance.code = '6';
               puissance.libelleCourt ='6 KVA';
               // créer typeComptage
               gdfsuezComBefChpCommunV3.listeValeursDt typeComptage = new gdfsuezComBefChpCommunV3.listeValeursDt();
               typeComptage.code = 'C';
               typeComptage.libelleCourt ='Comptage Heures Creuses';
            // créer FormuleTarifaire
               gdfsuezComBefChpCommunV3.listeValeursDt formuleTarifaireAcheminement = new gdfsuezComBefChpCommunV3.listeValeursDt();
               formuleTarifaireAcheminement.code = '5353';
               formuleTarifaireAcheminement.libelleCourt ='Formule Tarifaire';
               // créer une carac Elec TOTCO pour l'offre ELEC
               gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt caratElecTOTCO = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
               caratElecTOTCO.typePrix = typePrixTOTCO;
               caratElecTOTCO.versionUtilisation = versionUtilisation;
               caratElecTOTCO.puissance = puissance;
               caratElecTOTCO.typeComptage = typeComptage;
               caratElecTOTCO.CAEElec = 0000001836;
            // créer une carac Elec AB pour l'offre ELEC
               gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt caratElecAB = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
               caratElecAB.typePrix = typePrixAB;
               caratElecAB.versionUtilisation = versionUtilisation;
               caratElecAB.puissance = puissance;
               caratElecAB.typeComptage = typeComptage;
               caratElecAB.CAEElec = 0000001836;
            // créer une carac Elec CO pour l'offre ELEC
               gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt caratElecCO = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
               caratElecCO.typePrix = typePrixCO;
               caratElecCO.versionUtilisation = versionUtilisation;
               caratElecCO.puissance = puissance;
               caratElecCO.typeComptage = typeComptage;
               caratElecCO.CAEElec = 0000001836;
            // créer une carac Elec TOTAB pour l'offre ELEC
            gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt caratElecTOTAB = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
               caratElecTOTAB.typePrix = typePrixTOTAB;
               caratElecTOTAB.versionUtilisation = versionUtilisation;
               caratElecTOTAB.puissance = puissance;
               caratElecTOTAB.typeComptage = typeComptage;
               caratElecTOTAB.CAEElec = 0000001836;
            // créer une carac Gaz AB pour l'offre GAZ
               gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt caratGazAB = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt();
               caratGazAB.typePrix = typePrixAB;
               caratGazAB.CAEGaz = 0000001836;
            caratGazAB.plageconsommation = typePrixAB;
             // créer une carac Gaz CO pour l'offre GAZ
               gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt caratGazTOTCO = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt();
               caratGazTOTCO.typePrix = typePrixCO;
               caratGazTOTCO.CAEGaz = 0000001836;
            caratGazTOTCO.plageconsommation = typePrixCO;
               // créer une liste des prix TOCO pour l'offre ELEC
               gdfsuezBefCalypsoPrixetremisesV2.prixDt TOTCOElec = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
               TOTCOElec.clePrix = clePrix;
               TOTCOElec.dateDebutValiditePrix =(DateTime)JSON.deserialize('"2020-02-01T00:00:00.0"', DateTime.class);
                  // Datetime.valueOf('2020-02-01T00:00:00.0'); 
               TOTCOElec.montantHT = 0.109590160;
               TOTCOElec.montantTTC = 0.16998319;
               TOTCOElec.tauxTVA = 55.105000000000004;
              TOTCOElec.caracteristiquesElec = caratElecTOTCO;
                 // créer une liste des prix TOTAB pour l'offre ELEC 
               gdfsuezBefCalypsoPrixetremisesV2.prixDt TOTABElec = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
               TOTABElec.clePrix = clePrix;
            TOTABElec.dateDebutValiditePrix =(DateTime)JSON.deserialize('"2020-02-01T00:00:00.0"', DateTime.class);
             //  TOTAB.dateDebutValiditePrix =Datetime.valueOf('2020-02-01T00:00:00.0'); 
               TOTABElec.montantHT = 97.32000000;
               TOTABElec.montantTTC = 121.36362144;
               TOTABElec.tauxTVA = 24.706;
               TOTABElec.caracteristiquesElec = caratElecTOTAB;
             gdfsuezBefCalypsoPrixetremisesV2.prixDt prixABGaz = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
               prixABGaz.clePrix = clePrix;
            prixABGaz.dateDebutValiditePrix =(DateTime)JSON.deserialize('"2020-02-01T00:00:00.0"', DateTime.class);
             //  TOTAB.dateDebutValiditePrix =Datetime.valueOf('2020-02-01T00:00:00.0'); 
               prixABGaz.montantHT = 97.32000000;
               prixABGaz.montantTTC = 121.36362144;
               prixABGaz.tauxTVA = 24.706;
           		prixABGaz.caracteristiquesGaz = caratGazAB;
             gdfsuezBefCalypsoPrixetremisesV2.prixDt prixCOGaz = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
               prixCOGaz.clePrix = clePrix;
            prixCOGaz.dateDebutValiditePrix =(DateTime)JSON.deserialize('"2020-02-01T00:00:00.0"', DateTime.class);
             //  TOTAB.dateDebutValiditePrix =Datetime.valueOf('2020-02-01T00:00:00.0'); 
               prixCOGaz.montantHT = 97.32000000;
               prixCOGaz.montantTTC = 121.36362144;
               prixCOGaz.tauxTVA = 24.706;
            prixCOGaz.caracteristiquesGaz = caratGazTOTCO;
             gdfsuezBefCalypsoPrixetremisesV2.prixDt prixABElec = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
               prixABElec.clePrix = clePrix;
            prixABElec.dateDebutValiditePrix =(DateTime)JSON.deserialize('"2020-02-01T00:00:00.0"', DateTime.class);
             //  TOTAB.dateDebutValiditePrix =Datetime.valueOf('2020-02-01T00:00:00.0'); 
               prixABElec.montantHT = 97.32000000;
               prixABElec.montantTTC = 121.36362144;
               prixABElec.tauxTVA = 24.706;
           		prixABElec.caracteristiquesElec = caratElecAB;
             gdfsuezBefCalypsoPrixetremisesV2.prixDt prixCOElec= new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
               prixCOElec.clePrix = clePrix;
            prixCOElec.dateDebutValiditePrix =(DateTime)JSON.deserialize('"2020-02-01T00:00:00.0"', DateTime.class);
             //  TOTAB.dateDebutValiditePrix =Datetime.valueOf('2020-02-01T00:00:00.0'); 
               prixCOElec.montantHT = 97.32000000;
               prixCOElec.montantTTC = 121.36362144;
               prixCOElec.tauxTVA = 24.706;
            prixCOElec.caracteristiquesElec = caratElecCO;
               // créer la liste des Prix
               gdfsuezBefCalypsoPrixetremisesV2.prixDt[] listPrix = new List<gdfsuezBefCalypsoPrixetremisesV2.prixDt>();
               listPrix.add(TOTABElec);
               listPrix.add(TOTCOElec);
            listPrix.add(prixABGaz);
            listPrix.add(prixCOGaz);
            listPrix.add(prixCOElec);
            listPrix.add(prixABElec);
                // à jouter les prix à la liste des prix             
              gdfsuezBefCalypsoPrixetremisesV2.listePrixDt prixDt = new gdfsuezBefCalypsoPrixetremisesV2.listePrixDt();
              prixDt.prix =  listPrix;
               // créer une liste des offres
           gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt elecDGBUEBUVR3 = new gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt();
           elecDGBUEBUVR3.idOffre = 'DGBUEBUKF2VGO_P';
           elecDGBUEBUVR3.libelleOffre = 'Référence Duo Elec verte et Gaz 3 ans'; 
           elecDGBUEBUVR3.listePrix = prixDt;
           elecDGBUEBUVR3.listeRemises = null;
           elecDGBUEBUVR3.secteurActivite = null;  
           elecDGBUEBUVR3.formuleTarifaireAcheminement = formuleTarifaireAcheminement;
           gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt gazDGBUEBUF3AK = new gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt();
           gazDGBUEBUF3AK.idOffre = 'DGBUEBUKF3VGO_P';
           gazDGBUEBUF3AK.libelleOffre = 'Duo Ajust 3 ans'; 
           gazDGBUEBUF3AK.listePrix = prixDt;
           gazDGBUEBUF3AK.listeRemises = null;
           gazDGBUEBUF3AK.secteurActivite = null;  
           gazDGBUEBUF3AK.formuleTarifaireAcheminement = null; 
               // créer données pack
           gdfsuezBefCalypsoPrixetremisesV2.donneesPackDt donneesPack1 = new gdfsuezBefCalypsoPrixetremisesV2.donneesPackDt();
           donneesPack1.idPack = 'DGBUEBUKF2VGO_P';
           donneesPack1.libellePack = 'Référence Duo Elec verte et Gaz 3 ans';
           donneesPack1.listeRemises = null;
              // créer la liste des prix et remises
           gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesOutputDt offreElect1 = new gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesOutputDt();
           offreElect1.donneesPack = donneesPack1;
           offreElect1.donneesOffre = new List<gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt>{elecDGBUEBUVR3} ; 
               // créer données pack
           gdfsuezBefCalypsoPrixetremisesV2.donneesPackDt donneesPack2 = new gdfsuezBefCalypsoPrixetremisesV2.donneesPackDt();
           donneesPack2.idPack = 'DGBUEBUKF3VGO_P';
           donneesPack2.libellePack = 'Duo Ajust 3 ans';
           donneesPack2.listeRemises = null;
              // créer la liste des prix et remises
           gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesOutputDt offreGaz = new gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesOutputDt();
           offreGaz.donneesPack = donneesPack2;
           offreGaz.donneesOffre = new List<gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt>{gazDGBUEBUF3AK} ;     
             // remplir la liste des prix et remises
           response_x.rechercherPrixEtRemisesOutput.add(offreElect1); 
            response_x.rechercherPrixEtRemisesOutput.add(offreGaz); 
		   // gdfsuezBefCalypsoPrixetremisesV1.rechercherPrixEtRemisesOutputDt outputDT=new gdfsuezBefCalypsoPrixetremisesV1.rechercherPrixEtRemisesOutputDt();
			response.put( 'response_x', response_x);
		}
		else if(request instanceOf gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesServices_element) {
			response.put( 'response_x', new gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesServicesResponse_element());
		}
	}
}