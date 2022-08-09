@isTest
private class SM_AP46_XdataImportAccount_TEST {
    
    // Test where everything is ok
    @isTest static void testImportAccounts() {
        List<Map<String,String>> listAccounts = new List<Map<String,String>>();
        for(Integer i = 0 ; i<100 ; i++){
           final string thenum = '0' + String.valueOf(i);
            Map<String,String> accountToInsert = new Map<String,String>{
                'name'=> thenum, 
                'noCompteContrat'=> thenum,
                'idPortefeuilleContrat'=> thenum,
                'idBatiment'=> thenum,
                'idLocal'=> thenum,
                'lbPortefeuilleContrat'=> thenum,
                'FoyerId' => thenum,
                'FoyerLbbel'=> thenum,
                'StartDate' => thenum,
                'EndDate' => thenum
            };
            listAccounts.add(accountToInsert);
        }
        String res = SM_AP46_XdataImportAccount.importAccounts(listAccounts);
        integer numok = Database.countQuery('select count() from account');
        system.debug('Number of inserted accounts: ' + numok);
        // one with idlocal = 0
        System.assert((numok==99),'Error inserting 100 accounts, found: ' + numok);

    }
    
    
        // Test where everything is ok
    @isTest static void testImportAccountsWithUpdates() {
        //First insert 100 accounts
        List<Map<String,String>> listAccounts = new List<Map<String,String>>();
        for(Integer i = 1 ; i<101 ; i++){
           final string thenum = '0' + String.valueOf(i);
            Map<String,String> accountToInsert = new Map<String,String>{
                'name'=> thenum, 
                'noCompteContrat'=> thenum,
                'idPortefeuilleContrat'=> thenum,
                'idBatiment'=> thenum,
                'idLocal'=> thenum,
                'lbPortefeuilleContrat'=> thenum,
                'FoyerId' => thenum,
                'FoyerLbbel'=> thenum,
                'StartDate' => thenum,
                'EndDate' => thenum
            };
            listAccounts.add(accountToInsert);
        }
        String res = SM_AP46_XdataImportAccount.importAccounts(listAccounts);

        // now update 50 and create 50
        List<Map<String,String>> listAccounts2 = new List<Map<String,String>>();
        for(Integer i = 51 ; i<151 ; i++){
           final string thenum = '0' + String.valueOf(i);
            Map<String,String> accountToInsert = new Map<String,String>{
                'name'=> thenum, 
                'noCompteContrat'=> thenum,
                'idPortefeuilleContrat'=> thenum,
                'idBatiment'=> thenum,
                'idLocal'=> thenum,
                'lbPortefeuilleContrat'=> thenum,
                'FoyerId' => thenum,
                'FoyerLbbel'=> thenum,
                'StartDate' => thenum,
                'EndDate' => thenum
            
            };
            listAccounts2.add(accountToInsert);
        }
        String res2 = SM_AP46_XdataImportAccount.importAccounts(listAccounts2);

        integer numok = Database.countQuery('select count() from account');
        system.debug('Number of inserted accounts: ' + numok);
        System.assert((numok==150),'Error inserting and updating 150 accounts, found: ' + numok);
    }
    
    // Test where everything is ok
    @isTest static void testImportAccountsWithMultiUpdates() {
        //First insert 10 accounts
        List<Map<String,String>> listAccounts = new List<Map<String,String>>();
        for(Integer i = 0 ; i<10 ; i++){
           final string thenum = '1' + String.valueOf(i);
            Map<String,String> accountToInsert = new Map<String,String>{
                'name'=> thenum, 
                'noCompteContrat'=> thenum,
                'idPortefeuilleContrat'=> thenum,
                'idBatiment'=> thenum,
                'idLocal'=> thenum,
                'lbPortefeuilleContrat'=> thenum,
                'FoyerId' => thenum,
                'FoyerLbbel'=> thenum,
                'StartDate' => thenum,
                'EndDate' => thenum
            };
            listAccounts.add(accountToInsert);
        }
        String res = SM_AP46_XdataImportAccount.importAccounts(listAccounts);

        // now update 5 more times with same data
        for(Integer i = 0 ; i<5 ; i++){
            String res2 = SM_AP46_XdataImportAccount.importAccounts(listAccounts);
        }

        integer numok = Database.countQuery('select count() from account');
        system.debug('Number of inserted accounts: ' + numok);
        System.assert((numok==10),'Error inserting and updating 10 accounts, found: ' + numok);

    }
    
    
    // Test where some import will fail
    @isTest static void testImportAccountsWithKo() {
        List<Map<String,String>> listAccounts = new List<Map<String,String>>();
        for(Integer i = 0 ; i<100 ; i++){
           final string thenum = String.valueOf(i);
            Map<String,String> accountToInsert = new Map<String,String>{
                'name'=>'account '+ thenum, 
                'noCompteContrat'=>'00000000'+ thenum,
                'idPortefeuilleContrat'=>'00000'+thenum,
                'idBatiment'=>'1'+thenum,
                'idLocal'=>'2'+thenum,
                'lbPortefeuilleContrat'=>'123'+thenum,
                'FoyerId' => thenum,
                'FoyerLbbel'=> thenum,
                'StartDate' => thenum,
                'EndDate' => thenum
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