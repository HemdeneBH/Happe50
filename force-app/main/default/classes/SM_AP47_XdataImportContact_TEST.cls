@isTest
private class SM_AP47_XdataImportContact_TEST {

	static SM_AP45_XdataImportUtils xiu = new SM_AP45_XdataImportUtils('xdata', 'Contact');
	// record type des contact et accounts smile
	static Id ctRectid = SM_AP45_XdataImportUtils.getRecTypeId(Contact.sObjectType,'Contact_Smile');
	static Id acRectid = SM_AP45_XdataImportUtils.getRecTypeId(Account.sObjectType, 'Consumer');

    @isTest static void testImportContacts() {
        List<Account> accts = new List<Account>();
        for(Integer i = 0 ; i<10 ; i++){
			accts.add(new Account(Name='AC_TECHNIQUE',No_Compte_contrat__c ='000000'+i , recordtypeid = acRectid));
        }
        insert accts;
            
        Contact ct=SM_TestDataFactory.createContact('lastName',accts[1].Id); 
        ct.Identifiant_Buisness_Partener__c='0000001';
		insert ct;

        List<Map<String,String>> listContacts = new List<Map<String,String>>();
        for(Integer i = 0 ; i<10 ; i++){
            Map<String,String> contactToInsert = new Map<String,String>{
                'referenceClient' => '000000'+i,
                'idTiers' => '100'+i,
                'idTiersUnifie' => '200'+i,
                'civilite'=>'MME',
                'firstName'=>'FirstName'+i,
                'lastName' => 'LastName'+i,
                'mobilePrincipal' => 'Mobile 1',
                'mobile1' => '+33652954152',
                'adresseMail1' => 'test'+i+'@invalid',
                'adresseMail2' => 'test'+i+'@invalid',
                'adresseMail3' => 'test'+i+'@invalid',
                'adresseMailEspaceClient'=> 'test'+i+'@invalid',
                'complementAdresse'=>'Complement_adresse__c',
                'mailingPostCode'=>'MailingPostalCode',
                'mailingCity'=>'MailingCity',
                'noCompteContrat' => '000000'+i,
                'segmentMarketing' => 'Segment_Marketing__c'
            };
            listContacts.add(contactToInsert);
            contactToInsert = new Map<String,String>{
                'idTiers' => '200'+i
            };
            listContacts.add(contactToInsert);  
        }
        String res = SM_AP47_XdataImportContact.importContacts(listContacts);
        integer numok = Database.countQuery('select count() from contact');
        system.debug('Number of inserted contacts: ' + numok);
		System.assert((numok==10),'Error inserting 10 contacts with account, found: ' + numok);
    }


    @isTest static void testImportContactsWithACTECH() {

        List<Map<String,String>> listContacts = new List<Map<String,String>>();
        for(Integer i = 0 ; i<10 ; i++){
            Map<String,String> contactToInsert = new Map<String,String>{
                'referenceClient' => '000000'+i,
                'idTiers' => '100'+i,
                'idTiersUnifie' => '200'+i,
                'civilite'=>'MME',
                'firstName'=>'FirstName'+i,
                'lastName' => 'LastName'+i,
                'mobilePrincipal' => 'Mobile 1',
                'mobile1' => '+33652954152',
                'adresseMail1' => 'test'+i+'@koko.com',
                'complementAdresse'=>'Complement_adresse__c',
                'mailingPostCode'=>'MailingPostalCode',
                'mailingCity'=>'MailingCity',
                'noCompteContrat' => '000000'+i,
                'segmentMarketing' => 'Segment_Marketing__c',
                'adresseMail2' => 'test2'+i+'@koko.com',
                'adresseMail3' => 'test2'+i+'@koko.com',
                'adresseMailEspaceClient'=> 'testEC'+i+'@koko.com'
            };
            listContacts.add(contactToInsert);
        }
        String res = SM_AP47_XdataImportContact.importContacts(listContacts);
        integer numokac = Database.countQuery('select count() from account where Name=\'AC_TECHNIQUE\'');
        system.debug('Number of inserted technical accounts: ' + numokac);
		System.assert((numokac==10),'Error inserting 10 contacts with no accounts, found: ' + numokac);
        integer numok = Database.countQuery('select count() from contact');
        system.debug('Number of inserted contacts without accounts: ' + numok);
		System.assert((numok==10),'Error inserting 10 contacts without accounts, found: ' + numok);
    }
    
    @isTest static void testImportContactsWithoACTECH() {

        List<Map<String,String>> listContacts = new List<Map<String,String>>();
        for(Integer i = 0 ; i<10 ; i++){
            Map<String,String> contactToInsert = new Map<String,String>{
                'referenceClient' => '000000'+i,
                'idTiers' => '100'+i,
                'idTiersUnifie' => '200'+i,
                'civilite'=>'MME',
                'firstName'=>'FirstName'+i,
                'lastName' => 'LastName'+i,
                'mobilePrincipal' => 'Mobile 1',
                'mobile1' => '+33652954152',
                'adresseMail1' => 'test'+i+'@koko.com',
                'complementAdresse'=>'Complement_adresse__c',
                'mailingPostCode'=>'MailingPostalCode',
                'mailingCity'=>'MailingCity',
                'segmentMarketing' => 'Segment_Marketing__c'
            };
            listContacts.add(contactToInsert);
        }
        String res = SM_AP47_XdataImportContact.importContacts(listContacts);
        integer numokac = Database.countQuery('select count() from account where Name=\'AC_TECHNIQUE\'');
        system.debug('Number of inserted technical accounts: ' + numokac);
		System.assert((numokac==10),'Error inserting 10 contacts with no num accounts, found: ' + numokac);
        integer numok = Database.countQuery('select count() from contact');
        system.debug('Number of inserted contacts without num accounts: ' + numok);
		System.assert((numok==10),'Error inserting 10 contacts without num accounts, found: ' + numok);
    }
}