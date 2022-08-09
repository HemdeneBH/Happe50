/**
 * @File Name          : HP_BAT008_NettoyageLogCallOut.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 31/03/2020 à 13:29:31
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    31/03/2020   Mouhamadoune Coulibaly     Initial Version
**/
global  class HP_BAT008_NettoyageLogCallOut implements Database.batchable<HP_LOG_CALLOUT__b>, Database.RaisesPlatformEvents {
    DateTime nowDateTime = System.now();
    HP_Parameters__c param = [Select id,Cycle_Purge_Log__c from HP_Parameters__c];
    final Integer cyclepurge = (Integer)param.Cycle_Purge_Log__c;
    final DateTime periode = nowDateTime.addDays(- cyclepurge);
    List<HP_LOG_CALLOUT__b> listToDelete = null;
       
    global HP_BAT008_NettoyageLogCallOut() {
        listToDelete =[select Status__c, Date__c, Key_Row__c,User_Id__c from HP_LOG_CALLOUT__b where Date__c <= :periode LIMIT 40000];
    }
   
    global List<HP_LOG_CALLOUT__b> start(Database.batchableContext info){
        return  listToDelete;
    }    
    global void execute(Database.batchableContext info, List<HP_LOG_CALLOUT__b> scope){
        Database.deleteImmediate(scope);

    }    
    global void finish(Database.batchableContext info){  
        List<HP_LOG_CALLOUT__b> newListToDelete =[select Id from HP_LOG_CALLOUT__b where Date__c <= :periode LIMIT 1];
        if(newListToDelete.size() > 0) {
            Database.executeBatch(new HP_BAT008_NettoyageLogCallOut());
        }
    }
 }