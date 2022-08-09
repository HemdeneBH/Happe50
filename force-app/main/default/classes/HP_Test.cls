global class HP_Test implements Database.Batchable<SObject> {
     
    global Database.QueryLocator start(Database.BatchableContext batchableContext){
		return Database.getQueryLocator([select Id from Prestation_distributeur__c limit 1]);	
	}

	public static void execute(){
		HP_Test b = new HP_Test();
		Database.executeBatch(b, 1);
	}
    
    global void execute(Database.BatchableContext batchableContext, List<Prestation_distributeur__c> pList){
        Prestation_distributeur__c p = [select Id from Prestation_distributeur__c where Id ='a4Q1l0000004xHSaaa'];
    }    
    
    global void finish(Database.BatchableContext bc) {
	}
}