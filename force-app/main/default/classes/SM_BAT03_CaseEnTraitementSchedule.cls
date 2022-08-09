public class SM_BAT03_CaseEnTraitementSchedule implements Schedulable {
    public void execute(SchedulableContext sc) {
        database.executebatch(new SM_BAT03_CaseEnTraitement(),200);
	}

}