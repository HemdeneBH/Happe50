/**
 * @File Name          : HP_UTIL_LogConsoleControllerTest.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 24/04/2020 à 11:20:47
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    24/04/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
@IsTest
public class HP_UTIL_LogConsoleControllerTest {
    @testSetup 
    static void initData() {
        System.runAs(HP_UTIL_SmartFactory.insertUserHP()){    
            HP_LOG_WS__c log = new HP_LOG_WS__c();

            log.Endpoint__c =  'xx';
            log.Body_Request__c = 'xx';
            
            log.Status__c = 200;
            log.Body_Response__c = 'xx';          
            log.User_Id__c = UserInfo.getUserId();            
            log.Date__c = DateTime.Now();
            log.Call_Time_Execution__c = 15;
            log.Transaction_Id__c = 'xxx';
            insert log;      
        }
		
    }
 	@isTest
	static void logSearchTest() {
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            HP_LOG_CALLOUT__b pb = new HP_LOG_CALLOUT__b();
            pb.Body_Request__c = 'xx';
            pb.Endpoint__c =  'xx';
            pb.User_Id__c = UserInfo.getUserId();
            pb.Method__c = 'xx';
            pb.Date__c = DateTime.Now();
            pb.Call_Time_Execution__c = 15;
            pb.Key_Row__c = 'K022';
            pb.Transaction_Id__c = 'xxx';
            Test.startTest();
            HP_UTIL_LogConsoleController.LogConsoleWrapper logW = new HP_UTIL_LogConsoleController.LogConsoleWrapper(pb);
            logW.compareTo(logW);
            List<HP_UTIL_LogConsoleController.LogConsoleWrapper> logList = HP_UTIL_LogConsoleController.loadLog(DateTime.Now().addHours(-1), DateTime.Now().addHours(1),
                                                null, null, null, null, 'INOUT', 'xxx');
            Test.stopTest();
            System.assertEquals(1, logList.size(), 'List de log doit avoir nu seul element');
        }
       
    }
}