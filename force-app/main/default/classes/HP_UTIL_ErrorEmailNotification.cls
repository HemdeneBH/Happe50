/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 

 * @last modified on  : 10-27-2020

 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   10-22-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
global class HP_UTIL_ErrorEmailNotification {
    global DateTime now {get;set;}
    global DateTime dateLimit {get;set;}
    
    global List<InfoNotifactionWrapper> outApiError{get;set;}
    global List<InfoNotifactionWrapper> inApiError{get;set;}
    global List<InfoNotifactionWrapper> techError{get;set;}
    global List<LoginHistoryWrapper> logHist {get;set;}
    global Case lastEmailToCaseCreated {get;set;}
    global String urlApp{get;set;}
    global  HP_UTIL_ErrorEmailNotification() {
        lastEmailToCaseCreated = null;
        List<String> codeStatusErrorList = HP_UTIL_MetadataManager.getConfigByKey('HP_Error_Status_Code').split(';');
        Set<Decimal> codeErrorList = new set<Decimal>();
        for(String item : codeStatusErrorList) {
            codeErrorList.add(Decimal.valueOf(item));
        }
        Map<Id, User> userList = new Map<Id, User>([select Id, Name, profile.name from user where profile.name like 'HP_%']);
        now = System.now();
        dateLimit = now.addHours(- Integer.valueOf(HP_UTIL_MetadataManager.getConfigByKey('HP_Notification_Hour')));
        
        List<HP_LOG_CALLOUT__b> soOutApiError = [select Date__c,Call_Time_Execution__c, Endpoint__c, Method__c, Status__c, User_Id__c from HP_LOG_CALLOUT__b
                                   where Date__c >= :dateLimit];
        outApiError = new List<InfoNotifactionWrapper>();
        for(HP_LOG_CALLOUT__b item : soOutApiError) {
            User us = userList.get(item.User_Id__c);
            if(codeErrorList.contains(((integer)item.status__c)) && us != null) {
                outApiError.add( new InfoNotifactionWrapper(item, us.Name));
            }
            
        }
        List<HP_LOG_WS__c> soInApiError = [select Date__c,Call_Time_Execution__c, Endpoint__c, Method__c, Status__c, User_Id__c from HP_LOG_WS__c
                                   where Date__c >= :dateLimit];
        
        inApiError = new List<InfoNotifactionWrapper>();
        for(HP_LOG_WS__c item : soInApiError) {
            User us = userList.get(item.User_Id__c);
            if(codeErrorList.contains(item.status__c) && us != null) {
            inApiError.add( new InfoNotifactionWrapper(item, us.Name));
            }
        }
        List<HP_TECH_LOG__c> soTechError = [select Metadata__c,Phase__c, Project__c, Status__c, Type__c, Createddate from HP_TECH_LOG__c
                                   where Createddate >= :dateLimit];

		techError = new List<InfoNotifactionWrapper>();
        for(HP_TECH_LOG__c item : soTechError) {
            techError.add( new InfoNotifactionWrapper(item));
        }        

        List<LoginHistory> allLHList = [select LoginTime, Status, UserId
         from LoginHistory where LoginTime >= :dateLimit and LoginType ='Application' ];
         logHist = new List<LoginHistoryWrapper>();
         
         for(LoginHistory item : allLHList) {
             User us = userList.get(item.UserId);
            if(item.Status != 'Success' && item.Status != 'Failed: Computer activation required' && us != null) {
                logHist.add(new LoginHistoryWrapper(item, us));
            } 
         }
         try {
            lastEmailToCaseCreated = [select Id, Createddate, createdby.Name from case 
            where recordtype.developerName = 'HP_Mail' and createdby.Alias = 'EToC' order by createddate desc limit 1];
         }catch(Exception e){}
         urlApp = URL.getSalesforceBaseUrl().getHost() + '/lightning/app/' + [select  DurableId from AppDefinition where DeveloperName = 'HP_Tech'].DurableId;
    }
    
    public Double offset{get{
        TimeZone tz = UserInfo.getTimeZone();
        //Milliseconds to Day
        return tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
    }}
    
    global class LoginHistoryWrapper {
        global DateTime loginTime{get;set;}
        global String statusLogin{get;set;}
        global String userName{get;set;}
        global String profile{get;set;}
        global LoginHistoryWrapper(LoginHistory obj, User us) {
            loginTime = obj.LoginTime;
            statusLogin = obj.Status;
            userName = us.Name;
            profile = us.profile.name;
        }
    }
    global class InfoNotifactionWrapper {
        global DateTime errorDate{get;set;}
        global Decimal status{get;set;}
        global String method{get;set;}
        global String statusCH{get;set;}

        global String name{get;set;}

        global Decimal executionTime{get;set;}
        global String endPoint{get;set;}
        global String project{get;set;}
        global String metadata{get;set;}
        global String notificationType{get;set;}
        global String phase{get;set;}
        
        global InfoNotifactionWrapper(HP_LOG_CALLOUT__b obj, String username) {
            errorDate = obj.Date__c;
            executionTime = obj.Call_Time_Execution__c;
            endPoint = obj.Endpoint__c;
            method = obj.Method__c;
            status = obj.Status__c;

            name = username;

        }
        
        global InfoNotifactionWrapper(HP_LOG_WS__c obj, String username) {
            errorDate = obj.Date__c;
            executionTime = obj.Call_Time_Execution__c;
            endPoint = obj.Endpoint__c;
            method = obj.Method__c;
            status = obj.Status__c;

            name = username;

        }
        
        global InfoNotifactionWrapper(HP_TECH_LOG__c obj) {
            statusCH = obj.Status__c;
            project = obj.Project__c;
            metadata = obj.Metadata__c;
            notificationType = obj.Type__c;
            phase = obj.Phase__c;
            errorDate = obj.CreatedDate;
        }
    }
}