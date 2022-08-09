@isTest
private class SM_SM101_AccountImport_TEST {

    // record type des  accounts smile
    static SM_AP45_XdataImportUtils xiu = new SM_AP45_XdataImportUtils('xdata', 'Account');
    static Id acRectid = SM_AP45_XdataImportUtils.getRecTypeId(Account.sObjectType, 'Consumer');
    
    @testSetup 
    static void dataCreation(){
        Account acc = new Account();
        acc.Name = 'EJ_ACCOUNT';
        acc.RecordTypeId = SM_AP45_XdataImportUtils.getRecTypeId(Account.sObjectType, 'Consumer');
        acc.No_Compte_contrat__c = '0000001';
        acc.FoyerId__c=0001;
        acc.FoyerLabel__c='00001';
        acc.StartDate__c=Date.newInstance(2022,03,04);
        acc.EndDate__c=Date.newInstance(2022,03,04);
        insert acc;
    }
    
    // Test Account's in Sync's case
    @isTest 
    static void testSyncImportAccounts() {
        List<Map<String,String>> listAccounts = new List<Map<String,String>>();
        System.debug('DB********************'+Database.countQuery('select count() from account'));
        for(Integer i = 0 ; i<10 ; i++){
            Map<String,String> accountToInsert = new Map<String,String>{
                'name'=>'account '+i,
                    'noCompteContrat'=>'000000'+i,
                    'idPortefeuilleContrat'=>'00000'+i,
                    'idBatiment'=>'1'+i,
                    'idLocal'=>'2'+i,
                    'lbPortefeuilleContrat'=>'123'+i,
                    'idFoyer'=>'1234'+i,
                    'lbFoyer'=>'12345'+i,
                    'dateDebut'=>'2022-03-04',
                    'dateFin'=>'2022-03-04'
                    
                    };

            listAccounts.add(accountToInsert);
        }

        String res = SM_SM101_AccountImport.importAccounts(listAccounts);
        integer numok = Database.countQuery('select count() from account');
        system.debug('Number of inserted accounts in Sync Case: ' + numok);
        System.assert((numok==10),'Error inserting 10 accounts, found: ' + numok);
    }

    // Test account's Imports in async's case
    @isTest 
    static void testAsyncImportAccounts() {
        List<Map<String,String>> listAccounts = new List<Map<String,String>>();
        for(Integer i = 0 ; i<100 ; i++){
            Map<String,String> accountToInsert = new Map<String,String>{
                'name'=>'account '+i,
                    'noCompteContrat'=>'000'+i,
                    'idPortefeuilleContrat'=>'000'+i,
                    'idBatiment'=>'11'+i,
                    'idLocal'=>'22'+i,
                    'lbPortefeuilleContrat'=>'1234'+i,
                    'idFoyer'=>'12354'+i,
                    'lbFoyer'=>'12345'+i,
                    'dateDebut'=>'2022-03-04',
                    'dateFin'=>'2022-03-04'
                    
                    };
            listAccounts.add(accountToInsert);
        }

        String res = SM_SM101_AccountImport.importAccounts(listAccounts);
        integer numok = Database.countQuery('select count() from account');
        system.debug('Number of inserted accounts in Async Case: ' + numok);
        System.assert((numok==1),'Error inserting 100 accounts, found: ' + numok);
    }
    
    @isTest 
    static void tKOestImportAccountsKo(){
        List<Map<String,String>> Accounts = new List<Map<String,String>>();
        Map<String,String> validAccount = new Map<String,String>{
            'name'=>'account ',
                'noCompteContrat'=>'0000001',
                'idPortefeuilleContrat'=>'000001',
                'idBatiment'=>'1',
                'idLocal'=>'2',
                'lbPortefeuilleContrat'=>'123',
                'idFoyer'=>'1234',
                'lbFoyer'=>'12345',
                'dateDebut'=>'2022-03-04',
                'dateFin'=>'2022-03-04'
                };
        Map<String,String> AccountWhithNonoCompteContrat = new Map<String,String>{
            'name'=>'account 32 ',
                'noCompteContrat'=>'',
                'idPortefeuilleContrat'=>'000003',
                'idBatiment'=>'1',
                'idLocal'=>'2',
                'lbPortefeuilleContrat'=>'123',
                'idFoyer'=>'1234',
                'lbFoyer'=>'12345',
                'dateDebut'=>'2022-03-04',
                'dateFin'=>'2022-03-04'
                };
        Map<String,String> AccountWhithNoidLocal = new Map<String,String>{
            'name'=>'account ',
                'noCompteContrat'=>'0020104',
                'idPortefeuilleContrat'=>'00000',
                'idBatiment'=>'1',
                'idLocal'=>'',
                'lbPortefeuilleContrat'=>'123',
                'idFoyer'=>'1234',
                'lbFoyer'=>'12345',
                'dateDebut'=>'2022-03-04',
                'dateFin'=>'2022-03-04'
                };

        Accounts.add(validAccount);
        Accounts.add(AccountWhithNonoCompteContrat);
        Accounts.add(AccountWhithNoidLocal);
        SM_SM101_AccountImport.importAccounts(Accounts);
    }
    
    @isTest 
    static void tKOestImportAccountsKo2(){
        List<Map<String,String>> Accounts = new List<Map<String,String>>();
        Map<String,String> validAccount = new Map<String,String>{
            'name'=>'account ',
                'noCompteContrat'=>'0000001',
                'idPortefeuilleContrat'=>'000001',
                'idBatiment'=>'1',
                'idLocal'=>'2',
                'lbPortefeuilleContrat'=>'123',
                'idFoyer'=>'1234',
                'lbFoyer'=>'12345',
                'dateDebut'=>'2022-03-04',
                'dateFin'=>'2022-03-04'
                };
        Map<String,String> AccountWhithNonoCompteContrat = new Map<String,String>{
            'name'=>'account 32 ',
                'noCompteContrat'=>'',
                'idPortefeuilleContrat'=>'000003',
                'idBatiment'=>'1',
                'idLocal'=>'2',
                'lbPortefeuilleContrat'=>'123',
                'idFoyer'=>'1234',
                'lbFoyer'=>'12345',
                'dateDebut'=>'2022-03-04',
                'dateFin'=>'2022-03-04'
                };

        Map<String,String> AccountWhithNoidLocal = new Map<String,String>{
            'name'=>'account ',
                'noCompteContrat'=>'0020104',
                'idPortefeuilleContrat'=>'00000',
                'idBatiment'=>'1',
                'idLocal'=>'',
                'lbPortefeuilleContrat'=>'123',
                'idFoyer'=>'1234',
                'lbFoyer'=>'12345',
                'dateDebut'=>'2022-03-04',
                'dateFin'=>'2022-03-04'
                };

        Map<String,String> AccountWhithInvalidDate = new Map<String,String>{
            'name'=>'account ',
                'noCompteContrat'=>'0020104',
                'idPortefeuilleContrat'=>'00000',
                'idBatiment'=>'1',
                'idLocal'=>'',
                'lbPortefeuilleContrat'=>'123',
                'idFoyer'=>'1234',
                'lbFoyer'=>'12345',
                'dateDebut'=>'03/05/2022',
                'dateFin'=>'2022-03-04'
                };
        
                Accounts.add(validAccount);
        Accounts.add(AccountWhithNonoCompteContrat);
        Accounts.add(AccountWhithNoidLocal);
        Accounts.add(AccountWhithInvalidDate);
        SM_SM101_AccountImport.importAccounts(Accounts);
    }
    
    //tester with No Numéro Compte Contrat
    @isTest 
    static void TestNoIdContrat() {
        List<Map<String,String>> listAccounts = new List<Map<String,String>>();
        SM_SM101_AccountImport.ProcessAccountImport(listAccounts);
        Set<String>numsComptesContrat = new Set<String>();
        try{
            
            for(Integer i = 0 ; i<100 ; i++){
            
                Map<String,String> accountToInsert = new Map<String,String>{
                    'name'=>'accountKO '+i, 
                        'noCompteContrat'=>'0010'+i,
                        'idPortefeuilleContrat'=>'0100'+i,
                        'idBatiment'=>'101'+i,
                        'idLocal'=>'202'+i,
                        'lbPortefeuilleContrat'=>'12034'+i,
                        'idFoyer'=>'120354'+i,
                        'lbFoyer'=>'123045'+i,
                        'dateDebut'=>'2022-03-04',
                        'dateFin'=>'2022-03-04'
                        
                        };
                        
                accountToInsert.remove('noCompteContrat');
            
                listAccounts.add(accountToInsert);
            }

            SM_SM101_AccountImport.ProcessAccountImport(listAccounts);
        } catch (Exception exp){
            system.assert(false, 'Exceptions should be handled by the method');
        }    
    }
}