/*Author fuzeIT:
*Descritption: Struture de la trame de la prooposition commerciale (classe de test)
*CreatedDate:24/09/2018
*LastModified: MHA  12/12/2018
*/
@isTest
private class gdfsuezComBefCalypsoPropositioncomm_TEST {

	@isTest static void test_method_one() {
		// Implement test code
		DOM.Document doc = new DOM.Document();
		DOM.XmlNode mockNode = doc.createRootElement('Envelope', 'http://schemas.xmlsoap.org/soap/envelope/', 'env');

		mockNode.addChildElement('motifDate', 'http://gdfsuez.com/bef/calypso/propositioncommerciale', 'test');
		mockNode.addChildElement('motifRefus', 'http://gdfsuez.com/bef/calypso/propositioncommerciale', 'test');
		mockNode.addChildElement('motifSouscription', 'http://gdfsuez.com/bef/calypso/propositioncommerciale', 'test');
		mockNode.addChildElement('nombreExemplaireCPV', 'http://gdfsuez.com/bef/calypso/propositioncommerciale', 'test');
		mockNode.addChildElement('rythmeFacturationSouhaite', 'http://gdfsuez.com/bef/calypso/propositioncommerciale', 'test');
		mockNode.addChildElement('compteClient', 'http://gdfsuez.com/bef/calypso/propositioncommerciale', 'test');
		mockNode.addChildElement('typeEnseigne', 'http://gdfsuez.com/bef/calypso/propositioncommerciale', 'test');
		mockNode.addChildElement('canalEnvoiCPV', 'http://gdfsuez.com/bef/calypso/propositioncommerciale', 'test');
		mockNode.addChildElement('pack', 'http://gdfsuez.com/bef/calypso/propositioncommerciale', 'test');
		mockNode.addChildElement('local', 'http://gdfsuez.com/bef/calypso/propositioncommerciale', 'test');
		mockNode.addChildElement('idContactCPVEnvoi', 'http://gdfsuez.com/bef/calypso/propositioncommerciale', 'test');
		mockNode.addChildElement('statutPropositionCommerciale', 'http://gdfsuez.com/bef/calypso/propositioncommerciale', 'test');
		gdfsuezComBefCalypsoPropositioncomm gdfsuezComBefCalypsoPropositioncommV = new gdfsuezComBefCalypsoPropositioncomm();
		/*gdfsuezComBefCalypsoPropositioncomm gdfsuezComBefCalypsoPropositioncommV1 = new gdfsuezComBefCalypsoPropositioncomm(mockNode);*/


		gdfsuezComBefCalypsoPropositioncomm.datesDt datesDtV = new gdfsuezComBefCalypsoPropositioncomm.datesDt();
		gdfsuezComBefCalypsoPropositioncomm.datesDt datesDtV1 = new gdfsuezComBefCalypsoPropositioncomm.datesDt(mockNode);
		datesDtV1.populateXmlNode(mockNode);

		gdfsuezComBefCalypsoPropositioncomm.ObjetsLiesDt objetsLiesDt = new gdfsuezComBefCalypsoPropositioncomm.ObjetsLiesDt();
		gdfsuezComBefCalypsoPropositioncomm.ObjetsLiesDt objetsLiesDt1 = new gdfsuezComBefCalypsoPropositioncomm.ObjetsLiesDt(mockNode);
		objetsLiesDt1.populateXmlNode(mockNode);

		gdfsuezComBefCalypsoPropositioncomm.offreDt offreDtV = new gdfsuezComBefCalypsoPropositioncomm.offreDt();
		gdfsuezComBefCalypsoPropositioncomm.offreDt offreDtV1 = new gdfsuezComBefCalypsoPropositioncomm.offreDt(mockNode);
		offreDtV1.populateXmlNode(mockNode);

		gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale propositionCommerciale = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale();
		gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale propositionCommerciale1 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale(mockNode);
		propositionCommerciale1.populateXmlNode(mockNode);

		gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element propositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element();
		gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element propositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element1 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element(mockNode);
		propositionCommerciale_composantePropositionCommerciale_caracteristiquePME_element1.populateXmlNode(mockNode);

		gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_consommationAnnuelleEstimeeCadrans_element propositionCommerciale_composantePropositionCommerciale_consommationAnnuelleEstimeeCadrans_element = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_consommationAnnuelleEstimeeCadrans_element();
		gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_consommationAnnuelleEstimeeCadrans_element propositionCommerciale_composantePropositionCommerciale_consommationAnnuelleEstimeeCadrans_element1 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_consommationAnnuelleEstimeeCadrans_element(mockNode);
		propositionCommerciale_composantePropositionCommerciale_consommationAnnuelleEstimeeCadrans_element1.populateXmlNode(mockNode);

		gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element propositionCommerciale_composantePropositionCommerciale_element = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element();
		gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element propositionCommerciale_composantePropositionCommerciale_element1 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_element(mockNode);
		propositionCommerciale_composantePropositionCommerciale_element1.populateXmlNode(mockNode);

		gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_remiseRecurrente_element propositionCommerciale_composantePropositionCommerciale_remiseRecurrente_element = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_remiseRecurrente_element();
		gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_remiseRecurrente_element propositionCommerciale_composantePropositionCommerciale_remiseRecurrente_element1 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_composantePropositionCommerciale_remiseRecurrente_element(mockNode);
		propositionCommerciale_composantePropositionCommerciale_remiseRecurrente_element1.populateXmlNode(mockNode);

		gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_refPersonne_element propositionCommerciale_refPersonne_element = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_refPersonne_element();
		gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_refPersonne_element propositionCommerciale_refPersonne_element1 = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommerciale_refPersonne_element(mockNode);
		propositionCommerciale_refPersonne_element1.populateXmlNode(mockNode);

		gdfsuezComBefCalypsoPropositioncomm.RemiseOneShotDt remiseOneShotDt = new gdfsuezComBefCalypsoPropositioncomm.RemiseOneShotDt();
		gdfsuezComBefCalypsoPropositioncomm.RemiseOneShotDt remiseOneShotDt1 = new gdfsuezComBefCalypsoPropositioncomm.RemiseOneShotDt(mockNode);
		remiseOneShotDt1.populateXmlNode(mockNode);

		gdfsuezComBefCalypsoPropositioncomm.PropositionCommercialeAbstract propositionCommercialeAbstract = new gdfsuezComBefCalypsoPropositioncomm.PropositionCommercialeAbstract();

		gdfsuezComBefCalypsoPropositioncomm.CompteClientAbstract compteClientAbstract = new gdfsuezComBefCalypsoPropositioncomm.CompteClientAbstract();
		gdfsuezComBefCalypsoPropositioncomm.CompteClientAbstract compteClientAbstract1 = new gdfsuezComBefCalypsoPropositioncomm.CompteClientAbstract(mockNode);
		compteClientAbstract1.populateXmlNode(mockNode);

	}

}