/**
@Author <Amar Kaillo>
@name <SM_AP82_lireIdentiteUtilisateur>
@CreatedDate <06/03/2020>
@Description <Class called from SM_Batch_lireIdentiteUtilisateur - FT1-3649>
@Version <1.0>
@reference <Referenced program names>
@ModifiedBy <Amar Kaillo>
*/
public class SM_AP82_lireIdnentiteUtilisateur {
    
    public static list<User> callWSUpdateUser(User user, SM_OCTOPUS__c octopusCS, List<User> listUsersUpdate){

            gdfsuezBefCalypsoIdentiteutilisateu.lireIdentiteUtilisateurDt lireIdentiteUtilisateurInput = new gdfsuezBefCalypsoIdentiteutilisateu.lireIdentiteUtilisateurDt();
            // identiteUtilisateur
            lireIdentiteUtilisateurInput.identiteUtilisateur = new gdfsuezComBefCalypsoIdentiteutilisa.IdentiteUtilisateurAbstract();
            lireIdentiteUtilisateurInput.identiteUtilisateur.idUtilisateur = user.Gaia__c;
            // Context
            gdfsuezComBefChpPivot_Utili.contextDt context = new gdfsuezComBefChpPivot_Utili.contextDt();
            // Version
            context.version = '3';
            // System
            context.systemPath = new gdfsuezComBefChpPivot_Utili.contextDt_systemPath_element();
            context.systemPath.system_x = new list<gdfsuezComBefChpPivot_Utili.contextDt_systemPath_system_element>();
            gdfsuezComBefChpPivot_Utili.contextDt_systemPath_system_element systemIdElement = new gdfsuezComBefChpPivot_Utili.contextDt_systemPath_system_element();
            systemIdElement.systemId = 'Smile';
            context.systemPath.system_x.add(systemIdElement);
            // Cache
            context.allowCache = false;
            // Port
            gdfsuezBefCalypsoIdentiteutilisateu.Dependency identiteUtilisateurPort = new gdfsuezBefCalypsoIdentiteutilisateu.Dependency();          
            identiteUtilisateurPort.clientCertName_x = octopusCS.certName__c;
            identiteUtilisateurPort.timeout_x = 30000;
            SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'IdentiteUtilisateur_v3' limit 1];
            identiteUtilisateurPort.endpoint_x = octopusCS.endpoint__c + suffixs.suffix__c;
        System.debug('### aka endpoint ' + identiteUtilisateurPort.endpoint_x);
            identiteUtilisateurPort.inputHttpHeaders_x = new Map<String, String> {'Content-Type' => 'text/xml;charset=utf-8'};
                gdfsuezBefCalypsoIdentiteutilisateu.lireIdentiteUtilisateurResponse_element response = new gdfsuezBefCalypsoIdentiteutilisateu.lireIdentiteUtilisateurResponse_element();
            
            // Test Class Data
            if(Test.isRunningTest()){
                Test.setMock(HttpCalloutMock.class, new SM_AP82_lireIdentiteUtilisateur_Mock());
                identiteUtilisateurPort = new gdfsuezBefCalypsoIdentiteutilisateu.Dependency();    
            }
            // Call identiteUtilisateur and get response
            response = identiteUtilisateurPort.lireIdentiteUtilisateur_Http(lireIdentiteUtilisateurInput,context);
            
            if(response != null 
               && response.lireIdentiteUtilisateurOutput != null 
               && response.lireIdentiteUtilisateurOutput.identiteUtilisateur != null 
               && response.lireIdentiteUtilisateurOutput.identiteUtilisateur.uniteOrganisationnelle != null
               && response.lireIdentiteUtilisateurOutput.identiteUtilisateur.uniteOrganisationnelle.idUniteOrganisationnelle != null){
                   System.debug('### aka response.lireIdentiteUtilisateurOutput.identiteUtilisateur.uniteOrganisationnelle.idUniteOrganisationnelle ' + response.lireIdentiteUtilisateurOutput.identiteUtilisateur.uniteOrganisationnelle.idUniteOrganisationnelle);
                   //    update the info on the user record
                   if((user.SM_Identifiant_Organisation__c != String.valueOf(response.lireIdentiteUtilisateurOutput.identiteUtilisateur.uniteOrganisationnelle.idUniteOrganisationnelle))|| (user.SAP_Identifier__c!=Decimal.valueOf(response.lireIdentiteUtilisateurOutput.identiteUtilisateur.uniteOrganisationnelle.numeroBPUtilisateur))){
                       user.SM_Identifiant_Organisation__c = String.valueOf(response.lireIdentiteUtilisateurOutput.identiteUtilisateur.uniteOrganisationnelle.idUniteOrganisationnelle);
                       user.SAP_Identifier__c = Decimal.valueOf(response.lireIdentiteUtilisateurOutput.identiteUtilisateur.uniteOrganisationnelle.numeroBPUtilisateur);
                        listUsersUpdate.add(User);
                   }
               }
            return listUsersUpdate;
    }
    

}