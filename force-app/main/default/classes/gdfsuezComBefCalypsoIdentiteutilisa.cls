//Generated by FuseIT WSDL2Apex (http://www.fuseit.com/Solutions/SFDC-Explorer/Help-WSDL-Parser.aspx)
	
public class gdfsuezComBefCalypsoIdentiteutilisa {
	private static final String s_ns0 = 'http://gdfsuez.com/bef/calypso/identiteUtilisateur';
	public class IdentiteUtilisateurAbstract {
		public String idUtilisateur;
		private transient String[] idUtilisateur_type_info = new String[]{'idUtilisateur',s_ns0,'','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'idUtilisateur'};
            
            public IdentiteUtilisateurAbstract(){
		}
		public IdentiteUtilisateurAbstract(DOM.XmlNode responseNode){
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode idUtilisateurNode = responseNode.getChildElement('idUtilisateur', s_ns0);
			this.idUtilisateur = (idUtilisateurNode == null) ? null : idUtilisateurNode.getText();
			nodesParsed.add(idUtilisateurNode);
		}
		public void populateXmlNode(Dom.XmlNode outerNode){
			if(this.idUtilisateur != null){
				Dom.XmlNode idUtilisateurNode = outerNode.addChildElement('idUtilisateur', '', '');
				idUtilisateurNode.addTextNode((this.idUtilisateur == null) ? '' : this.idUtilisateur);
			}
		}
	}
	
	//Extends http://gdfsuez.com/bef/calypso/identiteUtilisateur:IdentiteUtilisateurAbstract
	/* public class IdentiteUtilisateurRoot {
		public String idUtilisateur;
		private transient String[] idUtilisateur_type_info = new String[]{'idUtilisateur',s_ns0,'','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'idUtilisateur'};
	}
    
    public class entiteRattachementDt {
		public String[] entiteRattachement;
		private transient String[] entiteRattachement_type_info = new String[]{'entiteRattachement',s_ns0,'string','0','-1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'entiteRattachement'};
	} */
	

	public class identiteUtilisateur {
        public String idUtilisateur;
		public gdfsuezComBefChpPivot_Utili.listeValeursDt civilite;
		// Restriction enumeration: 
		public String nom;
		// Restriction enumeration: 
		public String prenom;
		// Restriction enumeration: 
		public String mail;
		public gdfsuezComBefCalypsoIdentiteutilisa.uniteOrganisationnelleDt uniteOrganisationnelle;
		// public gdfsuezComBefCalypsoIdentiteutilisa.entiteRattachementDt listeEntiteRattachement;
		private transient String[] civilite_type_info = new String[]{'civilite',s_ns0,'listeValeursDt','0','1','false'};
		private transient String[] nom_type_info = new String[]{'nom',s_ns0,'string50','0','1','false'};
		private transient String[] prenom_type_info = new String[]{'prenom',s_ns0,'string50','0','1','false'};
		private transient String[] mail_type_info = new String[]{'mail',s_ns0,'string255','0','1','false'};
		private transient String[] uniteOrganisationnelle_type_info = new String[]{'uniteOrganisationnelle',s_ns0,'uniteOrganisationnelleDt','0','1','false'};
		private transient String[] listeEntiteRattachement_type_info = new String[]{'listeEntiteRattachement',s_ns0,'entiteRattachementDt','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'civilite','nom','prenom','mail','uniteOrganisationnelle','listeEntiteRattachement'};
               public identiteUtilisateur(){
		}
		public identiteUtilisateur(DOM.XmlNode responseNode){
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
			DOM.XmlNode idUtilisateurNode = responseNode.getChildElement('idUtilisateur', null);
			this.idUtilisateur = (idUtilisateurNode == null) ? null : idUtilisateurNode.getText();
			nodesParsed.add(idUtilisateurNode);
            
            DOM.XmlNode nomNode = responseNode.getChildElement('nom', '');
			this.nom = (nomNode == null) ? null : nomNode.getText();
			nodesParsed.add(nomNode);
            
            DOM.XmlNode prenomNode = responseNode.getChildElement('prenom', '');
			this.prenom = (prenomNode == null) ? null : prenomNode.getText();
			nodesParsed.add(prenomNode);
            
            DOM.XmlNode mailNode = responseNode.getChildElement('mail', '');
            this.mail = (mailNode == null) ? null : mailNode.getText();
            nodesParsed.add(mailNode);
            
            DOM.XmlNode uniteOrganisationelleNode = responseNode.getChildElement('uniteOrganisationnelle', null);          
            if(uniteOrganisationelleNode == null){
                this.uniteOrganisationnelle = null;
            } else{
                gdfsuezComBefCalypsoIdentiteutilisa.uniteOrganisationnelleDt lireIdentiteUtilisateurOutputObj = new gdfsuezComBefCalypsoIdentiteutilisa.uniteOrganisationnelleDt(uniteOrganisationelleNode);
                nodesParsed.add(uniteOrganisationelleNode);
                this.uniteOrganisationnelle = lireIdentiteUtilisateurOutputObj;
            }
            
            
        }
	/*	 public void populateXmlNode(Dom.XmlNode outerNode){
			if(this.idUtilisateur != null){
				Dom.XmlNode idUtilisateurNode = outerNode.addChildElement('idUtilisateur', '', '');
				idUtilisateurNode.addTextNode((this.idUtilisateur == null) ? '' : this.idUtilisateur);
			}
            
            if(this.nom != null){
				Dom.XmlNode nomNode = outerNode.addChildElement('nom', '', '');
				nomNode.addTextNode((this.nom == null) ? '' : this.nom);
			}
            
            if(this.prenom != null){
				Dom.XmlNode prenomNode = outerNode.addChildElement('prenom', '', '');
				prenomNode.addTextNode((this.prenom == null) ? '' : this.prenom);
			}
            
            gdfsuezComBefCalypsoIdentiteutilisa.uniteOrganisationnelleDt uniteOrganisationnelleObject = this.uniteOrganisationnelle;
            Dom.XmlNode messageRetoursNode = outerNode.addChildElement('uniteOrganisationnelle', '', '');
            if(uniteOrganisationnelleObject != null){
                uniteOrganisationnelleObject.populateXmlNode(messageRetoursNode);
            }
            
            if(this.mail != null){
				Dom.XmlNode mailNode = outerNode.addChildElement('mail', '', '');
				mailNode.addTextNode((this.mail == null) ? '' : this.mail);
			}
		}    */        
            
	}
	public class uniteOrganisationnelleDt {
		public String idUniteOrganisationnelle;
		public String numeroBPUniteOrganisationnelle;
		public String numeroBPUtilisateur;
		public String idPersonne;
		public String idPosition;
		private transient String[] idUniteOrganisationnelle_type_info = new String[]{'idUniteOrganisationnelle',s_ns0,'string','0','1','false'};
		private transient String[] numeroBPUniteOrganisationnelle_type_info = new String[]{'numeroBPUniteOrganisationnelle',s_ns0,'string','0','1','false'};
		private transient String[] numeroBPUtilisateur_type_info = new String[]{'numeroBPUtilisateur',s_ns0,'string','0','1','false'};
		private transient String[] idPersonne_type_info = new String[]{'idPersonne',s_ns0,'string','0','1','false'};
		private transient String[] idPosition_type_info = new String[]{'idPosition',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'idUniteOrganisationnelle','numeroBPUniteOrganisationnelle','numeroBPUtilisateur','idPersonne','idPosition'};
              public uniteOrganisationnelleDt(){
		}
		public uniteOrganisationnelleDt(DOM.XmlNode responseNode){
			Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
            
			DOM.XmlNode idUniteOrganisationnelleNode = responseNode.getChildElement('idUniteOrganisationnelle', null);
			this.idUniteOrganisationnelle = (idUniteOrganisationnelleNode == null) ? null : idUniteOrganisationnelleNode.getText();
			nodesParsed.add(idUniteOrganisationnelleNode);
            
            DOM.XmlNode numeroBPUniteOrganisationnelleNode = responseNode.getChildElement('numeroBPUniteOrganisationnelle', null);
			this.numeroBPUniteOrganisationnelle = (numeroBPUniteOrganisationnelleNode == null) ? null : numeroBPUniteOrganisationnelleNode.getText();
			nodesParsed.add(numeroBPUniteOrganisationnelleNode);
            
            
            DOM.XmlNode numeroBPUtilisateurNode = responseNode.getChildElement('numeroBPUtilisateur', null);
			this.numeroBPUtilisateur = (numeroBPUtilisateurNode == null) ? null : numeroBPUtilisateurNode.getText();
			nodesParsed.add(numeroBPUtilisateurNode);
            
            
            DOM.XmlNode idPersonneNode = responseNode.getChildElement('idPersonne', null);
			this.idPersonne = (idPersonneNode == null) ? null : idPersonneNode.getText();
			nodesParsed.add(idPersonneNode);
            

            DOM.XmlNode idPositionNode = responseNode.getChildElement('idPosition', null);
			this.idPosition = (idPositionNode == null) ? null : idPositionNode.getText();
			nodesParsed.add(idPositionNode);
        }
       /*  public void populateXmlNode(Dom.XmlNode outerNode){
			if(this.idUniteOrganisationnelle != null){
				Dom.XmlNode idUniteOrganisationnelleNode = outerNode.addChildElement('idUniteOrganisationnelle', '', '');
				idUniteOrganisationnelleNode.addTextNode((this.idUniteOrganisationnelle == null) ? '' : this.idUniteOrganisationnelle);
			}
            
            if(this.numeroBPUniteOrganisationnelle != null){
				Dom.XmlNode numeroBPUniteOrganisationnelleNode = outerNode.addChildElement('numeroBPUniteOrganisationnelle', '', '');
				numeroBPUniteOrganisationnelleNode.addTextNode((this.numeroBPUniteOrganisationnelle == null) ? '' : this.numeroBPUniteOrganisationnelle);
			}
            
            if(this.numeroBPUtilisateur != null){
				Dom.XmlNode numeroBPUtilisateurNode = outerNode.addChildElement('numeroBPUtilisateur', '', '');
				numeroBPUtilisateurNode.addTextNode((this.numeroBPUtilisateur == null) ? '' : this.numeroBPUtilisateur);
			}
            
            if(this.idPersonne != null){
				Dom.XmlNode idPersonneNode = outerNode.addChildElement('idPersonne', '', '');
				idPersonneNode.addTextNode((this.idPersonne == null) ? '' : this.idPersonne);
			}
            
            if(this.idPosition != null){
				Dom.XmlNode idPositionNode = outerNode.addChildElement('idPosition', '', '');
				idPositionNode.addTextNode((this.idPosition == null) ? '' : this.idPosition);
			}
        } */
	}
}