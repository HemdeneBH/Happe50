@isTest
global class SM_AP13_PdlElecMock implements WebServiceMock {
  global void doInvoke(
    Object stub,
    Object request,
    Map < String, Object > response,
    String endpoint,
    String soapAction,
    String requestName,
    String responseNS,
    String responseName,
    String responseType) {
    gdfsuezBefCalypsoPdlelectriciteV3.lirePDLElectriciteResponse_element response_x = new gdfsuezBefCalypsoPdlelectriciteV3.lirePDLElectriciteResponse_element();
    response_x.lirePDLElectriciteOutput = new gdfsuezBefCalypsoPdlelectriciteV3.lirePDLElectriciteOutputDt();


    gdfsuezComBefCalypsoPdlelectricite.PDLElectricite donnepdl = new gdfsuezComBefCalypsoPdlelectricite.PDLElectricite();
    donnepdl.idPDLElectricite = '01199999844520';
    donnepdl.donneesGenerales = new List < gdfsuezComBefCalypsoPdlelectricite.donneesGenerales_element > ();
    donnepdl.situationContractuelle = new List < gdfsuezComBefCalypsoPdlelectricite.situationContractuelle_element > ();
    gdfsuezComBefCalypsoPdlelectricite.situationContractuelle_element stcontract = new gdfsuezComBefCalypsoPdlelectricite.situationContractuelle_element();
    stcontract.sIContractuel = new gdfsuezComBefChpPivot.listeValeursDt();
    stcontract.sIContractuel.code = 'GINKO';

    gdfsuezComBefCalypsoPdlelectricite.structureTarifaire_element strTarifaire = new gdfsuezComBefCalypsoPdlelectricite.structureTarifaire_element();

    gdfsuezComBefChpPivot.listeValeursDt formuleTarifaireAcheminement = new gdfsuezComBefChpPivot.listeValeursDt();
    formuleTarifaireAcheminement.libelleCourt = 'Tarif BT&lt;=36kVA Courte Utilisation sans différenciation temporelle';
    formuleTarifaireAcheminement.code = 'BTINFCUST';
    strTarifaire.formuleTarifaireAcheminement = formuleTarifaireAcheminement;

    gdfsuezComBefChpPivot.listeValeursDt calendrierFournisseur = new gdfsuezComBefChpPivot.listeValeursDt();
   /* calendrierFournisseur.code = 'T1';
    calendrierFournisseur.libelleCourt = 'T1';*/
        calendrierFournisseur.code = 'FC000010';
    calendrierFournisseur.libelleCourt = 'FC000010';
    strTarifaire.calendrierFournisseur = calendrierFournisseur;

    gdfsuezComBefChpDistributeurelectric.puissanceSansDecimalDt puissanceSouscriteMax = new gdfsuezComBefChpDistributeurelectric.puissanceSansDecimalDt();
    puissanceSouscriteMax.valeur = 6;
    puissanceSouscriteMax.unite = 'kVa';
    strTarifaire.puissanceSouscriteMax = puissanceSouscriteMax;

    stcontract.structureTarifaire = strTarifaire;
    donnepdl.situationContractuelle.add(stcontract);

    donnepdl.situationComptage = new List < gdfsuezComBefCalypsoPdlelectricite.situationComptage_element > ();
    gdfsuezComBefCalypsoPdlelectricite.situationComptage_element comptage = new gdfsuezComBefCalypsoPdlelectricite.situationComptage_element();
    comptage.dispositifComptage = new gdfsuezComBefCalypsoPdlelectricite.dispositifComptage_element();
    comptage.dispositifComptage.typeComptage = new gdfsuezComBefChpPivot.listeValeursDt();
    comptage.dispositifComptage.typeComptage.code = 'CBT';
    comptage.dispositifComptage.compteurs = new gdfsuezComBefCalypsoPdlelectricite.compteurs_element();
    comptage.dispositifComptage.compteurs.compteur = new List < gdfsuezComBefCalypsoPdlelectricite.compteur_element > ();
    gdfsuezComBefCalypsoPdlelectricite.compteur_element compt = new gdfsuezComBefCalypsoPdlelectricite.compteur_element();
    compt.matricule = '884';
    compt.accessibilite = true;
    compt.modeleCompteur = new gdfsuezComBefCalypsoPdlelectricite.modeleCompteur_element();
    compt.modeleCompteur.nbCadrans = 1;
    comptage.dispositifComptage.compteurs.compteur.add(compt);

    comptage.dispositifComptage.typeComptage = new gdfsuezComBefChpPivot.listeValeursDt();
    comptage.dispositifComptage.typeComptage.code = 'CBF';

    donnepdl.donneesGenerales.add(new gdfsuezComBefCalypsoPdlelectricite.donneesGenerales_element());

    donnepdl.donneesGenerales[0].niveauOuvertureServices = new gdfsuezComBefChpPivot.listeValeursDt();
    donnepdl.donneesGenerales[0].niveauOuvertureServices.code = '0';

    donnepdl.situationAlimentation = new List < gdfsuezComBefCalypsoPdlelectricite.situationAlimentation_element > {
      new gdfsuezComBefCalypsoPdlelectricite.situationAlimentation_element()
    };

    donnepdl.situationAlimentation[0].etatAlimentation = new gdfsuezComBefChpPivot.listeValeursDt();
    donnepdl.situationAlimentation[0].etatAlimentation.libelleCourt = 'Alimenté';

    donnepdl.modificationsContractuellesEnCours = new gdfsuezComBefCalypsoPdlelectricite.modificationsContractuellesEnCours_element(); // .modificationContractuelleEnCours[0].dateMiseHorsService

    donnepdl.modificationsContractuellesEnCours.modificationContractuelleEnCours = new List < gdfsuezComBefCalypsoPdlelectricite.modificationContractuelleEnCours_element > ();
    gdfsuezComBefCalypsoPdlelectricite.modificationContractuelleEnCours_element modificationContractuelleEnCours = new gdfsuezComBefCalypsoPdlelectricite.modificationContractuelleEnCours_element();
    modificationContractuelleEnCours.dateMiseHorsService = system.today();



    donnepdl.modificationsContractuellesEnCours.modificationContractuelleEnCours.add(modificationContractuelleEnCours);
    donnepdl.situationComptage.add(comptage);

    donnepdl.derniersIndexReleves = new List < gdfsuezComBefCalypsoPdlelectricite.derniersIndexReleves_element > {
      new gdfsuezComBefCalypsoPdlelectricite.derniersIndexReleves_element()
    };
    donnepdl.derniersIndexReleves[0].date_x = system.today();

    // cadran CAE
    gdfsuezComBefCalypsoPdlelectricite.historiqueMesures_element historiqueMesures1 = new gdfsuezComBefCalypsoPdlelectricite.historiqueMesures_element();
    gdfsuezComBefCalypsoPdlelectricite.consommations_element consommationValue = new gdfsuezComBefCalypsoPdlelectricite.consommations_element();
    List<gdfsuezComBefCalypsoPdlelectricite.cadran_element> cadrans = new List<gdfsuezComBefCalypsoPdlelectricite.cadran_element>();

    gdfsuezComBefCalypsoPdlelectricite.cadran_element cadran_HP = new gdfsuezComBefCalypsoPdlelectricite.cadran_element();
    gdfsuezComBefChpPivot.listeValeursDt codeCadran1 = new gdfsuezComBefChpPivot.listeValeursDt();
    codeCadran1.code = 'HP';
    cadran_HP.codeCadran = codeCadran1;
    gdfsuezComBefChpDistributeurelectric.quantiteSansDecimalDt cae_HP = new gdfsuezComBefChpDistributeurelectric.quantiteSansDecimalDt();
    cae_HP.valeur = 3000;
    cae_HP.unite ='kWh';
    cadran_HP.cAE = cae_HP;
    cadrans.add(cadran_HP);

    gdfsuezComBefCalypsoPdlelectricite.cadran_element cadran_HC = new gdfsuezComBefCalypsoPdlelectricite.cadran_element();
    gdfsuezComBefChpPivot.listeValeursDt codeCadran2 = new gdfsuezComBefChpPivot.listeValeursDt();
    codeCadran2.code = 'HC';
    cadran_HC.codeCadran = codeCadran2;
    gdfsuezComBefChpDistributeurelectric.quantiteSansDecimalDt cae_HC = new gdfsuezComBefChpDistributeurelectric.quantiteSansDecimalDt();
    cae_HC.valeur = 3000;
    cae_HC.unite ='kWh';
    cadran_HC.cAE = cae_HC;
    cadrans.add(cadran_HC);

    gdfsuezComBefCalypsoPdlelectricite.cadran_element cadran_WE = new gdfsuezComBefCalypsoPdlelectricite.cadran_element();
    gdfsuezComBefChpPivot.listeValeursDt codeCadran3 = new gdfsuezComBefChpPivot.listeValeursDt();
    codeCadran3.code = 'WEC';
    cadran_WE.codeCadran = codeCadran3;
    gdfsuezComBefChpDistributeurelectric.quantiteSansDecimalDt cae_WE = new gdfsuezComBefChpDistributeurelectric.quantiteSansDecimalDt();
    cae_WE.valeur = 3000;
    cae_WE.unite ='kWh';
    cadran_WE.cAE = cae_WE;
    cadrans.add(cadran_WE);

    gdfsuezComBefCalypsoPdlelectricite.cAEParCadran_element cae_cadran = new gdfsuezComBefCalypsoPdlelectricite.cAEParCadran_element();
    cae_cadran.cadran = cadrans;
    consommationValue.cAEParCadran = cae_cadran;
    historiqueMesures1.consommations = consommationValue;
    donnepdl.historiqueMesures = historiqueMesures1;



    response_x.lirePDLElectriciteOutput.donneesPDL = new List < gdfsuezComBefCalypsoPdlelectricite.PDLElectricite > {
      donnepdl
    };
    response.put('response_x', response_x);
    // start - specify the response you want to send
    /* SM_AP11_OffresEtPrix.doAddResponse response_x =
              new calculatorServices.doAddResponse();
          response_x.return_x = 3.0;

          response.put('response_x', response_x); */
  }
}