/**
 * @author            : Ali AJELLAL
 * @group             : 

 * @last modified on  : 01-04-2022

 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

public with sharing class HP_HDL003_Souscription {
	public static void  handleAfterUpdate() {




        


        if(Trigger.isAfter && Trigger.isUpdate){

		    List<Id> souscriptionIdList = new List<Id>();
            List<Id> souscriptionIdListSave3 = new List<Id>();
            List<HP_SendMailContratualizationService.ObjectToSend> senderList = new  List<HP_SendMailContratualizationService.ObjectToSend> ();

            for (Id id : Trigger.newMap.keySet()) { 
                HP_Souscription__c oldSouscription = (HP_Souscription__c)Trigger.oldMap.get(id);
                HP_Souscription__c newSouscription = (HP_Souscription__c)Trigger.newMap.get(id);

                if(newSouscription.HP_Statut__c == 'CANCEL'  && (oldSouscription.HP_Statut__c == 'SAVE_2_CONFIRMED' || oldSouscription.HP_Statut__c == 'SAVE_2') &&
                newSouscription.HP_Tech_Is_Apex_Processing__c == false ) {
                    souscriptionIdList.add(newSouscription.Id);
                }

                if(newSouscription.HP_Statut__c == 'CANCEL'  && oldSouscription.HP_Statut__c == 'SAVE_3' && newSouscription.HP_Tech_Is_Apex_Processing__c == false ) {
                    souscriptionIdListSave3.add(newSouscription.Id);
                }
            }











            System.debug('******* souscriptionIdList ids:***'+  souscriptionIdList);
            System.debug('******* souscriptionIdListSave3 ids ********'+ souscriptionIdListSave3);
            System.debug('**************************************************************');





            if(souscriptionIdList.size() > 0) {
                List<HP_Contrat__c> contratList = [select Id, HP_Proposition_Commerciale_XdataId__c,  HP_Type_de_Compteur__c, HP_Souscription__r.HP_Type_Energie__c, HP_Souscription__r.HP_Contact__r.Email, HP_Souscription__r.HP_Contact__r.Id_Tiers__c, HP_Souscription__r.HP_Contact__r.Lastname, HP_Souscription__r.HP_Contact__r.Salutation, HP_Souscription__r.HP_Contact__r.Firstname, HP_Souscription__r.HP_Plan_de_Prix_electrique__c,HP_Souscription__r.HP_EnvoyerNotificationClient__c from HP_Contrat__c
                                where HP_Souscription__c in :souscriptionIdList and HP_Proposition_Commerciale_XdataId__c != null];
                List<Integer> commercialPropositionIdList = new List<Integer>();
                System.debug('******* contratList size  ********'+ contratList.size());
                System.debug('**************************************************************');
                System.debug('******* contratList size  ********'+ contratList.size());
                System.debug('**************************************************************');



                for(HP_Contrat__c acontrat : contratList) {
                    commercialPropositionIdList.add(Integer.valueOf(acontrat.HP_Proposition_Commerciale_XdataId__c));
                    Boolean sendEmailToCilent = acontrat.HP_Souscription__r.HP_EnvoyerNotificationClient__c;






                    if(sendEmailToCilent && senderList.size() == 0){

                        senderList.add(
                            new HP_SendMailContratualizationService.ObjectToSend(
                                'Annulation de votre demande',
                                acontrat.HP_Souscription__r.HP_Contact__r.Email,
                                Integer.valueOf(acontrat.HP_Souscription__r.HP_Contact__r.Id_Tiers__c),
                                acontrat.HP_Souscription__r.HP_Contact__r.Lastname,
                                acontrat.HP_Souscription__r.HP_Contact__r.Salutation,
                                acontrat.HP_Souscription__r.HP_Contact__r.Firstname,
                                HP_SendMailContratualizationService.handlePricingPlan(acontrat)
                                )
                            );
                    }
                   
                }
                System.debug('******* commercialPropositionIdList********'+ commercialPropositionIdList);
                if (commercialPropositionIdList.size() > 0) {
                   // HP_APIHourCommercialPropositionService.updateCommmercialPropositionAsync(commercialPropositionIdList, 'E0002');
                   HP_APIHourCommercialPropositionService.updateCommmercialPropositionAsync(commercialPropositionIdList, 'AnnulationPropositionCommerciale', 'H0104');
                }
            }

            if(souscriptionIdListSave3.size() > 0) {
                List<HP_Contrat__c> contratListSave3 = [select Id, HP_Contrat_XdataId__c, HP_Type_de_Compteur__c, HP_Souscription__r.HP_Type_Energie__c, HP_Souscription__r.HP_Contact__r.Email, HP_Souscription__r.HP_Contact__r.Id_Tiers__c, HP_Souscription__r.HP_Contact__r.Lastname, HP_Souscription__r.HP_Contact__r.Salutation, HP_Souscription__r.HP_Contact__r.Firstname, HP_Souscription__r.HP_Plan_de_Prix_electrique__c,HP_Souscription__r.HP_EnvoyerNotificationClient__c from HP_Contrat__c
                                    where HP_Souscription__c in :souscriptionIdListSave3 and HP_Contrat_XdataId__c != null];
                System.debug('*******contratListSave3: ********'+ contratListSave3);

                for(HP_Contrat__c acontrat : contratListSave3) {
                    Boolean sendEmailToCilent = acontrat.HP_Souscription__r.HP_EnvoyerNotificationClient__c;






                    if(sendEmailToCilent && senderList.size() == 0){
                        senderList.add(
                            new HP_SendMailContratualizationService.ObjectToSend(
                                'Annulation de votre demande',
                                acontrat.HP_Souscription__r.HP_Contact__r.Email,
                                Integer.valueOf(acontrat.HP_Souscription__r.HP_Contact__r.Id_Tiers__c),
                                acontrat.HP_Souscription__r.HP_Contact__r.Lastname,
                                acontrat.HP_Souscription__r.HP_Contact__r.Salutation,
                                acontrat.HP_Souscription__r.HP_Contact__r.Firstname,
                                HP_SendMailContratualizationService.handlePricingPlan(acontrat)
                                )
                            );
                    }
                    String todayFomat = System.now().format('yyyy-MM-dd');
                    HP_APIHourContractService.cancelContractAsync(String.valueOf(acontrat.HP_Contrat_XdataId__c),
                                            HP_Constantes.CONTRACT_XADATA_STATUS_CANCELED, 'INACT', todayFomat);
                    HP_AgilabCommercialPropositionService.updateContractAsync(Integer.valueOf(acontrat.HP_Contrat_XdataId__c), HP_Constantes.CONTRACT_AGILAB_STATUS_CANCELED, null);
                }
            }

            if(senderList.size() > 0) {
                System.debug('*******senderList size********'+ senderList.size());
                HP_SendMailContratualizationService.sendMailViaCabestan(senderList);
            }
        }
    }
    
    public static void  handleBeforeUpdateInsert() {

        List<Id> utilisateurIds = new List<id>();





        List <Id> contractantIds = new List<id>();

        for (HP_Souscription__c souscription : (List<HP_Souscription__c>) Trigger.new){
                utilisateurIds.add(souscription.HP_DigitalLogin__c);
                contractantIds.add(souscription.HP_Contact__c);
            }




        Map<Id, HP_PortailUtilisateur__c> utilisateurMap = new Map<Id, HP_PortailUtilisateur__c>([SELECT id, Prestataire__c,Nom__c  FROM HP_PortailUtilisateur__c WHERE id IN : utilisateurIds]);
        Map<Id, Contact> contactMap = new Map<Id, Contact>([ SELECT id, name from contact where id IN : contractantIds ]);

        System.debug('*******contactMap********'+contactMap);
        System.debug('*******utilisateurMap********'+utilisateurMap);


        for (HP_Souscription__c souscription : (List<HP_Souscription__c>) Trigger.new){






               souscription.HP_Prestataire__c = utilisateurMap.get(souscription.HP_DigitalLogin__c)?.Prestataire__c;
               souscription.HP_Nom_Contractant__c = contactMap.get(souscription.HP_Contact__c)?.Name;
            }
        
    }

}