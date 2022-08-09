/**
* @author AL
* @date Creation 27/12/2020
* @description Structure d'input pour contrat/addcontrat 
*/

public class SM_WRP002_AddContrat{
          
   public class contrat{
        public list <metaValues> metaValues;
        public ClientIdentity client;
        public localAssure localAssure;
        public cls_modePaiement paiementMode;
        public String idOffre;
        public String bpConseiller;
        public String canal;
        public String etat;
        public String order_id;
        public String commentaire;
    }
    
    public class ClientIdentity {       
        public String nom;
        public String prenom;
        public String civilite; 
      	public String email;
        public String bpClient;
        public String numRue;
        public String rue;
        public String codePostal;
        public String commune;
    }
    
    public class localAssure{
        public String numRue;
        public String rue;
        public String codePostal;
        public String commune;
        public String pays;
    }
    
    public class cls_modePaiement{
        public String libellePaiement;
        public String sendingMode;
        public String modePrelevement;
	}
    
    public class metaValues{
         public String fieldName;
         public String fieldValue;
    }
    
    public class RequestAddContrat{
        public contrat contrat;
        public String idConsomateur;
    }



}