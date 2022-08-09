/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 07-27-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
@isTest
public with sharing class HP_EC_DocumentManager_TEST {
    
    @TestSetup
    static void setup(){

        Account ac = new Account(name = 'HP Portal Account');
        insert ac;

        Contact con = new Contact(LastName = 'Portal Account', AccountId = ac.Id, ID_Tiers__c = 100166);
        insert con;
        
    }

    @isTest
    static void getAllPortalData() {

        Id p = [SELECT id FROM profile where name = 'HP_Community_User'].id;
        Contact con = [SELECT id FROM Contact WHERE lastname = 'Portal Account' LIMIT 1];
        User portalUser = new User(alias = 'hpPortal', email = 'portaluser@noemail.com', EmailEncodingKey = 'UTF-8', lastname = 'Portal', 
        LanguageLocaleKey = 'en_US', LocaleSidKey ='en_US', ProfileId = p, country = 'United States', IsActive = true, contactId = con.Id, TimeZoneSidKey = 'Europe/Paris', UserName = 'portaluser@noemail.com');
        insert portalUser;
        Id pset = [SELECT id FROM PermissionSet where name = 'HP_EC_permissions' LIMIT 1].id;
        PermissionSetAssignment psa =  new PermissionSetAssignment(PermissionSetId = pset, AssigneeId = portalUser.id);
        insert psa;

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_AgilabAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            '/api/happe/0.1/protected-agilab/api/v1/portefeuille_contrats/get_documents?' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
            'HP_AGILAB_GET_DOCUMENT_ResponseMOCK',
            new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_APIHourAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),

            'apiset/0.2/contrats?idPersonne' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
            'HP_CONTRAT_XDATA_BY_PERSONNE_MOCK',
            new Map<String, String> {'Content-Type' => 'application/json'}
            ),                    'apiset/0.3/portefeuilles-contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
            null, '{"idPortefeuilleContrat":"123"}',
            new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'}),

            '/api/happe/1.0/locaux-contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
            null, '{"idPortefeuilleContrat":"123"}',
            new Map<String, String> {'Content-Type' => 'application/json'}),
            'coordonnees-bancaires' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, null, '{"_data": []}',
                                            new Map<String, String>())



        };

        //User portalUser = [SELECT id FROM User WHERE username = 'portaluser@noemail.com' LIMIT 1];
        system.runAs(portalUser) {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
            HP_EC_DocumentManager.getContractDocumentsInfo('123');
            HP_EC_DocumentManager.getJustificatif('123');
            HP_EC_DocumentManager.getJustificatifDeDomicileVariables();
            HP_EC_DocumentManager.generateJustificatifDomicilePDF('{"date_du_jour":"date_du_jour","ref_client":"ref_client","adresse_factu1":"adresse_factu1","adresse_factu2":"adresse_factu2","adresse_local":"adresse_local","ref_contrat":"ref_contrat","civilite_titulaire":"civilite_titulaire","nom_titulaire":"nom_titulaire","prenom_titulaire":"prenom_titulaire","civilite_cotitulaire":"civilite_cotitulaire","nom_cotitulaire":"nom_cotitulaire","prenom_cotitulaire":"prenom_cotitulaire","bodyParagraph":"bodyParagraph","capital_GDF_SUEZ":"capital_GDF_SUEZ","adr_gdfsuez_siege":"adr_gdfsuez_siege","numero_tva_gdf_suez":"numero_tva_gdf_suez","service_client_agilab":"service_client_agilab","depannage_elec":"depannage_elec","depannage_gaz":"depannage_gaz"}');
            Test.stopTest();
        }
    }
}