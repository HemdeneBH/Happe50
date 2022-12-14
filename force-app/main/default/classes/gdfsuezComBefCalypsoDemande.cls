//Generated by FuseIT WSDL2Apex (http://www.fuseit.com/Solutions/SFDC-Explorer/Help-WSDL-Parser.aspx)
	
public class gdfsuezComBefCalypsoDemande {
	public class DemandeAbstract {
		public String idDemande;
		private String[] idDemande_type_info = new String[]{'idDemande','http://gdfsuez.com/bef/calypso/demande','','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/demande','true','false'};
		private String[] field_order_type_info = new String[]{'idDemande'};
		public DemandeAbstract(){
		}
		public DemandeAbstract(DOM.XmlNode responseNode){
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode idDemandeNode = responseNode.getChildElement('idDemande', 'http://gdfsuez.com/bef/calypso/demande');
			this.idDemande = (idDemandeNode == null) ? null : idDemandeNode.getText();
			nodesParsed.add(idDemandeNode);
			//System.debug(this.idDemande);			
		}
		public void populateXmlNode(Dom.XmlNode outerNode){
			Dom.XmlNode idDemandeNode = outerNode.addChildElement('idDemande', 'http://gdfsuez.com/bef/calypso/demande', '');
			idDemandeNode.addTextNode((this.idDemande == null) ? '' : this.idDemande);
		}
	}
	public class DemandeRoot {
		public String idDemande;
		private String[] idDemande_type_info = new String[]{'idDemande','http://gdfsuez.com/bef/calypso/demande','','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/calypso/demande','true','false'};
		private String[] field_order_type_info = new String[]{'idDemande'};
		public DemandeRoot(){
		}
		public DemandeRoot(DOM.XmlNode responseNode){
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode idDemandeNode = responseNode.getChildElement('idDemande', 'http://gdfsuez.com/bef/calypso/demande');
			this.idDemande = (idDemandeNode == null) ? null : idDemandeNode.getText();
			nodesParsed.add(idDemandeNode);
			//System.debug(this.idDemande);			
		}
		public void populateXmlNode(Dom.XmlNode outerNode){
			Dom.XmlNode idDemandeNode = outerNode.addChildElement('idDemande', 'http://gdfsuez.com/bef/calypso/demande', '');
			idDemandeNode.addTextNode((this.idDemande == null) ? '' : this.idDemande);
		}
	}
}