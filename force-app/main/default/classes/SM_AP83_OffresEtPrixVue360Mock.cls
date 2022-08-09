/**
 * @Author: LIK
 * @Description: Mock pour SM_AP83_OffresEtPrixVue360
 * @CreatedDate: LIK 08/04/2020
 */
@isTest
public class SM_AP83_OffresEtPrixVue360Mock implements WebServiceMock {
    private String type_offre;

    public SM_AP83_OffresEtPrixVue360Mock(String type_offre){
        this.type_offre = type_offre;
    }
        
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
            
            if (this.TYPE_OFFRE == 'Gaz') {
                /****TYPE REMISES****/
                gdfsuezComBefChpCommunV3.listeValeursDt typeRemise_REM_OS_OS = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typeRemise_REM_OS_OS.code = 'REM_OS_S';
                typeRemise_REM_OS_OS.libelleCourt = 'remise OS structurelle';
                typeRemise_REM_OS_OS.description = 'PAS DE REMISE';
                gdfsuezComBefChpCommunV3.listeValeursDt typeRemise_REM_OS_P = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typeRemise_REM_OS_P.code = 'REM_OS_P';
                typeRemise_REM_OS_P.libelleCourt = 'remise OS promotionnelle';
                typeRemise_REM_OS_P.description = 'PAS DE REMISE';
                gdfsuezComBefChpCommunV3.listeValeursDt typeRemise_REM_OS_E = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typeRemise_REM_OS_E.code = 'REM_OS_E';
                typeRemise_REM_OS_E.libelleCourt = 'remise OS enseigne';
                typeRemise_REM_OS_E.description = 'PAS DE REMISE';
                gdfsuezComBefChpCommunV3.listeValeursDt typeRemise_REC = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typeRemise_REC.code = 'REM_REC';
                typeRemise_REC.libelleCourt = 'remise récurrente';
                typeRemise_REC.description = 'PAS DE REMISE';
                gdfsuezComBefChpCommunV3.listeValeursDt typeRemise_REC_S = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typeRemise_REC_S.code = 'REM_REC_S';
                typeRemise_REC_S.libelleCourt = 'remise récurrente structurelle pour les services récurrents';
                typeRemise_REC_S.description = 'PAS DE REMISE';
                gdfsuezComBefChpCommunV3.listeValeursDt typeRemise_REC_P = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typeRemise_REC_P.code = 'REM_REC_P';
                typeRemise_REC_P.libelleCourt = 'remise récurrente promotionnelle pour les services récurrents';
                typeRemise_REC_P.description = 'PAS DE REMISE';
                
                /****TYPE PRIX****/
                gdfsuezComBefChpCommunV3.listeValeursDt typePrix_AB = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typePrix_AB.code = 'AB';
                typePrix_AB.libelleCourt = 'Abonnement';
                gdfsuezComBefChpCommunV3.listeValeursDt typePrix_ACHAB = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typePrix_ACHAB.code = 'ACHAB';
                typePrix_ACHAB.libelleCourt = 'Abonnement';
                gdfsuezComBefChpCommunV3.listeValeursDt typePrix_ACHCO = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typePrix_ACHCO.code = 'ACHCO';
                typePrix_ACHCO.libelleCourt = 'Acheminement consommation';
                gdfsuezComBefChpCommunV3.listeValeursDt typePrix_CO = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typePrix_CO.code = 'CO';
                typePrix_CO.libelleCourt = 'Consommation';
                gdfsuezComBefChpCommunV3.listeValeursDt typePrix_OB = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typePrix_OB.code = 'OB';
                typePrix_OB.libelleCourt = 'Obligations';
                gdfsuezComBefChpCommunV3.listeValeursDt typePrix_TOTAB = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typePrix_TOTAB.code = 'TOTAB';
                typePrix_TOTAB.libelleCourt = 'Total abonnement';
                gdfsuezComBefChpCommunV3.listeValeursDt typePrix_TOTCO = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typePrix_TOTCO.code = 'TOTCO';
                typePrix_TOTCO.libelleCourt = 'Total consommation';

                
                /****APPLICATION****/
                gdfsuezComBefChpCommunV3.listeValeursDt application_NU = new gdfsuezComBefChpCommunV3.listeValeursDt();
                application_NU.code = 'NU';
                application_NU.libelleCourt = 'Nu';
                
                /****CLE PRIX****/
                gdfsuezComBefChpCommunV3.listeValeursDt clePrix_TESTTO0535 = new gdfsuezComBefChpCommunV3.listeValeursDt();
                clePrix_TESTTO0535.code = 'TESTTO0535';
                clePrix_TESTTO0535.libelleCourt = 'GDF_NOF_MP_GBUGR1';
                gdfsuezComBefChpCommunV3.listeValeursDt clePrix_G1LPDST1AB = new gdfsuezComBefChpCommunV3.listeValeursDt();
                clePrix_G1LPDST1AB.code = 'G1LPDST1AB';
                clePrix_G1LPDST1AB.libelleCourt = 'Dist ABO T1 PRIX';
                gdfsuezComBefChpCommunV3.listeValeursDt clePrix_G1QPDST1CO = new gdfsuezComBefChpCommunV3.listeValeursDt();
                clePrix_G1QPDST1CO.code = 'G1QPDST1CO';
                clePrix_G1QPDST1CO.libelleCourt = 'Dist Conso T1 PRIX';
                gdfsuezComBefChpCommunV3.listeValeursDt clePrix_TESTTO0532 = new gdfsuezComBefChpCommunV3.listeValeursDt();
                clePrix_TESTTO0532.code = 'TESTTO0532';
                clePrix_TESTTO0532.libelleCourt = 'GDF_NOF_MP_GBUGR1';
                gdfsuezComBefChpCommunV3.listeValeursDt clePrix_G1PDRP = new gdfsuezComBefChpCommunV3.listeValeursDt();
                clePrix_G1PDRP.code = 'G1PDRP';
                gdfsuezComBefChpCommunV3.listeValeursDt clePrix_GOBL000001 = new gdfsuezComBefChpCommunV3.listeValeursDt();
                clePrix_GOBL000001.code = 'GOBL000001';
                clePrix_GOBL000001.libelleCourt = 'Prix Obligations 6000kWh 01/08';
                gdfsuezComBefChpCommunV3.listeValeursDt clePrix_GOBL000073 = new gdfsuezComBefChpCommunV3.listeValeursDt();
                clePrix_GOBL000073.code = 'GOBL000073';
                clePrix_GOBL000073.libelleCourt = 'Plafond Obligations 6000kWh 01';

                /****DONNEES PACK****/
                // REMISE 1
                gdfsuezBefCalypsoPrixetremisesV2.remiseDt remise_DP_1 = new gdfsuezBefCalypsoPrixetremisesV2.remiseDt();
                remise_DP_1.pourcentageRemise = '0';
                remise_DP_1.duree = '0';
                remise_DP_1.tauxTVA = Double.valueOf(0.00);
                remise_DP_1.montantHT = Double.valueOf(0.00);
                remise_DP_1.montantTTC = Double.valueOf(0.00);
                remise_DP_1.typeRemise = typeRemise_REM_OS_OS;
                // REMISE 2
                gdfsuezBefCalypsoPrixetremisesV2.remiseDt remise_DP_2 = new gdfsuezBefCalypsoPrixetremisesV2.remiseDt();
                remise_DP_2.pourcentageRemise = '0';
                remise_DP_2.duree = '0';
                remise_DP_2.tauxTVA = Double.valueOf(0.00);
                remise_DP_2.montantHT = Double.valueOf(0.00);
                remise_DP_2.montantTTC = Double.valueOf(0.00);
                remise_DP_2.typeRemise = typeRemise_REM_OS_P;
                // REMISE 3
                gdfsuezBefCalypsoPrixetremisesV2.remiseDt remise_DP_3 = new gdfsuezBefCalypsoPrixetremisesV2.remiseDt();
                remise_DP_3.pourcentageRemise = '0';
                remise_DP_3.duree = '0';
                remise_DP_3.tauxTVA = Double.valueOf(0.00);
                remise_DP_3.montantHT = Double.valueOf(0.00);
                remise_DP_3.montantTTC = Double.valueOf(0.00);
                remise_DP_3.typeRemise = typeRemise_REM_OS_E;
                // LISTE REMISE
                gdfsuezBefCalypsoPrixetremisesV2.listeRemisesDt listeRemises_DP = new gdfsuezBefCalypsoPrixetremisesV2.listeRemisesDt();
                listeRemises_DP.remise = new List<gdfsuezBefCalypsoPrixetremisesV2.remiseDt>();
                listeRemises_DP.remise.add(remise_DP_1);
                listeRemises_DP.remise.add(remise_DP_2);
                listeRemises_DP.remise.add(remise_DP_3);
                // DONNEES PACK            
                gdfsuezBefCalypsoPrixetremisesV2.donneesPackDt donneesPack = new gdfsuezBefCalypsoPrixetremisesV2.donneesPackDt();
                donneesPack.idPack = 'GBUGR1_P';
                donneesPack.libellePack = 'Référence Gaz 1 an';
                donneesPack.listeRemises = listeRemises_DP;


                /****DONNEES OFFRE****/
                // REMISE 1
                gdfsuezBefCalypsoPrixetremisesV2.remiseDt remise_DO_1 = new gdfsuezBefCalypsoPrixetremisesV2.remiseDt();
                remise_DO_1.pourcentageRemise = '0';
                remise_DO_1.natureRemise = 'PAS DE REMISE';
                remise_DO_1.duree = '0';
                remise_DO_1.tauxTVA = Double.valueOf(0.00);
                remise_DO_1.montantHT = Double.valueOf(0.00);
                remise_DO_1.montantTTC = Double.valueOf(0.00);
                remise_DO_1.typeRemise = typeRemise_REC_S;
                remise_DO_1.applicationRemise = application_NU;
                // REMISE 2
                gdfsuezBefCalypsoPrixetremisesV2.remiseDt remise_DO_2 = new gdfsuezBefCalypsoPrixetremisesV2.remiseDt();
                remise_DO_2.pourcentageRemise = '0';
                remise_DO_2.natureRemise = 'PAS DE REMISE';
                remise_DO_2.duree = '0';
                remise_DO_2.tauxTVA = Double.valueOf(0.00);
                remise_DO_2.montantHT = Double.valueOf(0.00);
                remise_DO_2.montantTTC = Double.valueOf(0.00);
                remise_DO_2.typeRemise = typeRemise_REC_S;
                remise_DO_2.applicationRemise = application_NU;
                // REMISE 3
                gdfsuezBefCalypsoPrixetremisesV2.remiseDt remise_DO_3 = new gdfsuezBefCalypsoPrixetremisesV2.remiseDt();
                remise_DO_3.pourcentageRemise = '0';
                remise_DO_3.natureRemise = 'PAS DE REMISE';
                remise_DO_3.duree = '0';
                remise_DO_3.tauxTVA = Double.valueOf(0.00);
                remise_DO_3.montantHT = Double.valueOf(0.00);
                remise_DO_3.montantTTC = Double.valueOf(0.00);
                remise_DO_3.typeRemise = typeRemise_REC_P;
                remise_DO_3.applicationRemise = application_NU;
                // LISTE REMISE
                gdfsuezBefCalypsoPrixetremisesV2.listeRemisesDt listeRemises_DO = new gdfsuezBefCalypsoPrixetremisesV2.listeRemisesDt();
                listeRemises_DO.remise = new List<gdfsuezBefCalypsoPrixetremisesV2.remiseDt>();
                listeRemises_DO.remise.add(remise_DO_1);
                listeRemises_DO.remise.add(remise_DO_2);
                listeRemises_DO.remise.add(remise_DO_3);
                // PRIX 1 
                gdfsuezBefCalypsoPrixetremisesV2.prixDt prix1 = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
                prix1.clePrix = clePrix_TESTTO0535;
                prix1.dateDebutValiditePrix = DateTime.valueOf('2019-08-01 00:00:00');
                prix1.dateFinValiditePrix = DateTime.valueOf('9999-12-31 00:00:00');
                prix1.montantHT = Double.valueOf(35.75000000);
                prix1.montantTTC = Double.valueOf(37.71625000);
                prix1.tauxTVA = Double.valueOf(5.5);
                prix1.caracteristiquesElec = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                prix1.caracteristiquesElec.CAEElec = Integer.valueOf('0000000000');
                prix1.caracteristiquesGaz = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt();
                prix1.caracteristiquesGaz.typePrix = typePrix_AB;
                prix1.caracteristiquesGaz.plageConsommation = new gdfsuezComBefChpCommunV3.listeValeursDt();
                prix1.caracteristiquesGaz.plageConsommation.code = '6000';
                prix1.caracteristiquesGaz.plageConsommation.libelleCourt = '0 à 6000 kWh';
                // PRIX 2 
                gdfsuezBefCalypsoPrixetremisesV2.prixDt prix2 = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
                prix2.clePrix = clePrix_G1LPDST1AB;
                prix2.dateDebutValiditePrix = DateTime.valueOf('2000-01-04 00:00:00');
                prix2.dateFinValiditePrix = DateTime.valueOf('9999-12-31 00:00:00');
                prix2.montantHT = Double.valueOf(41.64000000);
                prix2.montantTTC = Double.valueOf(54.36708420);
                prix2.tauxTVA = Double.valueOf(30.564999999999998);
                prix2.caracteristiquesElec = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                prix2.caracteristiquesElec.CAEElec = Integer.valueOf('0000000000');
                prix2.caracteristiquesGaz = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt();
                prix2.caracteristiquesGaz.typePrix = typePrix_ACHAB;
                prix2.caracteristiquesGaz.plageConsommation = new gdfsuezComBefChpCommunV3.listeValeursDt();
                prix2.caracteristiquesGaz.plageConsommation.code = '6000';
                prix2.caracteristiquesGaz.plageConsommation.libelleCourt = '0 à 6000 kWh';
                // PRIX 3
                gdfsuezBefCalypsoPrixetremisesV2.prixDt prix3 = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
                prix3.clePrix = clePrix_G1QPDST1CO;
                prix3.dateDebutValiditePrix = DateTime.valueOf('2000-01-04 00:00:00');
                prix3.dateFinValiditePrix = DateTime.valueOf('9999-12-31 00:00:00');
                prix3.montantHT = Double.valueOf(0.02885000);
                prix3.montantTTC = Double.valueOf(0.03462000);
                prix3.tauxTVA = Double.valueOf(20.0);
                prix3.caracteristiquesElec = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                prix3.caracteristiquesElec.CAEElec = Integer.valueOf('0000000000');
                prix3.caracteristiquesGaz = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt();
                prix3.caracteristiquesGaz.typePrix = typePrix_ACHAB;
                prix3.caracteristiquesGaz.plageConsommation = new gdfsuezComBefChpCommunV3.listeValeursDt();
                prix3.caracteristiquesGaz.plageConsommation.code = '6000';
                prix3.caracteristiquesGaz.plageConsommation.libelleCourt = '0 à 6000 kWh';
                // PRIX 4
                gdfsuezBefCalypsoPrixetremisesV2.prixDt prix4 = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
                prix4.clePrix = clePrix_TESTTO0532;
                prix4.dateDebutValiditePrix = DateTime.valueOf('2019-08-01 00:00:00');
                prix4.dateFinValiditePrix = DateTime.valueOf('9999-12-31 00:00:00');
                prix4.montantHT = Double.valueOf(0.01414000);
                prix4.montantTTC = Double.valueOf(0.02710800);
                prix4.tauxTVA = Double.valueOf(91.726);
                prix4.caracteristiquesElec = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                prix4.caracteristiquesElec.CAEElec = Integer.valueOf('0000000000');
                prix4.caracteristiquesGaz = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt();
                prix4.caracteristiquesGaz.typePrix = typePrix_CO;
                prix4.caracteristiquesGaz.plageConsommation = new gdfsuezComBefChpCommunV3.listeValeursDt();
                prix4.caracteristiquesGaz.plageConsommation.code = '6000';
                prix4.caracteristiquesGaz.plageConsommation.libelleCourt = '0 à 6000 kWh';
                // PRIX 5
                gdfsuezBefCalypsoPrixetremisesV2.prixDt prix5 = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
                prix5.clePrix = clePrix_GOBL000001;
                prix5.dateDebutValiditePrix = DateTime.valueOf('2019-08-01 00:00:00');
                prix5.dateFinValiditePrix = DateTime.valueOf('9999-12-31 00:00:00');
                prix5.montantHT = Double.valueOf(0.01414000);
                prix5.montantTTC = Double.valueOf(0.02710800);
                prix5.tauxTVA = Double.valueOf(91.726);
                prix5.caracteristiquesElec = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                prix5.caracteristiquesElec.CAEElec = Integer.valueOf('0000000000');
                prix5.caracteristiquesGaz = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt();
                prix5.caracteristiquesGaz.typePrix = typePrix_OB;
                prix5.caracteristiquesGaz.plageConsommation = new gdfsuezComBefChpCommunV3.listeValeursDt();
                prix5.caracteristiquesGaz.plageConsommation.code = '6000';
                prix5.caracteristiquesGaz.plageConsommation.libelleCourt = '0 à 6000 kWh';
                // PRIX 6
                gdfsuezBefCalypsoPrixetremisesV2.prixDt prix6 = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
                prix6.dateDebutValiditePrix = DateTime.valueOf('2019-08-01 00:00:00');
                prix6.dateFinValiditePrix = DateTime.valueOf('9999-12-31 00:00:00');
                prix6.montantHT = Double.valueOf(0.01414000);
                prix6.montantTTC = Double.valueOf(0.02710800);
                prix6.tauxTVA = Double.valueOf(91.726);
                prix6.caracteristiquesElec = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                prix6.caracteristiquesElec.CAEElec = Integer.valueOf('0000000000');
                prix6.caracteristiquesGaz = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt();
                prix6.caracteristiquesGaz.typePrix = typePrix_TOTAB;
                prix6.caracteristiquesGaz.plageConsommation = new gdfsuezComBefChpCommunV3.listeValeursDt();
                prix6.caracteristiquesGaz.plageConsommation.code = '6000';
                prix6.caracteristiquesGaz.plageConsommation.libelleCourt = '0 à 6000 kWh';
                // PRIX 7
                gdfsuezBefCalypsoPrixetremisesV2.prixDt prix7 = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
                prix7.dateDebutValiditePrix = DateTime.valueOf('2019-08-01 00:00:00');
                prix7.dateFinValiditePrix = DateTime.valueOf('9999-12-31 00:00:00');
                prix7.montantHT = Double.valueOf(0.01414000);
                prix7.montantTTC = Double.valueOf(0.02710800);
                prix7.tauxTVA = Double.valueOf(91.726);
                prix7.caracteristiquesElec = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                prix7.caracteristiquesElec.CAEElec = Integer.valueOf('0000000000');
                prix7.caracteristiquesGaz = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt();
                prix7.caracteristiquesGaz.typePrix = typePrix_TOTCO;
                prix7.caracteristiquesGaz.plageConsommation = new gdfsuezComBefChpCommunV3.listeValeursDt();
                prix7.caracteristiquesGaz.plageConsommation.code = '6000';
                prix7.caracteristiquesGaz.plageConsommation.libelleCourt = '0 à 6000 kWh';
                // PRIX 7
                gdfsuezBefCalypsoPrixetremisesV2.prixDt prix8 = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
                prix8.dateDebutValiditePrix = DateTime.valueOf('2019-08-01 00:00:00');
                prix8.dateFinValiditePrix = DateTime.valueOf('9999-12-31 00:00:00');
                prix8.montantHT = Double.valueOf(0.01414000);
                prix8.montantTTC = Double.valueOf(0.02710800);
                prix8.tauxTVA = Double.valueOf(91.726);
                prix8.caracteristiquesElec = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                prix8.caracteristiquesElec.CAEElec = Integer.valueOf('0000000000');
                prix8.caracteristiquesGaz = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt();
                prix8.caracteristiquesGaz.typePrix = typePrix_ACHCO;
                prix8.caracteristiquesGaz.plageConsommation = new gdfsuezComBefChpCommunV3.listeValeursDt();
                prix8.caracteristiquesGaz.plageConsommation.code = '6000';
                prix8.caracteristiquesGaz.plageConsommation.libelleCourt = '0 à 6000 kWh';
                // LISTE PRIX
                gdfsuezBefCalypsoPrixetremisesV2.listePrixDt listePrix_DO = new gdfsuezBefCalypsoPrixetremisesV2.listePrixDt();
                listePrix_DO.prix = new List<gdfsuezBefCalypsoPrixetremisesV2.prixDt>();
                listePrix_DO.prix.add(prix1);
                listePrix_DO.prix.add(prix2);
                listePrix_DO.prix.add(prix3);
                listePrix_DO.prix.add(prix4);
                listePrix_DO.prix.add(prix5);
                listePrix_DO.prix.add(prix6);
                listePrix_DO.prix.add(prix7);
                listePrix_DO.prix.add(prix8);
                // SECTEUR ACTVITE
                gdfsuezComBefChpCommunV3.listeValeursDt secteurActivite = new gdfsuezComBefChpCommunV3.listeValeursDt();
                secteurActivite.code = '5G';
                secteurActivite.libelleCourt = 'Gaz naturel';
                // DONNEES OFFRE
                gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt donneesOffre = new gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt();
                donneesOffre.idOffre = 'GBUGR1';
                donneesOffre.libelleOffre = 'Référence Gaz 1 an';
                donneesOffre.secteurActivite = secteurActivite;
                donneesOffre.listeRemises = listeRemises_DO;
                donneesOffre.listePrix = listePrix_DO;

                /****OUTPUT****/
                gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesOutputDt output = new gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesOutputDt();
                output.donneesPack = donneesPack;
                output.donneesOffre = new List<gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt>{donneesOffre};

                // remplir la liste des prix et remises
                response_x.rechercherPrixEtRemisesOutput.add(output); 
                // gdfsuezBefCalypsoPrixetremisesV1.rechercherPrixEtRemisesOutputDt outputDT=new gdfsuezBefCalypsoPrixetremisesV1.rechercherPrixEtRemisesOutputDt();
                response.put( 'response_x', response_x);
            } else if (this.TYPE_OFFRE == 'Dual') {
                /****TYPE REMISES****/
                gdfsuezComBefChpCommunV3.listeValeursDt typeRemise_REM_OS_OS = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typeRemise_REM_OS_OS.code = 'REM_OS_S';
                typeRemise_REM_OS_OS.libelleCourt = 'remise OS structurelle';
                typeRemise_REM_OS_OS.description = 'PAS DE REMISE';
                gdfsuezComBefChpCommunV3.listeValeursDt typeRemise_REM_OS_P = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typeRemise_REM_OS_P.code = 'REM_OS_P';
                typeRemise_REM_OS_P.libelleCourt = 'remise OS promotionnelle';
                typeRemise_REM_OS_P.description = 'PAS DE REMISE';
                gdfsuezComBefChpCommunV3.listeValeursDt typeRemise_REM_OS_E = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typeRemise_REM_OS_E.code = 'REM_OS_E';
                typeRemise_REM_OS_E.libelleCourt = 'remise OS enseigne';
                typeRemise_REM_OS_E.description = 'PAS DE REMISE';
                gdfsuezComBefChpCommunV3.listeValeursDt typeRemise_REC = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typeRemise_REC.code = 'REM_REC';
                typeRemise_REC.libelleCourt = 'remise récurrente';
                typeRemise_REC.description = 'PAS DE REMISE';
                gdfsuezComBefChpCommunV3.listeValeursDt typeRemise_REC_S = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typeRemise_REC_S.code = 'REM_REC_S';
                typeRemise_REC_S.libelleCourt = 'remise récurrente structurelle pour les services récurrents';
                typeRemise_REC_S.description = 'PAS DE REMISE';
                gdfsuezComBefChpCommunV3.listeValeursDt typeRemise_REC_P = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typeRemise_REC_P.code = 'REM_REC_P';
                typeRemise_REC_P.libelleCourt = 'remise récurrente promotionnelle pour les services récurrents';
                typeRemise_REC_P.description = 'PAS DE REMISE';
                
                /****TYPE PRIX****/
                gdfsuezComBefChpCommunV3.listeValeursDt typePrix_AB = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typePrix_AB.code = 'AB';
                typePrix_AB.libelleCourt = 'Abonnement';
                gdfsuezComBefChpCommunV3.listeValeursDt typePrix_ACHAB = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typePrix_ACHAB.code = 'ACHAB';
                typePrix_ACHAB.libelleCourt = 'Abonnement';
                gdfsuezComBefChpCommunV3.listeValeursDt typePrix_ACHCO = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typePrix_ACHCO.code = 'ACHCO';
                typePrix_ACHCO.libelleCourt = 'Acheminement consommation';
                gdfsuezComBefChpCommunV3.listeValeursDt typePrix_CO = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typePrix_CO.code = 'CO';
                typePrix_CO.libelleCourt = 'Consommation';
                
                gdfsuezComBefChpCommunV3.listeValeursDt typePrix_CTA = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typePrix_CO.code = 'CTA';
                typePrix_CO.libelleCourt = 'Contribution tarifaire d\'acheminement';

                gdfsuezComBefChpCommunV3.listeValeursDt typePrix_DRP = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typePrix_CO.code = 'DRP';
                typePrix_CO.libelleCourt = 'Date de règlement personnalisée';
                gdfsuezComBefChpCommunV3.listeValeursDt typePrix_OB = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typePrix_OB.code = 'OB';
                typePrix_OB.libelleCourt = 'Obligations';

                gdfsuezComBefChpCommunV3.listeValeursDt typePrix_OM = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typePrix_OB.code = 'OM';
                typePrix_OB.libelleCourt = 'Obligations max';
                gdfsuezComBefChpCommunV3.listeValeursDt typePrix_TOTAB = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typePrix_TOTAB.code = 'TOTAB';
                typePrix_TOTAB.libelleCourt = 'Total abonnement';
                gdfsuezComBefChpCommunV3.listeValeursDt typePrix_TOTCO = new gdfsuezComBefChpCommunV3.listeValeursDt();
                typePrix_TOTCO.code = 'TOTCO';
                typePrix_TOTCO.libelleCourt = 'Total consommation';

                
                /****APPLICATION****/
                gdfsuezComBefChpCommunV3.listeValeursDt application_NU = new gdfsuezComBefChpCommunV3.listeValeursDt();
                application_NU.code = 'NU';
                application_NU.libelleCourt = 'Nu';
                
                /****CLE PRIX****/
                gdfsuezComBefChpCommunV3.listeValeursDt clePrix_GBKPXGA2AB = new gdfsuezComBefChpCommunV3.listeValeursDt();
                clePrix_GBKPXGA2AB.code = 'GBKPXGA2AB';
                clePrix_GBKPXGA2AB.libelleCourt = 'GDF_NOF_MP_GBUGR1';
                gdfsuezComBefChpCommunV3.listeValeursDt clePrix_G1LPDST2AB = new gdfsuezComBefChpCommunV3.listeValeursDt();
                clePrix_G1LPDST2AB.code = 'G1LPDST2AB';
                clePrix_G1LPDST2AB.libelleCourt = 'Dist ABO T2 PRIX';
                gdfsuezComBefChpCommunV3.listeValeursDt clePrix_G1QPDST2CO = new gdfsuezComBefChpCommunV3.listeValeursDt();
                clePrix_G1QPDST2CO.code = 'G1QPDST2CO';
                clePrix_G1QPDST2CO.libelleCourt = 'Dist Conso T2 PRIX';
                gdfsuezComBefChpCommunV3.listeValeursDt clePrix_GBKPXGA2CO = new gdfsuezComBefChpCommunV3.listeValeursDt();
                clePrix_GBKPXGA2CO.code = 'GBKPXGA2CO';
                clePrix_GBKPXGA2CO.libelleCourt = 'GDF_NOF_MP_GBUGR1';
                gdfsuezComBefChpCommunV3.listeValeursDt clePrix_G1PDRP = new gdfsuezComBefChpCommunV3.listeValeursDt();
                clePrix_G1PDRP.code = 'G1PDRP';
                gdfsuezComBefChpCommunV3.listeValeursDt clePrix_GBKPXGB2OB = new gdfsuezComBefChpCommunV3.listeValeursDt();
                clePrix_GBKPXGB2OB.code = 'GBKPXGB2OB';
                clePrix_GBKPXGB2OB.libelleCourt = 'Prix Obligations 30000kWh 01/0';
                gdfsuezComBefChpCommunV3.listeValeursDt clePrix_GBKPXGB2OM = new gdfsuezComBefChpCommunV3.listeValeursDt();
                clePrix_GBKPXGB2OM.code = 'GBKPXGB2OM';
                clePrix_GBKPXGB2OM.libelleCourt = 'Plafond Obligations 30000kWh 0';

                /****DONNEES PACK****/
                // REMISE 1
                gdfsuezBefCalypsoPrixetremisesV2.remiseDt remise_DP_1 = new gdfsuezBefCalypsoPrixetremisesV2.remiseDt();
                remise_DP_1.pourcentageRemise = '0';
                remise_DP_1.duree = '0';
                remise_DP_1.tauxTVA = Double.valueOf(0.00);
                remise_DP_1.montantHT = Double.valueOf(0.00);
                remise_DP_1.montantTTC = Double.valueOf(0.00);
                remise_DP_1.typeRemise = typeRemise_REM_OS_OS;
                // REMISE 2
                gdfsuezBefCalypsoPrixetremisesV2.remiseDt remise_DP_2 = new gdfsuezBefCalypsoPrixetremisesV2.remiseDt();
                remise_DP_2.pourcentageRemise = '0';
                remise_DP_2.duree = '0';
                remise_DP_2.tauxTVA = Double.valueOf(0.00);
                remise_DP_2.montantHT = Double.valueOf(0.00);
                remise_DP_2.montantTTC = Double.valueOf(0.00);
                remise_DP_2.typeRemise = typeRemise_REM_OS_P;
                // REMISE 3
                gdfsuezBefCalypsoPrixetremisesV2.remiseDt remise_DP_3 = new gdfsuezBefCalypsoPrixetremisesV2.remiseDt();
                remise_DP_3.pourcentageRemise = '0';
                remise_DP_3.duree = '0';
                remise_DP_3.tauxTVA = Double.valueOf(0.00);
                remise_DP_3.montantHT = Double.valueOf(0.00);
                remise_DP_3.montantTTC = Double.valueOf(0.00);
                remise_DP_3.typeRemise = typeRemise_REM_OS_E;
                // LISTE REMISE
                gdfsuezBefCalypsoPrixetremisesV2.listeRemisesDt listeRemises_DP = new gdfsuezBefCalypsoPrixetremisesV2.listeRemisesDt();
                listeRemises_DP.remise = new List<gdfsuezBefCalypsoPrixetremisesV2.remiseDt>();
                listeRemises_DP.remise.add(remise_DP_1);
                listeRemises_DP.remise.add(remise_DP_2);
                listeRemises_DP.remise.add(remise_DP_3);
                // DONNEES PACK            
                gdfsuezBefCalypsoPrixetremisesV2.donneesPackDt donneesPack = new gdfsuezBefCalypsoPrixetremisesV2.donneesPackDt();
                donneesPack.idPack = 'DGBUEBUGR1_P';
                donneesPack.libellePack = 'Référence Duo Elec et Gaz 1 an';
                donneesPack.listeRemises = listeRemises_DP;


                /****DONNEES OFFRE****/
                // REMISE 1
                gdfsuezBefCalypsoPrixetremisesV2.remiseDt remise_DO_1 = new gdfsuezBefCalypsoPrixetremisesV2.remiseDt();
                remise_DO_1.pourcentageRemise = '0';
                remise_DO_1.natureRemise = 'PAS DE REMISE';
                remise_DO_1.duree = '0';
                remise_DO_1.tauxTVA = Double.valueOf(0.00);
                remise_DO_1.montantHT = Double.valueOf(0.00);
                remise_DO_1.montantTTC = Double.valueOf(0.00);
                remise_DO_1.typeRemise = typeRemise_REC_S;
                remise_DO_1.applicationRemise = application_NU;
                // REMISE 2
                gdfsuezBefCalypsoPrixetremisesV2.remiseDt remise_DO_2 = new gdfsuezBefCalypsoPrixetremisesV2.remiseDt();
                remise_DO_2.pourcentageRemise = '0';
                remise_DO_2.natureRemise = 'PAS DE REMISE';
                remise_DO_2.duree = '0';
                remise_DO_2.tauxTVA = Double.valueOf(0.00);
                remise_DO_2.montantHT = Double.valueOf(0.00);
                remise_DO_2.montantTTC = Double.valueOf(0.00);
                remise_DO_2.typeRemise = typeRemise_REC_S;
                remise_DO_2.applicationRemise = application_NU;
                // REMISE 3
                gdfsuezBefCalypsoPrixetremisesV2.remiseDt remise_DO_3 = new gdfsuezBefCalypsoPrixetremisesV2.remiseDt();
                remise_DO_3.pourcentageRemise = '0';
                remise_DO_3.natureRemise = 'PAS DE REMISE';
                remise_DO_3.duree = '0';
                remise_DO_3.tauxTVA = Double.valueOf(0.00);
                remise_DO_3.montantHT = Double.valueOf(0.00);
                remise_DO_3.montantTTC = Double.valueOf(0.00);
                remise_DO_3.typeRemise = typeRemise_REC_P;
                remise_DO_3.applicationRemise = application_NU;
                // LISTE REMISE
                gdfsuezBefCalypsoPrixetremisesV2.listeRemisesDt listeRemises_DO = new gdfsuezBefCalypsoPrixetremisesV2.listeRemisesDt();
                listeRemises_DO.remise = new List<gdfsuezBefCalypsoPrixetremisesV2.remiseDt>();
                listeRemises_DO.remise.add(remise_DO_1);
                listeRemises_DO.remise.add(remise_DO_2);
                listeRemises_DO.remise.add(remise_DO_3);
                // PRIX 1 
                gdfsuezBefCalypsoPrixetremisesV2.prixDt prix1 = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
                prix1.clePrix = clePrix_GBKPXGA2AB;
                prix1.dateDebutValiditePrix = DateTime.valueOf('2019-08-01 00:00:00');
                prix1.dateFinValiditePrix = DateTime.valueOf('9999-12-31 00:00:00');
                prix1.montantHT = Double.valueOf(35.75000000);
                prix1.montantTTC = Double.valueOf(37.71625000);
                prix1.tauxTVA = Double.valueOf(5.5);
                prix1.caracteristiquesElec = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                prix1.caracteristiquesElec.CAEElec = Integer.valueOf('0000000000');
                prix1.caracteristiquesGaz = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt();
                prix1.caracteristiquesGaz.typePrix = typePrix_AB;
                prix1.caracteristiquesGaz.plageConsommation = new gdfsuezComBefChpCommunV3.listeValeursDt();
                prix1.caracteristiquesGaz.plageConsommation.code = '6000';
                prix1.caracteristiquesGaz.plageConsommation.libelleCourt = '0 à 6000 kWh';
                // PRIX 2 
                gdfsuezBefCalypsoPrixetremisesV2.prixDt prix2 = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
                prix2.clePrix = clePrix_G1LPDST2AB;
                prix2.dateDebutValiditePrix = DateTime.valueOf('2000-01-04 00:00:00');
                prix2.dateFinValiditePrix = DateTime.valueOf('9999-12-31 00:00:00');
                prix2.montantHT = Double.valueOf(41.64000000);
                prix2.montantTTC = Double.valueOf(54.36708420);
                prix2.tauxTVA = Double.valueOf(30.564999999999998);
                prix2.caracteristiquesElec = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                prix2.caracteristiquesElec.CAEElec = Integer.valueOf('0000000000');
                prix2.caracteristiquesGaz = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt();
                prix2.caracteristiquesGaz.typePrix = typePrix_ACHAB;
                prix2.caracteristiquesGaz.plageConsommation = new gdfsuezComBefChpCommunV3.listeValeursDt();
                prix2.caracteristiquesGaz.plageConsommation.code = '6000';
                prix2.caracteristiquesGaz.plageConsommation.libelleCourt = '0 à 6000 kWh';
                // PRIX 3
                gdfsuezBefCalypsoPrixetremisesV2.prixDt prix3 = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
                prix3.clePrix = clePrix_G1QPDST2CO;
                prix3.dateDebutValiditePrix = DateTime.valueOf('2000-01-04 00:00:00');
                prix3.dateFinValiditePrix = DateTime.valueOf('9999-12-31 00:00:00');
                prix3.montantHT = Double.valueOf(0.02885000);
                prix3.montantTTC = Double.valueOf(0.03462000);
                prix3.tauxTVA = Double.valueOf(20.0);
                prix3.caracteristiquesElec = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                prix3.caracteristiquesElec.CAEElec = Integer.valueOf('0000000000');
                prix3.caracteristiquesGaz = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt();
                prix3.caracteristiquesGaz.typePrix = typePrix_ACHAB;
                prix3.caracteristiquesGaz.plageConsommation = new gdfsuezComBefChpCommunV3.listeValeursDt();
                prix3.caracteristiquesGaz.plageConsommation.code = '6000';
                prix3.caracteristiquesGaz.plageConsommation.libelleCourt = '0 à 6000 kWh';
                // PRIX 4
                gdfsuezBefCalypsoPrixetremisesV2.prixDt prix4 = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
                prix4.clePrix = clePrix_GBKPXGA2CO;
                prix4.dateDebutValiditePrix = DateTime.valueOf('2019-08-01 00:00:00');
                prix4.dateFinValiditePrix = DateTime.valueOf('9999-12-31 00:00:00');
                prix4.montantHT = Double.valueOf(0.01414000);
                prix4.montantTTC = Double.valueOf(0.02710800);
                prix4.tauxTVA = Double.valueOf(91.726);
                prix4.caracteristiquesElec = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                prix4.caracteristiquesElec.CAEElec = Integer.valueOf('0000000000');
                prix4.caracteristiquesGaz = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt();
                prix4.caracteristiquesGaz.typePrix = typePrix_CO;
                prix4.caracteristiquesGaz.plageConsommation = new gdfsuezComBefChpCommunV3.listeValeursDt();
                prix4.caracteristiquesGaz.plageConsommation.code = '6000';
                prix4.caracteristiquesGaz.plageConsommation.libelleCourt = '0 à 6000 kWh';
                // PRIX 5
                gdfsuezBefCalypsoPrixetremisesV2.prixDt prix5 = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
                prix5.clePrix = clePrix_GBKPXGB2OB;
                prix5.dateDebutValiditePrix = DateTime.valueOf('2019-08-01 00:00:00');
                prix5.dateFinValiditePrix = DateTime.valueOf('9999-12-31 00:00:00');
                prix5.montantHT = Double.valueOf(0.01414000);
                prix5.montantTTC = Double.valueOf(0.02710800);
                prix5.tauxTVA = Double.valueOf(91.726);
                prix5.caracteristiquesElec = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                prix5.caracteristiquesElec.CAEElec = Integer.valueOf('0000000000');
                prix5.caracteristiquesGaz = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt();
                prix5.caracteristiquesGaz.typePrix = typePrix_OB;
                prix5.caracteristiquesGaz.plageConsommation = new gdfsuezComBefChpCommunV3.listeValeursDt();
                prix5.caracteristiquesGaz.plageConsommation.code = '6000';
                prix5.caracteristiquesGaz.plageConsommation.libelleCourt = '0 à 6000 kWh';
                // PRIX 6
                gdfsuezBefCalypsoPrixetremisesV2.prixDt prix6 = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
                prix6.dateDebutValiditePrix = DateTime.valueOf('2019-08-01 00:00:00');
                prix6.dateFinValiditePrix = DateTime.valueOf('9999-12-31 00:00:00');
                prix6.montantHT = Double.valueOf(0.01414000);
                prix6.montantTTC = Double.valueOf(0.02710800);
                prix6.tauxTVA = Double.valueOf(91.726);
                prix6.caracteristiquesElec = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                prix6.caracteristiquesElec.CAEElec = Integer.valueOf('0000000000');
                prix6.caracteristiquesGaz = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt();
                prix6.caracteristiquesGaz.typePrix = typePrix_TOTAB;
                prix6.caracteristiquesGaz.plageConsommation = new gdfsuezComBefChpCommunV3.listeValeursDt();
                prix6.caracteristiquesGaz.plageConsommation.code = '6000';
                prix6.caracteristiquesGaz.plageConsommation.libelleCourt = '0 à 6000 kWh';
                // PRIX 7
                gdfsuezBefCalypsoPrixetremisesV2.prixDt prix7 = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
                prix7.dateDebutValiditePrix = DateTime.valueOf('2019-08-01 00:00:00');
                prix7.dateFinValiditePrix = DateTime.valueOf('9999-12-31 00:00:00');
                prix7.montantHT = Double.valueOf(0.01414000);
                prix7.montantTTC = Double.valueOf(0.02710800);
                prix7.tauxTVA = Double.valueOf(91.726);
                prix7.caracteristiquesElec = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                prix7.caracteristiquesElec.CAEElec = Integer.valueOf('0000000000');
                prix7.caracteristiquesGaz = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt();
                prix7.caracteristiquesGaz.typePrix = typePrix_TOTCO;
                prix7.caracteristiquesGaz.plageConsommation = new gdfsuezComBefChpCommunV3.listeValeursDt();
                prix7.caracteristiquesGaz.plageConsommation.code = '6000';
                prix7.caracteristiquesGaz.plageConsommation.libelleCourt = '0 à 6000 kWh';
                // PRIX 7
                gdfsuezBefCalypsoPrixetremisesV2.prixDt prix8 = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
                prix8.dateDebutValiditePrix = DateTime.valueOf('2019-08-01 00:00:00');
                prix8.dateFinValiditePrix = DateTime.valueOf('9999-12-31 00:00:00');
                prix8.montantHT = Double.valueOf(0.01414000);
                prix8.montantTTC = Double.valueOf(0.02710800);
                prix8.tauxTVA = Double.valueOf(91.726);
                prix8.caracteristiquesElec = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                prix8.caracteristiquesElec.CAEElec = Integer.valueOf('0000000000');
                prix8.caracteristiquesGaz = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt();
                prix8.caracteristiquesGaz.typePrix = typePrix_ACHCO;
                prix8.caracteristiquesGaz.plageConsommation = new gdfsuezComBefChpCommunV3.listeValeursDt();
                prix8.caracteristiquesGaz.plageConsommation.code = '6000';
                prix8.caracteristiquesGaz.plageConsommation.libelleCourt = '0 à 6000 kWh';
                // LISTE PRIX
                gdfsuezBefCalypsoPrixetremisesV2.listePrixDt listePrix_DO = new gdfsuezBefCalypsoPrixetremisesV2.listePrixDt();
                listePrix_DO.prix = new List<gdfsuezBefCalypsoPrixetremisesV2.prixDt>();
                listePrix_DO.prix.add(prix1);
                listePrix_DO.prix.add(prix2);
                listePrix_DO.prix.add(prix3);
                listePrix_DO.prix.add(prix4);
                listePrix_DO.prix.add(prix5);
                listePrix_DO.prix.add(prix6);
                listePrix_DO.prix.add(prix7);
                listePrix_DO.prix.add(prix8);
                // SECTEUR ACTVITE
                gdfsuezComBefChpCommunV3.listeValeursDt secteurActiviteGAZ = new gdfsuezComBefChpCommunV3.listeValeursDt();
                secteurActiviteGAZ.code = '5G';
                secteurActiviteGAZ.libelleCourt = 'Gaz naturel';
                // SECTEUR ACTVITE
                gdfsuezComBefChpCommunV3.listeValeursDt secteurActiviteELEC = new gdfsuezComBefChpCommunV3.listeValeursDt();
                secteurActiviteELEC.code = '5E';
                secteurActiviteELEC.libelleCourt = 'Electricité';
                // DONNEES OFFRE
                gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt donneesOffre1 = new gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt();
                donneesOffre1.idOffre = 'GBUGR1';
                donneesOffre1.libelleOffre = 'Référence Gaz 1 an';
                donneesOffre1.secteurActivite = secteurActiviteGAZ;
                donneesOffre1.listeRemises = listeRemises_DO;
                donneesOffre1.listePrix = listePrix_DO;

                gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt donneesOffre2 = new gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt();
                donneesOffre2.idOffre = 'EBUGR1';
                donneesOffre2.libelleOffre = 'Référence Elec 1 an';
                donneesOffre2.secteurActivite = secteurActiviteElec;
                donneesOffre2.listeRemises = listeRemises_DO;
                donneesOffre2.listePrix = listePrix_DO;

                /****OUTPUT****/
                gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesOutputDt output = new gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesOutputDt();
                output.donneesPack = donneesPack;
                output.donneesOffre = new List<gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt>{donneesOffre1,donneesOffre2};
                System.debug(output);
                // remplir la liste des prix et remises
                response_x.rechercherPrixEtRemisesOutput.add(output); 
                // gdfsuezBefCalypsoPrixetremisesV1.rechercherPrixEtRemisesOutputDt outputDT=new gdfsuezBefCalypsoPrixetremisesV1.rechercherPrixEtRemisesOutputDt();
                response.put( 'response_x', response_x);
            } else if (this.TYPE_OFFRE == 'Elec') {
                /****TYPE REMISES****/
                gdfsuezComBefChpCommunV3.listeValeursDt typeRemise_REM_OS_OS = new gdfsuezComBefChpCommunV3.listeValeursDt(); //OK
                typeRemise_REM_OS_OS.code = 'REM_OS_S';
                typeRemise_REM_OS_OS.libelleCourt = 'remise OS structurelle';
                typeRemise_REM_OS_OS.description = 'PAS DE REMISE';
                gdfsuezComBefChpCommunV3.listeValeursDt typeRemise_REM_OS_P = new gdfsuezComBefChpCommunV3.listeValeursDt(); //OK
                typeRemise_REM_OS_P.code = 'REM_OS_P';
                typeRemise_REM_OS_P.libelleCourt = 'remise OS promotionnelle';
                typeRemise_REM_OS_P.description = 'PAS DE REMISE';
                gdfsuezComBefChpCommunV3.listeValeursDt typeRemise_REM_OS_E = new gdfsuezComBefChpCommunV3.listeValeursDt(); //OK
                typeRemise_REM_OS_E.code = 'REM_OS_E';
                typeRemise_REM_OS_E.libelleCourt = 'remise OS enseigne';
                typeRemise_REM_OS_E.description = 'PAS DE REMISE';
                gdfsuezComBefChpCommunV3.listeValeursDt typeRemise_REC = new gdfsuezComBefChpCommunV3.listeValeursDt(); //OK
                typeRemise_REC.code = 'REM_REC';
                typeRemise_REC.libelleCourt = 'remise récurrente';
                typeRemise_REC.description = 'PAS DE REMISE';
                gdfsuezComBefChpCommunV3.listeValeursDt typeRemise_REC_S = new gdfsuezComBefChpCommunV3.listeValeursDt(); //OK
                typeRemise_REC_S.code = 'REM_REC_S';
                typeRemise_REC_S.libelleCourt = 'remise récurrente structurelle pour les services récurrents';
                typeRemise_REC_S.description = 'PAS DE REMISE';
                gdfsuezComBefChpCommunV3.listeValeursDt typeRemise_REC_P = new gdfsuezComBefChpCommunV3.listeValeursDt(); //OK
                typeRemise_REC_P.code = 'REM_REC_P';
                typeRemise_REC_P.libelleCourt = 'remise récurrente promotionnelle pour les services récurrents';
                typeRemise_REC_P.description = 'PAS DE REMISE';
                
                /****TYPE PRIX****/
                gdfsuezComBefChpCommunV3.listeValeursDt typePrix_AB = new gdfsuezComBefChpCommunV3.listeValeursDt(); //OK
                typePrix_AB.code = 'AB';
                typePrix_AB.libelleCourt = 'Abonnement';
                gdfsuezComBefChpCommunV3.listeValeursDt typePrix_ACHAB = new gdfsuezComBefChpCommunV3.listeValeursDt(); //OK
                typePrix_ACHAB.code = 'ACHAB';
                typePrix_ACHAB.libelleCourt = 'Abonnement';
                gdfsuezComBefChpCommunV3.listeValeursDt typePrix_ACHCO = new gdfsuezComBefChpCommunV3.listeValeursDt(); //OK
                typePrix_ACHCO.code = 'ACHCO';
                typePrix_ACHCO.libelleCourt = 'Acheminement consommation';
                gdfsuezComBefChpCommunV3.listeValeursDt typePrix_CO = new gdfsuezComBefChpCommunV3.listeValeursDt(); //OK
                typePrix_CO.code = 'CO';
                typePrix_CO.libelleCourt = 'Consommation';

 
                gdfsuezComBefChpCommunV3.listeValeursDt typePrix_DRP = new gdfsuezComBefChpCommunV3.listeValeursDt(); //NEW
                typePrix_DRP.code = 'DRP';
                typePrix_DRP.libelleCourt = 'Date de règlement personnalisée';
                gdfsuezComBefChpCommunV3.listeValeursDt typePrix_IA = new gdfsuezComBefChpCommunV3.listeValeursDt(); //NEW
                typePrix_IA.code = 'IA';
                gdfsuezComBefChpCommunV3.listeValeursDt typePrix_IB = new gdfsuezComBefChpCommunV3.listeValeursDt(); //NEW
                typePrix_IB.code = 'IB';
                gdfsuezComBefChpCommunV3.listeValeursDt typePrix_IC = new gdfsuezComBefChpCommunV3.listeValeursDt(); //NEW
                typePrix_IC.code = 'IC';

                //A supprimer
                // gdfsuezComBefChpCommunV3.listeValeursDt typePrix_OB = new gdfsuezComBefChpCommunV3.listeValeursDt();
                // typePrix_OB.code = 'OB';
                // typePrix_OB.libelleCourt = 'Obligations';
                // gdfsuezComBefChpCommunV3.listeValeursDt typePrix_TOTAB = new gdfsuezComBefChpCommunV3.listeValeursDt();
                // typePrix_TOTAB.code = 'TOTAB';
                // typePrix_TOTAB.libelleCourt = 'Total abonnement';
                // gdfsuezComBefChpCommunV3.listeValeursDt typePrix_TOTCO = new gdfsuezComBefChpCommunV3.listeValeursDt();
                // typePrix_TOTCO.code = 'TOTCO';
                // typePrix_TOTCO.libelleCourt = 'Total consommation';

                
                /****APPLICATION****/
                gdfsuezComBefChpCommunV3.listeValeursDt application_NU = new gdfsuezComBefChpCommunV3.listeValeursDt();
                application_NU.code = 'NU';
                application_NU.libelleCourt = 'Nu';
                
                /****CLE PRIX****/
                gdfsuezComBefChpCommunV3.listeValeursDt clePrix_EBMBKHA1DB = new gdfsuezComBefChpCommunV3.listeValeursDt();
                clePrix_EBMBKHA1DB.code = 'EBMBKHA1DB';
                clePrix_EBMBKHA1DB.libelleCourt = 'GDF_NOF_MP_EBUA2';
                gdfsuezComBefChpCommunV3.listeValeursDt clePrix_EA230SA1CB = new gdfsuezComBefChpCommunV3.listeValeursDt();
                clePrix_EA230SA1CB.code = 'EA230SA1CB';
                clePrix_EA230SA1CB.libelleCourt = 'Tarif Acheminement Juin 2007';
                gdfsuezComBefChpCommunV3.listeValeursDt clePrix_EA230SC1CB = new gdfsuezComBefChpCommunV3.listeValeursDt();
                clePrix_EA230SC1CB.code = 'EA230SC1CB';
                clePrix_EA230SC1CB.libelleCourt = 'Tarif Acheminement Juin 2007';
                gdfsuezComBefChpCommunV3.listeValeursDt clePrix_EBMBKHQ1DB = new gdfsuezComBefChpCommunV3.listeValeursDt();
                clePrix_EBMBKHQ1DB.code = 'EBMBKHQ1DB';
                clePrix_EBMBKHQ1DB.libelleCourt = 'GDF_NOF_MP_EBUA2';
                gdfsuezComBefChpCommunV3.listeValeursDt clePrix_EBMBKHP1DB = new gdfsuezComBefChpCommunV3.listeValeursDt();
                clePrix_EBMBKHP1DB.code = 'EBMBKHP1DB';
                clePrix_EBMBKHP1DB.libelleCourt = 'GDF_NOF_MP_EBUA2';
                gdfsuezComBefChpCommunV3.listeValeursDt clePrix_G1PDRP = new gdfsuezComBefChpCommunV3.listeValeursDt();
                clePrix_G1PDRP.code = 'G1PDRP';
                gdfsuezComBefChpCommunV3.listeValeursDt clePrix_EIACHHA6 = new gdfsuezComBefChpCommunV3.listeValeursDt();
                clePrix_EIACHHA6.code = 'EIACHHA6';
                gdfsuezComBefChpCommunV3.listeValeursDt clePrix_EIAJBHM6 = new gdfsuezComBefChpCommunV3.listeValeursDt();
                clePrix_EIAJBHM6.code = 'EIAJBHM6';
                clePrix_EIAJBHM6.libelleCourt = 'Indice composite sur TR Elec b';
                gdfsuezComBefChpCommunV3.listeValeursDt clePrix_EICAPHA6 = new gdfsuezComBefChpCommunV3.listeValeursDt();
                clePrix_EICAPHA6.code = 'EICAPHA6';

                /****DONNEES PACK****/
                // REMISE 1
                gdfsuezBefCalypsoPrixetremisesV2.remiseDt remise_DP_1 = new gdfsuezBefCalypsoPrixetremisesV2.remiseDt();
                remise_DP_1.pourcentageRemise = '0';
                remise_DP_1.duree = '0';
                remise_DP_1.tauxTVA = Double.valueOf(0.00);
                remise_DP_1.montantHT = Double.valueOf(0.00);
                remise_DP_1.montantTTC = Double.valueOf(0.00);
                remise_DP_1.typeRemise = typeRemise_REM_OS_OS;
                // REMISE 2
                gdfsuezBefCalypsoPrixetremisesV2.remiseDt remise_DP_2 = new gdfsuezBefCalypsoPrixetremisesV2.remiseDt();
                remise_DP_2.pourcentageRemise = '0';
                remise_DP_2.duree = '0';
                remise_DP_2.tauxTVA = Double.valueOf(0.00);
                remise_DP_2.montantHT = Double.valueOf(0.00);
                remise_DP_2.montantTTC = Double.valueOf(0.00);
                remise_DP_2.typeRemise = typeRemise_REM_OS_P;
                // REMISE 3
                gdfsuezBefCalypsoPrixetremisesV2.remiseDt remise_DP_3 = new gdfsuezBefCalypsoPrixetremisesV2.remiseDt();
                remise_DP_3.pourcentageRemise = '0';
                remise_DP_3.duree = '0';
                remise_DP_3.tauxTVA = Double.valueOf(0.00);
                remise_DP_3.montantHT = Double.valueOf(0.00);
                remise_DP_3.montantTTC = Double.valueOf(0.00);
                remise_DP_3.typeRemise = typeRemise_REM_OS_E;
                // LISTE REMISE
                gdfsuezBefCalypsoPrixetremisesV2.listeRemisesDt listeRemises_DP = new gdfsuezBefCalypsoPrixetremisesV2.listeRemisesDt();
                listeRemises_DP.remise = new List<gdfsuezBefCalypsoPrixetremisesV2.remiseDt>();
                listeRemises_DP.remise.add(remise_DP_1);
                listeRemises_DP.remise.add(remise_DP_2);
                listeRemises_DP.remise.add(remise_DP_3);
                // DONNEES PACK            
                gdfsuezBefCalypsoPrixetremisesV2.donneesPackDt donneesPack = new gdfsuezBefCalypsoPrixetremisesV2.donneesPackDt();
                donneesPack.idPack = 'EBUAK2_P';
                donneesPack.libellePack = 'Elec Ajust 2 ans';
                donneesPack.listeRemises = listeRemises_DP;


                /****DONNEES OFFRE****/
                // REMISE 1
                gdfsuezBefCalypsoPrixetremisesV2.remiseDt remise_DO_1 = new gdfsuezBefCalypsoPrixetremisesV2.remiseDt();
                remise_DO_1.pourcentageRemise = '0';
                remise_DO_1.natureRemise = 'PAS DE REMISE';
                remise_DO_1.duree = '0';
                remise_DO_1.tauxTVA = Double.valueOf(0.00);
                remise_DO_1.montantHT = Double.valueOf(0.00);
                remise_DO_1.montantTTC = Double.valueOf(0.00);
                remise_DO_1.typeRemise = typeRemise_REC;
                remise_DO_1.applicationRemise = application_NU;
                // REMISE 2
                gdfsuezBefCalypsoPrixetremisesV2.remiseDt remise_DO_2 = new gdfsuezBefCalypsoPrixetremisesV2.remiseDt();
                remise_DO_2.pourcentageRemise = '0';
                remise_DO_2.natureRemise = 'PAS DE REMISE';
                remise_DO_2.duree = '0';
                remise_DO_2.tauxTVA = Double.valueOf(0.00);
                remise_DO_2.montantHT = Double.valueOf(0.00);
                remise_DO_2.montantTTC = Double.valueOf(0.00);
                remise_DO_2.typeRemise = typeRemise_REC_S;
                remise_DO_2.applicationRemise = application_NU;
                // REMISE 3
                gdfsuezBefCalypsoPrixetremisesV2.remiseDt remise_DO_3 = new gdfsuezBefCalypsoPrixetremisesV2.remiseDt();
                remise_DO_3.pourcentageRemise = '0';
                remise_DO_3.natureRemise = 'PAS DE REMISE';
                remise_DO_3.duree = '0';
                remise_DO_3.tauxTVA = Double.valueOf(0.00);
                remise_DO_3.montantHT = Double.valueOf(0.00);
                remise_DO_3.montantTTC = Double.valueOf(0.00);
                remise_DO_3.typeRemise = typeRemise_REC_P;
                remise_DO_3.applicationRemise = application_NU;
                // LISTE REMISE
                gdfsuezBefCalypsoPrixetremisesV2.listeRemisesDt listeRemises_DO = new gdfsuezBefCalypsoPrixetremisesV2.listeRemisesDt();
                listeRemises_DO.remise = new List<gdfsuezBefCalypsoPrixetremisesV2.remiseDt>();
                listeRemises_DO.remise.add(remise_DO_1);
                listeRemises_DO.remise.add(remise_DO_2);
                listeRemises_DO.remise.add(remise_DO_3);





                // PRIX 1
                gdfsuezBefCalypsoPrixetremisesV2.prixDt prix1 = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
                prix1.clePrix = clePrix_EBMBKHA1DB;
                prix1.dateDebutValiditePrix = DateTime.valueOf('2019-12-01 00:00:00');
                prix1.dateFinValiditePrix = DateTime.valueOf('9999-12-31 00:00:00');
                prix1.montantHT = Double.valueOf(99.87000000);
                prix1.montantTTC = Double.valueOf(124.05387144);
                prix1.tauxTVA = Double.valueOf(24.215);
                prix1.caracteristiquesElec = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                prix1.caracteristiquesElec = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                prix1.caracteristiquesElec.CAEElec = Integer.valueOf('0000001122');
                prix1.caracteristiquesElec.typePrix = typePrix_AB;
                prix1.caracteristiquesElec.typeComptage = new gdfsuezComBefChpCommunV3.listeValeursDt();
                prix1.caracteristiquesElec.typeComptage.code = 'C';
                prix1.caracteristiquesElec.typeComptage.libelleCourt = 'Comptage Heures Creuses';
                prix1.caracteristiquesElec.puissance = new gdfsuezComBefChpCommunV3.listeValeursDt();
                prix1.caracteristiquesElec.puissance.code = '6';
                prix1.caracteristiquesElec.puissance.libelleCourt = '6 KVA';
                // PRIX 2 
                gdfsuezBefCalypsoPrixetremisesV2.prixDt prix2 = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
                prix2.clePrix = clePrix_EBMBKHQ1DB;
                prix2.dateDebutValiditePrix = DateTime.valueOf('2000-01-04 00:00:00');
                prix2.dateFinValiditePrix = DateTime.valueOf('9999-12-31 00:00:00');
                prix2.montantHT = Double.valueOf(41.64000000);
                prix2.montantTTC = Double.valueOf(54.36708420);
                prix2.tauxTVA = Double.valueOf(30.564999999999998);
                prix2.caracteristiquesElec = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                prix2.caracteristiquesElec.typePrix = typePrix_CO;
                prix2.caracteristiquesElec.CAEElec = Integer.valueOf('0000001122');
                prix2.caracteristiquesElec.typeComptage = new gdfsuezComBefChpCommunV3.listeValeursDt();
                prix2.caracteristiquesElec.typeComptage.code = 'C';
                prix2.caracteristiquesElec.typeComptage.libelleCourt = 'Comptage Heures Creuses';
                prix2.caracteristiquesElec.puissance = new gdfsuezComBefChpCommunV3.listeValeursDt();
                prix2.caracteristiquesElec.puissance.code = '6';
                prix2.caracteristiquesElec.puissance.libelleCourt = '6 KVA';
                // PRIX 3
                gdfsuezBefCalypsoPrixetremisesV2.prixDt prix3 = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
                prix3.clePrix = clePrix_EBMBKHP1DB;
                prix3.dateDebutValiditePrix = DateTime.valueOf('2000-01-04 00:00:00');
                prix3.dateFinValiditePrix = DateTime.valueOf('9999-12-31 00:00:00');
                prix3.montantHT = Double.valueOf(0.02885000);
                prix3.montantTTC = Double.valueOf(0.03462000);
                prix3.tauxTVA = Double.valueOf(20.0);
                prix3.caracteristiquesElec = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                prix3.caracteristiquesElec.typePrix = typePrix_CO;
                prix3.caracteristiquesElec.CAEElec = Integer.valueOf('0000001122');
                prix3.caracteristiquesElec.typeComptage = new gdfsuezComBefChpCommunV3.listeValeursDt();
                prix3.caracteristiquesElec.typeComptage.code = 'C';
                prix3.caracteristiquesElec.typeComptage.libelleCourt = 'Comptage Heures Creuses';
                prix3.caracteristiquesElec.puissance = new gdfsuezComBefChpCommunV3.listeValeursDt();
                prix3.caracteristiquesElec.puissance.code = '6';
                prix3.caracteristiquesElec.puissance.libelleCourt = '6 KVA';
                // PRIX 4
                gdfsuezBefCalypsoPrixetremisesV2.prixDt prix4 = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
                prix4.clePrix = clePrix_G1PDRP;
                prix4.dateDebutValiditePrix = DateTime.valueOf('2019-08-01 00:00:00');
                prix4.dateFinValiditePrix = DateTime.valueOf('9999-12-31 00:00:00');
                prix4.montantHT = Double.valueOf(0.01414000);
                prix4.montantTTC = Double.valueOf(0.02710800);
                prix4.tauxTVA = Double.valueOf(91.726);
                prix4.caracteristiquesElec = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                prix4.caracteristiquesElec.typePrix = typePrix_DRP;
                prix4.caracteristiquesElec.CAEElec = Integer.valueOf('0000001122');
                prix4.caracteristiquesElec.typeComptage = new gdfsuezComBefChpCommunV3.listeValeursDt();
                prix4.caracteristiquesElec.typeComptage.code = 'C';
                prix4.caracteristiquesElec.typeComptage.libelleCourt = 'Comptage Heures Creuses';
                prix4.caracteristiquesElec.puissance = new gdfsuezComBefChpCommunV3.listeValeursDt();
                prix4.caracteristiquesElec.puissance.code = '6';
                prix4.caracteristiquesElec.puissance.libelleCourt = '6 KVA';
                // PRIX 5
                gdfsuezBefCalypsoPrixetremisesV2.prixDt prix5 = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
                prix5.clePrix = clePrix_EIACHHA6;
                prix5.dateDebutValiditePrix = DateTime.valueOf('2019-08-01 00:00:00');
                prix5.dateFinValiditePrix = DateTime.valueOf('9999-12-31 00:00:00');
                prix5.montantHT = Double.valueOf(0.01414000);
                prix5.montantTTC = Double.valueOf(0.02710800);
                prix5.tauxTVA = Double.valueOf(91.726);
                prix5.caracteristiquesElec = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                prix5.caracteristiquesElec.typePrix = typePrix_IA;
                prix5.caracteristiquesElec.CAEElec = Integer.valueOf('0000001122');
                prix5.caracteristiquesElec.typeComptage = new gdfsuezComBefChpCommunV3.listeValeursDt();
                prix5.caracteristiquesElec.typeComptage.code = 'C';
                prix5.caracteristiquesElec.typeComptage.libelleCourt = 'Comptage Heures Creuses';
                prix5.caracteristiquesElec.puissance = new gdfsuezComBefChpCommunV3.listeValeursDt();
                prix5.caracteristiquesElec.puissance.code = '6';
                prix5.caracteristiquesElec.puissance.libelleCourt = '6 KVA';
                // PRIX 6
                // gdfsuezBefCalypsoPrixetremisesV2.prixDt prix6 = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
                // prix6.dateDebutValiditePrix = DateTime.valueOf('2019-08-01 00:00:00');
                // prix6.dateFinValiditePrix = DateTime.valueOf('9999-12-31 00:00:00');
                // prix6.montantHT = Double.valueOf(0.01414000);
                // prix6.montantTTC = Double.valueOf(0.02710800);
                // prix6.tauxTVA = Double.valueOf(91.726);
                // prix6.caracteristiquesElec = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                // prix6.caracteristiquesElec.CAEElec = Integer.valueOf('0000000000');
                // prix6.caracteristiquesGaz = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt();
                // prix6.caracteristiquesGaz.typePrix = typePrix_TOTAB;
                // prix6.caracteristiquesGaz.plageConsommation = new gdfsuezComBefChpCommunV3.listeValeursDt();
                // prix6.caracteristiquesGaz.plageConsommation.code = '6000';
                // prix6.caracteristiquesGaz.plageConsommation.libelleCourt = '0 à 6000 kWh';
                // // PRIX 7
                // gdfsuezBefCalypsoPrixetremisesV2.prixDt prix7 = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
                // prix7.dateDebutValiditePrix = DateTime.valueOf('2019-08-01 00:00:00');
                // prix7.dateFinValiditePrix = DateTime.valueOf('9999-12-31 00:00:00');
                // prix7.montantHT = Double.valueOf(0.01414000);
                // prix7.montantTTC = Double.valueOf(0.02710800);
                // prix7.tauxTVA = Double.valueOf(91.726);
                // prix7.caracteristiquesElec = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                // prix7.caracteristiquesElec.CAEElec = Integer.valueOf('0000000000');
                // prix7.caracteristiquesGaz = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt();
                // prix7.caracteristiquesGaz.typePrix = typePrix_TOTCO;
                // prix7.caracteristiquesGaz.plageConsommation = new gdfsuezComBefChpCommunV3.listeValeursDt();
                // prix7.caracteristiquesGaz.plageConsommation.code = '6000';
                // prix7.caracteristiquesGaz.plageConsommation.libelleCourt = '0 à 6000 kWh';
                // // PRIX 7
                // gdfsuezBefCalypsoPrixetremisesV2.prixDt prix8 = new gdfsuezBefCalypsoPrixetremisesV2.prixDt();
                // prix8.dateDebutValiditePrix = DateTime.valueOf('2019-08-01 00:00:00');
                // prix8.dateFinValiditePrix = DateTime.valueOf('9999-12-31 00:00:00');
                // prix8.montantHT = Double.valueOf(0.01414000);
                // prix8.montantTTC = Double.valueOf(0.02710800);
                // prix8.tauxTVA = Double.valueOf(91.726);
                // prix8.caracteristiquesElec = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                // prix8.caracteristiquesElec.CAEElec = Integer.valueOf('0000000000');
                // prix8.caracteristiquesGaz = new gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt();
                // prix8.caracteristiquesGaz.typePrix = typePrix_ACHCO;
                // prix8.caracteristiquesGaz.plageConsommation = new gdfsuezComBefChpCommunV3.listeValeursDt();
                // prix8.caracteristiquesGaz.plageConsommation.code = '6000';
                // prix8.caracteristiquesGaz.plageConsommation.libelleCourt = '0 à 6000 kWh';
                // LISTE PRIX
                gdfsuezBefCalypsoPrixetremisesV2.listePrixDt listePrix_DO = new gdfsuezBefCalypsoPrixetremisesV2.listePrixDt();
                listePrix_DO.prix = new List<gdfsuezBefCalypsoPrixetremisesV2.prixDt>();
                listePrix_DO.prix.add(prix1);
                listePrix_DO.prix.add(prix2);
                listePrix_DO.prix.add(prix3);
                listePrix_DO.prix.add(prix4);
                listePrix_DO.prix.add(prix5);
                // listePrix_DO.prix.add(prix6);
                // listePrix_DO.prix.add(prix7);
                // listePrix_DO.prix.add(prix8);
                // SECTEUR ACTVITE
                gdfsuezComBefChpCommunV3.listeValeursDt secteurActivite = new gdfsuezComBefChpCommunV3.listeValeursDt();
                secteurActivite.code = '5E';
                secteurActivite.libelleCourt = 'Electricité';
                // DONNEES OFFRE
                gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt donneesOffre = new gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt();
                donneesOffre.idOffre = 'EBUA2';
                donneesOffre.libelleOffre = 'Elec Ajust 2 ans (prix de marché)';
                donneesOffre.secteurActivite = secteurActivite;
                donneesOffre.listeRemises = listeRemises_DO;
                donneesOffre.listePrix = listePrix_DO;

                /****OUTPUT****/
                gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesOutputDt output = new gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesOutputDt();
                output.donneesPack = donneesPack;
                output.donneesOffre = new List<gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt>{donneesOffre};

                // remplir la liste des prix et remises
                response_x.rechercherPrixEtRemisesOutput.add(output); 
                // gdfsuezBefCalypsoPrixetremisesV1.rechercherPrixEtRemisesOutputDt outputDT=new gdfsuezBefCalypsoPrixetremisesV1.rechercherPrixEtRemisesOutputDt();
                response.put( 'response_x', response_x);
            }
		} else if(request instanceOf gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesServices_element) {
			response.put( 'response_x', new gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesServicesResponse_element());
		}
	}
}