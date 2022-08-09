@isTest
private class SM_AP46_XdataImportAccount_TEST {
	
	// Test where everything is ok
    @isTest static void testImportAccounts() {
		List<Map<String,String>> listAccounts = new List<Map<String,String>>();
		for(Integer i = 0 ; i<100 ; i++){
			Map<String,String> accountToInsert = new Map<String,String>{
				'name'=>'account '+i, 
				'noCompteContrat'=>'00000000'+i,
				'idPortefeuilleContrat'=>'00000'+i,
				'idBatiment'=>'1'+i,
				'idLocal'=>'2'+i,
				'lbPortefeuilleContrat'=>'123'+i
			};
			listAccounts.add(accountToInsert);
		}
		String res = SM_AP46_XdataImportAccount.importAccounts(listAccounts);
        integer numok = Database.countQuery('select count() from account');
        system.debug('Number of inserted accounts: ' + numok);
		System.assert((numok==100),'Error inserting 100 accounts, found: ' + numok);

	}
	
	// Test where some import will fail
    @isTest static void testImportAccountsWithKo() {
		List<Map<String,String>> listAccounts = new List<Map<String,String>>();
		for(Integer i = 0 ; i<100 ; i++){
			Map<String,String> accountToInsert = new Map<String,String>{
				'name'=>'account '+i, 
				'noCompteContrat'=>'00000000'+i,
				'idPortefeuilleContrat'=>'00000'+i,
				'idBatiment'=>'1'+i,
				'idLocal'=>'2'+i,
				'lbPortefeuilleContrat'=>'123'+i
			};
            if(math.mod(i,10)==0) accountToInsert.remove('noCompteContrat');
			listAccounts.add(accountToInsert);
		}
		String res = SM_AP46_XdataImportAccount.importAccounts(listAccounts);		
        integer numok = Database.countQuery('select count() from account');
        system.debug('Number of inserted accounts: ' + numok);
		System.assert((numok==90),'Error inserting 100 accounts with 10 incorrect account datas, not found 90 but : ' + numok);
	}
	
	
}