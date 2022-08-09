//Generated by FuseIT WSDL2Apex (http://www.fuseit.com/Solutions/SFDC-Explorer/Help-WSDL-Parser.aspx)

@isTest
private class gdfsuezBefCalypsoPdlgazV2WebSvcTest {
	
	@isTest static void coverGeneratedCodeTypes() {
		Test.setMock(WebServiceMock.class, new gdfsuezBefCalypsoPdlgazV2MockImpl());
		gdfsuezBefCalypsoPdlgazV2 parentObject = new gdfsuezBefCalypsoPdlgazV2();
		DOM.Document doc = new DOM.Document();
		DOM.XmlNode mockNode = doc.createRootElement('Envelope', 'http://schemas.xmlsoap.org/soap/envelope/', 'env');
		new gdfsuezBefCalypsoPdlgazV2.ConsommationJournaliereDt(mockNode);				
		new gdfsuezBefCalypsoPdlgazV2.creerPDLGazInputDt(mockNode);				
		new gdfsuezBefCalypsoPdlgazV2.creerPDLGazOutputDt(mockNode);				
		new gdfsuezBefCalypsoPdlgazV2.creerPDLGazResponse_element(mockNode);				
		new gdfsuezBefCalypsoPdlgazV2.DonneesConsommationsJournalieresDt(mockNode);				
		new gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt(mockNode);				
		new gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt_PDLGaz_element(mockNode);				
		new gdfsuezBefCalypsoPdlgazV2.lirePDLGazOutputDt(mockNode);				
		new gdfsuezBefCalypsoPdlgazV2.lirePDLGazResponse_element(mockNode);				
		new gdfsuezBefCalypsoPdlgazV2.majPDLGazInputDt(mockNode);				
		new gdfsuezBefCalypsoPdlgazV2.majPDLGazOutputDt(mockNode);				
		new gdfsuezBefCalypsoPdlgazV2.majPDLGazResponse_element(mockNode);				
		new gdfsuezBefCalypsoPdlgazV2.PDLGaz(mockNode);				
		new gdfsuezBefCalypsoPdlgazV2.PDLGaz_CAR_element(mockNode);				
		new gdfsuezBefCalypsoPdlgazV2.PDLGaz_dernieresReleves_element(mockNode);				
		new gdfsuezBefCalypsoPdlgazV2.PDLGaz_derniersIndex_element(mockNode);				
		new gdfsuezBefCalypsoPdlgazV2.PDLGaz_derniersIndex_index_element(mockNode);				
		new gdfsuezBefCalypsoPdlgazV2.PDLGaz_donneesContractuelles_element(mockNode);				
		new gdfsuezBefCalypsoPdlgazV2.PDLGaz_PITD_element(mockNode);				
		new gdfsuezBefCalypsoPdlgazV2.releve6M_1MDt(mockNode);				
		new gdfsuezComBefCalypsoLocal.LocalAbstract(mockNode);				
	//	new gdfsuezComBefCalypsoLocal.LocalRoot(mockNode);				
		new gdfsuezComBefCalypsoPdlgaz.CARDt(mockNode);				
		new gdfsuezComBefCalypsoPdlgaz.compteurDt(mockNode);				
		new gdfsuezComBefCalypsoPdlgaz.ConsommationJournaliereDt(mockNode);				
	//	new gdfsuezComBefCalypsoPdlgaz.DonneesConsommationsJournalieresDt(mockNode);				
		new gdfsuezComBefCalypsoPdlgaz.donneesCoupureDt(mockNode);				
		new gdfsuezComBefCalypsoPdlgaz.donneesReleveDt(mockNode);				
		new gdfsuezComBefCalypsoPdlgaz.GazparDt(mockNode);				
		new gdfsuezComBefCalypsoPdlgaz.GazparDt_deploiement_element(mockNode);				
		new gdfsuezComBefCalypsoPdlgaz.installationDt(mockNode);				
		new gdfsuezComBefCalypsoPdlgaz.releve6M_1MDt(mockNode);				
		new gdfsuezComBefCalypsoPdlgaz.utilisateurFinalDt(mockNode);				
		new gdfsuezComBefChpCommunadresse.adresseCommunDt(mockNode);				
		new gdfsuezComBefChpPivot.contextDt(mockNode);				
		new gdfsuezComBefChpPivot.systemPath_element(mockNode);				
		new gdfsuezComBefChpPivot.system_element(mockNode);				
//		new gdfsuezComBefChpPivot.horodatageDt(mockNode);				
		new gdfsuezComBefChpPivot.horodatageDt_valeur_element(mockNode);				
	//	new gdfsuezComBefChpPivot.horodatageSimpleDt(mockNode);				
	//	new gdfsuezComBefChpPivot.intervalleDt(mockNode);				
		new gdfsuezComBefChpPivot.intervalleDt_Dates_element(mockNode);				
		new gdfsuezComBefChpPivot.listeValeursDt(mockNode);				
//		new gdfsuezComBefChpPivot.listeValeursParticulieresDt(mockNode);				
//		new gdfsuezComBefChpPivot.messageRetoursDt(mockNode);				
		new gdfsuezComBefChpPivot.messageRetoursDt_messageRetour_element(mockNode);				
	//	new gdfsuezComBefChpPivot.paginationDt(mockNode);				
	//	new gdfsuezComBefChpPivot.refPersonneCreerDt(mockNode);				
	//	new gdfsuezComBefChpPivot.refPersonneLireDt(mockNode);				
	//	new gdfsuezComBefChpPivot.refPersonneMAJDt(mockNode);				
		new gdfsuezComBefChpPivot.retourTraitementMessageDt(mockNode);				
		new gdfsuezComBefChpPivot.retourTraitementMessagesDt(mockNode);				
	//	new gdfsuezComBefChpPivot.searchControlRequestDt(mockNode);				
	//	new gdfsuezComBefChpPivot.searchControlRequestHeaderDt(mockNode);				
//new gdfsuezComBefChpPivot.sortDt(mockNode);				
		new gdfsuezComBefChpPivot.sortDt_field_element(mockNode);				
		gdfsuezBefCalypsoPdlgazV2.ConsommationJournaliereDt Obj1 = new gdfsuezBefCalypsoPdlgazV2.ConsommationJournaliereDt();
		Obj1.populateXmlNode(mockNode);
		gdfsuezBefCalypsoPdlgazV2.ParseDateTime('2014-11-05T13:15:30Z');
		gdfsuezBefCalypsoPdlgazV2.creerPDLGaz_element Obj2 = new gdfsuezBefCalypsoPdlgazV2.creerPDLGaz_element();
		Obj2.populateXmlNode(mockNode);
		gdfsuezBefCalypsoPdlgazV2.creerPDLGazInputDt Obj3 = new gdfsuezBefCalypsoPdlgazV2.creerPDLGazInputDt();
		Obj3.populateXmlNode(mockNode);
		gdfsuezBefCalypsoPdlgazV2.creerPDLGazOutputDt Obj4 = new gdfsuezBefCalypsoPdlgazV2.creerPDLGazOutputDt();
		Obj4.populateXmlNode(mockNode);
		new gdfsuezBefCalypsoPdlgazV2.creerPDLGazResponse_element();
		gdfsuezBefCalypsoPdlgazV2.DonneesConsommationsJournalieresDt Obj6 = new gdfsuezBefCalypsoPdlgazV2.DonneesConsommationsJournalieresDt();
		Obj6.populateXmlNode(mockNode);
		gdfsuezBefCalypsoPdlgazV2.lirePDLGaz_element Obj7 = new gdfsuezBefCalypsoPdlgazV2.lirePDLGaz_element();
		Obj7.populateXmlNode(mockNode);
		gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt Obj8 = new gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt();
		Obj8.populateXmlNode(mockNode);
		gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt_PDLGaz_element Obj9 = new gdfsuezBefCalypsoPdlgazV2.lirePDLGazInputDt_PDLGaz_element();
		Obj9.populateXmlNode(mockNode);
		gdfsuezBefCalypsoPdlgazV2.lirePDLGazOutputDt Obj10 = new gdfsuezBefCalypsoPdlgazV2.lirePDLGazOutputDt();
		Obj10.populateXmlNode(mockNode);
		new gdfsuezBefCalypsoPdlgazV2.lirePDLGazResponse_element();
		gdfsuezBefCalypsoPdlgazV2.majPDLGaz_element Obj12 = new gdfsuezBefCalypsoPdlgazV2.majPDLGaz_element();
		Obj12.populateXmlNode(mockNode);
		gdfsuezBefCalypsoPdlgazV2.majPDLGazInputDt Obj13 = new gdfsuezBefCalypsoPdlgazV2.majPDLGazInputDt();
		Obj13.populateXmlNode(mockNode);
		gdfsuezBefCalypsoPdlgazV2.majPDLGazOutputDt Obj14 = new gdfsuezBefCalypsoPdlgazV2.majPDLGazOutputDt();
		Obj14.populateXmlNode(mockNode);
		new gdfsuezBefCalypsoPdlgazV2.majPDLGazResponse_element();
		gdfsuezBefCalypsoPdlgazV2.PDLGaz Obj16 = new gdfsuezBefCalypsoPdlgazV2.PDLGaz();
		Obj16.populateXmlNode(mockNode);
		gdfsuezBefCalypsoPdlgazV2.PDLGaz_CAR_element Obj17 = new gdfsuezBefCalypsoPdlgazV2.PDLGaz_CAR_element();
		Obj17.populateXmlNode(mockNode);
		gdfsuezBefCalypsoPdlgazV2.PDLGaz_dernieresReleves_element Obj18 = new gdfsuezBefCalypsoPdlgazV2.PDLGaz_dernieresReleves_element();
		Obj18.populateXmlNode(mockNode);
		gdfsuezBefCalypsoPdlgazV2.PDLGaz_derniersIndex_element Obj19 = new gdfsuezBefCalypsoPdlgazV2.PDLGaz_derniersIndex_element();
		Obj19.populateXmlNode(mockNode);
		gdfsuezBefCalypsoPdlgazV2.PDLGaz_derniersIndex_index_element Obj20 = new gdfsuezBefCalypsoPdlgazV2.PDLGaz_derniersIndex_index_element();
		Obj20.populateXmlNode(mockNode);
		gdfsuezBefCalypsoPdlgazV2.PDLGaz_donneesContractuelles_element Obj21 = new gdfsuezBefCalypsoPdlgazV2.PDLGaz_donneesContractuelles_element();
		Obj21.populateXmlNode(mockNode);
		gdfsuezBefCalypsoPdlgazV2.PDLGaz_PITD_element Obj22 = new gdfsuezBefCalypsoPdlgazV2.PDLGaz_PITD_element();
		Obj22.populateXmlNode(mockNode);
		gdfsuezBefCalypsoPdlgazV2.releve6M_1MDt Obj23 = new gdfsuezBefCalypsoPdlgazV2.releve6M_1MDt();
		Obj23.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoLocal.LocalAbstract Obj24 = new gdfsuezComBefCalypsoLocal.LocalAbstract();
		Obj24.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoLocal.LocalRoot Obj25 = new gdfsuezComBefCalypsoLocal.LocalRoot();
	//	Obj25.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPdlgaz.CARDt Obj26 = new gdfsuezComBefCalypsoPdlgaz.CARDt();
		Obj26.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPdlgaz.ParseDateTime('2014-11-05T13:15:30Z');
		gdfsuezComBefCalypsoPdlgaz.compteurDt Obj27 = new gdfsuezComBefCalypsoPdlgaz.compteurDt();
		Obj27.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPdlgaz.ConsommationJournaliereDt Obj28 = new gdfsuezComBefCalypsoPdlgaz.ConsommationJournaliereDt();
		Obj28.populateXmlNode(mockNode);
//		gdfsuezComBefCalypsoPdlgaz.DonneesConsommationsJournalieresDt Obj29 = new gdfsuezComBefCalypsoPdlgaz.DonneesConsommationsJournalieresDt();
//		Obj29.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPdlgaz.donneesCoupureDt Obj30 = new gdfsuezComBefCalypsoPdlgaz.donneesCoupureDt();
		Obj30.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPdlgaz.donneesReleveDt Obj31 = new gdfsuezComBefCalypsoPdlgaz.donneesReleveDt();
		Obj31.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPdlgaz.GazparDt Obj32 = new gdfsuezComBefCalypsoPdlgaz.GazparDt();
		Obj32.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPdlgaz.GazparDt_deploiement_element Obj33 = new gdfsuezComBefCalypsoPdlgaz.GazparDt_deploiement_element();
		Obj33.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPdlgaz.installationDt Obj34 = new gdfsuezComBefCalypsoPdlgaz.installationDt();
		Obj34.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPdlgaz.releve6M_1MDt Obj35 = new gdfsuezComBefCalypsoPdlgaz.releve6M_1MDt();
		Obj35.populateXmlNode(mockNode);
		gdfsuezComBefCalypsoPdlgaz.utilisateurFinalDt Obj36 = new gdfsuezComBefCalypsoPdlgaz.utilisateurFinalDt();
		Obj36.populateXmlNode(mockNode);
		gdfsuezComBefChpCommunadresse.adresseCommunDt Obj37 = new gdfsuezComBefChpCommunadresse.adresseCommunDt();
		Obj37.populateXmlNode(mockNode);
		gdfsuezComBefChpPivot.contextDt Obj38 = new gdfsuezComBefChpPivot.contextDt();
		Obj38.populateXmlNode(mockNode);
		gdfsuezComBefChpPivot.ParseDateTime('2014-11-05T13:15:30Z');
		gdfsuezComBefChpPivot.systemPath_element Obj39 = new gdfsuezComBefChpPivot.systemPath_element();
		Obj39.populateXmlNode(mockNode);
		gdfsuezComBefChpPivot.system_element Obj40 = new gdfsuezComBefChpPivot.system_element();
		Obj40.populateXmlNode(mockNode);
		gdfsuezComBefChpPivot.horodatageDt Obj41 = new gdfsuezComBefChpPivot.horodatageDt();
	//	Obj41.populateXmlNode(mockNode);
		gdfsuezComBefChpPivot.horodatageDt_valeur_element Obj42 = new gdfsuezComBefChpPivot.horodatageDt_valeur_element();
		Obj42.populateXmlNode(mockNode);
		gdfsuezComBefChpPivot.horodatageSimpleDt Obj43 = new gdfsuezComBefChpPivot.horodatageSimpleDt();
	//	Obj43.populateXmlNode(mockNode);
		gdfsuezComBefChpPivot.intervalleDt Obj44 = new gdfsuezComBefChpPivot.intervalleDt();
	//	Obj44.populateXmlNode(mockNode);
		gdfsuezComBefChpPivot.intervalleDt_Dates_element Obj45 = new gdfsuezComBefChpPivot.intervalleDt_Dates_element();
		Obj45.populateXmlNode(mockNode);
		gdfsuezComBefChpPivot.listeValeursDt Obj46 = new gdfsuezComBefChpPivot.listeValeursDt();
		Obj46.populateXmlNode(mockNode);
		gdfsuezComBefChpPivot.listeValeursParticulieresDt Obj47 = new gdfsuezComBefChpPivot.listeValeursParticulieresDt();
	//	Obj47.populateXmlNode(mockNode);
		gdfsuezComBefChpPivot.messageRetoursDt Obj48 = new gdfsuezComBefChpPivot.messageRetoursDt();
	//	Obj48.populateXmlNode(mockNode);
		gdfsuezComBefChpPivot.messageRetoursDt_messageRetour_element Obj49 = new gdfsuezComBefChpPivot.messageRetoursDt_messageRetour_element();
		Obj49.populateXmlNode(mockNode);
		gdfsuezComBefChpPivot.paginationDt Obj50 = new gdfsuezComBefChpPivot.paginationDt();
	//	Obj50.populateXmlNode(mockNode);
		gdfsuezComBefChpPivot.refPersonneCreerDt Obj51 = new gdfsuezComBefChpPivot.refPersonneCreerDt();
	//	Obj51.populateXmlNode(mockNode);
		gdfsuezComBefChpPivot.refPersonneLireDt Obj52 = new gdfsuezComBefChpPivot.refPersonneLireDt();
	//	Obj52.populateXmlNode(mockNode);
		gdfsuezComBefChpPivot.refPersonneMAJDt Obj53 = new gdfsuezComBefChpPivot.refPersonneMAJDt();
	//	Obj53.populateXmlNode(mockNode);
		gdfsuezComBefChpPivot.retourTraitementMessageDt Obj54 = new gdfsuezComBefChpPivot.retourTraitementMessageDt();
		Obj54.populateXmlNode(mockNode);
		gdfsuezComBefChpPivot.retourTraitementMessagesDt Obj55 = new gdfsuezComBefChpPivot.retourTraitementMessagesDt();
		Obj55.populateXmlNode(mockNode);
		gdfsuezComBefChpPivot.searchControlRequestDt Obj56 = new gdfsuezComBefChpPivot.searchControlRequestDt();
	//	Obj56.populateXmlNode(mockNode);
		gdfsuezComBefChpPivot.searchControlRequestHeaderDt Obj57 = new gdfsuezComBefChpPivot.searchControlRequestHeaderDt();
	//	Obj57.populateXmlNode(mockNode);
		gdfsuezComBefChpPivot.sortDt Obj58 = new gdfsuezComBefChpPivot.sortDt();
	//	Obj58.populateXmlNode(mockNode);
		gdfsuezComBefChpPivot.sortDt_field_element Obj59 = new gdfsuezComBefChpPivot.sortDt_field_element();
		Obj59.populateXmlNode(mockNode);
	}
	@isTest static void coverCodeForCreerPDLGaz(){
		Test.setMock(WebServiceMock.class, new gdfsuezBefCalypsoPdlgazV2MockImpl());
		gdfsuezBefCalypsoPdlgazV2.Dependency testObject = new gdfsuezBefCalypsoPdlgazV2.Dependency();
        testObject.CreerPDLGaz(null, null) ;
	//	System.assertEquals(null, testObject.CreerPDLGaz(null, null));
	}
	@isTest static void coverCodeForLirePDLGaz(){
		Test.setMock(WebServiceMock.class, new gdfsuezBefCalypsoPdlgazV2MockImpl());
		gdfsuezBefCalypsoPdlgazV2.Dependency testObject = new gdfsuezBefCalypsoPdlgazV2.Dependency();
        testObject.LirePDLGaz(null, null) ;
	//	System.assertEquals(null, testObject.LirePDLGaz(null, null));
	}
	@isTest static void coverCodeForMajPDLGaz(){
		Test.setMock(WebServiceMock.class, new gdfsuezBefCalypsoPdlgazV2MockImpl());
		gdfsuezBefCalypsoPdlgazV2.Dependency testObject = new gdfsuezBefCalypsoPdlgazV2.Dependency();
        testObject.MajPDLGaz(null, null) ;
	//	System.assertEquals(null, testObject.MajPDLGaz(null, null));
	}
	@isTest static void coverCodeForCreerPDLGaz_Http(){
		Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPdlgazV2HttpMock());
		gdfsuezBefCalypsoPdlgazV2.Dependency testObject = new gdfsuezBefCalypsoPdlgazV2.Dependency();
        testObject.CreerPDLGaz_Http(null, null) ;
	//	System.assertEquals(null, testObject.CreerPDLGaz_Http(null, null));		
	}
	@isTest static void coverCodeForLirePDLGaz_Http(){
		Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPdlgazV2HttpMock());
		gdfsuezBefCalypsoPdlgazV2.Dependency testObject = new gdfsuezBefCalypsoPdlgazV2.Dependency();
         testObject.LirePDLGaz_Http(null, null) ;
		//System.assertEquals(null, testObject.LirePDLGaz_Http(null, null));		
	}
	@isTest static void coverCodeForMajPDLGaz_Http(){
		Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPdlgazV2HttpMock());
		gdfsuezBefCalypsoPdlgazV2.Dependency testObject = new gdfsuezBefCalypsoPdlgazV2.Dependency();
        testObject.MajPDLGaz_Http(null, null) ;
		//System.assertEquals(null, testObject.MajPDLGaz_Http(null, null));		
	}
}