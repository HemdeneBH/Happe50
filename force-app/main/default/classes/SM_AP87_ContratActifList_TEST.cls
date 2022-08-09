@isTest
private class SM_AP87_ContratActifList_TEST
{
	/*
	*	@description : Appel depuis la vue 360
	*/
	@isTest(SeeAllData = false)
	public static void CallGetContratActif()
    {	
        Boolean outMap;
        outMap = SM_AP87_ContratActifList.getContractActif('E0004');
    }
}