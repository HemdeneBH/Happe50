/**
* Classe construite  dans le cadre de developpement de l'US  SMIL-1264
* @last modified on  : 05-05-2022
* @last modified by  : Ahmed LAAMIRI
* @see         
*/

global class SM_AP51_X12_SDEM_DataHandler  implements CMN_OPSProcessingInterface {

    static final Map < String, Object > creneaux = new Map < String, String > {
        'jou' => 'Journée',
            'dma' => 'Début de matinée',
            'fma' => 'Fin de matinée',
            'ma' => 'Matin',
            'dap' => 'Début d’après midi',
            'fap' => 'Fin d’après midi',
            'apm' => 'Après midi',
            'fjo' => 'Fin de journée',
            'dso' => 'Début de soirée',
            'mjo' => 'Milieu de soirée',
            'soi' => 'Soir',
            'fso' => 'Fin de soirée'
            };
                
                
                static final Map < String, String > mapCiviliteGaz = new Map < String, String > {
                    '1' => 'MME',
                        '2' => 'MR',
                        '3' => 'MLLE'
                        };
                            
                            
                            
                            static final Map < String, String > statutElec = new Map < String, String > {
                                'ANNUL' => 'Annulé',
                                    'COURS' => 'En cours',
                                    'TERMN' => 'Terminé'
                                    };
                                        
                                        
                                        
                                        static final Map < String, String > statutGaz = new Map < String, String > {
                                            '006' => 'Annulé',
                                                '010' => 'Terminé',
                                                '022' => 'Annulé',
                                                '023' => 'Annulé',
                                                '041' => 'Annulé',
                                                '043' => 'En cours',
                                                '044' => 'En cours',
                                                '045' => 'En cours',
                                                '048' => 'En cours',
                                                '049' => 'En cours',
                                                '050' => 'En cours',
                                                '051' => 'En cours',
                                                '063' => 'En cours',
                                                '070' => 'En cours',
                                                '090' => 'En cours',
                                                '093' => 'En cours',
                                                '098' => 'En cours',
                                                '114' => 'En cours',
                                                '119' => 'En cours',
                                                '120' => 'En cours',
                                                '121' => 'En cours',
                                                '122' => 'En cours',
                                                '114' => 'En cours',
                                                '130' => 'Annulé',
                                                '135' => 'En cours'
                                                };
    
    public void processing(List<CMN_OPSinfo> OPSinfos){
            List < Prestation_distributeur__c > opsToUpdate = new List < Prestation_distributeur__c > ();
            List < OpsEventLog__c > opsKO = new List < OpsEventLog__c > ();
            
            getAndUpdateOpsAndCase(OPSinfos, opsToUpdate,opsKO);
            
            if (!opsToUpdate.isEmpty() || !opsKO.isEmpty()) {
                Database.SaveResult[] srList ;
                if(!opsToUpdate.isEmpty()){
                    srList  = Database.update(opsToUpdate, true);   
                }                                                       
                traceLog(opsToUpdate,srList,opsKO) ;
            }  
            System.enqueueJob(new HP_SM033_PrestationFluxUpdate(opsToUpdate,OPSinfos));  
    }

    public static void getAndUpdateOpsAndCase(List <CMN_OPSinfo> ops, List < Prestation_distributeur__c > opsToUpdate,List < OpsEventLog__c > opsKO) {
        Map < String, CMN_OPSinfo > ids_OPS = new Map < String, CMN_OPSinfo> ();
        //Map < String, CaseWrapper > OPSId_CaseWrapper = new Map < String, CaseWrapper > ();
        for (CMN_OPSinfo opstemp: ops) {
            ids_OPS.put(opstemp.idAffaire, opstemp);
        }
        List < Prestation_distributeur__c > accs = [SELECT Id, Name,RecordTypeId ,Case__c,Situation_de_vente__c, Numero_PDL_PCE__c ,Secteur_activite__c, Numero_affaire_distributeur__c, Telephone_intervention__c, Statut_dernier_jalon__c, Nom_contact_d_intervention__c, Date_statut_prestation__c, Creneau__c, Prenom_contact_d_intervention__c, Civilite_interlocuteur_intervention__c, Numero_dernier_jalon__c, Statut__c, Date_de_prestation__c, Identifiant_ENGIE__c FROM Prestation_distributeur__c WHERE Numero_affaire_distributeur__c IN: ids_OPS.keySet()];
        system.debug('OPS=>' + accs);
        if (accs == null || accs.isEmpty()) {
            system.debug('## no OPS found##');
            // pas d'ops trouvée dans SF 
        }
        for (Prestation_distributeur__c acc: accs) {
            CMN_OPSinfo opsInfo = ids_OPS.get(acc.Numero_affaire_distributeur__c);
            try{
                updateField(opsInfo, acc, opsToUpdate);
            } catch (Exception e) {
                system.debug('Error occured ' + e.getStackTraceString());
                system.debug('Error occured ' );
                OpsEventLog__c opsInfoKODetails = new OpsEventLog__c() ;          
                fillOPSKOLog(opsInfoKODetails,acc,opsInfo,e) ;
                opsKO.add(opsInfoKODetails) ; 
            }
            
        }
        
    }

    private  static void traceLog(List<Prestation_distributeur__c> opsToUpdate ,Database.SaveResult[]  srList,List<OpsEventLog__c> opsKO){
        try{
            List<OpsEventLog__c>   listOpsTraceLog = new List<OpsEventLog__c>() ;
            
            if(srList != null){ 
                for( integer i = 0 ; i< opsToUpdate.size(); i++){
                    Database.SaveResult sr = srList[i];
                    Prestation_distributeur__c origRecord = opsToUpdate[i];
                    system.debug('saveresult'+sr.getId());
                    system.debug('origRecord'+origRecord.Id);
                    String project = 'Smile';
              
                    
                    
                    OpsEventLog__c opsEvent = new OpsEventLog__c() ;
                    opsEvent.PDL_PCE__c = origRecord.Numero_PDL_PCE__c;
                    opsEvent.idAffaire__c = origRecord.Numero_affaire_distributeur__c;
                    opsEvent.Date_de_reception__c = date.today();
                    opsEvent.Date_de_prestation__c = origRecord.Date_de_prestation__c;
                    opsEvent.Flux__c = HP_ParseUtils.serialize(origRecord);
                    opsEvent.Projet__c = project ;
                    opsEvent.Statut_prestation__c =  origRecord.Statut__c ;
                    opsEvent.TypeEnergie__c  =  String.valueOf(origRecord.Secteur_activite__c ) ;
                    
                    // Iterate through each returned result by the method
                    
                    if (sr.isSuccess()) {
                        opsEvent.Statut__c = 'Traitement OK' ;	
                        // This condition will be executed for successful records and will fetch the ids of successful records
                        System.debug('Successfully inserted ' + sr.getId());//Get the invoice id of inserted Account
                    }
                    else {
                        
                        opsEvent.Statut__c = 'Traitement KO' ;
                        // This condition will be executed for failed records
                        for(Database.Error objErr : sr.getErrors()) {
                            opsEvent.Flux__c = opsEvent.Flux__c + 'Eror Message : '+objErr.getMessage()+' Fields : '+ objErr.getFields() ;
                            System.debug(objErr.getStatusCode() + ': ' + objErr.getMessage());
                            
                        }
                    }
                    listOpsTraceLog.add(opsEvent) ;
                }
            }
            // tester s il ya e des KO OPS avant l'insertion dans la base pour des raisons date malformé etc ...
            if(opsKO.size() > 0 ){ 
                listOpsTraceLog.addAll(opsKO);
            }
            system.debug('total size'+listOpsTraceLog.size());
            String StringJason = JSON.serializePretty(listOpsTraceLog) ;
            updateOpsLog(StringJason);
            
        }catch(Exception e){
            System.debug('erreur catché '+e.getMessage()) ; 
            System.debug('erreur catché '+e.getStackTraceString()) ; 
        }
        
    }

    private static void fillOPSKOLog(OpsEventLog__c opsInfoKODetails , Prestation_distributeur__c ops, CMN_OPSinfo opsInfo, Exception e){
        
        opsInfoKODetails.PDL_PCE__c = ops.Numero_PDL_PCE__c ;
        opsInfoKODetails.idAffaire__c = ops.Numero_affaire_distributeur__c ;
        opsInfoKODetails.Date_de_reception__c = date.today() ;
        opsInfoKODetails.Date_de_prestation__c = ops.Date_de_prestation__c ;
        String project = 'Smile';
            
        opsInfoKODetails.Projet__c = project ;
        opsInfoKODetails.Statut_prestation__c =  ops.Statut__c ;
        opsInfoKODetails.TypeEnergie__c  =  String.valueOf(ops.Secteur_activite__c ) ;
        opsInfoKODetails.Statut__c = 'Traitement KO' ;
        opsInfoKODetails.Flux__c =' Error Message '+ e.getMessage() + e.getStackTraceString() +
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
        system.debug('error dans une OPS '+opsInfoKODetails.Flux__c);
        
    } 

    public static boolean updateField(CMN_OPSinfo opsInfo, Prestation_distributeur__c acc, List < Prestation_distributeur__c > opsToUpdate) {
        
        
        
        // common field Gaz and Elec
        updateOPSCommonFields(opsInfo,acc) ;
        
        
        if ( !String.isBlank(opsInfo.typeEnergie) &&   !String.isBlank(acc.Secteur_activite__c)  &&  opsInfo.typeEnergie.equals(acc.Secteur_activite__c) && acc.Secteur_activite__c.equals('Elec') && 
            opsInfo.numDernierJalon != null &&  ((acc.Numero_dernier_jalon__c !=null &&    opsInfo.numDernierJalon > acc.Numero_dernier_jalon__c) || acc.Numero_dernier_jalon__c== null  )  ) {
                
                
                updateOPSElecFields(opsInfo,acc);
                
                opsToUpdate.add(acc);
                // false ca veut dire il n'ya pas eu de problème . 
                return false;
            }
        // gaz
        else if (  !String.isBlank(opsInfo.typeEnergie) &&   !String.isBlank(acc.Secteur_activite__c) &&  opsInfo.typeEnergie.equals(acc.Secteur_activite__c) && acc.Secteur_activite__c.equals('Gaz') ) {
            
            
            updateOPSGazFields(opsInfo,acc) ;
            
            opsToUpdate.add(acc);
            // false ca veut dire il n'ya pas eu de problème . 
            return false;
        }
        
        throw new IOException('Cas non traité' );
        
    }

//* @last modified on  : 05-05-2022
//* @last modified by  : Ahmed LAAMIRI
//* @Description : No need to update the date if date de prestation IsBlank        
    static void  updateOPSElecFields(CMN_OPSinfo opsInfo , Prestation_distributeur__c acc){
        acc.Civilite_interlocuteur_intervention__c = opsInfo.civiliteIntervenant;
        if (String.isNotBlank(opsInfo.datePrestation)){acc.Date_de_prestation__c =  Date.valueOf(opsInfo.datePrestation.substring(0, 10));}     
        //acc.Date_de_prestation__c = String.isBlank(opsInfo.datePrestation) ? null : Date.valueOf(opsInfo.datePrestation.substring(0, 10));
        acc.Numero_dernier_jalon__c = opsInfo.numDernierJalon;
        acc.Statut__c = String.isBlank(opsInfo.statutPrestation) ? null :  statutElec.get(opsInfo.statutPrestation);
        acc.Statut_dernier_jalon__c = opsInfo.statutDernierJalon;
        
    }
    
//* @last modified on  : 05-05-2022
//* @last modified by  : Ahmed LAAMIRI
//* @Description : No need to update the date if date de prestation IsBlank    
    static void  updateOPSGazFields(CMN_OPSinfo opsInfo , Prestation_distributeur__c acc){
        acc.Civilite_interlocuteur_intervention__c =  String.isBlank(opsInfo.civiliteIntervenant) ? null :  mapCiviliteGaz.get(String.valueOf(opsInfo.civiliteIntervenant)) == null ? 'AUTRE' : mapCiviliteGaz.get(String.valueOf(opsInfo.civiliteIntervenant));
        if (String.isNotBlank(opsInfo.datePrestation)){acc.Date_de_prestation__c =  Date.valueOf(opsInfo.datePrestation.substring(0, 10));}     
        //acc.Date_de_prestation__c = String.isBlank(opsInfo.datePrestation) ? null : Date.valueOf(opsInfo.datePrestation.substring(0, 10));
        acc.Numero_dernier_jalon__c = opsInfo.numDernierJalon;
        acc.Statut__c =  String.isBlank(opsInfo.statutPrestation) ? null :   statutGaz.get(opsInfo.statutPrestation);
        acc.Date_statut_prestation__c = String.isBlank(opsInfo.datePrestation) ? null :   Date.valueOf(opsInfo.datePrestation.substring(0, 10));
        acc.Statut_dernier_jalon__c = opsInfo.statutDernierJalon;
    }
    
    static void  updateOPSCommonFields(CMN_OPSinfo
     opsInfo , Prestation_distributeur__c acc){
        
        acc.Creneau__c =  String.isBlank(opsInfo.creneau) ? null :  (String) creneaux.get(opsInfo.creneau);
        acc.Nom_contact_d_intervention__c = opsInfo.nomIntervenant;
        acc.Prenom_contact_d_intervention__c = opsInfo.prenomIntervenant;
        acc.Telephone_intervention__c = opsInfo.telephoneIntervenant;
        
        
    }
    
    @future
    public static void updateOpsLog(String StringJson){
        List<OpsEventLog__c> listOpsTraceLog = ( List<OpsEventLog__c> )  SYSTEM.JSON.deserializeStrict(StringJson,List<OpsEventLog__c>.class);
        system.debug('listOPS'+listOpsTraceLog.size());
        Database.SaveResult[]  srList = Database.insert(listOpsTraceLog, true);
        for( integer i = 0 ; i< listOpsTraceLog.size(); i++){
            if (srList[i].isSuccess()) {             
                System.debug('Successfully inserted OPS event LOG ' + srList[i].getId());
            }
        }
    }

    public class IOException extends Exception {	
    }
}