global class SM_BAT04_KnowledgeSyncDataCategorySch implements Schedulable {
    global void execute(SchedulableContext sc){
        Database.executeBatch(new SM_BAT04_KnowledgeSyncDataCategory(),200);
    }
}