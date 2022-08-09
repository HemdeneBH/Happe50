/**
 * @author Sutharsan Pushparajah
 * @date 09/11/2021
 * @description SM_SM100_ContactImport - Handle creation of contact from external source
 */
public inherited sharing class SM_SM100_ContactImport {

    /* SyncEventLog__c handling utility */
	public static SM_AP45_XdataImportUtils xiu = new SM_AP45_XdataImportUtils('xdata', 'Contact');
    /* Custom Permission to bypass the import of contact */
    public static final String PERMISSION_BP_IMPORT_CONTACT = 'BP_IMPORT_CONTACT';
    /* Launch queueable only if number of records to process is greater */
    public static final Integer MIN_QUEUEABLE_BATCH_SIZE;
    /* Status to return when ok */
    public static final String STATUS_OK = 'OK';
    /* Status to return when ok */
    public static final String STATUS_KO = 'KO';

    static {
       MIN_QUEUEABLE_BATCH_SIZE = (Integer) SM_EM105_ProcessSettings.getProcessSettings('XDATA_IMPORT').get('QueueableThreshold');
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 09/11/2021
     * @description ContactInputWrp - Wrapper to map data from xdata import
     */
    public inherited sharing class ContactInputWrp{
        String referenceClient;
        String idTiers;
        String idTiersUnifie;
        String civilite;
        String firstName;
        String lastName;
        String mobilePrincipal;
        String mobile1;
        String adresseMail1;
        String adresseMail2;
        String adresseMail3;
        String adresseMailEspaceClient;
        String complementAdresse;
        String mailingPostCode;
        String mailingCity;
        String noCompteContrat;
        String segmentMarketing;
        String statutInternaute;
        String flArchive;
        String derniereModificationAdressePostale;
        String mailingStreetNumber;
        String mailingStreet;
        String derniereModificationFixePrincipal;
        String telFixePrincipal;
        String telFixe1;
        String telFixe2;
        String telFixe3;
        String derniereModificationMobilePrincipal;
        String mobile2;
        String mobile3;
        String derniereModificationMailPrincipal;
        String adresseMailPrincipale;
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 09/11/2021
     * @description ContactOutputWrp - Wrapper to map response
     */
    public inherited sharing class ContactOutputWrp{
        String jobId;
        String message = 'Unhandled Error';
        String status = STATUS_KO;
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 09/11/2021
     * @param contacts List of contacts with details represented by key/value pairs
     * @description process asynchronously the import of contact from external source
     * @return String informations about the processing of the query
     */
    public static String importContacts(List<Map<String, String>> contacts){
        ContactOutputWrp output = new ContactOutputWrp();

        if (FeatureManagement.checkPermission(PERMISSION_BP_IMPORT_CONTACT)){
            output.message = 'Not Processed, Bypass has been set';
            output.status = STATUS_OK;
        } else {
            try{
                AsyncImportContact importContact = new AsyncImportContact(contacts);
                if (contacts.size() > MIN_QUEUEABLE_BATCH_SIZE){
                    output.jobId = System.enqueueJob(importContact);
                    output.message = 'Processing';
                    output.status = STATUS_OK;
                } else {
                    importContact.execute(null);
                    output.message = 'Processed';
                    output.status = STATUS_OK;
                }
            } catch(Exception exp){
                output.message = exp.getMessage();
                output.status = STATUS_KO;
            }
        }

        return JSON.serialize(output);
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 09/11/2021
     * @description AsyncImportContact - Queueable class to implement contact import logics
     */
    public inherited sharing class AsyncImportContact implements System.Queueable{
        /* List of contacts with details represented by key/value pairs */
        List<Map<String, String>> contacts;
        
        /**
         * @param contacts List of contacts with details represented by key/value pairs
         * @description Constructor
         */
        public AsyncImportContact(List<Map<String, String>> contacts){
            this.contacts = contacts;
        }

        /**
         * @author Sutharsan Pushparajah
         * @date 09/11/2021
         * @param context QueueableContext
         * @description process asynchronously the import of contact
         * @return N/A
         */
        public void execute(QueueableContext context) {
            SM_SM100_ContactImport.processContactImport(contacts);
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 09/11/2021
     * @param contacts List of contacts with details represented by key/value pairs
     * @description process the import of contact
     * @return N/A
     */
    public static void processContactImport(List<Map<String, String>> contacts){
        /* List of contacts with details represented by contactsWrp */
        List<ContactInputWrp> contactsWrp;
        List<Contact> allContacts = new List<Contact>();
        Map<String, ContactInputWrp> contactsFromWsByRefClient = new Map<String, ContactInputWrp>();
        Map<String, Contact> inDbContactsByRefClient = new Map<String, Contact>();
        Map<String, Contact> newDbContactsByRefClient = new Map<String, Contact>();
        Map<String, String> newDbContactsRefByAccNoContrat = new Map<String, String>();
        Map<String, Account> existingAccountsByNoContrat = new Map<String, Account>();
        Map<String, Account> existingAccountsByNoContratNotFound = new Map<String, Account>();
        Map<String, Account> newAccountByCtRefClient = new Map<String, Account>();
        Map<String, String> existingAccountsForContactUpdate = new Map<String, String>();
        
        //1ST level error handling
        try{
            if (contacts != null && !contacts.isEmpty()){
                contactsWrp = (List<ContactInputWrp>) JSON.deserialize(JSON.serialize(contacts), List<ContactInputWrp>.class);
            }
            
            if (contactsWrp == null || contactsWrp.isEmpty()){
                return;
            }

            for (ContactInputWrp ct : contactsWrp){
                if (String.isNotEmpty(ct.referenceClient)){
                    contactsFromWsByRefClient.put(ct.referenceClient, ct);
                } else {
                    xiu.logImportError('No Business Person',null, JSON.serialize(ct));
                }
            }

            if (contactsFromWsByRefClient.isEmpty()){
                return;
            }

            inDbContactsByRefClient = SM_EM100_Contact.getByIdentifiantBusinessPartners(contactsFromWsByRefClient.keySet());
        } catch (Exception exp){
            APU000_Logger.log(LoggingLevel.ERROR, 'SM_SM100_ContactImport', 'processContactImport', exp.getMessage());
            xiu.logImportError('Import Contact Error : '+exp.getMessage(),null, JSON.serialize(contacts));
            saveLogs();
            //Do not continue if error detect in this block to avoid inconsistency
            return;
        }

        //Error handling contact by contact in this step
        for (String key : contactsFromWsByRefClient.keySet()){

            ContactInputWrp ctFromWs = contactsFromWsByRefClient.get(key);

            try {
                Contact ctInDb = inDbContactsByRefClient.get(key);
                
                if (ctInDb == null){
                    ctInDb = SM_EM100_Contact.createContactSmile();
                    newDbContactsByRefClient.put(key, ctInDb);

                    Account accTemp = SM_EM101_Account.createTechnicalConsumer(ctFromWs.noCompteContrat);
                    if (String.isNotEmpty(ctFromWs.noCompteContrat)){
                        existingAccountsByNoContrat.put(ctFromWs.noCompteContrat, accTemp);
                        existingAccountsByNoContratNotFound.put(ctFromWs.noCompteContrat, accTemp);
                        newDbContactsRefByAccNoContrat.put(key, ctFromWs.noCompteContrat);
                    } else {
                        newAccountByCtRefClient.put(key, accTemp);
                    }
                } else {
                    //Try to link the contact to the right account on each update
                    if (String.isNotEmpty(ctFromWs.noCompteContrat)){
                        existingAccountsForContactUpdate.put(ctFromWs.noCompteContrat, key);
                    }
                }
                
                fillContact(ctInDb, ctFromWs);

            } catch (Exception exp){
                APU000_Logger.log(LoggingLevel.ERROR, 'SM_SM100_ContactImport', 'processContactImport', exp.getMessage());
                xiu.logImportError('Mapping Error', null, JSON.serialize(contactsFromWsByRefClient.get(key)));
                //remove all related records to avoid post processing
                newDbContactsByRefClient.remove(key);
                existingAccountsByNoContrat.remove(ctFromWs.noCompteContrat);
                existingAccountsByNoContratNotFound.remove(ctFromWs.noCompteContrat);
                newDbContactsRefByAccNoContrat.remove(key);
                newAccountByCtRefClient.remove(key);
            }
        }

        // Create a savepoint to rollback everything
        Savepoint savepoint = null;

        try {

            if (!existingAccountsForContactUpdate.isEmpty()){
                List<Account> accList0 = SM_EM101_Account.getByNoCompteContrat(existingAccountsForContactUpdate.keySet());
                
                for(Account ac0: accList0){
                    String contactKey = existingAccountsForContactUpdate.get(ac0.No_Compte_contrat__c);
                    inDbContactsByRefClient.get(contactKey).AccountId = ac0.Id;
                }
            }
            
            if (!existingAccountsByNoContrat.isEmpty()){
                List<Account> accList1 = SM_EM101_Account.getByNoCompteContrat(existingAccountsByNoContrat.keySet());
                for(Account ac1: accList1){
                    existingAccountsByNoContrat.put(ac1.No_Compte_contrat__c, ac1);
                    existingAccountsByNoContratNotFound.remove(ac1.No_Compte_contrat__c);
                }
            }

            savepoint = Database.setSavepoint();

            if (!newAccountByCtRefClient.isEmpty()){
                //if an error occurs then the id will be empty and the related contact will be removed in the next step
                Database.SaveResult[] acsrs = SM_EM101_Account.insertWithFailureAllowed(newAccountByCtRefClient.values());
            }

            if (!existingAccountsByNoContratNotFound.isEmpty()){
                //if an error occurs then the id will be empty and the related contact will be removed in the next step
                Database.UpsertResult[] srs = SM_EM101_Account.upsertWithFailureAllowed(existingAccountsByNoContratNotFound.values(), SM_EM101_Account.FIELD_EXTID_NO_COMPTE_CONTRAT);
                xiu.logBulkUpsert(srs, existingAccountsByNoContratNotFound.values());
            }

            for (String key : newDbContactsByRefClient.keySet()){
                Account acc = newAccountByCtRefClient.get(key);

                //Identifying the right account to relate the contact
                if (acc == null){
                    String noCompteContrat = newDbContactsRefByAccNoContrat.get(key);
                    acc = existingAccountsByNoContratNotFound.get(noCompteContrat);
                    if (acc == null){
                        acc = existingAccountsByNoContrat.get(noCompteContrat);
                    }
                } 
                
                //if there is no account then we do not process this contact
                if (String.isEmpty(acc.Id)){
                    newDbContactsByRefClient.remove(key);
                    xiu.logImportError('Import Contact Error', null, JSON.serialize(contactsFromWsByRefClient.get(key)));
                } else {
                    newDbContactsByRefClient.get(key).AccountId = acc.Id;
                }
            }
            
            allContacts.addAll(newDbContactsByRefClient.values());
            allContacts.addAll(inDbContactsByRefClient.values());

            if (!allContacts.isEmpty()){
                Database.UpsertResult[] srList = SM_EM100_Contact.upsertWithFailureAllowed(allContacts,SM_EM100_Contact.FIELD_EXTID_IDENTIFIANT_BUSINESS_PARTENER);
                xiu.logBulkUpsert(srList, allContacts);
            }
        } catch (Exception exp){
            if (savepoint != null){
                //If for any reason there is an exception, we rollback all
                Database.rollback(savepoint);
            }
            APU000_Logger.log(LoggingLevel.ERROR, 'SM_SM100_ContactImport', 'processContactImport', exp.getMessage());
            xiu.logImportError('Import Contact Error : '+exp.getMessage(),null, JSON.serialize(contacts));
        }

        saveLogs();
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 12/11/2021
     * @description Commit errors into DB
     * @return N/A
     */
    private static void saveLogs(){
        try {
            xiu.saveLogs();
        } catch(Exception exp){
            //failing to save log must not break the transaction
            //should be done async or through platform events
            return;
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 09/11/2021
     * @param cont contact record
     * @param ct contact wrapper record from ws
     * @description Map Contact Wrapper attributes to Contact record
     * @return Contact updated contact with wrapper info
     */
    private static Contact fillContact(Contact cont, ContactInputWrp ct) {

        cont.Identifiant_Buisness_Partener__c = String.isEmpty(ct.referenceClient)?cont.Identifiant_Buisness_Partener__c:ct.referenceClient;
        cont.ID_Tiers__c = String.isEmpty(ct.idTiers)?cont.ID_Tiers__c:Double.valueOf(ct.idTiers);
        cont.HP_XDataExternalId__c = String.isEmpty(ct.idTiers)?cont.HP_XDataExternalId__c:Double.valueOf(ct.idTiers);
        cont.ID_Tiers_Unifie__c = String.isEmpty(ct.idTiersUnifie)?cont.ID_Tiers_Unifie__c:Double.valueOf(ct.idTiersUnifie);
        cont.Salutation = String.isEmpty(ct.civilite)?cont.Salutation:ct.civilite;
        cont.FirstName = String.isEmpty(ct.firstName)?cont.FirstName:ct.firstName;
        cont.LastName = String.isEmpty(ct.lastName)?cont.LastName:ct.lastName;
        cont.Date_de_derniere_modification_codePostal__c = String.isEmpty(ct.derniereModificationAdressePostale)?cont.Date_de_derniere_modification_codePostal__c:DateTime.newInstance(Long.valueOf(ct.derniereModificationAdressePostale));
        cont.No_Voie__c = String.isEmpty(ct.mailingStreetNumber)?cont.No_Voie__c:ct.mailingStreetNumber;
        cont.MailingStreet = String.isEmpty(ct.mailingStreet)?cont.MailingStreet:ct.mailingStreet;
        cont.Complement_adresse__c = String.isEmpty(ct.complementAdresse)?cont.Complement_adresse__c:ct.complementAdresse;
        cont.MailingPostalCode = String.isEmpty(ct.mailingPostCode)?cont.MailingPostalCode:ct.mailingPostCode;
        cont.MailingCity = String.isEmpty(ct.mailingCity)?cont.MailingCity:ct.mailingCity;
        cont.Date_de_derniere_modification_phone__c = String.isEmpty(ct.derniereModificationFixePrincipal)?cont.Date_de_derniere_modification_phone__c:DateTime.newInstance(Long.valueOf(ct.derniereModificationFixePrincipal));
        cont.Tel_Fixe_Principal__c = ct.telFixePrincipal;
        cont.Phone = String.isEmpty(ct.telFixe1)?cont.Phone:ct.telFixe1;
        cont.Tel_Fixe_2__c = String.isEmpty(ct.telFixe2)?cont.Tel_Fixe_2__c:ct.telFixe2;
        cont.Tel_Fixe_3__c = String.isEmpty(ct.telFixe3)?cont.Tel_Fixe_3__c:ct.telFixe3;
        cont.Date_de_derniere_modification_mobile__c = String.isEmpty(ct.derniereModificationMobilePrincipal)?cont.Date_de_derniere_modification_mobile__c:DateTime.newInstance(Long.valueOf(ct.derniereModificationMobilePrincipal));
        cont.Mobile_Principal__c = ct.mobilePrincipal;
        cont.MobilePhone = String.isEmpty(ct.mobile1)?cont.MobilePhone:ct.mobile1;
        cont.Mobile_2__c = String.isEmpty(ct.mobile2)?cont.Mobile_2__c:ct.mobile2;
        cont.Mobile_3__c = String.isEmpty(ct.mobile3)?cont.Mobile_3__c:ct.mobile3;
        cont.Date_de_derniere_modification_email__c = String.isEmpty(ct.derniereModificationMailPrincipal)?cont.Date_de_derniere_modification_email__c:DateTime.newInstance(Long.valueOf(ct.derniereModificationMailPrincipal));
        cont.Adresse_Mail_Principale__c = ct.adresseMailPrincipale;
        cont.Email = String.isEmpty(ct.adresseMail1)?cont.Mobile_3__c:(SM_APU100_StringUtils.emailAddressIsValid(ct.adresseMail1)?ct.adresseMail1:'');
        cont.Adresse_Mail_2__c = String.isEmpty(ct.adresseMail2)?cont.Adresse_Mail_2__c:(SM_APU100_StringUtils.emailAddressIsValid(ct.adresseMail2)?ct.adresseMail2:'');
        cont.Adresse_Mail_3__c = String.isEmpty(ct.adresseMail3)?cont.Adresse_Mail_3__c:(SM_APU100_StringUtils.emailAddressIsValid(ct.adresseMail3)?ct.adresseMail3:'');
        cont.Adresse_Mail_de_l_espace_client__c = String.isEmpty(ct.adresseMailEspaceClient)?cont.Adresse_Mail_de_l_espace_client__c:(SM_APU100_StringUtils.emailAddressIsValid(ct.adresseMailEspaceClient)?ct.adresseMailEspaceClient:'');
        cont.Statut_Internaute__c = String.isEmpty(ct.statutInternaute)?cont.Statut_Internaute__c:ct.statutInternaute;
        cont.Segment_Marketing__c = String.isEmpty(ct.segmentMarketing)?cont.Segment_Marketing__c:ct.segmentMarketing;
        cont.SM_isArchive__c = String.isEmpty(ct.flArchive)?cont.SM_isArchive__c:Boolean.valueOf(ct.flArchive);

		return cont;
	}
}