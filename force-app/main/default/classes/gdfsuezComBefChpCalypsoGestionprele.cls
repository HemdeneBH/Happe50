//Generated by wsdl2apex

public class gdfsuezComBefChpCalypsoGestionprele {
    public class demanderPrelevementResponse_element {
        public gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementOutputDt demanderPrelevementOutput;
        public gdfsuezComBefChpPivot_Prelevement1.messageRetoursDt messageRetours;
        private String[] demanderPrelevementOutput_type_info = new String[]{'demanderPrelevementOutput','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'0','1','false'};
        private String[] messageRetours_type_info = new String[]{'messageRetours','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1','false','false'};
        private String[] field_order_type_info = new String[]{'demanderPrelevementOutput','messageRetours'};
    }
    public class listeCompteClientDt {
        public gdfsuezComBefChpCalypsoGestionprele.compteClientDt[] compteClient;
        private String[] compteClient_type_info = new String[]{'compteClient','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1','false','false'};
        private String[] field_order_type_info = new String[]{'compteClient'};
    }
    public class demanderPrelevementOutputDt {
        public gdfsuezComBefChpCalypsoGestionprele.mandatDPDt mandat;
        public gdfsuezComBefChpCalypsoGestionprele.compteClientDt compteClient;
        private String[] mandat_type_info = new String[]{'mandat','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'0','1','false'};
        private String[] compteClient_type_info = new String[]{'compteClient','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1','false','false'};
        private String[] field_order_type_info = new String[]{'mandat','compteClient'};
    }
    public class modifierCoordonneeBancaire_element {
        public gdfsuezComBefChpCalypsoGestionprele.modifierCoordonneeBancaireInputDt modifierCoordonneeBancaireInput;
        public gdfsuezComBefChpPivot_Prelevement1.contextDt context;
        private String[] modifierCoordonneeBancaireInput_type_info = new String[]{'modifierCoordonneeBancaireInput','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'1','1','false'};
        private String[] context_type_info = new String[]{'context','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1','false','false'};
        private String[] field_order_type_info = new String[]{'modifierCoordonneeBancaireInput','context'};
    }
    public class demanderPrelevement_element {
        public gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementInputDt demanderPrelevementInput;
        public gdfsuezComBefChpPivot_Prelevement1.contextDt context;
        private String[] demanderPrelevementInput_type_info = new String[]{'demanderPrelevementInput','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'1','1','false'};
        private String[] context_type_info = new String[]{'context','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1','false','false'};
        private String[] field_order_type_info = new String[]{'demanderPrelevementInput','context'};
    }
    public class listePersonneDt {
        public String idPersonne;
        public gdfsuezComBefChpPivot_Prelevement1.listeValeursDt role;
        private String[] idPersonne_type_info = new String[]{'idPersonne','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'0','1','false'};
        private String[] role_type_info = new String[]{'role','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1','false','false'};
        private String[] field_order_type_info = new String[]{'idPersonne','role'};
    }
    public class mandatDt {
        public String idMandat;
        public gdfsuezComBefChpPivot_Prelevement1.listeValeursDt statutMandat;
        private String[] idMandat_type_info = new String[]{'idMandat','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'1','1','false'};
        private String[] statutMandat_type_info = new String[]{'statutMandat','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1','false','false'};
        private String[] field_order_type_info = new String[]{'idMandat','statutMandat'};
    }
    public class modifierCoordonneeBancaireInputDt {
        public String idPersonne;
        public String idMandat;
        public String idCompteClient;
        public gdfsuezComBefChpCalypsoGestionprele.coordonneeBancaireDt coordonneeBancaire;
        public Boolean changementPayeur;
        private String[] idPersonne_type_info = new String[]{'idPersonne','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'0','1','false'};
        private String[] idMandat_type_info = new String[]{'idMandat','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'0','1','false'};
        private String[] idCompteClient_type_info = new String[]{'idCompteClient','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'0','1','false'};
        private String[] coordonneeBancaire_type_info = new String[]{'coordonneeBancaire','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'1','1','false'};
        private String[] changementPayeur_type_info = new String[]{'changementPayeur','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1','false','false'};
        private String[] field_order_type_info = new String[]{'idPersonne','idMandat','idCompteClient','coordonneeBancaire','changementPayeur'};
    }
    public class modifierCoordonneeBancaireResponse_element {
        public gdfsuezComBefChpCalypsoGestionprele.modifierCoordonneeBancaireOutputDt modifierCoordonneeBancaireOutput;
        public gdfsuezComBefChpPivot_Prelevement1.messageRetoursDt messageRetours;
        private String[] modifierCoordonneeBancaireOutput_type_info = new String[]{'modifierCoordonneeBancaireOutput','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'0','1','false'};
        private String[] messageRetours_type_info = new String[]{'messageRetours','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1','false','false'};
        private String[] field_order_type_info = new String[]{'modifierCoordonneeBancaireOutput','messageRetours'};
    }
    public class mandatDPDt {
        public String idMandat;
        public gdfsuezComBefChpPivot_Prelevement1.listeValeursDt statutMandat;
        public String idPersonne;
        public String idCoordonneeBancaire;
        private String[] idMandat_type_info = new String[]{'idMandat','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'0','1','false'};
        private String[] statutMandat_type_info = new String[]{'statutMandat','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'0','1','false'};
        private String[] idPersonne_type_info = new String[]{'idPersonne','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'0','1','false'};
        private String[] idCoordonneeBancaire_type_info = new String[]{'idCoordonneeBancaire','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1','false','false'};
        private String[] field_order_type_info = new String[]{'idMandat','statutMandat','idPersonne','idCoordonneeBancaire'};
    }
    public class listeServicesGestionDt {
        public gdfsuezComBefChpPivot_Prelevement1.listeValeursDt[] serviceGestion;
        private String[] serviceGestion_type_info = new String[]{'serviceGestion','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1','false','false'};
        private String[] field_order_type_info = new String[]{'serviceGestion'};
    }
    public class compteClientDt {
        public String idCompteClient;
        public gdfsuezComBefChpCalypsoGestionprele.listePersonneDt listePersonne;
        public gdfsuezComBefChpCalypsoGestionprele.listeServicesGestionDt listeServicesGestion;
        private String[] idCompteClient_type_info = new String[]{'idCompteClient','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'1','1','false'};
        private String[] listePersonne_type_info = new String[]{'listePersonne','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'0','1','false'};
        private String[] listeServicesGestion_type_info = new String[]{'listeServicesGestion','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1','false','false'};
        private String[] field_order_type_info = new String[]{'idCompteClient','listePersonne','listeServicesGestion'};
    }
    public class coordonneeBancaireDt {
        public String idCoordonneeBancaire;
        public String iban;
        public String bban;
        public String titulaireCompte;
        private String[] idCoordonneeBancaire_type_info = new String[]{'idCoordonneeBancaire','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'0','1','false'};
        private String[] iban_type_info = new String[]{'iban','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'0','1','false'};
        private String[] bban_type_info = new String[]{'bban','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'0','1','false'};
        private String[] titulaireCompte_type_info = new String[]{'titulaireCompte','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1','false','false'};
        private String[] field_order_type_info = new String[]{'idCoordonneeBancaire','iban','bban','titulaireCompte'};
    }
    public class demanderPrelevementInputDt {
        public String idPersonne;
        public gdfsuezComBefChpCalypsoGestionprele.coordonneeBancaireDt coordonneesBancaires;
        public String idCompteClient;
        public Boolean changementPayeur;
        private String[] idPersonne_type_info = new String[]{'idPersonne','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'1','1','false'};
        private String[] coordonneesBancaires_type_info = new String[]{'coordonneesBancaires','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'1','1','false'};
        private String[] idCompteClient_type_info = new String[]{'idCompteClient','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'1','1','false'};
        private String[] changementPayeur_type_info = new String[]{'changementPayeur','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1','false','false'};
        private String[] field_order_type_info = new String[]{'idPersonne','coordonneesBancaires','idCompteClient','changementPayeur'};
    }
    public class modifierCoordonneeBancaireOutputDt {
        public String idPersonne;
        public String idCoordonneeBancaire;
        public gdfsuezComBefChpCalypsoGestionprele.mandatDt mandat;
        public gdfsuezComBefChpCalypsoGestionprele.listeCompteClientDt listeCompteClient;
        private String[] idPersonne_type_info = new String[]{'idPersonne','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'0','1','false'};
        private String[] idCoordonneeBancaire_type_info = new String[]{'idCoordonneeBancaire','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'0','1','false'};
        private String[] mandat_type_info = new String[]{'mandat','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'0','1','false'};
        private String[] listeCompteClient_type_info = new String[]{'listeCompteClient','http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1','false','false'};
        private String[] field_order_type_info = new String[]{'idPersonne','idCoordonneeBancaire','mandat','listeCompteClient'};
    }
    public class GestionPrelevementPort {
        public String endpoint_x = 'http://localhost:8080/services/gestionprelevement';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://gdfsuez.com/bef/chp/pivot', 'gdfsuezComBefChpPivot_Prelevement1', 'http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1', 'gdfsuezComBefChpCalypsoGestionprele'};
        public gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementResponse_element DemanderPrelevement(gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementInputDt demanderPrelevementInput,gdfsuezComBefChpPivot_Prelevement1.contextDt context) {
            gdfsuezComBefChpCalypsoGestionprele.demanderPrelevement_element request_x = new gdfsuezComBefChpCalypsoGestionprele.demanderPrelevement_element();
            request_x.demanderPrelevementInput = demanderPrelevementInput;
            request_x.context = context;
            gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementResponse_element response_x;
            Map<String, gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementResponse_element> response_map_x = new Map<String, gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'tns:DemanderPrelevement',
              'http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',
              'demanderPrelevement',
              'http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',
              'demanderPrelevementResponse',
              'gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public gdfsuezComBefChpCalypsoGestionprele.modifierCoordonneeBancaireResponse_element ModifierCoordonneeBancaire(gdfsuezComBefChpCalypsoGestionprele.modifierCoordonneeBancaireInputDt modifierCoordonneeBancaireInput,gdfsuezComBefChpPivot_Prelevement1.contextDt context) {
            gdfsuezComBefChpCalypsoGestionprele.modifierCoordonneeBancaire_element request_x = new gdfsuezComBefChpCalypsoGestionprele.modifierCoordonneeBancaire_element();
            request_x.modifierCoordonneeBancaireInput = modifierCoordonneeBancaireInput;
            request_x.context = context;
            gdfsuezComBefChpCalypsoGestionprele.modifierCoordonneeBancaireResponse_element response_x;
            Map<String, gdfsuezComBefChpCalypsoGestionprele.modifierCoordonneeBancaireResponse_element> response_map_x = new Map<String, gdfsuezComBefChpCalypsoGestionprele.modifierCoordonneeBancaireResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'tns:ModifierCoordonneeBancaire',
              'http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',
              'modifierCoordonneeBancaire',
              'http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',
              'modifierCoordonneeBancaireResponse',
              'gdfsuezComBefChpCalypsoGestionprele.modifierCoordonneeBancaireResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
    }
}