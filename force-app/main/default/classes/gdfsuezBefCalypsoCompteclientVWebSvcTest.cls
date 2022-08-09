//Generated by FuseIT WSDL2Apex (http://www.fuseit.com/Solutions/SFDC-Explorer/Help-WSDL-Parser.aspx)

@isTest
private class gdfsuezBefCalypsoCompteclientVWebSvcTest {

	@isTest static void coverGeneratedCodeTypes() {
		Test.setMock(WebServiceMock.class, new gdfsuezBefCalypsoCompteclientV6MockImpl());
		gdfsuezBefCalypsoCompteclientV6 parentObject = new gdfsuezBefCalypsoCompteclientV6();
		DOM.Document doc = new DOM.Document();
		DOM.XmlNode mockNode = doc.createRootElement('Envelope', 'http://schemas.xmlsoap.org/soap/envelope/', 'env');
		new gdfsuezBefCalypsoCompteclientV6.activerServiceGestionInputDt(mockNode);
		new gdfsuezBefCalypsoCompteclientV6.activerServiceGestionOutputDt(mockNode);
		new gdfsuezBefCalypsoCompteclientV6.activerServiceGestionResponse_element(mockNode);
		new gdfsuezBefCalypsoCompteclientV6.creerCompteClientInputDt(mockNode);
		new gdfsuezBefCalypsoCompteclientV6.creerCompteClientOutputDt(mockNode);
		new gdfsuezBefCalypsoCompteclientV6.creerCompteClientResponse_element(mockNode);
		new gdfsuezBefCalypsoCompteclientV6.desactiverServiceGestionInputDt(mockNode);
		new gdfsuezBefCalypsoCompteclientV6.desactiverServiceGestionOutputDt(mockNode);
		new gdfsuezBefCalypsoCompteclientV6.desactiverServiceGestionResponse_element(mockNode);
		new gdfsuezBefCalypsoCompteclientV6.lireCompteClientInputDt(mockNode);
		new gdfsuezBefCalypsoCompteclientV6.lireCompteClientOutputDt(mockNode);
		new gdfsuezBefCalypsoCompteclientV6.lireCompteClientResponse_element(mockNode);
		new gdfsuezBefCalypsoCompteclientV6.lireTypologieFRInputDt(mockNode);
		new gdfsuezBefCalypsoCompteclientV6.lireTypologieFROutputDt(mockNode);
		new gdfsuezBefCalypsoCompteclientV6.lireTypologieFRResponse_element(mockNode);
		new gdfsuezBefCalypsoCompteclientV6.majCompteClientInputDt(mockNode);
		new gdfsuezBefCalypsoCompteclientV6.majCompteClientResponse_element(mockNode);
		new gdfsuezBefCalypsoCompteclientV6.rechercherCompteClientInputDt(mockNode);
		new gdfsuezBefCalypsoCompteclientV6.rechercherCompteClientOutputDt(mockNode);
		new gdfsuezBefCalypsoCompteclientV6.rechercherCompteClientResponse_element(mockNode);
		new gdfsuezComBefCalypsoComptecltV6.CompteClient(mockNode);
		new gdfsuezComBefCalypsoComptecltV6.CompteClient_blocages_element(mockNode);
		new gdfsuezComBefCalypsoComptecltV6.CompteClient_referencePersonne_element(mockNode);
		new gdfsuezComBefCalypsoComptecltV6.CompteClient_serviceSouscrit_element(mockNode);
		new gdfsuezComBefCalypsoComptecltV6.CompteClient_typologieFR_element(mockNode);
		new gdfsuezComBefCalypsoCoordonneesbanc.CoordonneesBancairesAbstract(mockNode);
		new gdfsuezComBefCalypsoCoordonneesbanc.CoordonneesBancairesRoot(mockNode);
		new gdfsuezComBefCalypsoFacture.FactureAbstract(mockNode);
		new gdfsuezComBefCalypsoFacture.FactureRoot(mockNode);
		new gdfsuezComBefCalypsoLocal_2.LocalAbstract(mockNode);
		new gdfsuezComBefCalypsoLocal_2.LocalRoot(mockNode);
		new gdfsuezComBefCalypsoPersonne.PersonneAbstract(mockNode);
		new gdfsuezComBefCalypsoPersonne.PersonneRoot(mockNode);
		new gdfsuezComBefCalypsoPlanmensualisat.PlanMensualisationAbstract(mockNode);
		new gdfsuezComBefCalypsoPlanmensualisat.PlanMensualisationRoot(mockNode);
		new gdfsuezComBefCalypsoTaf.TAFAbstract(mockNode);
		new gdfsuezComBefCalypsoTaf.TAFRoot(mockNode);
		new gdfsuezComBefChpPivotCompteClient.contextDt(mockNode);
		new gdfsuezComBefChpPivotCompteClient.contextDt_systemPath_element(mockNode);
		new gdfsuezComBefChpPivotCompteClient.contextDt_systemPath_system_element(mockNode);
		new gdfsuezComBefChpPivotCompteClient.horodatageDt(mockNode);
		new gdfsuezComBefChpPivotCompteClient.horodatageDt_valeur_element(mockNode);
		new gdfsuezComBefChpPivotCompteClient.horodatageSimpleDt(mockNode);
		new gdfsuezComBefChpPivotCompteClient.intervalleDt(mockNode);
		new gdfsuezComBefChpPivotCompteClient.intervalleDt_Dates_element(mockNode);
		new gdfsuezComBefChpPivotCompteClient.listeValeursDt(mockNode);
		new gdfsuezComBefChpPivotCompteClient.listeValeursParticulieresDt(mockNode);
		new gdfsuezComBefChpPivotCompteClient.messageRetoursDt(mockNode);
		new gdfsuezComBefChpPivotCompteClient.messageRetoursDt_messageRetour_element(mockNode);
		new gdfsuezComBefChpPivotCompteClient.paginationDt(mockNode);
		new gdfsuezComBefChpPivotCompteClient.refPersonneCreerDt(mockNode);
		new gdfsuezComBefChpPivotCompteClient.refPersonneLireDt(mockNode);
		new gdfsuezComBefChpPivotCompteClient.refPersonneMAJDt(mockNode);
		new gdfsuezComBefChpPivotCompteClient.retourTraitementMessageDt(mockNode);
		new gdfsuezComBefChpPivotCompteClient.retourTraitementMessagesDt(mockNode);
		new gdfsuezComBefChpPivotCompteClient.searchControlRequestDt(mockNode);
		new gdfsuezComBefChpPivotCompteClient.searchControlRequestHeaderDt(mockNode);
		new gdfsuezComBefChpPivotCompteClient.sortDt(mockNode);
		new gdfsuezComBefChpPivotCompteClient.sortDt_field_element(mockNode);
		gdfsuezBefCalypsoCompteclientV6.activerServiceGestion_element Obj1 = new gdfsuezBefCalypsoCompteclientV6.activerServiceGestion_element();
		Obj1.populateXmlNode(mockNode);
		gdfsuezBefCalypsoCompteclientV6.activerServiceGestionInputDt Obj2 = new gdfsuezBefCalypsoCompteclientV6.activerServiceGestionInputDt();
		Obj2.populateXmlNode(mockNode);
		gdfsuezBefCalypsoCompteclientV6.activerServiceGestionOutputDt Obj3 = new gdfsuezBefCalypsoCompteclientV6.activerServiceGestionOutputDt();
		Obj3.populateXmlNode(mockNode);
		new gdfsuezBefCalypsoCompteclientV6.activerServiceGestionResponse_element();
		gdfsuezBefCalypsoCompteclientV6.creerCompteClient_element Obj5 = new gdfsuezBefCalypsoCompteclientV6.creerCompteClient_element();
		Obj5.populateXmlNode(mockNode);
		gdfsuezBefCalypsoCompteclientV6.creerCompteClientInputDt Obj6 = new gdfsuezBefCalypsoCompteclientV6.creerCompteClientInputDt();
		Obj6.populateXmlNode(mockNode);
		gdfsuezBefCalypsoCompteclientV6.creerCompteClientOutputDt Obj7 = new gdfsuezBefCalypsoCompteclientV6.creerCompteClientOutputDt();
		Obj7.populateXmlNode(mockNode);

		new gdfsuezBefCalypsoCompteclientV6.creerCompteClientResponse_element();
		gdfsuezBefCalypsoCompteclientV6.desactiverServiceGestion_element Obj9 = new gdfsuezBefCalypsoCompteclientV6.desactiverServiceGestion_element();
		Obj9.populateXmlNode(mockNode);
		gdfsuezBefCalypsoCompteclientV6.desactiverServiceGestionInputDt Obj10 = new gdfsuezBefCalypsoCompteclientV6.desactiverServiceGestionInputDt();
		Obj10.populateXmlNode(mockNode);
		gdfsuezBefCalypsoCompteclientV6.desactiverServiceGestionOutputDt Obj11 = new gdfsuezBefCalypsoCompteclientV6.desactiverServiceGestionOutputDt();
		Obj11.populateXmlNode(mockNode);
		new gdfsuezBefCalypsoCompteclientV6.desactiverServiceGestionResponse_element();
		gdfsuezBefCalypsoCompteclientV6.lireCompteClient_element Obj13 = new gdfsuezBefCalypsoCompteclientV6.lireCompteClient_element();
		Obj13.populateXmlNode(mockNode);
		gdfsuezBefCalypsoCompteclientV6.lireCompteClientInputDt Obj14 = new gdfsuezBefCalypsoCompteclientV6.lireCompteClientInputDt();
		Obj14.populateXmlNode(mockNode);
		gdfsuezBefCalypsoCompteclientV6.lireCompteClientOutputDt Obj15 = new gdfsuezBefCalypsoCompteclientV6.lireCompteClientOutputDt();
		Obj15.populateXmlNode(mockNode);
		new gdfsuezBefCalypsoCompteclientV6.lireCompteClientResponse_element();
		gdfsuezBefCalypsoCompteclientV6.lireTypologieFR_element Obj17 = new gdfsuezBefCalypsoCompteclientV6.lireTypologieFR_element();
		Obj17.populateXmlNode(mockNode);
		gdfsuezBefCalypsoCompteclientV6.lireTypologieFRInputDt Obj18 = new gdfsuezBefCalypsoCompteclientV6.lireTypologieFRInputDt();
		Obj18.populateXmlNode(mockNode);
		gdfsuezBefCalypsoCompteclientV6.lireTypologieFROutputDt Obj19 = new gdfsuezBefCalypsoCompteclientV6.lireTypologieFROutputDt();
		Obj19.populateXmlNode(mockNode);
		new gdfsuezBefCalypsoCompteclientV6.lireTypologieFRResponse_element();
		gdfsuezBefCalypsoCompteclientV6.majCompteClient_element Obj21 = new gdfsuezBefCalypsoCompteclientV6.majCompteClient_element();
		Obj21.populateXmlNode(mockNode);
		gdfsuezBefCalypsoCompteclientV6.majCompteClientInputDt Obj22 = new gdfsuezBefCalypsoCompteclientV6.majCompteClientInputDt();
		Obj22.populateXmlNode(mockNode);
		new gdfsuezBefCalypsoCompteclientV6.majCompteClientResponse_element();
		gdfsuezBefCalypsoCompteclientV6.rechercherCompteClient_element Obj24 = new gdfsuezBefCalypsoCompteclientV6.rechercherCompteClient_element();
		Obj24.populateXmlNode(mockNode);
		gdfsuezBefCalypsoCompteclientV6.rechercherCompteClientInputDt Obj25 = new gdfsuezBefCalypsoCompteclientV6.rechercherCompteClientInputDt();
		Obj25.populateXmlNode(mockNode);
		gdfsuezBefCalypsoCompteclientV6.rechercherCompteClientOutputDt Obj26 = new gdfsuezBefCalypsoCompteclientV6.rechercherCompteClientOutputDt();
		Obj26.populateXmlNode(mockNode);
		new gdfsuezBefCalypsoCompteclientV6.rechercherCompteClientResponse_element();
		gdfsuezComBefCalypsoComptecltV6.CompteClient Obj28 = new gdfsuezComBefCalypsoComptecltV6.CompteClient();
		Obj28.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoComptecltV6.ParseDateTime('2014-11-05T13:15:30Z');
         gdfsuezComBefCalypsoComptecltV6.CompteClient_blocages_element  Obj29  =  new gdfsuezComBefCalypsoComptecltV6.CompteClient_blocages_element();
        Obj29.populateXmlNode(mockNode);
	//	gdfsuezComBefCalypsoComptecltV.blocages_element Obj29 = new gdfsuezComBefCalypsoComptecltV6.blocages_element();
	//	Obj29.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoComptecltV6.CompteClient_referencePersonne_element Obj30 = new gdfsuezComBefCalypsoComptecltV6.CompteClient_referencePersonne_element();
		Obj30.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoComptecltV6.CompteClient_serviceSouscrit_element Obj31 = new gdfsuezComBefCalypsoComptecltV6.CompteClient_serviceSouscrit_element();
		Obj31.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoComptecltV6.CompteClient_typologieFR_element Obj32 = new gdfsuezComBefCalypsoComptecltV6.CompteClient_typologieFR_element();
		Obj32.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoCoordonneesbanc.CoordonneesBancairesAbstract Obj33 = new gdfsuezComBefCalypsoCoordonneesbanc.CoordonneesBancairesAbstract();
		Obj33.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoCoordonneesbanc.CoordonneesBancairesRoot Obj34 = new gdfsuezComBefCalypsoCoordonneesbanc.CoordonneesBancairesRoot();
		Obj34.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoFacture.FactureAbstract Obj35 = new gdfsuezComBefCalypsoFacture.FactureAbstract();
		Obj35.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoFacture.FactureRoot Obj36 = new gdfsuezComBefCalypsoFacture.FactureRoot();
		Obj36.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoLocal_2.LocalAbstract Obj37 = new gdfsuezComBefCalypsoLocal_2.LocalAbstract();
		Obj37.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoLocal_2.LocalRoot Obj38 = new gdfsuezComBefCalypsoLocal_2.LocalRoot();
		Obj38.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPersonne.PersonneAbstract Obj39 = new gdfsuezComBefCalypsoPersonne.PersonneAbstract();
		Obj39.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPersonne.PersonneRoot Obj40 = new gdfsuezComBefCalypsoPersonne.PersonneRoot();
		Obj40.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPlanmensualisat.PlanMensualisationAbstract Obj41 = new gdfsuezComBefCalypsoPlanmensualisat.PlanMensualisationAbstract();
		Obj41.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPlanmensualisat.PlanMensualisationRoot Obj42 = new gdfsuezComBefCalypsoPlanmensualisat.PlanMensualisationRoot();
		Obj42.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoTaf.TAFAbstract Obj43 = new gdfsuezComBefCalypsoTaf.TAFAbstract();
		Obj43.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoTaf.TAFRoot Obj44 = new gdfsuezComBefCalypsoTaf.TAFRoot();
		Obj44.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotCompteClient.contextDt Obj45 = new gdfsuezComBefChpPivotCompteClient.contextDt();
		Obj45.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotCompteClient.ParseDateTime('2014-11-05T13:15:30Z');
		gdfsuezComBefChpPivotCompteClient.contextDt_systemPath_element Obj46 = new gdfsuezComBefChpPivotCompteClient.contextDt_systemPath_element();
		Obj46.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotCompteClient.contextDt_systemPath_system_element Obj47 = new gdfsuezComBefChpPivotCompteClient.contextDt_systemPath_system_element();
		Obj47.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotCompteClient.horodatageDt Obj48 = new gdfsuezComBefChpPivotCompteClient.horodatageDt();
		Obj48.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotCompteClient.horodatageDt_valeur_element Obj49 = new gdfsuezComBefChpPivotCompteClient.horodatageDt_valeur_element();
		Obj49.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotCompteClient.horodatageSimpleDt Obj50 = new gdfsuezComBefChpPivotCompteClient.horodatageSimpleDt();
		Obj50.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotCompteClient.intervalleDt Obj51 = new gdfsuezComBefChpPivotCompteClient.intervalleDt();
		Obj51.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotCompteClient.intervalleDt_Dates_element Obj52 = new gdfsuezComBefChpPivotCompteClient.intervalleDt_Dates_element();
		Obj52.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotCompteClient.listeValeursDt Obj53 = new gdfsuezComBefChpPivotCompteClient.listeValeursDt();
		Obj53.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotCompteClient.listeValeursParticulieresDt Obj54 = new gdfsuezComBefChpPivotCompteClient.listeValeursParticulieresDt();
		Obj54.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotCompteClient.messageRetoursDt Obj55 = new gdfsuezComBefChpPivotCompteClient.messageRetoursDt();
		Obj55.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotCompteClient.messageRetoursDt_messageRetour_element Obj56 = new gdfsuezComBefChpPivotCompteClient.messageRetoursDt_messageRetour_element();
		Obj56.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotCompteClient.paginationDt Obj57 = new gdfsuezComBefChpPivotCompteClient.paginationDt();
		Obj57.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotCompteClient.refPersonneCreerDt Obj58 = new gdfsuezComBefChpPivotCompteClient.refPersonneCreerDt();
		Obj58.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotCompteClient.refPersonneLireDt Obj59 = new gdfsuezComBefChpPivotCompteClient.refPersonneLireDt();
		Obj59.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotCompteClient.refPersonneMAJDt Obj60 = new gdfsuezComBefChpPivotCompteClient.refPersonneMAJDt();
		Obj60.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotCompteClient.retourTraitementMessageDt Obj61 = new gdfsuezComBefChpPivotCompteClient.retourTraitementMessageDt();
		Obj61.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotCompteClient.retourTraitementMessagesDt Obj62 = new gdfsuezComBefChpPivotCompteClient.retourTraitementMessagesDt();
		Obj62.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotCompteClient.searchControlRequestDt Obj63 = new gdfsuezComBefChpPivotCompteClient.searchControlRequestDt();
		Obj63.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotCompteClient.searchControlRequestHeaderDt Obj64 = new gdfsuezComBefChpPivotCompteClient.searchControlRequestHeaderDt();
		Obj64.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotCompteClient.sortDt Obj65 = new gdfsuezComBefChpPivotCompteClient.sortDt();
		Obj65.populateXmlNode(mockNode);
		gdfsuezComBefChpPivotCompteClient.sortDt_field_element Obj66 = new gdfsuezComBefChpPivotCompteClient.sortDt_field_element();
		Obj66.populateXmlNode(mockNode);
        gdfsuezComBefCalypsoComptecltV6.CompteClientAbstract test = new gdfsuezComBefCalypsoComptecltV6.CompteClientAbstract() ;

         gdfsuezComBefCalypsoComptecltV6.CompteClientAbstract test1 = new   gdfsuezComBefCalypsoComptecltV6.CompteClientAbstract(mockNode);
         test.populateXmlNode(mockNode);

	}
	@isTest static void coverCodeForActiverServiceGestion(){
		Test.setMock(WebServiceMock.class, new gdfsuezBefCalypsoCompteclientV6MockImpl());
		gdfsuezBefCalypsoCompteclientV6.Dependency testObject = new gdfsuezBefCalypsoCompteclientV6.Dependency();
		//System.assertEquals(null, testObject.ActiverServiceGestion(null, null));
	 testObject.ActiverServiceGestion(null, null) ;
    }
	@isTest static void coverCodeForCreerCompteClient(){
		Test.setMock(WebServiceMock.class, new gdfsuezBefCalypsoCompteclientV6MockImpl());
		gdfsuezBefCalypsoCompteclientV6.Dependency testObject = new gdfsuezBefCalypsoCompteclientV6.Dependency();
	//	System.assertEquals(null, testObject.CreerCompteClient(null, null));
	testObject.CreerCompteClient(null, null) ;
    }
	@isTest static void coverCodeForDesactiverServiceGestion(){
		Test.setMock(WebServiceMock.class, new gdfsuezBefCalypsoCompteclientV6MockImpl());
		gdfsuezBefCalypsoCompteclientV6.Dependency testObject = new gdfsuezBefCalypsoCompteclientV6.Dependency();
		//System.assertEquals(null, testObject.DesactiverServiceGestion(null, null));
        testObject.DesactiverServiceGestion(null, null)	;
    }
	@isTest static void coverCodeForLireCompteClient(){
		Test.setMock(WebServiceMock.class, new gdfsuezBefCalypsoCompteclientV6MockImpl());
		gdfsuezBefCalypsoCompteclientV6.Dependency testObject = new gdfsuezBefCalypsoCompteclientV6.Dependency();
	//	System.assertEquals(null, testObject.LireCompteClient(null, null));
	 testObject.LireCompteClient(null, null) ;
    }
	@isTest static void coverCodeForLireTypologieFR(){
		Test.setMock(WebServiceMock.class, new gdfsuezBefCalypsoCompteclientV6MockImpl());
		gdfsuezBefCalypsoCompteclientV6.Dependency testObject = new gdfsuezBefCalypsoCompteclientV6.Dependency();
	//	System.assertEquals(null, testObject.LireTypologieFR(null, null));
	 testObject.LireTypologieFR(null, null) ;
    }
	@isTest static void coverCodeForMajCompteClient(){
		Test.setMock(WebServiceMock.class, new gdfsuezBefCalypsoCompteclientV6MockImpl());
		gdfsuezBefCalypsoCompteclientV6.Dependency testObject = new gdfsuezBefCalypsoCompteclientV6.Dependency();
	//	System.assertEquals(null, testObject.MajCompteClient(null, null));
	testObject.MajCompteClient(null, null) ;
    }
	@isTest static void coverCodeForRechercherCompteClient(){
		Test.setMock(WebServiceMock.class, new gdfsuezBefCalypsoCompteclientV6MockImpl());
		gdfsuezBefCalypsoCompteclientV6.Dependency testObject = new gdfsuezBefCalypsoCompteclientV6.Dependency();
	//	System.assertEquals(null, testObject.RechercherCompteClient(null, null));
	testObject.RechercherCompteClient(null, null) ;
    }
	@isTest static void coverCodeForActiverServiceGestion_Http(){
		Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoCompteclientV6HttpMock());
		gdfsuezBefCalypsoCompteclientV6.Dependency testObject = new gdfsuezBefCalypsoCompteclientV6.Dependency();
	//	System.assertEquals(null, testObject.ActiverServiceGestion_Http(null, null));
	testObject.ActiverServiceGestion_Http(null, null);
    }
	@isTest static void coverCodeForCreerCompteClient_Http(){
		Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoCompteclientV6HttpMock());
		gdfsuezBefCalypsoCompteclientV6.Dependency testObject = new gdfsuezBefCalypsoCompteclientV6.Dependency();
		testObject.CreerCompteClient_Http(null, null);
        //System.assertEquals(null, testObject.CreerCompteClient_Http(null, null));
	}
	@isTest static void coverCodeForDesactiverServiceGestion_Http(){
		Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoCompteclientV6HttpMock());
		gdfsuezBefCalypsoCompteclientV6.Dependency testObject = new gdfsuezBefCalypsoCompteclientV6.Dependency();
		//System.assertEquals(null, testObject.DesactiverServiceGestion_Http(null, null));
	   testObject.DesactiverServiceGestion_Http(null, null) ;
    }
	@isTest static void coverCodeForLireCompteClient_Http(){
		Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoCompteclientV6HttpMock());
		gdfsuezBefCalypsoCompteclientV6.Dependency testObject = new gdfsuezBefCalypsoCompteclientV6.Dependency();
		//System.assertEquals(null, testObject.LireCompteClient_Http(null, null));
		testObject.LireCompteClient_Http(null, null) ;
	}
	@isTest static void coverCodeForLireTypologieFR_Http(){
		Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoCompteclientV6HttpMock());
		gdfsuezBefCalypsoCompteclientV6.Dependency testObject = new gdfsuezBefCalypsoCompteclientV6.Dependency();
		//System.assertEquals(null, testObject.LireTypologieFR_Http(null, null));
		testObject.LireTypologieFR_Http(null, null) ;
	}
	@isTest static void coverCodeForMajCompteClient_Http(){
		Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoCompteclientV6HttpMock());
		gdfsuezBefCalypsoCompteclientV6.Dependency testObject = new gdfsuezBefCalypsoCompteclientV6.Dependency();
		//System.assertEquals(null, testObject.MajCompteClient_Http(null, null));
	   testObject.MajCompteClient_Http(null, null);
    }
	@isTest static void coverCodeForRechercherCompteClient_Http(){
		Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoCompteclientV6HttpMock());
		gdfsuezBefCalypsoCompteclientV6.Dependency testObject = new gdfsuezBefCalypsoCompteclientV6.Dependency();
		//System.assertEquals(null, testObject.RechercherCompteClient_Http(null, null));
		testObject.RechercherCompteClient_Http(null, null);
	}
}