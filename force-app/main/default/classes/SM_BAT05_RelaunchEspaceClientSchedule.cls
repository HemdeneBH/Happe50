/** 
 * @author            : Ahlam BENABBOU
 * @group             : SMILE FT4
 * @description       : Schedulable class that invokes The batch SM_BAT05_RelaunchEspaceClient
**/
public class SM_BAT05_RelaunchEspaceClientSchedule implements Schedulable {
	public void execute(SchedulableContext sc) {
        Integer scope = Integer.valueOf(System.Label.BAT05_Scope);
        database.executebatch(new SM_BAT05_RelaunchEspaceClient(),scope);
	}
}