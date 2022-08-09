/*
*@Auhtor: Paul Ghoussoub
*@Description: Scheduler qui relance les cpv chaque jour
*@CreatedDate: 30/03/2021
*/
global class VI_SCH002_RelanceCPV  implements schedulable{
    /*
VI_SCH002_RelanceCPV schRelanceCPV = new VI_SCH002_RelanceCPV();
String sch = '0 0 19 * * ? *';
String jobID = System.schedule('Demarrer Relance CPV', sch, schRelanceCPV);
*/
    global void execute(SchedulableContext sc){
        VI_BAT02_RelanceCPV.execute();
    }
}