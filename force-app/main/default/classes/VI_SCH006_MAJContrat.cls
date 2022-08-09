/*
*@Author: Paul Ghoussoub
*@Description: Scheduler du batch VI_BAT006_MAJContrat
*@CreatedDate: 04/04/2022
*/
global class VI_SCH006_MAJContrat  implements schedulable{
    
    // VI_SCH006_MAJContrat schExpirationParcours = new VI_SCH006_MAJContrat();
    // String sch = '0 0 1 * * ?';	// Class runs every day at 1 AM.
    // String jobID = system.schedule('[PARTNER CO] Mise à jour de l'idLocal de l'assurance facture associée au parcours qui n'en ont pas', sch, schExpirationParcours);
    
    global void execute(SchedulableContext sc){
        VI_BAT006_MAJContrat.execute();
    }
}