/**
 * @author Sutharsan Pushparajah
 * @date 07/04/2022
 * @description Test class for SM_EM100_Contact
 */
@isTest
private class SM_EM100_Contact_TEST {
    
    private static final String ID_BUSINESS_PARTNER = '0312386733';

    /**
     * @author Sutharsan Pushparajah
     * @date 06/04/2022
     * @description Testing the Personnes API
     */
    @TestSetup
    private static void init(){

        Contact ct = SM_EM100_Contact.createContactSmile(ID_BUSINESS_PARTNER);

        SM_EM100_Contact.datamanager.insertList(new List<Contact>{ct}, true);
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 06/04/2022
     * @description Testing creation methods
     */
    @isTest
    private static void testCreateContactSmile(){
        
        Test.startTest();

        Contact ct = SM_EM100_Contact.createContactSmile();
        System.assertNotEquals(null, ct);
        System.assertEquals(SM_EM100_Contact.RT_ID_CONTACT_SMILE, ct.recordTypeId);

        ct = SM_EM100_Contact.createContactSmile(ID_BUSINESS_PARTNER);
        System.assertNotEquals(null, ct);
        System.assertEquals(SM_EM100_Contact.RT_ID_CONTACT_SMILE, ct.recordTypeId);
        System.assertEquals('CT_TECHNIQUE', ct.LastName);
        System.assertEquals(ID_BUSINESS_PARTNER, ct.Identifiant_Buisness_Partener__c);

        Test.stopTest();
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 06/04/2022
     * @description Testing getter by Salesforce Ids & by Identifiant Business Partner
     */
    @isTest
    private static void testGetByIdsAndIdentifiantBusinessPartner(){
        
        Test.startTest();

        Map<String, Contact> ctMap = SM_EM100_Contact.getByIdentifiantBusinessPartners(new Set<String>{ID_BUSINESS_PARTNER});
        System.assertNotEquals(null, ctMap);

        Contact ct = ctMap.get(ID_BUSINESS_PARTNER);
        System.assertNotEquals(null, ct);

        Contact ct2 = SM_EM100_Contact.getByIds('Id, LastName, RecordTypeId, Identifiant_Buisness_Partener__c', new List<Id>{ct.Id}).get(0);

        System.assertNotEquals(null, ct2);
        System.assertEquals(ct.Id, ct2.Id);
        System.assertEquals(SM_EM100_Contact.RT_ID_CONTACT_SMILE, ct2.RecordTypeId);
        System.assertEquals('CT_TECHNIQUE', ct2.LastName);
        System.assertEquals(ID_BUSINESS_PARTNER, ct2.Identifiant_Buisness_Partener__c);
        
        Test.stopTest();
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 06/04/2022
     * @description Testing getter by Salesforce Ids
     */
    @isTest
    private static void testUpsertWithFailureAllowed(){

        Test.startTest();

        Datetime theDay = Datetime.now();

        Map<String, Contact> ctMap = SM_EM100_Contact.getByIdentifiantBusinessPartners(new Set<String>{ID_BUSINESS_PARTNER});
        System.assertNotEquals(null, ctMap);

        Contact ct = ctMap.get(ID_BUSINESS_PARTNER);
        ct.Date_de_derniere_modification_phone__c = theDay;

        Database.UpsertResult[] srs = SM_EM100_Contact.upsertWithFailureAllowed(new List<Contact>{ct}, SM_EM100_Contact.FIELD_EXTID_IDENTIFIANT_BUSINESS_PARTENER);
        System.assertNotEquals(null, srs);
        System.assertEquals(true, srs.get(0).isSuccess());

        Test.stopTest();
    }
}