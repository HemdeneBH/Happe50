@isTest
private class SM_SM102_RoleImport_TEST {
   
    public static SM_AP45_XdataImportUtils xiu = new SM_AP45_XdataImportUtils('xdata', 'AccountContactRelation');
    
    //test data setup
    @testSetup static void  testSetupData() {
        List<Account> lstAccount = new List<Account>();
        lstAccount.add(new Account(No_Compte_contrat__c = '0001',Name='acc1'));
        lstAccount.add(new Account(No_Compte_contrat__c = '0003',Name='acc2'));
        Database.insert(lstAccount);      
    }
    
    // Test AccountContactRelation's in Sync's case
    @isTest 
    static void testSyncImportRoles(){
        List<Map<String,String>> listRoles = new List<Map<String,String>>(); 
        System.debug('DB********************'+Database.countQuery('select count() from AccountContactRelation'));
        for(Integer i = 0 ; i<10 ; i++){
            Map<String,String> roleToInsert = new Map<String,String>();
            if(math.mod(i,2)==0) roleToInsert.put('accountNo','000'+i);
            if(math.mod(i,5)==0) roleToInsert.put('contactNo','100'+i);
            if(math.mod(i,3)==0) { roleToInsert.put('roles','Contractant' + i);}
            if(math.mod(i,3)==0) roleToInsert.put('active','true');
            if(math.mod(i,4)==0) roleToInsert.put('startDate','2022-02-23');

            if (math.mod(i,7)==0){
                roleToInsert.put('endDate','2022-02-23');
            } else {
                roleToInsert.put('roles','Contractant'); 
            }
            
            listRoles.add(roleToInsert);
        }

        String res = SM_SM102_RoleImport.importRoles(listRoles);
    }

    // Test AccountContactRelation's Import in async's case
    @isTest 
    static void testAsyncImportRoles() {
        
        List<Map<String,String>> listRoles = new List<Map<String,String>>(); 
        try{  
            for(Integer i = 1 ; i<100 ; i++){
                Map<String,String> roleToInsert = new Map<String,String>();
                roleToInsert.put('','');
                roleToInsert.put('contactNo','000'+i);
                roleToInsert.put('roles','Contractant'); 
                roleToInsert.put('active','true'); 
                roleToInsert.put('endDate','2022-02-23'); 
                roleToInsert.put('startDate','2022-02-23'); 
                
                listRoles.add(roleToInsert);
            }
        
            String res = SM_SM102_RoleImport.importRoles(listRoles);
        } catch (Exception exp){
            system.assert(false, 'Exceptions should be handled by the method');
        }      
    }

    // Test  AccountContactRelation's Import in ko case
    @isTest 
    static void testImportAccountContactRelationsWithKo() {    
        List<Map<String,String>> listRoles = new List<Map<String,String>>();   
        
        for(Integer i = 0 ; i<100 ; i++){
            Map<String,String> roleToInsert = new Map<String,String>();
            if(math.mod(i,2)==0) roleToInsert.put('accountNo','');
            if(math.mod(i,5)==0) roleToInsert.put('contactNo','100'+i);
            if(math.mod(i,3)==0) { 
                roleToInsert.put('roles','Contractant' + i); 
            } else {
                roleToInsert.put('roles','Contractant'); 
            }

            if(math.mod(i,10)==0) roleToInsert.remove('rolekey');
            
            listRoles.add(roleToInsert);
        }

        String res = SM_SM102_RoleImport.importRoles(listRoles);      
    }
}