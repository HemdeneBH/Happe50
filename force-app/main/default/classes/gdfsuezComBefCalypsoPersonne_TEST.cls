@isTest
private class gdfsuezComBefCalypsoPersonne_TEST {

	@isTest static void globalTest() {
		// Implement test code
		/*gdfsuezComBefCalypsoPersonne personne = new gdfsuezComBefCalypsoPersonne();*/
		DOM.Document doc = new DOM.Document();
		DOM.XmlNode mockNode = doc.createRootElement('Envelope', 'http://schemas.xmlsoap.org/soap/envelope/', 'env');
		gdfsuezComBefCalypsoPersonne.PersonneAbstract personneAbstract = new gdfsuezComBefCalypsoPersonne.PersonneAbstract();
		personneAbstract.idPersonne = '1';
		mockNode.addChildElement('idPersonne', 'http://gdfsuez.com/bef/calypso/personne', '');
		gdfsuezComBefCalypsoPersonne.PersonneAbstract personneAbstract1 = new gdfsuezComBefCalypsoPersonne.PersonneAbstract(mockNode);
		personneAbstract1.idPersonne ='2';
		personneAbstract1.populateXmlNode(mockNode);

		gdfsuezComBefCalypsoPersonne.PersonneRoot personneRoot = new gdfsuezComBefCalypsoPersonne.PersonneRoot();
		personneRoot.idPersonne ='0';
		mockNode.addChildElement('idPersonne', 'http://gdfsuez.com/bef/calypso/personne', '');
		gdfsuezComBefCalypsoPersonne.PersonneRoot personneRoot1 = new gdfsuezComBefCalypsoPersonne.PersonneRoot(mockNode);
		personneRoot1.idPersonne = '3';
		personneAbstract1.populateXmlNode(mockNode);
	}

}