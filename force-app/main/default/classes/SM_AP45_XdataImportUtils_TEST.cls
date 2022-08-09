@isTest
public class SM_AP45_XdataImportUtils_TEST {

    @isTest static void testImportUtils() {
        final Schema.SObjectField accExtId = Account.Fields.No_Compte_contrat__c;
        SM_AP45_XdataImportUtils xiu = new SM_AP45_XdataImportUtils('xdata','Account');
        Id rectid = SM_AP45_XdataImportUtils.getRecTypeId(Account.sObjectType,'Consumer');
        System.assert(rectid!=null);
        
        xiu.logImportOk('oneobject');
        
        List<Account> accToWrite = new List<Account>();
		accToWrite.add(new Account(recordTypeId = rectid));
        accToWrite.add(new Account(name='oneaccount',recordTypeId = rectid));

        Database.SaveResult[] svList = Database.insert(accToWrite,false);
		System.assert(xiu.logBulkInsertUpdate(svList, accToWrite)==null);
        
        Database.UpsertResult[] srList = Database.upsert(accToWrite,accExtId, false);        
        System.assert(xiu.logBulkUpsert(srList, accToWrite)==null);
        
        System.assert(xiu.saveLogs()==null);
        
    }

}