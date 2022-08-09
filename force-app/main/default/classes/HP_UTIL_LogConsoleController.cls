/**
 * @File Name          : HP_UTIL_LogConsoleController.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 17/04/2020 à 11:08:00
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    05/03/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
global without sharing class HP_UTIL_LogConsoleController {
    private static Map<Id, User> userMap = null;
   
    private static Integer LIMITE_NOMBRE_LOGS = Integer.valueOf(HP_UTIL_MetadataManager.getConfigByKey('HP_LIMITE_NOMBRE_LOG'));

    private static Map<Id, User> getUsermap() {
        if(userMap == null) {
            userMap = new Map<ID, User>([SELECT Id, username FROM User]);
        }

        return userMap;
    }
    @AuraEnabled(cacheable=true)
    public static List<LogConsoleWrapper> loadLog(DateTime startDate, DateTime endDate, String username, String endPoint, String method, String status, String direction, String keyWord) {
        System.debug('@@ startDate ' + startDate);
        System.debug('@@ endDate ' + endDate);
        System.debug('@@ username ' + username);
        System.debug('@@ endPoint ' + endPoint);
        System.debug('@@ method ' + method);
        System.debug('@@ status ' + status);
        System.debug('@@ direction ' + direction);
        System.debug('@@ keyWord ' + keyWord);
        List<LogConsoleWrapper> data = loadDataLog(startDate, endDate, direction);

        return filterDatalog(data, username, endPoint, method, status,keyWord);
    }

    private static List<LogConsoleWrapper> loadDataLog(DateTime startDate, DateTime endDate, String direction) {
        List<LogConsoleWrapper> result = new List<LogConsoleWrapper>();
        if(direction == 'OUT' || direction == 'INOUT') {
            List<HP_LOG_CALLOUT__b> intLogData = [select Status__c, Date__c,Method__c,  Endpoint__c, Call_Time_Execution__c, Body_Response__c, Transaction_Id__c,Body_Request__c, User_Id__c
                                                from HP_LOG_CALLOUT__b where Date__c >= :startDate and Date__c <= :endDate limit :LIMITE_NOMBRE_LOGS];
            for(HP_LOG_CALLOUT__b log : intLogData){
                result.add(new LogConsoleWrapper(log));
            }
        }
        
        if(direction == 'IN' || direction == 'INOUT') {
            List<HP_LOG_WS__c> outLogData = [select Status__c, Date__c,Method__c,  Endpoint__c, Call_Time_Execution__c, Body_Response__c, Transaction_Id__c,Body_Request__c, User_Id__c
                                                    from HP_LOG_WS__c where Date__c >= :startDate and Date__c <= :endDate limit :LIMITE_NOMBRE_LOGS];
            for(HP_LOG_WS__c log : outLogData){
                result.add(new LogConsoleWrapper(log));
            }
        }
        result.sort();
        System.debug('@@ size : ' + result.size());
        return result;
    }
    private static List<LogConsoleWrapper> filterDatalog(List<LogConsoleWrapper> data, String username, String endPoint, String method, String status, String keyWord) {
        List<LogConsoleWrapper> result = new List<LogConsoleWrapper>();
        List<String> transactionList = null;
        if(keyWord != null) {
            transactionList = keyWord.split(';');
        }

        for(LogConsoleWrapper log : data) {
            if(validateCondition(log, username, endPoint, method, status, transactionList)) {
                if(result.size() < LIMITE_NOMBRE_LOGS) {
                    result.add(log);
                }
                else {
                    break;
                }
            }
        }

        return result;
    }

    private static boolean validateCondition(LogConsoleWrapper log, String username, String endPoint, String method, String status, List<String> keyWord) {
        
        if((String.isBlank(username) || log.username == username) &&
         (String.isBlank(endPoint) || log.endPoint.contains(endPoint)) 
        && (String.isBlank(method) || method == log.method) && 
        (verifyKeyWork(keyWord, log.requestBody) || 
        verifyKeyWork(keyWord, log.responseBody)
        || verifyKeyWork(keyWord, log.idTransaction))
         && (String.isBlank(status) ||(status == 'OK' && (log.status < 300 || log.status == 422)) || (status == 'KO' && (log.status >= 300 && log.status != 422)))) {
            return true;
        }
        return false;  
    }

    public static boolean verifyKeyWork(List<String> dataList, String source) {
        System.debug('@@ ver ' + dataList + '  ' + source);
        if(dataList == null || dataList.size() == 0) {
            return true;
        }
        if(source == null) {
            return false;
        }
        for(String item : dataList) {
            if(source.contains(item)) {
                return true;
            }
        }

        return false;
    }

    global class LogConsoleWrapper implements Comparable{
        @AuraEnabled
        global String idTransaction;
        @AuraEnabled
        global DateTime dateCall;
        @AuraEnabled
        global String username;
        @AuraEnabled
        global Decimal status;
        @AuraEnabled
        global String method;
        @AuraEnabled
        global String endPoint;

        @AuraEnabled
        global String requestBody;
        @AuraEnabled
        global String responseBody;
        @AuraEnabled
        global Decimal timeExecution;
        @AuraEnabled
        global String direction;
        @AuraEnabled
        global String classCssError;
        @AuraEnabled
        global String classCssTime;
       
        public LogConsoleWrapper(HP_LOG_CALLOUT__b log) {
            idTransaction = log.Transaction_Id__c;
            dateCall = log.Date__c;
            username = HP_UTIL_LogConsoleController.getUsermap().get(log.User_Id__c).username.substringBefore('@');
            status = log.Status__c;
            method = log.Method__c;
            endPoint = log.Endpoint__c.replace('callout:HP_AuthAPIHour_INT', '');
            requestBody = log.Body_Request__c;
            responseBody = log.Body_Response__c;
            timeExecution = log.Call_Time_Execution__c;
            direction = 'OUT';
            if(status >= 300 && status != 422) {
                classCssError = 'error-log';
            } 

            if(timeExecution > 1000) {
                classCssTime = 'error-log';
            }
        }

        public LogConsoleWrapper(HP_LOG_WS__c log) {
            idTransaction = log.Transaction_Id__c;
            dateCall = log.Date__c;
            username = HP_UTIL_LogConsoleController.getUsermap().get(log.User_Id__c).username.substringBefore('@');
            status = log.Status__c;
            method = log.Method__c;
            endPoint = log.Endpoint__c.replace('callout:HP_AuthAPIHour_INT', '');
            requestBody = log.Body_Request__c;
            responseBody = log.Body_Response__c;
            timeExecution = log.Call_Time_Execution__c;
            direction = 'IN';
            if(status >= 300 && status != 422) {
                classCssError = 'error-log';
            }
            if(timeExecution > 1000) {
                classCssTime = 'error-log';
            }
        }

        public Integer compareTo(Object obj) {
            LogConsoleWrapper castObject = (LogConsoleWrapper)obj;
            if(dateCall.getTime() > castObject.dateCall.getTime()) {
                return 1;
            } else  if(dateCall.getTime() < castObject.dateCall.getTime()){
                return -1;
            }
            return 0;
        }
    }
}