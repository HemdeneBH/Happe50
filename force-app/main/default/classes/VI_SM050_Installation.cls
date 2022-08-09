/*
*@Author: Paul Ghoussoub
*@Description: Appel vers l'API installations
*@CreatedDate: 22/03/22
*@LastModified: 22/03/22
*/

public class VI_SM050_Installation {
    public static InstallationsWrapper callInstallations(String numeroPointDeLivraison, String contexte, String partitionName){
        String res;
        Map<String, String> paramInstallations = new Map<String, String>();
        paramInstallations.put('numeroPointDeLivraison', numeroPointDeLivraison);
        
        String token;
        if (!Test.isRunningTest()){
            token = VI_SM013_GetTokenService.getToken(contexte, partitionName);
            system.debug('token '+token);
            if (token == null) {
                system.debug('Token not found ...');
                return null;
            }
        }
        else {
            token = 'ABCDEFU';
        }
        
        HttpResponse httpResponse =  VI_UTIL001_HttpUtilities.makeHttpCall(token,'GET', contexte+ '_Installations', paramInstallations, null, contexte);
        system.debug(VI_UTIL001_HttpUtilities.handleResponse(httpResponse.getBody()));
        res = VI_UTIL001_HttpUtilities.handleResponse(httpResponse.getBody());
        system.debug('res :'+ res);
        InstallationsWrapper responseWrapper = InstallationsWrapper.parse(httpResponse.getBody());
        system.debug('¤ responseWrapper : '+responseWrapper);
        if(responseWrapper == null){
            return NULL;
        }
        return responseWrapper;
    }
    
    public class InstallationsWrapper{
        public List<Data> data {get;set;} // in json: _data
        public Pagination pagination {get;set;} // in json: _pagination
        public String code {get;set;} 
        public String name {get;set;} 
        public String message {get;set;} 
    }
    
    class Data {
        public Integer id {get;set;} 
        public Integer idLocal {get;set;} 
        public Integer idPointDeLivraison {get;set;} 
        public String numeroPointDeLivraison {get;set;} 
        public String numeroInstallation {get;set;} 
        public String secteurActivite {get;set;} 
        public String typeTarif {get;set;} 
        public String uniteReleve {get;set;} 
        public String typeService {get;set;} 
        public String dateDebutContrat {get;set;} 
        public String datePremiereMiseEnService {get;set;} 
        public String dateDerniereVisite {get;set;} 
        
    }
    
    public class Pagination {
        public String pageActuelle {get;set;} 
        public Integer elementParPage {get;set;} 
        public String pagePrecedente {get;set;} 
        public String pageSuivante {get;set;} 
    }
    
    public static InstallationsWrapper parse(String json){
        json = json.replace('_data', 'data');
        json = json.replace('_pagination', 'pagination');
		return (InstallationsWrapper) System.JSON.deserialize(json, InstallationsWrapper.class);
	}
}