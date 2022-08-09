/*Author fuzeIT:
*Descritption: Struture de la trame de la prooposition commerciale (classe de test)
*CreatedDate:24/09/2018
*LastModified: MHA  12/12/2018
*/
@isTest
private class gdfsuezBefCalypsoPropositioncommerc_TEST {

	@isTest static void test_method_one() {
		// Implement test code
		Test.setMock(WebServiceMock.class, new gdfsuezBefCalypsoPCMockImpl());
		gdfsuezBefCalypsoPropositioncommerc parentObject = new gdfsuezBefCalypsoPropositioncommerc();
		DOM.Document doc = new DOM.Document();
		DOM.XmlNode mockNode = doc.createRootElement('Envelope', 'http://schemas.xmlsoap.org/soap/envelope/', 'env');
		mockNode.addChildElement('propositionCommerciale', 'http://gdfsuez/bef/calypso/propositioncommerciale/v4', 'test');
		mockNode.addChildElement('idContactCPVEnvoi', 'http://gdfsuez/bef/calypso/propositioncommerciale/v4', 'test');
		mockNode.addChildElement('creerPropositionCommercialeOutput', 'http://gdfsuez/bef/calypso/propositioncommerciale/v4', 'test');
		mockNode.addChildElement('messageRetours', 'http://gdfsuez/bef/calypso/propositioncommerciale/v4', 'test');

		new gdfsuezBefCalypsoPropositioncommerc.creerPropositionCommercialeInputDt(mockNode);
		new gdfsuezBefCalypsoPropositioncommerc.creerPropositionCommercialeOutputDt(mockNode);
		new gdfsuezBefCalypsoPropositioncommerc.creerPropositionCommercialeResponse_element(mockNode);
		new gdfsuezBefCalypsoPropositioncommerc.lirePropositionCommercialeInputDt(mockNode);
		new gdfsuezBefCalypsoPropositioncommerc.lirePropositionCommercialeOutputDt(mockNode);
		new gdfsuezBefCalypsoPropositioncommerc.lirePropositionCommercialeResponse_element(mockNode);
		new gdfsuezBefCalypsoPropositioncommerc.majPropositionCommercialeInputDt(mockNode);
		new gdfsuezBefCalypsoPropositioncommerc.majPropositionCommercialeResponse_element(mockNode);
		new gdfsuezBefCalypsoPropositioncommerc.rechercherPropositionCommercialeInputDt(mockNode);
		new gdfsuezBefCalypsoPropositioncommerc.rechercherPropositionCommercialeOutputDt(mockNode);
		new gdfsuezBefCalypsoPropositioncommerc.rechercherPropositionCommercialeResponse_element(mockNode);
		new gdfsuezBefCalypsoPropositioncommerc.transformerPropositionCommercialeInputDt(mockNode);
		new gdfsuezBefCalypsoPropositioncommerc.transformerPropositionCommercialeOutputDt(mockNode);
		new gdfsuezBefCalypsoPropositioncommerc.transformerPropositionCommercialeOutputDt_objetsCrees_element(mockNode);
		new gdfsuezBefCalypsoPropositioncommerc.transformerPropositionCommercialeOutputDt_objetsMAJ_element(mockNode);
		new gdfsuezBefCalypsoPropositioncommerc.transformerPropositionCommercialeResponse_element(mockNode);
		new gdfsuezComBefCalypsoContrat.ContratAbstract(mockNode);
		new gdfsuezComBefCalypsoContrat.ContratRoot(mockNode);
		new gdfsuezComBefCalypsoDemande.DemandeAbstract(mockNode);
		new gdfsuezComBefCalypsoDemande.DemandeRoot(mockNode);
		new gdfsuezComBefCalypsoNotedebitcredit.NoteDebitCreditAbstract(mockNode);
		new gdfsuezComBefCalypsoNotedebitcredit.NoteDebitCreditRoot(mockNode);
		new gdfsuezComBefCalypsoPersonne.PersonneAbstract(mockNode);
		new gdfsuezComBefCalypsoPersonne.PersonneRoot(mockNode);
		new gdfsuezComBefCalypsoPrestationservi.PrestationServiceAbstract(mockNode);
		new gdfsuezComBefCalypsoPrestationservi.PrestationServiceRoot(mockNode);
		new gdfsuezComBefCalypsoPropositioncomm.datesDt(mockNode);
		new gdfsuezComBefCalypsoPropositioncomm.ObjetsLiesDt(mockNode);
		new gdfsuezComBefCalypsoPropositioncomm.offreDt(mockNode);
		new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale(mockNode);
		new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element(mockNode);
		new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_consommationAnnuelleEstimeeCadrans_consommationAnnuelleEstimeeCadran_element(mockNode);
		new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_consommationAnnuelleEstimeeCadrans_element(mockNode);
		new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element(mockNode);
		new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_remiseRecurrente_element(mockNode);
		new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_refPersonne_element(mockNode);
		new gdfsuezComBefCalypsoPropositioncomm.RemiseOneShotDt(mockNode);
		new gdfsuezComBefChpPivotPC.contextDt(mockNode);
		new gdfsuezComBefChpPivotPC.contextDt_systemPath_element(mockNode);
		new gdfsuezComBefChpPivotPC.contextDt_systemPath_system_element(mockNode);
		new gdfsuezComBefChpPivotPC.horodatageDt(mockNode);
		new gdfsuezComBefChpPivotPC.horodatageDt_valeur_element(mockNode);
		new gdfsuezComBefChpPivotPC.horodatageSimpleDt(mockNode);
		new gdfsuezComBefChpPivotPC.intervalleDt(mockNode);
		new gdfsuezComBefChpPivotPC.intervalleDt_Dates_element(mockNode);
		new gdfsuezComBefChpPivotPC.listeValeursDt(mockNode);
		new gdfsuezComBefChpPivotPC.listeValeursParticulieresDt(mockNode);
		new gdfsuezComBefChpPivotPC.messageRetoursDt(mockNode);
		new gdfsuezComBefChpPivotPC.messageRetoursDt_messageRetour_element(mockNode);
		new gdfsuezComBefChpPivotPC.paginationDt(mockNode);
		new gdfsuezComBefChpPivotPC.refPersonneCreerDt(mockNode);
		new gdfsuezComBefChpPivotPC.refPersonneLireDt(mockNode);
		new gdfsuezComBefChpPivotPC.refPersonneMAJDt(mockNode);
		new gdfsuezComBefChpPivotPC.retourTraitementMessageDt(mockNode);
		new gdfsuezComBefChpPivotPC.retourTraitementMessagesDt(mockNode);
		new gdfsuezComBefChpPivotPC.searchControlRequestDt(mockNode);
		new gdfsuezComBefChpPivotPC.searchControlRequestHeaderDt(mockNode);
		new gdfsuezComBefChpPivotPC.sortDt(mockNode);
		new gdfsuezComBefChpPivotPC.sortDt_field_element(mockNode);
		gdfsuezBefCalypsoPropositioncommerc.creerPropositionCommerciale_element Obj1 = new gdfsuezBefCalypsoPropositioncommerc.creerPropositionCommerciale_element();
		Obj1.populateXmlNode(mockNode);
		gdfsuezBefCalypsoPropositioncommerc.creerPropositionCommercialeInputDt Obj2 = new gdfsuezBefCalypsoPropositioncommerc.creerPropositionCommercialeInputDt();
		Obj2.populateXmlNode(mockNode);
		gdfsuezBefCalypsoPropositioncommerc.creerPropositionCommercialeOutputDt Obj3 = new gdfsuezBefCalypsoPropositioncommerc.creerPropositionCommercialeOutputDt();
		Obj3.populateXmlNode(mockNode);
		new gdfsuezBefCalypsoPropositioncommerc.creerPropositionCommercialeResponse_element();
		gdfsuezBefCalypsoPropositioncommerc.lirePropositionCommerciale_element Obj5 = new gdfsuezBefCalypsoPropositioncommerc.lirePropositionCommerciale_element();
		Obj5.populateXmlNode(mockNode);
		gdfsuezBefCalypsoPropositioncommerc.lirePropositionCommercialeInputDt Obj6 = new gdfsuezBefCalypsoPropositioncommerc.lirePropositionCommercialeInputDt();
		Obj6.populateXmlNode(mockNode);
		gdfsuezBefCalypsoPropositioncommerc.lirePropositionCommercialeOutputDt Obj7 = new gdfsuezBefCalypsoPropositioncommerc.lirePropositionCommercialeOutputDt();
		Obj7.populateXmlNode(mockNode);
		new gdfsuezBefCalypsoPropositioncommerc.lirePropositionCommercialeResponse_element();
		gdfsuezBefCalypsoPropositioncommerc.majPropositionCommerciale_element Obj9 = new gdfsuezBefCalypsoPropositioncommerc.majPropositionCommerciale_element();
		Obj9.populateXmlNode(mockNode);
		gdfsuezBefCalypsoPropositioncommerc.majPropositionCommercialeInputDt Obj10 = new gdfsuezBefCalypsoPropositioncommerc.majPropositionCommercialeInputDt();
		Obj10.populateXmlNode(mockNode);
		new gdfsuezBefCalypsoPropositioncommerc.majPropositionCommercialeResponse_element();
		gdfsuezBefCalypsoPropositioncommerc.rechercherPropositionCommerciale_element Obj12 = new gdfsuezBefCalypsoPropositioncommerc.rechercherPropositionCommerciale_element();
		Obj12.populateXmlNode(mockNode);
		gdfsuezBefCalypsoPropositioncommerc.rechercherPropositionCommercialeInputDt Obj13 = new gdfsuezBefCalypsoPropositioncommerc.rechercherPropositionCommercialeInputDt();
		Obj13.populateXmlNode(mockNode);
		gdfsuezBefCalypsoPropositioncommerc.rechercherPropositionCommercialeOutputDt Obj14 = new gdfsuezBefCalypsoPropositioncommerc.rechercherPropositionCommercialeOutputDt();
		Obj14.populateXmlNode(mockNode);
		new gdfsuezBefCalypsoPropositioncommerc.rechercherPropositionCommercialeResponse_element();
		gdfsuezBefCalypsoPropositioncommerc.transformerPropositionCommerciale_element Obj16 = new gdfsuezBefCalypsoPropositioncommerc.transformerPropositionCommerciale_element();
		Obj16.populateXmlNode(mockNode);
		gdfsuezBefCalypsoPropositioncommerc.transformerPropositionCommercialeInputDt Obj17 = new gdfsuezBefCalypsoPropositioncommerc.transformerPropositionCommercialeInputDt();
		Obj17.populateXmlNode(mockNode);
		gdfsuezBefCalypsoPropositioncommerc.transformerPropositionCommercialeOutputDt Obj18 = new gdfsuezBefCalypsoPropositioncommerc.transformerPropositionCommercialeOutputDt();
		Obj18.populateXmlNode(mockNode);
		gdfsuezBefCalypsoPropositioncommerc.transformerPropositionCommercialeOutputDt_objetsCrees_element Obj19 = new gdfsuezBefCalypsoPropositioncommerc.transformerPropositionCommercialeOutputDt_objetsCrees_element();
		Obj19.populateXmlNode(mockNode);
		gdfsuezBefCalypsoPropositioncommerc.transformerPropositionCommercialeOutputDt_objetsMAJ_element Obj20 = new gdfsuezBefCalypsoPropositioncommerc.transformerPropositionCommercialeOutputDt_objetsMAJ_element();
		Obj20.populateXmlNode(mockNode);
		new gdfsuezBefCalypsoPropositioncommerc.transformerPropositionCommercialeResponse_element();
		gdfsuezComBefCalypsoContrat.ContratAbstract Obj22 = new gdfsuezComBefCalypsoContrat.ContratAbstract();
		Obj22.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoContrat.ContratRoot Obj23 = new gdfsuezComBefCalypsoContrat.ContratRoot();
		Obj23.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoDemande.DemandeAbstract Obj24 = new gdfsuezComBefCalypsoDemande.DemandeAbstract();
		Obj24.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoDemande.DemandeRoot Obj25 = new gdfsuezComBefCalypsoDemande.DemandeRoot();
		Obj25.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoNotedebitcredit.NoteDebitCreditAbstract Obj26 = new gdfsuezComBefCalypsoNotedebitcredit.NoteDebitCreditAbstract();
		Obj26.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoNotedebitcredit.NoteDebitCreditRoot Obj27 = new gdfsuezComBefCalypsoNotedebitcredit.NoteDebitCreditRoot();
		Obj27.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPersonne.PersonneAbstract Obj28 = new gdfsuezComBefCalypsoPersonne.PersonneAbstract();
		Obj28.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPersonne.PersonneRoot Obj29 = new gdfsuezComBefCalypsoPersonne.PersonneRoot();
		Obj29.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPrestationservi.PrestationServiceAbstract Obj30 = new gdfsuezComBefCalypsoPrestationservi.PrestationServiceAbstract();
		Obj30.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPrestationservi.PrestationServiceRoot Obj31 = new gdfsuezComBefCalypsoPrestationservi.PrestationServiceRoot();
		Obj31.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPropositioncomm.datesDt Obj32 = new gdfsuezComBefCalypsoPropositioncomm.datesDt();
		Obj32.valeurDate = '2014-11-05T13:15:30Z';
		Obj32.motifDate = new gdfsuezComBefChpPivotPC.listeValeursDt();
		Obj32.motifDate.categorie = 'motifDate';
		Obj32.motifDate.code = 'dateCreation';
		Obj32.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPropositioncomm.ParseDateTime('2014-11-05T13:15:30Z');
		gdfsuezComBefCalypsoPropositioncomm.ObjetsLiesDt Obj33 = new gdfsuezComBefCalypsoPropositioncomm.ObjetsLiesDt();
		Obj33.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPropositioncomm.offreDt Obj34 = new gdfsuezComBefCalypsoPropositioncomm.offreDt();
		Obj34.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale Obj35 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale();
		Obj35.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element Obj36 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element();
		Obj36.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_consommationAnnuelleEstimeeCadrans_consommationAnnuelleEstimeeCadran_element Obj37 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_consommationAnnuelleEstimeeCadrans_consommationAnnuelleEstimeeCadran_element();
		Obj37.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_consommationAnnuelleEstimeeCadrans_element Obj38 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_consommationAnnuelleEstimeeCadrans_element();
		Obj38.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element Obj39 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element();
		Obj39.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_remiseRecurrente_element Obj40 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_remiseRecurrente_element();
		Obj40.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_refPersonne_element Obj41 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_refPersonne_element();
		Obj41.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPropositioncomm.RemiseOneShotDt Obj42 = new gdfsuezComBefCalypsoPropositioncomm.RemiseOneShotDt();
		Obj42.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotPC.contextDt Obj43 = new gdfsuezComBefChpPivotPC.contextDt();
		Obj43.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotPC.ParseDateTime('2014-11-05T13:15:30Z');
		gdfsuezComBefChpPivotPC.contextDt_systemPath_element Obj44 = new gdfsuezComBefChpPivotPC.contextDt_systemPath_element();
		Obj44.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotPC.contextDt_systemPath_system_element Obj45 = new gdfsuezComBefChpPivotPC.contextDt_systemPath_system_element();
		Obj45.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotPC.horodatageDt Obj46 = new gdfsuezComBefChpPivotPC.horodatageDt();
		Obj46.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotPC.horodatageDt_valeur_element Obj47 = new gdfsuezComBefChpPivotPC.horodatageDt_valeur_element();
		Obj47.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotPC.horodatageSimpleDt Obj48 = new gdfsuezComBefChpPivotPC.horodatageSimpleDt();
		Obj48.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotPC.intervalleDt Obj49 = new gdfsuezComBefChpPivotPC.intervalleDt();
		Obj49.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotPC.intervalleDt_Dates_element Obj50 = new gdfsuezComBefChpPivotPC.intervalleDt_Dates_element();
		Obj50.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotPC.listeValeursDt Obj51 = new gdfsuezComBefChpPivotPC.listeValeursDt();
		Obj51.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotPC.listeValeursParticulieresDt Obj52 = new gdfsuezComBefChpPivotPC.listeValeursParticulieresDt();
		Obj52.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotPC.messageRetoursDt Obj53 = new gdfsuezComBefChpPivotPC.messageRetoursDt();
		Obj53.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotPC.messageRetoursDt_messageRetour_element Obj54 = new gdfsuezComBefChpPivotPC.messageRetoursDt_messageRetour_element();
		Obj54.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotPC.paginationDt Obj55 = new gdfsuezComBefChpPivotPC.paginationDt();
		Obj55.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotPC.refPersonneCreerDt Obj56 = new gdfsuezComBefChpPivotPC.refPersonneCreerDt();
		Obj56.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotPC.refPersonneLireDt Obj57 = new gdfsuezComBefChpPivotPC.refPersonneLireDt();
		Obj57.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotPC.refPersonneMAJDt Obj58 = new gdfsuezComBefChpPivotPC.refPersonneMAJDt();
		Obj58.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotPC.retourTraitementMessageDt Obj59 = new gdfsuezComBefChpPivotPC.retourTraitementMessageDt();
		Obj59.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotPC.retourTraitementMessagesDt Obj60 = new gdfsuezComBefChpPivotPC.retourTraitementMessagesDt();
		Obj60.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotPC.searchControlRequestDt Obj61 = new gdfsuezComBefChpPivotPC.searchControlRequestDt();
		Obj61.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotPC.searchControlRequestHeaderDt Obj62 = new gdfsuezComBefChpPivotPC.searchControlRequestHeaderDt();
		Obj62.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotPC.sortDt Obj63 = new gdfsuezComBefChpPivotPC.sortDt();
		Obj63.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotPC.sortDt_field_element Obj64 = new gdfsuezComBefChpPivotPC.sortDt_field_element();
		Obj64.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPropositioncomm.datesDt Obj65 = new gdfsuezComBefCalypsoPropositioncomm.datesDt(mockNode);
		Obj65.populateXmlNode(mockNode);
	}
	@isTest static void PropositionCommerciale(){
		Test.setMock(WebServiceMock.class, new gdfsuezBefCalypsoPCMockImpl());
		gdfsuezBefCalypsoPropositioncommerc.Dependency testObject = new gdfsuezBefCalypsoPropositioncommerc.Dependency();
		gdfsuezComBefChpPivotPC.contextDt Obj43 = new gdfsuezComBefChpPivotPC.contextDt();
		gdfsuezBefCalypsoPropositioncommerc.creerPropositionCommercialeInputDt Obj2 = new gdfsuezBefCalypsoPropositioncommerc.creerPropositionCommercialeInputDt();
		gdfsuezBefCalypsoPropositioncommerc.creerPropositionCommercialeResponse_element test1 = testObject.CreerPropositionCommerciale(Obj2, Obj43);
		/*System.assertEquals(null, testObject.CreerPropositionCommerciale(Obj2, Obj43));*/
	}
	@isTest static void coverCodeForLirePropositionCommerciale(){
		Test.setMock(WebServiceMock.class, new gdfsuezBefCalypsoPCMockImpl());
		gdfsuezComBefChpPivotPC.contextDt Obj43 = new gdfsuezComBefChpPivotPC.contextDt();
		gdfsuezBefCalypsoPropositioncommerc.lirePropositionCommercialeInputDt Obj6 = new gdfsuezBefCalypsoPropositioncommerc.lirePropositionCommercialeInputDt();
		gdfsuezBefCalypsoPropositioncommerc.Dependency testObject = new gdfsuezBefCalypsoPropositioncommerc.Dependency();
		gdfsuezBefCalypsoPropositioncommerc.lirePropositionCommercialeResponse_element test2 = testObject.LirePropositionCommerciale(Obj6, Obj43);
		/*System.assertEquals(null, testObject.LirePropositionCommerciale(Obj6, Obj43));*/
	}
	@isTest static void coverCodeForMajPropositionCommerciale(){
		Test.setMock(WebServiceMock.class, new gdfsuezBefCalypsoPCMockImpl());
		gdfsuezBefCalypsoPropositioncommerc.Dependency testObject = new gdfsuezBefCalypsoPropositioncommerc.Dependency();
		gdfsuezComBefChpPivotPC.contextDt Obj43 = new gdfsuezComBefChpPivotPC.contextDt();
		gdfsuezBefCalypsoPropositioncommerc.majPropositionCommercialeInputDt Obj10 = new gdfsuezBefCalypsoPropositioncommerc.majPropositionCommercialeInputDt();
		gdfsuezComBefChpPivotPC.retourTraitementMessagesDt test3 = testObject.MajPropositionCommerciale(Obj10, Obj43);
		/*System.assertEquals(null, testObject.MajPropositionCommerciale(Obj10, Obj43));*/
	}
	@isTest static void coverCodeForRechercherPropositionCommerciale(){
		Test.setMock(WebServiceMock.class, new gdfsuezBefCalypsoPCMockImpl());
		gdfsuezBefCalypsoPropositioncommerc.Dependency testObject = new gdfsuezBefCalypsoPropositioncommerc.Dependency();
		gdfsuezComBefChpPivotPC.contextDt Obj43 = new gdfsuezComBefChpPivotPC.contextDt();
		gdfsuezBefCalypsoPropositioncommerc.rechercherPropositionCommercialeInputDt Obj13 = new gdfsuezBefCalypsoPropositioncommerc.rechercherPropositionCommercialeInputDt();
		gdfsuezBefCalypsoPropositioncommerc.rechercherPropositionCommercialeResponse_element test4 = testObject.RechercherPropositionCommerciale(Obj13, Obj43);
		/*System.assertEquals(null, testObject.RechercherPropositionCommerciale(null, null));*/
	}
	@isTest static void coverCodeForTransformerPropositionCommerciale(){
		Test.setMock(WebServiceMock.class, new gdfsuezBefCalypsoPCMockImpl());
		gdfsuezBefCalypsoPropositioncommerc.Dependency testObject = new gdfsuezBefCalypsoPropositioncommerc.Dependency();
		gdfsuezComBefChpPivotPC.contextDt Obj43 = new gdfsuezComBefChpPivotPC.contextDt();
		gdfsuezBefCalypsoPropositioncommerc.transformerPropositionCommercialeInputDt Obj17 = new gdfsuezBefCalypsoPropositioncommerc.transformerPropositionCommercialeInputDt();
		gdfsuezBefCalypsoPropositioncommerc.transformerPropositionCommercialeResponse_element test5 =testObject.TransformerPropositionCommerciale(Obj17, Obj43);
		/*System.assertEquals(null, testObject.TransformerPropositionCommerciale(null, null));*/
	}
	@isTest static void coverCodeForCreerPropositionCommerciale_Http(){
		Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPCHttpMock());
		gdfsuezBefCalypsoPropositioncommerc.Dependency testObject = new gdfsuezBefCalypsoPropositioncommerc.Dependency();
		gdfsuezComBefChpPivotPC.contextDt Obj43 = new gdfsuezComBefChpPivotPC.contextDt();
		gdfsuezBefCalypsoPropositioncommerc.creerPropositionCommercialeInputDt Obj2 = new gdfsuezBefCalypsoPropositioncommerc.creerPropositionCommercialeInputDt();
		gdfsuezBefCalypsoPropositioncommerc.creerPropositionCommercialeResponse_element test6 = testObject.CreerPropositionCommerciale_Http(Obj2, Obj43);
		/*System.assertEquals(null, testObject.CreerPropositionCommerciale_Http(null, null));*/
	}
	@isTest static void coverCodeForLirePropositionCommerciale_Http(){
		Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPCHttpMock());
		gdfsuezBefCalypsoPropositioncommerc.Dependency testObject = new gdfsuezBefCalypsoPropositioncommerc.Dependency();
		gdfsuezComBefChpPivotPC.contextDt Obj43 = new gdfsuezComBefChpPivotPC.contextDt();
		gdfsuezBefCalypsoPropositioncommerc.lirePropositionCommercialeInputDt Obj6 = new gdfsuezBefCalypsoPropositioncommerc.lirePropositionCommercialeInputDt();
		gdfsuezBefCalypsoPropositioncommerc.lirePropositionCommercialeResponse_element test7 = testObject.LirePropositionCommerciale_Http(Obj6, Obj43);
		/*System.assertEquals(null, testObject.LirePropositionCommerciale_Http(null, null));*/
	}
	@isTest static void coverCodeForMajPropositionCommerciale_Http(){
		Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPCHttpMock());
		gdfsuezBefCalypsoPropositioncommerc.Dependency testObject = new gdfsuezBefCalypsoPropositioncommerc.Dependency();
		gdfsuezComBefChpPivotPC.contextDt Obj43 = new gdfsuezComBefChpPivotPC.contextDt();
		gdfsuezBefCalypsoPropositioncommerc.majPropositionCommercialeInputDt Obj10 = new gdfsuezBefCalypsoPropositioncommerc.majPropositionCommercialeInputDt();
		gdfsuezComBefChpPivotPC.retourTraitementMessagesDt test8 = testObject.MajPropositionCommerciale_Http(Obj10, Obj43);
		/*System.assertEquals(null, testObject.MajPropositionCommerciale_Http(Obj9, null));*/
	}
	@isTest static void coverCodeForRechercherPropositionCommerciale_Http(){
		Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPCHttpMock());
		gdfsuezBefCalypsoPropositioncommerc.Dependency testObject = new gdfsuezBefCalypsoPropositioncommerc.Dependency();
		gdfsuezComBefChpPivotPC.contextDt Obj43 = new gdfsuezComBefChpPivotPC.contextDt();
		gdfsuezBefCalypsoPropositioncommerc.rechercherPropositionCommercialeInputDt Obj13 = new gdfsuezBefCalypsoPropositioncommerc.rechercherPropositionCommercialeInputDt();
		gdfsuezBefCalypsoPropositioncommerc.rechercherPropositionCommercialeResponse_element test9 = testObject.RechercherPropositionCommerciale_Http(Obj13, Obj43);
		/*System.assertEquals(null, testObject.RechercherPropositionCommerciale_Http(null, null));*/
	}
	@isTest static void coverCodeForTransformerPropositionCommerciale_Http(){
		Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPCHttpMock());
		gdfsuezBefCalypsoPropositioncommerc.Dependency testObject = new gdfsuezBefCalypsoPropositioncommerc.Dependency();
		gdfsuezComBefChpPivotPC.contextDt Obj43 = new gdfsuezComBefChpPivotPC.contextDt();
		gdfsuezBefCalypsoPropositioncommerc.transformerPropositionCommercialeInputDt Obj17 = new gdfsuezBefCalypsoPropositioncommerc.transformerPropositionCommercialeInputDt();
		gdfsuezBefCalypsoPropositioncommerc.transformerPropositionCommercialeResponse_element test10 = testObject.TransformerPropositionCommerciale_Http(Obj17, Obj43);
		/*System.assertEquals(null, testObject.TransformerPropositionCommerciale_Http(null, null));*/
	}
}