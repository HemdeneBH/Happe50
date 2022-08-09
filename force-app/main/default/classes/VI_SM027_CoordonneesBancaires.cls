public without sharing class VI_SM027_CoordonneesBancaires {
    /*
*@Author: Paul Ghoussoub
*@Description: Appel de l'API APIHOUR apiset/coordonnées bancaires avec l'idBP
*@CreatedDate: 12/02/2021
*@LastModified: 20/05/2021
*/
    
    public static List<Coordonnees> getCoordonneesBancaires(String idBP,String contexte, String partitionName){
        Map<String, String> listParameters = new Map<String, String>();
        List<Coordonnees> cordonneesBancaires = new List<Coordonnees>();
        listParameters.put('idBusinessPartner', idBP); //'0302898231'
        String token;
        if(!Test.isRunningTest()){
            token = VI_SM013_GetTokenService.getToken(contexte, partitionName);
        }
        else{
            token = 'test';
        }
        if (token == null) {
            system.debug('Token not found ...');  
            return null;
        }
        HttpResponse httpResponse = new HttpResponse();
        if (test.isRunningTest()) {
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('SM_MockResponseGetCoordonneesBancaires');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json');
            // Set the mock callout mode
            Test.setMock(HttpCalloutMock.class, mock);
        }
        httpResponse = VI_UTIL001_HttpUtilities.makeHttpCall(token,'GET',contexte+'_Coordonnees_Bancaires',listParameters,null, contexte);
        system.debug('@@ httpResponse ' + httpResponse);
        if (httpResponse != null) {
            Map < String, Object > resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
            List < Object > listCoordonneesB = (List < Object > ) resultAsMap.get('_data');
            if (listCoordonneesB != null && !listCoordonneesB.isEmpty()) {
                integer i=0;
                for( Object coordonneesBancaire : listCoordonneesB){
                    system.debug('coordonneesBancaire'+ coordonneesBancaire);
                    Map < String, Object > coordonnes = (Map < String, Object > ) listCoordonneesB[i];
                    Coordonnees coob = new Coordonnees();
                    coob.IbanNumber = (String) coordonnes.get('iBAN');
                    coob.IbanNumberX = 'XXXXXXXXXXXXXXXXXXXXXXX'+ coob.IbanNumber.substring(coob.IbanNumber.length()-4,coob.IbanNumber.length());
                    coob.bic = (String) coordonnes.get('bIC');
                    coob.Nombanque = (String) coordonnes.get('nomInstitutBancaire');
                    coob.TitulaireCompte = (String) coordonnes.get('titulaire');
                    coob.idCompteClientCoordB= (String) coordonnes.get('idBusinessPartner');
                    coob.idCoordonneeBancaire = (String) coordonnes.get('id'); 
                    coob.libelle = coob.IbanNumber + '\r\n' + coob.Nombanque + '|'+ coob.TitulaireCompte;
                    VI_SM031_GestionPrelevement.mandatRetour mandatRetour=VI_SM031_GestionPrelevement.demandePrelevement(null,coob.idCoordonneeBancaire,idBP.substring(1),
                                                                                                                     null,
                                                                                                                     'callout:VI_AuthOctopus');
                    //DDPCM 302 Start
                    if(mandatRetour != null){
                        coob.statutMandat = mandatRetour.statutMandat;
                        if(mandatRetour.statutMandat=='Actif'){
                            coob.isSigned=true;
                        }
                        else{
                            coob.isSigned=false;
                        }
                    }
                    //DDPCM 302 End
                    i++;
                    cordonneesBancaires.add(coob);
                }
            }
            
        }
        return cordonneesBancaires;
    }
    
    public static String getCoordonneesBancairesById(String idBP, String idCoordBancaires,String contexte, String partitionName){
        Map<String, String> listParameters = new Map<String, String>();
        List<Coordonnees> cordonneesBancaires = new List<Coordonnees>();
        system.debug('idCoordBancaires'+ idCoordBancaires);
        listParameters.put('idBusinessPartner', idBP); //'0302898231'
        String token;
        if(!Test.isRunningTest()){
            token = VI_SM013_GetTokenService.getToken(contexte, partitionName);
        }
        else{
            token = 'test';
        }
        if (token == null) {
            system.debug('Token not found ...');  
            return null;
        }
        HttpResponse httpResponse = new HttpResponse();
        if (test.isRunningTest()) {
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('SM_MockResponseGetCoordonneesBancaires');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json');
            // Set the mock callout mode
            Test.setMock(HttpCalloutMock.class, mock);
        }
        httpResponse = VI_UTIL001_HttpUtilities.makeHttpCall(token,'GET',contexte+'_Coordonnees_Bancaires',listParameters,null, contexte);
        system.debug('@@ httpResponse ' + httpResponse);
        if (httpResponse != null) {
            Map < String, Object > resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
            system.debug('resultAsMap '+resultAsMap);
            List < Object > listCoordonneesB = (List < Object > ) resultAsMap.get('_data');
            system.debug('listCoordonneesB '+listCoordonneesB);
            if (listCoordonneesB != null && !listCoordonneesB.isEmpty()) {
                integer i=0;
                for( Object coordonneesBancaire : listCoordonneesB){
                    system.debug('coordonneesBancaire '+coordonneesBancaire);
                    Map < String, Object > coordonnes = (Map < String, Object > ) listCoordonneesB[i];
                    String coordonneeBancaire = (String) coordonnes.get('id');
                    system.debug('coordonneeBancaire'+ coordonneeBancaire);
                    if(coordonneeBancaire == idCoordBancaires){
                        String IBAN = (String) coordonnes.get('iBAN');
                        system.debug('IBAN '+IBAN);
                        return IBAN;
                    }
                  i++;  
                }
            }
            
        }
        return null;
    }    
    public class Coordonnees{
        @AuraEnabled
        public String IbanNumber; 
        @AuraEnabled
        public String IbanNumberX; 
        @AuraEnabled
        public String bic;
        @AuraEnabled
        public String Nombanque;
        @AuraEnabled
        public String TitulaireCompte;
        @AuraEnabled
        public String idPersonne;
        @AuraEnabled
        public String idCompteClientCoordB;
        @AuraEnabled
        public String idCoordonneeBancaire;
        @AuraEnabled
        public String libelle;
        @AuraEnabled
        public String statutMandat;
        @AuraEnabled
        public String message;
        @AuraEnabled
        public Boolean isSigned;
    }
    
}