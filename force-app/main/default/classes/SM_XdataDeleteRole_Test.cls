@isTest
public class SM_XdataDeleteRole_Test {

	static SM_AP45_XdataImportUtils xiu = new SM_AP45_XdataImportUtils('xdata', 'Contact');
	// record type des contact et accounts smile
	static Id ctRectid = SM_AP45_XdataImportUtils.getRecTypeId(Contact.sObjectType,'Contact_Smile');
	static Id acRectid = SM_AP45_XdataImportUtils.getRecTypeId(Account.sObjectType, 'Consumer');

    @isTest static void testDelRole() {
        // Create accounts
        List<Account> accts = new List<Account>();
        for(Integer i = 0 ; i<100 ; i++){
			accts.add(new Account(Name='AC_TECHNIQUE1',No_Compte_contrat__c ='000000'+i , recordtypeid = acRectid));
        }
        insert accts;
        integer numokac = Database.countQuery('select count() from account');
        system.debug('Number of inserted accounts: ' + numokac);
		System.assert((numokac==100),'Error inserting 100 accounts, found: ' + numokac);

        
		// Create contacts and automatically roles
        List<Map<String,String>> listContacts = new List<Map<String,String>>();
        for(Integer i = 0 ; i<100 ; i++){
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
                'segmentMarketing' => 'Segment_Marketing__c'
            };
            listContacts.add(contactToInsert);
        }
        String res = SM_AP47_XdataImportContact.importContacts(listContacts);
        integer numok = Database.countQuery('select count() from contact');
        system.debug('Number of inserted contacts: ' + numok);
		System.assert((numok==100),'Error inserting 100 contacts with account, found: ' + numok);
        
        
        List<Map<String,String>> roles = new List<Map<String,String>>();
        for(Integer i = 0 ; i<50 ; i++){
            Map<String,String> rl = new Map<String,String>{
                'accountNo' => '000000'+i ,
                'contactNo' => '000000'+i
            };
            roles.add(rl);
            roles.add(new Map<String,String>{'accountNo' => '110000'+i ,'contactNo' => '220000'+i});
        }
        String roleres = SM_XdataDeleteRole.deleteRoles(roles);
        integer numVal = Database.countQuery('select count() from account where name=\'AC_TECHNIQUE1\'');
        system.debug('Number of unchanged accounts: ' + numVal);
		System.assert((numVal==100),'Error inserting 100 contacts with account, found: ' + numVal);
        
        numVal = Database.countQuery('select count() from account where name=\'AC_TECHNIQUE\'');
        system.debug('Number of replacement accounts: ' + numVal);
		System.assert((numVal==50),'Error inserting 100 contacts with account, found: ' + numVal);
        
        numVal = Database.countQuery('select count() from accountcontactrelation ');
        system.debug('Number of ACR: ' + numVal);
		System.assert((numVal==100),'Error inserting 100 contacts with account, found: ' + numVal);
                      
        
        
    }



}