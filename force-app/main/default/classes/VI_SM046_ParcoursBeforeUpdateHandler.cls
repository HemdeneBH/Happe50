/*
*@Author: Clément Bouquin
*@Description: Mise à jour des champs parcours grâce au trigger Before
*@CreatedDate: 07/10/2021
*@LastModified: 07/10/2021
*/

public inherited sharing class VI_SM046_ParcoursBeforeUpdateHandler {
 
/*    
* @author Clément Bouquin
* @date 07/10/2021
* @description Mise à jour des champs parcours grâce au trigger Before
* @param parcourList, oldParcourMap
* @return void ( called from a trigger)
*/
    public static void ParcoursBeforeUpdate(List<VI_Parcours__c> parcourList, Map<ID,VI_Parcours__c> oldParcourMap) {
        System.debug('updateParcours: START with ' + parcourList.size() + ' parcour records');
        for (VI_Parcours__c parIter : parcourList) {
            if(oldParcourMap.get(parIter.Id).VI_Date_envoi_email__c != parIter.VI_Date_envoi_email__c){
                if (parIter.VI_ChoixParcours__c == 'CHF') {
                    List<VI_DonneesParcours__c> donneeParcours;
                    donneeParcours=[Select Id, VI_RelanceCPV1_J__c, VI_RelanceCPV2_J__c, VI_RelanceCPV3_J__c, VI_RelanceCPV4_J__c, VI_RelanceCPV5_J__c, VI_NomPartenaire__r.Name 
                                    From VI_DonneesParcours__c 
                                    Where VI_NomPartenaire__r.Name=:parIter.VI_PartenaireRelieAuParcours__c];
                    if (donneeParcours.size() > 0) {
                        system.debug('parIter.id :'+ parIter.Id);
                        if (donneeParcours[0].VI_RelanceCPV1_J__c != null){
  							parIter.VI_DateRelanceCPV1__c = parIter.VI_Date_envoi_email__c.adddays(donneeParcours[0].VI_RelanceCPV1_J__c.intValue());
                            system.debug('coucou paul');
                        }
                        if (donneeParcours[0].VI_RelanceCPV2_J__c != null){
  							parIter.VI_DateRelanceCPV2__c = parIter.VI_Date_envoi_email__c.adddays(donneeParcours[0].VI_RelanceCPV2_J__c.intValue());
                        }
                        if (donneeParcours[0].VI_RelanceCPV3_J__c != null){
  							parIter.VI_DateRelanceCPV3__c = parIter.VI_Date_envoi_email__c.adddays(donneeParcours[0].VI_RelanceCPV3_J__c.intValue());
                        }
                        if (donneeParcours[0].VI_RelanceCPV4_J__c != null){
  							parIter.VI_DateRelanceCPV4__c = parIter.VI_Date_envoi_email__c.adddays(donneeParcours[0].VI_RelanceCPV4_J__c.intValue());
                        }
                        if (donneeParcours[0].VI_RelanceCPV5_J__c != null){
  							parIter.VI_DateRelanceCPV5__c = parIter.VI_Date_envoi_email__c.adddays(donneeParcours[0].VI_RelanceCPV5_J__c.intValue());
                        }
                    }
                }
            }
            System.debug('parIter.VI_DateRelanceCPV1__c :' + parIter.VI_DateRelanceCPV1__c);
            System.debug('parIter.VI_DateRelanceCPV2__c :' + parIter.VI_DateRelanceCPV2__c);
            System.debug('parIter.VI_DateRelanceCPV3__c :' + parIter.VI_DateRelanceCPV3__c);
            System.debug('parIter.VI_DateRelanceCPV4__c :' + parIter.VI_DateRelanceCPV4__c);
            System.debug('parIter.VI_DateRelanceCPV5__c :' + parIter.VI_DateRelanceCPV5__c);
        }
        System.debug('update Parcours data : END');  
    }
}