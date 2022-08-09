public class SM_BAT02_CaseAbsenceRetourDistSchedule implements Schedulable {
    public void execute(SchedulableContext sc) {
        database.executebatch(new SM_BAT02_CaseAbsenceRetourDist(),200);
	}
}