/*
*@Author: Paul Ghoussoub
*@Description: Appel pour créer les espaces privés des nouveaux clients
*@CreatedDate: 09/05/22
*@LastModified: 11/05/22
*/
public class VI_SM052_EspacesPrives { 
     /* @author Paul Ghoussoub
	* @date 09/05/22
	* @description appel pour récupérer les code promos pour les offres proposées
	* @parameters informations sur le client , le contexte et la partition
	*/
    public static Response creerEspaceClient(String prenom,String nom,String numeroTelephone,String email,String numeroBP,String contexte,String partitionName){
        String token;
        Map<String, Object> requestMap =new Map<String, Object>();
        if (!Test.isRunningTest()){ 
            token = VI_SM013_GetTokenService.getTokenB2C(contexte, partitionName);
            system.debug('token '+token);
            if (token == null) {
                system.debug('Token not found ...');
            }
        }
        EspaceClientACreer espaceClient  = new EspaceClientACreer(prenom,nom,numeroTelephone,email,numeroBP);
        Map<String,Object> espaceClientACreerBody = buildEspaceClientACreerRequestBody(espaceClient);
        HttpResponse httpResponse = VI_UTIL001_HttpUtilities.makeHttpCall(token,'POST',contexte+'_EspacePriveB2C',null,espaceClientACreerBody,null,'application/json','application/json',null, 'VI');
        Response response = parse(httpResponse.getBody());
        return response;
        
        
    }
    public class EspaceClientACreer{
        public String prenom ;
        public String nom ;
        public String numeroTelephone ;
        public String email ;
        public String numeroBP ;
        
        public EspaceClientACreer(String prenom, String nom, String numeroTelephone, String email, String numeroBP){
            this.prenom = prenom;
            this.nom = nom;
            this.numeroTelephone = numeroTelephone;
            this.email = email;
            this.numeroBP = numeroBP;
        }
    }
    
    public static Map<String,Object> buildEspaceClientACreerRequestBody(EspaceClientACreer espaceClient){
        Map<String,Object> mapBody=new Map<String,Object>();
        Map<String,Object> mapidentite=new Map<String,Object>();
        mapidentite.put('telephone', espaceClient.numeroTelephone);
        mapidentite.put('prenom', espaceClient.prenom);
        mapidentite.put('nom', espaceClient.nom);
        mapidentite.put('login', espaceClient.email);
        mapidentite.put('email', espaceClient.email);
        Map<String,Object> mapReferencesSI=new Map<String,Object>();
        Map<String,Object> mapReferencesSI2=new Map<String,Object>();
        List<Map<String,Object>> listMapReferencesSI=new List<Map<String,Object>>();
        mapReferencesSI.put('referenceClient', espaceClient.numeroBP);
        mapReferencesSI.put('application', 'SYMPHONIE_DGP');
        listMapReferencesSI.add(mapReferencesSI);
        mapBody.put('referencesSI', listMapReferencesSI);
        mapBody.put('identite', mapidentite);
        return mapBody;
    } 
    
    
    public class Response {
        public String oktaId;
        public Identite identite;
        public List<String> entites;
        public Boolean estActif;
        public Boolean estRattache;
        public String idB2C;
        public String statusCreation;
        public String code;
        public String status;
        public String message;
        
    }
    
    public class Identite {
        public String nom;
        public String prenom;
        public String login;
        public String email;
        public String telephone;
    }
    
    
    public static Response parse(String json) {
        return (Response) System.JSON.deserialize(json, Response.class);
    }
    
}