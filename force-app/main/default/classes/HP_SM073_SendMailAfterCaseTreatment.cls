/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 02-23-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
public with sharing class HP_SM073_SendMailAfterCaseTreatment {
    
    @InvocableMethod
    public static void verifyConditionsAndSendMail(final List<Id> caseIds) {
        System.debug('HP_SM073_SendMailAfterCaseTreatment || verifyConditionsAndSendMail Function START.');
        System.debug('Param @caseIds: '+caseIds);
        List<Case>  myCaseList = HP_EM010_Case.loadCase(caseIds[0]);

        String selfcareId = myCaseList[0].HP_Souscription__r.HP_Souscription_Digital_Id__c;
        String etatDuCase = myCaseList[0].Etat_du_Case__c;
        
        HP_Souscription__c souscription = HP_EM005_Souscription.loadSouscription(selfcareId);

        System.debug('************************************************************************');
        System.debug('souscription.HP_Type_Energie__c: '+souscription.HP_Type_Energie__c);
        System.debug('souscription.OK_Electricite__c: '+souscription.OK_Electricite__c);
        System.debug('souscription.OK_Gaz__c: '+souscription.OK_Gaz__c);
        System.debug('************************************************************************');


        if (souscription.HP_Type_Energie__c == 'COMBINED_GAS_AND_ELECTRICITY' && etatDuCase == 'KO définitif' && (souscription.OK_Electricite__c == true || souscription.OK_Gaz__c == true)) {
            execute(souscription.id,selfcareId);
        } else if (souscription.HP_Type_Energie__c == 'COMBINED_GAS_AND_ELECTRICITY'&& etatDuCase == 'Contrat validé' && (souscription.OK_Electricite__c == true && souscription.OK_Gaz__c == true)) {
            execute(souscription.id,selfcareId);
        }

        System.debug('HP_SM073_SendMailAfterCaseTreatment || verifyConditionsAndSendMail Function END.');
    }

    @future(callout = true)
    public static void execute(Id souscriptionId, String selfcareId) {
        List<HP_Contrat__c> contractList = HP_EM023_Contrat.loadContrat(selfcareId);
        HP_Souscription__c souscription = HP_EM005_Souscription.loadSouscription(selfcareId);
        String gasContractXdataId = '';
        String electricityContractXdataId = '';
        
        for(HP_Contrat__c acontrat : contractList) {
			if(acontrat.HP_Type_de_Compteur__c == 'GAS') {
				gasContractXdataId = String.valueOf(acontrat.HP_Contrat_XdataId__c);
			} else {
				electricityContractXdataId = String.valueOf(acontrat.HP_Contrat_XdataId__c);
			}
		}

        HP_SM063_WelcomeEmailSender.sendWelcomeEmail(souscriptionId, electricityContractXdataId, gasContractXdataId, souscription.OK_Electricite__c, souscription.OK_Gaz__c);
        System.debug('HP_SM073_SendMailAfterCaseTreatment.execute() || sendWelcomeEmail() Function CALLED.');
    }

}