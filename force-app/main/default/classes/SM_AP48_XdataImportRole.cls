@RestResource(urlMapping='/role/*')

global with sharing class SM_AP48_XdataImportRole {

	static final Schema.SObjectField acExtNo = Account.Fields.No_Compte_contrat__c;
	static final Schema.SObjectField ctExtNo = Contact.Fields.Identifiant_Buisness_Partener__c;
	static final Schema.SObjectField rolExtNo = AccountContactRelation.Fields.rolekey__c;

	@HttpPost
	global static string importRoles(List<Map<String,String>> roles) {
		// TODO: lire le numéro de version de l'url – adapter le traitement à la version de code, la table de correspondance

		SM_AP45_XdataImportUtils xiu = new SM_AP45_XdataImportUtils('xdata', 'AccountContactRelation');
		// record type des accounts et contacts smile, pour les creer quand necessaire
		Id acRectid = SM_AP45_XdataImportUtils.getRecTypeId(Account.sObjectType, 'Consumer');
		Id ctRectid = SM_AP45_XdataImportUtils.getRecTypeId(Contact.sObjectType, 'Contact_Smile');

		// 1- Lire les identifiants d'account et contact recu
		List<String> allAcNos = new List<String>();
		List<String> allCtNos = new List<String>();

		// les roles upsert
		Map<String,AccountContactRelation> allACRs = new Map<String,AccountContactRelation>(); 
		// les accounts et contacts non existants a creer
		Map<String,Account> newAcs = new Map<String,Account>();
		Map<String,Contact> newCts = new Map<String,Contact>();

		for(Map<String,String> rl : roles){
			String noac = rl.get('accountNo');
			String noct = rl.get('contactNo');
			String rlstr = rl.get('roles');

			// Erreur si on n'a pas d'id account ou contact ou pas de role
			if(noac == null || noac == '' || noct == null || noct == '' || rlstr == null || rlstr == ''){
				xiu.logImportError('Pas accountno ou contactno ou role',null, JSON.serialize(rl));
				continue;
			}

			allAcNos.add(noac);
			allCtNos.add(noct);

			try{
				AccountContactRelation aRole = new AccountContactRelation();
				String rolek = 'C_' + noac + '_B_' + noct;
				aRole.rolekey__c = rolek;
				aRole.Account = new Account(No_Compte_contrat__c = noac);
				aRole.Contact = new Contact(Identifiant_Buisness_Partener__c=noct);
				aRole.Roles = rlstr;
				allACRs.put(rolek, aRole);
			}catch(Exception e){
				xiu.logImportError('mapping', null, JSON.serialize(rl));
			}
		}


		// 2- Lister les accounts et contacts existants
		List<String> existingAcNos = new List<String>();
		for(Account ac1: [select No_Compte_contrat__c from Account where No_Compte_contrat__c in :allAcNos]){
			existingAcNos.add(ac1.No_Compte_contrat__c);
		}

		List<String> existingCtNos = new List<String>();
		for(Contact ct1: [select Identifiant_Buisness_Partener__c from Contact where Identifiant_Buisness_Partener__c in :allCtNos]){
			existingCtNos.add(ct1.Identifiant_Buisness_Partener__c);
		}

		// 3- Rechercher les accounts et contacts non existants

		for(Map<String,String> rl : roles){
			String noac = rl.get('accountNo');
			String noct = rl.get('contactNo');
			String rlstr = rl.get('roles');

			if(noac == null || noac == '' || noct == null || noct == ''|| rlstr == null || rlstr == '')
				continue;

			if((! existingAcNos.contains(noac)) && (!newAcs.containsKey(noac))){
				Account anewac = new Account(Name='AC_TECHNIQUE',No_Compte_contrat__c=noac, recordtypeid=acRectid);
				newAcs.put(noac,anewac);
			}

			if((! existingCtNos.contains(noct))&&(! newCts.containsKey(noct))){
				Contact anewct = new Contact(LastName='CT_TECHNIQUE',Identifiant_Buisness_Partener__c=noct,recordtypeid=ctRectid);
				anewct.Account = new Account(No_Compte_contrat__c=noac);
				newCts.put(noct,anewct);
			}
		}

		// 4- enregistrer en base accounts et contacts non existants
		if(! newAcs.isEmpty()){
			Database.UpsertResult[] srs = Database.upsert(newAcs.values(),acExtNo,false);
			xiu.logBulkUpsert(srs, newAcs.values());
		}

		if(! newCts.isEmpty()){        
			Database.UpsertResult[] srs = Database.upsert(newCts.values(),ctExtNo,false);
			xiu.logBulkUpsert(srs, newCts.values());
		}

		// 5 - enregistrement les roles en base
		if(! allACRs.isEmpty()){
			Database.UpsertResult[] srs = Database.upsert(allACRs.values(),rolExtNo, false);
			xiu.logBulkUpsert(srs, allACRs.values());
		}
		xiu.saveLogs();
		return 'ok';
	}
}