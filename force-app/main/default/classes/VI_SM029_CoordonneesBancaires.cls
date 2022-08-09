/*
*@Author: Paul Ghousoub
*@Description: Créer les coordonnées banquaires avec l Iban et l idPersonne
*@CreatedDate: 2/12/2020
*@LastModified: 2/12/2020
*/
public without sharing class VI_SM029_CoordonneesBancaires {
    /*
*@Auhtor: Paul Ghoussoub
*@Description Création du compte banquaire
*@CreatedDate: 15/02/2021
*/
    public static InfosCompteBancaire creerCompteBancaire(String idPersonne,String IbanNumber,String TitulaireCompte,String contexte, String partitionName)
    {
        InfosCompteBancaire infos=new InfosCompteBancaire();
        try {
            String idCoordonneeBancaire=creerCB(idPersonne,IbanNumber,TitulaireCompte);
            if(idCoordonneeBancaire.contains('Erreur: ')){
                infos.message = idCoordonneeBancaire;
                return infos;
            }
            String nomInstitutBancaire=VI_SM028_BanquesApiService.getInstitutBanqueByIBAN(IbanNumber,'VI','local.VIToken');
            infos.coordAdded=true;
            infos.idPersonne=idPersonne;
            infos.IbanNumber=IbanNumber;
            infos.libelle1='N° IBAN: ' + IbanNumber;
            infos.libelle2='Nom de la banque: ' + nomInstitutBancaire + ' ,Titulaire du compte: ' + TitulaireCompte;
            infos.Nombanque=nomInstitutBancaire;
            infos.idCoordonneeBancaire=idCoordonneeBancaire;
            infos.titulaire = TitulaireCompte;
        } catch (Exception e) {
            system.debug(e.getStackTraceString());
            infos.message = e.getMessage();
        }
        return infos;
    }
    
    /*@Auhtor: Paul Ghoussoub
*@Description: appel de la méthode pour la créationd de coordonnées bancaires
*@CreatedDate: 15/02/2021
*/
    public static String creerCB(String idPersonne,String IbanNumber,String TitulaireCompte) {
        if (String.isBlank(idPersonne)) {
            return null;
        }
        if (String.isBlank(IbanNumber)) {
            return null;
        }
        if (String.isBlank(titulaireCompte)) {
           return null;
        }
        
        //Context
        gdfsuezBefCalypsoCoordonneesbancaires.contextDt octx = initContext('PP', '2.0');
        gdfsuezBefCalypsoCoordonneesbancaires.Dependency port = new gdfsuezBefCalypsoCoordonneesbancaires.Dependency();
        port.endpoint_x = 'callout:VI_AuthOctopus'+ '/ES-CoordonneesBancaires_v2';
        port.timeout_x = 60000;
        port.inputHttpHeaders_x = new Map < String, String > {
            'Content-Type' => 'text/xml;charset=utf-8'
                };
                    gdfsuezBefCalypsoCoordonneesbancaires.creerCoordonneesBancairesInputDt coordonneesBancairesInput = new gdfsuezBefCalypsoCoordonneesbancaires.creerCoordonneesBancairesInputDt();
        coordonneesBancairesInput.coordonneesBancaires = new gdfsuezBefCalypsoCoordonneesbancaires.coordonneesBancairesDt();
        coordonneesBancairesInput.coordonneesBancaires.iban = IbanNumber.trim(); //'FR7612607000099501973863230';
        coordonneesBancairesInput.coordonneesBancaires.titulaireCompte = titulaireCompte;
        coordonneesBancairesInput.idPersonne = idPersonne; // '300014091' ;
        gdfsuezBefCalypsoCoordonneesbancaires.creerCoordonneesBancairesResponse_element response = new gdfsuezBefCalypsoCoordonneesbancaires.creerCoordonneesBancairesResponse_element();
        
        String responseCodeCreerCB;
        String responseLibelleCreerCB;
        
        try {
            System.debug('*** request : ' + coordonneesBancairesInput);
            
            if (test.isRunningTest()) {
                Test.setMock(WebServiceMock.class, new VI_SM029_CoordonneesBancaires_Mock());
                response = CreerCoordonneesBancaires(coordonneesBancairesInput, octx,port);
            }
            else{
                response = CreerCoordonneesBancaires(coordonneesBancairesInput, octx,port);
            }
            responseCodeCreerCB = response.messageRetours.messageRetour[0].code;
            responseLibelleCreerCB = response.messageRetours.messageRetour[0].libelle;
            if (!responseCodeCreerCB.equals('OCTOPUS_CreerCB_01')) {
                return 'Erreur: ' + responseLibelleCreerCB;
            }
            system.debug('response '+response);
            return response.creerCoordonneesBancairesOutput.idCoordonneeBancaire ;
        } catch (Exception e) {
            if (test.isRunningTest()) {
                system.debug('e.getMessage()'+ e.getMessage());
                return null;
            }
            System.debug('*** Error when calling WS : ' + e);
            return 'Erreur:' + e.getMessage();
        }
        
    }
    /*
*@Auhtor: Paul Ghoussoub
*@Description Génération du contexte
*@CreatedDate: 15/02/2021
*/
    public static gdfsuezBefCalypsoCoordonneesbancaires.contextDt initContext(String application, String version) {
        // Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
        gdfsuezBefCalypsoCoordonneesbancaires.system_element osource = new gdfsuezBefCalypsoCoordonneesbancaires.system_element();
        osource.systemId = application;
        gdfsuezBefCalypsoCoordonneesbancaires.contextDt octx = new gdfsuezBefCalypsoCoordonneesbancaires.contextDt();
        octx.version = version;
        //  octx.allowCache = false ;
        octx.systemPath = new gdfsuezBefCalypsoCoordonneesbancaires.systemPath_element();
        octx.systemPath.system_x = new gdfsuezBefCalypsoCoordonneesbancaires.system_element[] {
            osource
                };
                    return octx;
    }
    /*
*@Auhtor: Paul Ghoussoub
*@Description Wrapper du compteBancaire
*@CreatedDate: 15/02/2021
*/
    public class InfosCompteBancaire{
        @AuraEnabled
        public Boolean coordAdded;
        @AuraEnabled
        public String idPersonne;
        @AuraEnabled
        public String IbanNumber;
        @AuraEnabled
        public String libelle1;
        @AuraEnabled
        public String libelle2;
        @AuraEnabled
        public  String Nombanque;
        @AuraEnabled
        public String idCoordonneeBancaire;
        @AuraEnabled
        public String message;
        @AuraEnabled
        public String titulaire;
    }
/*@Author: Paul Ghoussoub
*@Description: Appel Http vers le service CoordonneesBancaires
*@CreatedDate: 16/02/2021
*/
    public static gdfsuezBefCalypsoCoordonneesbancaires.creerCoordonneesBancairesResponse_element CreerCoordonneesBancaires(gdfsuezBefCalypsoCoordonneesbancaires.creerCoordonneesBancairesInputDt creerCoordonneesBancairesInput,gdfsuezBefCalypsoCoordonneesbancaires.contextDt context,
                                                                                                                    gdfsuezBefCalypsoCoordonneesbancaires.Dependency port) 
    {
        gdfsuezBefCalypsoCoordonneesbancaires.creerCoordonneesBancaires_element request_x = new gdfsuezBefCalypsoCoordonneesbancaires.creerCoordonneesBancaires_element();
        request_x.creerCoordonneesBancairesInput = creerCoordonneesBancairesInput;
        request_x.context = context;
        gdfsuezBefCalypsoCoordonneesbancaires.creerCoordonneesBancairesResponse_element response_x;
        Map<String, gdfsuezBefCalypsoCoordonneesbancaires.creerCoordonneesBancairesResponse_element> response_map_x = new Map<String, gdfsuezBefCalypsoCoordonneesbancaires.creerCoordonneesBancairesResponse_element>();
        response_map_x.put('response_x', response_x);
        WebServiceCallout.invoke(
            port,
            request_x,
            response_map_x,
            new String[]{port.endpoint_x,
                'tns:CreerCoordonneesBancaires',
                'http://gdfsuez/bef/calypso/CoordonneesBancaires/v2',
                'creerCoordonneesBancaires',
                'http://gdfsuez/bef/calypso/CoordonneesBancaires/v2',
                'creerCoordonneesBancairesResponse',
                'gdfsuezBefCalypsoCoordonneesbancaires.creerCoordonneesBancairesResponse_element'}
        );
        response_x = response_map_x.get('response_x');
        return response_x;
    }
    
    public class IOException extends Exception {}
}