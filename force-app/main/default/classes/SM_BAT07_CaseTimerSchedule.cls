public without sharing class SM_BAT07_CaseTimerSchedule implements Schedulable {
    public void execute(SchedulableContext sc) {
        database.executebatch(new SM_BAT07_CaseTimer(),200); 
	}
}