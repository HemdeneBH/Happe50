/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   03-02-2021   Antoine Latour   Initial Version
**/

global class HP_SM053_UpdateOPS  implements CMN_OPSProcessingInterface {
                                       
                            
    public void processing(List<CMN_OPSinfo> OPSinfos){
        List < Prestation_distributeur__c > prestaDistribToUpdate = new List < Prestation_distributeur__c > ();
        List < HP_OpsEventLog__c > opsKO = new List < HP_OpsEventLog__c > ();
        updatePrestaDistribFields(OPSinfos, prestaDistribToUpdate, opsKO);
            
        if (!prestaDistribToUpdate.isEmpty() || !opsKO.isEmpty()) {
            Database.SaveResult[] srList  = HP_EM007_PrestationDistributeurManager.updatePrestationsDistributeur(prestaDistribToUpdate);                                                       
            try {
                traceLog(prestaDistribToUpdate,srList,opsKO);
                HP_SM033_PrestationFluxUpdate.updateOPSAndCase(prestaDistribToUpdate,OPSinfos);
            }
            catch(Exception e) {
                HP_TECH_LOG__c hpLogTech = HP_EM031_HPLogTech.buildHPLogTechFromGenericApexError('Happe', 'Nouveau',
                'HP_SM053_UpdateOPS', 'Mise à jour des Prestation Distributeur', e.getMessage());
                insert hpLogTech;
            }
        }  
    }

    public static void updatePrestaDistribFields(List <CMN_OPSinfo> ops, List < Prestation_distributeur__c > prestaDistribToUpdate,List < HP_OpsEventLog__c > opsKO) {
        Map < String, CMN_OPSinfo > ids_OPS = new Map < String, CMN_OPSinfo> ();
        for (CMN_OPSinfo opstemp: ops) {
            ids_OPS.put(opstemp.idAffaire, opstemp);
        }
  
        List < Prestation_distributeur__c > accs = HP_EM007_PrestationDistributeurManager.loadPrestationsDistributeurFromListIdAffaire(ids_OPS.keySet());
        
        if (accs == null || accs.isEmpty()) {
            return;
        }

        List<String> constantes = new List<String>{'HP_OPS_CIVILITE_GAZ', 'HP_OPS_CRENEAUX', 'HP_OPS_STATUT_ELEC', 'HP_OPS_STATUT_GAZ'};
        Map<String, Map<object,object>> mapConstantes = HP_UTIL_MetadataManager.getCodification(constantes);

        for (Prestation_distributeur__c acc: accs) {
            CMN_OPSinfo opsInfo = ids_OPS.get(acc.Numero_affaire_distributeur__c);
            try{
                updateFields(opsInfo, acc, prestaDistribToUpdate, mapConstantes);
            } catch (Exception e) {
                HP_OpsEventLog__c opsInfoKODetails = HP_EM046_HPOPSEventLog.fillOPSKOLog(acc,opsInfo,e);
                opsKO.add(opsInfoKODetails) ; 
            }
        }
    }

    private  static void traceLog(List<Prestation_distributeur__c> prestaDistribToUpdate ,Database.SaveResult[]  srList,List<HP_OpsEventLog__c> opsKO){
        List<HP_OpsEventLog__c> listOpsTraceLog = new List<HP_OpsEventLog__c>() ;
            
        if(srList != null){ 
            for( integer i = 0 ; i< prestaDistribToUpdate.size(); i++){
                Database.SaveResult sr = srList[i];
                Prestation_distributeur__c presta = prestaDistribToUpdate[i];
                HP_OPSEventLog__c log = HP_EM046_HPOPSEventLog.createHPOpsEventLog(sr, presta);                 
                listOpsTraceLog.add(log) ;
            }
        }

        if(opsKO.size() > 0 ){ 
            listOpsTraceLog.addAll(opsKO);
        }

        HP_EM046_HPOPSEventLog.updateOpsLog(listOpsTraceLog);   
    }

    public static void updateFields(CMN_OPSinfo opsInfo, Prestation_distributeur__c acc, List < Prestation_distributeur__c > prestaDistribToUpdate, Map<String, Map<object,object>> mapConstantes) {     
        
        updateOPSCommonFields(opsInfo, acc, mapConstantes) ;
        
        boolean missingEnergy = String.isBlank(opsInfo.typeEnergie) || String.isBlank(acc.Secteur_activite__c);
        boolean isElec = !missingEnergy && opsInfo.typeEnergie.equals(acc.Secteur_activite__c) && acc.Secteur_activite__c.equals('Elec');
        boolean isGaz = !missingEnergy && opsInfo.typeEnergie.equals(acc.Secteur_activite__c) && acc.Secteur_activite__c.equals('Gaz');
        boolean isNumDernierJalonValid = opsInfo.numDernierJalon != null && ((acc.Numero_dernier_jalon__c !=null && opsInfo.numDernierJalon > acc.Numero_dernier_jalon__c) || acc.Numero_dernier_jalon__c== null);
        
        if (isElec &&  isNumDernierJalonValid) {
            updateOPSElecFields(opsInfo, acc, mapConstantes);
            prestaDistribToUpdate.add(acc);
        }
        else if (isGaz) {
            updateOPSGazFields(opsInfo, acc, mapConstantes) ;
            prestaDistribToUpdate.add(acc);
        }
        else {
            throw new IoException('Cas non traité');  
        }
              
    }

    static void  updateOPSElecFields(CMN_OPSinfo opsInfo , Prestation_distributeur__c acc, Map<String, Map<object,object>> mapConstantes){
        Map<Object, Object> statutElec = mapConstantes.get('HP_OPS_STATUT_ELEC');

        acc.Civilite_interlocuteur_intervention__c = opsInfo.civiliteIntervenant;
        acc.Date_de_prestation__c = String.isBlank(opsInfo.datePrestation) ? null : Date.valueOf(opsInfo.datePrestation.substring(0, 10));
        acc.Numero_dernier_jalon__c = opsInfo.numDernierJalon;
        acc.Statut__c = String.isBlank(opsInfo.statutPrestation) ? null : (String) statutElec.get(opsInfo.statutPrestation);
        acc.Statut_dernier_jalon__c = opsInfo.statutDernierJalon;   
        acc.Date_statut_prestation__c = Date.today();
    }
    
    static void  updateOPSGazFields(CMN_OPSinfo opsInfo , Prestation_distributeur__c acc, Map<String, Map<object,object>> mapConstantes){
        Map<Object, Object> mapCiviliteGaz = mapConstantes.get('HP_OPS_CIVILITE_GAZ');
        Map<Object, Object> statutGaz = mapConstantes.get('HP_OPS_STATUT_GAZ');

        acc.Civilite_interlocuteur_intervention__c =  String.isBlank(opsInfo.civiliteIntervenant) ? null : (String) mapCiviliteGaz.get(String.valueOf(opsInfo.civiliteIntervenant)) == null ? 'AUTRE' : (String) mapCiviliteGaz.get(String.valueOf(opsInfo.civiliteIntervenant));
        acc.Date_de_prestation__c = String.isBlank(opsInfo.datePrestation) ? null : Date.valueOf(opsInfo.datePrestation.substring(0, 10));
        acc.Numero_dernier_jalon__c = opsInfo.numDernierJalon;
        acc.Statut__c =  String.isBlank(opsInfo.statutPrestation) ? null :   (String) statutGaz.get(opsInfo.statutPrestation);
        acc.Statut_dernier_jalon__c = opsInfo.statutDernierJalon;
        acc.Date_statut_prestation__c = Date.today();
    }
    
    static void  updateOPSCommonFields(CMN_OPSinfo opsInfo , Prestation_distributeur__c acc, Map<String, Map<Object, Object>> mapConstantes){
        acc.Creneau__c =  String.isBlank(opsInfo.creneau) ? null :  (String) mapConstantes.get('HP_OPS_CRENEAUX').get(opsInfo.creneau);
        acc.Nom_contact_d_intervention__c = opsInfo.nomIntervenant;
        acc.Prenom_contact_d_intervention__c = opsInfo.prenomIntervenant;
        acc.Telephone_intervention__c = opsInfo.telephoneIntervenant;
    }

    public class IOException extends Exception {	
    }
}