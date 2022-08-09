/*******************************************************************************************************
* @description: 
* @date: 2019-06-06
* @author: OMAR
********************************************************************************************************/
@isTest
private class SM_AP70_Get_Image_Link_TEST
{
	@isTest
	static void getImageLink_TEST()
	{
		// Test 1 -  
		SM_AP70_Get_Image_Link imageLinkCtrl = new SM_AP70_Get_Image_Link();
        imageLinkCtrl.DocumentValue = '123456789';
          String orgId = UserInfo.getOrganizationId();
         String instanceName = [select InstanceName from Organization limit 1].InstanceName;
		imageLinkCtrl.getImageLink();
		System.assertEquals('https://c.'+instanceName+'.content.force.com/servlet/servlet.ImageServer?id=123456789&oid='+orgId, imageLinkCtrl.getImageLink());

	}
}