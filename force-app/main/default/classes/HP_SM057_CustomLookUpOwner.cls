/**
 * @description       : 
 * @author            : Slimene Belhaj Ali
 * @group             : 
 * @last modified on  : 03-19-2021
 * @last modified by  : Slimene Belhaj Ali
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   03-19-2021   Slimene Belhaj Ali   Initial Version
**/
public with sharing class HP_SM057_CustomLookUpOwner {
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = '%' + searchKeyWord + '%';
        
        List < sObject > returnList = new List < sObject > ();
        String whereClause = '';
        if(ObjectName != 'User') {
            whereClause = ' and Type = \'Queue\' and developername like \'%HP%\' ';
        } else {
            whereClause = ' and  Profile.name like \'%HP%\' ';
        }
        String sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey '+ whereClause + ' order by createdDate DESC limit 5';
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
}