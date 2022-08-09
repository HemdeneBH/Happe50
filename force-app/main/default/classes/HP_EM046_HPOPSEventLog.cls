/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   03-02-2021   Antoine Latour   Initial Version
**/

global class HP_EM046_HPOPSEventLog {
                                       
    /**
    * @description 
    * @author Antoine Latour | 03-02-2021 
    * @param Database.SaveResult sr 
    * @param Prestation_distributeur__c presta 
    * @return HP_HP_OpsEventLog__c 
    **/
    public static HP_OpsEventLog__c createHPOpsEventLog(Database.SaveResult sr, Prestation_distributeur__c presta) {
        HP_OpsEventLog__c opsEvent = new HP_OpsEventLog__c() ;
        opsEvent.HP_PDL_PCE__c = presta.Numero_PDL_PCE__c;
        opsEvent.HP_idAffaire__c = presta.Numero_affaire_distributeur__c;
        opsEvent.HP_Date_de_reception__c = date.today();
        opsEvent.HP_Date_de_prestation__c = presta.Date_de_prestation__c;
        opsEvent.HP_Flux__c = HP_ParseUtils.serialize(presta);
        opsEvent.HP_Statut_prestation__c =  presta.Statut__c ;
        opsEvent.HP_Type_Energie__c  =  String.valueOf(presta.Secteur_activite__c ) ;
            
        // Iterate through each returned result by the method
         
        if (sr.isSuccess()) {
            opsEvent.HP_Statut__c = 'Traitement OK' ;	
        }
        else {
            opsEvent.HP_Statut__c = 'Traitement KO' ;
            for(Database.Error objErr : sr.getErrors()) {
                opsEvent.HP_Flux__c = opsEvent.HP_Flux__c + 'Eror Message : '+objErr.getMessage()+' Fields : '+ objErr.getFields() ;
            }
        }

        return opsEvent;
    }

    /**
    * @description 
    * @author Antoine Latour | 03-02-2021 
    * @param Prestation_distributeur__c ops 
    * @param CMN_OPSinfo opsInfo 
    * @param Exception e 
    * @return HP_HP_OpsEventLog__c 
    **/
    public static HP_OpsEventLog__c fillOPSKOLog(Prestation_distributeur__c ops, CMN_OPSinfo opsInfo, Exception e){
        
        HP_OpsEventLog__c opsInfoKODetails = new HP_OpsEventLog__c();
        opsInfoKODetails.HP_PDL_PCE__c = ops.Numero_PDL_PCE__c ;
        opsInfoKODetails.HP_idAffaire__c = ops.Numero_affaire_distributeur__c ;
        opsInfoKODetails.HP_Date_de_reception__c = date.today() ;
        opsInfoKODetails.HP_Date_de_prestation__c = ops.Date_de_prestation__c ;           
        opsInfoKODetails.HP_Statut_prestation__c =  ops.Statut__c ;
        opsInfoKODetails.HP_Type_Energie__c  =  String.valueOf(ops.Secteur_activite__c ) ;
        opsInfoKODetails.HP_Statut__c = 'Traitement KO' ;
        opsInfoKODetails.HP_Flux__c =' Error Message '+ e.getMessage() + e.getStackTraceString() +
            'Flux recu '+
            ' idAffaire :'+opsInfo.idAffaire+'\n'+
            ' referenceDemandeur :'+opsInfo.referenceDemandeur+'\n'+
            ' statutDernierJalon: '+opsInfo.statutDernierJalon+'\n'+
            ' numDernierJalon: '+opsInfo.numDernierJalon+'\n'+
            ' statutPrestation: '+opsInfo.statutPrestation+'\n'+
            ' datePrestation: '+opsInfo.datePrestation+'\n'+
            ' creneau: '+opsInfo.creneau+'\n'+
            ' civiliteIntervenant: '+opsInfo.civiliteIntervenant+'\n'+
            ' nomIntervenant: '+opsInfo.nomIntervenant+'\n'+
            ' prenomIntervenant : '+opsInfo.prenomIntervenant+'\n'+
            ' telephoneIntervenant : '+opsInfo.telephoneIntervenant+'\n'+
            ' typeEnergie: '+opsInfo.typeEnergie ;    
            
            return opsInfoKODetails;
    } 
   
    /**
    * @description 
    * @author Antoine Latour | 03-02-2021 
    * @param List<HP_OpsEventLog__c> listOpsTraceLog
    **/
    public static void updateOpsLog(List<HP_OpsEventLog__c> listOpsTraceLog){
        Database.SaveResult[]  srList = Database.insert(listOpsTraceLog, true);
    }
}