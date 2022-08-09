/**
 * @author Unknown
 * @date 06/04/2022 - Sutharsan Pushparajah : Enforce Unit Testing
 * @description Test class for SM_AP87_NotesDebitsCredits
 */
@isTest
private class SM_AP87_NotesDebitsCredits_TEST {

    private static final String ID_PORTEFEUILLE_CONTRAT = '16963';

    /**
     * @author Sutharsan Pushparajah
     * @date 11/04/2022
     * @description Creating Contact Data in Salesforce
     */
	@TestSetup
	private static void init(){
		Account acc = SM_TestDataFactory.createAccount('Test');
		insert acc;

		Contact ct = SM_TestDataFactory.createContact('lastName', acc.Id);
		ct.ID_Tiers__c = Double.valueOf(ID_PORTEFEUILLE_CONTRAT);
        ct.Identifiant_Buisness_Partener__c = ID_PORTEFEUILLE_CONTRAT;
        ct.RecordTypeId = SM_EM100_Contact.RT_ID_CONTACT_SMILE;
		insert ct;
	}

    /**
     * @author Sutharsan Pushparajah
     * @date 11/04/2022
     * @description Mocking callout in test context
     */
    public inherited sharing class TestingMockHttp implements HttpCalloutMock{
		String payload = '{"_data":[{"id":61265,"idPersonne":35131,"idPortefeuilleContrat":16963,"energie":"Gaz","typeNote":"Note de débit","typeAjustement":"Frais/Services/Prestations","libelleArticle":"Gaz:Relevé spécial demandé client","montantTTC":135.18,"dateSaisie":"2020-03-16","statut":"Validé auto.","dateValidation":"date"}]}';

		public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody(payload);

            return res;
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 11/04/2022
     * @description Testing API Call with the identifiant portefeuille
     */
    @isTest 
    private static void testGetNotesDebitsCredits(){

        MCK000_MultiRequestMock multiMockHttp = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, multiMockHttp);
        multiMockHttp.addRequestMock('NOTES_DEBITS_CREDITS', new TestingMockHttp());

        Test.startTest();
        
        SM_wrapperNoteDebitCredit respwrp = SM_AP87_NotesDebitsCredits.getNotesDebitsCredits(ID_PORTEFEUILLE_CONTRAT);
        
        System.assertNotEquals(null, respwrp.x_data[0].idPersonne);
        System.assertEquals(35131, respwrp.x_data[0].idPersonne);
        System.assertEquals(Integer.valueOf(ID_PORTEFEUILLE_CONTRAT), respwrp.x_data[0].idPortefeuilleContrat);
        
        Test.stopTest();
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 11/04/2022
     * @description Testing API Call with the Salesforce Id of Contact record
     */
    @isTest 
    private static void testGetNotesDebitsCreditsByIdsf(){

        MCK000_MultiRequestMock multiMockHttp = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, multiMockHttp);
        multiMockHttp.addRequestMock('NOTES_DEBITS_CREDITS', new TestingMockHttp());

        String ctid = SM_EM100_Contact.getByIdentifiantBusinessPartners(new Set<String>{ID_PORTEFEUILLE_CONTRAT}).get(ID_PORTEFEUILLE_CONTRAT).Id;

        Test.startTest();
        
        SM_wrapperNoteDebitCredit respwrp = SM_AP87_NotesDebitsCredits.getNotesDebitsCreditsByIdsf(ctId);
        
        System.assertNotEquals(null, respwrp.x_data[0].idPersonne);
        System.assertEquals(35131, respwrp.x_data[0].idPersonne);
        System.assertEquals(Integer.valueOf(ID_PORTEFEUILLE_CONTRAT), respwrp.x_data[0].idPortefeuilleContrat);
        
        Test.stopTest();
    }
}