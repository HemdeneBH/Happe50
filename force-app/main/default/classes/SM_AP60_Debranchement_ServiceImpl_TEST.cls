/*******************************************************************************************************
* @description: Appeler le service crypter Param pour le debranchement ( Developpement fait dans le  cadre de l'us SMIL-1734 )
* @date: 2019-04-02
* @author: Mickaël
********************************************************************************************************/
@isTest
private class SM_AP60_Debranchement_ServiceImpl_TEST
{
	@isTest
	static void crypterParam_TEST()
	{
		// Test 1 - Sans BP
		 
		SM_AP60_Debranchement_ServiceImpl cryptCtrl = new SM_AP60_Debranchement_ServiceImpl();
        cryptCtrl.ContactIdValue = '';
		cryptCtrl.getChaineCryptee();
		System.assertEquals('#', cryptCtrl.getChaineCryptee());

		// Test 2 - Avec BP
		cryptCtrl.ContactIdValue = '03090372200';
		cryptCtrl.getChaineCryptee();
		System.assertEquals(Label.SM_CL_Api_Debranchement_endpoint + '/modification-rdv-distributeur.html?token=13246578987894654321', cryptCtrl.getChaineCryptee());

        cryptCtrl.ContactIdValue = '03090372841';
		cryptCtrl.getChaineCryptee();
		System.assertEquals('#',cryptCtrl.getChaineCryptee());
	}
}