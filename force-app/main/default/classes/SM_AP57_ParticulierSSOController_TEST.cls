@isTest
private class SM_AP57_ParticulierSSOController_TEST
{
	@isTest
	static void auth_TEST(){

		SM_Digsvc__c ds = new SM_Digsvc__c();
        ds.orgurl__c = 'https://test.my.salesforce.com';
        ds.striss__c = 'ClientSecret';
        ds.usrnamepostfix__c = 'digital.engie.com';
        ds.xdusr__c = UserInfo.getUserName();  
        ds.communityUrl__c = 'https://randomurl.my.salesforce.com';  
        ds.instanceType__c = 'test';   
        ds.communityName__c = 'digital';

        insert ds;


		String token = 'sJZxdmRMoxM/jzMmNx1MmxoWO8XvS07n1Ppj/MgFM/rJ2ldkNJvkpkLZaBMEUZlRW71ubLMSC2/Yk/sdG62DiFjUQ3WzqJG0hkn0eBZL2Jf4YPYIR8XU4ChAcneyS3iL1w+EkEimHmzWGIjCSHR8Jw==';
		// Correspond à refbp=0306502365&nomBP=ISOIRD&parcoursId=smileModificationRdvDistributeur&dateEnvoiEmail=1549882525000
		ApexPages.CurrentPage().getParameters().put('token', token);
		SM_AP57_ParticulierSSOController authCtrl = new SM_AP57_ParticulierSSOController();
		authCtrl.particulierAuth();
	}
}