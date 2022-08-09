/** 
 * @description       : Batchable/Schedulable class that deletes all ReportOmniScript__c records (and cascade deletes ReportOSElement__c)
 * @author            : Patrick THAI
 * @group             : 
 * @last modified on  : 12-08-2020
 * @last modified by  : Patrick THAI
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   10-02-2020   Patrick THAI     Initial Version
**/

public with sharing class COE_BAT002_ReportOsDeletion implements Database.Batchable<SObject>, Schedulable {

    public Integer creationBatchSize = 0;
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    // Batchable methods
    //
    public Database.QueryLocator start(Database.BatchableContext batchableContext){
        return DataBase.getQueryLocator([SELECT Id FROM ReportOmniScript__c ]);	
    }

    public void execute(Database.BatchableContext batchableContext, List<ReportOmniScript__c > omniscripts ){
        if(omniscripts.size() > 0)
            delete omniscripts;
    }

    public void finish(Database.BatchableContext bc) {
        //if creationBatchSize is defined, generate Report OS again 
        if(creationBatchSize > 0)
            Database.executeBatch(new COE_BAT001_OSJson2Fields(), creationBatchSize);
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    // Schedulable methods
    //
    public void execute(SchedulableContext SC) {
        this.creationBatchSize = 5; 
        Database.executeBatch(this);
     }
}