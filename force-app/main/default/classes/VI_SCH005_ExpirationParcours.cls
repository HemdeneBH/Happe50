/*
*@Author: Clément Bouquin
*@Description: Scheduler qui relance chaque jour la misa à jour du status des Parcours et le status des Cases et leurs sous status si l'enveloppe a été envoyé il y aplus de 10 jour et que sont status n'est pas Signed
*@CreatedDate: 06/07/2021
*@LastModified: 06/07/2021
*/

global class VI_SCH005_ExpirationParcours implements schedulable{

    // VI_SCH005_ExpirationParcours schExpirationParcours = new VI_SCH005_ExpirationParcours();
	// String sch = '0 0 1 * * ?';	// Class runs every day at 1 AM.
	// String jobID = system.schedule('Mise à jour du statut du Parcours à \'Expiré\' ainsi que le status du Case à \'Pré-clôturé\' et son sous-statut à \'Abandon\' Si le status de l enveloppe n est pas \'Signed\' 10 jours après son envoie', sch, schExpirationParcours);
    
    global void execute(SchedulableContext sc){
        VI_BAT005_ExpirationParcours.execute();
    }
    
}