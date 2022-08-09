public class WrapperContatPC {
    public List<ListeIDPDLPC> ListeIDPDLPC;
    public List<ListeIDPDLDonneesContrat5S> ListeIDPDLDonneesContrat5S;
 
    
    
    public class ListeIDPDLPC {
        public StatutPropale statutPropale{set;get;}
        public List<ComposantePropositionCommerciale> ComposantePropositionCommerciale;
        public Personne personne;
        public IdComposante idPropositionCommerciale;
        public IdComposante dateProposition;
    }
    
    public class StatutPropale {
        public IdComposante code;
        public IdComposante libelleCourt;
    }
    
    public class Personne {
        public IdComposante idPersonne;
        public IdComposante nom;
        public IdComposante prenom;
    }
    public class IdComposante {
        public String value;
    }
    
    public class TypeComposantePropale {
        public IdComposante code;
        public IdComposante libelleCourt;
    }
    
    
    public class HistoriqueComposanteDt {
        public TypeComposantePropale refOffre;
        public TypeComposantePropale typeComposanteContrat;
        public TypeComposantePropale statutComposante;
        public IdComposante dateFinContrat;
        public IdComposante dateDebutContrat;
        public IdComposante idHistoriqueComposante;
    }
    
    public class ComposantePropositionCommerciale {
        public IdComposante idPropositionCommerciale;
        public StatutPropale statutPropale{set;get;}
        public IdComposante idComposante;
        public IdComposante dateEffetContractuelleInitiale;
        public TypeComposantePropale typeComposantePropale;
        public TypeComposantePropale refOffre;
        public PDL PDL;
    }
    
    public class PDL {
        public IdComposante idPDL;
        public TypeComposantePropale secteurActivite;
        public TypeComposantePropale reseau;
    }
    
    public class ListeIDPDLDonneesContrat5S {
        public PDL PDL;
        public HistoriqueComposanteDt historiqueComposanteDt;
        public IdComposante numContratISU;
    }
   
 
    public  WrapperContatPC parse(String json) {
        return (WrapperContatPC) System.JSON.deserialize(json, WrapperContatPC.class);
    }
}