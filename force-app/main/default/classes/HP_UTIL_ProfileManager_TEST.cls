/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   22-03-2020   Antoine Latour   Initial Version
**/
@IsTest
public class HP_UTIL_ProfileManager_TEST {

    @testSetup static void dataSetup(){
    	HP_UTIL_SmartFactory.insertUserHP();
    }
    
     @isTest
	 static void isHappeProfile(){
		System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
        	Test.startTest();
            Boolean result = HP_UTIL_ProfileManager.isHappeProfile();
            Test.stopTest();
            
            System.assert(result);
        }
     }
       
    @isTest
	static void getCurrentUserProfileName(){
		System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
        	Test.startTest();
            String result = HP_UTIL_ProfileManager.getCurrentUserProfileName();
            Test.stopTest();
            
            System.assert(result == 'HP_SystemAdmin');
        }
    }
    
    @isTest
    static void getOwnerProfile() {
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
        	Test.startTest();
            String result = HP_UTIL_ProfileManager.getOwnerProfile(UserInfo.getUserId());
            Test.stopTest();
            
            System.assert(result == 'HP_SystemAdmin');
        }
    }
}