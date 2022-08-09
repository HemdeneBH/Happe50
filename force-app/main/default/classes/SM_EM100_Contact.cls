/**
 * @author Sutharsan Pushparajah
 * @date 09/11/2021
 * @description SM_EM100_Contact - Entity to manage Contact SObject
 */
public inherited sharing class SM_EM100_Contact {
    
    /* Technical contact name */
    public static final String TECHNICAL_NAME = 'CT_TECHNIQUE';
    /* Instance of the contact datamanager to access SOQL & DML operations */
    public static ITF001_DataManager datamanager = new DM001_SObjectInstance(SObjectType.Contact.Name, 'SM_EM100_Contact');
    /* External Id field Identifiant_Buisness_Partener__c */
    public static final Schema.SObjectField FIELD_EXTID_IDENTIFIANT_BUSINESS_PARTENER = Contact.Fields.Identifiant_Buisness_Partener__c;
    /* Contact_Smile RecordType Id */
    public static final Id RT_ID_CONTACT_SMILE = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact_Smile').getRecordTypeId();

    /**
     * @author Sutharsan Pushparajah
     * @date 10/11/2021
     * @description Create a smile contact
     * @return Contact instance of contact for smile contact
     */
    public static Contact createContactSmile(){
        return new Contact(recordtypeid = RT_ID_CONTACT_SMILE);
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 10/11/2021
     * @description Create a smile contact for the corresponding identifiant Business Partner
     * @param IdBuisnessPartener Identifiant Business Partner which is the id of the contact record
     * @return Contact instance of contact for smile contact
     */
    public static Contact createContactSmile(String IdBuisnessPartener){
        return new Contact(LastName = TECHNICAL_NAME,recordtypeid = RT_ID_CONTACT_SMILE, Identifiant_Buisness_Partener__c= IdBuisnessPartener);
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 09/11/2021
     * @param identifiantBusinessPartners Identifiant_Buisness_Partener__c to filter on
     * @description get a map of constacts filtered by Identifiant_Buisness_Partener__c
     * @return Map<String, Contact> Map of contact by Identifiant_Buisness_Partener__c
     */
    public static Map<String, Contact> getByIdentifiantBusinessPartners(Set<String> identifiantBusinessPartners){
        
        Map<String, Contact> contactsByIdBusinessPartener = new Map<String, Contact>();
        
        for(Contact ct: [select id, Identifiant_Buisness_Partener__c, ID_Tiers__c, HP_XDataExternalId__c, ID_Tiers_Unifie__c, Salutation, FirstName, LastName,
                         Date_de_derniere_modification_codePostal__c, No_Voie__c, MailingStreet, Complement_adresse__c, MailingPostalCode, MailingCity,
            			 Date_de_derniere_modification_email__c , Date_de_derniere_modification_phone__c, Date_de_derniere_modification_mobile__c,
                         Tel_Fixe_Principal__c, Phone, Tel_Fixe_2__c, Tel_Fixe_3__c, Mobile_Principal__c, MobilePhone, Mobile_2__c, Mobile_3__c, 
                         Adresse_Mail_Principale__c, Email, Adresse_Mail_2__c, Adresse_Mail_3__c, Adresse_Mail_de_l_espace_client__c, Statut_Internaute__c,
                         Segment_Marketing__c, SM_isArchive__c, RecordTypeId
            			 from Contact where Identifiant_Buisness_Partener__c in :identifiantBusinessPartners]){
            
            contactsByIdBusinessPartener.put(ct.Identifiant_Buisness_Partener__c, ct);
        }

        return contactsByIdBusinessPartener;
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 09/11/2021
     * @param contacts list of contact to insert/update through upsert
     * @param externalIdField Field used as externalId for upsert
     * @description insert/update through upsert contact records and allow partial success
     * @return Database.UpsertResult[] List of upsertresult for contact upsert
     */
    public static Database.UpsertResult[] upsertWithFailureAllowed(List<Contact> contacts, Schema.SObjectField externalIdField){
        Database.UpsertResult[] srs = Database.upsert(contacts, externalIdField, false);
        return srs;
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 06/04/2022
     * @param fields fields to query separated by comma
     * @param ids List of contact Id to query on
     * @description Query contact records filtered on id
     * @return List<Contact> List of contact records queried by id
     */
    public static List<Contact> getByIds(String fields, List<Id> ids){
        return datamanager.queryBy(fields, String.valueOf(Contact.Id), ids);
    }
    
}