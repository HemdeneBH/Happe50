@isTest
private class SM_AP48_XdataImportRole_TEST {
    
    @isTest static void testImportRoles() {

        List<Map<String,String>> listRoles = new List<Map<String,String>>();
        Date StartDate=Date.today();
        Date EndDate=StartDate+5;
        String SD=String.valueOf(StartDate);
        String ED=String.valueOf(EndDate);
        
        


        for(Integer i = 0 ; i<100 ; i++){
            Map<String,String> roleToInsert = new Map<String,String>();
            if(math.mod(i,2)==0) roleToInsert.put('accountNo','100'+i);
            if(math.mod(i,5)==0) roleToInsert.put('contactNo','100'+i);
            if(math.mod(i,3)==0) { roleToInsert.put('roles','Contractant' + i); }
            else {roleToInsert.put('roles','Contractant'); }
            roleToInsert.put('StartDate',SD);
            roleToInsert.put('EndDate',ED);
            roleToInsert.put('IsActive','true');

            
            listRoles.add(roleToInsert);
            
        }

        String res = SM_AP48_XdataImportRole.importRoles(listRoles);


        
        System.assertEquals(res,'ok');

    }
    
}