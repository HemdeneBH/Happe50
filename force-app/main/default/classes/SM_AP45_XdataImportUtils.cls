global with sharing class SM_AP45_XdataImportUtils {

	// pour la tracabilite
	final String flux;
	final String objName;
	List<SyncEventLog__c> evlogs = new List<SyncEventLog__c>();

	public SM_AP45_XdataImportUtils(String streamname, String objn){
		flux = streamname;
        objName = objn;
	}
    
    global static ID getRecTypeId(Schema.sObjectType sobjt,String recType){
        ID rtid;
		Schema.RecordTypeInfo rtinf = sobjt.getDescribe().getRecordTypeInfosByDeveloperName().get(recType);
		if (rtinf != null) { rtid = rtinf.getRecordTypeId();}
        else {rtid = null;}
        return rtid;
    }

	// fonction de log d'un bulk upsert
	global void logBulkUpsert(List<Database.UpsertResult> dbrlts, List<sobject> sobjs){
		integer sizeres = dbrlts.size();
		Database.UpsertResult result;
		for(integer respos=0;respos<sizeres;respos+=1){
			result = dbrlts[respos];
            if (result.isSuccess()) { 
				//logImportOk(sobjs[respos].id);
			}
            else {
				logImportError(null,result.getErrors(), JSON.serialize(sobjs[respos]));
			}
		}
	}
		
	// fonction de log d'un bulk insert
	global void logBulkInsertUpdate(List<Database.SaveResult> dbrlts, List<sobject> sobjs){
		integer sizeres = dbrlts.size();
		Database.SaveResult result;
		for(integer respos=0;respos<sizeres;respos+=1){
			result = dbrlts[respos];
            if (result.isSuccess()) {
				//logImportOk(sobjs[respos].id);
			}
            else {
				logImportError(null,result.getErrors(), JSON.serialize(sobjs[respos]));
			}
		}
	}
   
	// fonction de log de l'import reussi
	global void logImportOk(String objid) {
		// TODO: seulement logguer si on est en debug
		/*
		SyncEventLog__c sel = new SyncEventLog__c (flux__c = flux + objName, name=objid);
		evlogs.add(sel);
		System.debug( Date.today() + ' flux ok: ' + flux + ' import de l object: ' + objName + ' id: ' + objid );
		*/
	}
	
	// Fonction de log d'une erreur pour l'import de donnees
	global void logImportError(String errMsg, List<Database.Error> errs,String inputData) {
		String strcause='';
        if(errs != null) { for (Database.Error err: errs) {strcause = strcause + err.getMessage() +' --- ';}}
		else { strcause = errMsg;}
		SyncEventLog__c sel = new SyncEventLog__c (flux__c = flux + objName, name=strcause, inputdat__c = inputData);
		evlogs.add(sel);
		System.debug( Date.today() + ' flux ko: ' + flux + ' import de l object: ' + objName + ' message: ' + strcause + ' donnees: ' + inputData);
	}

	global void saveLogs(){
		if(evlogs.isEmpty())
			return;
		Database.DMLOptions dmo = new Database.DMLOptions();
		dmo.allowFieldTruncation = true;
		dmo.optAllOrNone = true;
		Database.insert(evlogs,dmo);
	}
}