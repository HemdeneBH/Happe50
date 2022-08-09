public with sharing class SM_AP47_XdataImportContact {


	static final Schema.SObjectField acExtNo = Account.Fields.No_Compte_contrat__c;
	static final Schema.SObjectField ctExtNo = Contact.Fields.Identifiant_Buisness_Partener__c;

	static SM_AP45_XdataImportUtils xiu = new SM_AP45_XdataImportUtils('xdata', 'Contact');

	// record type des contact et accounts smile
	static Id ctRectid = SM_AP45_XdataImportUtils.getRecTypeId(Contact.sObjectType,'Contact_Smile');
	static Id acRectid = SM_AP45_XdataImportUtils.getRecTypeId(Account.sObjectType, 'Consumer');

	/*	
	// liste des champs pour le suivi de fraicheur des coordonnees client
	static String[] mapEltsad = new List<String> {'derniereModificationAdressePostale','mailingStreet','mailingStreetNumber','complementAdresse','mailingPostCode','mailingCity'};
	static String[] mapEltstel = new List<String> {'derniereModificationFixePrincipal','telFixePrincipal','telFixe1','telFixe2','telFixe3'};
	static String[] mapEltsmob = new List<String> {'derniereModificationMobilePrincipal','mobilePrincipal','mobile1','mobile2','mobile3'};
	static String[] mapEltsmail = new List<String> {'derniereModificationMailPrincipal','adresseMailPrincipale','adresseMail1','adresseMail2','adresseMail3'};
	*/
	public static String importContacts(List<Map<String,String>> contacts) {

		// TODO: lire le numéro de version de l'url – adapter le traitement à la version de code, la table de correspondance

		// Verifier si le contact reference un account sinon le creer
		// chercher tous les accounts en fonction de :noCompteContrat=Account\:No_Compte_contrat__c
		// 

		// les contactsNos des donnees recues
		List<String> allCtNos = new List<String>();
		// les accountNos des donnees recues
		List<String> acExtNos = new List<String>();
		// les account sans accountNo
		List<Account> acWitouthAcNos = new List<Account> ();

		// tous les contacts
		Map<String,Contact> ctsAll = new Map<String,Contact>();
		// les contacts sans reference de accountNo
		List<Contact> ctsWitouthAcNos = new List<Contact> ();


		// 0- lire  en base la derniere date de MAJ des adresses de contact, leur num 
		for(Map<String,String> ct : contacts){
			String ctno1 = ct.get('referenceClient');
			if(ctno1 == null){
				xiu.logImportError('Pas de no BP',null, JSON.serialize(ct));
				continue;
			}
			allCtNos.add(ctno1);
		}

		// map des id sap vers les donnees en base des contacts
		Map<String, Contact> inDbContacts = new Map<String,Contact>();
		for(Contact ctdb: [select id, Identifiant_Buisness_Partener__c, Date_de_derniere_modification_codePostal__c, 
				Date_de_derniere_modification_email__c , Date_de_derniere_modification_phone__c, Date_de_derniere_modification_mobile__c
				from Contact where Identifiant_Buisness_Partener__c in :allCtNos]){
			inDbContacts.put(ctdb.Identifiant_Buisness_Partener__c, ctdb);
		}

		// 1- Separer les contacts avec identifiants d'account de ceux qui n'en ont pas
		for(Map<String,String> ct : contacts){
            system.debug('***ct : '+ ct);
			String ctno1 = ct.get('referenceClient');
			if(ctno1 == null) continue;

			Contact ctInDb = inDbContacts.get(ctno1);
			// choisir si on met a jour les coordonnees du contact
			//System.debug('updating contact: ' +  JSON.serialize(ct));

			try{
				/*				
				if(ctInDb != null){
					manageUpdateIfNewer(ct, 'derniereModificationAdressePostale', ctInDb.Date_de_derniere_modification_codePostal__c, mapEltsad);
					manageUpdateIfNewer(ct, 'derniereModificationFixePrincipal', ctInDb.Date_de_derniere_modification_phone__c, mapEltstel);
					manageUpdateIfNewer(ct, 'derniereModificationMobilePrincipal', ctInDb.Date_de_derniere_modification_mobile__c, mapEltsmob);
					manageUpdateIfNewer(ct, 'derniereModificationMailPrincipal', ctInDb.Date_de_derniere_modification_email__c, mapEltsmail);
				} 
				*/

				Contact ct1 = ctsAll.get(ctno1);
				if(ct1==null){
					ct1 = new Contact(recordTypeId = ctRectid);
					ctsAll.put(ctno1, ct1);
				} 
				fillContact(ct1, ct);
                system.debug('***ct1 : '+ ct1);

				// si le contact existe deja en base il a deja un account direct existant, on ne le change pas
				// si le contact n'existe en base il faut lui associer un account direct
				if(ctInDb == null){
					// distinction entre les contacts qui referencent ou non un account
					// TODO: batch de nettoyage pour les accounts techniques
					String noac = ct.remove('noCompteContrat');
					// si le contact reference un account sap
					if((noac != null) && (noac != '')){
						acExtNos.add(noac);
						ct1.Account = new Account(No_Compte_contrat__c=noac);
                        system.debug('***link account : '+ noac);
					}else{
						// scenario A.2.1, creer un contact et un account technique sans ID sap
						acWitouthAcNos.add(new Account(Name='AC_TECHNIQUE', recordtypeid = acRectid));
						ctsWitouthAcNos.add(ct1);
					}
                } /*else {
                    // cas de l'update
                    String noac = ct.remove('noCompteContrat');
					// si le contact reference un account sap
					if((noac != null) && (noac != '')){
						acExtNos.add(noac);
						ct1.Account = new Account(No_Compte_contrat__c=noac);
					}
                }*/
			}catch(Exception e){
				xiu.logImportError('mapping', null, JSON.serialize(ct));
			}
		}

		// 2- Pour les nouveaux contacts sans id d'account SAP, mettre un account technique en direct account
		if(! acWitouthAcNos.isEmpty()){
			Database.SaveResult[] acsrs = Database.insert(acWitouthAcNos,false);
			// TODO: verifier quil n'y a pas des erreurs
			// lier les contacts avec ces accounts
			for(integer npos = 0; npos < acWitouthAcNos.size();npos +=1){
				Account acpos = acWitouthAcNos.get(npos);
				Contact ctpos = ctsWitouthAcNos.get(npos);
				ctpos.accountId = acpos.id;
                system.debug('***link account id : '+ acpos.id + 'to contact : '+ ctpos);
			}
		}

		// 3- Pour les nouveaux contacts avec id d'account SAP, mettre un account SAP en direct account et le creer si necessaire
		if(! acExtNos.isEmpty()){
			// 3.a rechercher les accounts avec un id SAP deja en base
			List<String> existingAcNos = new List<String>();
			for(Account ac1: [select id, No_Compte_contrat__c from Account where No_Compte_contrat__c in :acExtNos]){
				existingAcNos.add(ac1.No_Compte_contrat__c);
			}

			// 3.b- Creer les accounts non existants comme accounts techniques avec record type smile
			List<Account> newAcWithNos = new List<Account>();
			for(String ctno2 : acExtNos){
				if(existingAcNos.contains(ctno2))
					continue;
				Account newac = new Account(Name='AC_TECHNIQUE',No_Compte_contrat__c=ctno2, recordtypeid=acRectid);
				newAcWithNos.add(newac);
				// eviter duplicat si on a 2 contacts avec le meme account
				existingAcNos.add(ctno2);
			}
			if(! newAcWithNos.isEmpty()){
				Database.UpsertResult[] srs = Database.upsert(newAcWithNos,acExtNo,false);
				xiu.logBulkUpsert(srs, newAcWithNos);
			}
		}

		// 4- enregistrement en base des contacts
		if(! ctsAll.isEmpty()){
            List<Contact> listContacts = ctsAll.values();
            for(Integer i = 0; i< listContacts.size(); i++){
                Contact myContact = listContacts[i];
                if(myContact.Account != null && myContact.accountId != null){
                    // résolution du bug "Cannot specify both an external ID reference and a salesforce id"
                    // on supprime le champ AccountId quand Account est renseigné
					
					/* 
					if (myContact.Email == null && Adresse_Mail_2__c == null && myContact.Adresse_Mail_3__c == null && myContact.Adresse_Mail_Principale__c != null) {
						myContact.Adresse_Mail_Principale__c = null;
					}
					if (myContact.Phone == null && Tel_Fixe_2__c == null && myContact.Tel_Fixe_3__c == null && myContact.Tel_Fixe_Principal__c != null) {
						myContact.Tel_Fixe_Principal__c = null;
					}
					if (myContact.MobilePhone == null && Mobile_2__c == null && myContact.Mobile_3__c == null && myContact.Mobile_Principal__c != null) {
						myContact.Mobile_Principal__c = null;
					}
					*/

                    Map<String, Object> myContactMap = new Map<String, Object>(myContact.getPopulatedFieldsAsMap() );
                    myContactMap.remove('AccountId'); // Attention : case sensitive
                    listcontacts[i] = (Contact) JSON.deserialize(JSON.serialize(myContactMap), Contact.class);
                    
                }
            }
			Database.UpsertResult[] srList = Database.upsert(listContacts,ctExtNo, false);
			xiu.logBulkUpsert(srList, listContacts);
		}
		xiu.saveLogs();
		return 'ok' ;
	}

	/*	
	static void manageUpdateIfNewer(Map<String,String> inputmap, String mapk, Datetime sobjdate, List<String> mapkeys){
		// garder les données si on recoit une date
		// et si la date est plus récente que en base

		String datestr = inputmap.get(mapk);        
		if(datestr != null && datestr != ''){
			Datetime mapdate = DateTime.newInstance(Long.valueOf(datestr));            
			if(sobjdate == null || sobjdate < mapdate)
				return;
		}

		for(String k : mapkeys)
			inputmap.remove(k);
	}
	*/

	// methode pour vérifier si le format de l'email est valide oun non
    public static Boolean emailAddressIsValid(String email) {
		if (String.isEmpty(email)) return true;
		Boolean isValid = true;
			
		// Regex source: http://www.regular-expressions.info/email.html
		String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; 
		Pattern MyPattern = Pattern.compile(emailRegex);
		Matcher MyMatcher = MyPattern.matcher(email);
	
		// on élimine aussi quelques cas non gérés par la regex
        if (!MyMatcher.matches() || email.contains('-.') || email.contains('.-') || email.contains('@-') || email.endsWith('.')) 
		    isValid = false;
		return isValid;
	}
    
    
	public static Contact fillContact(Contact cont, Map<String,String> ct) {
		for(String fieldName : ct.keySet()){
			String fieldVal = ct.get(fieldName);
			//if(fieldVal==null) continue;
			String [] principalContactFields = new String[]{'telFixePrincipal', 'adresseMailPrincipale', 'mobilePrincipal'};
			if (!principalContactFields.contains(fieldName) && fieldVal==null) continue;

			switch on fieldName{
				when 'referenceClient' { cont.Identifiant_Buisness_Partener__c = fieldVal; }
				when 'idTiers' { cont.ID_Tiers__c = Double.valueOf(fieldVal); }
				when 'idTiersUnifie' { cont.ID_Tiers_Unifie__c = Double.valueOf(fieldVal); }
				when 'civilite' { cont.Salutation = fieldVal; }
				when 'firstName' { cont.FirstName = fieldVal; }
				when 'lastName' { cont.LastName = fieldVal; }
				when 'derniereModificationAdressePostale' { cont.Date_de_derniere_modification_codePostal__c = DateTime.newInstance(Long.valueOf(fieldVal)); }
				when 'mailingStreetNumber' { cont.No_Voie__c = fieldVal; }
				when 'mailingStreet' { cont.MailingStreet = fieldVal; }
				when 'complementAdresse' { cont.Complement_adresse__c = fieldVal; }
				when 'mailingPostCode' { cont.MailingPostalCode = fieldVal; }
				when 'mailingCity' { cont.MailingCity = fieldVal; }
				when 'derniereModificationFixePrincipal' { cont.Date_de_derniere_modification_phone__c = DateTime.newInstance(Long.valueOf(fieldVal)); }
				when 'telFixePrincipal' { cont.Tel_Fixe_Principal__c = fieldVal; }
				when 'telFixe1' { cont.Phone = fieldVal; }
				when 'telFixe2' { cont.Tel_Fixe_2__c = fieldVal; }
				when 'telFixe3' { cont.Tel_Fixe_3__c = fieldVal; }
				when 'derniereModificationMobilePrincipal' { cont.Date_de_derniere_modification_mobile__c = DateTime.newInstance(Long.valueOf(fieldVal)); }
				when 'mobilePrincipal' { cont.Mobile_Principal__c = fieldVal; }
				when 'mobile1' { cont.MobilePhone = fieldVal; }
				when 'mobile2' { cont.Mobile_2__c = fieldVal; }
				when 'mobile3' { cont.Mobile_3__c = fieldVal; }
				when 'derniereModificationMailPrincipal' { cont.Date_de_derniere_modification_email__c = DateTime.newInstance(Long.valueOf(fieldVal)); }
				when 'adresseMailPrincipale' { cont.Adresse_Mail_Principale__c = fieldVal; }
				when 'adresseMail1' { 
                    				 	if (emailAddressIsValid(fieldVal)) 
                    						cont.Email = fieldVal;
                                    	else
                                        	cont.Email = '';
                                     }
				when 'adresseMail2' { 
                                        if (emailAddressIsValid(fieldVal)) 
                                            cont.Adresse_Mail_2__c = fieldVal;
                                        else
                                            cont.Adresse_Mail_2__c = '';
                                    }
				when 'adresseMail3' { 
                                        if (emailAddressIsValid(fieldVal)) 
                                            cont.Adresse_Mail_3__c = fieldVal;
                                        else
                                            cont.Adresse_Mail_3__c = '';
                					}
				when 'adresseMailEspaceClient' { 
                    					if (emailAddressIsValid(fieldVal)) 
                                            cont.Adresse_Mail_de_l_espace_client__c = fieldVal;
                                        else
                                            cont.Adresse_Mail_de_l_espace_client__c = '';
										 }
				when 'statutInternaute' { cont.Statut_Internaute__c = fieldVal; }
				when 'segmentMarketing' { cont.Segment_Marketing__c = fieldVal; }
				when 'flArchive' {cont.SM_isArchive__c = Boolean.valueOf(fieldVal); }
				
				when else { System.debug('input field not managed: ' + fieldName + ' with value: ' + fieldVal);
				}
			}
		}
		return cont;
	}
	
}