@isTest 
private class gdfsuezComBefChpCalypsoGestionsoTest {

@isTest static void test_method_one() {
		// Implement test code
		Test.setMock(WebServiceMock.class, new gdfsuezComBefChpCalypsoGestionsoMockImpl());
		gdfsuezComBefChpCalypsoGestionso parentObject = new gdfsuezComBefChpCalypsoGestionso();
		DOM.Document doc = new DOM.Document();
		DOM.XmlNode mockNode = doc.createRootElement('Envelope', 'http://schemas.xmlsoap.org/soap/envelope/', 'env');
		mockNode.addChildElement('messageRetours', 'http://www.gdfsuez.com/bef/chp/calypso/GestionSouscriptionService/v1', 'test');

		new gdfsuezComBefChpCalypsoGestionso.demanderSouscriptionServiceInputDt(mockNode);
		new gdfsuezComBefChpCalypsoGestionso.demanderSouscriptionServiceResponse_element(mockNode);
    	new gdfsuezComBefChpCalypsoGestionso.serviceDt(mockNode);
		
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
		new gdfsuezComBefChpPivot.contextDt(mockNode);
		new gdfsuezComBefChpPivot.systemPath_element(mockNode);
		new gdfsuezComBefChpPivot.system_element(mockNode);
		
		new gdfsuezComBefChpPivot.horodatageDt_valeur_element(mockNode);
		
		new gdfsuezComBefChpPivot.intervalleDt_Dates_element(mockNode);
		new gdfsuezComBefChpPivot.listeValeursDt(mockNode);
		
		new gdfsuezComBefChpPivot.messageRetoursDt(mockNode);
		new gdfsuezComBefChpPivot.messageRetoursDt_messageRetour_element(mockNode);
		
		new gdfsuezComBefChpPivot.retourTraitementMessageDt(mockNode);
		new gdfsuezComBefChpPivot.retourTraitementMessagesDt(mockNode);
		
		new gdfsuezComBefChpPivot.sortDt_field_element(mockNode);
    gdfsuezComBefChpPivot.contextDt Obj43 = new gdfsuezComBefChpPivot.contextDt();
		Obj43.populateXmlNode(mockNode);
		gdfsuezComBefChpCalypsoGestionso.demanderSouscriptionService_element Obj1 = new gdfsuezComBefChpCalypsoGestionso.demanderSouscriptionService_element();
		Obj1.populateXmlNode(mockNode);
		gdfsuezComBefChpCalypsoGestionso.demanderSouscriptionServiceInputDt Obj2 = new gdfsuezComBefChpCalypsoGestionso.demanderSouscriptionServiceInputDt();
	obj2.enseigne = 	new gdfsuezComBefChpPivot.listeValeursDt();
    obj2.enseigne.code = 'CRC';
    obj2.adresseEmailCorrespondance = 'Test@test.com';
    obj2.idCompteClient = '59292929';
    obj2.idPersonne = '535363';
    Obj2.populateXmlNode(mockNode);
    gdfsuezComBefChpCalypsoGestionso.demanderSouscriptionService_element Obj11 = new gdfsuezComBefChpCalypsoGestionso.demanderSouscriptionService_element(Obj2,Obj43);
		Obj11.populateXmlNode(mockNode);
    
    gdfsuezComBefChpCalypsoGestionso.serviceDt obj3 = new gdfsuezComBefChpCalypsoGestionso.serviceDt();
    obj3.serviceGestion = new gdfsuezComBefChpPivot.listeValeursDt();
    obj3.serviceGestion.libelleCourt = 'ma facture';
    obj3.typeGestion = new gdfsuezComBefChpPivot.listeValeursDt();
    obj3.typeGestion.libelleCourt = 'ma facture en ligne';
    obj3.statutService = new gdfsuezComBefChpPivot.listeValeursDt();
    obj3.statutService.libelleCourt = 'Demandé';
    obj3.populateXmlNode(mockNode);
		
		new gdfsuezComBefChpCalypsoGestionso.demanderSouscriptionServiceResponse_element();
    
    
		
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
    	
    	gdfsuezComBefChpPivot.systemPath_element Obj44 = new gdfsuezComBefChpPivot.systemPath_element();
		Obj44.populateXmlNode(mockNode);
		gdfsuezComBefChpPivot.system_element Obj45 = new gdfsuezComBefChpPivot.system_element();
		Obj45.populateXmlNode(mockNode);
    	gdfsuezComBefChpPivot.messageRetoursDt Obj53 = new gdfsuezComBefChpPivot.messageRetoursDt();
		Obj53.populateXmlNode(mockNode);
		gdfsuezComBefChpPivot.messageRetoursDt_messageRetour_element Obj54 = new gdfsuezComBefChpPivot.messageRetoursDt_messageRetour_element();
		Obj54.populateXmlNode(mockNode);
	}
    
    
    
    @isTest static void coverCodeForDemanderGestionSouscription(){
		Test.setMock(WebServiceMock.class, new gdfsuezComBefChpCalypsoGestionsoMockImpl());
		gdfsuezComBefChpCalypsoGestionso.DemandeSouscriptionServicePort testObject = new gdfsuezComBefChpCalypsoGestionso.DemandeSouscriptionServicePort();
		gdfsuezComBefChpPivot.contextDt Obj43 = new gdfsuezComBefChpPivot.contextDt();
		gdfsuezComBefChpCalypsoGestionso.demanderSouscriptionServiceInputDt Obj2 = new gdfsuezComBefChpCalypsoGestionso.demanderSouscriptionServiceInputDt();
		gdfsuezComBefChpPivot.messageRetoursDt test1 = testObject.DemanderSouscriptionService(Obj2, Obj43);
		/*System.assertEquals(null, testObject.CreerPropositionCommerciale(Obj2, Obj43));*/
	}
      
}