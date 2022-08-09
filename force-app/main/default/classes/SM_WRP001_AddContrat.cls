/**
* @author ADE
* @date Creation 05/11/2020
* @description Structure d'input pour contrat/addcontrat 
*/

public class SM_WRP001_AddContrat{
    public String IdBusinessPartner;	//312376423	
    public String refClientIdBP;	//312376423  
    public ClientIdentity contactinfo;
    public cls_services servicesAcceptes;
    public cls_services servicesRefuses;
    public cls_services servicesEnAttente;
    public String numeroVoie;
    public String libelleVoie;
    public String codePostal;
    public String ville;
    public String complementAdresse;
    public String canal;



    public cls_modePaiement paiementMode;
    
    public class cls_modePaiement{
        public String libellePaiement;
        public String sendingMode;
         public cls_modePrelevement modePrelevement;
    }
    
    public class cls_modePrelevement{
        public String nomTitulaire;
        public String dPrlv;
        public String iban;
        public String domiciliation;
    }


    public virtual  class cls_services {		
        public String idOffre;	//DEGS0
        public cls_clientInfos clientInfos; 
        public String formattedEtat;
        public String canal;
    }
    public class cls_clientInfos {
        public String dateEffet;
        public String DatePrelevement;
        public String canal;	//Email
        public String modeDePaiement;	//prelevement
        public cls_iban iban;
        //to remove
        public String refClientIdBP;	//312376423
        public String nom;
        public String prenom;
        public String civilite;
        public String email; // obligatoire pour le parcours digital
        //localAssure
        public string numeroVoie = '';
        public String libelleVoie = '';
        public String codePostal = '';
        public String ville = '';  
        public String complementAdresse = '';
        //client
        public String clNumeroVoie = '';
        public String clLibelleVoie = '';
        public String clCodePostal = '';
        public String clVille = '';
        public String clComplementAdresse = '';
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
    
  
    public class cls_iban {
        public String TitulaireCompte;	//Angel Di Maria
        public String Nombanque;	//BOURSORAMA
        public String bic;	//BOUSFRPPXXX
        public String IbanNumber;	//FR7640618802750004032774542
    }

    public class localAssure{
        public String numRue;
        public String rue;
        public String codePostal;
        public String commune;
        public String complement;
        public String pays;
    }
    public class RequestAddContrat{
        public contrat contrat;
        public String idConsomateur;
    }

    public class contrat{
        public ClientIdentity client;
        public localAssure localAssure;
        public cls_modePaiement paiementMode;
        public String dateEffet;
        public String idOffre;
        public Integer bpConseiller;
        public String canal;
        public String etat;
        public String order_id;
    }
    

    public class RequestOffreAvailables{
        public localAssure localAssure;
        public String idConsomateur;
        public String bpClient;
        public integer bpConseiller;
        public String canal;
    }
    

    public class RequestOffre{
        public localAssure localAssure;
        public String idConsomateur;
        public String bpClient;
    }


    

    public static SM_WRP001_AddContrat parse(String json){
        return (SM_WRP001_AddContrat) System.JSON.deserialize(json, SM_WRP001_AddContrat.class);
    }
    




}