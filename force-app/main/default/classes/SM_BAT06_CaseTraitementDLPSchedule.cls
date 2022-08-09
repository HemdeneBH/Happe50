/**
 * @description       : Schedulable class that invokes The batch SM_BAT06_CaseTraitementDLP
 * @author            : FT2-AE
 * @group             : SMILE FT2
 * @last modified on  : 02-28-2022
 * @last modified by  : FT2-AE
**/
public with sharing class SM_BAT06_CaseTraitementDLPSchedule implements Schedulable {
    public void execute(SchedulableContext sc) {
        database.executebatch(new SM_BAT06_CaseTraitementDLP(),1);
	}
}