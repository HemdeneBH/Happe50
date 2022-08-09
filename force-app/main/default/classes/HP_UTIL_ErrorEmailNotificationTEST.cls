@isTest
public class HP_UTIL_ErrorEmailNotificationTEST {
	@testSetup static void dataSetup(){
		
        System.runAs(HP_UTIL_SmartFactory.insertUserHP()){
            HP_LOG_WS__c pb = new HP_LOG_WS__c();
                pb.Body_Request__c = 'xx';
                pb.Endpoint__c =  'xx';
                pb.User_Id__c = UserInfo.getUserId();
                pb.Method__c = 'xx';
                pb.Date__c = DateTime.Now();
                pb.Call_Time_Execution__c = 15;
            	pb.Status__c = 401;
                pb.Transaction_Id__c = 'xxx';
            insert pb;
           
            HP_TECH_LOG__c tech = new HP_TECH_LOG__c();
                tech.EmailSubject__c = 'xx';
                tech.Phase__c = 'xx';
                tech.Project__c = 'Happe';
                tech.Status__c = 'Nouveau';
                tech.Type__c = 'xx';
    
            insert tech;
        }
    }

    @isTest static void loadEmailContent_TEST(){
    
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Test.startTest();
            new HP_UTIL_ErrorEmailNotification();
    
            User us = [select Id, Name, Profile.Name from user where id = :UserInfo.getUserId()];
            new HP_UTIL_ErrorEmailNotification.LoginHistoryWrapper (new LoginHistory(), us);
            new HP_UTIL_ErrorEmailNotification.InfoNotifactionWrapper (new HP_LOG_CALLOUT__b(), '');
    
            Test.stopTest();
        }
    }
    
    @isTest static void scheduleEmailContent_TEST(){
    
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Test.startTest();
            system.schedule('HP_SCH008_EmailErrorNotificationTest','0 0 23 * * ?', new HP_SCH008_EmailErrorNotification());
            Test.stopTest();
        }
    }
}