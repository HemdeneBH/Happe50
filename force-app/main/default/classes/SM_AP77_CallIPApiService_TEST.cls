@isTest
private class SM_AP77_CallIPApiService_TEST
{
    /*
*	@description : Appel depuis la vue 360
*/
    @isTest(SeeAllData = false)
    public static void CallIP()
    {
        Map < Object, Object > inputMapObject = new Map < Object, Object >();	
        Map < String, Object > inputMap = new Map < String, Object >();		
        Map < String, Object > outMap = new Map < String, Object >();
        inputMap.put('idsPortefeuilleContrat','251760');
        String nameIP = 'TEST_IP';
        
        outMap = SM_AP77_CallIPApiService.callIP(inputMap, nameIP);
        Account account = new Account();
        account.Name = 'Test Account';
        insert account; 
        
        List<Account> listAccount = new List<Account>();
        listAccount.add(account);
        
        Map<Account, Account> mapAccount = new Map<Account, Account>();
        mapAccount.put(account, account);
        Map<Account, Map<Account, Account>> mapAccountofMap = new Map<Account, Map<Account, Account>>();
        mapAccountofMap.put(account, mapAccount);
        
        inputMapObject.put(mapAccount, mapAccountofMap);
        inputMap.put('testInput', listAccount);
        inputMap.put('inputMap', inputMapObject);
        
        Map<String, Object> outputMap = SM_AP77_CallIPApiService.transformComplexInput(inputMap);

    }
}