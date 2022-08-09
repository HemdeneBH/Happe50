/**
 * @description       : 
 * @author            : Ali AJELLAL
 * @last modified on  : 06-14-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

global with sharing class HP_BAT015_SouscriptionDedupOrderUpgrade implements Database.Batchable<String>, Database.AllowsCallouts, Schedulable, Database.RaisesPlatformEvents, HP_UTIL_BatchInterface{
   
    public static final Integer BATCH_CHUNK_SIZE = 10;
    public static Date dateQuery = System.now().date().addDays(-30);
    private Date  souscriptionDate;
    List<hp_souscription__c> listSouscription = null;


    public HP_BAT015_SouscriptionDedupOrderUpgrade() {
    
        listSouscription = [ select HP_TECH_FormulaEnergyPDLPCEField__c from hp_souscription__c  where  (DAY_ONLY(HP_Date_Origine__c ) >= :dateQuery)];
        souscriptionDate = dateQuery;

    }

    public HP_BAT015_SouscriptionDedupOrderUpgrade(Date selectedDate) {
        Datetime toFormatDate = selectedDate;
        souscriptionDate = selectedDate;
        String dateFormat = toFormatDate.formatGmt('yyyy-MM-dd');
        listSouscription = [ select HP_TECH_FormulaEnergyPDLPCEField__c from hp_souscription__c  where  (DAY_ONLY(HP_Date_Origine__c ) >= :selectedDate)];

        System.debug('listSouscription : ' + listSouscription);
    }

   
    public  List<String>  start(Database.BatchableContext bc) {
        List<String> fieldList = new List<String>();
        for (HP_souscription__c souscription :listSouscription) {
            fieldList.add(souscription.HP_TECH_FormulaEnergyPDLPCEField__c);
        } 
       return fieldList;
    }

    global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT015_SouscriptionDedupOrderUpgrade());
    }

    global static void execute(SchedulableContext sc){
        execute();
    }

    global static void execute(){
        HP_BAT015_SouscriptionDedupOrderUpgrade batchQsouscriptionDedupOrder = new HP_BAT015_SouscriptionDedupOrderUpgrade();
        Database.executeBatch(batchQsouscriptionDedupOrder, BATCH_CHUNK_SIZE);
    }

    global static void execute(Date selectedDate) {
        HP_BAT015_SouscriptionDedupOrderUpgrade batchQsouscriptionDedupOrder = new HP_BAT015_SouscriptionDedupOrderUpgrade(selectedDate);
        Database.executeBatch(batchQsouscriptionDedupOrder, BATCH_CHUNK_SIZE);
    }

    global void execute(Database.BatchableContext bc, List<String> fieldList) { 
        System.debug('*******list formulaFieldList:***'+fieldList);
        set<String> fieldSet = new Set<String>();
        for (String item :fieldList) {
            fieldSet.add(item);
        } 
        System.debug('*******list fieldSet:***'+fieldSet);

        List<hp_souscription__c> souscriptionsByFormula =  HP_EM005_Souscription.getSouscriptionsByFormula(fieldSet,souscriptionDate);
        System.debug('*******list souscriptionsByFormula:***'+souscriptionsByFormula.size());

        for (HP_souscription__c souscription : souscriptionsByFormula) {
            souscription.HP_TECH_DedupOrder__c = 1;
            
        }
       Database.update(souscriptionsByFormula);
       System.debug('*******list souscriptionsByFormula:***'+souscriptionsByFormula);

      HP_SM048_SouscriptionDedupOrderUpGrade.updateSouscriptionWithHighestStatus(souscriptionsByFormula, souscriptionDate);
    }


    global void finish(Database.BatchableContext bc){
        
    }

}