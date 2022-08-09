public with sharing class SM_AP81_AllowCreateDP {
    /*
* @Author: Amine Deghais ~ amine.deghais@external.engie.com
* @Date: 02/06/2020
* @Description: check if user is allowed to create DP
*/
    @AuraEnabled(cacheable=true)
     public static Boolean checkAllowCreateDP() {    
        return FeatureManagement.checkPermission('SM_Allow_Create_DP');
        
    }     
}