public without sharing class SM_AP46_XdataImportAccount {

	static final Schema.SObjectField accExtId = Account.Fields.No_Compte_contrat__c;
	static SM_AP45_XdataImportUtils xiu = new SM_AP45_XdataImportUtils('xdata','Account');
	static Id rectid = SM_AP45_XdataImportUtils.getRecTypeId(Account.sObjectType,'Consumer');
    
    // TODO: socle, quel record type pour smile et happe ?
    // TODO: socle rechercher les account selon les identifiants externes smile et happe
    // TODO: socle, Map<Double, Account> upAccs = new Map<Double, Account>();
	public static string importAccounts(List<Map<String,String>> accounts) {
		// TODO: lire le numéro de version de l'url – adapter le traitement à la version de code, la table de correspondance
		
		Set<String> allnocomptec = new Set<String>();
		Map<String, Account> insAccs = new Map<String, Account>();
		Map<String, Account> upAccs = new Map<String, Account>();
        List<Map<String,String>> accounts2 = new List<Map<String,String>>(); // apres nettoyage

		System.debug(logginglevel.INFO,'0 - start import account');

		// 1: get list of all accounts received
        for(Map<String,String> ac : accounts){
			// recherche sur le numero de compte contrat (identifiant SAP) et [TODO Happe] sinon sur l'identifiant xdata ID_Porte_feuille_contrat__c
			String nocomptec = ac.get('noCompteContrat');
			if(nocomptec == null || nocomptec == ''){
				xiu.logImportError('Pas de noCompteContrat',null, JSON.serialize(ac));
				continue;
			}
            String idLocalstr = ac.get('idLocal');
            system.debug('idLocalstr:'+idLocalstr);
            
            if(idLocalstr == null || idLocalstr == '' || Double.valueOf(idLocalstr) == 0){
				xiu.logImportError('Pas de idLocal correct',null, JSON.serialize(ac));
				continue;
			}
			
            accounts2.add(ac);
			allnocomptec.add(nocomptec);
		}

		System.debug(logginglevel.INFO,'1 - check input account done');

		// 2 : check which account already exists
		//AB : new fields added to the query 
		for(Account existac: [select Name,Id, No_Compte_contrat__c,ID_Porte_feuille_contrat__c,ID_Batiment__c,ID_Local__c,LB_Portefeuille_contrat__c,FoyerId__c,FoyerLabel__c,StartDate__c,EndDate__c from Account where No_Compte_contrat__c in :allnocomptec]){
			upAccs.put(existac.No_Compte_contrat__c, existac);
		}

		System.debug(logginglevel.INFO,'2 - read existing account - number : ' + upAccs.keySet().size());

		// 3 Insert or update the account
        for(Map<String,String> ac : accounts2){
			String nocomptec = ac.get('noCompteContrat');
			if(upAccs.containsKey(nocomptec)){ // update
				try{
					Account anAccount = upAccs.get(nocomptec);
                    system.debug('anAccount:'+anAccount);
					fillAccount(anAccount, ac);
					//upAccs.put(nocomptec, anAccount);
				}catch(Exception e){
					xiu.logImportError('mapping: '+e.getMessage(), null, JSON.serialize(ac));
				}
			}else{ // insert
				try{
					Account anAccount = insAccs.get(nocomptec);
					if(anAccount==null){
						anAccount = new Account(recordTypeId = rectid);
						insAccs.put(nocomptec, anAccount);
					}
					fillAccount(anAccount, ac);
				}catch(Exception e){
					xiu.logImportError('mapping: '+e.getMessage(), null, JSON.serialize(ac));
				}
				
			}

		}

		System.debug(logginglevel.INFO,'3 - modify in mem account done');


		if(! insAccs.isEmpty()){
			List<Account> accToWrite = insAccs.values();
			Database.SaveResult[] srList = Database.insert(accToWrite, false);
			xiu.logBulkInsertUpdate(srList, accToWrite);
		}
		System.debug(logginglevel.INFO,'4 - insert account done :' + insAccs.keySet().size());


		if(! upAccs.isEmpty()){
			List<Account> accToWrite = upAccs.values();
			Database.SaveResult[] srList = Database.update(accToWrite, false);
			xiu.logBulkInsertUpdate(srList, accToWrite);
		}

		System.debug(logginglevel.INFO,'5 - update account done: '  + upAccs.keySet().size());

		xiu.saveLogs();
		System.debug(logginglevel.INFO,'6 - save logs');

		return 'ok';
	}



		public static void fillAccount(Account acc, Map<String,String> acdats) {
		List<String> allkeys = new List<String>(acdats.keySet());
		integer numkeys = allkeys.size();
		//String fieldName;
		//String fieldVal;
		for(integer pos = 0; pos<numkeys;pos+=1){
			final string fieldName = allkeys[pos];
			final string fieldVal = acdats.get(fieldName);

			if(fieldVal==null) continue; 

			switch on fieldName{
				when 'name' {if(acc.Name != fieldVal) { acc.Name = fieldVal;} }
				when 'noCompteContrat' { acc.No_Compte_contrat__c = fieldVal; }
				when 'idPortefeuilleContrat' { acc.ID_Porte_feuille_contrat__c = Double.valueOf(fieldVal); }
				when 'idBatiment' { acc.ID_Batiment__c = Double.valueOf(fieldVal); }
				when 'idLocal' { acc.ID_Local__c = Double.valueOf(fieldVal); }
				when 'lbPortefeuilleContrat' { acc.LB_Portefeuille_contrat__c = fieldVal; }
				// AB: 4 New code lines added here 
				when 'idFoyer' {acc.FoyerId__c = String.isEmpty(fieldVal)?acc.FoyerId__c:Double.valueOf(fieldVal); }
				when 'lbFoyer' {acc.FoyerLabel__c = String.isEmpty(fieldVal)?acc.FoyerLabel__c:fieldVal; }
				when 'dateDebut' {acc.StartDate__c = String.isEmpty(fieldVal)?acc.StartDate__c:Date.valueOf(fieldVal); }
				when 'dateFin' {acc.EndDate__c = String.isEmpty(fieldVal)?acc.EndDate__c:Date.valueOf(fieldVal); }
                when else { System.debug('input field not managed: ' + fieldName + ' with value: ' + fieldVal);
				}
			}
            
		}
	}
}