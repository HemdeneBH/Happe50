/*
*@Auhtor: Paul Ghoussoub
*@Description: Scheduler qui relance les mandats chaque jour
*@CreatedDate: 16/03/2021
*/
global class VI_SCH001_RelanceMandat implements schedulable{
     /*
VI_SCH001_RelanceMandat schRelanceMandat = new VI_SCH001_RelanceMandat();
String sch = '0 0 19 * * ? *';
String jobID = System.schedule('Demarrer Relance Mandat', sch, schRelanceMandat);
*/
    global void execute(SchedulableContext sc){
        VI_BAT001_RelanceMandat.execute();
    }
}